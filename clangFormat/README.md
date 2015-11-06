## Code Style
The clang format pre-commit hook will execute clang-format on your code after you commit and inform you if there were any style violations. All files can be found here: [Code Style](https://github.com/Raizlabs/Raizlabs-Cocoa-Style/tree/master/clangFormat)

 - Download the private clang-format binary, copy it into some directory in your `$PATH` list.
 - Depending on how you download, you may need to do one or both of:
  - `chmod +x /path/to/clang-format`
  - `xattr -d com.apple.quarantine /path/to/clang-format`
 - Copy the pre-commit hook into {project path}/.git/hooks/ directory of your project.
 - Rename rz-clang-format to {project path}/.clang-format 
 
To format a bunch of files, `find swapp -iname "*.[mh]" | xargs -I {} clang-format -i {}`
