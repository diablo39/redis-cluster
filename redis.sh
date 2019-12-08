docker run -v G:/Repos/redis/redis-vote:/usr/local/etc/redis --name redis-vote redis:5.0.7 redis-server /usr/local/etc/redis/redis.conf


# create masters
docker run -d --rm --name redis-1 --expose=7001 --expose=17001 --net=host -v $PWD/redis-1:/usr/local/etc/redis redis:5.0.7 redis-server /usr/local/etc/redis/redis.conf
docker run -d --rm --name redis-2 --expose=7002 --expose=17002 --net=host -v $PWD/redis-2:/usr/local/etc/redis redis:5.0.7 redis-server /usr/local/etc/redis/redis.conf
docker run -d --rm --name redis-3 --expose=7003 --expose=17003 --net=host -v $PWD/redis-3:/usr/local/etc/redis redis:5.0.7 redis-server /usr/local/etc/redis/redis.conf


#create slaves
docker run -d --rm --name redis-1-slave --expose=7011 --expose=17011 --net=host -v $PWD/redis-1-slave:/usr/local/etc/redis redis:5.0.7 redis-server /usr/local/etc/redis/redis.conf
docker run -d --rm --name redis-2-slave --expose=7012 --expose=17012 --net=host -v $PWD/redis-2-slave:/usr/local/etc/redis redis:5.0.7 redis-server /usr/local/etc/redis/redis.conf
docker run -d --rm --name redis-3-slave --expose=7013 --expose=17013 --net=host -v $PWD/redis-3-slave:/usr/local/etc/redis redis:5.0.7 redis-server /usr/local/etc/redis/redis.conf

# create tie-breaker
docker run -d --rm --name redis-tie-breaker --expose=7000 --expose=17000 --net=host -v $PWD/redis-tie-breaker:/usr/local/etc/redis redis:5.0.7 redis-server /usr/local/etc/redis/redis.conf

#redis-cli
docker run --rm -it --net=host redis:5.0.7 bash

# create cluster with masters
redis-cli --cluster create 172.18.35.139:7001 172.18.35.139:7002 172.18.35.139:7003 --cluster-replicas 0

# add slaves
redis-cli --cluster add-node 172.18.35.139:7011 172.18.35.139:7001 --cluster-slave
redis-cli --cluster add-node 172.18.35.139:7012 172.18.35.139:7001 --cluster-slave
redis-cli --cluster add-node 172.18.35.139:7013 172.18.35.139:7001 --cluster-slave

# add tie braker
redis-cli --cluster add-node 172.18.35.139:7000 172.18.35.139:7001

docker kill redis-tie-breaker
docker kill redis-1
docker kill redis-2
docker kill redis-3

docker kill redis-tie-breaker && docker kill redis-1-slave && docker kill redis-2-slave && docker kill redis-3-slave