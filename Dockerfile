ARG PYTHON_VERSION
ARG AIRFLOW_VERSION
FROM python:${PYTHON_VERSION}

RUN python -m venv /opt/venv

# Install airflow
ENV CONSTRAINT_URL "https://raw.githubusercontent.com/apache/airflow/constraints-${AIRFLOW_VERSION}/constraints-${PYTHON_VERSION}.txt"
RUN pip install "apache-airflow[async,postgres,google,cncf.kubernetes]==${AIRFLOW_VERSION}" --constraint "${CONSTRAINT_URL}"

# Install Deps
RUN pip install google-cloud-storage google-auth-httplib2 google-api-python-client pandas-gbq pytest PyGithub==1.55

RUN mkdir /action
COPY dag_validation.py /action/dag_validation.py
COPY alert.py action/alert.py

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
