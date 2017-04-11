#!/bin/bash

setup_erlang_cookie() {
	if [ "${RABBITMQ_ERLANG_COOKIE:-}" ]; then
		cookieFile='/var/lib/rabbitmq/.erlang.cookie'
		if [ -e "$cookieFile" ]; then
			if [ "$(cat "$cookieFile" 2>/dev/null)" != "$RABBITMQ_ERLANG_COOKIE" ]; then
				echo >&2 "warning: $cookieFile contents do not match RABBITMQ_ERLANG_COOKIE"
			fi
		else
			echo "$RABBITMQ_ERLANG_COOKIE" > "$cookieFile"
			chmod 600 "$cookieFile"
		fi
	fi
}

setup_default_user() {
	if [ "${RABBITMQ_DEFAULT_USER:-}" ] && [ "${RABBITMQ_DEFAULT_PASSWORD:-}" ]; then
		echo "Removing 'guest' user and adding ${RABBITMQ_DEFAULT_USER}"
		rabbitmqctl delete_user guest
		rabbitmqctl add_user $RABBITMQ_DEFAULT_USER $RABBITMQ_DEFAULT_PASSWORD
		rabbitmqctl set_user_tags $RABBITMQ_DEFAULT_USER administrator
		rabbitmqctl set_permissions -p / $RABBITMQ_DEFAULT_USER ".*" ".*" ".*"
	fi
}

setup_cluster() {
	if [ "${CLUSTER_WITH:-}" ]; then
		echo >&2 "SETUP CLUSTER WITH $CLUSTER_WITH"

		# join the cluster
		rabbitmqctl stop_app &&
		rabbitmqctl join_cluster rabbit\@$CLUSTER_WITH &&
		rabbitmqctl start_app
	fi
}

rabbitmq-server 2>&1 | tee /var/log/rabbitmq/rabbit\@$HOSTNAME.log &
rabbitmqctl wait /var/lib/rabbitmq/mnesia/rabbit\@$HOSTNAME.pid

setup_erlang_cookie
setup_default_user
setup_cluster

tail -f --retry --follow=name /var/log/rabbitmq/rabbit\@$HOSTNAME.log
