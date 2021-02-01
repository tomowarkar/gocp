---
title: ffmpeg 個人的メモ
---

### 音声ファイル詳細

```bash
$ sox --i audio.mp3
Input File     : 'audio.mp3'
Channels       : 2
Sample Rate    : 22050
Precision      : 16-bit
Duration       : 00:02:30.31 = 3314291 samples ~ 11273.1 CDDA sectors
File Size      : 1.20M
Bit Rate       : 64.0k
Sample Encoding: MPEG audio (layer I, II or III)
```

### 再生速度を変える
#### 2倍速
```bash
$ ffmpeg -i src.mp4 -vf setpts=PTS/2.0 -af atempo=2.0 dest.mp4
```
[ffmpegを使って動画の再生速度を変えてみる - 脳内メモ＋＋](http://fftest33.blog.fc2.com/blog-entry-36.html)

### 指定時間でカット

```
$ ffmpeg -i input.mp4 -t [duration] -c copy output.mp4
```
[ffmpeg で指定時間でカットするまとめ | ニコラボ](https://nico-lab.net/cutting_ffmpeg/)

### 結合

[How to merge audio and video file in ffmpeg - Super User](https://superuser.com/questions/27764)
[ffmpeg join two mp4 files with ffmpeg on command line - Super User](https://superuser.com/questions/1059245/ffmpeg-join-two-mp4-files-with-ffmpeg-on-command-line)

[Merge video and audio with ffmpeg. Loop the video while audio is not over - Stack Overflow](https://stackoverflow.com/questions/5015771/merge-video-and-audio-with-ffmpeg-loop-the-video-while-audio-is-not-over)

### ノイズキャンセル

```
$ ffmpeg -i <input_file> -af "highpass=f=200, lowpass=f=3000" <output_file>
```
[バックグラウンドノイズを減らし、ffmpegを使用してオーディオクリップからの音声を最適化する](https://qastack.jp/superuser/733061/reduce-background-noise-and-optimize-the-speech-from-an-audio-clip-using-ffmpeg)
