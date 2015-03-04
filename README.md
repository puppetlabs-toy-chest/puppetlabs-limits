# Limits module for Puppet

## Description
Module for managing pam limits in /etc/security/limits.conf

## Usage

### limits::fragment

<pre>
  limits::fragment {
    "*/soft/nofile":
      value => "1024";
    "*/hard/nofile":
      value => "8192";
  }
</pre>

You can also use hiera with this module, to match the example above, you can use the following configuration

In your hiera/host yaml configuration: 

<pre>
---
limits::fragment:
  "*/soft/nofile":
    value: '1024'
  "*/hard/nofile":
    value: '8192'
</pre>

Your site.pp or other configuration should include the following:

<pre>
$limits = hiera('limits::fragment', {})
create_resources('limits::fragment', $limits)
</pre>
    
