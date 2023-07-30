syn match tagLabel '^[A-Za-z0-9 /]*'
syn match tagNonEditable '^\[X\].*'

highlight link tagLabel String
highlight link tagNonEditable Comment
