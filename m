From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 3/4] crypto: drbg - replace spinlock with mutex
Date: Mon, 20 Apr 2015 08:27:09 +0800
Message-ID: <20150420002709.GB16750@gondor.apana.org.au>
References: <1551177.C0RmlOO9iU@myon.chronox.de>
 <1809889.qql3aDFiri@myon.chronox.de>
 <20150419054803.GA11255@gondor.apana.org.au>
 <1695105.vT0DvueDZS@myon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:37813 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750946AbbDTA1N (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 19 Apr 2015 20:27:13 -0400
Content-Disposition: inline
In-Reply-To: <1695105.vT0DvueDZS@myon.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sun, Apr 19, 2015 at 05:37:21PM +0200, Stephan Mueller wrote:
>
> I am not sure I understand you correctly: shall the DRBG have these 
> precautions? If so, wouldn't we break the requirements in SP800-90A where the 
> DRBG is intended to seed itself?
> 
> Or would you want to update the crypto_alloc_rng routine?

No.  Our API doesn't provide the Instantiate_function obviously.
If you really want to have an explicit instantiate function then
you can provide a wrapper:

crypto_instantiate_drbg(...)
{
	struct crypto_rng *drbg;

	drbg = crypto_alloc_rng(...);
	crypto_rng_reset(drbg, ...);
	return drbg;
}

The fact that crypto_alloc_rng currently instantiates the RNG
is wrong because there is no provision for the personalisation
string.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
