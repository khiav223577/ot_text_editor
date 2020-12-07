require "rspec/expectations"

RSpec::Matchers.define_negated_matcher :not_change, :change

RSpec::Matchers.define :be_json do
  match do |actual|
    actual.content_type == "application/json"
  end
end

RSpec::Matchers.define :have_message_code do |expected_key|
  match do |actual|
    actual.parsed_body["message_code"] == expected_key.to_s
  end
end

RSpec::Matchers.define :have_mail_html_link do |url|
  match do |actual|
    pattern = /href="#{Regexp.quote(url.to_s)}[^"]*"/
    actual.body.raw_source.scan(pattern).empty? ? false : true
  end
end

def change_hash_by(from_hash, to_hash)
  keys = from_hash.keys | to_hash.keys
  return change { yield.slice(*keys) }.from(from_hash).to(to_hash).and not_change { yield.except(*keys) }
end
