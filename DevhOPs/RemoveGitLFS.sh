#from https://github.com/git-lfs/git-lfs/issues/3026	
function waitForAnyKey
{
read -p "Press enter to continue"
echo "Done"
}

echo "commit & push everything"
 git add.
git commit -m "pre lfs removal final commit"
waitForAnyKey

echo "remove hooks"
git lfs uninstall
echo "remove lfs stuff from .gitattributes"
echo "list lfs files using"
git lfs ls-files | sed -r 's/^.{13}//' > files.txt
waitForAnyKey

echo "run git rm --cached for each file"
while read line; do git rm --cached "$line"; done < files.txt
waitForAnyKey

echo "run git add for each file"
while read line; do git add "$line"; done < files.txt
waitForAnyKey

echo "commit everything"
git add .gitattributes
git commit -m "unlfs"
git push origin
waitForAnyKey

echo  "check that no lfs files left"
git lfs ls-files
waitForAnyKey

echo "remove junk"
rm -rf .git/lfs
rm files.txt
waitForAnyKey


