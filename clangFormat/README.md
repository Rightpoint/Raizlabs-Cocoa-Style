## Code Style
The clang format pre-commit hook will execute clang-format on your code after you commit and inform you if there were any style violations.  All files can be found here: [Code Style](https://github.com/Raizlabs/Raizlabs-Cocoa-Style/tree/master/clangFormat)

 - Download the private clang-format binary, copy it into /usr/local/bin/ and chmod +x it.
 - Copy the pre-commit hook into {project path}/.git/hooks/ directory of your project.
 - Rename rz-clang-format to {project path}/.clang-format 
 
To format a bunch of files, `find swapp -iname "*.mh" | xargs -I {} clang-format -i {}`

