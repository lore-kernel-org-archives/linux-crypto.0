From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 5/8] crypto:chcr: Change cra_flags for cipher algos
Date: Wed, 8 Mar 2017 18:21:08 +0800
Message-ID: <20170308102108.GA5000@gondor.apana.org.au>
References: <cover.1485501428.git.harsh@chelsio.com>
 <19591395286ea8addca8affa595eabd951fda7ff.1485501429.git.harsh@chelsio.com>
 <CAFXBA=mkKinfgLT0vRSXjyW7Lt0V-6o0ud3bdzLZjxqF1je+sg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Harsh Jain <harshjain.prof@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:52309 "EHLO
        helcar.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751750AbdCHKVn (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 8 Mar 2017 05:21:43 -0500
Content-Disposition: inline
In-Reply-To: <CAFXBA=mkKinfgLT0vRSXjyW7Lt0V-6o0ud3bdzLZjxqF1je+sg@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Mar 08, 2017 at 03:28:26PM +0530, Harsh Jain wrote:
>
> If I try above patch on 4.9.13 stable kernel. Kernel  stops executing
> tests for cbc(aes), Same is working fine on cryptodev-2.6 latest tree.
> It seems below patch set has changed the behavior.
> 
> 
> crypto: testmgr - Do not test internal algorithms

On older kernels each ablkcipher gets an geniv instantiated on top
of it.  Therefore the ablkcipher itself is never tested, only the
geniv is tested.

We have since got rid of the geniv and now test the ablkcipher
directly.

There was a period where we didn't generate a geniv but I forgot
to also remove the below chunk which skipped testing the ablkcipher.

> diff --git a/crypto/algboss.c b/crypto/algboss.c
> index 6e39d9c..ccb85e1 100644
> --- a/crypto/algboss.c
> +++ b/crypto/algboss.c
> @@ -247,12 +247,8 @@ static int cryptomgr_schedule_test(struct crypto_alg *alg)
> memcpy(param->alg, alg->cra_name, sizeof(param->alg));
> type = alg->cra_flags;
> - /* This piece of crap needs to disappear into per-type test hooks. */
> - if (!((type ^ CRYPTO_ALG_TYPE_BLKCIPHER) &
> - CRYPTO_ALG_TYPE_BLKCIPHER_MASK) && !(type & CRYPTO_ALG_GENIV) &&
> - ((alg->cra_flags & CRYPTO_ALG_TYPE_MASK) ==
> - CRYPTO_ALG_TYPE_BLKCIPHER ? alg->cra_blkcipher.ivsize :
> - alg->cra_ablkcipher.ivsize))
> + /* Do not test internal algorithms. */
> + if (type & CRYPTO_ALG_INTERNAL)
> type |= CRYPTO_ALG_TESTED;
>
> Its bit confusing for me. Are we supposed to declared it as
> "CRYPTO_ALG_TYPE_BLKCIPHER" for older kernels.

It should definitely be ABLKCIPHER in your case.

Even if the test is skipped your driver should still work.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
