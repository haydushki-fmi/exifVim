syn match tagLabel '^[A-Za-z0-9 /]*'
syn match tagLabelNonEditable '^\[X\][A-Za-z0-9 /]*'

highlight link tagLabel String
highlight link tagLabelNonEditable Comment
