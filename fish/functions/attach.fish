# Defined in - @ line 1
function attach --wraps='abduco -A main dvtm-status' --description 'alias attach=abduco -A main dvtm-status'
  abduco -A main dvtm-status $argv;
end
