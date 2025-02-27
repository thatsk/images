terraform {
  required_providers {
    apko = { source = "chainguard-dev/apko" }
  }
}

variable "target_repository" {
  description = "The docker repo into which the image and attestations should be published."
}

module "dev" { source = "../../tflib/dev-subvariant" }

module "tagger" {
  source = "../../tflib/tagger"

  depends_on = [
    module.test-three-two,
  ]

  tags = merge(
    { for t in toset(concat(["latest"], module.version-tags-3_2.tag_list)) : t => module.three-two.image_ref },
    { for t in toset(concat(["latest"], module.version-tags-3_2.tag_list)) : "${t}-dev" => module.three-two-dev.image_ref },
  )
}
