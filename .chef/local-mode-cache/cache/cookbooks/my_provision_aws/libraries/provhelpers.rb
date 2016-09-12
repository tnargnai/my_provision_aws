module ProvHelpers

require 'chef'
require 'chef/rest'

# Variables
  # @@knife = File.expand_path("#{ENV['HOME']}/.chef/knife.rb")
  # @@secret = "#{ENV['HOME']}/.chef/encrypted_data_bag_secret"
  @@knife = "/Users/grantia2/repos/barclays/chef-prov//.chef/knife.rb"
  @@secret = "/Users/grantia2/repos/barclays/chef-prov/.chef/encrypted_data_bag_secret"
  @@certificate = "/Users/grantia2/repos/barclays/chef-prov/.chef/trusted_certs/DigiCert_SHA2_Secure_Server_CA.crt"
  Chef::Config.from_file(@@knife)
  @@rest = Chef::REST.new(Chef::Config[:chef_server_url])

  # Get all nodes in environment on chef server
  def get_env_nodes(env)
      # Get all nodes in environment
      dirty_chef_nodes = @@rest.get_rest("environments/#{env}/nodes")
      chef_nodes = []
      dirty_chef_nodes.each do |key, value|
        chef_nodes << key
      end
        chef_nodes.sort!
      return chef_nodes
  end

# Get all nodes in data bag in environment
  def get_dbag_nodes()
      all_dbag_nodes = []
      begin
        all_dbag_nodes = search(:nodes, "*:*")
      rescue
        Chef::Log.warn "The nodes data bag does not exist!"
      end

      dbag_nodes = []
      all_dbag_nodes.each do |node_spec|
        if node_spec['env'] == node.chef_environment
          dbag_nodes << node_spec['id']
        end
      end

      dbag_nodes.sort!
      return dbag_nodes
  end

 # Build AWS node
  def build_aws_node(node)

    node_spec = data_bag_item('nodes', node)

    # AWS provisioner
    require "chef/provisioning/aws_driver"
    with_driver 'aws::eu-west-1'

    # Chef provisioning
    require 'chef/provisioning'

    with_chef_server Chef::Config[:chef_server_url],
      :client_name => Chef::Config[:node_name],
      :signing_key_filename => Chef::Config[:client_key]

      machine node_spec['id'] do
        machine_options(
          lazy do
            {
              bootstrap_options: {
                key_name: node_spec['aws']['key_name'],
                instance_type: node_spec['aws']['instance_type'],
                security_group_ids: node_spec['aws']['sec_groups'],
                image_id: node_spec['aws']['image_id'],
                subnet: node_spec['aws']['subnet'],
                block_device_mappings: node_spec['aws']['additional_disks'],
                iam_instance_profile: node_spec['aws']['roles']
              },
              convergence_options: {
                chef_version: "12.9.38"
              },
              ssh_username: node_spec['aws']['ssh_user'],
              transport_address_location: node_spec['aws']['transport_address_location'],
              network_interfaces: [
                {
                  network_interface_id: "eth0",
                  device_index: 1,
                  subnet_id: node_spec['aws']['subnet'],
                  delete_on_termination: true
                }
              ],
              aws_tags: { :Environment => node_spec['env'] }
            }
          end #lazy end
        )
          chef_environment node_spec['env']
          run_list node_spec['run_list']
          file "/etc/chef/encrypted_data_bag_secret", @@secret
          file "/etc/chef/trusted_certs/trusted_certs/DigiCert_SHA2_Secure_Server_CA.crt", @@certificate
          file "/etc/hostname" => { :content => node_spec['id'] }
          converge true
        end # machine_options end
      end # machine end
  end # build_aws_node end

  def destroy_aws_node(node)

    # Get nodes spec
    node_spec = data_bag_item('nodes', node)

    # AWS provisioner
    require "chef/provisioning/aws_driver"
    with_driver 'aws::eu-west-1'

    # Chef provisioning
    require 'chef/provisioning'

    with_chef_server Chef::Config[:chef_server_url],
      :client_name => Chef::Config[:node_name],
      :signing_key_filename => Chef::Config[:client_key]

      machine node_spec['id'] do
        action :destroy
      end

  end

  def manage_destroy_aws_node(node)

    # AWS provisioner
    require "chef/provisioning/aws_driver"
    with_driver 'aws::eu-west-1'

    # Chef provisioning
    require 'chef/provisioning'

    with_chef_server Chef::Config[:chef_server_url],
      :client_name => Chef::Config[:node_name],
      :signing_key_filename => Chef::Config[:client_key]

      machine node do
        action :destroy
      end

  end
