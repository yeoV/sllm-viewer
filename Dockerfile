FROM  python:3.11-buster as py-build
LABEL author="lsy"

ARG APP_VERSION=0.1.0

RUN apt-get update && apt-get install -y \
    build-essential \
    curl \
    software-properties-common \
    && rm -rf /var/lib/apt/lists/*


RUN curl -sSL https://install.python-poetry.org | POETRY_HOME=/opt/poetry python3 -


ADD ./dist/viewer-${APP_VERSION}.tar.gz /
WORKDIR /viewer-${APP_VERSION}
ENV PATH=/opt/poetry/bin:$PATH

RUN poetry config virtualenvs.in-project true && poetry install

FROM python:3.11-slim
ARG APP_VERSION=0.1.0

EXPOSE 8501
COPY --from=py-build /viewer-${APP_VERSION} /app
WORKDIR /app

ENTRYPOINT [ ".venv/bin/python", "-m", "streamlit", "run", "viewer/frontend/test.py", "--server.port=8501", "--server.address=0.0.0.0" ]

