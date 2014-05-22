From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: testmgr - add aead cbc des, des3_ede tests
Date: Thu, 22 May 2014 21:09:34 +0800
Message-ID: <20140522130934.GF3598@gondor.apana.org.au>
References: <1400672348-1658-1-git-send-email-NiteshNarayanLal@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ruchika.gupta@freescale.com, linux-crypto@vger.kernel.org,
	Vakul Garg <vakul@freescale.com>
To: Nitesh Lal <NiteshNarayanLal@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ringil.hengli.com.au ([178.18.16.133]:34639 "EHLO
	ringil.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752935AbaEVNJg (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 22 May 2014 09:09:36 -0400
Content-Disposition: inline
In-Reply-To: <1400672348-1658-1-git-send-email-NiteshNarayanLal@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, May 21, 2014 at 05:09:08PM +0530, Nitesh Lal wrote:
> Test vectors were taken from existing test for
> CBC(DES3_EDE). Associated data has been added to test vectors.
> HMAC computed with Crypto++ has been used. Following algos have
> been covered.
> 
>         (a) "authenc(hmac(sha1),cbc(des))"
>         (b) "authenc(hmac(sha1),cbc(des3_ede))"
>         (c) "authenc(hmac(sha224),cbc(des))"
>         (d) "authenc(hmac(sha224),cbc(des3_ede))"
>         (e) "authenc(hmac(sha256),cbc(des))"
>         (f) "authenc(hmac(sha256),cbc(des3_ede))"
>         (g) "authenc(hmac(sha384),cbc(des))"
>         (h) "authenc(hmac(sha384),cbc(des3_ede))"
>         (i) "authenc(hmac(sha512),cbc(des))"
>         (j) "authenc(hmac(sha512),cbc(des3_ede))"
> 
> Signed-off-by: Vakul Garg <vakul@freescale.com>
> [NiteshNarayanLal@freescale.com: added hooks for the missing algorithms test and tested the patch]
> Signed-off-by: Nitesh Lal <NiteshNarayanLal@freescale.com>

Patch applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
