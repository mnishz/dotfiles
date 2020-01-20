let s:is_match = execute('syntax case') =~# 'match'
syntax case ignore
syntax match DiffAdd "// nishi*"
syntax match WarningMsg "uec"
syntax match Error "tmf"
if s:is_match | syntax case match | endif
