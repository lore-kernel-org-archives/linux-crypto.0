From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [v3 PATCH 10/16] crypto: testmgr - Do not test internal algorithms
Date: Tue, 22 Nov 2016 20:08:31 +0800
Message-ID: <E1c99sF-00038y-4u@gondobar>
References: <20161122120703.GA11911@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:33649 "EHLO
        helcar.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S932744AbcKVMIu (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 22 Nov 2016 07:08:50 -0500
Received: from [192.168.128.4] (helo=gondobar)
        by fornost.hengli.com.au with esmtp (Exim 4.80 #3 (Debian))
        id 1c99sS-00064h-Sh
        for <linux-crypto@vger.kernel.org>; Tue, 22 Nov 2016 23:08:46 +1100
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Currently we manually filter out internal algorithms using a list
in testmgr.  This is dangerous as internal algorithms cannot be
safely used even by testmgr.  This patch ensures that they're never
processed by testmgr at all.

This patch also removes an obsolete bypass for nivciphers which
no longer exist.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/algboss.c |    8 --
 crypto/testmgr.c |  153 +++----------------------------------------------------
 2 files changed, 11 insertions(+), 150 deletions(-)

diff --git a/crypto/algboss.c b/crypto/algboss.c
index 6e39d9c..ccb85e1 100644
--- a/crypto/algboss.c
+++ b/crypto/algboss.c
@@ -247,12 +247,8 @@ static int cryptomgr_schedule_test(struct crypto_alg *alg)
 	memcpy(param->alg, alg->cra_name, sizeof(param->alg));
 	type = alg->cra_flags;
 
-	/* This piece of crap needs to disappear into per-type test hooks. */
-	if (!((type ^ CRYPTO_ALG_TYPE_BLKCIPHER) &
-	      CRYPTO_ALG_TYPE_BLKCIPHER_MASK) && !(type & CRYPTO_ALG_GENIV) &&
-	    ((alg->cra_flags & CRYPTO_ALG_TYPE_MASK) ==
-	     CRYPTO_ALG_TYPE_BLKCIPHER ? alg->cra_blkcipher.ivsize :
-					 alg->cra_ablkcipher.ivsize))
+	/* Do not test internal algorithms. */
+	if (type & CRYPTO_ALG_INTERNAL)
 		type |= CRYPTO_ALG_TESTED;
 
 	param->type = type;
diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index ded50b6..6ac4696 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -1625,7 +1625,7 @@ static int alg_test_aead(const struct alg_test_desc *desc, const char *driver,
 	struct crypto_aead *tfm;
 	int err = 0;
 
-	tfm = crypto_alloc_aead(driver, type | CRYPTO_ALG_INTERNAL, mask);
+	tfm = crypto_alloc_aead(driver, type, mask);
 	if (IS_ERR(tfm)) {
 		printk(KERN_ERR "alg: aead: Failed to load transform for %s: "
 		       "%ld\n", driver, PTR_ERR(tfm));
@@ -1654,7 +1654,7 @@ static int alg_test_cipher(const struct alg_test_desc *desc,
 	struct crypto_cipher *tfm;
 	int err = 0;
 
-	tfm = crypto_alloc_cipher(driver, type | CRYPTO_ALG_INTERNAL, mask);
+	tfm = crypto_alloc_cipher(driver, type, mask);
 	if (IS_ERR(tfm)) {
 		printk(KERN_ERR "alg: cipher: Failed to load transform for "
 		       "%s: %ld\n", driver, PTR_ERR(tfm));
@@ -1683,7 +1683,7 @@ static int alg_test_skcipher(const struct alg_test_desc *desc,
 	struct crypto_skcipher *tfm;
 	int err = 0;
 
-	tfm = crypto_alloc_skcipher(driver, type | CRYPTO_ALG_INTERNAL, mask);
+	tfm = crypto_alloc_skcipher(driver, type, mask);
 	if (IS_ERR(tfm)) {
 		printk(KERN_ERR "alg: skcipher: Failed to load transform for "
 		       "%s: %ld\n", driver, PTR_ERR(tfm));
@@ -1750,7 +1750,7 @@ static int alg_test_hash(const struct alg_test_desc *desc, const char *driver,
 	struct crypto_ahash *tfm;
 	int err;
 
-	tfm = crypto_alloc_ahash(driver, type | CRYPTO_ALG_INTERNAL, mask);
+	tfm = crypto_alloc_ahash(driver, type, mask);
 	if (IS_ERR(tfm)) {
 		printk(KERN_ERR "alg: hash: Failed to load transform for %s: "
 		       "%ld\n", driver, PTR_ERR(tfm));
@@ -1778,7 +1778,7 @@ static int alg_test_crc32c(const struct alg_test_desc *desc,
 	if (err)
 		goto out;
 
-	tfm = crypto_alloc_shash(driver, type | CRYPTO_ALG_INTERNAL, mask);
+	tfm = crypto_alloc_shash(driver, type, mask);
 	if (IS_ERR(tfm)) {
 		printk(KERN_ERR "alg: crc32c: Failed to load transform for %s: "
 		       "%ld\n", driver, PTR_ERR(tfm));
@@ -1820,7 +1820,7 @@ static int alg_test_cprng(const struct alg_test_desc *desc, const char *driver,
 	struct crypto_rng *rng;
 	int err;
 
-	rng = crypto_alloc_rng(driver, type | CRYPTO_ALG_INTERNAL, mask);
+	rng = crypto_alloc_rng(driver, type, mask);
 	if (IS_ERR(rng)) {
 		printk(KERN_ERR "alg: cprng: Failed to load transform for %s: "
 		       "%ld\n", driver, PTR_ERR(rng));
@@ -1847,7 +1847,7 @@ static int drbg_cavs_test(struct drbg_testvec *test, int pr,
 	if (!buf)
 		return -ENOMEM;
 
-	drng = crypto_alloc_rng(driver, type | CRYPTO_ALG_INTERNAL, mask);
+	drng = crypto_alloc_rng(driver, type, mask);
 	if (IS_ERR(drng)) {
 		printk(KERN_ERR "alg: drbg: could not allocate DRNG handle for "
 		       "%s\n", driver);
@@ -2041,7 +2041,7 @@ static int alg_test_kpp(const struct alg_test_desc *desc, const char *driver,
 	struct crypto_kpp *tfm;
 	int err = 0;
 
-	tfm = crypto_alloc_kpp(driver, type | CRYPTO_ALG_INTERNAL, mask);
+	tfm = crypto_alloc_kpp(driver, type, mask);
 	if (IS_ERR(tfm)) {
 		pr_err("alg: kpp: Failed to load tfm for %s: %ld\n",
 		       driver, PTR_ERR(tfm));
@@ -2200,7 +2200,7 @@ static int alg_test_akcipher(const struct alg_test_desc *desc,
 	struct crypto_akcipher *tfm;
 	int err = 0;
 
-	tfm = crypto_alloc_akcipher(driver, type | CRYPTO_ALG_INTERNAL, mask);
+	tfm = crypto_alloc_akcipher(driver, type, mask);
 	if (IS_ERR(tfm)) {
 		pr_err("alg: akcipher: Failed to load tfm for %s: %ld\n",
 		       driver, PTR_ERR(tfm));
@@ -2223,88 +2223,6 @@ static int alg_test_null(const struct alg_test_desc *desc,
 /* Please keep this list sorted by algorithm name. */
 static const struct alg_test_desc alg_test_descs[] = {
 	{
-		.alg = "__cbc-cast5-avx",
-		.test = alg_test_null,
-	}, {
-		.alg = "__cbc-cast6-avx",
-		.test = alg_test_null,
-	}, {
-		.alg = "__cbc-serpent-avx",
-		.test = alg_test_null,
-	}, {
-		.alg = "__cbc-serpent-avx2",
-		.test = alg_test_null,
-	}, {
-		.alg = "__cbc-serpent-sse2",
-		.test = alg_test_null,
-	}, {
-		.alg = "__cbc-twofish-avx",
-		.test = alg_test_null,
-	}, {
-		.alg = "__driver-cbc-aes-aesni",
-		.test = alg_test_null,
-		.fips_allowed = 1,
-	}, {
-		.alg = "__driver-cbc-camellia-aesni",
-		.test = alg_test_null,
-	}, {
-		.alg = "__driver-cbc-camellia-aesni-avx2",
-		.test = alg_test_null,
-	}, {
-		.alg = "__driver-cbc-cast5-avx",
-		.test = alg_test_null,
-	}, {
-		.alg = "__driver-cbc-cast6-avx",
-		.test = alg_test_null,
-	}, {
-		.alg = "__driver-cbc-serpent-avx",
-		.test = alg_test_null,
-	}, {
-		.alg = "__driver-cbc-serpent-avx2",
-		.test = alg_test_null,
-	}, {
-		.alg = "__driver-cbc-serpent-sse2",
-		.test = alg_test_null,
-	}, {
-		.alg = "__driver-cbc-twofish-avx",
-		.test = alg_test_null,
-	}, {
-		.alg = "__driver-ecb-aes-aesni",
-		.test = alg_test_null,
-		.fips_allowed = 1,
-	}, {
-		.alg = "__driver-ecb-camellia-aesni",
-		.test = alg_test_null,
-	}, {
-		.alg = "__driver-ecb-camellia-aesni-avx2",
-		.test = alg_test_null,
-	}, {
-		.alg = "__driver-ecb-cast5-avx",
-		.test = alg_test_null,
-	}, {
-		.alg = "__driver-ecb-cast6-avx",
-		.test = alg_test_null,
-	}, {
-		.alg = "__driver-ecb-serpent-avx",
-		.test = alg_test_null,
-	}, {
-		.alg = "__driver-ecb-serpent-avx2",
-		.test = alg_test_null,
-	}, {
-		.alg = "__driver-ecb-serpent-sse2",
-		.test = alg_test_null,
-	}, {
-		.alg = "__driver-ecb-twofish-avx",
-		.test = alg_test_null,
-	}, {
-		.alg = "__driver-gcm-aes-aesni",
-		.test = alg_test_null,
-		.fips_allowed = 1,
-	}, {
-		.alg = "__ghash-pclmulqdqni",
-		.test = alg_test_null,
-		.fips_allowed = 1,
-	}, {
 		.alg = "ansi_cprng",
 		.test = alg_test_cprng,
 		.suite = {
@@ -2791,55 +2709,6 @@ static int alg_test_null(const struct alg_test_desc *desc,
 			}
 		}
 	}, {
-		.alg = "cryptd(__driver-cbc-aes-aesni)",
-		.test = alg_test_null,
-		.fips_allowed = 1,
-	}, {
-		.alg = "cryptd(__driver-cbc-camellia-aesni)",
-		.test = alg_test_null,
-	}, {
-		.alg = "cryptd(__driver-cbc-camellia-aesni-avx2)",
-		.test = alg_test_null,
-	}, {
-		.alg = "cryptd(__driver-cbc-serpent-avx2)",
-		.test = alg_test_null,
-	}, {
-		.alg = "cryptd(__driver-ecb-aes-aesni)",
-		.test = alg_test_null,
-		.fips_allowed = 1,
-	}, {
-		.alg = "cryptd(__driver-ecb-camellia-aesni)",
-		.test = alg_test_null,
-	}, {
-		.alg = "cryptd(__driver-ecb-camellia-aesni-avx2)",
-		.test = alg_test_null,
-	}, {
-		.alg = "cryptd(__driver-ecb-cast5-avx)",
-		.test = alg_test_null,
-	}, {
-		.alg = "cryptd(__driver-ecb-cast6-avx)",
-		.test = alg_test_null,
-	}, {
-		.alg = "cryptd(__driver-ecb-serpent-avx)",
-		.test = alg_test_null,
-	}, {
-		.alg = "cryptd(__driver-ecb-serpent-avx2)",
-		.test = alg_test_null,
-	}, {
-		.alg = "cryptd(__driver-ecb-serpent-sse2)",
-		.test = alg_test_null,
-	}, {
-		.alg = "cryptd(__driver-ecb-twofish-avx)",
-		.test = alg_test_null,
-	}, {
-		.alg = "cryptd(__driver-gcm-aes-aesni)",
-		.test = alg_test_null,
-		.fips_allowed = 1,
-	}, {
-		.alg = "cryptd(__ghash-pclmulqdqni)",
-		.test = alg_test_null,
-		.fips_allowed = 1,
-	}, {
 		.alg = "ctr(aes)",
 		.test = alg_test_skcipher,
 		.fips_allowed = 1,
@@ -3166,10 +3035,6 @@ static int alg_test_null(const struct alg_test_desc *desc,
 		.fips_allowed = 1,
 		.test = alg_test_null,
 	}, {
-		.alg = "ecb(__aes-aesni)",
-		.test = alg_test_null,
-		.fips_allowed = 1,
-	}, {
 		.alg = "ecb(aes)",
 		.test = alg_test_skcipher,
 		.fips_allowed = 1,
