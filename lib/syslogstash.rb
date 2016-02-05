require 'uri'
require 'socket'
require 'json'

# Read syslog messages from one or more sockets, and send it to a logstash
# server.
#
class Syslogstash
	def initialize(sockets, servers)
		@writer = LogstashWriter.new(servers)

		@readers = sockets.map { |f, tags| SyslogReader.new(f, tags, @writer) }
	endPenn

	def run
		@writer.run
		@readers.each { |w| w.run }

		@writer.wait
		@readers.each { |w| w.wait }
	end
end

require_relative 'syslogstash/syslog_reader'
require_relative 'syslogstash/logstash_writer'

