param([string]$assemblyVersion, [string]$nugetVersion)

if ([string]::IsNullOrEmpty($assemblyVersion)) {$assemblyVersion = "0.0.1"}
if ([string]::IsNullOrEmpty($nugetVersion)) {$nugetVersion = "0.0.1"}

$vswhere = ${Env:\ProgramFiles(x86)} + '\Microsoft Visual Studio\Installer\vswhere'
$msbuild = &$vswhere -products * -requires Microsoft.Component.MSBuild -latest -find MSBuild\**\Bin\MSBuild.exe
$vstest = &$vswhere -products * -latest -find **\TestWindow\**\vstest.console.exe

Write-Host
Write-Host "Assembly version = $assemblyVersion"
Write-Host "Nuget version    = $nugetVersion"
Write-Host "MSBuild path     = $msbuild"
Write-Host

Invoke-WebRequest -Uri "https://dist.nuget.org/win-x86-commandline/latest/nuget.exe" -OutFile "nuget.exe"

.\nuget.exe restore ..\MQTTnet.sln

# Build and execute tests
&$msbuild ..\Tests\MQTTnet.Core.Tests\MQTTnet.Tests.csproj /t:Build /p:Configuration="Release" /p:TargetFramework="netcoreapp3.1" /verbosity:m
&$msbuild ..\Tests\MQTTnet.AspNetCore.Tests\MQTTnet.AspNetCore.Tests.csproj /t:Build /p:Configuration="Release" /p:TargetFramework="netcoreapp3.1" /verbosity:m

&$vstest ..\Tests\MQTTnet.Core.Tests\bin\Release\netcoreapp3.1\MQTTnet.Tests.dll
&$vstest ..\Tests\MQTTnet.AspNetCore.Tests\bin\Release\netcoreapp3.1\MQTTnet.AspNetCore.Tests.dll

# Build the core library
&$msbuild ..\Source\MQTTnet\MQTTnet.csproj /t:Build /p:Configuration="Release" /p:TargetFramework="net452" /p:FileVersion=$assemblyVersion /p:AssemblyVersion=$assemblyVersion /verbosity:m /p:SignAssembly=true /p:AssemblyOriginatorKeyFile=".\..\..\Build\codeSigningKey.pfx"
&$msbuild ..\Source\MQTTnet\MQTTnet.csproj /t:Build /p:Configuration="Release" /p:TargetFramework="net461" /p:FileVersion=$assemblyVersion /p:AssemblyVersion=$assemblyVersion /verbosity:m /p:SignAssembly=true /p:AssemblyOriginatorKeyFile=".\..\..\Build\codeSigningKey.pfx"
&$msbuild ..\Source\MQTTnet\MQTTnet.csproj /t:Build /p:Configuration="Release" /p:TargetFramework="netstandard1.3" /p:FileVersion=$assemblyVersion /p:AssemblyVersion=$assemblyVersion /verbosity:m /p:SignAssembly=true /p:AssemblyOriginatorKeyFile=".\..\..\Build\codeSigningKey.pfx"
&$msbuild ..\Source\MQTTnet\MQTTnet.csproj /t:Build /p:Configuration="Release" /p:TargetFramework="netstandard2.0" /p:FileVersion=$assemblyVersion /p:AssemblyVersion=$assemblyVersion /verbosity:m /p:SignAssembly=true /p:AssemblyOriginatorKeyFile=".\..\..\Build\codeSigningKey.pfx"
&$msbuild ..\Source\MQTTnet\MQTTnet.csproj /t:Build /p:Configuration="Release" /p:TargetFramework="netstandard2.1" /p:FileVersion=$assemblyVersion /p:AssemblyVersion=$assemblyVersion /verbosity:m /p:SignAssembly=true /p:AssemblyOriginatorKeyFile=".\..\..\Build\codeSigningKey.pfx"
&$msbuild ..\Source\MQTTnet\MQTTnet.csproj /t:Build /p:Configuration="Release" /p:TargetFramework="netcoreapp3.1" /p:FileVersion=$assemblyVersion /p:AssemblyVersion=$assemblyVersion /verbosity:m /p:SignAssembly=true /p:AssemblyOriginatorKeyFile=".\..\..\Build\codeSigningKey.pfx"
&$msbuild ..\Source\MQTTnet\MQTTnet.csproj /t:Build /p:Configuration="Release" /p:TargetFramework="uap10.0" /p:FileVersion=$assemblyVersion /p:AssemblyVersion=$assemblyVersion /verbosity:m /p:SignAssembly=true /p:AssemblyOriginatorKeyFile=".\..\..\Build\codeSigningKey.pfx"
&$msbuild ..\Source\MQTTnet\MQTTnet.csproj /t:Build /p:Configuration="Release" /p:TargetFramework="net5.0" /p:FileVersion=$assemblyVersion /p:AssemblyVersion=$assemblyVersion /verbosity:m /p:SignAssembly=true /p:AssemblyOriginatorKeyFile=".\..\..\Build\codeSigningKey.pfx"

# Build the ASP.NET Core 2.0 extension
&$msbuild ..\Source\MQTTnet.AspNetCore\MQTTnet.AspNetCore.csproj /t:Build /p:Configuration="Release" /p:TargetFramework="netstandard2.0" /p:FileVersion=$assemblyVersion /p:AssemblyVersion=$assemblyVersion /verbosity:m /p:SignAssembly=true /p:AssemblyOriginatorKeyFile=".\..\..\Build\codeSigningKey.pfx"
&$msbuild ..\Source\MQTTnet.AspNetCore\MQTTnet.AspNetCore.csproj /t:Build /p:Configuration="Release" /p:TargetFramework="netcoreapp3.1" /p:FileVersion=$assemblyVersion /p:AssemblyVersion=$assemblyVersion /verbosity:m /p:SignAssembly=true /p:AssemblyOriginatorKeyFile=".\..\..\Build\codeSigningKey.pfx"
&$msbuild ..\Source\MQTTnet.AspNetCore\MQTTnet.AspNetCore.csproj /t:Build /p:Configuration="Release" /p:TargetFramework="net5.0" /p:FileVersion=$assemblyVersion /p:AssemblyVersion=$assemblyVersion /verbosity:m /p:SignAssembly=true /p:AssemblyOriginatorKeyFile=".\..\..\Build\codeSigningKey.pfx"

# Build the RPC extension
&$msbuild ..\Source\MQTTnet.Extensions.Rpc\MQTTnet.Extensions.Rpc.csproj /t:Build /p:Configuration="Release" /p:TargetFramework="net452" /p:FileVersion=$assemblyVersion /p:AssemblyVersion=$assemblyVersion /verbosity:m /p:SignAssembly=true /p:AssemblyOriginatorKeyFile=".\..\..\Build\codeSigningKey.pfx"
&$msbuild ..\Source\MQTTnet.Extensions.Rpc\MQTTnet.Extensions.Rpc.csproj /t:Build /p:Configuration="Release" /p:TargetFramework="net461" /p:FileVersion=$assemblyVersion /p:AssemblyVersion=$assemblyVersion /verbosity:m /p:SignAssembly=true /p:AssemblyOriginatorKeyFile=".\..\..\Build\codeSigningKey.pfx"
&$msbuild ..\Source\MQTTnet.Extensions.Rpc\MQTTnet.Extensions.Rpc.csproj /t:Build /p:Configuration="Release" /p:TargetFramework="netstandard1.3" /p:FileVersion=$assemblyVersion /p:AssemblyVersion=$assemblyVersion /verbosity:m /p:SignAssembly=true /p:AssemblyOriginatorKeyFile=".\..\..\Build\codeSigningKey.pfx"
&$msbuild ..\Source\MQTTnet.Extensions.Rpc\MQTTnet.Extensions.Rpc.csproj /t:Build /p:Configuration="Release" /p:TargetFramework="netstandard2.0" /p:FileVersion=$assemblyVersion /p:AssemblyVersion=$assemblyVersion /verbosity:m /p:SignAssembly=true /p:AssemblyOriginatorKeyFile=".\..\..\Build\codeSigningKey.pfx"
&$msbuild ..\Source\MQTTnet.Extensions.Rpc\MQTTnet.Extensions.Rpc.csproj /t:Build /p:Configuration="Release" /p:TargetFramework="netstandard2.1" /p:FileVersion=$assemblyVersion /p:AssemblyVersion=$assemblyVersion /verbosity:m /p:SignAssembly=true /p:AssemblyOriginatorKeyFile=".\..\..\Build\codeSigningKey.pfx"
&$msbuild ..\Source\MQTTnet.Extensions.Rpc\MQTTnet.Extensions.Rpc.csproj /t:Build /p:Configuration="Release" /p:TargetFramework="uap10.0" /p:FileVersion=$assemblyVersion /p:AssemblyVersion=$assemblyVersion /verbosity:m /p:SignAssembly=true /p:AssemblyOriginatorKeyFile=".\..\..\Build\codeSigningKey.pfx"
&$msbuild ..\Source\MQTTnet.Extensions.Rpc\MQTTnet.Extensions.Rpc.csproj /t:Build /p:Configuration="Release" /p:TargetFramework="net5.0" /p:FileVersion=$assemblyVersion /p:AssemblyVersion=$assemblyVersion /verbosity:m /p:SignAssembly=true /p:AssemblyOriginatorKeyFile=".\..\..\Build\codeSigningKey.pfx"

# Build the Managed Client extension
&$msbuild ..\Source\MQTTnet.Extensions.ManagedClient\MQTTnet.Extensions.ManagedClient.csproj /t:Build /p:Configuration="Release" /p:TargetFramework="net452" /p:FileVersion=$assemblyVersion /p:AssemblyVersion=$assemblyVersion /verbosity:m /p:SignAssembly=true /p:AssemblyOriginatorKeyFile=".\..\..\Build\codeSigningKey.pfx"
&$msbuild ..\Source\MQTTnet.Extensions.ManagedClient\MQTTnet.Extensions.ManagedClient.csproj /t:Build /p:Configuration="Release" /p:TargetFramework="net461" /p:FileVersion=$assemblyVersion /p:AssemblyVersion=$assemblyVersion /verbosity:m /p:SignAssembly=true /p:AssemblyOriginatorKeyFile=".\..\..\Build\codeSigningKey.pfx"
&$msbuild ..\Source\MQTTnet.Extensions.ManagedClient\MQTTnet.Extensions.ManagedClient.csproj /t:Build /p:Configuration="Release" /p:TargetFramework="netstandard1.3" /p:FileVersion=$assemblyVersion /p:AssemblyVersion=$assemblyVersion /verbosity:m /p:SignAssembly=true /p:AssemblyOriginatorKeyFile=".\..\..\Build\codeSigningKey.pfx"
&$msbuild ..\Source\MQTTnet.Extensions.ManagedClient\MQTTnet.Extensions.ManagedClient.csproj /t:Build /p:Configuration="Release" /p:TargetFramework="netstandard2.0" /p:FileVersion=$assemblyVersion /p:AssemblyVersion=$assemblyVersion /verbosity:m /p:SignAssembly=true /p:AssemblyOriginatorKeyFile=".\..\..\Build\codeSigningKey.pfx"
&$msbuild ..\Source\MQTTnet.Extensions.ManagedClient\MQTTnet.Extensions.ManagedClient.csproj /t:Build /p:Configuration="Release" /p:TargetFramework="netstandard2.1" /p:FileVersion=$assemblyVersion /p:AssemblyVersion=$assemblyVersion /verbosity:m /p:SignAssembly=true /p:AssemblyOriginatorKeyFile=".\..\..\Build\codeSigningKey.pfx"
&$msbuild ..\Source\MQTTnet.Extensions.ManagedClient\MQTTnet.Extensions.ManagedClient.csproj /t:Build /p:Configuration="Release" /p:TargetFramework="uap10.0" /p:FileVersion=$assemblyVersion /p:AssemblyVersion=$assemblyVersion /verbosity:m /p:SignAssembly=true /p:AssemblyOriginatorKeyFile=".\..\..\Build\codeSigningKey.pfx"
&$msbuild ..\Source\MQTTnet.Extensions.ManagedClient\MQTTnet.Extensions.ManagedClient.csproj /t:Build /p:Configuration="Release" /p:TargetFramework="net5.0" /p:FileVersion=$assemblyVersion /p:AssemblyVersion=$assemblyVersion /verbosity:m /p:SignAssembly=true /p:AssemblyOriginatorKeyFile=".\..\..\Build\codeSigningKey.pfx"

# Build the WebSocket4Net extension
&$msbuild ..\Source\MQTTnet.Extensions.WebSocket4Net\MQTTnet.Extensions.WebSocket4Net.csproj /t:Build /p:Configuration="Release" /p:TargetFramework="net452" /p:FileVersion=$assemblyVersion /p:AssemblyVersion=$assemblyVersion /verbosity:m /p:SignAssembly=true /p:AssemblyOriginatorKeyFile=".\..\..\Build\codeSigningKey.pfx"
&$msbuild ..\Source\MQTTnet.Extensions.WebSocket4Net\MQTTnet.Extensions.WebSocket4Net.csproj /t:Build /p:Configuration="Release" /p:TargetFramework="net461" /p:FileVersion=$assemblyVersion /p:AssemblyVersion=$assemblyVersion /verbosity:m /p:SignAssembly=true /p:AssemblyOriginatorKeyFile=".\..\..\Build\codeSigningKey.pfx"
&$msbuild ..\Source\MQTTnet.Extensions.WebSocket4Net\MQTTnet.Extensions.WebSocket4Net.csproj /t:Build /p:Configuration="Release" /p:TargetFramework="netstandard1.3" /p:FileVersion=$assemblyVersion /p:AssemblyVersion=$assemblyVersion /verbosity:m /p:SignAssembly=true /p:AssemblyOriginatorKeyFile=".\..\..\Build\codeSigningKey.pfx"
&$msbuild ..\Source\MQTTnet.Extensions.WebSocket4Net\MQTTnet.Extensions.WebSocket4Net.csproj /t:Build /p:Configuration="Release" /p:TargetFramework="netstandard2.0" /p:FileVersion=$assemblyVersion /p:AssemblyVersion=$assemblyVersion /verbosity:m /p:SignAssembly=true /p:AssemblyOriginatorKeyFile=".\..\..\Build\codeSigningKey.pfx"
&$msbuild ..\Source\MQTTnet.Extensions.WebSocket4Net\MQTTnet.Extensions.WebSocket4Net.csproj /t:Build /p:Configuration="Release" /p:TargetFramework="netstandard2.1" /p:FileVersion=$assemblyVersion /p:AssemblyVersion=$assemblyVersion /verbosity:m /p:SignAssembly=true /p:AssemblyOriginatorKeyFile=".\..\..\Build\codeSigningKey.pfx"
&$msbuild ..\Source\MQTTnet.Extensions.WebSocket4Net\MQTTnet.Extensions.WebSocket4Net.csproj /t:Build /p:Configuration="Release" /p:TargetFramework="uap10.0" /p:FileVersion=$assemblyVersion /p:AssemblyVersion=$assemblyVersion /verbosity:m /p:SignAssembly=true /p:AssemblyOriginatorKeyFile=".\..\..\Build\codeSigningKey.pfx"
&$msbuild ..\Source\MQTTnet.Extensions.WebSocket4Net\MQTTnet.Extensions.WebSocket4Net.csproj /t:Build /p:Configuration="Release" /p:TargetFramework="net5.0" /p:FileVersion=$assemblyVersion /p:AssemblyVersion=$assemblyVersion /verbosity:m /p:SignAssembly=true /p:AssemblyOriginatorKeyFile=".\..\..\Build\codeSigningKey.pfx"

# Create NuGet packages.

Remove-Item .\NuGet -Force -Recurse -ErrorAction SilentlyContinue

$gitCommit = git log -1 --format=%h

Copy-Item MQTTnet.nuspec -Destination MQTTnet.nuspec.old -Force
(Get-Content MQTTnet.nuspec) -replace '\$gitCommit', $gitCommit | Set-Content MQTTnet.nuspec
Copy-Item MQTTnet.AspNetCore.nuspec -Destination MQTTnet.AspNetCore.nuspec.old -Force
(Get-Content MQTTnet.AspNetCore.nuspec) -replace '\$nugetVersion', $nugetVersion | Set-Content MQTTnet.AspNetCore.nuspec
Copy-Item MQTTnet.Extensions.Rpc.nuspec -Destination MQTTnet.Extensions.Rpc.nuspec.old -Force
(Get-Content MQTTnet.Extensions.Rpc.nuspec) -replace '\$nugetVersion', $nugetVersion | Set-Content MQTTnet.Extensions.Rpc.nuspec
Copy-Item MQTTnet.Extensions.ManagedClient.nuspec -Destination MQTTnet.Extensions.ManagedClient.nuspec.old -Force
(Get-Content MQTTnet.Extensions.ManagedClient.nuspec) -replace '\$nugetVersion', $nugetVersion | Set-Content MQTTnet.Extensions.ManagedClient.nuspec
Copy-Item MQTTnet.Extensions.WebSocket4Net.nuspec -Destination MQTTnet.Extensions.WebSocket4Net.nuspec.old -Force
(Get-Content MQTTnet.Extensions.WebSocket4Net.nuspec) -replace '\$nugetVersion', $nugetVersion | Set-Content MQTTnet.Extensions.WebSocket4Net.nuspec

New-Item -ItemType Directory -Force -Path .\NuGet
.\nuget.exe pack MQTTnet.nuspec -Verbosity detailed -Symbols -SymbolPackageFormat snupkg -OutputDir "NuGet" -Version $nugetVersion
.\nuget.exe pack MQTTnet.AspNetCore.nuspec -Verbosity detailed -Symbols -SymbolPackageFormat snupkg -OutputDir "NuGet" -Version $nugetVersion
.\nuget.exe pack MQTTnet.Extensions.Rpc.nuspec -Verbosity detailed -Symbols -SymbolPackageFormat snupkg -OutputDir "NuGet" -Version $nugetVersion
.\nuget.exe pack MQTTnet.Extensions.ManagedClient.nuspec -Verbosity detailed -Symbols -SymbolPackageFormat snupkg -OutputDir "NuGet" -Version $nugetVersion
.\nuget.exe pack MQTTnet.Extensions.WebSocket4Net.nuspec -Verbosity detailed -Symbols -SymbolPackageFormat snupkg -OutputDir "NuGet" -Version $nugetVersion

Move-Item MQTTnet.nuspec.old -Destination MQTTnet.nuspec -Force
Move-Item MQTTnet.AspNetCore.nuspec.old -Destination MQTTnet.AspNetCore.nuspec -Force
Move-Item MQTTnet.Extensions.Rpc.nuspec.old -Destination MQTTnet.Extensions.Rpc.nuspec -Force
Move-Item MQTTnet.Extensions.ManagedClient.nuspec.old -Destination MQTTnet.Extensions.ManagedClient.nuspec -Force
Move-Item MQTTnet.Extensions.WebSocket4Net.nuspec.old -Destination MQTTnet.Extensions.WebSocket4Net.nuspec -Force

Remove-Item "nuget.exe" -Force -Recurse -ErrorAction SilentlyContinue