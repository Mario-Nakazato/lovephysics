@setlocal
@echo off
set path="c:\Arquivos de Programas\winrar\";%path%
winrar.exe a root.zip conf.lua main.lua src
rename root.zip game.love
copy /b love.exe+game.love run.exe
del game.love
start run.exe