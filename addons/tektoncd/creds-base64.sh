#!/bin/zsh
 read "username?Enter a username: "
 read "password?Enter a password: "
 credentials="$(echo -n "$username:$password" | base64)"
 header="Authorization: Basic $credentials"
 echo $header
