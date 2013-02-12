#!/usr/bin/python

import imaplib

lastcountstore = "/tmp/lastcountstore"
passwordFile = "password"

def print_count(n):
    if int(n) == 0:
        print n
    else:
        print "<fc=red>" + str(n) + "</fc>"

try:
    f = open(passwordFile, 'r')
    password = f.read().strip()
    f.close()
except:
    print "<fc=red>no password</fc>"
    exit(0) # exit w/ 0 just so xmobar won't bitch

imap_server = imaplib.IMAP4_SSL("imap.gmail.com",993)
try:
    # The password is application-specific. If it leaks I deactivate it.
    imap_server.login("felzix", password)
except:
    try:
        f = open(lastcountstore, 'r')
        print_count(f.read())
        f.close()
        exit(0)
    except IOError:
        print "<fc=red>unauthorized</fc>"
        exit(0) # exit w/ 0 just so xmobar won't bitch

imap_server.select('INBOX')

status, response = imap_server.status('INBOX', "(UNSEEN)")
unreadcount = int(response[0].split()[2].strip(').,]'))

print_count(unreadcount)

try:
    f = open(lastcountstore, 'w')
    f.write(str(unreadcount))
    f.close()
except:
    pass

