job "nomad-nginx-ui" {

  group "ui" {
    network {
      port "https" {
        static = 443
        to = 4646
      }
      port "http" {
        static = 80
        to = 4645
      }
    }

    service {
      provider = "nomad"
      port     = "https"
      name     = "nomad-https"
    }

    service {
      provider = "nomad"
      port     = "http"
      name     = "nomad-http"
    }

    task "nginx" {
      driver = "docker"

      config {
        image          = "nginx:1.23"
        command        = "nginx"
        args           = ["-c", "/local/nginx.conf"]
        ports          = ["http", "https"]
        auth_soft_fail = true
      }

      identity {
        env = true
      }

      resources {
        cpu    = 200
        memory = 200
      }

      template {
        destination = "secrets/ui.crt"
        data = <<EOF
{{- with nomadVar "nomad/jobs/nomad-nginx-ui/ui/nginx"}}{{.cert}}{{ end -}}
EOF
      }

      template {
        destination = "secrets/ui.key"
        data = <<EOF
{{- with nomadVar "nomad/jobs/nomad-nginx-ui/ui/nginx"}}{{.key}}{{ end -}}
EOF
      }

      template {
        destination = "local/nginx.conf"
        data        = file("nginx.conf.template")
      }
    }
  }
}
