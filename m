From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 1/6] crypto: tcrypt - Use ahash
Date: Mon, 01 Feb 2016 21:36:49 +0800
Message-ID: <E1aQEev-0002oY-B3@gondolin.me.apana.org.au>
References: <20160201133405.GA10754@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:54913 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932274AbcBANgw (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 1 Feb 2016 08:36:52 -0500
Received: from gondolin.me.apana.org.au ([192.168.0.6])
	by norbury.hengli.com.au with esmtp (Exim 4.80 #3 (Debian))
	id 1aQEev-0002ID-FO
	for <linux-crypto@vger.kernel.org>; Tue, 02 Feb 2016 00:36:49 +1100
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch removes the last user of the obsolete crypto_hash
interface, tcrypt, by simply switching it over to ahash.  In
fact it already has all the code there so it's just a matter
of calling the ahash speed test code with the right mask.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/tcrypt.c |  239 +++-----------------------------------------------------
 1 file changed, 15 insertions(+), 224 deletions(-)

diff --git a/crypto/tcrypt.c b/crypto/tcrypt.c
index 270bc4b..579dce0 100644
--- a/crypto/tcrypt.c
+++ b/crypto/tcrypt.c
@@ -554,164 +554,6 @@ out:
 	crypto_free_blkcipher(tfm);
 }
 
-static int test_hash_jiffies_digest(struct hash_desc *desc,
-				    struct scatterlist *sg, int blen,
-				    char *out, int secs)
-{
-	unsigned long start, end;
-	int bcount;
-	int ret;
-
-	for (start = jiffies, end = start + secs * HZ, bcount = 0;
-	     time_before(jiffies, end); bcount++) {
-		ret = crypto_hash_digest(desc, sg, blen, out);
-		if (ret)
-			return ret;
-	}
-
-	printk("%6u opers/sec, %9lu bytes/sec\n",
-	       bcount / secs, ((long)bcount * blen) / secs);
-
-	return 0;
-}
-
-static int test_hash_jiffies(struct hash_desc *desc, struct scatterlist *sg,
-			     int blen, int plen, char *out, int secs)
-{
-	unsigned long start, end;
-	int bcount, pcount;
-	int ret;
-
-	if (plen == blen)
-		return test_hash_jiffies_digest(desc, sg, blen, out, secs);
-
-	for (start = jiffies, end = start + secs * HZ, bcount = 0;
-	     time_before(jiffies, end); bcount++) {
-		ret = crypto_hash_init(desc);
-		if (ret)
-			return ret;
-		for (pcount = 0; pcount < blen; pcount += plen) {
-			ret = crypto_hash_update(desc, sg, plen);
-			if (ret)
-				return ret;
-		}
-		/* we assume there is enough space in 'out' for the result */
-		ret = crypto_hash_final(desc, out);
-		if (ret)
-			return ret;
-	}
-
-	printk("%6u opers/sec, %9lu bytes/sec\n",
-	       bcount / secs, ((long)bcount * blen) / secs);
-
-	return 0;
-}
-
-static int test_hash_cycles_digest(struct hash_desc *desc,
-				   struct scatterlist *sg, int blen, char *out)
-{
-	unsigned long cycles = 0;
-	int i;
-	int ret;
-
-	local_irq_disable();
-
-	/* Warm-up run. */
-	for (i = 0; i < 4; i++) {
-		ret = crypto_hash_digest(desc, sg, blen, out);
-		if (ret)
-			goto out;
-	}
-
-	/* The real thing. */
-	for (i = 0; i < 8; i++) {
-		cycles_t start, end;
-
-		start = get_cycles();
-
-		ret = crypto_hash_digest(desc, sg, blen, out);
-		if (ret)
-			goto out;
-
-		end = get_cycles();
-
-		cycles += end - start;
-	}
-
-out:
-	local_irq_enable();
-
-	if (ret)
-		return ret;
-
-	printk("%6lu cycles/operation, %4lu cycles/byte\n",
-	       cycles / 8, cycles / (8 * blen));
-
-	return 0;
-}
-
-static int test_hash_cycles(struct hash_desc *desc, struct scatterlist *sg,
-			    int blen, int plen, char *out)
-{
-	unsigned long cycles = 0;
-	int i, pcount;
-	int ret;
-
-	if (plen == blen)
-		return test_hash_cycles_digest(desc, sg, blen, out);
-
-	local_irq_disable();
-
-	/* Warm-up run. */
-	for (i = 0; i < 4; i++) {
-		ret = crypto_hash_init(desc);
-		if (ret)
-			goto out;
-		for (pcount = 0; pcount < blen; pcount += plen) {
-			ret = crypto_hash_update(desc, sg, plen);
-			if (ret)
-				goto out;
-		}
-		ret = crypto_hash_final(desc, out);
-		if (ret)
-			goto out;
-	}
-
-	/* The real thing. */
-	for (i = 0; i < 8; i++) {
-		cycles_t start, end;
-
-		start = get_cycles();
-
-		ret = crypto_hash_init(desc);
-		if (ret)
-			goto out;
-		for (pcount = 0; pcount < blen; pcount += plen) {
-			ret = crypto_hash_update(desc, sg, plen);
-			if (ret)
-				goto out;
-		}
-		ret = crypto_hash_final(desc, out);
-		if (ret)
-			goto out;
-
-		end = get_cycles();
-
-		cycles += end - start;
-	}
-
-out:
-	local_irq_enable();
-
-	if (ret)
-		return ret;
-
-	printk("%6lu cycles/operation, %4lu cycles/byte\n",
-	       cycles / 8, cycles / (8 * blen));
-
-	return 0;
-}
-
 static void test_hash_sg_init(struct scatterlist *sg)
 {
 	int i;
@@ -723,69 +565,6 @@ static void test_hash_sg_init(struct scatterlist *sg)
 	}
 }
 
-static void test_hash_speed(const char *algo, unsigned int secs,
-			    struct hash_speed *speed)
-{
-	struct scatterlist sg[TVMEMSIZE];
-	struct crypto_hash *tfm;
-	struct hash_desc desc;
-	static char output[1024];
-	int i;
-	int ret;
-
-	tfm = crypto_alloc_hash(algo, 0, CRYPTO_ALG_ASYNC);
-
-	if (IS_ERR(tfm)) {
-		printk(KERN_ERR "failed to load transform for %s: %ld\n", algo,
-		       PTR_ERR(tfm));
-		return;
-	}
-
-	printk(KERN_INFO "\ntesting speed of %s (%s)\n", algo,
-			get_driver_name(crypto_hash, tfm));
-
-	desc.tfm = tfm;
-	desc.flags = 0;
-
-	if (crypto_hash_digestsize(tfm) > sizeof(output)) {
-		printk(KERN_ERR "digestsize(%u) > outputbuffer(%zu)\n",
-		       crypto_hash_digestsize(tfm), sizeof(output));
-		goto out;
-	}
-
-	test_hash_sg_init(sg);
-	for (i = 0; speed[i].blen != 0; i++) {
-		if (speed[i].blen > TVMEMSIZE * PAGE_SIZE) {
-			printk(KERN_ERR
-			       "template (%u) too big for tvmem (%lu)\n",
-			       speed[i].blen, TVMEMSIZE * PAGE_SIZE);
-			goto out;
-		}
-
-		if (speed[i].klen)
-			crypto_hash_setkey(tfm, tvmem[0], speed[i].klen);
-
-		printk(KERN_INFO "test%3u "
-		       "(%5u byte blocks,%5u bytes per update,%4u updates): ",
-		       i, speed[i].blen, speed[i].plen, speed[i].blen / speed[i].plen);
-
-		if (secs)
-			ret = test_hash_jiffies(&desc, sg, speed[i].blen,
-						speed[i].plen, output, secs);
-		else
-			ret = test_hash_cycles(&desc, sg, speed[i].blen,
-					       speed[i].plen, output);
-
-		if (ret) {
-			printk(KERN_ERR "hashing failed ret=%d\n", ret);
-			break;
-		}
-	}
-
-out:
-	crypto_free_hash(tfm);
-}
-
 static inline int do_one_ahash_op(struct ahash_request *req, int ret)
 {
 	if (ret == -EINPROGRESS || ret == -EBUSY) {
@@ -945,8 +724,8 @@ out:
 	return 0;
 }
 
-static void test_ahash_speed(const char *algo, unsigned int secs,
-			     struct hash_speed *speed)
+static void test_ahash_speed_common(const char *algo, unsigned int secs,
+				    struct hash_speed *speed, unsigned mask)
 {
 	struct scatterlist sg[TVMEMSIZE];
 	struct tcrypt_result tresult;
@@ -955,7 +734,7 @@ static void test_ahash_speed(const char *algo, unsigned int secs,
 	char *output;
 	int i, ret;
 
-	tfm = crypto_alloc_ahash(algo, 0, 0);
+	tfm = crypto_alloc_ahash(algo, 0, mask);
 	if (IS_ERR(tfm)) {
 		pr_err("failed to load transform for %s: %ld\n",
 		       algo, PTR_ERR(tfm));
@@ -1021,6 +800,18 @@ out:
 	crypto_free_ahash(tfm);
 }
 
+static void test_ahash_speed(const char *algo, unsigned int secs,
+			     struct hash_speed *speed)
+{
+	return test_ahash_speed_common(algo, secs, speed, 0);
+}
+
+static void test_hash_speed(const char *algo, unsigned int secs,
+			    struct hash_speed *speed)
+{
+	return test_ahash_speed_common(algo, secs, speed, CRYPTO_ALG_ASYNC);
+}
+
 static inline int do_one_acipher_op(struct ablkcipher_request *req, int ret)
 {
 	if (ret == -EINPROGRESS || ret == -EBUSY) {
