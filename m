From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v3] crypto: remove instance when test failed
Date: Thu, 9 Apr 2015 17:40:35 +0800
Message-ID: <20150409094035.GA5327@gondor.apana.org.au>
References: <1461449.htSjBpksos@tachyon.chronox.de>
 <20150409074141.GA4394@gondor.apana.org.au>
 <9590265.Rdkakn8z8k@tauon>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <9590265.Rdkakn8z8k@tauon>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, Apr 09, 2015 at 11:22:19AM +0200, Stephan Mueller wrote:
>
> I tested it and this approach does not work.
> 
> If I see that right, the reason for that is the following: The suggestion is 
> to grab the ref count at the start of the function followed by a 
> __crypto_register_alg. __crypto_register_alg however sets the refcount to 1 
> unconditionally. That means that the final put of the alg will most likely set 
> the refcount to 0 that causes an issue with all other operations (at least I 
> cannot allocate HMAC or CMAC any more -- the ones I currently test).
> 
> So, the grabing of the alg must happen after the invocation of 
> __crypto_register_alg.

Well let's move it then.

---8<---
crypto: api - Move alg ref count init to crypto_check_alg

We currently initialise the crypto_alg ref count in the function
__crypto_register_alg.  As one of the callers of that function
crypto_register_instance needs to obtain a ref count before it
calls __crypto_register_alg, we need to move the initialisation
out of there.

Since both callers of __crypto_register_alg call crypto_check_alg,
this is the logical place to perform the initialisation.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/crypto/algapi.c b/crypto/algapi.c
index f1d0307..1462c68 100644
--- a/crypto/algapi.c
+++ b/crypto/algapi.c
@@ -64,6 +64,8 @@ static int crypto_check_alg(struct crypto_alg *alg)
 	if (alg->cra_priority < 0)
 		return -EINVAL;
 
+	atomic_set(&alg->cra_refcnt, 1);
+
 	return crypto_set_driver_name(alg);
 }
 
@@ -187,7 +189,6 @@ static struct crypto_larval *__crypto_register_alg(struct crypto_alg *alg)
 
 	ret = -EEXIST;
 
-	atomic_set(&alg->cra_refcnt, 1);
 	list_for_each_entry(q, &crypto_alg_list, cra_list) {
 		if (q == alg)
 			goto err;
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
