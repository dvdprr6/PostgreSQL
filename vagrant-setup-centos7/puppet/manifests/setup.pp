Exec { path => [ '/bin/', '/sbin/', '/usr/bin/', '/usr/sbin/' ]}

$base_path = '/usr/local/bin:/usr/local/:/usr/bin/:/bin/'

class systemUpdate{
  exec{'yum update':
    command => 'yum update -y',
    timeout => 0
  }
  $sysPackages = [
    'wget',
    'telnet',
    'unzip'
  ]
  package {$sysPackages:
    ensure => 'installed',
    require => Exec['yum update']
  }
}

class timezone{
  exec{'unlink localtime':
    command => 'unlink /etc/localtime',
    cwd => '/home/vagrant',
    user => root
  } ->
  file{'/etc/localtime':
    ensure => 'link',
    target => '/usr/share/zoneinfo/Canada/Eastern',
    owner => root
  }
}

class postgresInstall{
  exec{'download postresql':
    command => 'yum install -y https://download.postgresql.org/pub/repos/yum/11/redhat/rhel-7-x86_64/pgdg-centos11-11-2.noarch.rpm',
    cwd => '/home/vagrant',
    user => root
  } ->
  exec{'install postgresql':
    command => 'yum install -y postgresql11',
    cwd => '/home/vagrant',
    user => root
  } ->
  exec{'install postgrsql-server':
    command => 'yum install -y postgresql11-server',
    cwd => '/home/vagrant',
    user => root
  }
}

class initDB{
  exec{'initialize DB':
    command => '/usr/pgsql-11/bin/postgresql-11-setup initdb',
    cwd => '/home/vagrant',
    user => root
  }
}

class enableAutoStart{
  exec{'auto start':
    command => 'systemctl enable postgresql-11',
    cwd => '/home/vagrant',
    user => root
  }
}

class startPostgreSQL{
  exec{'start postgres':
    command => 'systemctl start postgresql-11',
    cwd => '/home/vagrant',
    user => root
  }
}

class postgresSQLSetup{
  include systemUpdate
  include timezone
  include postgresInstall
  include initDB
  include enableAutoStart
  include startPostgreSQL
  
  Class[systemUpdate]
  -> Class[timezone]
  -> Class[postgresInstall]
  -> Class[initDB]
  -> Class[enableAutoStart]
  -> Class[startPostgreSQL]
}

include postgresSQLSetup
