# Class: mongodb
#
# This class installs MongoDB (stable)
#
# Notes:
#  This class is Ubuntu specific.
#  By Sean Porter Consulting
#
# Actions:
#  - Install MongoDB using a 10gen Ubuntu repository
#  - Manage the MongoDB service
#  - MongoDB can be part of a replica set
#
# Sample Usage:
#  class { mongodb:
#    replSet => "myReplicaSet",
#    ulimit_nofile => 20000,
#  }
#
class mongodb(
  $replSet = $mongodb::params::replSet,
  $respawn = $mongodb::params::respawn,
  $ulimit_nofile = $mongodb::params::ulimit_nofile,
  $repository = $mongodb::params::repository,
  $package = $mongodb::params::package
) inherits mongodb::params {

  file { "/etc/yum.repos.d/10gen.repo":
    mode => 644,
    owner => root,
    group => root,
    notify => Exec["yum-clean"],
    content => template("regression/10gen.repo.erb")
  }

  package { [mongo20-10gen]:
    ensure => installed
  }

  package { [mongo20-10gen-server]:
    ensure => installed
  }

  exec { "yum-clean":
		command => "/usr/bin/yum clean all",
		refreshonly => true,
	}

  file { "/etc/mongodb.conf":
    content => template("mongodb/mongodb.conf.erb"),
    mode => "0644",
    notify => Service["mongodb"],
    require => Package[$package],
  }

}
