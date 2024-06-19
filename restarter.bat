@echo off
title Auto OTServ Restarter
echo :: =========================================
echo :: --- AUTO RESTARTER ---
echo :: =========================================
echo ::
echo ::
:begin
canary.exe
echo ::
echo :: =========================================
echo :: --- Reiniciando ---
echo :: =========================================
echo ::
goto begin
:goto begin
