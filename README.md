my_provisioning_aws Cookbook
========================

Recipes for use with chef-provisioning to orchestrate multiple builds

## Supported Platforms

This cookbook has recipes for use with vagrant (for testing) as well as vSphere and AWS for actual deployments.
Drivers are also available for Openstack, Azure, Bare Metal and Docker, although these haven't been included here.

## Usage

This cookbook differs from others in that it is intended to be called by chef-zero:

e.g. chef-client -E <env> -z -r 'recipe[mf-provisioning::vsphere]'

Although this can be called my any suitably configured chef workstation, the plan is to call it
from a Jenkins job, passing other required variables (e.g. build number) as json attributes.
If a server already exists, it won't try to rebuild it but just pass through to the chef-client
run on the node. For Hybris nodes it defines a couple of attributes which will instigate an application
rebuild with the latest tag, whereas normal chef runs don't include this. This means we can replace the
deploy_hybris.rb deployment script and just use chef.

## License and Authors

Author:: Andy Wallace (<andy.wallace@matchesfashion.com>)
