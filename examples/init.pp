node default {

  notify { 'enduser-before': }
  notify { 'enduser-after': }

  class { 'duo':
    require => Notify['enduser-before'],
    before  => Notify['enduser-after'],
  }

}
