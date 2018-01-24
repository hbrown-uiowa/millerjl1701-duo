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

          it { is_expected.to contain_class('duo::install') }
          it { is_expected.to contain_class('duo::config') }
          it { is_expected.to contain_class('duo::service') }
          it { is_expected.to contain_class('duo::install').that_comes_before('Class[duo::config]') }
          it { is_expected.to contain_class('duo::service').that_subscribes_to('Class[duo::config]') }

          it { is_expected.to contain_package('duo').with_ensure('present') }

          it { is_expected.to contain_service('duo').with(
            'ensure'     => 'running',
            'enable'     => 'true',
            'hasstatus'  => 'true',
            'hasrestart' => 'true',
          ) }
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
