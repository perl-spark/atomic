use strict;
use warnings;

use Module::Build;

Module::Build->new(
  module_name => 'atomic',
  license  => 'perl',
  dist_author => 'James Laver <james.laver@gmail.com>',
  dist_abstract => 'Atomic memory operations',
  build_requires => {
    'Module::Build' => 0,
    'ExtUtils::CBuilder' => '0.15',
    'Test::More' => 0,
  },
  requires => {
    'perl' => '5.14.0',
    'XSLoader' => 0
  },
  dynamic_config => 0,
  meta_add => { distribution_type => 'module' },
  create_makefile_pl => 'passthrough',  
)->create_build_script;
