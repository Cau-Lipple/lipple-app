import json
import base64
import boto3 
from urllib.parse import quote, unquote

def lambda_handler(event, context):
    print("Lambda function started")
    print('Received event:', json.dumps(event))
    
    # 대소문자를 구분하지 않고 httpMethod 값을 가져옴
    http_method = event.get('httpMethod') or event.get('requestContext', {}).get('http', {}).get('method', '').upper()
        
    if http_method == 'POST':
        print("POST method detected")
        
        # 결과 반환
        response = {
            'statusCode': 200,
            "mp4": [85,91,88],
            "sound": [96,86,65],
            "tot": 90
        }

    elif http_method == 'GET':
        print("GET method detected")

        if 'method' in event :
            print("Getallvid method detected")
            videos_by_category = all_vid_list_category()
            categories = list(videos_by_category.keys())

            response_body = {
                'videos': []
            }

            for category in categories:
                videos_in_category = videos_by_category.get(category, [])

                for video_file in videos_in_category:
                    video_id = video_file.split('.')[0]
                    text_content = read_text_file(video_id)

                    video_info = {
                        'name': text_content,
                        'File_Id': video_id,
                        'category': category
                    }

                    response_body['videos'].append(video_info)

            response = {
                'statusCode': 200,
                'body': response_body
            }
            
        elif 'categoryId' in event.get('pathParameters', {}):
            category_id = event.get('pathParameters', {}).get('categoryId', None)
            
            if category_id is not None:
                # URL-인코딩된 category_id 생성
                category_id_decoded = unquote(category_id)
                print(category_id_decoded)
                videos_with_category = list_videos_by_category(category_id_decoded)
                
                response = {
                    'statusCode': 200,
                    'body': json.dumps({'videos': videos_with_category})
                }
            else:
                response = {
                    'statusCode': 400,
                    'body': 'Invalid request. Missing categoryId parameter.',
                    'name': 'error'
                }
            
        elif 'videoId' not in event.get('pathParameters', {}) and 'voiceId' not in event.get('pathParameters', {}):
            categories = list_all_videos()

            response = {
                'statusCode': 200,
                'body': categories
            }
            print(response)
            
        elif 'videoId' in event.get('pathParameters', {}) :
            print("video get method")
            video_id = event.get('pathParameters', {}).get('videoId', None)
           
            if video_id is not None:
                # video_id가 존재할 때의 처리
                video_data = download_video(video_id)
                if video_data:
                    text_content = read_text_file(video_id)
                    video_url = construct_s3_url('lipark', 'video/', f'{video_id}.mp4')
                    response = {
                        'statusCode': 200,
                        'body': f'"{video_url}"',
                        'name': f'"{text_content}"'
                    }
                else:
                    response = {
                        'statusCode': 404,
                        'body': 'Video not found',
                        'name': 'error'
                    }
            else:
                response = {
                    'statusCode': 400,
                    'body': 'Invalid request. Missing videoId parameter.',
                    'name': 'error'
                }
        else :
            print("voice get method")
            voice_id = event.get('pathParameters', {}).get('voiceId', None)

            if voice_id is not None:
                # voice_id가 존재할 때의 처리
                voice_data = download_voice(voice_id)
                if voice_data:
                    text_content = read_text_file(voice_id)
                    voice_url = construct_s3_url('lipark', 'voice/', f'{voice_id}.wav')
                    response = {
                        'statusCode': 200,
                        'body': f'"{voice_url}"',
                        'name': f'"{text_content}"'
                    }
                else:
                    response = {
                        'statusCode': 404,
                        'body': 'Voice not found',
                        'name': 'error'
                    }
            else:
                response = {
                    'statusCode': 400,
                    'body': 'Invalid request. Missing voiceId parameter.',
                    'name': 'error'
                }

    else:
        print("Invalid HTTP method detected")
        
        response = {
            'statusCode': 400,
            'body': f'Invalid request for HTTP method: {http_method}'
        }

    print("Lambda function completed")
    return response

s3 = boto3.client('s3')

def download_video(video_id):
    try:
        BUCKET_NAME = 'lipark'
        DIR_NAME = 'video/'
        FILE_NAME = f'{video_id}.mp4'
        KEY = DIR_NAME + FILE_NAME
        
        response = s3.get_object(Bucket = BUCKET_NAME, Key = KEY)
        video_data = response['Body'].read()
        return video_data
    except Exception as e:
        print(f"Error downloading video: {str(e)}")
        return None

def download_voice(voice_id):
    try:
        BUCKET_NAME = 'lipark'
        DIR_NAME = 'voice/'
        FILE_NAME = f'{voice_id}.wav'
        KEY = DIR_NAME + FILE_NAME
        
        response = s3.get_object(Bucket = BUCKET_NAME, Key = KEY)
        voice_data = response['Body'].read()
        return voice_data
    except Exception as e:
        print(f"Error downloading voice: {str(e)}")
        return None
        
def read_text_file(file_id):
    try:
        BUCKET_NAME = 'lipark'
        DIR_NAME = 'script/'
        FILE_NAME = f'{file_id}.txt'
        KEY = DIR_NAME + FILE_NAME
        response = s3.get_object(Bucket=BUCKET_NAME, Key=KEY)
        text_content = response['Body'].read().decode('cp949')
        return text_content
    except Exception as e:
        print(f"Error reading text file: {str(e)}")
        return None

def construct_s3_url(bucket_name, dir_name, file_name):
     return f'{bucket_name}.s3.ap-northeast-2.amazonaws.com/{dir_name}{file_name}'.replace(' ', '')

def list_all_videos():
    try:
        BUCKET_NAME = 'lipark'
        PREFIX = 'video/'

        # list_objects_v2 메서드를 사용하여 /video 경로의 모든 객체 목록 가져오기
        response = s3.list_objects_v2(Bucket=BUCKET_NAME, Prefix=PREFIX)

        # 응답에서 키를 추출하여 카테고리 값들을 배열로 반환
        videos_with_tags = response.get('Contents', [])
        categories = set()

        for video in videos_with_tags:
            # S3 객체의 태그 정보 가져오기
            tags = s3.get_object_tagging(Bucket=BUCKET_NAME, Key=video['Key'])
            category_tag = next((tag['Value'] for tag in tags.get('TagSet', []) if tag['Key'] == 'category'), None)

            if category_tag:
                # UTF-8로 디코딩
                decoded_category_tag = category_tag.encode('utf-8').decode('utf-8')
                categories.add(decoded_category_tag)

        # 카테고리 값들을 배열로 반환
        return list(categories)

    except Exception as e:
        print(f"Error listing video objects: {str(e)}")
        return []
        
def list_videos_by_category(category_id):
    try:
        BUCKET_NAME = 'lipark'
        PREFIX = 'video/'

        # list_objects_v2 메서드를 사용하여 /video 경로의 모든 객체 목록 가져오기
        response = s3.list_objects_v2(Bucket=BUCKET_NAME, Prefix=PREFIX)

        # 응답에서 키를 추출하여 카테고리에 속한 동영상을 저장할 리스트
        videos_in_category = []

        for video in response.get('Contents', []):
            # S3 객체의 태그 정보 가져오기
            tags = s3.get_object_tagging(Bucket=BUCKET_NAME, Key=video['Key'])
            category_tag = next((tag['Value'] for tag in tags.get('TagSet', []) if tag['Key'] == 'category'), None)

            if category_tag == category_id:
                # 동영상이 지정된 카테고리에 속한 경우
                video_info = {
                    'File_Id': video['Key'].split('/')[-1].split('.')[0],  # 동영상 파일명에서 ID 추출
                    'name': read_text_file(video['Key'].split('/')[-1].split('.')[0])  # 동영상 파일명으로 텍스트 읽기
                }
                videos_in_category.append(video_info)

        return videos_in_category

    except Exception as e:
        print(f"Error listing videos by category: {str(e)}")
        return []


def get_video_category(video_id):
    try:
        BUCKET_NAME = 'lipark'
        KEY = f'video/{video_id}.mp4'

        # Get tags for the video object
        tags = s3.get_object_tagging(Bucket=BUCKET_NAME, Key=KEY)

        # Find the 'Category' tag value
        category_tag = next((tag['Value'] for tag in tags.get('TagSet', []) if tag['Key'] == 'category'), None)

        return category_tag.encode('utf-8').decode('utf-8') if category_tag else 'Uncategorized'

    except Exception as e:
        print(f"Error getting video category: {str(e)}")
        return 'Uncategorized'
        
def all_vid_list_category():
    try:
        BUCKET_NAME = 'lipark'
        PREFIX = 'video/'

        # list_objects_v2 메서드를 사용하여 /video 경로의 모든 객체 목록 가져오기
        response = s3.list_objects_v2(Bucket=BUCKET_NAME, Prefix=PREFIX)

        # 응답에서 키를 추출하여 카테고리에 속한 동영상을 저장할 딕셔너리
        videos_by_category = {}

        for video in response.get('Contents', []):
            # S3 객체의 태그 정보 가져오기
            tags = s3.get_object_tagging(Bucket=BUCKET_NAME, Key=video['Key'])
            category_tag = next((tag['Value'] for tag in tags.get('TagSet', []) if tag['Key'] == 'category'), None)

            if category_tag:
                # UTF-8로 디코딩
                decoded_category_tag = category_tag.encode('utf-8').decode('utf-8')

                # 동영상이 속한 카테고리에 추가
                if decoded_category_tag in videos_by_category:
                    videos_by_category[decoded_category_tag].append(video['Key'].split('/')[-1])
                else:
                    videos_by_category[decoded_category_tag] = [video['Key'].split('/')[-1]]

        # 모든 카테고리의 동영상을 리스트로 반환
        return videos_by_category

    except Exception as e:
        print(f"Error listing videos by category: {str(e)}")
        return {}
