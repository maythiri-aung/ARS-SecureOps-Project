resource "hcp_hvn" "vault_hvn" {
  hvn_id         = "ars-vault-hvn"  #must be between 3 and 36 characters in length and contains only letters,numbers or hyphens
  cloud_provider = "aws"
  region         = "ap-southeast-1"
  cidr_block     = "172.25.16.0/20"
}

resource "hcp_vault_cluster" "vault_cluster" {
  cluster_id = "ars-vault-cluster"
  hvn_id     = hcp_hvn.vault_hvn.hvn_id
  tier       = "starter_small"
  public_endpoint = true #to access cluster from public
  
}