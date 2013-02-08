#!/usr/bin/python

import imaplib

lastcountstore = "/tmp/lastcountstore"

def print_count(n):
    if int(n) == 0:
        print n
    else:
        print "<fc=red>" + str(n) + "</fc>"

imap_server = imaplib.IMAP4_SSL("imap.gmail.com",993)
try:
    # The password is application-specific. if it leaks it gets deactivated.
    imap_server.login("felzix", "oslomrahgducvlmc")
except :
    try:
        f = open(lastcountstore, 'r')
        print_count(f.read())
        f.close()
        exit(0)
    except IOError:
        print "<fc=red>unauthorized</fc>"
        exit(0) # exit w/ 1 just so xmobar won't bitch

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

