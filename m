From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [patch 2/2] remove similar aes glue code
Date: Sun, 11 Nov 2007 09:18:56 +0800
Message-ID: <20071111011856.GA10745@gondor.apana.org.au>
References: <20071102180503.712394234@ml.breakpoint.cc> <20071102181036.701800933@ml.breakpoint.cc> <20071110111955.GB5485@gondor.apana.org.au> <20071110212000.GC15150@Chamillionaire.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:2177 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750839AbXKKBS6 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 10 Nov 2007 20:18:58 -0500
Received: from gondolin.me.apana.org.au ([192.168.0.6] ident=mail)
	by arnor.apana.org.au with esmtp (Exim 4.50 #1 (Debian))
	id 1Ir1TV-00061F-3E
	for <linux-crypto@vger.kernel.org>; Sun, 11 Nov 2007 12:18:57 +1100
Received: from herbert by gondolin.me.apana.org.au with local (Exim 3.36 #1 (Debian))
	id 1Ir1TU-0002na-00
	for <linux-crypto@vger.kernel.org>; Sun, 11 Nov 2007 09:18:56 +0800
Content-Disposition: inline
In-Reply-To: <20071110212000.GC15150@Chamillionaire.breakpoint.cc>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Sat, Nov 10, 2007 at 10:20:00PM +0100, Sebastian Siewior wrote:
> * Herbert Xu | 2007-11-10 19:19:55 [+0800]:
> 
> >On Sat, Nov 03, 2007 at 11:05:03AM +0100, Sebastian Siewior wrote:
> >>
> >>  static struct crypto_alg aes_alg = {
> >> -	.cra_name		=	"aes",
> >> -	.cra_driver_name	=	"aes-x86_64",
> >> +	.cra_name			=	"aes",
> >> +	.cra_driver_name	=	"aes-asm",
> >
> >This is bad because the algorithm name no longer matches the module
> >name.
> This is case for every aes driver after I renamed them. Or am I missing
> something? You are not talking about cra_drive_name are you?

I meant the cra_driver_name.  Both names can be used to find
the algorithm.

Thanks,

> >I suppose we could rename the modules too, or perhaps just
> >add an alias?
> 
> We can't rename the asm optimized module to aes.ko. Well we could but
> this might be little ugly since we allready haven an alias for AES
> provided by the generic algorithm (on which this algorithm depends on).
> If you are talking about adding an alias which one should it be?
> We allready have an AES alias in the glue code.

You could add an aes-asm alias.

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
