From: "George Spelvin" <linux@horizon.com>
Subject: [PATCH 15/17] crypto: testmgr - Teach test_cprng to handle non-default seed sizes
Date: 2 Dec 2014 03:59:34 -0500
Message-ID: <20141202085934.19592.qmail@ns.horizon.com>
References: <20141202083314.17647.qmail@ns.horizon.com>
Cc: linux-crypto@vger.kernel.org, linux@horizon.com,
	smueller@chronox.de
To: herbert@gondor.apana.org.au, nhorman@tuxdriver.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ns.horizon.com ([71.41.210.147]:42456 "HELO ns.horizon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752013AbaLBI7f (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 2 Dec 2014 03:59:35 -0500
In-Reply-To: <20141202083314.17647.qmail@ns.horizon.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

crypto_rng_seedsize() isn't necessarily enough.

Also (while we're at it), dynamically allocate the result (in the
same buffer) as well.

Signed-off-by: George Spelvin <linux@horizon.com>
---
 crypto/testmgr.c | 27 +++++++++++++++++++++------
 1 file changed, 21 insertions(+), 6 deletions(-)

Much of this gets undone in the next patch, but I wanted to show the idea.

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index 29a0cbdd..b81e593d 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -1449,9 +1449,19 @@ static int test_cprng(struct crypto_rng *tfm, struct cprng_testvec *template,
 	const char *algo = crypto_tfm_alg_driver_name(crypto_rng_tfm(tfm));
 	int err = 0, i, j, seedsize;
 	u8 *seed;
-	char result[32];
 
-	seedsize = crypto_rng_seedsize(tfm);
+	/*
+	 * How big a seed + result buffer do we need?  Note that some
+	 * tests use a non-default seed size, so crypto_rng_seedsize(tfm)
+	 * isn't necessarily enough.
+	 */
+	seedsize = 0;
+	for (i = 0; i < tcount; i++) {
+		j = template[i].vlen + template[i].klen +
+		    template[i].dtlen + template[i].rlen;
+		if (j > seedsize)
+			seedsize = j;
+	}
 
 	seed = kmalloc(seedsize, GFP_KERNEL);
 	if (!seed) {
@@ -1461,13 +1471,16 @@ static int test_cprng(struct crypto_rng *tfm, struct cprng_testvec *template,
 	}
 
 	for (i = 0; i < tcount; i++) {
-		memset(result, 0, 32);
 
 		memcpy(seed, template[i].v, template[i].vlen);
 		memcpy(seed + template[i].vlen, template[i].key,
 		       template[i].klen);
 		memcpy(seed + template[i].vlen + template[i].klen,
 		       template[i].dt, template[i].dtlen);
+		seedsize = template[i].vlen + template[i].klen +
+		           template[i].dtlen +
+
+		memset(seed+seedsize, 0, template[i].rlen);
 
 		err = crypto_rng_reset(tfm, seed, seedsize);
 		if (err) {
@@ -1477,7 +1490,7 @@ static int test_cprng(struct crypto_rng *tfm, struct cprng_testvec *template,
 		}
 
 		for (j = 0; j < template[i].loops; j++) {
-			err = crypto_rng_get_bytes(tfm, result,
+			err = crypto_rng_get_bytes(tfm, seed + seedsize,
 						   template[i].rlen);
 			if (err != template[i].rlen) {
 				printk(KERN_ERR "alg: cprng: Failed to obtain "
@@ -1488,12 +1501,12 @@ static int test_cprng(struct crypto_rng *tfm, struct cprng_testvec *template,
 			}
 		}
 
-		err = memcmp(result, template[i].result,
+		err = memcmp(seed + seedsize, template[i].result,
 			     template[i].rlen);
 		if (err) {
 			printk(KERN_ERR "alg: cprng: Test %d failed for %s\n",
 			       i, algo);
-			hexdump(result, template[i].rlen);
+			hexdump(seed + seedsize, template[i].rlen);
 			err = -EINVAL;
 			goto out;
 		}
@@ -1722,6 +1735,8 @@ static int alg_test_cprng(const struct alg_test_desc *desc, const char *driver,
 
 	crypto_free_rng(rng);
 
+printk("alg_test_cprng: testing %s: err %d\n", driver, err);
+
 	return err;
 }
 
-- 
2.1.3
