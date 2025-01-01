#!/usr/bin/zsh

# Ask for the user's name
print "Hello!\nWelcome to Hosa's Shell!\n"
print "############ Please enter your UserName:"

read user_name

# Greet the user
print "############ Hello, $user_name! Welcome to the Shell!\n"
print "Lets print your info now!\n"

ll /home/$user_name

print "\n################################################"
print "################################################\n"

print "We'll now copy a folder to temp DIR!"
sudo cp -r /home/$user_name/Pictures/ /tmp/temporarry/

print "\n################################################"
print "################################################\n"
print "Copied Successfully!"
print "Folder copied to /tmp/temporary/!"
print "\n################################################"
print "################################################\n"

print "Now lets show your processes!\n"
top | grep $user_name

