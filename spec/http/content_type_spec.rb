# frozen_string_literal: true
#
# Copyright, 2016, by Samuel G. D. Williams. <http://www.codeotaku.com>
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.

require 'http/accept/content_type'

RSpec.describe HTTP::Accept::ContentType do
	it "should raise argument error if constructed with wildcard" do
		expect{HTTP::Accept::ContentType.new("*", "*")}.to raise_error(ArgumentError)
	end
end

RSpec.describe HTTP::Accept::ContentType.new("text", "plain") do
	it "should format simple mime type" do
		expect(subject.to_s).to be == "text/plain"
	end
	
	it "can compare with string" do
		expect(subject).to be === "text/plain"
	end
	
	it "can compare with self" do
		expect(subject).to be === subject
	end
end

RSpec.describe HTTP::Accept::ContentType.new("text", "plain", charset: 'utf-8') do
	it "should format simple mime type with options" do
		expect(subject.to_s).to be == "text/plain; charset=utf-8"
	end
end

RSpec.describe HTTP::Accept::ContentType.new("text", "plain", charset: 'utf-8', q: 0.8) do
	it "should format simple mime type with multiple options" do
		expect(subject.to_s).to be == "text/plain; charset=utf-8; q=0.8"
	end
end

RSpec.describe HTTP::Accept::ContentType.new("text", "plain", value: '["bar", "baz"]') do
	it "should format simple mime type with quoted options" do
		expect(subject.to_s).to be == "text/plain; value=\"[\\\"bar\\\", \\\"baz\\\"]\""
	end
	
	it "should round trip to the same quoted string" do
		media_types = HTTP::Accept::MediaTypes.parse(subject.to_s)
		
		expect(media_types[0].mime_type).to be == "text/plain"
		expect(media_types[0].parameters).to be == {'value' => '["bar", "baz"]'}
	end
end
