From: Harald Freudenberger <hfreude@linux.vnet.ibm.com>
Subject: Re: [PATCH] s390/crypto: fix aes ctr concurrency issue
Date: Fri, 29 Nov 2013 09:58:05 +0100
Message-ID: <1385715485.3131.16.camel@myubuntu10>
References: <1384856532-17247-1-git-send-email-freude@linux.vnet.ibm.com>
	 <1384856532-17247-2-git-send-email-freude@linux.vnet.ibm.com>
	 <20131128140045.GA32124@gondor.apana.org.au>
	 <1385653183.3131.14.camel@myubuntu10>
	 <20131129015023.GA5381@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org,
	Martin Schwidefsky <schwidefsky@de.ibm.com>,
	Ingo Tuchscherer <ingo.tuchscherer@linux.vnet.ibm.com>,
	Gerald Schaefer <gerald.schaefer@de.ibm.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from e39.co.us.ibm.com ([32.97.110.160]:50020 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750985Ab3K2I6M (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 29 Nov 2013 03:58:12 -0500
Received: from /spool/local
	by e39.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-crypto@vger.kernel.org> from <hfreude@linux.vnet.ibm.com>;
	Fri, 29 Nov 2013 01:58:11 -0700
Received: from b03cxnp07027.gho.boulder.ibm.com (b03cxnp07027.gho.boulder.ibm.com [9.17.130.14])
	by d03dlp01.boulder.ibm.com (Postfix) with ESMTP id C78D31FF001C
	for <linux-crypto@vger.kernel.org>; Fri, 29 Nov 2013 01:57:49 -0700 (MST)
Received: from d03av06.boulder.ibm.com (d03av06.boulder.ibm.com [9.17.195.245])
	by b03cxnp07027.gho.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id rAT6u7w23670382
	for <linux-crypto@vger.kernel.org>; Fri, 29 Nov 2013 07:56:07 +0100
Received: from d03av06.boulder.ibm.com (loopback [127.0.0.1])
	by d03av06.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id rAT916lW009452
	for <linux-crypto@vger.kernel.org>; Fri, 29 Nov 2013 02:01:07 -0700
In-Reply-To: <20131129015023.GA5381@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, 2013-11-29 at 09:50 +0800, Herbert Xu wrote:
> On Thu, Nov 28, 2013 at 04:39:43PM +0100, Harald Freudenberger wrote:
> >
> > > You can't use mutex_lock because you may be in a non-sleepable
> > > context.  Perhaps just fall back to doing it block-by-block, like
> > > we do in aesni-intel on x86?
> > 
> > The first attempt to lock the mutex is done with mutex_trylock() which
> > should be safe for non-sleepable context. If this fails, an attempt is
> > made to allocate a fresh page __get_free_page(GFP_ATOMIC). If this also
> > fails, well what could be done then ? I think, it is valid to wait for
> > the preallocated page to get released with an mutex_lock(). Should I
> > really add code here for handling the 3rd level of the exceptional
> > path ?
> 
> If it's wrong per se, how does hiding it behind two if's make it
> OK?
Sorry, I got the point now. Will do a rework of the patch according
to your hints. Thanks
