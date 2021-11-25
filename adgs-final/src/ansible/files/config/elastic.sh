#!/bin/bash
echo "network.host: 0.0.0.0" >> /etc/elasticsearch/elasticsearch.yml
echo "discovery.type: single-node" >> /etc/elasticsearch/elasticsearch.yml
sed -i 's/path.data: \/var\/lib\/elasticsearch/path.data: \/data01\/elasticsearch/g' /etc/elasticsearch/elasticsearch.yml
