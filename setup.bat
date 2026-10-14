@echo off
cd /d %~dp0
python -m venv .venv || goto :err
call .venv\Scripts\activate.bat
python -m pip install --upgrade pip
pip install -r requirements.txt || goto :err
python -m ipykernel install --user --name distillation --display-name "Python (distillation)"
echo Done. In VS Code pick kernel "Python (distillation)".
goto :eof
:err
echo Setup failed. Is Python 3.10+ installed and on PATH?
