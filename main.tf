locals {
  basic_auth_creds = try(base64encode("${var.basic_auth_username}:${var.basic_auth_password}"), null)
}

resource "aws_amplify_app" "poc-amplify" {
  name       = "poc-amplify"
  repository = "https://github.com/pablohenriquemg/amplify-poc"
  enable_branch_auto_build = true
  # GitHub personal access token
  access_token = var.gh_access_token
  enable_basic_auth      = var.enable_basic_auth_globally
  basic_auth_credentials = local.basic_auth_creds

  # The default build_spec added by the Amplify Console for React.
  build_spec = <<-EOT
    version: 0.1
    frontend:
      phases:
        preBuild:
          commands:
            - yarn install
        build:
          commands:
            - yarn run build
      artifacts:
        baseDirectory: build
        files:
          - '**/*'
      cache:
        paths:
          - node_modules/**/*
  EOT

  # The default rewrites and redirects added by the Amplify Console.
  custom_rule {
    source = "/<*>"
    status = "404"
    target = "/index.html"
  }

  environment_variables = {
    ENV = "test"
  }
}

resource "aws_amplify_branch" "main" {
  app_id      = aws_amplify_app.poc-amplify.id
  branch_name = "main"

  framework = "React"
  stage     = "PRODUCTION"

  environment_variables = {
    REACT_APP_API_SERVER = "https://main.d1b9epjr6x4lh3.amplifyapp.com"
  }
}