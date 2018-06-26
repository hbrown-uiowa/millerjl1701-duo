require 'spec_helper_acceptance'

describe 'duo class' do
  context 'default parameters' do
    # Using puppet_apply as a helper
    it 'should work idempotently with no errors' do
      pp = <<-EOS
      class { 'duo':
        config_ikey    => 'ikeystring',
        config_skey    => 'skeystring',
        config_apihost => 'apihost.example.com',
      }
      EOS

      # Run it twice and test for idempotency
      apply_manifest(pp, :catch_failures => true)
      apply_manifest(pp, :catch_changes  => true)
    end

    describe yumrepo('duosecurity') do
      it { should exist }
      it { should be_enabled }
    end

    describe package('openssl-devel') do
      it { should be_installed }
    end

    describe package('zlib-devel') do
      it { should be_installed }
    end

    describe package('duo_unix') do
      it { should be_installed }
    end

    describe file('/etc/duo/login_duo.conf') do
      it { should exist }
      it { should be_owned_by 'sshd' }
      it { should be_grouped_into 'root' }
      it { should be_mode 600 }
      it { should contain '; Duo integration key' }
    end

    describe file('/etc/duo/pam_duo.conf') do
      it { should exist }
      it { should be_owned_by 'root' }
      it { should be_grouped_into 'root' }
      it { should be_mode 600 }
      it { should_not contain '; Duo integration key' }
      it { should contain 'ikey=ikeystring' }
      it { should contain 'skey=skeystring' }
      it { should contain 'host=apihost.example.com' }
      it { should contain 'accept_env_factor=no' }
      it { should contain 'autopush=no' }
      it { should contain 'failmode=safe' }
      it { should_not contain 'failback_local_ip=' }
      it { should_not contain 'groups=' }
      it { should_not contain 'http_proxy=' }
      it { should contain 'https_timeout=0' }
      it { should contain 'motd=no' }
      it { should contain 'pushinfo=no' }
    end
  end
end
