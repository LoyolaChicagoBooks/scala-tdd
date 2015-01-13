set xrange [0:8]
set yrange [0:5000]
set xlabel "VM Count"
set ylabel "Seconds"
set boxwidth 0.5 absolute
set xtics 1
set ytics 500
set style fill solid 0.5
set term png
set output "build_perf.png"
plot "build_data.csv" using 1:2 title 'Compilation Time' with boxes fs pattern 1
