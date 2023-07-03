<?php
function str_replace_file($search, $replace, $file)
{
    $doc = file_get_contents($file);
    $new_string = str_replace($search, $replace, $doc);
    file_put_contents($file, $new_string);
}
$working_dir = $argv[1];
// Replace
$doc_path = __DIR__ . "/{$working_dir}.github/workflows/release.yml";
$doc = file_get_contents($doc_path);
$search = "run: yarn test:unit";
$replace = "run: yarn test:unit

      # Prepare release.
      - name: Prepare release
        uses: lando/prepare-release-action@v2
        with:
          lando-plugin: true";
str_replace_file($search, $replace, $doc_path);

// Remove the release script
$doc_path = __DIR__ . "/{$working_dir}package.json";
$package_search = '"lint": "eslint --quiet . && yarn docs:lint",
    "release": "bundle-dependencies update && bump --prompt --tag --all --push",';
$package_replace = '"lint": "eslint --quiet . && yarn docs:lint",';
str_replace_file($package_search, $package_replace, $doc_path);

// Update Documentation
$doc_path = __DIR__ . "/{$working_dir}docs/development.md";
$doc_search = "That said, in order to create a release and succesfully publish it to `npm` you will want to make sure:

* You have tagged the commit you want to deploy in `git` and pushed it up to GitHub
* You have bumped the version in your `package.json` so that it doesn't collide with a version already published to `npm`

In order to help with the above we recommend you run the convience command `yarn release` which will take care of both.";

$doc_replace = "The GitHub release will automatically [prepare the release](https://github.com/lando/prepare-release-action) and deploy it to NPM, so make sure to use the correct semantic version for the release title (ex: \`v0.8.0\`).";
str_replace_file($doc_search, $doc_replace, $doc_path);


?>