import sys
import pyuefivars.edk2
store = pyuefivars.edk2.EDK2UEFIVarStore(sys.stdin.buffer.read())
for i, var in enumerate(store.vars):
    if var.name == "SbatLevel":
        print(var.data)
