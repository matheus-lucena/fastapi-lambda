#Copyright 2018 Amazon.com, Inc. or its affiliates. All Rights Reserved.
#PDX-License-Identifier: MIT-0 (For details, see https://github.com/awsdocs/amazon-rekognition-developer-guide/blob/master/LICENSE-SAMPLECODE.)

import boto3

client=boto3.client('rekognition')

def create_collection(collection_id):
    #Create a collection
    print('Creating collection:' + collection_id)
    response=client.create_collection(CollectionId=collection_id)
    print('Collection ARN: ' + response['CollectionArn'])
    print('Status code: ' + str(response['StatusCode']))
    print('Done...')
    
def delete_collection(collection_id):
    #Create a collection
    print('Deleting collection:' + collection_id)
    response=client.delete_collection(CollectionId=collection_id)
    
    print('Status code: ' + str(response['StatusCode']))
    print('Done...')

def list_collections():
    #Create a collection
    response=client.list_collections()
    
    for col in response['CollectionIds']:
        print("Collection " + col)

def main():
    collection_id = input("Please enter nome collection :\n")
    
    delete_collection(collection_id)
    create_collection(collection_id)
    list_collections()

if __name__ == "__main__":
    main()    
