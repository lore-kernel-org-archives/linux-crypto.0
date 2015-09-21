From: Alex Porosanu <alexandru.porosanu@freescale.com>
Subject: [PATCH v4] crypto/caam: add backlogging support
Date: Mon, 21 Sep 2015 16:22:56 +0300
Message-ID: <1442841776-25573-1-git-send-email-alexandru.porosanu@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <Horia.Geanta@freescale.com>, <mircea.pop@freescale.com>,
	<herbert@gondor.apana.org.au>
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-by2on0118.outbound.protection.outlook.com ([207.46.100.118]:53248
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752862AbbIUNXG (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 21 Sep 2015 09:23:06 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

caam_jr_enqueue() function returns -EBUSY once there are no
more slots available in the JR, but it doesn't actually save
the current request. This breaks the functionality of users
that expect that even if there is no more space for the request,
it is at least queued for later execution. In other words, all
crypto transformations that request backlogging
(i.e. have CRYPTO_TFM_REQ_MAY_BACKLOG set), will hang. Such an
example is dm-crypt.
The current patch solves this issue by setting a threshold after
which caam_jr_enqueue() returns -EBUSY, but since the HW job ring
isn't actually full, the job is enqueued.
The API contract which states that a CRYPTO_TFM_REQ_MAY_BACKLOG
transformation must be able to enqueue at least 1 entry is
assured by allowing only a number of transformations to be
affined to one JR, equal to half the number of JR slots minus
one.

Signed-off-by: Alex Porosanu <alexandru.porosanu@freescale.com>

---
v4:
- as per Horia's observation, now the JR is split in two and no
  more than half of the JR - 1 entry transformations can be
  affined to a JR. This leads to a total # of 511 x 4 = 1020
  transformations that can be affined on the SEC device, using
  the current default configuration.
v3:
- as per Herbert's observation, allow only # of backlogging slots
  transformations w/MAY_BACKLOG flag set to be affined to a JR;
  the total # of transformations that can be thus allocated is equal
  to the # of JRs times the # of "backlogging slots". In the standard
  configuration, this means 16 x 4 = 64 transformations.

v2:
- added backlogging support for hash as well (caamhash)
- simplfied some convoluted logic in *_done_* callbacks
- simplified backlogging entries addition in jr.c
- made the # of backlogging entries depend on the JR size
- fixed wrong function call for abklcipher (backlogging instead of 'normal')
---
 drivers/crypto/caam/caamalg.c  |  97 +++++++++++++++++---
 drivers/crypto/caam/caamhash.c | 103 ++++++++++++++++++---
 drivers/crypto/caam/intern.h   |   7 ++
 drivers/crypto/caam/jr.c       | 198 +++++++++++++++++++++++++++++++++--------
 drivers/crypto/caam/jr.h       |   5 ++
 5 files changed, 346 insertions(+), 64 deletions(-)

diff --git a/drivers/crypto/caam/caamalg.c b/drivers/crypto/caam/caamalg.c
index ba79d63..c211aa8 100644
--- a/drivers/crypto/caam/caamalg.c
+++ b/drivers/crypto/caam/caamalg.c
@@ -1815,6 +1815,9 @@ static void aead_encrypt_done(struct device *jrdev, u32 *desc, u32 err,
 
 	edesc = container_of(desc, struct aead_edesc, hw_desc[0]);
 
+	if (err == -EINPROGRESS)
+		goto out_bklogged;
+
 	if (err)
 		caam_jr_strstatus(jrdev, err);
 
@@ -1822,6 +1825,7 @@ static void aead_encrypt_done(struct device *jrdev, u32 *desc, u32 err,
 
 	kfree(edesc);
 
+out_bklogged:
 	aead_request_complete(req, err);
 }
 
@@ -1837,6 +1841,9 @@ static void aead_decrypt_done(struct device *jrdev, u32 *desc, u32 err,
 
 	edesc = container_of(desc, struct aead_edesc, hw_desc[0]);
 
+	if (err == -EINPROGRESS)
+		goto out_bklogged;
+
 	if (err)
 		caam_jr_strstatus(jrdev, err);
 
@@ -1850,6 +1857,7 @@ static void aead_decrypt_done(struct device *jrdev, u32 *desc, u32 err,
 
 	kfree(edesc);
 
+out_bklogged:
 	aead_request_complete(req, err);
 }
 
@@ -1864,10 +1872,12 @@ static void ablkcipher_encrypt_done(struct device *jrdev, u32 *desc, u32 err,
 
 	dev_err(jrdev, "%s %d: err 0x%x\n", __func__, __LINE__, err);
 #endif
-
 	edesc = (struct ablkcipher_edesc *)((char *)desc -
 		 offsetof(struct ablkcipher_edesc, hw_desc));
 
+	if (err == -EINPROGRESS)
+		goto out_bklogged;
+
 	if (err)
 		caam_jr_strstatus(jrdev, err);
 
@@ -1883,6 +1893,7 @@ static void ablkcipher_encrypt_done(struct device *jrdev, u32 *desc, u32 err,
 	ablkcipher_unmap(jrdev, edesc, req);
 	kfree(edesc);
 
+out_bklogged:
 	ablkcipher_request_complete(req, err);
 }
 
@@ -1900,6 +1911,9 @@ static void ablkcipher_decrypt_done(struct device *jrdev, u32 *desc, u32 err,
 
 	edesc = (struct ablkcipher_edesc *)((char *)desc -
 		 offsetof(struct ablkcipher_edesc, hw_desc));
+	if (err == -EINPROGRESS)
+		goto out_bklogged;
+
 	if (err)
 		caam_jr_strstatus(jrdev, err);
 
@@ -1915,6 +1929,7 @@ static void ablkcipher_decrypt_done(struct device *jrdev, u32 *desc, u32 err,
 	ablkcipher_unmap(jrdev, edesc, req);
 	kfree(edesc);
 
+out_bklogged:
 	ablkcipher_request_complete(req, err);
 }
 
@@ -2294,7 +2309,15 @@ static int gcm_encrypt(struct aead_request *req)
 #endif
 
 	desc = edesc->hw_desc;
-	ret = caam_jr_enqueue(jrdev, desc, aead_encrypt_done, req);
+	if (req->base.flags & CRYPTO_TFM_REQ_MAY_BACKLOG) {
+		ret = caam_jr_enqueue_bklog(jrdev, desc, aead_encrypt_done,
+					    req);
+		if (ret == -EBUSY)
+			return ret;
+	} else {
+		ret = caam_jr_enqueue(jrdev, desc, aead_encrypt_done, req);
+	}
+
 	if (!ret) {
 		ret = -EINPROGRESS;
 	} else {
@@ -2338,7 +2361,15 @@ static int aead_encrypt(struct aead_request *req)
 #endif
 
 	desc = edesc->hw_desc;
-	ret = caam_jr_enqueue(jrdev, desc, aead_encrypt_done, req);
+	if (req->base.flags & CRYPTO_TFM_REQ_MAY_BACKLOG) {
+		ret = caam_jr_enqueue_bklog(jrdev, desc, aead_encrypt_done,
+					    req);
+		if (ret == -EBUSY)
+			return ret;
+	} else {
+		ret = caam_jr_enqueue(jrdev, desc, aead_encrypt_done, req);
+	}
+
 	if (!ret) {
 		ret = -EINPROGRESS;
 	} else {
@@ -2373,7 +2404,15 @@ static int gcm_decrypt(struct aead_request *req)
 #endif
 
 	desc = edesc->hw_desc;
-	ret = caam_jr_enqueue(jrdev, desc, aead_decrypt_done, req);
+	if (req->base.flags & CRYPTO_TFM_REQ_MAY_BACKLOG) {
+		ret = caam_jr_enqueue_bklog(jrdev, desc, aead_decrypt_done,
+					    req);
+		if (ret == -EBUSY)
+			return ret;
+	} else {
+		ret = caam_jr_enqueue(jrdev, desc, aead_decrypt_done, req);
+	}
+
 	if (!ret) {
 		ret = -EINPROGRESS;
 	} else {
@@ -2423,7 +2462,15 @@ static int aead_decrypt(struct aead_request *req)
 #endif
 
 	desc = edesc->hw_desc;
-	ret = caam_jr_enqueue(jrdev, desc, aead_decrypt_done, req);
+	if (req->base.flags & CRYPTO_TFM_REQ_MAY_BACKLOG) {
+		ret = caam_jr_enqueue_bklog(jrdev, desc, aead_decrypt_done,
+					    req);
+		if (ret == -EBUSY)
+			return ret;
+	} else {
+		ret = caam_jr_enqueue(jrdev, desc, aead_decrypt_done, req);
+	}
+
 	if (!ret) {
 		ret = -EINPROGRESS;
 	} else {
@@ -2575,7 +2622,15 @@ static int ablkcipher_encrypt(struct ablkcipher_request *req)
 		       desc_bytes(edesc->hw_desc), 1);
 #endif
 	desc = edesc->hw_desc;
-	ret = caam_jr_enqueue(jrdev, desc, ablkcipher_encrypt_done, req);
+	if (req->base.flags & CRYPTO_TFM_REQ_MAY_BACKLOG) {
+		ret = caam_jr_enqueue_bklog(jrdev, desc,
+					    ablkcipher_encrypt_done, req);
+		if (ret == -EBUSY)
+			return ret;
+	} else {
+		ret = caam_jr_enqueue(jrdev, desc, ablkcipher_encrypt_done,
+				      req);
+	}
 
 	if (!ret) {
 		ret = -EINPROGRESS;
@@ -2612,15 +2667,22 @@ static int ablkcipher_decrypt(struct ablkcipher_request *req)
 		       DUMP_PREFIX_ADDRESS, 16, 4, edesc->hw_desc,
 		       desc_bytes(edesc->hw_desc), 1);
 #endif
+	if (req->base.flags & CRYPTO_TFM_REQ_MAY_BACKLOG) {
+		ret = caam_jr_enqueue_bklog(jrdev, desc,
+					    ablkcipher_decrypt_done, req);
+		if (ret == -EBUSY)
+			return ret;
+	} else {
+		ret = caam_jr_enqueue(jrdev, desc, ablkcipher_decrypt_done,
+				      req);
+	}
 
-	ret = caam_jr_enqueue(jrdev, desc, ablkcipher_decrypt_done, req);
 	if (!ret) {
 		ret = -EINPROGRESS;
 	} else {
 		ablkcipher_unmap(jrdev, edesc, req);
 		kfree(edesc);
 	}
-
 	return ret;
 }
 
@@ -2757,7 +2819,15 @@ static int ablkcipher_givencrypt(struct skcipher_givcrypt_request *creq)
 		       desc_bytes(edesc->hw_desc), 1);
 #endif
 	desc = edesc->hw_desc;
-	ret = caam_jr_enqueue(jrdev, desc, ablkcipher_encrypt_done, req);
+	if (req->base.flags & CRYPTO_TFM_REQ_MAY_BACKLOG) {
+		ret = caam_jr_enqueue_bklog(jrdev, desc,
+					    ablkcipher_encrypt_done, req);
+		if (ret == -EBUSY)
+			return ret;
+	} else {
+		ret = caam_jr_enqueue(jrdev, desc, ablkcipher_encrypt_done,
+				      req);
+	}
 
 	if (!ret) {
 		ret = -EINPROGRESS;
@@ -4215,7 +4285,8 @@ struct caam_crypto_alg {
 	struct caam_alg_entry caam;
 };
 
-static int caam_init_common(struct caam_ctx *ctx, struct caam_alg_entry *caam)
+static int caam_init_common(struct caam_ctx *ctx, struct caam_alg_entry *caam,
+			    bool bklog)
 {
 	ctx->jrdev = caam_jr_alloc();
 	if (IS_ERR(ctx->jrdev)) {
@@ -4238,7 +4309,8 @@ static int caam_cra_init(struct crypto_tfm *tfm)
 		 container_of(alg, struct caam_crypto_alg, crypto_alg);
 	struct caam_ctx *ctx = crypto_tfm_ctx(tfm);
 
-	return caam_init_common(ctx, &caam_alg->caam);
+	return caam_init_common(ctx, &caam_alg->caam,
+				tfm->crt_flags & CRYPTO_TFM_REQ_MAY_BACKLOG);
 }
 
 static int caam_aead_init(struct crypto_aead *tfm)
@@ -4248,7 +4320,8 @@ static int caam_aead_init(struct crypto_aead *tfm)
 		 container_of(alg, struct caam_aead_alg, aead);
 	struct caam_ctx *ctx = crypto_aead_ctx(tfm);
 
-	return caam_init_common(ctx, &caam_alg->caam);
+	return caam_init_common(ctx, &caam_alg->caam,
+			tfm->base.crt_flags & CRYPTO_TFM_REQ_MAY_BACKLOG);
 }
 
 static void caam_exit_common(struct caam_ctx *ctx)
diff --git a/drivers/crypto/caam/caamhash.c b/drivers/crypto/caam/caamhash.c
index 94433b9..cc6b8c7 100644
--- a/drivers/crypto/caam/caamhash.c
+++ b/drivers/crypto/caam/caamhash.c
@@ -645,6 +645,10 @@ static void ahash_done(struct device *jrdev, u32 *desc, u32 err,
 
 	edesc = (struct ahash_edesc *)((char *)desc -
 		 offsetof(struct ahash_edesc, hw_desc));
+
+	if (err == -EINPROGRESS)
+		goto out_bklogged;
+
 	if (err)
 		caam_jr_strstatus(jrdev, err);
 
@@ -661,6 +665,7 @@ static void ahash_done(struct device *jrdev, u32 *desc, u32 err,
 			       digestsize, 1);
 #endif
 
+out_bklogged:
 	req->base.complete(&req->base, err);
 }
 
@@ -680,6 +685,9 @@ static void ahash_done_bi(struct device *jrdev, u32 *desc, u32 err,
 
 	edesc = (struct ahash_edesc *)((char *)desc -
 		 offsetof(struct ahash_edesc, hw_desc));
+	if (err == -EINPROGRESS)
+		goto out_bklogged;
+
 	if (err)
 		caam_jr_strstatus(jrdev, err);
 
@@ -695,7 +703,7 @@ static void ahash_done_bi(struct device *jrdev, u32 *desc, u32 err,
 			       DUMP_PREFIX_ADDRESS, 16, 4, req->result,
 			       digestsize, 1);
 #endif
-
+out_bklogged:
 	req->base.complete(&req->base, err);
 }
 
@@ -715,6 +723,9 @@ static void ahash_done_ctx_src(struct device *jrdev, u32 *desc, u32 err,
 
 	edesc = (struct ahash_edesc *)((char *)desc -
 		 offsetof(struct ahash_edesc, hw_desc));
+	if (err == -EINPROGRESS)
+		goto out_bklogged;
+
 	if (err)
 		caam_jr_strstatus(jrdev, err);
 
@@ -730,7 +741,7 @@ static void ahash_done_ctx_src(struct device *jrdev, u32 *desc, u32 err,
 			       DUMP_PREFIX_ADDRESS, 16, 4, req->result,
 			       digestsize, 1);
 #endif
-
+out_bklogged:
 	req->base.complete(&req->base, err);
 }
 
@@ -750,6 +761,9 @@ static void ahash_done_ctx_dst(struct device *jrdev, u32 *desc, u32 err,
 
 	edesc = (struct ahash_edesc *)((char *)desc -
 		 offsetof(struct ahash_edesc, hw_desc));
+	if (err == -EINPROGRESS)
+		goto out_bklogged;
+
 	if (err)
 		caam_jr_strstatus(jrdev, err);
 
@@ -765,7 +779,7 @@ static void ahash_done_ctx_dst(struct device *jrdev, u32 *desc, u32 err,
 			       DUMP_PREFIX_ADDRESS, 16, 4, req->result,
 			       digestsize, 1);
 #endif
-
+out_bklogged:
 	req->base.complete(&req->base, err);
 }
 
@@ -870,7 +884,15 @@ static int ahash_update_ctx(struct ahash_request *req)
 			       desc_bytes(desc), 1);
 #endif
 
-		ret = caam_jr_enqueue(jrdev, desc, ahash_done_bi, req);
+		if (req->base.flags & CRYPTO_TFM_REQ_MAY_BACKLOG) {
+			ret = caam_jr_enqueue_bklog(jrdev, desc, ahash_done_bi,
+						    req);
+			if (ret == -EBUSY)
+				return ret;
+		} else {
+			ret = caam_jr_enqueue(jrdev, desc, ahash_done_bi, req);
+		}
+
 		if (!ret) {
 			ret = -EINPROGRESS;
 		} else {
@@ -967,7 +989,15 @@ static int ahash_final_ctx(struct ahash_request *req)
 		       DUMP_PREFIX_ADDRESS, 16, 4, desc, desc_bytes(desc), 1);
 #endif
 
-	ret = caam_jr_enqueue(jrdev, desc, ahash_done_ctx_src, req);
+	if (req->base.flags & CRYPTO_TFM_REQ_MAY_BACKLOG) {
+		ret = caam_jr_enqueue_bklog(jrdev, desc, ahash_done_ctx_src,
+					    req);
+		if (ret == -EBUSY)
+			return ret;
+	} else {
+		ret = caam_jr_enqueue(jrdev, desc, ahash_done_ctx_src, req);
+	}
+
 	if (!ret) {
 		ret = -EINPROGRESS;
 	} else {
@@ -1057,7 +1087,15 @@ static int ahash_finup_ctx(struct ahash_request *req)
 		       DUMP_PREFIX_ADDRESS, 16, 4, desc, desc_bytes(desc), 1);
 #endif
 
-	ret = caam_jr_enqueue(jrdev, desc, ahash_done_ctx_src, req);
+	if (req->base.flags & CRYPTO_TFM_REQ_MAY_BACKLOG) {
+		ret = caam_jr_enqueue_bklog(jrdev, desc, ahash_done_ctx_src,
+					    req);
+		if (ret == -EBUSY)
+			return ret;
+	} else {
+		ret = caam_jr_enqueue(jrdev, desc, ahash_done_ctx_src, req);
+	}
+
 	if (!ret) {
 		ret = -EINPROGRESS;
 	} else {
@@ -1136,7 +1174,14 @@ static int ahash_digest(struct ahash_request *req)
 		       DUMP_PREFIX_ADDRESS, 16, 4, desc, desc_bytes(desc), 1);
 #endif
 
-	ret = caam_jr_enqueue(jrdev, desc, ahash_done, req);
+	if (req->base.flags & CRYPTO_TFM_REQ_MAY_BACKLOG) {
+		ret = caam_jr_enqueue_bklog(jrdev, desc, ahash_done, req);
+		if (ret == -EBUSY)
+			return ret;
+	} else {
+		ret = caam_jr_enqueue(jrdev, desc, ahash_done, req);
+	}
+
 	if (!ret) {
 		ret = -EINPROGRESS;
 	} else {
@@ -1198,7 +1243,14 @@ static int ahash_final_no_ctx(struct ahash_request *req)
 		       DUMP_PREFIX_ADDRESS, 16, 4, desc, desc_bytes(desc), 1);
 #endif
 
-	ret = caam_jr_enqueue(jrdev, desc, ahash_done, req);
+	if (req->base.flags & CRYPTO_TFM_REQ_MAY_BACKLOG) {
+		ret = caam_jr_enqueue_bklog(jrdev, desc, ahash_done, req);
+		if (ret == -EBUSY)
+			return ret;
+	} else {
+		ret = caam_jr_enqueue(jrdev, desc, ahash_done, req);
+	}
+
 	if (!ret) {
 		ret = -EINPROGRESS;
 	} else {
@@ -1297,7 +1349,16 @@ static int ahash_update_no_ctx(struct ahash_request *req)
 			       desc_bytes(desc), 1);
 #endif
 
-		ret = caam_jr_enqueue(jrdev, desc, ahash_done_ctx_dst, req);
+		if (req->base.flags & CRYPTO_TFM_REQ_MAY_BACKLOG) {
+			ret = caam_jr_enqueue_bklog(jrdev, desc,
+						    ahash_done_ctx_dst, req);
+			if (ret == -EBUSY)
+				return ret;
+		} else {
+			ret = caam_jr_enqueue(jrdev, desc, ahash_done_ctx_dst,
+					      req);
+		}
+
 		if (!ret) {
 			ret = -EINPROGRESS;
 			state->update = ahash_update_ctx;
@@ -1399,7 +1460,15 @@ static int ahash_finup_no_ctx(struct ahash_request *req)
 		       DUMP_PREFIX_ADDRESS, 16, 4, desc, desc_bytes(desc), 1);
 #endif
 
-	ret = caam_jr_enqueue(jrdev, desc, ahash_done, req);
+	if (req->base.flags & CRYPTO_TFM_REQ_MAY_BACKLOG) {
+		ret = caam_jr_enqueue_bklog(jrdev, desc, ahash_done,
+					    req);
+		if (ret == -EBUSY)
+			return ret;
+	} else {
+		ret = caam_jr_enqueue(jrdev, desc, ahash_done, req);
+	}
+
 	if (!ret) {
 		ret = -EINPROGRESS;
 	} else {
@@ -1502,8 +1571,16 @@ static int ahash_update_first(struct ahash_request *req)
 			       desc_bytes(desc), 1);
 #endif
 
-		ret = caam_jr_enqueue(jrdev, desc, ahash_done_ctx_dst,
-				      req);
+		if (req->base.flags & CRYPTO_TFM_REQ_MAY_BACKLOG) {
+			ret = caam_jr_enqueue_bklog(jrdev, desc,
+						    ahash_done_ctx_dst, req);
+			if (ret == -EBUSY)
+				return ret;
+		} else {
+			ret = caam_jr_enqueue(jrdev, desc, ahash_done_ctx_dst,
+					      req);
+		}
+
 		if (!ret) {
 			ret = -EINPROGRESS;
 			state->update = ahash_update_ctx;
@@ -1770,6 +1847,7 @@ static int caam_hash_cra_init(struct crypto_tfm *tfm)
 	 * crypto request processing per tfm
 	 */
 	ctx->jrdev = caam_jr_alloc();
+
 	if (IS_ERR(ctx->jrdev)) {
 		pr_err("Job Ring Device allocation for transform failed\n");
 		return PTR_ERR(ctx->jrdev);
@@ -1816,7 +1894,6 @@ static void caam_hash_cra_exit(struct crypto_tfm *tfm)
 	    !dma_mapping_error(ctx->jrdev, ctx->sh_desc_finup_dma))
 		dma_unmap_single(ctx->jrdev, ctx->sh_desc_finup_dma,
 				 desc_bytes(ctx->sh_desc_finup), DMA_TO_DEVICE);
-
 	caam_jr_free(ctx->jrdev);
 }
 
diff --git a/drivers/crypto/caam/intern.h b/drivers/crypto/caam/intern.h
index e2bcacc..aa4e257 100644
--- a/drivers/crypto/caam/intern.h
+++ b/drivers/crypto/caam/intern.h
@@ -11,6 +11,12 @@
 
 /* Currently comes from Kconfig param as a ^2 (driver-required) */
 #define JOBR_DEPTH (1 << CONFIG_CRYPTO_DEV_FSL_CAAM_RINGSIZE)
+/*
+ * If the user tries to enqueue a job and the number of slots available
+ * is less than this value, then the job will be backlogged (if the user
+ * allows for it) or it will be dropped.
+ */
+#define JOBR_THRESH (JOBR_DEPTH / 2 - 1)
 
 /* Kconfig params for interrupt coalescing if selected (else zero) */
 #ifdef CONFIG_CRYPTO_DEV_FSL_CAAM_INTC
@@ -33,6 +39,7 @@ struct caam_jrentry_info {
 	u32 *desc_addr_virt;	/* Stored virt addr for postprocessing */
 	dma_addr_t desc_addr_dma;	/* Stored bus addr for done matching */
 	u32 desc_size;	/* Stored size for postprocessing, header derived */
+	bool is_backlogged; /* True if the request has been backlogged */
 };
 
 /* Private sub-storage for a single JobR */
diff --git a/drivers/crypto/caam/jr.c b/drivers/crypto/caam/jr.c
index f7e0d8d..9c5d1fd 100644
--- a/drivers/crypto/caam/jr.c
+++ b/drivers/crypto/caam/jr.c
@@ -168,6 +168,7 @@ static void caam_jr_dequeue(unsigned long devarg)
 	void (*usercall)(struct device *dev, u32 *desc, u32 status, void *arg);
 	u32 *userdesc, userstatus;
 	void *userarg;
+	bool is_backlogged;
 
 	while (rd_reg32(&jrp->rregs->outring_used)) {
 
@@ -201,6 +202,7 @@ static void caam_jr_dequeue(unsigned long devarg)
 		userarg = jrp->entinfo[sw_idx].cbkarg;
 		userdesc = jrp->entinfo[sw_idx].desc_addr_virt;
 		userstatus = jrp->outring[hw_idx].jrstatus;
+		is_backlogged = jrp->entinfo[sw_idx].is_backlogged;
 
 		/*
 		 * Make sure all information from the job has been obtained
@@ -231,6 +233,20 @@ static void caam_jr_dequeue(unsigned long devarg)
 
 		spin_unlock(&jrp->outlock);
 
+		if (is_backlogged)
+			/*
+			 * For backlogged requests, the user callback needs to
+			 * be called twice: once when starting to process it
+			 * (with a status of -EINPROGRESS and once when it's
+			 * done. Since SEC cheats by enqueuing the request in
+			 * its HW ring but returning -EBUSY, the time when the
+			 * request's processing has started is not known.
+			 * Thus notify here the user. The second call is on the
+			 * normal path (i.e. the one that is called even for
+			 * non-backlogged requests).
+			 */
+			usercall(dev, userdesc, -EINPROGRESS, userarg);
+
 		/* Finally, execute user's callback */
 		usercall(dev, userdesc, userstatus, userarg);
 	}
@@ -261,6 +277,15 @@ struct device *caam_jr_alloc(void)
 
 	list_for_each_entry(jrpriv, &driver_data.jr_list, list_node) {
 		tfm_cnt = atomic_read(&jrpriv->tfm_count);
+
+		/*
+		 * Don't allow more than JOBR_THRES jobs on this JR. If more
+		 * are allowed, then backlogging API contract won't work (each
+		 * "backloggable" tfm must allow for at least 1 enqueue.
+		 */
+		if (tfm_cnt == JOBR_THRESH)
+			continue;
+
 		if (tfm_cnt < min_tfm_cnt) {
 			min_tfm_cnt = tfm_cnt;
 			min_jrpriv = jrpriv;
@@ -292,6 +317,83 @@ void caam_jr_free(struct device *rdev)
 }
 EXPORT_SYMBOL(caam_jr_free);
 
+static inline int __caam_jr_enqueue(struct caam_drv_private_jr *jrp, u32 *desc,
+				    int desc_size, dma_addr_t desc_dma,
+				    void (*cbk)(struct device *dev, u32 *desc,
+						u32 status, void *areq),
+				    void *areq,
+				    bool can_be_backlogged)
+{
+	int head, tail;
+	struct caam_jrentry_info *head_entry;
+	int ret = 0, hw_slots, sw_slots;
+
+	spin_lock_bh(&jrp->inplock);
+
+	head = jrp->head;
+	tail = ACCESS_ONCE(jrp->tail);
+
+	head_entry = &jrp->entinfo[head];
+
+	/* Reset backlogging status here */
+	head_entry->is_backlogged = false;
+
+	hw_slots = rd_reg32(&jrp->rregs->inpring_avail);
+	sw_slots = CIRC_SPACE(head, tail, JOBR_DEPTH);
+
+	if (hw_slots <= JOBR_THRESH || sw_slots <= JOBR_THRESH) {
+		/*
+		 * The state below can be reached in three cases:
+		 * 1) A badly behaved backlogging user doesn't back off when
+		 *    told so by the -EBUSY return code
+		 * 2) More than JOBR_THRESH backlogging users requests
+		 * 3) Due to the high system load, the entries reserved for the
+		 *    backlogging users are being filled (slowly) in between
+		 *    the successive calls to the user callback (the first one
+		 *    with -EINPROGRESS and the 2nd one with the real result.
+		 * The code below is a last-resort measure which will DROP
+		 * any request if there is physically no more space. This will
+		 * lead to data-loss for disk-related users.
+		 */
+		if (!hw_slots || !sw_slots) {
+			ret = -EIO;
+			goto out_unlock;
+		}
+
+		ret = -EBUSY;
+		if (!can_be_backlogged)
+			goto out_unlock;
+
+		head_entry->is_backlogged = true;
+	}
+
+	head_entry->desc_addr_virt = desc;
+	head_entry->desc_size = desc_size;
+	head_entry->callbk = (void *)cbk;
+	head_entry->cbkarg = areq;
+	head_entry->desc_addr_dma = desc_dma;
+
+	jrp->inpring[jrp->inp_ring_write_index] = desc_dma;
+
+	/*
+	 * Guarantee that the descriptor's DMA address has been written to
+	 * the next slot in the ring before the write index is updated, since
+	 * other cores may update this index independently.
+	 */
+	smp_wmb();
+
+	jrp->inp_ring_write_index = (jrp->inp_ring_write_index + 1) &
+				    (JOBR_DEPTH - 1);
+	jrp->head = (head + 1) & (JOBR_DEPTH - 1);
+
+	wr_reg32(&jrp->rregs->inpring_jobadd, 1);
+
+out_unlock:
+	spin_unlock_bh(&jrp->inplock);
+
+	return ret;
+}
+
 /**
  * caam_jr_enqueue() - Enqueue a job descriptor head. Returns 0 if OK,
  * -EBUSY if the queue is full, -EIO if it cannot map the caller's
@@ -326,8 +428,7 @@ int caam_jr_enqueue(struct device *dev, u32 *desc,
 		    void *areq)
 {
 	struct caam_drv_private_jr *jrp = dev_get_drvdata(dev);
-	struct caam_jrentry_info *head_entry;
-	int head, tail, desc_size;
+	int desc_size, ret;
 	dma_addr_t desc_dma;
 
 	desc_size = (*desc & HDR_JD_LENGTH_MASK) * sizeof(u32);
@@ -337,51 +438,70 @@ int caam_jr_enqueue(struct device *dev, u32 *desc,
 		return -EIO;
 	}
 
-	spin_lock_bh(&jrp->inplock);
-
-	head = jrp->head;
-	tail = ACCESS_ONCE(jrp->tail);
-
-	if (!rd_reg32(&jrp->rregs->inpring_avail) ||
-	    CIRC_SPACE(head, tail, JOBR_DEPTH) <= 0) {
-		spin_unlock_bh(&jrp->inplock);
+	ret = __caam_jr_enqueue(jrp, desc, desc_size, desc_dma, cbk, areq,
+				false);
+	if (unlikely(ret))
 		dma_unmap_single(dev, desc_dma, desc_size, DMA_TO_DEVICE);
-		return -EBUSY;
-	}
 
-	head_entry = &jrp->entinfo[head];
-	head_entry->desc_addr_virt = desc;
-	head_entry->desc_size = desc_size;
-	head_entry->callbk = (void *)cbk;
-	head_entry->cbkarg = areq;
-	head_entry->desc_addr_dma = desc_dma;
-
-	jrp->inpring[jrp->inp_ring_write_index] = desc_dma;
-
-	/*
-	 * Guarantee that the descriptor's DMA address has been written to
-	 * the next slot in the ring before the write index is updated, since
-	 * other cores may update this index independently.
-	 */
-	smp_wmb();
+	return ret;
+}
+EXPORT_SYMBOL(caam_jr_enqueue);
 
-	jrp->inp_ring_write_index = (jrp->inp_ring_write_index + 1) &
-				    (JOBR_DEPTH - 1);
-	jrp->head = (head + 1) & (JOBR_DEPTH - 1);
+/**
+ * caam_jr_enqueue_bklog() - Enqueue a job descriptor head, returns 0 if OK, or
+ * -EBUSY if the number of available entries in the Job Ring is less
+ * than the threshold configured through JOBR_THRESH, and -EIO if it cannot map
+ * the caller's descriptor or if there is really no more space in the hardware
+ * job ring.
+ * @dev:  device of the job ring to be used. This device should have
+ *        been assigned prior by caam_jr_register().
+ * @desc: points to a job descriptor that execute our request. All
+ *        descriptors (and all referenced data) must be in a DMAable
+ *        region, and all data references must be physical addresses
+ *        accessible to CAAM (i.e. within a PAMU window granted
+ *        to it).
+ * @cbk:  pointer to a callback function to be invoked upon completion
+ *        of this request. This has the form:
+ *        callback(struct device *dev, u32 *desc, u32 stat, void *arg)
+ *        where:
+ *        @dev:    contains the job ring device that processed this
+ *                 response.
+ *        @desc:   descriptor that initiated the request, same as
+ *                 "desc" being argued to caam_jr_enqueue().
+ *        @status: untranslated status received from CAAM. See the
+ *                 reference manual for a detailed description of
+ *                 error meaning, or see the JRSTA definitions in the
+ *                 register header file
+ *        @areq:   optional pointer to an argument passed with the
+ *                 original request
+ * @areq: optional pointer to a user argument for use at callback
+ *        time.
+ **/
+int caam_jr_enqueue_bklog(struct device *dev, u32 *desc,
+			  void (*cbk)(struct device *dev, u32 *desc,
+				      u32 status, void *areq),
+			  void *areq)
+{
+	struct caam_drv_private_jr *jrp = dev_get_drvdata(dev);
+	int desc_size, ret;
+	dma_addr_t desc_dma;
 
-	/*
-	 * Ensure that all job information has been written before
-	 * notifying CAAM that a new job was added to the input ring.
-	 */
-	wmb();
+	desc_size = (*desc & HDR_JD_LENGTH_MASK) * sizeof(u32);
+	desc_dma = dma_map_single(dev, desc, desc_size, DMA_TO_DEVICE);
+	if (dma_mapping_error(dev, desc_dma)) {
+		dev_err(dev, "caam_jr_enqueue(): can't map jobdesc\n");
+		return -EIO;
+	}
 
-	wr_reg32(&jrp->rregs->inpring_jobadd, 1);
+	ret = __caam_jr_enqueue(jrp, desc, desc_size, desc_dma, cbk, areq,
+				true);
+	if (unlikely(ret && (ret != -EBUSY)))
+		dma_unmap_single(dev, desc_dma, desc_size, DMA_TO_DEVICE);
 
-	spin_unlock_bh(&jrp->inplock);
+	return ret;
 
-	return 0;
 }
-EXPORT_SYMBOL(caam_jr_enqueue);
+EXPORT_SYMBOL(caam_jr_enqueue_bklog);
 
 /*
  * Init JobR independent of platform property detection
diff --git a/drivers/crypto/caam/jr.h b/drivers/crypto/caam/jr.h
index 97113a6..21558df 100644
--- a/drivers/crypto/caam/jr.h
+++ b/drivers/crypto/caam/jr.h
@@ -15,4 +15,9 @@ int caam_jr_enqueue(struct device *dev, u32 *desc,
 				void *areq),
 		    void *areq);
 
+int caam_jr_enqueue_bklog(struct device *dev, u32 *desc,
+			  void (*cbk)(struct device *dev, u32 *desc, u32 status,
+				      void *areq),
+			  void *areq);
+
 #endif /* JR_H */
-- 
1.9.3
