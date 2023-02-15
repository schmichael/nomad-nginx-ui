# nomad-nginx-ui

nomad-nginx-ui contains a [Nomad](https://nomadproject.io)
[jobspec](https://developer.hashicorp.com/nomad/docs/job-specification) for
accessing [Nomad's
UI](https://developer.hashicorp.com/nomad/tutorials/web-ui/web-ui-access) when
Nomad has [ACLs](https://developer.hashicorp.com/nomad/docs/configuration/acl)
and [mTLS](https://developer.hashicorp.com/nomad/docs/configuration/tls)
enabled.

The goal of this effort is to use all of the [fancy new features in Nomad
1.5+](https://www.hashicorp.com/blog/nomad-1-5-adds-single-sign-on-and-dynamic-node-metadata)
to evolve the [pre-1.5 tutortial on accessing Nomad's UI when ACLs and mTLS
are
enabled](https://developer.hashicorp.com/nomad/tutorials/manage-clusters/reverse-proxy-ui).

The complication in this approach vs pre-1.5 is that the [Task
API](https://developer.hashicorp.com/nomad/api-docs/task-api) always requires
authentication. The UI relies on the Agent API's unauthenticated behavior to
enable access to the UI and sign in form.

This experiment does 2 things to workaround these limitations:

1. Use the nginx proxy's workload identity to authenticate requests to /ui/ so
	 the UI's assets may be served prior to user authnetication.
2. Redirect / to /ui/settings/tokens to skip an error message and ease the
	 user sign in flow.

## Implementation

The goal of Nomad UI proxies is to use browser-friendly DNS and TLS for
accessing the Nomad UI.

This experiment provides browser-friendliness by...

1. ...using [mkcert](https://github.com/FiloSottile/mkcert) to generate
	 certificates and store the CA where browsers will find them.
2. ...leaving DNS up to you. The easiest is to add an `/etc/hosts` entry for
	 `example.test` and the IP the alloc is scheduled on.

Generating certs with Vault and using something like Consul or CoreDNS for DNS
are more realistic.

## Using

1. Install [mkcert](https://mkcert.dev/)
2. Run `make` to generate and install certificates.
3. Add `example.test` to `/etc/hosts` for the IP Nomad exposes nginx on.
