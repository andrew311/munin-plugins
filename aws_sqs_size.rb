#!/usr/bin/ruby
#
# Copyright 2012, Andrew Rollins
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
require 'rubygems'
require 'aws_sdk'

LOGGER = Logger.new(STDOUT)
LOGGER.level = Logger::FATAL

SQS = RightAws::SqsGen2.new(
  ENV['aws_access_key_id'],
  ENV['aws_secret_access_key'],
  :logger => LOGGER
)

def get_queues
  SQS.queues
end

def do_config
  puts "graph_title SQS Size"
  puts "graph_vlabel queue size"
  puts "graph_category SQS"

  get_queues().each do |q|
    name = q.name
    puts "#{name}.label #{name}"
    puts "#{name}.type GAUGE"
    puts "#{name}.draw LINE1"
    puts "#{name}.min  0"
    puts "#{name}.warning  #{ENV['aws_sqs_size_warning']}"
    puts "#{name}.critical #{ENV['aws_sqs_size_critical']}"
  end
end

def do_data
  get_queues().each do |q|
    puts "#{q.name}.value #{q.size}"
  end
end

if __FILE__ == $0
  if ARGV[0] == "config"
    do_config()
  else
    do_data()
  end
end
