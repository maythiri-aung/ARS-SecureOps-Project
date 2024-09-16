resource "hcp_hvn" "vault_hvn" {
  hvn_id         = "ars_hvn"
  cloud_provider = "aws"
  region         = "ap-southeast-1"
  cidr_block     = "172.25.16.0/20"
}

resource "hcp_vault_cluster" "vault_cluster" {
  cluster_id = "ars_vault-cluster"
  hvn_id     = hcp_hvn.vault_hvn.hvn_id
  tier       = "starter_small"
  public_endpoint = true #to access cluster from public
  
}