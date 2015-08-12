require 'kitchen'
require 'kitchen/driver/ssh_base'

module Kitchen
  module Driver
    class Ssh2 < SSHBase

      default_config :ssh_command_prefix, nil

      # (see Base#converge)
      def converge(state) # rubocop:disable Metrics/AbcSize
        provisioner = instance.provisioner
        provisioner.create_sandbox
        sandbox_dirs = Dir.glob("#{provisioner.sandbox_path}/*")

        instance.transport.connection(backcompat_merged_state(state)) do |conn|
          run_remote(provisioner.install_command,conn)
          run_remote(provisioner.init_command,conn)
          info("Transferring files to #{instance.to_str}")
          conn.upload(sandbox_dirs, provisioner[:root_path])
          debug("Transfer complete")
          run_remote(provisioner.prepare_command,conn)
          run_remote(provisioner.run_command,conn)
        end
      rescue Kitchen::Transport::TransportFailed => ex
        raise ActionFailed, ex.message
      ensure
        instance.provisioner.cleanup_sandbox
      end

      # (see Base#setup)
      def setup(state)
        verifier = instance.verifier

        instance.transport.connection(backcompat_merged_state(state)) do |conn|
          run_remote(verifier.install_command,conn)
        end
      rescue Kitchen::Transport::TransportFailed => ex
        raise ActionFailed, ex.message
      end

      # (see Base#verify)
      def verify(state) # rubocop:disable Metrics/AbcSize
        verifier = instance.verifier
        verifier.create_sandbox
        sandbox_dirs = Dir.glob(File.join(verifier.sandbox_path, "*"))

        instance.transport.connection(backcompat_merged_state(state)) do |conn|
          run_remote(verifier.init_command,conn)
          info("Transferring files to #{instance.to_str}")
          conn.upload(sandbox_dirs, verifier[:root_path])
          debug("Transfer complete")
          run_remote(verifier.prepare_command,conn)
          run_remote(verifier.run_command,conn)
        end
      rescue Kitchen::Transport::TransportFailed => ex
        raise ActionFailed, ex.message
      ensure
        instance.verifier.cleanup_sandbox
      end

      # Executes an arbitrary command on an instance over an SSH connection.
      #
      # @param state [Hash] mutable instance and driver state
      # @param command [String] the command to be executed
      # @raise [ActionFailed] if the command could not be successfully completed
      def remote_command(state, command)
        instance.transport.connection(backcompat_merged_state(state)) do |conn|
          run_remote(command,conn)
        end
      end
      
      # Executes a remote command over SSH.
      #
      # @param command [String] remove command to run
      # @param connection [Kitchen::SSH] an SSH connection
      # @raise [ActionFailed] if an exception occurs
      # @api private
      def run_remote(command, connection)
        return if command.nil?

        command = command.to_s
        command = self[:ssh_command_prefix] + " " + command if self[:ssh_command_prefix]

        #require 'pry'; binding.pry
        print "SSH2 Running remote command: " + command;
        connection.execute(env_cmd(command))
      rescue SSHFailed, Net::SSH::Exception => ex
        raise ActionFailed, ex.message
      end

      def create(state)
        state[:sudo] = config[:sudo]
        state[:port] = config[:port]
        state[:ssh_key] = config[:ssh_key]
        state[:forward_agent] = config[:forward_agent]
        state[:username] = config[:username]
        state[:hostname] = config[:hostname]
        state[:password] = config[:password]
        print "Kitchen-ssh does not start your server '#{state[:hostname]}' but will look for an ssh connection with user '#{state[:username]}'"
        wait_for_sshd(state[:hostname], state[:username], {:port => state[:port]})
        print "Kitchen-ssh found ssh ready on host '#{state[:hostname]}' with user '#{state[:username]}'\n"
        debug("ssh:create '#{state[:hostname]}'")
      end

      def destroy(state)
        print "Kitchen-ssh does not destroy your server '#{state[:hostname]}' by shutting it down..."
        print "Shutdown your server '#{state[:hostname]}' natively with user '#{state[:username]}'"
        print 'in your cloud or virtualisation console etc.\n'
        debug("ssh:destroy '#{state[:hostname]}'")
      end

      
    end
  end
end
