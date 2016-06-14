From: Stephan Mueller <smueller@chronox.de>
Subject: [PATCH v2 2/4] crypto: DRBG - use aligned buffers
Date: Tue, 14 Jun 2016 07:35:13 +0200
Message-ID: <2811728.SouGpRTfX4@positron.chronox.de>
References: <1842774.dgV8IOeQEu@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:36444 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751070AbcFNFgY (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 14 Jun 2016 01:36:24 -0400
In-Reply-To: <1842774.dgV8IOeQEu@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hardware cipher implementation may require aligned buffers. All buffers
that potentially are processed with a cipher are now aligned.

At the time of the allocation of the memory, we have not yet allocated
the cipher implementations. Hence, we cannot obtain the alignmask for
the used cipher yet. Therefore, the DRBG code uses an alignment which
should satisfy all cipher implementations.

Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 crypto/drbg.c         | 44 ++++++++++++++++++++++++--------------------
 include/crypto/drbg.h |  3 +++
 2 files changed, 27 insertions(+), 20 deletions(-)

diff --git a/crypto/drbg.c b/crypto/drbg.c
index 4ee1a9c..8ac3ea1 100644
--- a/crypto/drbg.c
+++ b/crypto/drbg.c
@@ -1139,11 +1139,11 @@ static inline void drbg_dealloc_state(struct drbg_state *drbg)
 	if (!drbg)
 		return;
 	kzfree(drbg->V);
-	drbg->V = NULL;
+	drbg->Vbuf = NULL;
 	kzfree(drbg->C);
-	drbg->C = NULL;
-	kzfree(drbg->scratchpad);
-	drbg->scratchpad = NULL;
+	drbg->Cbuf = NULL;
+	kzfree(drbg->scratchpadbuf);
+	drbg->scratchpadbuf = NULL;
 	drbg->reseed_ctr = 0;
 	drbg->d_ops = NULL;
 	drbg->core = NULL;
@@ -1179,12 +1179,18 @@ static inline int drbg_alloc_state(struct drbg_state *drbg)
 		goto err;
 	}
 
-	drbg->V = kmalloc(drbg_statelen(drbg), GFP_KERNEL);
-	if (!drbg->V)
-		goto err;
-	drbg->C = kmalloc(drbg_statelen(drbg), GFP_KERNEL);
-	if (!drbg->C)
+	ret = drbg->d_ops->crypto_init(drbg);
+	if (ret < 0)
 		goto err;
+
+	drbg->Vbuf = kmalloc(drbg_statelen(drbg) + ret, GFP_KERNEL);
+	if (!drbg->Vbuf)
+		goto fini;
+	drbg->V = PTR_ALIGN(drbg->Vbuf, ret + 1);
+	drbg->Cbuf = kmalloc(drbg_statelen(drbg) + ret, GFP_KERNEL);
+	if (!drbg->Cbuf)
+		goto fini;
+	drbg->C = PTR_ALIGN(drbg->Cbuf, ret + 1);
 	/* scratchpad is only generated for CTR and Hash */
 	if (drbg->core->flags & DRBG_HMAC)
 		sb_size = 0;
@@ -1198,13 +1204,16 @@ static inline int drbg_alloc_state(struct drbg_state *drbg)
 		sb_size = drbg_statelen(drbg) + drbg_blocklen(drbg);
 
 	if (0 < sb_size) {
-		drbg->scratchpad = kzalloc(sb_size, GFP_KERNEL);
-		if (!drbg->scratchpad)
-			goto err;
+		drbg->scratchpadbuf = kzalloc(sb_size + ret, GFP_KERNEL);
+		if (!drbg->scratchpadbuf)
+			goto fini;
+		drbg->scratchpad = PTR_ALIGN(drbg->scratchpadbuf, ret + 1);
 	}
 
 	return 0;
 
+fini:
+	drbg->d_ops->crypto_fini(drbg);
 err:
 	drbg_dealloc_state(drbg);
 	return ret;
@@ -1472,10 +1481,6 @@ static int drbg_instantiate(struct drbg_state *drbg, struct drbg_string *pers,
 		if (ret)
 			goto unlock;
 
-		ret = -EFAULT;
-		if (drbg->d_ops->crypto_init(drbg))
-			goto err;
-
 		ret = drbg_prepare_hrng(drbg);
 		if (ret)
 			goto free_everything;
@@ -1499,8 +1504,6 @@ static int drbg_instantiate(struct drbg_state *drbg, struct drbg_string *pers,
 	mutex_unlock(&drbg->drbg_mutex);
 	return ret;
 
-err:
-	drbg_dealloc_state(drbg);
 unlock:
 	mutex_unlock(&drbg->drbg_mutex);
 	return ret;
@@ -1585,7 +1588,8 @@ static int drbg_init_hash_kernel(struct drbg_state *drbg)
 	sdesc->shash.tfm = tfm;
 	sdesc->shash.flags = 0;
 	drbg->priv_data = sdesc;
-	return 0;
+
+	return crypto_shash_alignmask(tfm);
 }
 
 static int drbg_fini_hash_kernel(struct drbg_state *drbg)
@@ -1705,7 +1709,7 @@ static int drbg_init_sym_kernel(struct drbg_state *drbg)
 	drbg->ctr_null_value = (u8 *)PTR_ALIGN(drbg->ctr_null_value_buf,
 					       alignmask + 1);
 
-	return 0;
+	return alignmask;
 }
 
 static void drbg_kcapi_symsetkey(struct drbg_state *drbg,
diff --git a/include/crypto/drbg.h b/include/crypto/drbg.h
index b2fe15d..61580b1 100644
--- a/include/crypto/drbg.h
+++ b/include/crypto/drbg.h
@@ -108,13 +108,16 @@ struct drbg_test_data {
 struct drbg_state {
 	struct mutex drbg_mutex;	/* lock around DRBG */
 	unsigned char *V;	/* internal state 10.1.1.1 1a) */
+	unsigned char *Vbuf;
 	/* hash: static value 10.1.1.1 1b) hmac / ctr: key */
 	unsigned char *C;
+	unsigned char *Cbuf;
 	/* Number of RNG requests since last reseed -- 10.1.1.1 1c) */
 	size_t reseed_ctr;
 	size_t reseed_threshold;
 	 /* some memory the DRBG can use for its operation */
 	unsigned char *scratchpad;
+	unsigned char *scratchpadbuf;
 	void *priv_data;	/* Cipher handle */
 
 	struct crypto_skcipher *ctr_handle;	/* CTR mode cipher handle */
-- 
2.5.5
