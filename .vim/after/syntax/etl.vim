let s:is_match = execute('syntax case') =~# 'match'
syntax case ignore
syntax match DiffAdd "// nishi.*"
syntax match Statement "DR[ _]CmdStepStart"
syntax match Identifier "CE[ _]rw[ _]analyze\(_exit\)\? "
syntax match Special "SingleSectorRecovery"
syntax match WarningMsg "uec"
syntax match Error "tmf"
syntax match Error "EINJ[ _]add[ _]error"
syntax match Error "DR[ _]prevent[ _]drive[ _]start"
" syntax match UnderLined ""
if s:is_match | syntax case match | endif
