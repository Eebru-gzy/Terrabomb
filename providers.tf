terraform {
  cloud {
    organization = "Eebru"

    workspaces {
      name = "test-workspace"
    }
  }
}

provider "aws" {}