from flask import Flask, request, jsonify
import funcs as fc
from numpy import mean, array
from joblib import load
from werkzeug.utils import secure_filename
import os


app = Flask(__name__)
id_data = {
    1: "나도 전동 킥보드 잘 탈 수 있는데 나이가 안 되네.",
    2: "내가 이래 봬도 칠십오 년에 면허를 받은 몸이라고.",
    3: "버스 탈 때 애들이 한 번씩 노약자석에 앉아 있으면 비켜달라고 하기 미안하더라.",
    4: "서울 시내는 초보자가 운전하기에 너무 어려워.",
    5: "시골에서는 보통 트럭을 몰고 다니지.",
    6: "아빠 저도 스포츠카 타보고 싶어요.",
    7: "아빠 차 못생겨서 타기 싫어.",
    8: "아빠는 내가 학교 가기 전에 지하철 타고 회사에 출근하셔.",
    9: "엄마 우리 차는 왜 이렇게 낮아?",
    10: "엄마 친구가 그러는데 비행기 탈 때는 신발 벗고 타야 된대.",
    11: "요새는 사람들이 렌터카를 많이 선호하더라.",
    12: "요즘 버스 타는 게 왜 이렇게 복잡한지.",
    13: "요즘에 젊은 애들은 차를 일찍 사던데 그게 좋은 선택인가 싶어.",
    14: "이제 교통카드로 청소년 할인받는 것도 이 년 남았네.",
    15: "저는 버스 타면 소리가 두 번 울려요.",
    16: "저는 혼자서 버스 타고 학교 가요.",
    17: "지하철이 잘 되어 있어서 나처럼 휠체어 타는 사람들도 편하게 다닐 수 있어."
}

# 기본 로딩
app.config['UPLOAD_FOLDER'] = 'C:/capston/' 
app.config['MAX_CONTENT_LENGTH'] = 16 * 1024 * 1024  # 16 MB로 설정
@app.route('/evaluate', methods=['POST'])
def evaluate():
    #try:
        if 'body' not in request.files:
            return jsonify({'error': 'No video file provided'}), 400

        print(request)
        video_file = request.files['body']
        
        video_id = int(request.form.get('videoId'))
        id = id_data.get(video_id, "Video ID에 해당하는 문장이 없습니다.")
        # 공백 제거
        id = id.replace('?','').replace(' ','').replace('.','').replace(',','')
        
        # 파일이 비어 있는지 확인
        if video_file.filename == '':
            return jsonify({'error': 'No selected video file'}), 400

        # 허용된 파일 형식인지 확인
        if video_file and allowed_file(video_file.filename):
            
            filename = secure_filename(video_file.filename)
            upload_folder = os.path.join(app.config['UPLOAD_FOLDER'], filename)
            video_file.save(upload_folder)

            # 여기에서 video_path 변수를 사용하여 동영상 처리
            video_path = os.path.join(app.config['UPLOAD_FOLDER'], filename)
            audio_path = 'C:/capston/audio.wav'
            
            fc.split_video_and_audio(video_path, audio_path)

            result = get_tot_score(video_path, audio_path,id)

            # 결과를 JSON으로 반환
            response = {
                "status_code": 200,
                "mp4_score": result[1],
                "wav_score": result[2],
                "total_score": result[3]
            }
            print(response)
            return jsonify(response)

"""    except Exception as e:
        # 예외를 적절히 처리
        return jsonify({"error": str(e)}), 500"""
        
def allowed_file(filename):
    return '.' in filename and filename.rsplit('.', 1)[1].lower() in {'mp4'}

def get_mp4_score(is_face,mp4,id) : #영상점수
    dtw_mp4 = load('dtw_mp4.pkl') #기존 영상 랜드마크의 dtw값들
    landmarks = load('landmarks.pkl') #기존 영상 입술 영역 랜드마크 값들
    if not is_face : return []
    cut = 3
    dtw_now = []
    for data in landmarks[id] : 
        dtw_now.append(fc.dtw_cmp(data,mp4,cut))
    score = [fc.score(mean(array(dtw_mp4[id])[:,i,:]),mean(array(dtw_now)[:,i,:]),(max(array(dtw_mp4[id])[:,i,:])-min(array(dtw_mp4[id])[:,i,:]))/3) for i in range(cut)]
    return score

def get_wav_score(is_face,wav,sr,id) : #음성점수
    dtws = load('dtws.pkl') #기존 음성들의 key에 따른 dtw값들
    wavs = load('wavs.pkl') #기존 음성들의 key에 따른 processed wav값들
    if not is_face : return []
    cut = 3
    dtw_now = [[]for _ in range(cut)]
    pwav = fc.process(wav,sr,cut)
    for i in range(cut) :
        for data in wavs[id][:,i,:,:] : 
            dtw_now[i].append(fc.dtw2d(pwav[i,:,:],data))
    score = [fc.score(mean(dtws[id][i,:]),mean(dtw_now[i]),max(dtws[id][i,:])-min(dtws[id][i:,])+mean(dtws[id])*0.5) for i in range(cut)]  
    return score

def get_score_len(wav,sr,id): #길이점수
    lens = load('lens.pkl') #기존 음성들의 key에 따른 음성길이
    time = len(wav)/sr
    print("id:", id)
    score = fc.score(mean(lens[id]),time,3+mean(lens[id])*0.5)
    return score

def get_tot_score(video_path, audio_path,id) : #총점 반환
    print("id:", id)
    is_face,mp4,wav,sr = fc.mp4_to_landmark(video_path)+fc.read_wav(audio_path)
    len_score = get_score_len(wav,sr,id)
    mp4_score = get_mp4_score(is_face,mp4,id)
    if mp4_score == [] :
        mp4_score = [0,0,0]
    wav_score = get_wav_score(is_face,wav,sr,id)
    if wav_score == [] :
        wav_score = [0,0,0]
        return is_face,mp4_score,wav_score,len_score
    print(len_score,mp4_score,wav_score) #출력부분 지우거나 주석 ㄱ
    return is_face,mp4_score,wav_score,mean([mean(mp4_score),mean(wav_score),len_score])

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0')
