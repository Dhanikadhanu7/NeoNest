# app/utils/audio_recorder.py
import sounddevice as sd
from scipy.io.wavfile import write

class AudioRecorder:
    def __init__(self, fs=44100):
        self.fs = fs
        self.recording = None

    def record(self, duration, filename="temp_audio.wav"):
        """
        Records audio for `duration` seconds and saves to filename.
        """
        print(f"🎙️ Recording for {duration} seconds...")
        audio = sd.rec(int(duration * self.fs), samplerate=self.fs, channels=1, dtype='int16')
        sd.wait()
        write(filename, self.fs, audio)
        print(f"✅ Recording saved as {filename}")
        return filename
