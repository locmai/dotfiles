locals {
  connectors = length(var.connectors) > 0 ? tuple(var.connectors) : [
      {
        type = "ldap"
        id   = "connector1"
        name = "LDAP Connector One"
        config = {
          host              = "host1.example.com"
          rootCAData        = "rootCAData1"
          insecureNoSSL     = false
          insecureSkipVerify = true
          bindDN            = "bindDN1"
          bindPW            = "bindPW1"
          # usernamePrompt    = "Enter your username"
          userSearch = {
            baseDN    = "ou=users,dc=example,dc=com"
            filter    = "(objectClass=person)"
            username  = "uid"
            idAttr    = "uidNumber"
            emailAttr = "mail"
            nameAttr  = "cn"
          }
          groupSearch = {
            baseDN   = "ou=groups,dc=example,dc=com"
            filter   = "(objectClass=groupOfNames)"
            nameAttr = "cn"
            userAttr = "member"
          }
          usersDN = "ou=users,dc=example,dc=com"
        }
      }
  ]
}

module "connectors" {
  source = "../dex-connectors"
  connectors = var.connectors
}
