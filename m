From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: Re: [PATCH] crypto: AF_ALG - fix memory management of aio with multiple iocbs
Date: Fri, 16 Dec 2016 13:27:50 +0100
Message-ID: <2916745.RxhEJByb92@tauon.atsec.com>
References: <4632372.rm33NXUfDp@positron.chronox.de> <20161216115436.GA19917@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:39334 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756602AbcLPM1y (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 16 Dec 2016 07:27:54 -0500
In-Reply-To: <20161216115436.GA19917@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Freitag, 16. Dezember 2016, 19:54:36 CET schrieb Herbert Xu:

Hi Herbert,

> On Tue, Dec 13, 2016 at 09:42:45PM +0100, Stephan Müller wrote:
> > +		/*
> > +		 * The async operation may have processed only a subset of
> > +		 * the data that was initially received from the caller.
> > +		 * Thus, we only can release the data that a cipher operation
> > +		 * processed.
> > +		 */
> > +		if (len < sg->length) {
> > +			/* ensure that empty SGLs are not referenced any more */
> > +			sreq->tsg = sg;
> 
> Hmm if you change sreq->tsg how is the original tsg ever going to
> get freed?

You are right, this will introduce a memleak. But with the immediate freeing 
of sreq->tsg in the current code, the AIO interface cannot support multiple 
IOCBs.

Thus, the entire memory handling in the AIO case seems broken.
> 
> > +
> > +			/* advance the buffers to the unprocessed data */
> > +			sg->length -= len;
> > +			sg->offset += len;
> > +			return;
> > +		}
> > +
> > +		len -= sg->length;
> > +		put_page(page);
> > +	}
> > 
> >  	kfree(sreq->tsg);
> 
> Thanks,



Ciao
Stephan
