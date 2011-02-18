From: Jan Glauber <jang@linux.vnet.ibm.com>
Subject: Re: crypto: sha1 - Add test vector to test partial block processing
Date: Fri, 18 Feb 2011 09:37:17 +0000
Message-ID: <1298021837.17221.33.camel@bender>
References: <20110207092817.GA16881@gondor.apana.org.au>
	 <1297082827.11137.15.camel@bender>
	 <20110217032557.GA12955@gondor.apana.org.au>
	 <1297955462.3547.14.camel@localhost.localdomain>
	 <20110217205226.GA21423@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: linux-crypto <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mtagate6.uk.ibm.com ([194.196.100.166]:50088 "EHLO
	mtagate6.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752046Ab1BRJiI (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 18 Feb 2011 04:38:08 -0500
Received: from d06nrmr1806.portsmouth.uk.ibm.com (d06nrmr1806.portsmouth.uk.ibm.com [9.149.39.193])
	by mtagate6.uk.ibm.com (8.13.1/8.13.1) with ESMTP id p1I9c57O020290
	for <linux-crypto@vger.kernel.org>; Fri, 18 Feb 2011 09:38:05 GMT
Received: from d06av08.portsmouth.uk.ibm.com (d06av08.portsmouth.uk.ibm.com [9.149.37.249])
	by d06nrmr1806.portsmouth.uk.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id p1I9cBej1835102
	for <linux-crypto@vger.kernel.org>; Fri, 18 Feb 2011 09:38:11 GMT
Received: from d06av08.portsmouth.uk.ibm.com (loopback [127.0.0.1])
	by d06av08.portsmouth.uk.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id p1I9c4Bs003291
	for <linux-crypto@vger.kernel.org>; Fri, 18 Feb 2011 09:38:04 GMT
In-Reply-To: <20110217205226.GA21423@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, 2011-02-18 at 07:52 +1100, Herbert Xu wrote:
> On Thu, Feb 17, 2011 at 04:11:02PM +0100, Jan Glauber wrote:
> > Hi Herbert,
> > 
> > good idea. I ended up with using openssl to create a test vector for
> > that special case but a published test vector is of course better.
> > 
> > With your sha patch applied sha1_s390 survives the tcrypt test.
> 
> Could you check if sha1_s390 fails the test without the patch?

Without 9d20b57 it gives:

[root@h4245005 ~]# modprobe tcrypt mode=2
FATAL: Error inserting tcrypt (/lib/modules/2.6.38-rc4-dirty/kernel/crypto/tcrypt.ko): Resource temporarily unavailable
[root@h4245005 ~]# tail -f /var/log/messages 
...
Feb 18 10:22:13 h4245005 kernel: alg: hash: Chunking test 2 failed for sha1-s390
Feb 18 10:22:13 h4245005 kernel: 00000000: 4a d0 d6 bd 53 2b 6b df cd 34 b9 60 d1 90 85 d0
Feb 18 10:22:13 h4245005 kernel: 00000010: 38 70 2b 41

With the patch applied nothing shows up in dmesg.

--Jan


> Thanks!
