let s:is_match = execute('syntax case') =~# 'match'
syntax case ignore
syntax match DiffAdd "// nishi.*"
syntax match DiffAdd "CmdStepStart"
syntax match WarningMsg "uec"
syntax match Error "tmf"
" syntax match UnderLined ""
if s:is_match | syntax case match | endif
