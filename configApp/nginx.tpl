server {
	server_name $DOMAINS;
    access_log logs/$NAME.log main;
	listen 80;

	location / {
		proxy_pass             http://127.0.0.1:$HOST_PORT; # proxy_pass $DOMAINS
		proxy_set_header       Host $host;
		proxy_pass_request_headers      on;
	}
}
