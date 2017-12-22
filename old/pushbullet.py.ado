# https://github.com/randomchars/pushbullet.py
# pip install pushbullet.py
# Usage: >python pushbullet.py.ado API_KEY "DEVICE_NAME" "TITLE" "MESSAGE"

import sys
from pushbullet import PushBullet

if __name__=="__main__":
	nargs = len(sys.argv)
	assert nargs==5
	api_key = sys.argv[1]
	device_nick = sys.argv[2]
	title = sys.argv[3]
	msg = sys.argv[4]
	pb = PushBullet(api_key)
	print(title)
	print(msg)
	device = [d for d in pb.devices if d.nickname==device_nick][0]
	success, push = device.push_note(title, msg)
