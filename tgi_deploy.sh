#!/bin/bash
cd text-generation-inference
conda create -n tgi python=3.11
eval "$(/home/user/miniconda3/bin/conda shell.bash hook)"
conda install -c conda-forge pkg-config openssl


conda activate tgi
export OPENSSL_DIR=$CONDA_PREFIX && \
export OPENSSL_INCLUDE_DIR=$CONDA_PREFIX/include && \
export OPENSSL_LIB_DIR=$CONDA_PREFIX/lib && \
export PKG_CONFIG_PATH=$CONDA_PREFIX/lib/pkgconfig
export PYTHONPATH=/home/user/miniconda3/envs/tgi/lib/python3.11/site-packages
export LD_LIBRARY_PATH=/home/user/:$LD_LIBRARY_PATH
ln -s /usr/lib/x86_64-linux-gnu/libnvidia-ml.so.1 /home/user/libnvidia-ml.so

nohup text-generation-launcher   --model-id HuggingFaceH4/zephyr-7b-beta   -p 7860 &> qwen2.log &

PYTHONPATH=/home/user/:$PYTHONPATH \
LD_LIBRARY_PATH=/home/user/:$LD_LIBRARY_PATH \
text-generation-launcher \
  --model-id HuggingFaceH4/zephyr-7b-beta \
  --disable-custom-kernels \
  -p 7860

LD_LIBRARY_PATH=/home/user/:$LD_LIBRARY_PATH \
text-generation-launcher \
  --model-id HuggingFaceH4/zephyr-7b-beta \
  -p 7860

LD_LIBRARY_PATH=/home/user/:$LD_LIBRARY_PATH text-generation-launcher --model-id Qwen/Qwen2.5-VL-7B-Instruct -p 7860
LD_LIBRARY_PATH=/home/user/:$LD_LIBRARY_PATH text-generation-launcher --model-id Qwen/Qwen3-8B -p 7860


text-generation-launcher \
  --model-id HuggingFaceH4/zephyr-7b-beta \
  --disable-custom-kernels


# To run the server in the background, use:
nohup text-generation-launcher \
    --model-id mistralai/Mistral-7B-v0.1 \
    --port 8080 \
    --max-batch-prefill-tokens 2048 \
    --max-batch-total-tokens 4096 \
    --max-input-length 4096 \
    --max-total-tokens 8192 \
    --max-batch-size 32 \
    --max-waiting-tokens 20 \
    --hostname 0.0.0.0 \
    --cuda-memory-fraction 0.95 \
    --max-concurrent-requests 128 \
    --trust-remote-code \
    --json-output > tgi.log 2>&1 &


# To stop the server, use:
ps aux | grep text-generation-launcher
pkill -f text-generation-launcher
kill -9 $(nvidia-smi | grep python | awk '{ print $5 }')



curl https://jdelavande-dev-tgi.hf.space/generate \
  -X POST \
  -H "Content-Type: application/json" \
  -d '{"inputs":"Bonjour !", "parameters":{"max_new_tokens":20}}'

  curl https://jdelavande-dev-tgi2.hf.space/ \
  -X POST \
  -H "Content-Type: application/json" \
  -d '{"inputs":"Bonjour !", "parameters":{"max_new_tokens":20}}'

    curl localhost:7860/generate \
  -X POST \
  -H "Content-Type: application/json" \
  -d '{"inputs":"Bonjour !", "parameters":{"max_new_tokens":20}}'