# Class: duo
# ===========================
#
# Main class that includes all other classes for the duo module.
#
# @param config_apihost The FQDN of the Duo api host that the duo_unix client should use. Default value: not specified.
# @param config_ikey The Duo integration key to use.
# @param config_skey The Duo secret key to use.
# @param config_accept_env_factor Used to set the accept_env_factor configuration parameter. See the Duo application documentation for how this should be set for your use case.
# @param config_autopush Used to set the autopush configuration parameter. See the Duo application documentation for how this should be set for your use case.
# @param config_failmode Used to set the failmode configuration parameter. See the Duo application documentation for how this should be set for your use case.
# @param config_fallback_local_ip  Used to set the fallback_local_ip configuration parameter. See the Duo application documentation for how this should be set for your use case.
# @param config_groups Used to set the groups configuration parameter. See the Duo application documentation for how this should be set for your use case.
# @param config_http_proxy Used to set the http_proxy configuration parameter. See the Duo application documentation for how this should be set for your use case.
# @param config_https_timeout Used to set the https_timeout configuration parameter. See the Duo application documentation for how this should be set for your use case.
# @param config_login_type Define which configuration case to use.
# @param config_motd Used to set the motd configuration parameter. See the Duo application documentation for how this should be set for your use case.
# @param config_prompts Used to set the prompts configuration parameter. See the Duo application documentation for how this should be set for your use case.
# @param config_pushinfo Used to set the pushinfo configuration parameter. See the Duo application documentation for how this should be set for your use case.
# @param manage_prereqs Whether or not to manage installation of the package prerequisites.
# @param manage_repo Whether or not to manage the yum repository definition.
# @param package_ensure Whether to install the duo package, and/or what version. Values: 'present', 'latest', or a specific version number.
# @param package_name Specifies the name of the package to install.
# @param package_prereqs Packages that need to be installed in the system prior to duo_unix.
# @param repo_baseurl Base URL of the yum repository for the yum.repos.d file.
# @param repo_descr Description of the yum repository for the yum.repos.d file.
# @param repo_enabled Whether or not the yum repository is enabled in the yum.repos.d file.
# @param repo_ensure Whether or not the yum.repos.d file is present or absent on the file system.
# @param repo_gpgcheck Whter or not to enable the gpgcheck setting in the yum.repos.d file.
# @param repo_gpgkey URL to the gpgkey in the yum.repos.d file.
# @param repo_proxy URL of the proxy to use set in the yum.repos.d file.
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
        '6', '7': {
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
