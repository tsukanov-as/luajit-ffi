git submodule update --init --recursive freetype
git submodule update --init --recursive LuaJIT
git submodule update --init --recursive LuaJIT-GLFW
git submodule update --init --recursive LuaJIT-ImGui
git submodule update --init --recursive SDL

$ROOT = (Get-Location).Path.Replace("\", "/")
$SDL_PATH = "$ROOT/ARTIFACTS_x64/sdl"
$GLFW_PATH = "$ROOT/ARTIFACTS_x64/glfw"
$FREETYPE_PATH = "$ROOT/ARTIFACTS_x64/freetype"
$LUAJIT_PATH = "$ROOT/ARTIFACTS_x64/luajit"

mkdir $LUAJIT_PATH -Force | Out-Null

cmd /c '"C:\Program Files (x86)\Microsoft Visual Studio\2019\Community\VC\Auxiliary\Build\vcvars64.bat" && cd .\LuaJIT\src && msvcbuild.bat'
cp ./LuaJIT/src/luajit.exe, ./LuaJIT/src/lua51.dll $LUAJIT_PATH

cp "./luafilesystem/lfs.lua", "./luafilesystem/lfs_ffi.lua" $LUAJIT_PATH/lua

cmake -G "Visual Studio 16 2019" -A "x64" -S "./SDL" -B "./BUILD/sdl" -D CMAKE_INSTALL_PREFIX:PATH=$SDL_PATH
cmake --build "BUILD/sdl" --target INSTALL --config Release
cp "$SDL_PATH/bin/SDL2.dll" $LUAJIT_PATH

# cmake -G "Visual Studio 16 2019" -A "x64" -S "./glfw" -B "./BUILD/glfw" -D BUILD_SHARED_LIBS=ON -D CMAKE_INSTALL_PREFIX:PATH=$GLFW_PATH
# cmake --build "BUILD/glfw" --target INSTALL --config Release

cmake -G "Visual Studio 16 2019" -A "x64" -S "./LuaJIT-GLFW" -B "./BUILD/glfw" -D LUAJIT_BIN=$LUAJIT_PATH -D CMAKE_INSTALL_PREFIX:PATH=$GLFW_PATH
cmake --build "BUILD/glfw" --target INSTALL --config Release
cmake --build "BUILD/glfw" --target GLFW/INSTALL --config Release

cmake -G "Visual Studio 16 2019" -A "x64" -S "./freetype" -B "./BUILD/freetype" -D CMAKE_INSTALL_PREFIX:PATH=$FREETYPE_PATH
cmake --build "BUILD/freetype" --target INSTALL --config Release

cmake -G "Visual Studio 16 2019" -A "x64" -S "./LuaJIT-ImGui" -B "./BUILD/imgui" -D IMGUI_FREETYPE=ON -D FREETYPE_PATH=$FREETYPE_PATH -D GLFW_PATH=$GLFW_PATH -D SDL_PATH=$SDL_PATH -D LUAJIT_BIN=$LUAJIT_PATH
cmake --build "BUILD/imgui" --target INSTALL --config Release