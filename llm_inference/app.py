from flask import Flask, request
from flask import jsonify
from utils.generate import generate_summarization, generate_sentiment
from models.similarity import calculatesim
from configs.sentiments import emotion_relations, label_to_class, class_to_label

import firebase_admin, argparse
from firebase_admin import credentials
from firebase_admin import firestore
from google.cloud.firestore_v1.base_query import FieldFilter
from vllm import LLM, SamplingParams

# Initialize Flask app
app = Flask(__name__)

# Initialize Firestore DB
cred = credentials.Certificate('ybigta-memegorithm-firebase-adminsdk-8f0wp-b6ed71bf6b.json')
firebase_admin.initialize_app(cred)
db = firestore.client()
users_ref = db.collection("image")

# Initialize LLM
model='davidkim205/komt-mistral-7b-v1'
llm = LLM(model=model, tensor_parallel_size=1)

def first_filtering(users_ref, similarity_dict):
    """
    Filters documents from Firestore based on the names provided in the similarity_dict.

    Args:
        users_ref (Firestore CollectionReference): Reference to the Firestore collection.
        similarity_dict (dict): Dictionary containing similarity scores for different names.

    Returns:
        list: List of documents matching the provided names.
    """
    ocr_name, ocr_score = similarity_dict['ocr'][0], similarity_dict['ocr'][1]
    caption_name, caption_score = similarity_dict['caption'][0], similarity_dict['caption'][1]
    ocr_caption_name, ocr_caption_score = similarity_dict['ocr_caption'][0], similarity_dict['ocr_caption'][1]

    # Query firestore db
    documents_dict = {}
    query_ocr = users_ref.where("name", "==", ocr_name)
    query_caption = users_ref.where("name", "==", caption_name)
    query_ocr_caption = users_ref.where("name", "==", ocr_caption_name)

    # Get documents
    docs_ocr = query_ocr.stream()
    docs_caption = query_caption.stream()
    docs_ocr_caption = query_ocr_caption.stream()

    # Append similarity score to document
    for doc in docs_ocr:
        doc_dict = doc.to_dict()
        doc_dict['similarity_score'] = ocr_score
        documents_dict['ocr'] = doc_dict

    for doc in docs_caption:
        doc_dict = doc.to_dict()
        doc_dict['similarity_score'] = caption_score
        documents_dict['caption'] = doc_dict

    for doc in docs_ocr_caption:
        doc_dict = doc.to_dict()
        doc_dict['similarity_score'] = ocr_caption_score
        documents_dict['ocr_caption'] = doc_dict

    return documents_dict

def second_filtering(documents_dict, target_sentiment):
    """
    Filter the documents based on the target sentiment and return the most similar image ID.

    Args:
        documents_dict (dict): A dictionary containing the documents.
        target_sentiment (str): The target sentiment to filter the documents.

    Returns:
        str: The most similar image ID.

    """
    result_documents_dict = {}
    for document_key in documents_dict.keys():
        target_sentiments_set = set(emotion_relations[target_sentiment])
        document = documents_dict[document_key]
        if document['sentiment'] in target_sentiments_set:
            result_documents_dict[document_key] = document
    
    if len(result_documents_dict) == 0:
        print("No documents found with the same sentiment. Returning all documents.")
        result_documents_dict = documents_dict
    
    print(f"Second filtering - filter by sentiment: {result_documents_dict}")

    # Sort by similarity score
    result_documents_dict = dict(sorted(result_documents_dict.items(), key=lambda x: x[1]['similarity_score'], reverse=True))
    most_similar_key, most_similar_document = next(iter(result_documents_dict.items()))
    print(f"Most similar key: {most_similar_key}, most similar document: {most_similar_document}")
    most_similar_image_id = most_similar_document['name']

    return most_similar_image_id


# Endpoint function for /
@app.route('/', methods=['POST'])
def post():
    text = request.json['text']
    print(f"Received POST with sentence: {text}")

    # Run language model to generate sentiment & summarization
    sentiment = generate_sentiment(llm, text)
    summarization = generate_summarization(llm, text)

    print(f"Sentiment: {sentiment}")
    print(f"Summarization: {summarization}")

    # Calculate similarity
    result_dict = calculatesim(summarization)
    first_filtering_dict = first_filtering(users_ref, result_dict) # Filter by similarity
    recommendation_id = second_filtering(first_filtering_dict, sentiment)

    # Return image ID
    response = jsonify({"image_id": recommendation_id})
    response.headers.add("Access-Control-Allow-Origin", "*")
    return response

# Run server
if __name__ == '__main__':
    argparser = argparse.ArgumentParser()
    argparser.add_argument('--port', type=int, default=7070)
    args = argparser.parse_args()
    app.run(host='0.0.0.0', port=args.port)
