From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: fix larval lookup
Date: Tue, 19 Aug 2008 15:05:45 +1000
Message-ID: <E1KVJPd-0007er-00@gondolin.me.apana.org.au>
References: <20080818070204.GL22567@mail3.prorata.de>
Cc: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org
To: christian@hohnstaedt.de (Christian Hohnstaedt)
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:58033 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751269AbYHSFFs (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 19 Aug 2008 01:05:48 -0400
In-Reply-To: <20080818070204.GL22567@mail3.prorata.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Christian Hohnstaedt <christian@hohnstaedt.de> wrote:
> 
> crypto_alg_mod_lookup() runs in a timeout (60s) for unknown algos.
> 
> crypto_larval_error() doesn't find the larval and thus doesn't
> finish crypto_larval_wait, because
> the larval->mask has the CRYPTO_ALG_TESTED bit set, while
> crypto_alg_lookup() is called without that bit in the mask
> and the mask comparison in __crypto_alg_lookup fails.
> 
> Since larvals itself never get tested, it seems ok to 
> reset that bit.
> 
> Signed-off-by: Christian Hohnstaedt <chohnstaedt@innominate.com>

Thanks for catching this! However, we do want to keep the TESTED
bit in case someone specifically requests for an untested algorithm.

So I'm going to fix it as follows, by using the original type
and mask for error propagation.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
--
diff --git a/crypto/algboss.c b/crypto/algboss.c
index a635784..d6dc18f 100644
--- a/crypto/algboss.c
+++ b/crypto/algboss.c
@@ -45,6 +45,9 @@ struct cryptomgr_param {
 
 	char larval[CRYPTO_MAX_ALG_NAME];
 	char template[CRYPTO_MAX_ALG_NAME];
+
+	u32 otype;
+	u32 omask;
 };
 
 struct crypto_test_param {
@@ -82,8 +85,7 @@ out:
 	module_put_and_exit(0);
 
 err:
-	crypto_larval_error(param->larval, param->type.data.type,
-			    param->type.data.mask);
+	crypto_larval_error(param->larval, param->otype, param->omask);
 	goto out;
 }
 
@@ -179,6 +181,9 @@ static int cryptomgr_schedule_probe(struct crypto_larval *larval)
 	param->type.data.mask = larval->mask & ~CRYPTO_ALG_TESTED;
 	param->tb[0] = &param->type.attr;
 
+	param->otype = larval->alg.cra_flags;
+	param->omask = larval->mask;
+
 	memcpy(param->larval, larval->alg.cra_name, CRYPTO_MAX_ALG_NAME);
 
 	thread = kthread_run(cryptomgr_probe, param, "cryptomgr_probe");
