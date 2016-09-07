#
# Cookbook Name:: my_provision_aws
# Recipe:: destroy
#
# Copyright 2016
#
# chef-client -z -E <chef_env> -r 'recipe[my_provision_aws::destroy]'
#
# Include helpers
  ::Chef::Recipe.send(:include, ProvHelpers)

# Get all nodes for environment from data bag
  nodes = get_dbag_nodes()

# Destroy nodes
  nodes.each do |node|
      destroy_aws_node(node)
  end
