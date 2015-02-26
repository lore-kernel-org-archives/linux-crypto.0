From: sri sowj <srisowj4linux@gmail.com>
Subject: How to deal with backlog messages in crypto driver
Date: Thu, 26 Feb 2015 23:40:31 +0530
Message-ID: <CAHTT9V+2pS0XHBxWrYCpMBUpCnpO+QO9+7trovqZtpTfVdhPTA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pa0-f45.google.com ([209.85.220.45]:40178 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753905AbbBZSKc (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 26 Feb 2015 13:10:32 -0500
Received: by paceu11 with SMTP id eu11so15772785pac.7
        for <linux-crypto@vger.kernel.org>; Thu, 26 Feb 2015 10:10:31 -0800 (PST)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi All ,


As per my understanding backlogs are used when crypto hardware
processing a request ,then multiple incoming requests comes to serve .
A queue/backlog is created to enqueue the request .Please let me know
if my understanding is incorrect.

EX:
M4,M3,M2,M1 ----> H(M0)

Here H(M0) under processing, M1 - M4 request comes when M0 is under
processing so M1-M4 are backlogged.

I am unable to understand how backlog messaging works in Linux kernel
crypto subsystem,Please can some one help me to understand following.


#1: In open source I can find references like below

         backlog = crypto_get_backlog(&dd->queue);
         async_req = crypto_dequeue_request(&dd->queue);

         if (backlog)
                 backlog->complete(backlog, -EINPROGRESS); // Not
really sure what does this call for?


Here When does this backlogged message gets processed?

Note:from http://www.mail-archive.com/linux-crypto%40vger.kernel.org/msg12206.html
,I can understand that backlogged messages need not to be resubmitted.

Please can some one help me to understand how/when to make use of
backlog technique in linux kernel crypto subsystem.

BR,
Srisowj
