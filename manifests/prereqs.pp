# @api private
#
# This class is called from the main duo class for installing needed prerequisite packages.
#
class duo::prereqs {
  assert_private('duo::install is a private class')

  if $::duo::manage_prereqs{
    $::duo::package_prereqs.each |String $_package| {
      package { $_package:
        ensure => present,
      }
    }
  }
}
