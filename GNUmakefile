.PHONY all: ui.cert
	nomad var put -force nomad/jobs/nomad-nginx-ui/ui/nginx cert=@ui.cert key=@ui.key
	nomad job run nomad-nginx-ui.nomad.hcl
	@echo "\n==> Remember to add example.test to /etc/hosts for the IP address of the allocation!"
	@echo "    Then browse to https://example.test/ to login."

ui.cert:
	mkcert -install
	mkcert -cert-file ui.cert -key-file ui.key example.test localhost 127.0.0.1 ::1
