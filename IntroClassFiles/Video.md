brew --version

brew update
brew install git ffmpeg uv python@3.12

git --version
ffmpeg -version
uv --version
python3 --version

mkdir -p ~/AI
cd ~/AI

mkdir -p models
mkdir -p inputs
mkdir -p outputs
mkdir -p audio
mkdir -p references
mkdir -p scripts

~/AI/

models/
inputs/
outputs/
audio/
references/
scripts/

cd ~/AI

git clone https://github.com/dgrauet/ltx-2-mlx.git

cd ltx-2-mlx

uv sync --all-extras

uv run ltx-2-mlx --help

Go here:


https://huggingface.co/Lightricks/LTX-2.5?utm_source=chatgpt.com

brew install huggingface-cli

uv tool install huggingface_hub

hf auth login

NEED HUGGING FACE TOKEN

hf auth whoami

cd ~/AI/ltx-2-mlx

uv run ltx-2-mlx info

uv run ltx-2-mlx generate \
  --prompt "A black stick figure walks into a simple office, static camera, white background" \
  --distilled \
  -o ~/AI/outputs/test.mp4

  open ~/AI/outputs/test.mp4
  
Create a charecter and paste here:

  ~/AI/references/tom.png

  uv run ltx-2-mlx generate \
  --prompt "The character looks toward the camera, raises his hand and points toward the screen. Static camera. Preserve the original character design." \
  --image ~/AI/references/tom.png \
  --two-stage \
  -o ~/AI/outputs/tom-test.mp4

  Create voice.wav

  ~/AI/audio/dialogue.wav

  uv run ltx-2-mlx a2v \
  --prompt "A black and white stick figure character speaking in an office. Natural head movement and hand gestures. Static camera." \
  --audio ~/AI/audio/dialogue.wav \
  -o ~/AI/outputs/dialogue-test.mp4

  open ~/AI/outputs/dialogue-test.mp4

  uv run ltx-2-mlx retake \
  --prompt "The character looks naturally toward the other person and gestures with one hand." \
  --video ~/AI/outputs/dialogue-test.mp4 \
  --start 1 \
  --end 3 \
  -o ~/AI/outputs/dialogue-retake.mp4

  uv run ltx-2-mlx extend \
  --prompt "The character pauses and looks confused." \
  --video ~/AI/outputs/dialogue-retake.mp4 \
  --extend-frames 2 \
  -o ~/AI/outputs/dialogue-extended.mp4

  12. then install ComfyUI

I’d deliberately wait until everything above works.

Terminal isn’t where you’ll necessarily stay. It’s just the easiest way to prove that MLX, Metal, the models and audio generation are all working correctly before we introduce another layer.

Once that’s solid, install the Mac version of ComfyUI.

https://github.com/dgrauet/ltx-2-mlx?utm_source=chatgpt.com



  


