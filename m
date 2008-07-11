From: Jan Glauber <jang@linux.vnet.ibm.com>
Subject: Re: [PATCH] check for s390 crypto facility availablility
Date: Fri, 11 Jul 2008 18:34:10 +0000
Message-ID: <1215801250.9088.10.camel@localhost.localdomain>
References: <1215702043.12011.6.camel@localhost.localdomain>
	 <20080711122938.GA4140@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: linux-crypto <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mtagate7.de.ibm.com ([195.212.29.156]:50300 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752917AbYGKQk3 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 11 Jul 2008 12:40:29 -0400
Received: from d12nrmr1607.megacenter.de.ibm.com (d12nrmr1607.megacenter.de.ibm.com [9.149.167.49])
	by mtagate7.de.ibm.com (8.13.8/8.13.8) with ESMTP id m6BGdqJH034884
	for <linux-crypto@vger.kernel.org>; Fri, 11 Jul 2008 16:39:52 GMT
Received: from d12av02.megacenter.de.ibm.com (d12av02.megacenter.de.ibm.com [9.149.165.228])
	by d12nrmr1607.megacenter.de.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m6BGdqNb2261182
	for <linux-crypto@vger.kernel.org>; Fri, 11 Jul 2008 18:39:52 +0200
Received: from d12av02.megacenter.de.ibm.com (loopback [127.0.0.1])
	by d12av02.megacenter.de.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m6BGdqh0000979
	for <linux-crypto@vger.kernel.org>; Fri, 11 Jul 2008 18:39:52 +0200
In-Reply-To: <20080711122938.GA4140@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, 2008-07-11 at 20:29 +0800, Herbert Xu wrote: 
> On Thu, Jul 10, 2008 at 03:00:43PM +0000, Jan Glauber wrote:
> > 
> > here is a small patch for the s390 crypto detection.
> > 
> > [PATCH] respect STFL bit for s390 crypto
> > 
> > From: <jang@linux.vnet.ibm.com>
> > 
> > For all s390 in-kernel crypto algorithms we check at module
> > load time whether the CPACF facility bit is on. If the facility
> > is not enabled we bail out.
> > 
> > Signed-off-by: <jang@linux.vnet.ibm.com>
> 
> Thanks Jan, the patch looks harmless enough.
> 
> > --- ./arch/s390/crypto/crypt_s390.h.stfle
> > +++ ./arch/s390/crypto/crypt_s390.h
> > @@ -294,6 +294,10 @@ static inline int crypt_s390_func_availa
> >  	unsigned char status[16];
> >  	int ret;
> >  
> > +	/* check if CPACF facility (bit 17) is available */
> > +	if (!(stfl() & 1ULL << (31 - 17)))
> > +		return 0;
> 
> However, the patch description doesn't exactly tell me what
> happens without this check.  I mean, does the machine go up
> in flames if the check would have bailed :)

I see ;- Will resend it with a hopefully better description.

> That leads to my next question, is this something that must
> go into 2.6.26 or can it wait?

It can clearly wait for 2.6.27.

> Cheers,

thanks, Jan

