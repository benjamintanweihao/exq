Code.require_file "test_helper.exs", __DIR__

defmodule Exq.RedisTest do
  use ExUnit.Case

  setup_all do 
    TestRedis.setup
  end 

  teardown_all do
    TestRedis.teardown
  end

  teardown do 
    Exq.Redis.flushdb! :testredis
    :ok
  end

  test "smembers empty" do 
    m = Exq.Redis.smembers!(:testredis, "bogus")
    assert m == []
  end
  
  test "sadd" do 
    r = Exq.Redis.sadd!(:testredis, "theset", "amember")
    assert r == "1"
    assert Exq.Redis.smembers!(:testredis, "theset") == ["amember"]
  end

  test "lpop empty" do 
    assert Exq.Redis.lpop!(:testredis, "bogus")  == :none
  end 

  test "rpush / lpop" do 
    Exq.Redis.rpush!(:testredis, "akey", "avalue")
    assert Exq.Redis.lpop!(:testredis, "akey")  == "avalue"
    assert Exq.Redis.lpop!(:testredis, "akey")  == :none
  end

  test "flushdb" do
    Exq.Redis.sadd!(:testredis, "theset", "amember")
    Exq.Redis.flushdb! :testredis
    assert Exq.Redis.smembers!(:testredis, "theset") == []
  end
end
