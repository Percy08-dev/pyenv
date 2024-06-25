@echo off


rem Usage:
rem   pyenv set <path> - Set the path for the virtual environment
rem   pyenv new <env_name> [python_version] - Create a new virtual environment with optional Python version
rem   pyenv activate <env_name> - Activate the virtual environment
rem   pyenv del <env_name> - Delete the virtual environment
rem   pyenv list - List all virtual environments in the specified path
rem   pyenv versions - Show the list of available Python versions

pushd %cd%

if "%1"=="" goto :usage
if "%1"=="set" goto :set
if "%1"=="new" goto :new
if "%1"=="activate" goto :activate
if "%1"=="del" goto :del
if "%1"=="list" goto :list
if "%1"=="versions" goto :versions
goto :error

:set
if "%2"=="" goto :usage
echo %~2 > "%~dp0path.txt"
echo Path set to %~2
goto :end

:new
if not exist "%~dp0path.txt" (
    echo Path not set. Use 'pyenv set <path>' to set the path.
    goto :cleanup
)
set /p ENV_PATH=<"%~dp0path.txt"
if not exist %ENV_PATH% (
    mkdir %ENV_PATH%
    echo Directory %ENV_PATH% created.
)
cd /d %ENV_PATH%
if "%3"=="" (
    python -m venv %2
    echo Virtual environment %2 created using default Python version.
) else (
    py -%3 -m venv %2
    echo Virtual environment %2 created using Python %3.
)

:activate
if not exist "%~dp0path.txt" (
    echo Path not set. Use 'pyenv set <path>' to set the path.
    goto :end
)
set /p ENV_PATH=<"%~dp0path.txt"
cd /d %ENV_PATH%
if not exist %2\Scripts\activate (
    echo Virtual environment %2 does not exist.
    goto :end
)
echo Activating virtual environment %2
call %2\Scripts\activate.bat
goto :end

:del
if not exist "%~dp0path.txt" (
    echo Path not set. Use 'pyenv set <path>' to set the path.
    goto :end
)
set /p ENV_PATH=<"%~dp0path.txt"
cd /d %ENV_PATH%
if not exist %2 (
    echo Virtual environment %2 does not exist.
    goto :end
)
rd /s /q %2
echo Virtual environment %2 deleted.
goto :end

:list
if not exist "%~dp0path.txt" (
    echo Path not set. Use 'pyenv set <path>' to set the path.
    goto :end
)
set /p ENV_PATH=<"%~dp0path.txt"
cd /d %ENV_PATH%
echo Listing virtual environments:
for /d %%i in (*) do (
    if exist %%i\Scripts (
        echo %%i
    )
)
goto :end

:versions
call py -0p
goto :end


:error
echo Invalid command.
goto :end

:usage
echo Usage:
echo   pyenv set ^<path^> - Set the path for the virtual environment
echo   pyenv new ^<env_name^> [python_version] - Create a new virtual environment with optional Python version
echo   pyenv activate ^<env_name^> - Activate the virtual environment
echo   pyenv del ^<env_name^> - Delete the virtual environment
echo   pyenv list - List all virtual environments in the specified path
echo   pyenv versions - Show the list of available Python versions
goto :end

:end
popd

