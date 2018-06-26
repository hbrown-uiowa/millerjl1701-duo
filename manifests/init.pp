# Class: duo
# ===========================
#
# Main class that includes all other classes for the duo module.
#
# @param package_ensure Whether to install the duo package, and/or what version. Values: 'present', 'latest', or a specific version number. Default value: present.
# @param package_name Specifies the name of the package to install. Default value: 'duo'.
#
class duo (
  String                     $config_apihost,
  String                     $config_ikey,
  String                     $config_skey,
  Optional[String]           $config_accept_env_factor = 'no',
  Enum['yes', 'no']          $config_autopush          = 'no',
  Enum['safe', 'secure']     $config_failmode          = 'safe',
  Optional[String]           $config_fallback_local_ip = undef,
  Optional[Array]            $config_groups            = undef,
  Optional[String]           $config_http_proxy        = undef,
  Optional[String]           $config_https_timeout     = '0',
  Enum['login', 'pam']       $config_login_type        = 'pam',
  Enum['yes', 'no']          $config_motd              = 'no',
  Enum['1', '2', '3']        $config_prompts           = '3',
  Enum['yes', 'no']          $config_pushinfo          = 'no',
  Boolean                    $manage_prereqs           = true,
  Boolean                    $manage_repo              = true,
  String                     $package_ensure           = 'present',
  String                     $package_name             = 'duo_unix',
  Array                      $package_prereqs          = [ 'openssl-devel', 'zlib-devel', ],
  String                     $repo_baseurl             = 'http://pkg.duosecurity.com/CentOS/$releasever/$basearch',
  String                     $repo_descr               = 'Duo Security Repository',
  Boolean                    $repo_enabled             = true,
  Enum['present', 'absent']  $repo_ensure              = 'present',
  Boolean                    $repo_gpgcheck            = true,
  String                     $repo_gpgkey              = 'https://duo.com/RPM-GPG-KEY-DUO',
  Optional[String]           $repo_proxy               = undef,
  ) {
  case $::operatingsystem {
    'RedHat', 'CentOS': {
      case $::operatingsystemmajrelease {
        '7': {
          contain duo::repo
          contain duo::prereqs
          contain duo::install
          contain duo::config

          Class['duo::repo']
          -> Class['duo::prereqs']
          -> Class['duo::install']
          -> Class['duo::config']
        }
        default: {
          fail("${::operatingsystem} ${::operatingsystemmajrelease} not supported")
        }
      }
    }
    default: {
      fail("${::operatingsystem} not supported")
    }
  }
}
