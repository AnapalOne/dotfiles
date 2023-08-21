#!/bin/env bash

case $1 in
	"-neko")
		notifyDesc_open="neko? neko! neko neko."
		notifyDesc_kill="neko..."
	;;
	"-dog")
		notifyDesc_open="doggo? doggo! doggo doggo."
		notifyDesc_kill="doggo..."
	;;
	"-sakura")
		notifyDesc_open="best girl."
		notifyDesc_kill="bad girl..."
	;;
esac

if pgrep oneko > /dev/null; then
	pkill oneko
	xsetroot -cursor_name left_ptr
	notify-send -a oneko -h string:x-canonical-private-synchronous:oneko "$notifyDesc_kill"
else
	oneko $1 &
	notify-send -a oneko -h string:x-canonical-private-synchronous:oneko "$notifyDesc_open"
fi