From: Catalin Vasile <cata.vasile@nxp.com>
Subject: [PATCH] crypto: caam: add backlogging support
Date: Fri, 6 May 2016 16:18:52 +0300
Message-ID: <1462540733-2170-1-git-send-email-cata.vasile@nxp.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-crypto-owner@vger.kernel.org>, <horia.geanta@nxp.com>,
	<alexandru.porosanu@nxp.com>, <scott.wood@nxp.com>,
	Catalin Vasile <cata.vasile@nxp.com>
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bn1on0088.outbound.protection.outlook.com ([157.56.110.88]:55552
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757596AbcEFNTD (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 6 May 2016 09:19:03 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

caam_jr_enqueue() function returns -EBUSY once there are no more slots
available in the JR, but it doesn't actually save the current request.
This breaks the functionality of users that expect that even if there is
no more space for the request, it is at least queued for later
execution. In other words, all crypto transformations that request
backlogging (i.e. have CRYPTO_TFM_REQ_MAY_BACKLOG set), will hang. Such
an example is dm-crypt. The current patch solves this issue by setting a
threshold after which caam_jr_enqueue() returns -EBUSY, but since the HW
job ring isn't actually full, the job is enqueued.

Signed-off-by: Alexandru Porosanu <alexandru.porosanu@nxp.com>
Tested-by: Catalin Vasile <cata.vasile@nxp.com>
---
 drivers/crypto/caam/caamalg.c  |  88 ++++++++++++++++--
 drivers/crypto/caam/caamhash.c | 101 +++++++++++++++++++--
 drivers/crypto/caam/intern.h   |   7 ++
 drivers/crypto/caam/jr.c       | 196 +++++++++++++++++++++++++++++++++--------
 drivers/crypto/caam/jr.h       |   5 ++
 5 files changed, 343 insertions(+), 54 deletions(-)

diff --git a/drivers/crypto/caam/caamalg.c b/drivers/crypto/caam/caamalg.c
index ea8189f..62bce17 100644
--- a/drivers/crypto/caam/caamalg.c
+++ b/drivers/crypto/caam/caamalg.c
@@ -1921,6 +1921,9 @@ static void aead_encrypt_done(struct device *jrdev, u32 *desc, u32 err,
 
 	edesc = container_of(desc, struct aead_edesc, hw_desc[0]);
 
+	if (err == -EINPROGRESS)
+		goto out_bklogged;
+
 	if (err)
 		caam_jr_strstatus(jrdev, err);
 
@@ -1928,6 +1931,7 @@ static void aead_encrypt_done(struct device *jrdev, u32 *desc, u32 err,
 
 	kfree(edesc);
 
+out_bklogged:
 	aead_request_complete(req, err);
 }
 
@@ -1943,6 +1947,9 @@ static void aead_decrypt_done(struct device *jrdev, u32 *desc, u32 err,
 
 	edesc = container_of(desc, struct aead_edesc, hw_desc[0]);
 
+	if (err == -EINPROGRESS)
+		goto out_bklogged;
+
 	if (err)
 		caam_jr_strstatus(jrdev, err);
 
@@ -1956,6 +1963,7 @@ static void aead_decrypt_done(struct device *jrdev, u32 *desc, u32 err,
 
 	kfree(edesc);
 
+out_bklogged:
 	aead_request_complete(req, err);
 }
 
@@ -1974,6 +1982,9 @@ static void ablkcipher_encrypt_done(struct device *jrdev, u32 *desc, u32 err,
 	edesc = (struct ablkcipher_edesc *)((char *)desc -
 		 offsetof(struct ablkcipher_edesc, hw_desc));
 
+	if (err == -EINPROGRESS)
+		goto out_bklogged;
+
 	if (err)
 		caam_jr_strstatus(jrdev, err);
 
@@ -1989,6 +2000,7 @@ static void ablkcipher_encrypt_done(struct device *jrdev, u32 *desc, u32 err,
 	ablkcipher_unmap(jrdev, edesc, req);
 	kfree(edesc);
 
+out_bklogged:
 	ablkcipher_request_complete(req, err);
 }
 
@@ -2006,6 +2018,10 @@ static void ablkcipher_decrypt_done(struct device *jrdev, u32 *desc, u32 err,
 
 	edesc = (struct ablkcipher_edesc *)((char *)desc -
 		 offsetof(struct ablkcipher_edesc, hw_desc));
+
+	if (err == -EINPROGRESS)
+		goto out_bklogged;
+
 	if (err)
 		caam_jr_strstatus(jrdev, err);
 
@@ -2021,6 +2037,7 @@ static void ablkcipher_decrypt_done(struct device *jrdev, u32 *desc, u32 err,
 	ablkcipher_unmap(jrdev, edesc, req);
 	kfree(edesc);
 
+out_bklogged:
 	ablkcipher_request_complete(req, err);
 }
 
@@ -2394,7 +2411,15 @@ static int gcm_encrypt(struct aead_request *req)
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
@@ -2438,7 +2463,15 @@ static int aead_encrypt(struct aead_request *req)
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
@@ -2473,7 +2506,15 @@ static int gcm_decrypt(struct aead_request *req)
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
@@ -2523,7 +2564,15 @@ static int aead_decrypt(struct aead_request *req)
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
@@ -2672,7 +2721,15 @@ static int ablkcipher_encrypt(struct ablkcipher_request *req)
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
@@ -2710,7 +2767,16 @@ static int ablkcipher_decrypt(struct ablkcipher_request *req)
 		       desc_bytes(edesc->hw_desc), 1);
 #endif
 
-	ret = caam_jr_enqueue(jrdev, desc, ablkcipher_decrypt_done, req);
+	if (req->base.flags & CRYPTO_TFM_REQ_MAY_BACKLOG) {
+		ret = caam_jr_enqueue_bklog(jrdev, desc,
+					    ablkcipher_decrypt_done, req);
+		if (ret == -EBUSY)
+			return ret;
+	} else {
+		ret = caam_jr_enqueue(jrdev, desc, ablkcipher_decrypt_done,
+				      req);
+	}
+
 	if (!ret) {
 		ret = -EINPROGRESS;
 	} else {
@@ -2851,7 +2917,15 @@ static int ablkcipher_givencrypt(struct skcipher_givcrypt_request *creq)
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
diff --git a/drivers/crypto/caam/caamhash.c b/drivers/crypto/caam/caamhash.c
index 5845d4a..910a350 100644
--- a/drivers/crypto/caam/caamhash.c
+++ b/drivers/crypto/caam/caamhash.c
@@ -650,6 +650,10 @@ static void ahash_done(struct device *jrdev, u32 *desc, u32 err,
 
 	edesc = (struct ahash_edesc *)((char *)desc -
 		 offsetof(struct ahash_edesc, hw_desc));
+
+	if (err == -EINPROGRESS)
+		goto out_bklogged;
+
 	if (err)
 		caam_jr_strstatus(jrdev, err);
 
@@ -666,6 +670,7 @@ static void ahash_done(struct device *jrdev, u32 *desc, u32 err,
 			       digestsize, 1);
 #endif
 
+out_bklogged:
 	req->base.complete(&req->base, err);
 }
 
@@ -685,6 +690,10 @@ static void ahash_done_bi(struct device *jrdev, u32 *desc, u32 err,
 
 	edesc = (struct ahash_edesc *)((char *)desc -
 		 offsetof(struct ahash_edesc, hw_desc));
+
+	if (err == -EINPROGRESS)
+		goto out_bklogged;
+
 	if (err)
 		caam_jr_strstatus(jrdev, err);
 
@@ -701,6 +710,7 @@ static void ahash_done_bi(struct device *jrdev, u32 *desc, u32 err,
 			       digestsize, 1);
 #endif
 
+out_bklogged:
 	req->base.complete(&req->base, err);
 }
 
@@ -720,6 +730,10 @@ static void ahash_done_ctx_src(struct device *jrdev, u32 *desc, u32 err,
 
 	edesc = (struct ahash_edesc *)((char *)desc -
 		 offsetof(struct ahash_edesc, hw_desc));
+
+	if (err == -EINPROGRESS)
+		goto out_bklogged;
+
 	if (err)
 		caam_jr_strstatus(jrdev, err);
 
@@ -736,6 +750,7 @@ static void ahash_done_ctx_src(struct device *jrdev, u32 *desc, u32 err,
 			       digestsize, 1);
 #endif
 
+out_bklogged:
 	req->base.complete(&req->base, err);
 }
 
@@ -755,6 +770,10 @@ static void ahash_done_ctx_dst(struct device *jrdev, u32 *desc, u32 err,
 
 	edesc = (struct ahash_edesc *)((char *)desc -
 		 offsetof(struct ahash_edesc, hw_desc));
+
+	if (err == -EINPROGRESS)
+		goto out_bklogged;
+
 	if (err)
 		caam_jr_strstatus(jrdev, err);
 
@@ -771,6 +790,7 @@ static void ahash_done_ctx_dst(struct device *jrdev, u32 *desc, u32 err,
 			       digestsize, 1);
 #endif
 
+out_bklogged:
 	req->base.complete(&req->base, err);
 }
 
@@ -876,7 +896,15 @@ static int ahash_update_ctx(struct ahash_request *req)
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
@@ -973,7 +1001,15 @@ static int ahash_final_ctx(struct ahash_request *req)
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
@@ -1065,7 +1101,15 @@ static int ahash_finup_ctx(struct ahash_request *req)
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
@@ -1145,7 +1189,14 @@ static int ahash_digest(struct ahash_request *req)
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
@@ -1207,7 +1258,14 @@ static int ahash_final_no_ctx(struct ahash_request *req)
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
@@ -1308,7 +1366,16 @@ static int ahash_update_no_ctx(struct ahash_request *req)
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
@@ -1411,7 +1478,15 @@ static int ahash_finup_no_ctx(struct ahash_request *req)
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
@@ -1514,8 +1589,16 @@ static int ahash_update_first(struct ahash_request *req)
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
index 5ef4be2..49790e1 100644
--- a/drivers/crypto/caam/jr.c
+++ b/drivers/crypto/caam/jr.c
@@ -168,6 +168,7 @@ static void caam_jr_dequeue(unsigned long devarg)
 	void (*usercall)(struct device *dev, u32 *desc, u32 status, void *arg);
 	u32 *userdesc, userstatus;
 	void *userarg;
+	bool is_backlogged;
 
 	while (rd_reg32(&jrp->rregs->outring_used)) {
 
@@ -201,6 +202,9 @@ static void caam_jr_dequeue(unsigned long devarg)
 		userarg = jrp->entinfo[sw_idx].cbkarg;
 		userdesc = jrp->entinfo[sw_idx].desc_addr_virt;
 		userstatus = jrp->outring[hw_idx].jrstatus;
+		is_backlogged = jrp->entinfo[sw_idx].is_backlogged;
+		/* Reset backlogging status here */
+		jrp->entinfo[sw_idx].is_backlogged = false;
 
 		/*
 		 * Make sure all information from the job has been obtained
@@ -231,6 +235,20 @@ static void caam_jr_dequeue(unsigned long devarg)
 
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
@@ -261,6 +279,15 @@ struct device *caam_jr_alloc(void)
 
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
@@ -292,6 +319,80 @@ void caam_jr_free(struct device *rdev)
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
@@ -326,8 +427,7 @@ int caam_jr_enqueue(struct device *dev, u32 *desc,
 		    void *areq)
 {
 	struct caam_drv_private_jr *jrp = dev_get_drvdata(dev);
-	struct caam_jrentry_info *head_entry;
-	int head, tail, desc_size;
+	int desc_size, ret;
 	dma_addr_t desc_dma;
 
 	desc_size = (*desc & HDR_JD_LENGTH_MASK) * sizeof(u32);
@@ -337,51 +437,71 @@ int caam_jr_enqueue(struct device *dev, u32 *desc,
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
+	return 0;
+}
+EXPORT_SYMBOL(caam_jr_enqueue);
 
-	/*
-	 * Guarantee that the descriptor's DMA address has been written to
-	 * the next slot in the ring before the write index is updated, since
-	 * other cores may update this index independently.
-	 */
-	smp_wmb();
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
 
-	jrp->inp_ring_write_index = (jrp->inp_ring_write_index + 1) &
-				    (JOBR_DEPTH - 1);
-	jrp->head = (head + 1) & (JOBR_DEPTH - 1);
 
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
1.8.3.1
