locals {
  label_map = merge({ "created_by" = "terraform" }, var.labels)
}

resource "google_secret_manager_secret" "secret" {
  secret_id = var.secret_name
  replication {
    automatic = var.replication
  }

  labels  = local.label_map
  project = var.gcp_project
}

resource "google_secret_manager_secret_version" "secret-version" {
  secret      = google_secret_manager_secret.secret.id
  secret_data = var.generate_random_password ? random_password.password[1].result : var.secret_data
}

resource "random_password" "password" {
  count            = var.generate_random_password ? 1 : 0
  length           = var.random_password_length
  special          = true
  override_special = "_%@"
}

resource "google_secret_manager_secret_iam_member" "gsa_accessor" {
  count     = length(var.gsa_list)
  secret_id = google_secret_manager_secret.secret.id
  role      = "roles/secretmanager.secretAccessor"

  member  = format("serviceAccount:%s", var.gsa_list[count.index])
  project = var.gcp_project

  lifecycle {
    ignore_changes = [secret_id]
  }
}

resource "google_secret_manager_secret_iam_member" "group_accessor" {
  count     = length(var.group_list)
  secret_id = google_secret_manager_secret.secret.id
  role      = "roles/secretmanager.secretAccessor"

  member  = format("group:%s", var.group_list[count.index])
  project = var.gcp_project

  lifecycle {
    ignore_changes = [secret_id]
  }
}
