From: Jitendra Lulla <lulla.jitendra@gmail.com>
Subject: RE: RFC: Crypto API User-interface
Date: Wed, 23 Apr 2014 16:07:27 +0530
Message-ID: <CAEux+EPz9NRhyiYRTC4POSCURVX176uWsPOp2D1trNXH2g-68Q@mail.gmail.com>
Reply-To: lullajd@yahoo.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pd0-f177.google.com ([209.85.192.177]:58626 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932484AbaDWKhr (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 23 Apr 2014 06:37:47 -0400
Received: by mail-pd0-f177.google.com with SMTP id y10so638073pdj.8
        for <linux-crypto@vger.kernel.org>; Wed, 23 Apr 2014 03:37:47 -0700 (PDT)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi,

This is regarding the hash computation over a file with AF_ALG from
user space. [without OpenSSL]

The following link has the mail from Herbert with subject : "RFC:
Crypto API User-interface"
http://lwn.net/Articles/410848/

I was trying to take help from the code snippet he has put in his mail
and I was doing the following to compute
hash over a file of 16 bytes. The file contents are "123456789012345\n".
I read the first 10 bytes first and computed hash over it. Then I read
the next 6 bytes from
the file and computed the hash and I had taken care of using the flags
MSG_MORE and MSG_OOB.

Following is what I am doing:

1. send(opfd, sbuf, len, MSG_MORE);
2. read(opfd, state, 20);
3. send(opfd, state, 20, MSG_OOB);

4. send(opfd, sbuf, len, MSG_MORE);
5. read(opfd, state, 20);
6. /*restore from a partial hash state */
7. send(opfd, state, 20, MSG_OOB);

8.  /* finalize */
9. send(opfd, sbuf, 0, 0);
10. read(opfd, buf, 20);

sbuf
in line 1 contains: "1234567890" (the " is not part of the data, the
data is plain 10 ascii bytes for 1 through 9), len is 10.
the state after line 2 contains correct hash of the above data.

sbuf in line 4 contains: "12345\n". Len is 6.

The hash I am seeing in buf after line 10 is not correct one.

Is there anything obviously wrong with the above code? I am using
2.6.39.4 kernel on rhel 6.4 (santiago)

Thanks for the help!

~Jitendra
