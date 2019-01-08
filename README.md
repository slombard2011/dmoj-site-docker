# dmoj-site-docker

## build image

```
docker build --tag dmoj-site .
```

## build image from scratch 

```
docker build --no-cache --tag dmoj-site .
```

## create network for site and db :

```
docker network create -d bridge --subnet 172.25.0.0/16 isolated_nw
```

## build and start db container on the dedicated network :

```
docker run --name dmoj-mysql --network=isolated_nw --ip=172.25.3.3 -v /code/docker-data/mysql:/var/lib/mysql -e MYSQL_ROOT_PASSWORD=dmoj -d mysql/mysql-server:5.7
```

## Start the site on port 10080 :

```
docker run --name=dmoj-site --network=isolated_nw -p 10080:80 -p 9999:9999 -p 9998:9998 -t -i -d dmoj-site /bin/bash
```

## Configure db (wait for the db to be started before entering this command. to do so check by using docker ps and checking that the db container is in healthy state) :

```
docker exec dmoj-mysql mysql -uroot -pdmoj --execute="CREATE DATABASE dmoj DEFAULT CHARACTER SET utf8mb4 DEFAULT COLLATE utf8mb4_general_ci;"

docker exec dmoj-mysql mysql -uroot -pdmoj --execute="GRANT ALL PRIVILEGES ON dmoj.* to 'dmoj'@'%' IDENTIFIED BY 'dmoj';"
```

## start the website :

```
docker exec dmoj-site sh /dmoj/site/docker-entrypoint.sh
```


