from vllm import SamplingParams
from .compare_utils import find_starting_word

# Index to emotion mapping
label_to_class = ['불안', '중립', '당황', '슬픔', '상처', '분노', '기쁨']

# Emotion to index mapping
class_to_label = {emotion: index for index, emotion in enumerate(label_to_class)}

def generate_summarization(llm, x):
    # text = f"### instruction: {x}\n\n### Response: "
    text = f"### instruction: #입력 문장에서 핵심 정보 추출. 입력 내용에서 부사, 수식어를 제외하고 서술어, 감정 표현, 필수 문장 성분만 추출할 것. 10단어 이내의 문장 한 개로 제시할 것. \n ##예시 입력 문장 : “하 아니 월요일에 전공시험2 전공중간대체과제1인데, 일요일에 왜 수원에서 알바해야함????????? 나진짜 세상이 미웠다 ...게다가 알바 끝나고 왔는데 정말이지 갑자기. 정말 갑자기.열이 엄청 나고 목이 아프고 어쩌구 .. 잔뜩 아파서 너무 서러웟음” \n ##예시 답변 : 시험이 있는데 알바를 해야하고 아파서 서러웠다 \n ##예시 입력 문장 : “갤러리아 가서 지파씨 젤라또도 먹었는데 나는 로마에서 먹었던 그 스트라치텔라의 감동적인 맛을 기대했으나 대 단 히 실 망 스 러 웟 다. 이건 진짜 젤라또에 대한 모욕이야. 우리. 젤라또로 장난치지 맙시다.” \n ##예시 답변 : “젤라또를 먹었는데 기대와 달리 실망했다” \n #입력 문장 :{x}\n\n### Response: "
    stop_tokens = ["USER:", "USER", "ASSISTANT:", "ASSISTANT"]
    sampling_params = SamplingParams(temperature=0.5, top_p=1, max_tokens=256, stop=stop_tokens)
    completions = llm.generate([text], sampling_params)
    generated_text = completions[0].outputs[0].text

    print("Generated text: ", generated_text)

    return generated_text

def generate_sentiment(llm, x):
    text = f"### instruction: #입력 문장의 감정 분류. 입력 내용을 [기쁨, 당황, 분노, 불안, 상처, 슬픔, 중립] 7개 감정 중 하나로 분류할 것. 다른 감정은 절대 제시하지 말 것. 답변은 한 단어로 제시할 것. \n ##예시 입력 문장 : “인터크로스 시발아……쉽지않다 실험. 자퇴하고 싶음” \n ##예시 답변 : 분노 \n ##예시 입력 문장 : “숯불에 구운 고기는 정말정말 맛있다. 진짜 진짜 진짜 맛있었습니다!!” \n ##예시 답변 : 기쁨 \n ##예시 입력 문장 : “나진짜 세상이 미웠다 ...게다가 알바 끝나고 왔는데 정말이지 갑자기. 정말 갑자기.열이 엄청 나고 목이 아프고 잔뜩 아파서 너무 서러웠음” \n ##예시 답변 : 슬픔 \n #입력문장 :{x}\n\n### Response: "
    stop_tokens = ["USER:", "USER", "ASSISTANT:", "ASSISTANT"]
    sampling_params = SamplingParams(temperature=0.5, top_p=1, max_tokens=256, stop=stop_tokens)
    completions = llm.generate([text], sampling_params)
    generated_text = completions[0].outputs[0].text

    print("Generated text: ", generated_text)

    # Check if generated text string starts with a valid emotion. If not, return "중립"
    emotion = find_starting_word(generated_text, set(label_to_class))

    return emotion

