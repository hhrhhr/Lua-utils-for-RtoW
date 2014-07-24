@echo off

set game=f:\SteamLibrary\SteamApps\common\War of the Roses


set packs=2d86d39cfd70734b 2ff804aade2cf156 3ca8c930c6708afd 5d29e57585741a57 5ea97ef46b4361cc 8cd62fb9d5950f5f 9e13b2414b41b842 33c9b8d393acaf70 44bcc04093e5c506 46f4455f4676790b 47ad6b6ed96c97f2 56ac41faae6d21af 66adc2efea8f2608 95ea85a86660c57d 660e0b9f5cc6ff02 938eb165b0545f72 4975ba83a6501228 7585bc30b234d3d9 7786c699abf77a30 8321aa8995d4f918 71221f75f3c050af 680514e023d37cd5 9229959b09a3b4be 518753147e2fc4ea a4fd8ec59148aef4 a6a54d97d065ea79 a6db0de7cf227dfe a286189062e5d554 ab0abf5ac607baf5 ac5c2f0670e5d674 b269cc5420b69598 bca203095653c1ca bd053aae5ff23427 beeefa09068685fa ce181a2776cafe63 e7d6d704989f9c84 e774711a9c0e8b57 e904971801831bb1 ec181385e7000cf1 eccb737d1b0361b7 ecfbda7249b8b06e f8002b8ee7c4cdc2 f9818e292d7614a9 fb170191cf056434

if exist _big rmdir /s /q _big >nul
mkdir _big

for %%i in (%packs%) do (
    echo %%i
    lua\lua.exe lua\1-ungzip.lua "%game%\bundle\%%i" _big\%%i
)

:eof
pause
