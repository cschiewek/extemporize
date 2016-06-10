local http = require "resty.http"
local httpc = http.new()
httpc:set_timeout(500)
local ok, err = httpc:connect(ngx.var.extemporize_host, ngx.var.extemporize_port)

if ok then
  local res, err = httpc:request{
    path = "/api/match?".."domain="..ngx.var.host.."&path="..ngx.var.uri
  }
  if res then
    if res.status == 200 then
      body = res:read_body()
      ngx.log(ngx.NOTICE, "[Extemporize] - REDIRECTING TO: "..body)
      return ngx.redirect(body)
    end
  else
    ngx.log(ngx.ERR, "[Extemporize] - ERROR "..err)
  end
  httpc:close()
else
  ngx.log(ngx.ERR, "[Extemporize] - ERROR "..err)
end
