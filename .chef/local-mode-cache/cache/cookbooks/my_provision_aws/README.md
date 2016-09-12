my_provisioning_aws Cookbook
========================

Recipes for use with chef-provisioning to orchestrate multiple builds

## Supported Platforms

AWS

## Usage

This cookbook differs from others in that it is intended to be called by chef-zero:

e.g. chef-client -E <env> -z -r 'recipe[my_provision_aws::build]'

Although this can be called my any suitably configured chef workstation, the plan is to call it
from a Jenkins job, passing other required variables (e.g. build number) as json attributes.
If a server already exists, it won't try to rebuild it but just pass through to the chef-client
run on the node.
