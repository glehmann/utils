#!/usr/bin/env python
#coding: iso-8859-15

from optparse import OptionParser
import os, time, re, smtplib, sys

parser = OptionParser(usage="usage: %prog [options] [filename] ...")
parser.add_option("-e", "--email", dest="email", default=os.getenv("USER")+"@"+os.getenv("HOSTNAME"), metavar="EMAIL", help="email dest")
parser.add_option("-p", "--passwd", dest="passwd", default="", metavar="PASSWD", help="email passwd")
parser.add_option("-H", "--host", dest="host", default="localhost", metavar="PASSWD", help="email passwd")
parser.add_option("-u", "--user", dest="user", default="", metavar="PASSWD", help="email passwd")
parser.add_option("-i", "--list-id", dest="listId", default="", metavar="ID", help="list id")
parser.add_option("-t", "--to", dest="to", default="", metavar="ID", help="list id")
(options, args) = parser.parse_args()

#alvis-arch@indexdata.dk
if len(args) == 0:
	args = ["-"]
	
nb = 0
	
def send(mail) :
	global nb
	mailTab = mail.split("\n")
	if len(mailTab) == 2:
		print "mail trop court"
		return
	#enleve la derniere ligne (From gsp at dtv.dk  Mon May  3 09:46:41 2004)
	mailTab = mailTab[:-2]+mailTab[-1:]
	mailTab = mailTab[:1]+["List-Id: "+options.listId+"\nTo: "+options.to]+mailTab[1:]
	ret = server.sendmail(options.email, [options.email], "\n".join(mailTab))
	nb += 1	
	print nb, ret
	#print "\n".join(mailTab)
	#sys.exit(0)

server = smtplib.SMTP(options.host)
if options.user != "" :
	server.login(options.user, options.passwd)
	
for fichier in args :
	if fichier == "-" :
		f = sys.stdin
	else :
		f = file(fichier)
		
	mail = ""
	precLineIsFrom = False
	
	for ligne in f :
		if ligne.find("From: ") == 0 and precLineIsFrom :
			#c'est le prochain mail qui arrive !
			#on envoi le precedent
			send(mail)
			#on modifie from pour remplacer " at " par "@"
			mail = ligne.replace(" at ", "@")
			precLineIsFrom = False
		else :
			if ligne.find("Date: ") == 0 :
				try :
					ligne = "Date: " + time.strftime("%a, %d %b %Y %H:%M:%S GMT", time.strptime(ligne[6:-1])) + "\n"
				except ValueError :
					pass
			precLineIsFrom = ligne.find("From ") == 0
			mail += ligne
	
	send(mail)

server.quit()
#print nb

