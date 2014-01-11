require 'rubygems'
require 'net/http'
require 'dnsimple'
require 'json'

CONFIGFILE = 'config.cfg'

if File.exists?(CONFIGFILE)
	json = File.read(CONFIGFILE)
	info = JSON.parse(json)
	username = info["username"]
	api_token = info["api_token"]
	domainname = info["domainname"]
	recordid = info["recordid"]
else
	puts 'Configuration not found!'
	exit 
end

uri = URI('http://ipv4.icanhazip.com/')
res = Net::HTTP.get_response(uri)
myIP = res.body.strip

DNSimple::Client.username = username
DNSimple::Client.api_token = api_token

domain = DNSimple::Domain.find(domainname)
record = DNSimple::Record.find(domain, recordid, {})
record::content = myIP
record.save()

