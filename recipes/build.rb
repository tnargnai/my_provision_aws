#
# Cookbook Name:: my_provision_aws
# Recipe:: build
#
# Copyright 2016
#
# This recipe is designed to be used from chef-zero.
#
# chef-client -z -E <chef_env> -r 'recipe[my_provision_aws::build]'
#
# Include helpers
  ::Chef::Recipe.send(:include, ProvHelpers)

# Get all nodes for environment from data bag
  nodes = get_dbag_nodes()

# Build nodes
  nodes.each do |node|
      build_aws_node(node)
  end
