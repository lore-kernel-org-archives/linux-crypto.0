From: Harald Freudenberger <hfreude@linux.vnet.ibm.com>
Subject: Re: [PATCH] s390/crypto: fix aes ctr concurrency issue
Date: Thu, 28 Nov 2013 16:39:43 +0100
Message-ID: <1385653183.3131.14.camel@myubuntu10>
References: <1384856532-17247-1-git-send-email-freude@linux.vnet.ibm.com>
	 <1384856532-17247-2-git-send-email-freude@linux.vnet.ibm.com>
	 <20131128140045.GA32124@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org,
	Martin Schwidefsky <schwidefsky@de.ibm.com>,
	Ingo Tuchscherer <ingo.tuchscherer@linux.vnet.ibm.com>,
	Gerald Schaefer <gerald.schaefer@de.ibm.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from e32.co.us.ibm.com ([32.97.110.150]:45976 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757762Ab3K1Pjt (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 28 Nov 2013 10:39:49 -0500
Received: from /spool/local
	by e32.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-crypto@vger.kernel.org> from <hfreude@linux.vnet.ibm.com>;
	Thu, 28 Nov 2013 08:39:48 -0700
Received: from b03cxnp08025.gho.boulder.ibm.com (b03cxnp08025.gho.boulder.ibm.com [9.17.130.17])
	by d03dlp02.boulder.ibm.com (Postfix) with ESMTP id B6C603E4003F
	for <linux-crypto@vger.kernel.org>; Thu, 28 Nov 2013 08:39:46 -0700 (MST)
Received: from d03av05.boulder.ibm.com (d03av05.boulder.ibm.com [9.17.195.85])
	by b03cxnp08025.gho.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id rASDbu6T7668040
	for <linux-crypto@vger.kernel.org>; Thu, 28 Nov 2013 14:37:56 +0100
Received: from d03av05.boulder.ibm.com (localhost [127.0.0.1])
	by d03av05.boulder.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id rASFdjI2014218
	for <linux-crypto@vger.kernel.org>; Thu, 28 Nov 2013 08:39:46 -0700
In-Reply-To: <20131128140045.GA32124@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, 2013-11-28 at 22:00 +0800, Herbert Xu wrote:
> On Tue, Nov 19, 2013 at 11:22:12AM +0100, Harald Freudenberger wrote:
> > The aes-ctr mode used one preallocated page without any concurrency
> > protection. When multiple threads run aes-ctr encryption or decryption
> > this could lead to data corruption.
> > 
> > The patch introduces locking for the preallocated page and alternatively
> > allocating and freeing of an temp page in concurrency situations.
> 
> You can't use mutex_lock because you may be in a non-sleepable
> context.  Perhaps just fall back to doing it block-by-block, like
> we do in aesni-intel on x86?

The first attempt to lock the mutex is done with mutex_trylock() which
should be safe for non-sleepable context. If this fails, an attempt is
made to allocate a fresh page __get_free_page(GFP_ATOMIC). If this also
fails, well what could be done then ? I think, it is valid to wait for
the preallocated page to get released with an mutex_lock(). Should I
really add code here for handling the 3rd level of the exceptional
path ?

> 
> I have to say that your hardware has a funny way of doing CTR.
> Somebody was generalising out of their backside :)
> 
> Thanks,
