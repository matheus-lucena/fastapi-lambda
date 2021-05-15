from fastapi import FastAPI, APIRouter, UploadFile, File, Form
from mangum import Mangum
import os
import boto3
from fastapi.responses import JSONResponse

def add_faces_to_collection(bucket, photo, ExternalImageId):    
    client=boto3.client('rekognition')
    response=client.index_faces(CollectionId=os.environ['CollectionID'],
        Image={'S3Object':{'Bucket':bucket,'Name':photo}},
        ExternalImageId=ExternalImageId.replace(" ", "_"),
        MaxFaces=1,
        QualityFilter="AUTO",
        DetectionAttributes=['ALL'])

    return len(response['FaceRecords'])

def search_faces_by_image(contents, threshold=80, region="us-east-1"):
	rekognition = boto3.client("rekognition", region)
	response = rekognition.search_faces_by_image(
		Image={
            "Bytes": contents
		},
        MaxFaces=6,
		CollectionId=os.environ['CollectionID'],
		FaceMatchThreshold=threshold,
	)
	return response['FaceMatches']

app = FastAPI(
    title='Teste',
    description='Teste',
    version=1.0
)

ROUTER = APIRouter()

@ROUTER.post("/register")
async def main_route(name: str = Form(...), image: UploadFile = File(...)):
    s3=boto3.resource('s3')
    bucketName = os.environ['BucketName']
    s3_response = s3.Bucket(bucketName).put_object(Key=image.filename, Body=image.file)
    add_faces_to_collection(bucketName, image.filename, name)
    return JSONResponse(content={"status": "success"})

@ROUTER.post("/recognize")
async def recognize_route(image: UploadFile = File(...)):
    contents = image.file.read()
    return JSONResponse(content=search_faces_by_image(contents))

app.include_router(ROUTER, prefix='/api')

handler = Mangum(app)