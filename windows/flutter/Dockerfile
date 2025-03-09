# escape=`

ARG base_image_tag=wsc2022

FROM ky1vstar/flutter-tools:${base_image_tag}

ARG flutter_version
ARG flutter_channel

# Install Google Root R1 cert so pub.dartlang.org stays working
ADD https://pki.goog/repo/certs/gtsr1.pem C:/TEMP/gtsr1.pem
RUN powershell.exe -Command `
        Import-Certificate -FilePath C:\TEMP\gtsr1.pem -CertStoreLocation Cert:\LocalMachine\Root

# Install Flutter
RUN setx path "%path%;C:\flutter\bin;C:\flutter\bin\cache\dart-sdk\bin;"

ADD https://storage.googleapis.com/flutter_infra_release/releases/${flutter_channel}/windows/flutter_windows_${flutter_version}-${flutter_channel}.zip C:/TEMP/flutter_windows.zip
RUN powershell.exe -Command Expand-Archive -LiteralPath C:\TEMP\flutter_windows.zip -DestinationPath C:\
RUN del /q C:\TEMP\*.*

RUN flutter config --no-analytics

RUN flutter config --enable-windows-desktop

RUN flutter precache --windows

RUN flutter doctor -v