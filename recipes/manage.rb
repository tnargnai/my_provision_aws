#
# Cookbook Name:: my_provision_aws
# Recipe:: manage
#
# Copyright 2016
#
# This recipe is designed to be used from chef-zero.
#
# chef-client -z -E <chef_env> -r 'recipe[mf-provisioning::manage]'
#
# Include helpers
  ::Chef::Recipe.send(:include, ProvHelpers)

# AWS provisioner
  require "chef/provisioning/aws_driver"
  with_driver 'aws::eu-west-1'

# Get active nodes for environment from Chef server
  chef_nodes = get_env_nodes(node.chef_environment)

# Get all nodes for environment from data bag
  dbag_nodes = get_dbag_nodes()

# Nodes to add
  nodes_to_add = dbag_nodes - chef_nodes
  if !nodes_to_add.empty?
    # Add Nodes
    nodes_to_add.each do |node|
        build_aws_node(node)
    end
  end

# Nodes to destroy
 nodes_to_destroy =  chef_nodes - dbag_nodes
 if !nodes_to_destroy.empty?
   # Destroy Nodes
   nodes_to_destroy.each do |node|
       manage_destroy_aws_node(node)
   end
 end
