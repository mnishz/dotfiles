let s:is_match = execute('syntax case') =~# 'match'
syntax case ignore
syntax match DiffAdd "nishi.*"
syntax match Statement "DR[ _]CmdStepStart"
syntax match Identifier "CE[ _]rw[ _]analyze\(_exit\)\? "
syntax match Special "SingleSectorRecovery"
syntax match WarningMsg "uec"
syntax match Error "tmf\(CmdCode\)\?"
syntax match Error "EINJ[ _]ForceServoError"
syntax match Error "EINJ[ _]ErrorLocationFound"
syntax match Error "DR[ _]prevent[ _]drive[ _]start"
syntax match Error "send[ _]special"
" syntax match UnderLined ""
if s:is_match | syntax case match | endif
