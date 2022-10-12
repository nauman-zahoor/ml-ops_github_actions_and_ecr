FROM huggingface/transformers-pytorch-cpu:latest

COPY requirements_inference.txt ./requirements_inference.txt
RUN pip install -r requirements_inference.txt
RUN pip install "dvc[s3]"
RUN pip install "transformers"

COPY ./ /tmp
WORKDIR /tmp

ARG AWS_ACCESS_KEY_ID
ARG AWS_SECRET_ACCESS_KEY


#this envs are experimental
ENV AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY




# initialise dvc
RUN dvc init -f --no-scm 
# configuring remote server in dvc
RUN dvc remote add -d model-store s3://mlops-aws-nauman/

RUN cat .dvc/config
# pulling the trained model
RUN dvc pull dvcfiles/trained_model_original.dvc
RUN dvc pull dvcfiles/trained_model_onnx.dvc

ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8

# running the application
EXPOSE 8000
CMD ["uvicorn", "tmp:app", "--host", "0.0.0.0", "--port", "8000"]
