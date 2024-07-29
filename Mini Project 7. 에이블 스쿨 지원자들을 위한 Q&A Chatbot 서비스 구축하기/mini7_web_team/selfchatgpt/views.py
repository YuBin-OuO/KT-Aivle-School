from django.shortcuts import render, redirect
from django.http import HttpResponse
from django.http import JsonResponse
from django import forms
from django.urls import reverse
from django.utils import timezone

from langchain.chat_models import ChatOpenAI
from langchain.schema import HumanMessage, AIMessage
from langchain.embeddings import OpenAIEmbeddings
from langchain.vectorstores import Chroma
from langchain.chains import RetrievalQA, ConversationalRetrievalChain
from langchain.memory import ConversationBufferMemory , ChatMessageHistory 
from langchain.schema import Document

import pandas as pd
import json
import sqlite3

# Create your views here.

# Chroma 데이터베이스 초기화 - 사전에 database가 완성 되어 있다는 가정하에 진행 - aivleschool_qa.csv 내용이 저장된 상태임
embeddings = OpenAIEmbeddings(model = "text-embedding-ada-002")
database = Chroma(persist_directory = "./database", embedding_function = embeddings)

######## DB에 새 Q&A 데이터들 추가 ##############
# data = pd.read_csv('aivleschool_qa2.csv', encoding='utf-8')
# # 한문, 한글, 일본어 등 한 글자 표현하는 데 2byte 드는 문자들: UTF-8로 읽어와야 함

# text_list = data['QA'].tolist()
# meta_list = data['구분'].tolist()

# # meta_list의 각 항목을 딕셔너리로 변환
# doc = [Document(page_content=text_list[i], metadata={'구분': meta_list[i]}) for i in range(len(data))]

# # 데이터베이스에 문서를 추가
# ind = database.add_documents(doc)
# print(len(database))
################################################

def index(request):
    return render(request, 'selfchatgpt/index.html')

def chat(request):
    # post로 받은 question (index.html에서 name속성이 question인 input태그의 value값)을 가져옴
    query = request.POST.get('question')

    # chatgpt API 및 lang chain을 사용을 위한 선언
    chat = ChatOpenAI(model="gpt-3.5-turbo",
                      temperature = 1.0,
                      max_tokens = 200)
    k = 3
    retriever = database.as_retriever(search_kwargs={"k": k})
    
    # 대화 메모리 생성
    memory = ConversationBufferMemory(memory_key="chat_history", input_key="question", output_key="answer",
                                  return_messages=True) # 대화 시작할 때 실행돼야 함

    # ConversationalRetrievalQA 체인 생성
    qa = ConversationalRetrievalChain.from_llm(llm=chat, retriever=retriever, memory=memory,
                                            return_source_documents=True, output_key="answer")    
    
    result = qa(query)

    # result.html에서 사용할 context
    context = {
        'question': query,
        'result': result["answer"]
    }
    print(query)

    # 응답을 보여주기 위한 html 선택 (위에서 처리한 context를 함께 전달)
    return JsonResponse(context)