docker run -v G:/Repos/redis/redis-vote:/usr/local/etc/redis --name redis-vote redis:5.0.7 redis-server /usr/local/etc/redis/redis.conf


# create masters
docker run -d --rm --name redis-1 --expose=7001 --expose=17001 --net=host -v $PWD/redis-1:/usr/local/etc/redis redis:5.0.7 redis-server /usr/local/etc/redis/redis.conf
docker run -d --rm --name redis-2 --expose=7002 --expose=17002 --net=host -v $PWD/redis-2:/usr/local/etc/redis redis:5.0.7 redis-server /usr/local/etc/redis/redis.conf
docker run -d --rm --name redis-3 --expose=7003 --expose=17003 --net=host -v $PWD/redis-3:/usr/local/etc/redis redis:5.0.7 redis-server /usr/local/etc/redis/redis.conf


#create slaves

docker run --rm --name redis-1 -p 7011:7011 -p 17011:17011 -v C:/Sources/redis-cluster/docker-1:/usr/local/etc/redis docker-artifactrepo.mille.pl/redis:5.0.7 redis-server /usr/local/etc/redis/redis.conf
docker run --rm --name redis-2 -p 7012:7012 -p 17012:17012 -v C:/Sources/redis-cluster/docker-2:/usr/local/etc/redis docker-artifactrepo.mille.pl/redis:5.0.7 redis-server /usr/local/etc/redis/redis.conf
docker run --rm --name redis-3 -p 7013:7013 -p 17013:17013 -v C:/Sources/redis-cluster/docker-3:/usr/local/etc/redis docker-artifactrepo.mille.pl/redis:5.0.7 redis-server /usr/local/etc/redis/redis.conf

#redis-cli
docker run --rm -it --net=host redis:5.0.7 bash

# create cluster
redis-cli --cluster create 172.18.35.139:7001 172.18.35.139:7002 172.18.35.139:7003 --cluster-replicas 0
