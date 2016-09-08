#
# Copyright (c) 2015-2016 Red Hat, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

#
# Library requirements.
#
require 'date'

#
# Load the extension:
#
require 'ovirtsdk4c'

#
# Own requirements.
#
require 'ovirtsdk4/version.rb'
require 'ovirtsdk4/http.rb'
require 'ovirtsdk4/type.rb'
require 'ovirtsdk4/types.rb'
require 'ovirtsdk4/reader.rb'
require 'ovirtsdk4/readers.rb'
require 'ovirtsdk4/writer.rb'
require 'ovirtsdk4/writers.rb'
require 'ovirtsdk4/service.rb'
require 'ovirtsdk4/services.rb'


#if Rails.env.development?
  #require 'byebug/core'
  #Byebug.wait_connection = true
  #Byebug.start_server 'localhost', 9048
  #puts '>>>>>>>>>>>>>>.. contin'
#end
def byebug_has_client?
  require 'byebug/core'

  ObjectSpace.each_object(Byebug::RemoteInterface).count > 0
end

def byebug_ensure_server
  require 'byebug/core'

  return if Byebug.actual_port
  Byebug.start_server('localhost', 0)  # pick an available port
  until Byebug.actual_port
    puts "~~~~~~ Bybug.actual_port = #{Byebug.actual_port} Bybug.actual_control_port = #{Byebug.actual_control_port}"
    sleep(0.2)
  end
  #@log.log "Byebug.start_server: listening on port #{Byebug.actual_port}"
#rescue => e
  #@log.error "Couldn't Byebug.start_server: #{e}"
  #@log.exception(e)
  return
end

def byebug_term
  require 'byebug/core'

  byebug_ensure_server

  unless byebug_has_client?
    term = ENV.fetch("BYEBUG_TERM_COMMAND", "gnome-terminal -x")
    system("#{term} byebug -R localhost:#{Byebug.actual_port} &")

    until byebug_has_client?
      sleep(0.2)
    end
  end

  #byebug        # would open debugger here
  Byebug.attach  # opens debugger in caller (it's what `byebug` calls)
end

