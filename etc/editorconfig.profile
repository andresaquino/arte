# EditorConfig
# LastModf: 20180523.0801

# EditorConfig is awesome
# http://EditorConfig.org
root = true
charset = utf-8
insert_final_newline = true
trim_trailing_whitespace = false

# Unix-style newlines with a newline ending every file
[*]
tab_width = 2
indent_size = 2
indent_style = tab

[*.{sh,shell,start}]
indent_size = 4
tab_width = 4
indent_style = tab

[*.{cnf,conf}]
indent_size = 15
tab_width = 15
indent_style = tab

[*.{yml,yaml}]
indent_size = 8
indent_style = space

[*.{dockerfile,docker}]
indent_size = 4
tab_width = 4
indent_style = tab

[*.{vimrc,vim}]
indent_size = 3
indent_style = space

[*.{md,markdown}]
max_line_length = 80
indent_style = space
indent_size = 4

