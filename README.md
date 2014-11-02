Prerequisites
-------------
- Git
- Vagrant
- Virtualbox


Getting Started
---------------

clone this repository and
```
vagrant up
```


Setup SSH config
----------------

Create a new key pair

```
ssh-keygen -t rsa -f ~/.ssh/id_dokku -N ""
```

Register the key with sshcommand
```
cat ~/.ssh/id_dokku.pub | vagrant ssh -c "sudo sshcommand acl-add dokku progrium"
```

Create an ssh config file
```
vi ~/.ssh/config
```

Add the following content :

```
Host dokku_local
HostName 10.0.0.2
IdentityFile ~/.ssh/id_dokku
PreferredAuthentications publickey
RequestTTY yes
User dokku
```

At this point you should be able to exec dokku commands over ssh, e.g. :

```
ssh dokku_local help
```

This should print the available Dokku commands

Deploy
------

Clone a git repo and cd into the dir :
```
git clone https://github.com/heroku/node-js-getting-started.git
cd node-js-getting-started
```

Add a git remote to Dokku using the ssh alias :
```
git remote add progrium dokku_local:node-js-getting-started
```

Create the application definition
```
ssh dokku_local create node-js-getting-started
```

Set environment variables
```
ssh dokku_local config:set node-js-getting-started FOO=BAR
...
```

Deploy
```
git push progrium master
```
