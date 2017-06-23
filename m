From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: Re: [PATCH v10 1/2] crypto: skcipher AF_ALG - overhaul memory management
Date: Fri, 23 Jun 2017 11:06:30 +0200
Message-ID: <13379757.uGWUeJijgc@tauon.chronox.de>
References: <16464524.Q9cOxD7cVH@positron.chronox.de> <8143872.gWNkduROBH@positron.chronox.de> <20170623061048.GA28869@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:60358 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753972AbdFWJGc (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 23 Jun 2017 05:06:32 -0400
In-Reply-To: <20170623061048.GA28869@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Freitag, 23. Juni 2017, 08:10:48 CEST schrieb Herbert Xu:

Hi Herbert,

> On Wed, Jun 21, 2017 at 10:03:02PM +0200, Stephan Müller wrote:
> > +	/* convert iovecs of output buffers into RX SGL */
> > +	while (len < ctx->used && msg_data_left(msg)) {
> 
> How are we supposed to reach the wait path when ctx->used == 0?

Right. 

May I ask whether that wait is correct to begin with? The recvmsg is protected 
by a lock_sock. Thus, if the code is waiting, the lock is still held. So, how 
can data be inserted into the socket by sendmsg/sendpage while recvmsg is 
waiting? Don't we have a deadlock here?
> 
> > +		/*
> > +		 * This error covers -EIOCBQUEUED which implies that we can
> > +		 * only handle one AIO request. If the caller wants to have
> > +		 * multiple AIO requests in parallel, he must make multiple
> > +		 * separate AIO calls.
> > +		 */
> > +		if (err < 0) {
> > +			if (err == -EIOCBQUEUED)
> > +				ret = err;
> > +			goto out;
> > 
> >  		}
> > 
> > +		if (!err)
> > +			goto out;
> 
> You can combine the two now as err <= 0.

Fixed, thank you.
> 
> Thanks,



Ciao
Stephan
