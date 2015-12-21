$envs = ['development', 'test']

$runner_name  = 'vagrant'
$runner_group = 'vagrant'
$runner_home  = '/home/vagrant'
$runner_path  = "${::runner_home}/.rbenv/shims:${::runner_home}/.rbenv/bin:/usr/local/sbin:/usr/local/bin:/usr/bin:/bin"

$app_name       = 'global_assets'
$app_home       = '/vagrant'

class { '::mcommons': }

class { '::mcommons::ruby':
  version => '2.2.3',
}

class { 'mcommons::ruby::bundle_install': }
class { 'mcommons::ruby::rails': }
class { 'mcommons::ruby::rspec_deps': }
