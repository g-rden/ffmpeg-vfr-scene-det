#!/bin/sh

#USAGE:
#./getframes [scene value] [video file]

scene="$1"
input="$2"
img_nbr=0
pts_time_prev=0

#output first frame
ffmpeg -i "$input" -vframes 1 img/img0.png
#output all other detected frames
ffmpeg -i "$input" -filter_complex "select='gt(scene,$scene)',metadata='print:file=time.txt'" -vsync vfr img/img%00d.png

#clear file
printf '' > concat.txt

#write to concat file
while read -r line; do
	case "$line" in
		*pts_time:*) pts_time="${line##*pts_time:}"
			dur=$( (echo "$pts_time $pts_time_prev" | awk '{print $1-$2}'))
			pts_time_prev=$pts_time
			printf 'file img/img%d.png\nduration %s\n' "$img_nbr" "$dur" >> concat.txt
			img_nbr=$((img_nbr+1))
		;;
	esac
done < time.txt

#write last frame a second time at the end of the video
pts_time=$( (ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "$input"))
dur=$( (echo "$pts_time $pts_time_prev" | awk '{print $1-$2}'))
pts_time_prev=$pts_time
printf 'file img/img%d.png\nduration %s\nfile img/img%d.png\nduration 0\n' "$img_nbr" "$dur" "$img_nbr" >> concat.txt

#you might need to edit concat.txt to fix duration etc.
