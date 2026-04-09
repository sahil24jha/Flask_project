#!/usr/bin/env bash
# ─────────────────────────────────────────────────────────────────────────────
# build-and-push.sh
# Builds Docker images for backend & frontend and pushes them to ECR.
#
# Usage:
#   chmod +x build-and-push.sh
#   ./build-and-push.sh [IMAGE_TAG]
#
# Requirements:
#   - AWS CLI v2 configured (aws configure)
#   - Docker running
#   - Terraform already applied (ECR repos must exist)
# ─────────────────────────────────────────────────────────────────────────────

set -euo pipefail

# ─── Config ──────────────────────────────────────────────────────────────────
IMAGE_TAG="${1:-latest}"
AWS_REGION="${AWS_REGION:-us-east-1}"
PROJECT_NAME="${PROJECT_NAME:-flask-signup}"

echo "▶  Using image tag  : $IMAGE_TAG"
echo "▶  AWS Region       : $AWS_REGION"
echo "▶  Project name     : $PROJECT_NAME"
echo ""

# ─── Resolve AWS Account ID ──────────────────────────────────────────────────
AWS_ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
echo "▶  AWS Account ID   : $AWS_ACCOUNT_ID"

ECR_REGISTRY="${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com"
BACKEND_REPO="${ECR_REGISTRY}/${PROJECT_NAME}-backend"
FRONTEND_REPO="${ECR_REGISTRY}/${PROJECT_NAME}-frontend"

# ─── Authenticate Docker to ECR ──────────────────────────────────────────────
echo ""
echo "━━━  Logging into ECR  ━━━"
aws ecr get-login-password --region "$AWS_REGION" \
  | docker login --username AWS --password-stdin "$ECR_REGISTRY"

# ─── Build & Push Backend ─────────────────────────────────────────────────────
echo ""
echo "━━━  Building backend image  ━━━"
docker build -t "${PROJECT_NAME}-backend:${IMAGE_TAG}" ./backend

echo "━━━  Tagging backend image  ━━━"
docker tag "${PROJECT_NAME}-backend:${IMAGE_TAG}" "${BACKEND_REPO}:${IMAGE_TAG}"

echo "━━━  Pushing backend image  ━━━"
docker push "${BACKEND_REPO}:${IMAGE_TAG}"
echo "✔  Backend pushed → ${BACKEND_REPO}:${IMAGE_TAG}"

# ─── Build & Push Frontend ────────────────────────────────────────────────────
echo ""
echo "━━━  Building frontend image  ━━━"
docker build -t "${PROJECT_NAME}-frontend:${IMAGE_TAG}" ./frontend

echo "━━━  Tagging frontend image  ━━━"
docker tag "${PROJECT_NAME}-frontend:${IMAGE_TAG}" "${FRONTEND_REPO}:${IMAGE_TAG}"

echo "━━━  Pushing frontend image  ━━━"
docker push "${FRONTEND_REPO}:${IMAGE_TAG}"
echo "✔  Frontend pushed → ${FRONTEND_REPO}:${IMAGE_TAG}"

# ─── Force new ECS deployments to pick up new images ─────────────────────────
echo ""
echo "━━━  Updating ECS services  ━━━"
CLUSTER="${PROJECT_NAME}-cluster"

aws ecs update-service \
  --cluster "$CLUSTER" \
  --service "${PROJECT_NAME}-backend-svc" \
  --force-new-deployment \
  --region "$AWS_REGION" \
  --output text --query "service.serviceName" \
  && echo "✔  Backend service update triggered"

aws ecs update-service \
  --cluster "$CLUSTER" \
  --service "${PROJECT_NAME}-frontend-svc" \
  --force-new-deployment \
  --region "$AWS_REGION" \
  --output text --query "service.serviceName" \
  && echo "✔  Frontend service update triggered"

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  All done! ECS will pull the new images shortly."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
