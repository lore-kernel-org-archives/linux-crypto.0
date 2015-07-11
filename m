From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 0/14] crypto: aead - Phase oute seqniv
Date: Sat, 11 Jul 2015 10:39:18 +0800
Message-ID: <20150711023918.GB24197@gondor.apana.org.au>
References: <20150708231330.GA28797@gondor.apana.org.au>
 <2219094.SOh4kNKiQk@tachyon.chronox.de>
 <20150710133922.GC17850@gondor.apana.org.au>
 <1566279.T44EXs4eLd@tauon.atsec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:50292 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752382AbbGKIVK (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 11 Jul 2015 04:21:10 -0400
Content-Disposition: inline
In-Reply-To: <1566279.T44EXs4eLd@tauon.atsec.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Jul 10, 2015 at 07:57:11PM +0200, Stephan Mueller wrote:
> Am Freitag, 10. Juli 2015, 21:39:22 schrieb Herbert Xu:
> 
> Hi Herbert,
> 
> >On Thu, Jul 09, 2015 at 01:38:07PM +0200, Stephan Mueller wrote:
> >> Actually, I found a problem that I have overlooked initally:
> >> rfc4106-gcm-aesni causes a problem. For encryption/decryption with the
> >> same tests for other rfc4106 implementations, I get an EINVAL.
> >
> >Did you update your test vectors? The AD must now include the IV.
> >This is the reason I disabled the AEAD interface in 4.2 by requiring
> >any exported AEAD algorithm to carry the CRYPTO_ALG_AEAD_NEW flag.
> 
> I actually did not. But it works with the gcm equivalents as well as the C 
> version of RFC4106. Only rfc4106-gcm-aesni is affected.

Weird.  The C version does the very same check:

static int crypto_rfc4106_decrypt(struct aead_request *req)
{
        if (req->assoclen != 16 && req->assoclen != 20)
                return -EINVAL;

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
