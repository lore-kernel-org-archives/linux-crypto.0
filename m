From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: Crypto Fixes for 2.6.35
Date: Fri, 23 Jul 2010 15:27:46 +0800
Message-ID: <20100723072746.GB4267@gondor.apana.org.au>
References: <20090910141905.GA17948@gondor.apana.org.au> <20091020065442.GA5947@gondor.apana.org.au> <20091230021253.GA17067@gondor.apana.org.au> <20100201195204.GA6953@gondor.apana.org.au> <20100305071043.GA3548@gondor.apana.org.au> <20100427135547.GA4008@gondor.apana.org.au> <20100603100550.GA30681@gondor.apana.org.au> <20100716022648.GA28219@gondor.apana.org.au> <20100722055043.GA25689@gondor.apana.org.au> <AANLkTimqQXuiwgQep4uUrKDIAO2idw51Eu6XiZgs0HsR@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Lee Nipper <lee.nipper@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:40852 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751386Ab0GWH1u (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 23 Jul 2010 03:27:50 -0400
Content-Disposition: inline
In-Reply-To: <AANLkTimqQXuiwgQep4uUrKDIAO2idw51Eu6XiZgs0HsR@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Jul 23, 2010 at 12:17:59AM -0500, Lee Nipper wrote:
>
> But I am curious why this patch
> 
> http://www.mail-archive.com/linux-crypto@vger.kernel.org/msg04660.html
> 
> wasn't nudged along too.  It also fixed a talitos problem with ahash.
> I don't mind if it needs to wait until later;  I'm just curious.

If it causes a crash or has other serious implications then I will
push it.  However, if it simply results in a broken hash computation,
a failure that should be fairly obvious, then it can wait til the
next cycle.

When I looked at it previously I thought it fell into the latter
category, but I might be mistaken.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
