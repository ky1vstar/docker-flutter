ARG server_version=2022

# Base image on microsoft/dotnet-framework:4.7.1 or later as adviced by Microsoft.
# https://docs.microsoft.com/en-us/visualstudio/install/build-tools-container-issues
FROM mcr.microsoft.com/dotnet/framework/runtime:4.8-windowsservercore-ltsc${server_version}

# VS 2019 = 16, VS 2022 = 17
ARG vs_buildtools_version=17

## https://github.com/cirruslabs/docker-images-windows/blob/41b4e03c85b1f8a50d866f2eb47ba3e8af17cbf5/windowsservercore/Dockerfile
RUN powershell -NoLogo -NoProfile -Command \
    netsh interface ipv4 show interfaces ; \
    netsh interface ipv4 set subinterface 18 mtu=1460 store=persistent ; \
    netsh interface ipv4 show interfaces ; \
    Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1')) ; \
    choco install -y --no-progress git --parameters="/GitAndUnixToolsOnPath" ; \
    choco install -y --no-progress 7zip ; \
    Remove-Item C:\ProgramData\chocolatey\logs\* -Force -Recurse ; \
    Remove-Item $Env:localappdata\NuGet\v3-cache\* -Force -Recurse ;

## https://github.com/cirruslabs/docker-images-android/blob/cd2a41ec49be26c3e5482546385a55a32183f334/sdk/tools-windowsservercore-2019/Dockerfile
RUN powershell.exe -Command \
    git config --global user.email "support@cirruslabs.org"; \
    git config --global user.name "Cirrus CI";

# Install VS
## https://docs.microsoft.com/en-us/visualstudio/install/build-tools-container?view=vs-2019
## https://learn.microsoft.com/en-us/visualstudio/install/build-tools-container?view=vs-2022

## Restore the default Windows shell for correct batch processing.
SHELL ["cmd", "/S", "/C"]

## https://docs.microsoft.com/en-us/visualstudio/install/workload-component-id-vs-build-tools?view=vs-2019
## https://learn.microsoft.com/en-us/visualstudio/install/workload-component-id-vs-build-tools?view=vs-2022
RUN \
    # Download the Build Tools bootstrapper.
    curl -SL --output vs_buildtools.exe https://aka.ms/vs/${vs_buildtools_version}/release/vs_buildtools.exe \
    \
    # Install Build Tools with the Microsoft.VisualStudio.Workload.VCTool workload, includingWindows SDK 10.0.19041 required by Flutter.
    && (start /w vs_buildtools.exe --quiet --wait --norestart --nocache \
        --installPath "C:\BuildTools" \
        --add Microsoft.VisualStudio.Workload.VCTools \
        --add Microsoft.VisualStudio.Component.Windows10SDK.19041 \
        --add Microsoft.VisualStudio.Component.VC.Tools.x86.x64 \
        --add Microsoft.VisualStudio.Component.VC.CMake.Project \
        --add Microsoft.VisualStudio.Workload.NativeDesktop \
        --add Microsoft.VisualStudio.Workload.ManagedDesktopBuildTools \
        --add Microsoft.VisualStudio.Component.VC.CLI.Support \
        || IF "%ERRORLEVEL%"=="3010" EXIT 0) \
    \
    # Cleanup
    && del /q vs_buildtools.exe

