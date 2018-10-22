# PostgreSQL Vagrant

The purpose of this project is to create a quick and easy VM that supports Pseudo-Distributed Hadoop environment for development

## Requirements
Before creating your VM you need the following tools. Download and install the latest versions of 
- [VirtualBox](https://www.virtualbox.org/)
- [Vagrant](https://www.vagrantup.com/)

## Vagrant Setup
Once the required tools and software have been successfully installed, the next step would be to setup Vagrant to create and manage the VM. The virtual vagrant box that is currently supported is centos7.

On the command line download Vagrant's centos7 box:

```
$ vagrant box add centos/7
```

For a complete list of boxes that Vagrant supports please visit: https://app.vagrantup.com/boxes/search

Running the following command will list the boxes that have have been download

```
$ vagrant box list
```

Now install Vagrant's VirtualBox Guest Additions plutgin so that Vagrant can work with VirtualBox properly

```
$ vagrant plugin install vagrant-vbguest
```

## Edit local hosts file
To be able to open Hadoop's dashboard on your local browser add the following to your hosts file ```/etc/hosts```

```
127.0.0.1   vagrant-hadoop-centos7
```


## VM Setup

After downloading this repository, navigate to ```vagrant-setup-centos7``` directory and run

```
$ vagrant up
```

This will read the Vagrantfile and use the puppet scripts to provision and get the VM ready for Hadoop. NOTE: It may take several minutes to get the VM ready.

Once the VM has been finished being provisioned, run this command to enter the VM

```
$ vagrant ssh
```

By default this command will place you in ```/home/vagrant/``` home directory.


## Additional PostgreSQL Configuration

Open the following ```/var/lib/pgsql/11/data/postgresql.conf``` and uncomment and set the following fields:

```
listen_address = '*'

port = 5432
```

Open configuration file ```/var/lib/pgsql/11/data/pg_hba.conf```  and add the following line:

```
host    all             all             0.0.0.0/0               md5
```

## Stop and Start PostgreSQL

Start postgreSQL: ```systemctl start postgresql-11```
Stop postgreSQL: ```systemctl stop postgresql-11```

## Useful PostgreSQL Commands

Create Postgres user: ```postgres=# create user <username>;```

Create postgres DB: ```postgres=# create database <db-name>;```

Set user password: ```postgres=# alter user <username> with password '<password>';```

Grant priviliges on database: ```postgres=# grant all privileges on database <dbname> to <username> ;```

Create Schema: ```postgres=# \connect <db-name> ; create schema <schema-name>;```

## References

- https://www.postgresql.org/download/linux/redhat/
- https://medium.com/coding-blocks/creating-user-database-and-adding-access-on-postgresql-8bfcd2f4a91e
- https://stackoverflow.com/questions/14139017/cannot-connect-to-postgres-running-on-vm-from-host-machine-using-md5-method
- https://stackoverflow.com/questions/6508267/postgresql-create-schema-in-specific-database
