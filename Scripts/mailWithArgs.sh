#!/bin/env bash

# Read concept and message body from command line arguments
concept="$1"
message="$2"
sender="$3"
receiver="$4"
gapp="$5"
# check for provided attachment file as a positional parameter
# -z indicating an empty positional parameter
# attachment doesn't exist condition

if [ -z "$6" ]; then 

    # curl command for accessing the smtp server

    curl -s --url 'smtps://smtp.gmail.com:465' --ssl-reqd \
    --mail-from $sender \
    --mail-rcpt $receiver\
    --user $sender:$gapp \
     -T <(echo -e "From: ${sender}
To: ${receiver}
Subject:${concept}

 ${message}")

# attachment exists condition
else

    file="$6"           # set file as the 3rd positional parameter
    
    # MIME type for multiple type of input file extensions
    
    MIMEType=`file --mime-type "$file" | sed 's/.*: //'`
    curl -s --url 'smtps://smtp.gmail.com:465' --ssl-reqd \
    --mail-from $sender \
    --mail-rcpt $receiver\
    --user $sender:$gapp \
     -H "Subject: $concept" -H "From: $sender" -H "To: $receiver" -F \
    '=(;type=multipart/mixed' -F "=$message;type=text/plain" -F \
      "file=@$file;type=$MIMEType;encoder=base64" -F '=)'
     
fi

