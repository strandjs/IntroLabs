@ECHO OFF
REM change directory to pull proper.git
cd c:\IntroLabs
REM pull an updated version of the repo
git pull https://github.com/strandjs/IntroLabs
REM open the lab html in the default browser
C:\IntroLabs\IntroClassFiles\index.html