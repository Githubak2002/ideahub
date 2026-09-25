# -----------------------------------------------------------------------------
# Common locals
# -----------------------------------------------------------------------------

locals {
  name_prefix = "${var.project}-${var.environment}"

  common_tags = {
    environment = var.environment
    project     = var.project
    owner       = var.owner
    managed-by  = "terraform"
  }
}
