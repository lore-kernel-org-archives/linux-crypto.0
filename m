From: Stephan Mueller <smueller@chronox.de>
Subject: [PATCH 1/4] crypto: CTR DRBG - use CTR AES instead of ECB AES
Date: Fri, 10 Jun 2016 07:56:19 +0200
Message-ID: <1587889.Y1vW5InshL@positron.chronox.de>
References: <3932580.AnntHTzK82@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:36232 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750994AbcFJF7U (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 10 Jun 2016 01:59:20 -0400
In-Reply-To: <3932580.AnntHTzK82@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The CTR DRBG derives its random data from the CTR that is encrypted with
AES.

This patch now changes the CTR DRBG implementation such that the
CTR AES mode is employed. This allows the use of steamlined CTR AES
implementation such as ctr-aes-aesni.

Unfortunately there are the following subtile changes we need to apply
when using the CTR AES mode:

- the CTR mode increments the counter after the cipher operation, but
  the CTR DRBG requires the increment before the cipher op. Hence, the
  crypto_inc is applied to the counter (drbg->V) once it is
  recalculated.

- the CTR mode wants to encrypt data, but the CTR DRBG is interested in
  the encrypted counter only. The full CTR mode is the XOR of the
  encrypted counter with the plaintext data. To access the encrypted
  counter, the patch uses a NULL data vector as plaintext to be
  "encrypted".

Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 crypto/Kconfig        |   1 +
 crypto/drbg.c         | 193 ++++++++++++++++++++++++++++++++++++--------------
 include/crypto/drbg.h |   9 +++
 3 files changed, 149 insertions(+), 54 deletions(-)

diff --git a/crypto/Kconfig b/crypto/Kconfig
index 1d33beb..c903f18 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -1567,6 +1567,7 @@ config CRYPTO_DRBG_HASH
 config CRYPTO_DRBG_CTR
 	bool "Enable CTR DRBG"
 	select CRYPTO_AES
+	depends on CRYPTO_CTR
 	help
 	  Enable the CTR DRBG variant as defined in NIST SP800-90A.
 
diff --git a/crypto/drbg.c b/crypto/drbg.c
index 0aca2b9..4ee1a9c 100644
--- a/crypto/drbg.c
+++ b/crypto/drbg.c
@@ -258,6 +258,7 @@ static int drbg_kcapi_sym(struct drbg_state *drbg, unsigned char *outval,
 			  const struct drbg_string *in);
 static int drbg_init_sym_kernel(struct drbg_state *drbg);
 static int drbg_fini_sym_kernel(struct drbg_state *drbg);
+static int drbg_kcapi_sym_ctr(struct drbg_state *drbg, u8 *outbuf, u32 outlen);
 
 /* BCC function for CTR DRBG as defined in 10.4.3 */
 static int drbg_ctr_bcc(struct drbg_state *drbg,
@@ -482,36 +483,37 @@ static int drbg_ctr_update(struct drbg_state *drbg, struct list_head *seed,
 				 drbg_blocklen(drbg);
 	unsigned char *temp_p, *df_data_p; /* pointer to iterate over buffers */
 	unsigned int len = 0;
-	struct drbg_string cipherin;
 
 	if (3 > reseed)
 		memset(df_data, 0, drbg_statelen(drbg));
 
-	/* 10.2.1.3.2 step 2 and 10.2.1.4.2 step 2 */
-	if (seed) {
-		ret = drbg_ctr_df(drbg, df_data, drbg_statelen(drbg), seed);
+	if (!reseed) {
+		/*
+		 * The DRBG uses the CTR mode of the underlying AES cipher. The
+		 * CTR mode increments the counter value after the AES operation
+		 * but SP800-90A requires that the counter is incremented before
+		 * the AES operation. Hence, we increment it at the time we set
+		 * it by one.
+		 */
+		crypto_inc(drbg->V, drbg_blocklen(drbg));
+
+		ret = crypto_skcipher_setkey(drbg->ctr_handle, drbg->C,
+					     drbg_keylen(drbg));
 		if (ret)
 			goto out;
-		drbg_kcapi_symsetkey(drbg, drbg->C);
 	}
 
-	drbg_string_fill(&cipherin, drbg->V, drbg_blocklen(drbg));
-	/*
-	 * 10.2.1.3.2 steps 2 and 3 are already covered as the allocation
-	 * zeroizes all memory during initialization
-	 */
-	while (len < (drbg_statelen(drbg))) {
-		/* 10.2.1.2 step 2.1 */
-		crypto_inc(drbg->V, drbg_blocklen(drbg));
-		/*
-		 * 10.2.1.2 step 2.2 */
-		ret = drbg_kcapi_sym(drbg, temp + len, &cipherin);
+	/* 10.2.1.3.2 step 2 and 10.2.1.4.2 step 2 */
+	if (seed) {
+		ret = drbg_ctr_df(drbg, df_data, drbg_statelen(drbg), seed);
 		if (ret)
 			goto out;
-		/* 10.2.1.2 step 2.3 and 3 */
-		len += drbg_blocklen(drbg);
 	}
 
+	ret = drbg_kcapi_sym_ctr(drbg, temp, drbg_statelen(drbg));
+	if (ret)
+		return ret;
+
 	/* 10.2.1.2 step 4 */
 	temp_p = temp;
 	df_data_p = df_data;
@@ -522,9 +524,14 @@ static int drbg_ctr_update(struct drbg_state *drbg, struct list_head *seed,
 
 	/* 10.2.1.2 step 5 */
 	memcpy(drbg->C, temp, drbg_keylen(drbg));
-	drbg_kcapi_symsetkey(drbg, drbg->C);
+	ret = crypto_skcipher_setkey(drbg->ctr_handle, drbg->C,
+				     drbg_keylen(drbg));
+	if (ret)
+		goto out;
 	/* 10.2.1.2 step 6 */
 	memcpy(drbg->V, temp + drbg_keylen(drbg), drbg_blocklen(drbg));
+	/* See above: increment counter by one to compensate timing of CTR op */
+	crypto_inc(drbg->V, drbg_blocklen(drbg));
 	ret = 0;
 
 out:
@@ -543,46 +550,26 @@ static int drbg_ctr_generate(struct drbg_state *drbg,
 			     unsigned char *buf, unsigned int buflen,
 			     struct list_head *addtl)
 {
-	int len = 0;
-	int ret = 0;
-	struct drbg_string data;
+	int ret;
+	int len = min_t(int, buflen, INT_MAX);
 
 	/* 10.2.1.5.2 step 2 */
 	if (addtl && !list_empty(addtl)) {
 		ret = drbg_ctr_update(drbg, addtl, 2);
 		if (ret)
 			return 0;
-		drbg_kcapi_symsetkey(drbg, drbg->C);
 	}
 
 	/* 10.2.1.5.2 step 4.1 */
-	crypto_inc(drbg->V, drbg_blocklen(drbg));
-	drbg_string_fill(&data, drbg->V, drbg_blocklen(drbg));
-	while (len < buflen) {
-		int outlen = 0;
-		/* 10.2.1.5.2 step 4.2 */
-		ret = drbg_kcapi_sym(drbg, drbg->scratchpad, &data);
-		if (ret) {
-			len = ret;
-			goto out;
-		}
-		outlen = (drbg_blocklen(drbg) < (buflen - len)) ?
-			  drbg_blocklen(drbg) : (buflen - len);
-		/* 10.2.1.5.2 step 4.3 */
-		memcpy(buf + len, drbg->scratchpad, outlen);
-		len += outlen;
-		/* 10.2.1.5.2 step 6 */
-		if (len < buflen)
-			crypto_inc(drbg->V, drbg_blocklen(drbg));
-	}
+	ret = drbg_kcapi_sym_ctr(drbg, buf, len);
+	if (ret)
+		return ret;
 
 	/* 10.2.1.5.2 step 6 */
 	ret = drbg_ctr_update(drbg, NULL, 3);
 	if (ret)
 		len = ret;
 
-out:
-	memset(drbg->scratchpad, 0, drbg_blocklen(drbg));
 	return len;
 }
 
@@ -1634,10 +1621,46 @@ static int drbg_kcapi_hash(struct drbg_state *drbg, unsigned char *outval,
 #endif /* (CONFIG_CRYPTO_DRBG_HASH || CONFIG_CRYPTO_DRBG_HMAC) */
 
 #ifdef CONFIG_CRYPTO_DRBG_CTR
+static int drbg_fini_sym_kernel(struct drbg_state *drbg)
+{
+	struct crypto_cipher *tfm =
+		(struct crypto_cipher *)drbg->priv_data;
+	if (tfm)
+		crypto_free_cipher(tfm);
+	drbg->priv_data = NULL;
+
+	if (drbg->ctr_handle)
+		crypto_free_skcipher(drbg->ctr_handle);
+	drbg->ctr_handle = NULL;
+
+	if (drbg->ctr_req)
+		skcipher_request_free(drbg->ctr_req);;
+	drbg->ctr_req = NULL;
+
+	kfree(drbg->ctr_null_value_buf);
+	drbg->ctr_null_value = NULL;
+
+	return 0;
+}
+
+static void drbg_skcipher_cb(struct crypto_async_request *req, int error)
+{
+	struct drbg_state *drbg = req->data;
+
+	if (error == -EINPROGRESS)
+		return;
+	drbg->ctr_async_err = error;
+	complete(&drbg->ctr_completion);
+}
+
+#define DRBG_CTR_NULL_LEN 128
 static int drbg_init_sym_kernel(struct drbg_state *drbg)
 {
-	int ret = 0;
 	struct crypto_cipher *tfm;
+	struct crypto_skcipher *sk_tfm;
+	struct skcipher_request *req;
+	unsigned int alignmask;
+	char ctr_name[CRYPTO_MAX_ALG_NAME];
 
 	tfm = crypto_alloc_cipher(drbg->core->backend_cra_name, 0, 0);
 	if (IS_ERR(tfm)) {
@@ -1647,16 +1670,41 @@ static int drbg_init_sym_kernel(struct drbg_state *drbg)
 	}
 	BUG_ON(drbg_blocklen(drbg) != crypto_cipher_blocksize(tfm));
 	drbg->priv_data = tfm;
-	return ret;
-}
 
-static int drbg_fini_sym_kernel(struct drbg_state *drbg)
-{
-	struct crypto_cipher *tfm =
-		(struct crypto_cipher *)drbg->priv_data;
-	if (tfm)
-		crypto_free_cipher(tfm);
-	drbg->priv_data = NULL;
+	if (snprintf(ctr_name, CRYPTO_MAX_ALG_NAME, "ctr(%s)",
+	    drbg->core->backend_cra_name) >= CRYPTO_MAX_ALG_NAME) {
+		drbg_fini_sym_kernel(drbg);
+		return -EINVAL;
+	}
+	sk_tfm = crypto_alloc_skcipher(ctr_name, 0, 0);
+	if (IS_ERR(sk_tfm)) {
+		pr_info("DRBG: could not allocate CTR cipher TFM handle: %s\n",
+				ctr_name);
+		drbg_fini_sym_kernel(drbg);
+		return PTR_ERR(sk_tfm);
+	}
+	drbg->ctr_handle = sk_tfm;
+
+	req = skcipher_request_alloc(sk_tfm, GFP_KERNEL);
+	if (!req) {
+		pr_info("DRBG: could not allocate request queue\n");
+		drbg_fini_sym_kernel(drbg);
+		return PTR_ERR(req);
+	}
+	drbg->ctr_req = req;
+	skcipher_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG,
+					drbg_skcipher_cb, drbg);
+
+	alignmask = crypto_skcipher_alignmask(sk_tfm);
+	drbg->ctr_null_value_buf = kzalloc(DRBG_CTR_NULL_LEN + alignmask,
+					   GFP_KERNEL);
+	if (!drbg->ctr_null_value_buf) {
+		drbg_fini_sym_kernel(drbg);
+		return -ENOMEM;
+	}
+	drbg->ctr_null_value = (u8 *)PTR_ALIGN(drbg->ctr_null_value_buf,
+					       alignmask + 1);
+
 	return 0;
 }
 
@@ -1680,6 +1728,43 @@ static int drbg_kcapi_sym(struct drbg_state *drbg, unsigned char *outval,
 	crypto_cipher_encrypt_one(tfm, outval, in->buf);
 	return 0;
 }
+
+static int drbg_kcapi_sym_ctr(struct drbg_state *drbg, u8 *outbuf, u32 outlen)
+{
+	struct scatterlist sg_in;
+
+	sg_init_one(&sg_in, drbg->ctr_null_value, DRBG_CTR_NULL_LEN);
+
+	while (outlen) {
+		u32 cryptlen = min_t(u32, outlen, DRBG_CTR_NULL_LEN);
+		struct scatterlist sg_out;
+		int ret;
+
+		sg_init_one(&sg_out, outbuf, cryptlen);
+		skcipher_request_set_crypt(drbg->ctr_req, &sg_in, &sg_out,
+					   cryptlen, drbg->V);
+		ret = crypto_skcipher_encrypt(drbg->ctr_req);
+		switch (ret) {
+		case 0:
+			break;
+		case -EINPROGRESS:
+		case -EBUSY:
+			ret = wait_for_completion_interruptible(
+				&drbg->ctr_completion);
+			if (!ret && !drbg->ctr_async_err) {
+				reinit_completion(&drbg->ctr_completion);
+				break;
+			}
+		default:
+			return ret;
+		}
+		init_completion(&drbg->ctr_completion);
+
+		outlen -= cryptlen;
+	}
+
+	return 0;
+}
 #endif /* CONFIG_CRYPTO_DRBG_CTR */
 
 /***************************************************************
diff --git a/include/crypto/drbg.h b/include/crypto/drbg.h
index d961b2b..b2fe15d 100644
--- a/include/crypto/drbg.h
+++ b/include/crypto/drbg.h
@@ -43,6 +43,7 @@
 #include <linux/random.h>
 #include <linux/scatterlist.h>
 #include <crypto/hash.h>
+#include <crypto/skcipher.h>
 #include <linux/module.h>
 #include <linux/crypto.h>
 #include <linux/slab.h>
@@ -115,6 +116,14 @@ struct drbg_state {
 	 /* some memory the DRBG can use for its operation */
 	unsigned char *scratchpad;
 	void *priv_data;	/* Cipher handle */
+
+	struct crypto_skcipher *ctr_handle;	/* CTR mode cipher handle */
+	struct skcipher_request *ctr_req;	/* CTR mode request handle */
+	__u8 *ctr_null_value_buf;		/* CTR mode unaligned buffer */
+	__u8 *ctr_null_value;			/* CTR mode aligned zero buf */
+	struct completion ctr_completion;	/* CTR mode async handler */
+	int ctr_async_err;			/* CTR mode async error */
+
 	bool seeded;		/* DRBG fully seeded? */
 	bool pr;		/* Prediction resistance enabled? */
 	struct work_struct seed_work;	/* asynchronous seeding support */
-- 
2.5.5
