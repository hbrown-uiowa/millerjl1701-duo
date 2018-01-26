require 'spec_helper'

describe 'duo' do
  context 'supported operating systems' do
    on_supported_os.each do |os, facts|
      context "on #{os}" do
        let(:facts) do
          facts
        end

        context "duo class without any parameters changed from defaults" do
          it { is_expected.to compile.with_all_deps }

          it { is_expected.to contain_class('duo::repo') }
          it { is_expected.to contain_class('duo::install') }
          it { is_expected.to contain_class('duo::config') }
          it { is_expected.to contain_class('duo::service') }
          it { is_expected.to contain_class('duo::repo').that_comes_before('Class[duo::install]') }
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

          it { is_expected.to contain_package('duo_unix').with_ensure('present') }
          it { is_expected.to contain_package('openssl-devel').with_ensure('present')  }
          it { is_expected.to contain_package('zlib-devel').with_ensure('present')  }

          #it { is_expected.to contain_service('duo').with(
          #  'ensure'     => 'running',
          #  'enable'     => 'true',
          #  'hasstatus'  => 'true',
          #  'hasrestart' => 'true',
          #) }
        end

        context 'duo class with manage_prereqs set to false' do
          let(:params){
            {
              :manage_prereqs => false,
            }
          }

          it { is_expected.to_not contain_package('openssl-devel') }
          it { is_expected.to_not contain_package('zlib-devel') }
        end

        context 'duo class with manage_repo set to false' do
          let(:params){
            {
              :manage_repo => false,
            }
          }

          it { is_expected.to_not contain_yumrepo('duosecurity') }
        end

        context 'duo class with package_prereqs set to include pam-devel in addition to the others' do
          let(:params){
            {
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
              :repo_baseurl => 'http://foo.example.com/bar',
            }
          }
          it { is_expected.to contain_yumrepo('duosecurity').with_baseurl('http://foo.example.com/bar') }
        end

        context 'duo class with repo_descr set to foo repo' do
          let(:params){
            {
              :repo_descr => 'foo repo',
            }
          }
          it { is_expected.to contain_yumrepo('duosecurity').with_descr('foo repo') }
        end

        context 'duo class with repo_enabled set to false' do
          let(:params){
            {
              :repo_enabled => false,
            }
          }

          it { is_expected.to contain_yumrepo('duosecurity').with_enabled('0') }
        end

        context 'duo class with repo_ensure set to absent' do
          let(:params){
            {
              :repo_ensure => 'absent',
            }
          }

          it { is_expected.to contain_yumrepo('duosecurity').with_ensure('absent') }
        end

        context 'duo class with repo_gpgcheck set to false' do
          let(:params){
            {
              :repo_gpgcheck => false,
            }
          }

          it { is_expected.to contain_yumrepo('duosecurity').with_gpgcheck('0') }
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

      it { expect { is_expected.to contain_package('duo') }.to raise_error(Puppet::Error, /Nexenta not supported/) }
    end
  end
end
