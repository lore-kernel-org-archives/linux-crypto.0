From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: AF_ALG - fix memory management of aio with
 multiple iocbs
Date: Fri, 16 Dec 2016 20:31:27 +0800
Message-ID: <20161216123127.GA20406@gondor.apana.org.au>
References: <4632372.rm33NXUfDp@positron.chronox.de>
 <20161216115436.GA19917@gondor.apana.org.au>
 <2916745.RxhEJByb92@tauon.atsec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: linux-crypto@vger.kernel.org
To: Stephan =?iso-8859-1?Q?M=FCller?= <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:46625 "EHLO
        helcar.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1760229AbcLPMbi (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 16 Dec 2016 07:31:38 -0500
Content-Disposition: inline
In-Reply-To: <2916745.RxhEJByb92@tauon.atsec.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Dec 16, 2016 at 01:27:50PM +0100, Stephan Müller wrote:
> Am Freitag, 16. Dezember 2016, 19:54:36 CET schrieb Herbert Xu:
> 
> Hi Herbert,
> 
> > On Tue, Dec 13, 2016 at 09:42:45PM +0100, Stephan Müller wrote:
> > > +		/*
> > > +		 * The async operation may have processed only a subset of
> > > +		 * the data that was initially received from the caller.
> > > +		 * Thus, we only can release the data that a cipher operation
> > > +		 * processed.
> > > +		 */
> > > +		if (len < sg->length) {
> > > +			/* ensure that empty SGLs are not referenced any more */
> > > +			sreq->tsg = sg;
> > 
> > Hmm if you change sreq->tsg how is the original tsg ever going to
> > get freed?
> 
> You are right, this will introduce a memleak. But with the immediate freeing 
> of sreq->tsg in the current code, the AIO interface cannot support multiple 
> IOCBs.
> 
> Thus, the entire memory handling in the AIO case seems broken.

Right, but can we please fix it properly? For example, you could
save the original tsg in a new field and free that when you are
done.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
