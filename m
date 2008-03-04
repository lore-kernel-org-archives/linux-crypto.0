From: Jan Glauber <jang@linux.vnet.ibm.com>
Subject: Re: [PATCH 1/4] generic sha_update and sha_final for s390
Date: Tue, 04 Mar 2008 11:26:34 +0100
Message-ID: <1204626394.28341.2.camel@localhost.localdomain>
References: <1204561183.6025.51.camel@localhost.localdomain>
	 <20080303220524.GA30074@Chamillionaire.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	linux-crypto <linux-crypto@vger.kernel.org>
To: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mtagate4.de.ibm.com ([195.212.29.153]:19344 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755747AbYCDK0a (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 4 Mar 2008 05:26:30 -0500
Received: from d12nrmr1607.megacenter.de.ibm.com (d12nrmr1607.megacenter.de.ibm.com [9.149.167.49])
	by mtagate4.de.ibm.com (8.13.8/8.13.8) with ESMTP id m24AQTbw148488
	for <linux-crypto@vger.kernel.org>; Tue, 4 Mar 2008 10:26:29 GMT
Received: from d12av02.megacenter.de.ibm.com (d12av02.megacenter.de.ibm.com [9.149.165.228])
	by d12nrmr1607.megacenter.de.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m24AQTUQ1302610
	for <linux-crypto@vger.kernel.org>; Tue, 4 Mar 2008 11:26:29 +0100
Received: from d12av02.megacenter.de.ibm.com (loopback [127.0.0.1])
	by d12av02.megacenter.de.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m24AQSFG017979
	for <linux-crypto@vger.kernel.org>; Tue, 4 Mar 2008 10:26:29 GMT
In-Reply-To: <20080303220524.GA30074@Chamillionaire.breakpoint.cc>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


On Mon, 2008-03-03 at 23:05 +0100, Sebastian Siewior wrote:
> * Jan Glauber | 2008-03-03 17:19:43 [+0100]:
> >Index: cryptodev-2.6/arch/s390/crypto/sha.h
> >===================================================================
> >--- /dev/null
> >+++ cryptodev-2.6/arch/s390/crypto/sha.h
> >@@ -0,0 +1,34 @@
> >+/*
> >+ * Cryptographic API.
> >+ *
> >+ * s390 generic implementation of the SHA Secure Hash Algorithms.
> >+ *
> >+ * Copyright IBM Corp. 2007
> Just a nitpick: shouldn't this be the year you wrote the code? I really
> don't know.

It actually is the year I wrote the code, I just had to wait for the
hardware announcement ;-

Cheers, Jan

> Sebastian

