require 'spec_helper_acceptance'

describe 'Custom Message' do

  def apply_reboot_manifest(agent, reboot_manifest)
    apply_manifest_on agent, reboot_manifest, {:debug => true} do |result|
      if fact_on(agent, 'kernel') == 'SunOS'
        expected_command = /shutdown -y -i 6 -g 60 \"A different message\"/
      else
        expected_command = /shutdown -r \+1 \"A different message\"/
      end

      assert_match expected_command,
                   result.stdout, 'Expected reboot message is incorrect'
      assert_match /Scheduling system reboot with message: \"A different message\"/,
                   result.stdout, 'Reboot message was not logged'
    end
    retry_shutdown_abort(agent)
  end

  let(:reboot_manifest) {
    <<-MANIFEST
      notify { 'step_1':
      }
      ~>
      reboot { 'now':
        when => refreshed,
        message => 'A different message',
      }
    MANIFEST
  }

  windows_agents.each do |agent|
    context "on #{agent}" do
      it 'Reboot Immediately with a Custom Message' do
        apply_reboot_manifest(agent, reboot_manifest)
      end
    end
  end

  posix_agents.each do |agent|
    context "on #{agent}" do
      it 'Reboot Immediately with a Custom Message' do
        apply_reboot_manifest(agent, reboot_manifest)
      end
    end
  end
end
