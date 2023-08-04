provider "github" {
  token        = var.github_token
  organization = var.github_organization
}

resource "github_repository" "repo" {
  name        = var.github_repository_name
  description = "Your repository description here."
  private     = false
  visibility  = "public"
}

resource "github_branch" "develop" {
  repository = github_repository.repo.name
  branch     = "develop"
}

resource "github_repository_collaborator" "softservedata" {
  repository = github_repository.repo.name
  username   = "softservedata"
  permission = "push"
}

resource "github_branch_protection" "main" {
  repository = github_repository.repo.name
  branch     = "main"

  enforce_admins           = true
  required_pull_request_reviews {
    dismiss_stale_reviews   = true
    dismissal_restrictions {
      users  = ["softservedata"]
    }
    require_code_owner_reviews = true
  }
}

resource "github_branch_protection" "develop" {
  repository = github_repository.repo.name
  branch     = "develop"

  required_pull_request_reviews {
    dismiss_stale_reviews   = true
    require_code_owner_reviews = false
    required_approving_review_count = 2
  }
}
