# https://gist.github.com/vdw/f3c832df8ce271a036f2
# https://gist.github.com/vdw/939a61dd3fbdb04dc5b8

require "yaml"
require "pp"
require "pry"

def hash_to_dotted_path(hash, path = "")
  hash.each_with_object({}) do |(k, v), ret|
    key = path + k.to_s

    if v.is_a? Hash
      ret.merge! hash_to_dotted_path(v, key.to_s + ".")
    else
      ret[key] = v
    end
  end
end

def dotted_path_to_hash(hash)
  hash.map do |pkey, pvalue|
    pkey.to_s.split(".").reverse.inject(pvalue) do |value, key|
      {key.to_sym => value}
    end
  end.inject(&:deep_merge)
end

def delete_hash_by_dotted_path hash, dotted_path
  dotted_path = dotted_path.split "."
  leaf = dotted_path.pop

  dotted_path.inject(hash) {|hash, elm| hash[elm]}.delete leaf
end

yaml = YAML::load_file("locales/api.en.yml");
binding.pry
pp hash_to_dotted_path yaml
# pp dotted_path_to_hash({ 'level1.level2.level3' => 123 })
