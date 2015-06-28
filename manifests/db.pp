# Public: Create MySQL Databases
#
# namevar - The name of the database.
#
# Examples
#
#   mysql::db { 'foo': }
define mysql::db($ensure = present) {
  require mysql

  if $ensure == 'present' {
    exec { "create mysql db ${name}":
      command => "mysql -uroot -e 'create database ${name} default character set utf8 default collate utf8_unicode_ci'",
      creates => "${mysql::config::datadir}/${name}",
      require => Exec['wait-for-mysql'],
      unless  => "mysql -uroot -p13306 -e 'show databases' \
        --password='' | grep -w '${name}'"
    }
  } elsif $ensure == 'absent' {
    exec { "delete mysql db ${name}":
      command => "mysqladmin -uroot -p13306 drop ${name} --password=''",
      require => Exec['wait-for-mysql']
    }
  }
}
