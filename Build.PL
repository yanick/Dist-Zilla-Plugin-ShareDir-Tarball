
use strict;
use warnings;

use Module::Build 0.3601;


my %module_build_args = (
  "build_requires" => {
    "Carp" => 0,
    "File::Find" => 0,
    "File::Temp" => 0,
    "Module::Build" => "0.3601",
    "Scalar::Util" => 0,
    "Test::DZil" => 0,
    "Test::More" => "0.94",
    "perl" => "5.004"
  },
  "configure_requires" => {
    "Module::Build" => "0.3601"
  },
  "dist_abstract" => "Bundle your shared dir into a tarball",
  "dist_author" => [
    "Yanick Champoux <yanick\@babyl.dyndns.org>"
  ],
  "dist_name" => "Dist-Zilla-Plugin-ShareDir-Tarball",
  "dist_version" => "0.2.0",
  "license" => "perl",
  "module_name" => "Dist::Zilla::Plugin::ShareDir::Tarball",
  "recommends" => {},
  "recursive_test_files" => 1,
  "requires" => {
    "Archive::Tar" => 0,
    "Compress::Zlib" => 0,
    "Dist::Zilla::File::InMemory" => 0,
    "Dist::Zilla::Role::FileInjector" => 0,
    "Dist::Zilla::Role::FileMunger" => 0,
    "Moose" => 0,
    "strict" => 0,
    "warnings" => 0
  },
  "script_files" => []
);


my $build = Module::Build->new(%module_build_args);

$build->create_build_script;
