From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: Crypto test results unused?
Date: Wed, 13 Jan 2010 09:44:05 +1100
Message-ID: <20100112224404.GA5480@gondor.apana.org.au>
References: <20100112111439.GA31504@gondor.apana.org.au> <m37hrn1a4k.fsf@intrepid.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Krzysztof Halasa <khc@pm.waw.pl>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:57131 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750757Ab0ALWoI (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 12 Jan 2010 17:44:08 -0500
Content-Disposition: inline
In-Reply-To: <m37hrn1a4k.fsf@intrepid.localdomain>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Jan 12, 2010 at 06:55:07PM +0100, Krzysztof Halasa wrote:
>
> Currently the /proc/crypto contains:
> 
> - for passed tests: "selftest: passed" (which is of course right)
> 
> - for failed tests: "selftest: unknown" (which is a surprise for me):
> 
> alg: skcipher: Test 1 failed on encryption for ecb(des)-ixp4xx
> 00000000: 01 23 45 67 89 ab cd e7
> 
> name         : ecb(des)
> driver       : ecb(des)-ixp4xx
> module       : ixp4xx_crypto
> priority     : 300
> refcnt       : 1
> selftest     : unknown
> type         : ablkcipher
> async        : yes
> blocksize    : 8
> min keysize  : 8
> max keysize  : 8
> ivsize       : 0
> geniv        : <default>

This is fine.

> - for routines without a test: "selftest: passed" (which isn't true
>   either)
> 
> alg: No test for authenc(hmac(md5),cbc(des)) (authenc(hmac(md5),cbc(des))-ixp4xx)

This should be fixed by adding some code to test authenc algorithms
by combining the test vectors of its components.
 
> I think we need a way to differentiate between "really unknown" and
> "failed", do we need another flag for it?

It doesn't matter.  We test all algorithms at registration time.
So unknown means failed except during registration.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
