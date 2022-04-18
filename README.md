# development-backup

This repository is composed of some ansible playbooks and terraform to boostrap and setup a backup promox server.

## Preparations

When running this the first time to setup a new machine, there are some things to prepare manually.

### Zerotier Member ID

Generate a new private/public keypair as zerotier identity.

```bash
zerotier-idtool generate identity.secret identity.public
```

**Note** Save this somewhere secure, as is would allow an attacker to impersonate this machine.

### Setup SSH Access

```bash
# get keys from vault with `./bin/vault.sh`
ssh-copy-id -i .ssh/<key-name> root@<host>
```

## Bootstrap

```bash
make boostrap
```
