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
require 'right_aws'

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
  puts "graph_title SQS Rate of Change"
  puts "graph_vlabel items / ${graph_period}"
  puts "graph_category SQS"

  get_queues().each do |q|
    name = q.name
    puts "#{name}.label #{name}"
    puts "#{name}.type DERIVE"
    puts "#{name}.draw LINE1"
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
