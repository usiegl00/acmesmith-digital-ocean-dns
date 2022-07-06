# acmesmith-digital-ocean-dns

This gem is a plugin for [Acmesmith](https://github.com/sorah/acmesmith) and implements an automated `dns-01` challenge responder using DigitalOcean DNS.

With this plugin and Acmesmith, you can automate to authorize your domain hosted on [Digital Ocean DNS](https://docs.digitalocean.com/products/networking/dns/) and request TLS certificates for the domains against [Let's Encrypt](https://letsencrypt.org/) and other CAs supporting the ACME protocol.

## Usage
### Prerequisites
- You need to have control of your domain name to change its authoritative nameservers.
- You need to have service account of DigitalOcean to operate DigitalOcean DNS via API.

### Preparation
- Ask your DNSaaS provider to host a zone for your domain name. They will tell you the DNS content servers that host the zone.
- Ask your domain registrar to set the authoritative nameservers of your domain to the content servers provided by the DNSaaS.

### Installation
Install `acmesith-digital-ocean-dns` gem along with `acmesmith`. You can just do `gem install acmesith-digital-ocean-dns` or use Bundler if you want.

### Configuration
Use `digital_ocean_dns` challenge responder in your `acmesmith.yml`. General instructions about `acmesmith.yml` is available in the manual of Acmesmith.

Write your `digitalocean_token` in `acmesmith.yml`, or if you don't want to write them down into the file, export these values as the corresponding environment variables `OS_DIGITALOCEAN_TOKEN`.

```yaml
directory: https://acme-v02.api.letsencrypt.org/directory

storage:
  type: filesystem
  path: /path/to/key/storage

challenge_responders:
  - digital_ocean_dns:
      ttl: 5  # (optional) long TTL hinders re-authorization, but a DNSaaS provider may restrict short TTL
```

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
This gem is based on the [Google Cloud DNS Acmesmith plugin](https://github.com/nagachika/acmesmith-google-cloud-dns).
