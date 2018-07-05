node default {

  notify { 'enduser-before': }
  notify { 'enduser-after': }

  class { 'duo':
    config_ikey    => 'ikeystringfromduo',
    config_skey    => 'skeystringfromduo',
    config_apihost => 'f.q.d.n',
  }

}
