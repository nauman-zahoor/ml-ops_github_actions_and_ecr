from fastapi import FastAPI
from inference_onnx import ColaONNXPredictor
app = FastAPI(title="MLOps Basics App")
print('starting...')
import os
print(os.listdir())
print('\n\n\n\n')
predictor = ColaONNXPredictor("./models/model.onnx")

@app.get("/")
async def home_page():
    return "<h2>Sample prediction API</h2>"


@app.get("/predict")
async def get_prediction(text: str):
    result =  predictor.predict(text)
    return result