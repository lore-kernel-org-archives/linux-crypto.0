From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH 5/8] crypto: drbg - Add stdrng alias and increase priority
Date: Wed, 03 Jun 2015 08:59:13 +0200
Message-ID: <1663398.CPqnxUufLz@tauon>
References: <20150603064641.GA4655@gondor.apana.org.au> <E1Z02US-0001Gy-Hd@gondolin.me.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:46049 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751999AbbFCG71 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 3 Jun 2015 02:59:27 -0400
In-Reply-To: <E1Z02US-0001Gy-Hd@gondolin.me.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Mittwoch, 3. Juni 2015, 14:49:28 schrieb Herbert Xu:

Hi Herbert,

>This patch adds the stdrng module alias and increases the priority
>to ensure that it is loaded in preference to other RNGs.
>
>Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
>---
>
> crypto/drbg.c |    3 ++-
> 1 file changed, 2 insertions(+), 1 deletion(-)
>
>diff --git a/crypto/drbg.c b/crypto/drbg.c
>index 9284348..04836b4 100644
>--- a/crypto/drbg.c
>+++ b/crypto/drbg.c
>@@ -1876,7 +1876,7 @@ static inline void __init drbg_fill_array(struct
>rng_alg *alg, const struct drbg_core *core, int pr)
> {
> 	int pos = 0;
>-	static int priority = 100;
>+	static int priority = 200;

Considering the patch 8/8 which removes krng, wouldn't it make sense to remove 
the following code from the DRBG:

        /*
         * If FIPS mode enabled, the selected DRBG shall have the
         * highest cra_priority over other stdrng instances to ensure
         * it is selected.
         */
        if (fips_enabled)
                alg->base.cra_priority += 200;

That code was added to get a higher prio than the krng in FIPS mode. As this 
is not needed any more (krng is gone), I would say it is safe to remove this 
code too.

>
> 	memcpy(alg->base.cra_name, "stdrng", 6);
> 	if (pr) {
>@@ -1965,3 +1965,4 @@ MODULE_DESCRIPTION("NIST SP800-90A Deterministic Random
>Bit Generator (DRBG) " CRYPTO_DRBG_HASH_STRING
> 		   CRYPTO_DRBG_HMAC_STRING
> 		   CRYPTO_DRBG_CTR_STRING);
>+MODULE_ALIAS_CRYPTO("stdrng");


Ciao
Stephan
