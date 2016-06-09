System.put_env("PATH", "/usr/local/openresty/nginx/sbin:$PATH")
File.mkdir_p!("test/client/tmp")
System.cmd "nginx", ~w[-p test/client/tmp -c ../nginx.conf], into: IO.stream(:stdio, :line)
