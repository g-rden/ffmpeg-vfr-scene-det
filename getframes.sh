#!/bin/sh

#USAGE:
#./getframes [scene value] [video file]

scene="$1"
input="$2"
frameloc='frames/frame'
frame=0
pts_time_prev=0

#output first frame
ffmpeg -i "$input" -vframes 1 "$dir"/img0.png
#output all other detected frames
ffmpeg -i "$input" -filter_complex "select='gt(scene,$scene)',metadata='print:file=times'" -vsync vfr "$frameloc"%d.png #TODO not printing to file

#clear file
printf '' > concat

#write to concat file
while read -r line; do
	case "$line" in
		*pts_time:*) pts_time="${line##*pts_time:}"
			dur=$( (echo "$pts_time $pts_time_prev" | awk '{print $1-$2}'))
			pts_time_prev=$pts_time
			printf 'file %s%d.png\nduration %s\n' "$frameloc" "$frame" "$dur" >> concat
			frame=$((frame+1))
		;;
	esac
done < times

#write last frame a second time at the end of the video
pts_time=$( (ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "$input"))
dur=$( (echo "$pts_time $pts_time_prev" | awk '{print $1-$2}'))
pts_time_prev=$pts_time
printf 'file %s%d.png\nduration %s\nfile %s%d.png\nduration 0\n' "$frameloc" "$frame" "$dur" "$frameloc" "$frame" >> concat

#you might need to edit concat.txt to fix duration etc.
