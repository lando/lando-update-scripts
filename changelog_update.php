<?php
function str_replace_file($search, $replace, $file)
{
    $doc = file_get_contents($file);
    $new_string = str_replace($search, $replace, $doc);
    file_put_contents($file, $new_string);
}
$working_dir = $argv[1];
// Replace
$doc_path = __DIR__ . "/{$working_dir}/CHANGELOG.md";
$doc = file_get_contents($doc_path);
$search = "## {{ UNRELEASED_VERSION }} - [{{ UNRELEASED_DATE }}]({{ UNRELEASED_LINK }})";
$replace = "## {{ UNRELEASED_VERSION }} - [{{ UNRELEASED_DATE }}]({{ UNRELEASED_LINK }})

  - Updated lando/mysql to $argv[2].";
str_replace_file($search, $replace, $doc_path);

?>