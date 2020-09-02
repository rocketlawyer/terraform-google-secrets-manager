resource "google_secret_manager_secret" "secret" {
  provider  = google-beta
  secret_id = var.secret_name
  replication {
    automatic = var.replication
  }
  project = var.gcp_project
}

resource "google_secret_manager_secret_version" "secret-version" {
  provider    = google-beta
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
  provider  = google-beta
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
  provider  = google-beta
  count     = length(var.group_list)
  secret_id = google_secret_manager_secret.secret.id
  role      = "roles/secretmanager.secretAccessor"

  member  = format("group:%s", var.group_list[count.index])
  project = var.gcp_project

  lifecycle {
    ignore_changes = [secret_id]
  }
}
