From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 0/14] crypto: aead - Phase oute seqniv
Date: Fri, 10 Jul 2015 21:39:22 +0800
Message-ID: <20150710133922.GC17850@gondor.apana.org.au>
References: <20150708231330.GA28797@gondor.apana.org.au>
 <2012703.RafZhkfDBX@tauon.atsec.com>
 <2219094.SOh4kNKiQk@tachyon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:39294 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932312AbbGJNjZ (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 10 Jul 2015 09:39:25 -0400
Content-Disposition: inline
In-Reply-To: <2219094.SOh4kNKiQk@tachyon.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Jul 09, 2015 at 01:38:07PM +0200, Stephan Mueller wrote:
>
> Actually, I found a problem that I have overlooked initally: rfc4106-gcm-aesni 
> causes a problem. For encryption/decryption with the same tests for other 
> rfc4106 implementations, I get an EINVAL.

Did you update your test vectors? The AD must now include the IV.
This is the reason I disabled the AEAD interface in 4.2 by requiring
any exported AEAD algorithm to carry the CRYPTO_ALG_AEAD_NEW flag.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
