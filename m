From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [v2 PATCH 5/11] crypto: drbg - Convert to new rng interface
Date: Tue, 21 Apr 2015 10:46:41 +0800
Message-ID: <E1YkOCv-0007Ke-V4@gondolin.me.apana.org.au>
References: <20150421024436.GA28057@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:51164 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751764AbbDUCqp (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 20 Apr 2015 22:46:45 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch converts the DRBG implementation to the new low-level
rng interface.

This allows us to get rid of struct drbg_gen by using the new RNG
API instead.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/drbg.c         |  123 +++++++++++++++++++++-----------------------------
 include/crypto/drbg.h |   50 ++++----------------
 2 files changed, 66 insertions(+), 107 deletions(-)

diff --git a/crypto/drbg.c b/crypto/drbg.c
index 5bce159..ec6bffd 100644
--- a/crypto/drbg.c
+++ b/crypto/drbg.c
@@ -235,7 +235,7 @@ static bool drbg_fips_continuous_test(struct drbg_state *drbg,
 #ifdef CONFIG_CRYPTO_FIPS
 	int ret = 0;
 	/* skip test if we test the overall system */
-	if (drbg->test_data)
+	if (list_empty(&drbg->test_data.list))
 		return true;
 	/* only perform test in FIPS mode */
 	if (0 == fips_enabled)
@@ -1068,9 +1068,9 @@ static int drbg_seed(struct drbg_state *drbg, struct drbg_string *pers,
 		return -EINVAL;
 	}
 
-	if (drbg->test_data && drbg->test_data->testentropy) {
-		drbg_string_fill(&data1, drbg->test_data->testentropy->buf,
-				 drbg->test_data->testentropy->len);
+	if (list_empty(&drbg->test_data.list)) {
+		drbg_string_fill(&data1, drbg->test_data.buf,
+				 drbg->test_data.len);
 		pr_devel("DRBG: using test entropy\n");
 	} else {
 		/*
@@ -1471,15 +1471,16 @@ static int drbg_uninstantiate(struct drbg_state *drbg)
  * Helper function for setting the test data in the DRBG
  *
  * @drbg DRBG state handle
- * @test_data test data to sets
+ * @data test data
+ * @len test data length
  */
-static inline void drbg_set_testdata(struct drbg_state *drbg,
-				     struct drbg_test_data *test_data)
+static void drbg_kcapi_set_entropy(struct crypto_rng *tfm,
+				   const u8 *data, unsigned int len)
 {
-	if (!test_data || !test_data->testentropy)
-		return;
-	mutex_lock(&drbg->drbg_mutex);;
-	drbg->test_data = test_data;
+	struct drbg_state *drbg = crypto_rng_ctx(tfm);
+
+	mutex_lock(&drbg->drbg_mutex);
+	drbg_string_fill(&drbg->test_data, data, len);
 	mutex_unlock(&drbg->drbg_mutex);
 }
 
@@ -1645,63 +1646,49 @@ static void drbg_kcapi_cleanup(struct crypto_tfm *tfm)
  * Generate random numbers invoked by the kernel crypto API:
  * The API of the kernel crypto API is extended as follows:
  *
- * If dlen is larger than zero, rdata is interpreted as the output buffer
- * where random data is to be stored.
- *
- * If dlen is zero, rdata is interpreted as a pointer to a struct drbg_gen
- * which holds the additional information string that is used for the
- * DRBG generation process. The output buffer that is to be used to store
- * data is also pointed to by struct drbg_gen.
+ * src is additional input supplied to the RNG.
+ * slen is the length of src.
+ * dst is the output buffer where random data is to be stored.
+ * dlen is the length of dst.
  */
-static int drbg_kcapi_random(struct crypto_rng *tfm, u8 *rdata,
-			     unsigned int dlen)
+static int drbg_kcapi_random(struct crypto_rng *tfm,
+			     const u8 *src, unsigned int slen,
+			     u8 *dst, unsigned int dlen)
 {
 	struct drbg_state *drbg = crypto_rng_ctx(tfm);
-	if (0 < dlen) {
-		return drbg_generate_long(drbg, rdata, dlen, NULL);
-	} else {
-		struct drbg_gen *data = (struct drbg_gen *)rdata;
-		struct drbg_string addtl;
-		/* catch NULL pointer */
-		if (!data)
-			return 0;
-		drbg_set_testdata(drbg, data->test_data);
+	struct drbg_string *addtl = NULL;
+	struct drbg_string string;
+
+	if (slen) {
 		/* linked list variable is now local to allow modification */
-		drbg_string_fill(&addtl, data->addtl->buf, data->addtl->len);
-		return drbg_generate_long(drbg, data->outbuf, data->outlen,
-					  &addtl);
+		drbg_string_fill(&string, src, slen);
+		addtl = &string;
 	}
+
+	return drbg_generate_long(drbg, dst, dlen, addtl);
 }
 
 /*
  * Seed the DRBG invoked by the kernel crypto API
- * Similar to the generate function of drbg_kcapi_random, this
- * function extends the kernel crypto API interface with struct drbg_gen
  */
-static int drbg_kcapi_reset(struct crypto_rng *tfm, u8 *seed, unsigned int slen)
+static int drbg_kcapi_seed(struct crypto_rng *tfm,
+			   const u8 *seed, unsigned int slen)
 {
 	struct drbg_state *drbg = crypto_rng_ctx(tfm);
 	struct crypto_tfm *tfm_base = crypto_rng_tfm(tfm);
 	bool pr = false;
-	struct drbg_string seed_string;
+	struct drbg_string string;
+	struct drbg_string *seed_string = NULL;
 	int coreref = 0;
 
 	drbg_convert_tfm_core(crypto_tfm_alg_driver_name(tfm_base), &coreref,
 			      &pr);
 	if (0 < slen) {
-		drbg_string_fill(&seed_string, seed, slen);
-		return drbg_instantiate(drbg, &seed_string, coreref, pr);
-	} else {
-		struct drbg_gen *data = (struct drbg_gen *)seed;
-		/* allow invocation of API call with NULL, 0 */
-		if (!data)
-			return drbg_instantiate(drbg, NULL, coreref, pr);
-		drbg_set_testdata(drbg, data->test_data);
-		/* linked list variable is now local to allow modification */
-		drbg_string_fill(&seed_string, data->addtl->buf,
-				 data->addtl->len);
-		return drbg_instantiate(drbg, &seed_string, coreref, pr);
+		drbg_string_fill(&string, seed, slen);
+		seed_string = &string;
 	}
+
+	return drbg_instantiate(drbg, seed_string, coreref, pr);
 }
 
 /***************************************************************
@@ -1793,32 +1780,31 @@ outbuf:
 #endif /* CONFIG_CRYPTO_FIPS */
 }
 
-static struct crypto_alg drbg_algs[22];
+static struct rng_alg drbg_algs[22];
 
 /*
  * Fill the array drbg_algs used to register the different DRBGs
  * with the kernel crypto API. To fill the array, the information
  * from drbg_cores[] is used.
  */
-static inline void __init drbg_fill_array(struct crypto_alg *alg,
+static inline void __init drbg_fill_array(struct rng_alg *alg,
 					  const struct drbg_core *core, int pr)
 {
 	int pos = 0;
 	static int priority = 100;
 
-	memset(alg, 0, sizeof(struct crypto_alg));
-	memcpy(alg->cra_name, "stdrng", 6);
+	memcpy(alg->base.cra_name, "stdrng", 6);
 	if (pr) {
-		memcpy(alg->cra_driver_name, "drbg_pr_", 8);
+		memcpy(alg->base.cra_driver_name, "drbg_pr_", 8);
 		pos = 8;
 	} else {
-		memcpy(alg->cra_driver_name, "drbg_nopr_", 10);
+		memcpy(alg->base.cra_driver_name, "drbg_nopr_", 10);
 		pos = 10;
 	}
-	memcpy(alg->cra_driver_name + pos, core->cra_name,
+	memcpy(alg->base.cra_driver_name + pos, core->cra_name,
 	       strlen(core->cra_name));
 
-	alg->cra_priority = priority;
+	alg->base.cra_priority = priority;
 	priority++;
 	/*
 	 * If FIPS mode enabled, the selected DRBG shall have the
@@ -1826,17 +1812,16 @@ static inline void __init drbg_fill_array(struct crypto_alg *alg,
 	 * it is selected.
 	 */
 	if (fips_enabled)
-		alg->cra_priority += 200;
-
-	alg->cra_flags		= CRYPTO_ALG_TYPE_RNG;
-	alg->cra_ctxsize 	= sizeof(struct drbg_state);
-	alg->cra_type		= &crypto_rng_type;
-	alg->cra_module		= THIS_MODULE;
-	alg->cra_init		= drbg_kcapi_init;
-	alg->cra_exit		= drbg_kcapi_cleanup;
-	alg->cra_u.rng.rng_make_random	= drbg_kcapi_random;
-	alg->cra_u.rng.rng_reset	= drbg_kcapi_reset;
-	alg->cra_u.rng.seedsize	= 0;
+		alg->base.cra_priority += 200;
+
+	alg->base.cra_ctxsize 	= sizeof(struct drbg_state);
+	alg->base.cra_module	= THIS_MODULE;
+	alg->base.cra_init	= drbg_kcapi_init;
+	alg->base.cra_exit	= drbg_kcapi_cleanup;
+	alg->generate		= drbg_kcapi_random;
+	alg->seed		= drbg_kcapi_seed;
+	alg->set_ent		= drbg_kcapi_set_entropy;
+	alg->seedsize		= 0;
 }
 
 static int __init drbg_init(void)
@@ -1869,12 +1854,12 @@ static int __init drbg_init(void)
 		drbg_fill_array(&drbg_algs[i], &drbg_cores[j], 1);
 	for (j = 0; ARRAY_SIZE(drbg_cores) > j; j++, i++)
 		drbg_fill_array(&drbg_algs[i], &drbg_cores[j], 0);
-	return crypto_register_algs(drbg_algs, (ARRAY_SIZE(drbg_cores) * 2));
+	return crypto_register_rngs(drbg_algs, (ARRAY_SIZE(drbg_cores) * 2));
 }
 
 static void __exit drbg_exit(void)
 {
-	crypto_unregister_algs(drbg_algs, (ARRAY_SIZE(drbg_cores) * 2));
+	crypto_unregister_rngs(drbg_algs, (ARRAY_SIZE(drbg_cores) * 2));
 }
 
 module_init(drbg_init);
diff --git a/include/crypto/drbg.h b/include/crypto/drbg.h
index a43a7ed..480d7a0 100644
--- a/include/crypto/drbg.h
+++ b/include/crypto/drbg.h
@@ -121,7 +121,7 @@ struct drbg_state {
 #endif
 	const struct drbg_state_ops *d_ops;
 	const struct drbg_core *core;
-	struct drbg_test_data *test_data;
+	struct drbg_string test_data;
 };
 
 static inline __u8 drbg_statelen(struct drbg_state *drbg)
@@ -177,19 +177,8 @@ static inline size_t drbg_max_requests(struct drbg_state *drbg)
 }
 
 /*
- * kernel crypto API input data structure for DRBG generate in case dlen
- * is set to 0
- */
-struct drbg_gen {
-	unsigned char *outbuf;	/* output buffer for random numbers */
-	unsigned int outlen;	/* size of output buffer */
-	struct drbg_string *addtl;	/* additional information string */
-	struct drbg_test_data *test_data;	/* test data */
-};
-
-/*
  * This is a wrapper to the kernel crypto API function of
- * crypto_rng_get_bytes() to allow the caller to provide additional data.
+ * crypto_rng_generate() to allow the caller to provide additional data.
  *
  * @drng DRBG handle -- see crypto_rng_get_bytes
  * @outbuf output buffer -- see crypto_rng_get_bytes
@@ -204,21 +193,15 @@ static inline int crypto_drbg_get_bytes_addtl(struct crypto_rng *drng,
 			unsigned char *outbuf, unsigned int outlen,
 			struct drbg_string *addtl)
 {
-	int ret;
-	struct drbg_gen genbuf;
-	genbuf.outbuf = outbuf;
-	genbuf.outlen = outlen;
-	genbuf.addtl = addtl;
-	genbuf.test_data = NULL;
-	ret = crypto_rng_get_bytes(drng, (u8 *)&genbuf, 0);
-	return ret;
+	return crypto_rng_generate(drng, addtl->buf, addtl->len,
+				   outbuf, outlen);
 }
 
 /*
  * TEST code
  *
  * This is a wrapper to the kernel crypto API function of
- * crypto_rng_get_bytes() to allow the caller to provide additional data and
+ * crypto_rng_generate() to allow the caller to provide additional data and
  * allow furnishing of test_data
  *
  * @drng DRBG handle -- see crypto_rng_get_bytes
@@ -236,14 +219,10 @@ static inline int crypto_drbg_get_bytes_addtl_test(struct crypto_rng *drng,
 			struct drbg_string *addtl,
 			struct drbg_test_data *test_data)
 {
-	int ret;
-	struct drbg_gen genbuf;
-	genbuf.outbuf = outbuf;
-	genbuf.outlen = outlen;
-	genbuf.addtl = addtl;
-	genbuf.test_data = test_data;
-	ret = crypto_rng_get_bytes(drng, (u8 *)&genbuf, 0);
-	return ret;
+	crypto_rng_set_entropy(drng, test_data->testentropy->buf,
+			       test_data->testentropy->len);
+	return crypto_rng_generate(drng, addtl->buf, addtl->len,
+				   outbuf, outlen);
 }
 
 /*
@@ -264,14 +243,9 @@ static inline int crypto_drbg_reset_test(struct crypto_rng *drng,
 					 struct drbg_string *pers,
 					 struct drbg_test_data *test_data)
 {
-	int ret;
-	struct drbg_gen genbuf;
-	genbuf.outbuf = NULL;
-	genbuf.outlen = 0;
-	genbuf.addtl = pers;
-	genbuf.test_data = test_data;
-	ret = crypto_rng_reset(drng, (u8 *)&genbuf, 0);
-	return ret;
+	crypto_rng_set_entropy(drng, test_data->testentropy->buf,
+			       test_data->testentropy->len);
+	return crypto_rng_reset(drng, pers->buf, pers->len);
 }
 
 /* DRBG type flags */
