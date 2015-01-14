all: build_perf.png

clean:
	rm -f build_perf.png

build_perf.png: build_perf.plot build_data.csv
	rm -f build_perf.png
	gnuplot build_perf.plot
