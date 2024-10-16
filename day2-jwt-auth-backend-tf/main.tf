resource "vault_jwt_auth_backend" "jwt_auth" {
    description         = "Demonstration of the Terraform JWT auth backend"
    path                = "jwt"
    oidc_discovery_url  = "https://app.terraform.io"
    bound_issuer        = "https://app.terraform.io"
}
resource "vault_policy" "admin_policy" {
  name = "admin-policy"

  policy = <<EOT
path "auth/*" {
  capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}

# Create, update, and delete auth methods
path "sys/auth/*" {
  capabilities = ["create", "update", "delete", "sudo"]
}

# List auth methods
path "sys/auth" {
  capabilities = ["read"]
}

# Enable and manage the key/value secrets engine at `secret/` path
# List, create, update, and delete key/value secrets
path "secret/*" {
  capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}

# Manage secrets engines
path "sys/mounts/*" {
  capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}

# List existing secrets engines.
path "sys/mounts" {
  capabilities = ["read"]
}

path "ars-aws/" {
  capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}

path "ars-aws/*" {
  capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}

path "sys/policy/*" {
  capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}

path "sys/policy/" {
  capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}

path "example/*" {
  capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}

EOT
}



resource "vault_jwt_auth_backend_role" "jwt_auth_role" {
  backend        = vault_jwt_auth_backend.jwt_auth.path
  role_name      = "admin-role"
  token_policies = [vault_policy.admin_policy.name]

  bound_audiences   = ["vault.workload.identity"]
  bound_claims_type = "glob"
  bound_claims = {
    sub = "organization:HelloCloud-ARS:project:SecureOpsProject:workspace:*:run_phase:*"
  }
  user_claim = "terraform_full_workspace"
  role_type  = "jwt"
  token_ttl  = 1200
}