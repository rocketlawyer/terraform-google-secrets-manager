output "secret_value" {
  value = var.generate_random_password ? random_password.password[1].result : var.secret_data
}

output "secret_name" {
  value = var.secret_name
}
