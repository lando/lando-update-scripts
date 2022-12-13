for dir in */; do
  cd $dir
  git checkout -- .
  cd ..
done