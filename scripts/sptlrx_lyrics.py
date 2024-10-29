import os
import subprocess

pipe_path_lyrics = "/tmp/sptlrx_lyrics"
try:
    os.mkfifo(pipe_path_lyrics)
except FileExistsError:
    pass

process_lyrics = subprocess.Popen(["sptlrx", "pipe"], stdout=subprocess.PIPE)

for line_lyrics in iter(process_lyrics.stdout.readline, ""):
    with open(pipe_path_lyrics, "wb") as lyrics:
        lyrics.write(line_lyrics)