From: avital sela <avitalsela95@gmail.com>
Subject: question about fragmentation of large packets
Date: Tue, 8 Dec 2009 14:54:43 +0200
Message-ID: <311e0d1f0912080454q6099cc4cq5b23617364bf9633@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-fx0-f213.google.com ([209.85.220.213]:64674 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754148AbZLHMyh (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 8 Dec 2009 07:54:37 -0500
Received: by fxm5 with SMTP id 5so6142050fxm.28
        for <linux-crypto@vger.kernel.org>; Tue, 08 Dec 2009 04:54:43 -0800 (PST)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hello,

I am testing a AES HW crypto driver I wrote. I test by setting up a
tunnel between the board and a Linux server and pinging packets from
the board to the server.
With my driver loaded everything works fine with small packets but
large packets (>1500) fail (100% packet loss).
I added some debug code to the standard crypto/cbc.c and noticed that
when I ping using -s1500 the encryption (aes-cbc) gets broken up to 3
chuncks
sized 1456 , 16, 64.  I also noticed that the iv for each of the
chunks is different.
Questions:
1. Why are there 3 chunks with these sizes? Is this related to the
crypto subsystem or the  ipsec one?
2. How is the iv computed between each subsequent chunk?
I think my driver is failing because although it also processes 3
identically sized chunks it does not change the iv between each one
(it only does so once at the end).

Thanks for your time,
Avital
