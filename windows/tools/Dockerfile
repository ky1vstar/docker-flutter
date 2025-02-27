ARG server_version=2022

# Base image on microsoft/dotnet-framework:4.7.1 or later as adviced by Microsoft.
# https://docs.microsoft.com/en-us/visualstudio/install/build-tools-container-issues
FROM mcr.microsoft.com/dotnet/framework/runtime:4.8-windowsservercore-ltsc${server_version}

ARG server_version

## https://github.com/cirruslabs/docker-images-windows/blob/41b4e03c85b1f8a50d866f2eb47ba3e8af17cbf5/windowsservercore/Dockerfile
RUN powershell -NoLogo -NoProfile -Command \
    netsh interface ipv4 show interfaces ; \
    netsh interface ipv4 set subinterface 18 mtu=1460 store=persistent ; \
    netsh interface ipv4 show interfaces ; \
    Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1')) ; \
    choco install -y --no-progress git --parameters="/GitAndUnixToolsOnPath" ; \
    choco install -y --no-progress 7zip ; \
    Remove-Item C:\ProgramData\chocolatey\logs\* -Force -Recurse ; \
    Remove-Item $Env:localappdata\Nuget\Cache\*nupkg ; \
    Remove-Item $Env:temp\* -Force -Recurse;

## https://github.com/cirruslabs/docker-images-android/blob/cd2a41ec49be26c3e5482546385a55a32183f334/sdk/tools-windowsservercore-2019/Dockerfile
RUN powershell.exe -Command \
    git config --global user.email "support@cirruslabs.org"; \
    git config --global user.name "Cirrus CI";

# Install VS
## https://docs.microsoft.com/en-us/visualstudio/install/build-tools-container?view=vs-2019

## Restore the default Windows shell for correct batch processing.
SHELL ["cmd", "/S", "/C"]

## Download the Build Tools bootstrapper.
ADD https://aka.ms/vs/16/release/channel C:/TEMP/VisualStudio.chman

ADD https://aka.ms/vs/16/release/vs_buildtools.exe C:/TEMP/vs_buildtools.exe
## https://docs.microsoft.com/en-us/visualstudio/install/workload-component-id-vs-build-tools?view=vs-2019
RUN C:\TEMP\vs_buildtools.exe --quiet --wait --norestart --nocache \
    --channelUri C:\TEMP\VisualStudio.chman \
    --installChannelUri C:\TEMP\VisualStudio.chman \
    --add Microsoft.VisualStudio.Component.Windows10SDK.19041 \
    --add Microsoft.VisualStudio.Component.VC.Tools.x86.x64 \
    --add Microsoft.VisualStudio.Component.VC.CMake.Project \
    --add Microsoft.VisualStudio.Workload.NativeDesktop \
    --add Microsoft.VisualStudio.Workload.ManagedDesktopBuildTools \
    --add Microsoft.VisualStudio.Workload.VCTools \
    --add Microsoft.VisualStudio.Component.VC.CLI.Support \
    --installPath C:\BuildTools \
     || IF "%ERRORLEVEL%"=="3010" EXIT 0

## Fix android sdk licenses (missing in cirruslabs container)
RUN powershell.exe -Command \
        Set-Content -Value "`n859f317696f67ef3d7f30a50a5560e7834b43903" -Path C:\Android\licenses\android-sdk-arm-dbt-license
