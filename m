From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH 0/14] crypto: aead - Phase oute seqniv
Date: Fri, 10 Jul 2015 19:57:11 +0200
Message-ID: <1566279.T44EXs4eLd@tauon.atsec.com>
References: <20150708231330.GA28797@gondor.apana.org.au> <2219094.SOh4kNKiQk@tachyon.chronox.de> <20150710133922.GC17850@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:47947 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932601AbbGJR5P (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 10 Jul 2015 13:57:15 -0400
In-Reply-To: <20150710133922.GC17850@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Freitag, 10. Juli 2015, 21:39:22 schrieb Herbert Xu:

Hi Herbert,

>On Thu, Jul 09, 2015 at 01:38:07PM +0200, Stephan Mueller wrote:
>> Actually, I found a problem that I have overlooked initally:
>> rfc4106-gcm-aesni causes a problem. For encryption/decryption with the
>> same tests for other rfc4106 implementations, I get an EINVAL.
>
>Did you update your test vectors? The AD must now include the IV.
>This is the reason I disabled the AEAD interface in 4.2 by requiring
>any exported AEAD algorithm to carry the CRYPTO_ALG_AEAD_NEW flag.

I actually did not. But it works with the gcm equivalents as well as the C 
version of RFC4106. Only rfc4106-gcm-aesni is affected.

But I will update the invocation.

Thanks


Ciao
Stephan
