# Memegorithm

<p align="center">
  <img src="./assets/example.png" width="600" />
</p>

<!-- ![Example image](./assets/example.png) -->
## Last Update (December 22, 2023)
> Included example images

> Included [README.md](./visual_sentiment_prediction/README.md) for running visual sentiment prediction (VSP)

## Getting Started
### Prerequisites

- Python >= 3.8
- pip
- Flask
- Flutter
- Firebase database & auth token: `./llm_inference/*.json`

### How to run (Quickstart)

#### Flask server (Model serving)

1. Clone the repository:

```sh
git clone https://github.com/youngosil/Memegorithm.git
```

2. Run required dependencies
```sh
cd llm_inference
pip install -r requirements.txt
```

3. Run flask server
```sh
python app.py --port 5000
```

#### Flutter

```sh
flutter run -d chrome --web-renderer html
```
