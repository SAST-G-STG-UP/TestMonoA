#!/bin/sh

set -e

dotnet build -c Release ../../Emby.Server.Implementations/Emby.Server.Implementations.csproj --output bin
sharpfuzz bin/Emby.Server.Implementations.dll
cp bin/Emby.Server.Implementations.dll .

dotnet build
mkdir -p Findings
AFL_SKIP_BIN_CHECK=1 afl-fuzz -i "Testcases/$1" -o "Findings/$1" -t 5000 -m 10240 dotnet bin/Debug/net6.0/Emby.Server.Implementations.Fuzz.dll "$1"