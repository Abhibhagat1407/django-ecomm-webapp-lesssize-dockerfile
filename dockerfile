#FROM python:3.10.12
#ENV SECRET_KEY test@123
#WORKDIR /app
#COPY requirements.txt /app/

#RUN pip install --no-cache-dir -r requirements.txt
#COPY . /app/
#EXPOSE 8000
#CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]

FROM python:3.10-alpine as build
RUN apk add --update --virtual .build-deps \
    build-base \
    python3-dev \
    libpq
ENV SECRET_KEY test@123
ENV STRIPE_LIVE_PUBLIC_KEY=your-live-public-key
ENV STRIPE_LIVE_SECRET_KEY=your-live-secret-key
ENV STRIPE_TEST_PUBLIC_KEY=your-test-public-key
ENV STRIPE_TEST_SECRET_KEY=your-test-secret-key

#RUN apt-get update && apt-get install -y build-essential
COPY requirements.txt /app/requirements.txt
RUN pip install --upgrade pip
RUN pip install -r /app/requirements.txt
RUN pip install --upgrade pip


FROM python:3.10-alpine as run  
RUN apk add libpq
COPY --from=base /usr/local/lib/python3.10/site-packages/ /usr/local/lib/python3.10/site-packages/
COPY --from=base /usr/local/bin/ /usr/local/bin/
COPY . /app

ENV PYTHONUNBUFFERED=1
EXPOSE 8000
CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]



