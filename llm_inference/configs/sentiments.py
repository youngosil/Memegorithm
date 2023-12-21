# Dictionary containing sentiment scores for different emotions.
emotion_relations = {
    '기쁨': ['기쁨', '중립'],
    '당황': ['당황', '불안', '상처', '중립'],
    '분노': ['불안', '상처', '슬픔', '중립'],
    '불안': ['당황', '분노', '상처', '중립'],
    '상처': ['상처', '불안', '슬픔', '중립'],
    '슬픔': ['슬픔', '분노', '상처', '중립'],
    '중립': ['중립', '기쁨', '당황', '불안', '상처', '분노', '슬픔']
}

# Index to emotion mapping
label_to_class = ['불안', '중립', '당황', '슬픔', '상처', '분노', '기쁨']

# Emotion to index mapping
class_to_label = {emotion: index for index, emotion in enumerate(label_to_class)}
