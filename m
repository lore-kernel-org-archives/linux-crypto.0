From: john terragon <terragonjohn@yahoo.com>
Subject: aesni-intel slower than aes-x86_64
Date: Sun, 11 Apr 2010 15:52:20 -0700 (PDT)
Message-ID: <693236.82640.qm@web45101.mail.sp1.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from web45101.mail.sp1.yahoo.com ([68.180.197.49]:40210 "HELO
	web45101.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753155Ab0DKW7F (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 11 Apr 2010 18:59:05 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi.
My system has a core i5 520M and supports AES-NI. I wanted to do a
rude performance test and so I ran these commands on a small (4GB) partition and on the dm-crypt device backed by it:

1) using the aesni-intel module: dd if=/dev/dev/mapper/vol of=/dev/null bs=4k
2) using only the generic aes-x86_64 module: dd if=/dev/dev/mapper/vol
of=/dev/null bs=4k
3) dd if=/dev/sda4 of=/dev/null bs=4k 

What I got kind of surprised me:
1) ~ 67 MB/sec, with a low cpu load by kcryptd
2) ~ 79 MB/sec, with a higher cpu load by kcryptd
3) ~ 81 MB/sec

So aesni-intel seems to be quite slower than the generic aes-x86_64 (although with a lower cpu load). 
Is this to be expected? Am I missing something?

The kernel is the "official" 2.6.32.something (AMD64) from debian sid.

Thanks

John




      
