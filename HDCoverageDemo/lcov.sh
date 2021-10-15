lcov -c -d . -o hdcoverage.info

if [ $? -eq 0 ]; then
	genhtml -o html hdcoverage.info
else
	echo "lcov faild"
fi