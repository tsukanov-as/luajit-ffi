git submodule update --init --recursive love/love
git submodule update --init --recursive love/megasource

$ROOT = (Get-Location).Path.Replace("\", "/")
$LOVE_PATH = "$ROOT/ARTIFACTS_x64/love"
$MEGA_LOVE = "$ROOT/love/love"

cmake -G "Visual Studio 16 2019" -A "x64" -S "./love/megasource" -B "./BUILD/love" -D MEGA_LOVE=$MEGA_LOVE
cmake --build "BUILD/love" --target love/love --config Release

mkdir $LOVE_PATH -Force | Out-Null
$RELEASE = "$ROOT/BUILD/love/love/Release"
cp "$RELEASE/love.exe",
   "$RELEASE/love.dll",
   "$RELEASE/lua51.dll",
   "$RELEASE/mpg123.dll",
   "$RELEASE/OpenAL32.dll",
   "$RELEASE/SDL2.dll" $LOVE_PATH