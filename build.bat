del main.exe

del main.obj
del main.lib
del main.exp
\masm32\bin\ml /c /coff main.asm
\masm32\bin\rc /v msc/rsrc.rc
\masm32\bin\Cvtres.exe /machine:ix86 msc/rsrc.res
\masm32\bin\Link /SUBSYSTEM:WINDOWS main.obj msc/rsrc.obj
cd msc

del rsrc.res
del rsrc.obj
cd ..
del main.obj
main.exe
pause