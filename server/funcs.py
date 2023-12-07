# funcs.py

from librosa import load, resample
from librosa.feature import mfcc
from numpy import mean, array, float64
from fastdtw import fastdtw
from sklearn.preprocessing import RobustScaler as sc
from dlib import get_frontal_face_detector, shape_predictor
from cv2 import imread, cvtColor, COLOR_BGR2GRAY, VideoCapture
from scipy.spatial.distance import euclidean
from moviepy.editor import VideoFileClip
import os
from base64 import b64decode

detector = get_frontal_face_detector()
predictor = shape_predictor("shape_predictor_68_face_landmarks.dat")

def find_lip_landmark(image):
    gray = cvtColor(image, COLOR_BGR2GRAY)
    faces = detector(gray)
    if not faces:
        return 0, []
    landmarks = predictor(gray, faces[0])
    inner_lip_points = list(range(60, 68))
    outer_lip_points = list(range(48, 60))
    landmarks = array([(landmarks.part(point).x, landmarks.part(point).y) for point in inner_lip_points + outer_lip_points]).astype(float64)
    landmarks[:, 0] /= mean(landmarks[:, 0])
    landmarks[:, 1] /= mean(landmarks[:, 1])
    return 1, landmarks

def mp4_to_landmark(path):
    cap = VideoCapture(path)
    landmarks = []
    while True:
        ret, frame = cap.read()
        if not ret:
            break
        is_face, landmark = find_lip_landmark(frame)
        if not is_face:
            return 0, []
        landmarks.append(landmark)
    landmarks = array(landmarks)
    cap.release()
    return 1, landmarks

def read_wav(path):
    return load(path, sr=None)  # 수정: sr=None를 추가하여 원본 샘플링 레이트를 유지

def score(mean, now, tick):
    ret = (now - (mean - tick)) / (tick * 2) * 2
    if ret > 1:
        ret = 2 - ret
    if ret < 0 or ret > 1:
        ret = 0
    return ret * 100

def dtw2d_mp4(a, b):
    distances = []
    for i in range(20):
        now = []
        distance, path = fastdtw(a[:, i, :], b[:, i, :], dist=euclidean)
        now.append(distance)
    distances.append(mean(now))
    return array(distances)

def dtw_cmp(landmark, landmark2, cut):
    rets = []
    l, l2 = len(landmark) // cut, len(landmark2) // cut
    for j in range(cut):
        rets.append(dtw2d_mp4(landmark[l * j:l * (j + 1), :, :], landmark2[l2 * j:l2 * (j + 1), :, :]))
    return rets

def dtw2d(a, b):
    distances = []
    for i in range(len(a)):
        distance, path = fastdtw(a[i], b[i])  # 수정: dist 지정
        distances.append(distance)
    return mean(distances)

def scale(wav):
    return sc().fit_transform(wav.reshape(-1, 1)).flatten()

def process(wav, sr, cut):
    tsr = (200001) * sr / len(wav)
    wav = resample(wav, orig_sr=sr, target_sr=tsr)[:200000]
    wav = scale(wav)
    l = 200000 // cut
    mfccs = array([mfcc(y=wav[i - l:i], sr=tsr, n_mfcc=10) for i in range(l, len(wav) + 1, l)])
    return mfccs

def split_video_and_audio(video_path, audio_output_path):
    print(video_path)
    video_clip = VideoFileClip(video_path)
    audio_clip = video_clip.audio
    print("clip success")
    os.makedirs(os.path.dirname(audio_output_path), exist_ok=True)
    print("maked dir")
    audio_clip.write_audiofile(audio_output_path, codec='pcm_s16le')

def base64_to_mp4(base64_string, output_path):
    video_data = b64decode(base64_string)
    with open(output_path, 'wb') as f:
        print("write 성공")
        f.write(video_data)

def rm(paths):
    for path in paths:
        os.remove(path)
