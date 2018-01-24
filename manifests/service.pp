# @api private
#
# This class is meant to be called from duo to manage the duo service.
#
class duo::service {
  assert_private('duo::service is a private class')

  service { $::duo::service_name:
    ensure     => $::duo::service_ensure,
    enable     => $::duo::service_enable,
    hasstatus  => true,
    hasrestart => true,
  }
}
