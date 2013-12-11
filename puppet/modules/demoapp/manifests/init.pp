import "stdlib"
import "apt"
import "postgresql"

include "::rabbitmq"

class demoapp {
    # Apt Config, use a local mirror, trust me
    stage {"pre": 
        before => Stage[main]
    }

    class updateApt { 
        exec {"/usr/bin/apt-get update":    
        }
    }

    class {'updateApt': 
        stage => pre
    }

    class {'apt':
    }

    apt::source {'ubuntu canada':
        location => 'http://ca.archive.ubuntu.com/ubuntu',
        repos => 'precise'
    }

    # Packages
    package { ["python-dev", "python-pip", "libpq-dev", "git", "ruby", "rubygems"]:
        ensure => installed,
        require => Apt::Source['ubuntu canada']
    }

    # Appliction dependencies
    exec {'makeEnv':
        cwd => "/vagrant/",
        provider => "shell",
        command => "pip install -r requirements.pip && touch .pip_run",
        logoutput => true,
        creates => "/vagrant/.pip_run",
        require => Package["python-pip"]
    }

    # Install a gem, why not
    exec {"installForeman":
        command => "/usr/bin/gem install foreman",
        require => Package["rubygems"]
    }

    # DB Config
    class {'postgresql::server':
        config_hash => {
            'listen_addresses' => "*",
            'ipv4acls' => ['host demo demo 10.0.2.2/32 md5']
        }
    }
    postgresql::db {'demo':
        user => 'demo',
        password => 'a'
    }

    # Message Queue
    class { '::rabbitmq':
        delete_guest_user => true,
        admin_enable => false
    }

    rabbitmq_user { 'demo':
        admin    => false,
        password => 'demo',
    }

    rabbitmq_vhost { 'demo':
        ensure => present,
    }

    rabbitmq_user_permissions { 'demo@demo':
        configure_permission => '.*',
        read_permission      => '.*',
        write_permission     => '.*',
    }
}