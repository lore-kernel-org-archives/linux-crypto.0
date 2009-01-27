From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: Linux 2.6.28 and AEAD initialization
Date: Tue, 27 Jan 2009 18:01:02 +1100
Message-ID: <20090127070102.GA28643@gondor.apana.org.au>
References: <4976889C.3090602@strongswan.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Andreas Steffen <andreas.steffen@strongswan.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:43636 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751703AbZA0HBF (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 27 Jan 2009 02:01:05 -0500
Content-Disposition: inline
In-Reply-To: <4976889C.3090602@strongswan.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Jan 21, 2009 at 02:29:48AM +0000, Andreas Steffen wrote:
> 
> Because of type=nivaead
> 
>     if (alg->cra_type == &crypto_aead_type)
>         return alg;
> 
> crypto_lookup_aead() does not return the algorithm and falls through
> to the statement
> 
>     return ERR_PTR(crypto_nivaead_default(alg, type, mask));
> 
> which makes another call to algapi.c;__crypto_register_alg().
> Because the driver has already been installed
> 
>     ret = -EEXIST;
>     ...
> 
> 	if (crypto_is_larval(q)) {
> 	    if (!strcmp(alg->cra_driver_name, q->cra_driver_name))
> 	        goto err;
> 	    continue;
> 	}
> 
> __crypto_register_alg() exits with the EEXIST error code.

This can only happen if we find a larval q with a matching driver
name, i.e., there is still an outstanding test on this driver.

Actually I see where the problem is.  When we complete the test
we're notifying everyone of the completion before we take the
test larval off the list.  So if one of the notified parties tries
to register another driver with the same name, then we hit this
error.  This is exactly what aead and givcipher tries to do.

Does this patch help?

crypto: api - Fix algorithm test race that broke aead initialisation

When we complete a test we'll notify everyone waiting on it, drop
the mutex, and then remove the test larval (after reacquiring the
mutex).  If one of the notified parties tries to register another
algorithm with the same driver name prior to the removal of the
test larval, they will fail with EEXIST as only one algorithm of
a given name can be tested at any time.

This broke the initialisation of aead and givcipher algorithms as
they will register two algorithms with the same driver name, in
sequence.

This patch fixes the problem by marking the larval as dead before
we drop the mutex, and also ignoring all dead or dying algorithms
on the registration path.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/crypto/algapi.c b/crypto/algapi.c
index 7c41e74..56c62e2 100644
--- a/crypto/algapi.c
+++ b/crypto/algapi.c
@@ -149,6 +149,9 @@ static struct crypto_larval *__crypto_register_alg(struct crypto_alg *alg)
 		if (q == alg)
 			goto err;
 
+		if (crypto_is_moribund(q))
+			continue;
+
 		if (crypto_is_larval(q)) {
 			if (!strcmp(alg->cra_driver_name, q->cra_driver_name))
 				goto err;
@@ -197,7 +200,7 @@ void crypto_alg_tested(const char *name, int err)
 
 	down_write(&crypto_alg_sem);
 	list_for_each_entry(q, &crypto_alg_list, cra_list) {
-		if (!crypto_is_larval(q))
+		if (crypto_is_moribund(q) || !crypto_is_larval(q))
 			continue;
 
 		test = (struct crypto_larval *)q;
@@ -210,6 +213,7 @@ void crypto_alg_tested(const char *name, int err)
 	goto unlock;
 
 found:
+	q->cra_flags |= CRYPTO_ALG_DEAD;
 	alg = test->adult;
 	if (err || list_empty(&alg->cra_list))
 		goto complete;

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
