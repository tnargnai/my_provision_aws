#
# Cookbook Name:: my_provision_aws
# Recipe:: destroy-single
#
# Copyright 2016
#
# This recipe is designed to be used from chef-zero, passing the node name.
#
# chef-client -z -E <chef_env> -r 'recipe[my_provision_aws::destroy-single]' -N <node_name>

# Include helpers
::Chef::Recipe.send(:include, ProvHelpers)

destroy_aws_node(node.name)
