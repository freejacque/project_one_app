module RedisHelper

  def redis_set(key, value)
    $redis.set(key, value.to_json)
  end

  def redis_get(key)
    JSON.parse($redis.get(key))
  end

end #module
