# @api private
#
# This class is called from duo for configuration of the application.
#
class duo::config {
  assert_private('duo::config is a private class')
  $_config_login_type        = $duo::config_login_type
  $_config_groups            = $duo::config_groups
  $_config_http_proxy        = $duo::config_http_proxy
  $_config_fallback_local_ip = $duo::config_fallback_local_ip

  if $_config_login_type == 'login' {
    # populate config file with desired params
    file { '/etc/duo/login_duo.conf':
      ensure  => present,
      owner   => 'sshd',
      group   => 'root',
      mode    => '0600',
      content => template('duo/login_duo.conf.erb'),
    }
    # serve out the file provided by the rpm
    file { '/etc/duo/pam_duo.conf':
      ensure => present,
      owner  => 'root',
      group  => 'root',
      mode   => '0600',
      source => 'puppet:///modules/duo/pam_duo.conf',
    }
  } else {
    # serve out the file provided by the rpm
    file { '/etc/duo/login_duo.conf':
      ensure => present,
      owner  => 'sshd',
      group  => 'root',
      mode   => '0600',
      source => 'puppet:///modules/duo/login_duo.conf',
    }
    # populate config file with desired params.
    file { '/etc/duo/pam_duo.conf':
      ensure  => present,
      owner   => 'root',
      group   => 'root',
      mode    => '0600',
      content => template('duo/pam_duo.conf.erb'),
    }
  }
}
