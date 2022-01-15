# ffmpeg-vfr-scene-det
Reducing video via [scene detection](https://ffmpeg.org/ffmpeg-all.html#select_002c-aselect) to essential frames and encoding it with variable fps. This will not work well with most video contentand is very unorthodox.

# extract frames
Make the script executable: e.g. `chmod +x getframes.sh`.
Make a directory called `frames`. e.g. `mkdir frames`.
Run script `./getframes [scene value] [video file]`.

Set scene value for more or less aggressive scene detection:

0 - very aggressive

1 - not aggressive or even disabled

e.g. 0.01

# encode extracted frames with variable fps
`ffmpeg -f concat -safe 0 -i concat.txt -vsync passthrough [output file]`
You can add ffmpeg options, but these are required.

# re-encode with constant fps
`ffmpeg -i [vrf video file] -r [framerate of the original video] -vsync cfr [output file]`
You can add ffmpeg options, but these are required.
Re-encoding as cfr can improve compatability with video players and displaying subtitles.
