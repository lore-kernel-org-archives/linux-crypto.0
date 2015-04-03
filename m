From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH v2] crypto: remove instance when test failed
Date: Fri, 03 Apr 2015 17:17:13 +0200
Message-ID: <1731327.mgbsjj4MeV@tachyon.chronox.de>
References: <3394653.LODBE1uz62@tachyon.chronox.de> <20150403095828.GA19273@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:58125 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752582AbbDCPRR (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 3 Apr 2015 11:17:17 -0400
In-Reply-To: <20150403095828.GA19273@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Freitag, 3. April 2015, 17:58:28 schrieb Herbert Xu:

Hi Herbert,

> On Thu, Apr 02, 2015 at 07:05:27PM +0200, Stephan Mueller wrote:
> > diff --git a/crypto/algapi.c b/crypto/algapi.c
> > index 83b04e0..215c604 100644
> > --- a/crypto/algapi.c
> > +++ b/crypto/algapi.c
> > 
> > @@ -545,6 +545,10 @@ unlock:
> >  		goto err;
> >  	
> >  	crypto_wait_for_test(larval);
> > 
> > +
> > +	/* Remove instance if test failed */
> > +	if (!(inst->alg.cra_flags & CRYPTO_ALG_TESTED))
> > +		crypto_unregister_instance(inst);
> 
> Unfortunately I don't think this is safe because the moment you
> release the mutex the instance can be freed.  So you'll need to
> hold a reference to it.
> 
> Cheers,

Wpuldn't crypto_del_alg suffer from the same issue? I see that the cra_refcnt 
is checked. But I guess there would be the same kind of race?

-- 
Ciao
Stephan
