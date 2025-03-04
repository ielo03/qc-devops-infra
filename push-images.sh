#!/bin/bash

cd qc-devops-source/frontend
docker build -t frontend .
docker tag frontend:latest 061039790334.dkr.ecr.us-west-1.amazonaws.com/frontend:latest
docker push 061039790334.dkr.ecr.us-west-1.amazonaws.com/frontend:latest

cd ../backend
docker build -t backend .
docker tag backend:latest 061039790334.dkr.ecr.us-west-1.amazonaws.com/backend:latest
docker push 061039790334.dkr.ecr.us-west-1.amazonaws.com/backend:latest
