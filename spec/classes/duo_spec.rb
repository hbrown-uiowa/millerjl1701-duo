require 'spec_helper'

describe 'duo' do
  context 'supported operating systems' do
    on_supported_os.each do |os, facts|
      context "on #{os}" do
        let(:facts) do
          facts
        end

        context "duo class without any parameters changed from defaults and mandatory params added" do
          let(:params){
            {
              :config_ikey    => 'ikeystring',
              :config_skey    => 'skeystring',
              :config_apihost => 'apihost.example.com',
            }
          }
          it { is_expected.to compile.with_all_deps }

          it { is_expected.to contain_class('duo::repo') }
          it { is_expected.to contain_class('duo::install') }
          it { is_expected.to contain_class('duo::config') }
          it { is_expected.to contain_class('duo::service') }
          it { is_expected.to contain_class('duo::repo').that_comes_before('Class[duo::prereqs]') }
          it { is_expected.to contain_class('duo::prereqs').that_comes_before('Class[duo::install]') }
          it { is_expected.to contain_class('duo::install').that_comes_before('Class[duo::config]') }
          it { is_expected.to contain_class('duo::service').that_subscribes_to('Class[duo::config]') }

          it { is_expected.to contain_yumrepo('duosecurity').with(
            'ensure'   => 'present',
            'descr'    => 'Duo Security Repository',
            'baseurl'  => 'http://pkg.duosecurity.com/CentOS/$releasever/$basearch',
            'enabled'  => '1',
            'gpgcheck' => '1',
            'gpgkey'   => 'https://duo.com/RPM-GPG-KEY-DUO',
          ) }

          it { is_expected.to contain_package('openssl-devel').with_ensure('present')  }
          it { is_expected.to contain_package('zlib-devel').with_ensure('present')  }

          it { is_expected.to contain_package('duo_unix').with_ensure('present') }

          it { is_expected.to contain_file('/etc/duo/login_duo.conf').with(
            'ensure' => 'present',
            'owner'  => 'sshd',
            'group'  => 'root',
            'mode'   => '0600',
            'source' => 'puppet:///modules/duo/login_duo.conf',
          ) }
          it { is_expected.to contain_file('/etc/duo/pam_duo.conf').with(
            'ensure' => 'present',
            'owner'  => 'root',
            'group'  => 'root',
            'mode'   => '0600',
          ) }
          it { is_expected.to_not contain_file('/etc/duo/pam_duo.conf').with_source('puppet:///modules/duo/pam_duo.conf') }

          it { is_expected.to contain_file('/etc/duo/pam_duo.conf').with_content(/ikey=ikeystring/) }
          it { is_expected.to contain_file('/etc/duo/pam_duo.conf').with_content(/skey=skeystring/) }
          it { is_expected.to contain_file('/etc/duo/pam_duo.conf').with_content(/host=apihost.example.com/) }
          it { is_expected.to contain_file('/etc/duo/pam_duo.conf').with_content(/accept_env_factor=no/) }
          it { is_expected.to contain_file('/etc/duo/pam_duo.conf').with_content(/autopush=no/) }
          it { is_expected.to contain_file('/etc/duo/pam_duo.conf').with_content(/failmode=safe/) }
          it { is_expected.to_not contain_file('/etc/duo/pam_duo.conf').with_content(/failback_local_ip=/) }
          it { is_expected.to_not contain_file('/etc/duo/pam_duo.conf').with_content(/groups=/) }
          it { is_expected.to_not contain_file('/etc/duo/pam_duo.conf').with_content(/http_proxy=/) }
          it { is_expected.to contain_file('/etc/duo/pam_duo.conf').with_content(/https_timeout=0/) }
          it { is_expected.to contain_file('/etc/duo/pam_duo.conf').with_content(/motd=no/) }
          it { is_expected.to contain_file('/etc/duo/pam_duo.conf').with_content(/prompts=3/) }
          it { is_expected.to contain_file('/etc/duo/pam_duo.conf').with_content(/pushinfo=no/) }

          #it { is_expected.to contain_service('duo').with(
          #  'ensure'     => 'running',
          #  'enable'     => 'true',
          #  'hasstatus'  => 'true',
          #  'hasrestart' => 'true',
          #) }
        end

        context 'duo class with config_groups set to [ foo, bar]' do
          let(:params){
            {
              :config_ikey    => 'ikeystring',
              :config_skey    => 'skeystring',
              :config_apihost => 'apihost.example.com',
              :config_groups  => [ 'foo', 'bar', ],
            }
          }

          it { is_expected.to contain_file('/etc/duo/pam_duo.conf').with_content(/groups=foo,bar/) }
        end

        context 'duo class with config_accept_env_factor set to DUO_PASSCODE=push' do
          let(:params){
            {
              :config_ikey              => 'ikeystring',
              :config_skey              => 'skeystring',
              :config_apihost           => 'apihost.example.com',
              :config_accept_env_factor => 'DUO_PASSCODE=push',
            }
          }

          it { is_expected.to contain_file('/etc/duo/pam_duo.conf').with_content(/accept_env_factor=DUO_PASSCODE=push/) }
        end

        context 'duo class with config_autopush set to yes' do
          let(:params){
            {
              :config_ikey     => 'ikeystring',
              :config_skey     => 'skeystring',
              :config_apihost  => 'apihost.example.com',
              :config_autopush => 'yes',
            }
          }

          it { is_expected.to contain_file('/etc/duo/pam_duo.conf').with_content(/autopush=yes/) }
        end

        context 'duo class with config_failmode set to secure' do
          let(:params){
            {
              :config_ikey     => 'ikeystring',
              :config_skey     => 'skeystring',
              :config_apihost  => 'apihost.example.com',
              :config_failmode => 'secure',
            }
          }

          it { is_expected.to contain_file('/etc/duo/pam_duo.conf').with_content(/failmode=secure/) }
        end

        context 'duo class with config_http_proxy set to http://proxy.example.com:8080/' do
          let(:params){
            {
              :config_ikey       => 'ikeystring',
              :config_skey       => 'skeystring',
              :config_apihost    => 'apihost.example.com',
              :config_http_proxy => 'http://proxy.example.com:8080/',
            }
          }

          it { is_expected.to contain_file('/etc/duo/pam_duo.conf').with_content(/http_proxy=http:\/\/proxy.example.com:8080\//) }
        end

        context 'duo class with config_https_timeout set to 60' do
          let(:params){
            {
              :config_ikey          => 'ikeystring',
              :config_skey          => 'skeystring',
              :config_apihost       => 'apihost.example.com',
              :config_https_timeout => '60',
            }
          }

          it { is_expected.to contain_file('/etc/duo/pam_duo.conf').with_content(/https_timeout=60/) }
        end

        context 'duo class with config_motd set to yes' do
          let(:params){
            {
              :config_ikey    => 'ikeystring',
              :config_skey    => 'skeystring',
              :config_apihost => 'apihost.example.com',
              :config_motd    => 'yes',
            }
          }

          it { is_expected.to contain_file('/etc/duo/pam_duo.conf').with_content(/motd=yes/) }
        end

        context 'duo class with config_prompts set to 1' do
          let(:params){
            {
              :config_ikey    => 'ikeystring',
              :config_skey    => 'skeystring',
              :config_apihost => 'apihost.example.com',
              :config_prompts => '1',
            }
          }

          it { is_expected.to contain_file('/etc/duo/pam_duo.conf').with_content(/prompts=1/) }
        end

        context 'duo class with config_pushinfo set to yes' do
          let(:params){
            {
              :config_ikey     => 'ikeystring',
              :config_skey     => 'skeystring',
              :config_apihost  => 'apihost.example.com',
              :config_pushinfo => 'yes',
            }
          }

          it { is_expected.to contain_file('/etc/duo/pam_duo.conf').with_content(/pushinfo=yes/) }
        end

        context 'duo class with config_fallback_local_ip set to yes' do
          let(:params){
            {
              :config_ikey              => 'ikeystring',
              :config_skey              => 'skeystring',
              :config_apihost           => 'apihost.example.com',
              :config_fallback_local_ip => 'yes',
            }
          }

          it { is_expected.to contain_file('/etc/duo/pam_duo.conf').with_content(/fallback_local_ip=yes/) }
        end

        context 'duo class with config_login_type set to login' do
          let(:params){
            {
              :config_ikey       => 'ikeystring',
              :config_skey       => 'skeystring',
              :config_apihost    => 'apihost.example.com',
              :config_login_type => 'login',
            }
          }

          it { is_expected.to contain_file('/etc/duo/pam_duo.conf').with_source('puppet:///modules/duo/pam_duo.conf') }
          it { is_expected.to_not contain_file('/etc/duo/login_duo.conf').with_source('puppet:///modules/duo/login_duo.conf') }
          it { is_expected.to contain_file('/etc/duo/login_duo.conf').with_content(/ikey=ikeystring/) }
          it { is_expected.to contain_file('/etc/duo/login_duo.conf').with_content(/skey=skeystring/) }
          it { is_expected.to contain_file('/etc/duo/login_duo.conf').with_content(/host=apihost.example.com/) }
          it { is_expected.to contain_file('/etc/duo/login_duo.conf').with_content(/accept_env_factor=no/) }
          it { is_expected.to contain_file('/etc/duo/login_duo.conf').with_content(/autopush=no/) }
          it { is_expected.to contain_file('/etc/duo/login_duo.conf').with_content(/failmode=safe/) }
          it { is_expected.to_not contain_file('/etc/duo/login_duo.conf').with_content(/failback_local_ip=/) }
          it { is_expected.to_not contain_file('/etc/duo/login_duo.conf').with_content(/groups=/) }
          it { is_expected.to_not contain_file('/etc/duo/login_duo.conf').with_content(/http_proxy=/) }
          it { is_expected.to contain_file('/etc/duo/login_duo.conf').with_content(/https_timeout=0/) }
          it { is_expected.to contain_file('/etc/duo/login_duo.conf').with_content(/motd=no/) }
          it { is_expected.to contain_file('/etc/duo/login_duo.conf').with_content(/prompts=3/) }
          it { is_expected.to contain_file('/etc/duo/login_duo.conf').with_content(/pushinfo=no/) }
        end

        context 'duo class with config_login_type set to login and config_groups set to [ foo, bar]' do
          let(:params){
            {
              :config_ikey       => 'ikeystring',
              :config_skey       => 'skeystring',
              :config_apihost    => 'apihost.example.com',
              :config_login_type => 'login',
              :config_groups     => [ 'foo', 'bar', ],
            }
          }

          it { is_expected.to contain_file('/etc/duo/login_duo.conf').with_content(/groups=foo,bar/) }
        end

        context 'duo class with config_login_type set to login and config_accept_env_factor set to DUO_PASSCODE=push' do
          let(:params){
            {
              :config_ikey              => 'ikeystring',
              :config_skey              => 'skeystring',
              :config_apihost           => 'apihost.example.com',
              :config_login_type        => 'login',
              :config_accept_env_factor => 'DUO_PASSCODE=push',
            }
          }

          it { is_expected.to contain_file('/etc/duo/login_duo.conf').with_content(/accept_env_factor=DUO_PASSCODE=push/) }
        end

        context 'duo class with config_login_type set to login and config_autopush set to yes' do
          let(:params){
            {
              :config_ikey       => 'ikeystring',
              :config_skey       => 'skeystring',
              :config_apihost    => 'apihost.example.com',
              :config_login_type => 'login',
              :config_autopush   => 'yes',
            }
          }

          it { is_expected.to contain_file('/etc/duo/login_duo.conf').with_content(/autopush=yes/) }
        end

        context 'duo class with config_login_type set to login and config_failmode set to secure' do
          let(:params){
            {
              :config_ikey       => 'ikeystring',
              :config_skey       => 'skeystring',
              :config_apihost    => 'apihost.example.com',
              :config_login_type => 'login',
              :config_failmode   => 'secure',
            }
          }

          it { is_expected.to contain_file('/etc/duo/login_duo.conf').with_content(/failmode=secure/) }
        end

        context 'duo class with config_login_type set to login and config_http_proxy set to http://proxy.example.com:8080/' do
          let(:params){
            {
              :config_ikey       => 'ikeystring',
              :config_skey       => 'skeystring',
              :config_apihost    => 'apihost.example.com',
              :config_login_type => 'login',
              :config_http_proxy => 'http://proxy.example.com:8080/',
            }
          }

          it { is_expected.to contain_file('/etc/duo/login_duo.conf').with_content(/http_proxy=http:\/\/proxy.example.com:8080\//) }
        end

        context 'duo class with config_login_type set to login and config_https_timeout set to 60' do
          let(:params){
            {
              :config_ikey          => 'ikeystring',
              :config_skey          => 'skeystring',
              :config_apihost       => 'apihost.example.com',
              :config_login_type    => 'login',
              :config_https_timeout => '60',
            }
          }

          it { is_expected.to contain_file('/etc/duo/login_duo.conf').with_content(/https_timeout=60/) }
        end

        context 'duo class with config_login_type set to login and config_motd set to yes' do
          let(:params){
            {
              :config_ikey       => 'ikeystring',
              :config_skey       => 'skeystring',
              :config_apihost    => 'apihost.example.com',
              :config_login_type => 'login',
              :config_motd       => 'yes',
            }
          }

          it { is_expected.to contain_file('/etc/duo/login_duo.conf').with_content(/motd=yes/) }
        end

        context 'duo class with config_login_type set to login and config_prompts set to 1' do
          let(:params){
            {
              :config_ikey       => 'ikeystring',
              :config_skey       => 'skeystring',
              :config_apihost    => 'apihost.example.com',
              :config_login_type => 'login',
              :config_prompts    => '1',
            }
          }

          it { is_expected.to contain_file('/etc/duo/login_duo.conf').with_content(/prompts=1/) }
        end

        context 'duo class with config_login_type set to login and config_pushinfo set to yes' do
          let(:params){
            {
              :config_ikey       => 'ikeystring',
              :config_skey       => 'skeystring',
              :config_apihost    => 'apihost.example.com',
              :config_login_type => 'login',
              :config_pushinfo   => 'yes',
            }
          }

          it { is_expected.to contain_file('/etc/duo/login_duo.conf').with_content(/pushinfo=yes/) }
        end

        context 'duo class with config_login_type set to login and config_fallback_local_ip set to yes' do
          let(:params){
            {
              :config_ikey              => 'ikeystring',
              :config_skey              => 'skeystring',
              :config_apihost           => 'apihost.example.com',
              :config_login_type        => 'login',
              :config_fallback_local_ip => 'yes',
            }
          }

          it { is_expected.to contain_file('/etc/duo/login_duo.conf').with_content(/fallback_local_ip=yes/) }
        end

        context 'duo class with manage_prereqs set to false' do
          let(:params){
            {
              :config_ikey    => 'ikeystring',
              :config_skey    => 'skeystring',
              :config_apihost => 'apihost.example.com',
              :manage_prereqs => false,
            }
          }

          it { is_expected.to_not contain_package('openssl-devel') }
          it { is_expected.to_not contain_package('zlib-devel') }
        end

        context 'duo class with manage_repo set to false' do
          let(:params){
            {
              :config_ikey    => 'ikeystring',
              :config_skey    => 'skeystring',
              :config_apihost => 'apihost.example.com',
              :manage_repo    => false,
            }
          }

          it { is_expected.to_not contain_yumrepo('duosecurity') }
        end

        context 'duo class with package_prereqs set to include pam-devel in addition to the others' do
          let(:params){
            {
              :config_ikey     => 'ikeystring',
              :config_skey     => 'skeystring',
              :config_apihost  => 'apihost.example.com',
              :package_prereqs => [ 'openssl-devel', 'zlib-devel', 'pam-devel', ],
            }
          }

          it { is_expected.to contain_package('openssl-devel').with_ensure('present')  }
          it { is_expected.to contain_package('pam-devel').with_ensure('present')  }
          it { is_expected.to contain_package('zlib-devel').with_ensure('present')  }
        end

        context 'duo class with repo_baseurl set to http://foo.example.com/bar' do
          let(:params){
            {
              :config_ikey    => 'ikeystring',
              :config_skey    => 'skeystring',
              :config_apihost => 'apihost.example.com',
              :repo_baseurl   => 'http://foo.example.com/bar',
            }
          }
          it { is_expected.to contain_yumrepo('duosecurity').with_baseurl('http://foo.example.com/bar') }
        end

        context 'duo class with repo_descr set to foo repo' do
          let(:params){
            {
              :config_ikey    => 'ikeystring',
              :config_skey    => 'skeystring',
              :config_apihost => 'apihost.example.com',
              :repo_descr     => 'foo repo',
            }
          }
          it { is_expected.to contain_yumrepo('duosecurity').with_descr('foo repo') }
        end

        context 'duo class with repo_enabled set to false' do
          let(:params){
            {
              :config_ikey    => 'ikeystring',
              :config_skey    => 'skeystring',
              :config_apihost => 'apihost.example.com',
              :repo_enabled   => false,
            }
          }

          it { is_expected.to contain_yumrepo('duosecurity').with_enabled('0') }
        end

        context 'duo class with repo_ensure set to absent' do
          let(:params){
            {
              :config_ikey    => 'ikeystring',
              :config_skey    => 'skeystring',
              :config_apihost => 'apihost.example.com',
              :repo_ensure    => 'absent',
            }
          }

          it { is_expected.to contain_yumrepo('duosecurity').with_ensure('absent') }
        end

        context 'duo class with repo_gpgcheck set to false' do
          let(:params){
            {
              :config_ikey    => 'ikeystring',
              :config_skey    => 'skeystring',
              :config_apihost => 'apihost.example.com',
              :repo_gpgcheck  => false,
            }
          }

          it { is_expected.to contain_yumrepo('duosecurity').with_gpgcheck('0') }
        end

        context 'duo class with repo_proxy set to http://proxy.example.com:8080' do
          let(:params){
            {
              :config_ikey    => 'ikeystring',
              :config_skey    => 'skeystring',
              :config_apihost => 'apihost.example.com',
              :repo_proxy     => 'http://proxy.example.com:8080',
            }
          }

          it { is_expected.to contain_yumrepo('duosecurity').with_proxy('http://proxy.example.com:8080') }
        end

      end
    end
  end

  context 'unsupported operating system' do
    describe 'duo class without any parameters on Solaris/Nexenta' do
      let(:facts) do
        {
          :osfamily        => 'Solaris',
          :operatingsystem => 'Nexenta',
        }
      end
      let(:params){
        {
          :config_ikey    => 'ikeystring',
          :config_skey    => 'skeystring',
          :config_apihost => 'apihost.example.com',
        }
      }

      it { expect { is_expected.to contain_package('duo') }.to raise_error(Puppet::Error, /Nexenta not supported/) }
    end
  end
end
