# @api private
#
# This class is called from duo for service config.
#
class duo::repo {
  assert_private('duo::config is a private class')
  if $duo::manage_repo {
    if $duo::repo_enabled {
      $_enabled = '1'
    }
    else {
      $_enabled = '0'
    }
    if $duo::repo_gpgcheck {
      $_gpgcheck = '1'
    }
    else {
      $_gpgcheck = '0'
    }

    yumrepo { 'duosecurity':
      ensure   => $duo::repo_ensure,
      descr    => $duo::repo_descr,
      baseurl  => $duo::repo_baseurl,
      enabled  => $_enabled,
      gpgcheck => $_gpgcheck,
      gpgkey   => $duo::repo_gpgkey,
      proxy    => $duo::repo_proxy,
    }
  }
}
