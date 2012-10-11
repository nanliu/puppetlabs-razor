# Say you want to tell Razor that you're going to build two servers which
# should have the hostname_prefix 'ldap'. Unfortunately, those two facts are in
# different places - you need to define a new Model and also a new Policy and
# keep them in sync. This type removes some of the duplication.
#
# == Parameters
# As per the rz_model and rz_policy types, except:
#
# puppet_tag: pussed as tag to each resource
# model_template, policy_template: passed as template to rz_model and rz_policy
#   respectively.
# policy_tags: passed as tags to the policy
#
define razor::node_type (
  $broker,
  $enabled,
  $ensure,
  $image,
  $maximum,
  $metadata,
  $model_template,
  $policy_tags,
  $policy_template,
  $puppet_tag,
) {

  rz_model {"${name}_model":
    ensure   => $ensure,
    image    => $image,
    metadata => $metadata,
    template => $model_template,
    tag      => $puppet_tag,
  }

  rz_policy {"${name}_policy":
    ensure   => $ensure,
    broker   => $broker,
    model    => "${name}_model",
    enabled  => $enabled,
    tags     => $policy_tags,
    template => $policy_template,
    tag      => $puppet_tag,
    maximum  => $maximum,
  }
}
