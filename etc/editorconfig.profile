# EditorConfig is awesome
# http://EditorConfig.org
root = true
charset = utf-8
insert_final_newline = true
trim_trailing_whitespace = false

# Unix-style newlines with a newline ending every file
[*]
indent_size = 3
indent_style = space

[*.{sh,shell,start,profile}]
indent_size = 2
indent_style = space

[*.{cnf,conf}]
tab_width = 15
indent_style = tab

[*.{yml,yaml}]
indent_size = 8
indent_style = space

[*.{dockerfile,docker}]
indent_size = 4
indent_style = space

[*.{md,markdown}]
max_line_length = 100
indent_style = space
indent_size = 4

