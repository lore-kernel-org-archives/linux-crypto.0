From: LABBE Corentin <clabbe.montjoie@gmail.com>
Subject: [PATCH 2/6] crypto: sun4i-ss: unify update/final function
Date: Wed, 10 Aug 2016 11:45:30 +0200
Message-ID: <1470822334-20672-2-git-send-email-clabbe.montjoie@gmail.com>
References: <1470822334-20672-1-git-send-email-clabbe.montjoie@gmail.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	LABBE Corentin <clabbe.montjoie@gmail.com>
To: herbert@gondor.apana.org.au, davem@davemloft.net,
	maxime.ripard@free-electrons.com, wens@csie.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1470822334-20672-1-git-send-email-clabbe.montjoie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

The update and final functions have lots of common action.
This patch mix them in one function.
This will give some improvements:
- This will permit asynchronous support more easily
- This will permit to use finup/digest functions with some performance
  improvements

Signed-off-by: LABBE Corentin <clabbe.montjoie@gmail.com>
---
 drivers/crypto/sunxi-ss/sun4i-ss-hash.c | 147 ++++++++++++++++++--------------
 drivers/crypto/sunxi-ss/sun4i-ss.h      |   1 +
 2 files changed, 85 insertions(+), 63 deletions(-)

diff --git a/drivers/crypto/sunxi-ss/sun4i-ss-hash.c b/drivers/crypto/sunxi-ss/sun4i-ss-hash.c
index ff80314..2fb0684 100644
--- a/drivers/crypto/sunxi-ss/sun4i-ss-hash.c
+++ b/drivers/crypto/sunxi-ss/sun4i-ss-hash.c
@@ -129,6 +129,9 @@ int sun4i_hash_import_sha1(struct ahash_request *areq, const void *in)
 	return 0;
 }
 
+#define SS_HASH_UPDATE 1
+#define SS_HASH_FINAL 2
+
 /*
  * sun4i_hash_update: update hash engine
  *
@@ -156,7 +159,7 @@ int sun4i_hash_import_sha1(struct ahash_request *areq, const void *in)
  * write remaining data in op->buf
  * final state op->len=56
  */
-int sun4i_hash_update(struct ahash_request *areq)
+int sun4i_hash(struct ahash_request *areq)
 {
 	u32 v, ivmode = 0;
 	unsigned int i = 0;
@@ -180,22 +183,30 @@ int sun4i_hash_update(struct ahash_request *areq)
 	u32 spaces, rx_cnt = SS_RX_DEFAULT;
 	size_t copied = 0;
 	struct sg_mapping_iter mi;
+	unsigned int j = 0;
+	int zeros;
+	unsigned int index, padlen;
+	__be64 bits;
+	u32 bf[32];
+	u32 wb = 0;
+	unsigned int nwait, nbw = 0;
+	struct scatterlist *in_sg = areq->src;
 
 	dev_dbg(ss->dev, "%s %s bc=%llu len=%u mode=%x wl=%u h0=%0x",
 		__func__, crypto_tfm_alg_name(areq->base.tfm),
 		op->byte_count, areq->nbytes, op->mode,
 		op->len, op->hash[0]);
 
-	if (areq->nbytes == 0)
+	if (unlikely(areq->nbytes == 0) && (op->flags & SS_HASH_FINAL) == 0)
 		return 0;
 
 	/* protect against overflow */
-	if (areq->nbytes > UINT_MAX - op->len) {
+	if (unlikely(areq->nbytes > UINT_MAX - op->len)) {
 		dev_err(ss->dev, "Cannot process too large request\n");
 		return -EINVAL;
 	}
 
-	if (op->len + areq->nbytes < 64) {
+	if (op->len + areq->nbytes < 64 && (op->flags & SS_HASH_FINAL) == 0) {
 		/* linearize data to op->buf */
 		copied = sg_pcopy_to_buffer(areq->src, sg_nents(areq->src),
 					    op->buf + op->len, areq->nbytes, 0);
@@ -203,14 +214,6 @@ int sun4i_hash_update(struct ahash_request *areq)
 		return 0;
 	}
 
-	end = ((areq->nbytes + op->len) / 64) * 64 - op->len;
-
-	if (end > areq->nbytes || areq->nbytes - end > 63) {
-		dev_err(ss->dev, "ERROR: Bound error %u %u\n",
-			end, areq->nbytes);
-		return -EINVAL;
-	}
-
 	spin_lock_bh(&ss->slock);
 
 	/*
@@ -225,6 +228,33 @@ int sun4i_hash_update(struct ahash_request *areq)
 	/* Enable the device */
 	writel(op->mode | SS_ENABLED | ivmode, ss->base + SS_CTL);
 
+	if ((op->flags & SS_HASH_UPDATE) == 0)
+		goto hash_final;
+
+	/* start of handling data */
+	if ((op->flags & SS_HASH_FINAL) == 0) {
+		end = ((areq->nbytes + op->len) / 64) * 64 - op->len;
+
+		if (end > areq->nbytes || areq->nbytes - end > 63) {
+			dev_err(ss->dev, "ERROR: Bound error %u %u\n",
+				end, areq->nbytes);
+			return -EINVAL;
+		}
+	} else {
+		/* Since we have the flag final, we can go up to modulo 4 */
+		end = ((areq->nbytes + op->len) / 4) * 4 - op->len;
+	}
+
+	/* TODO if SGlen % 4 and op->len == 0 then DMA */
+	i = 1;
+	while (in_sg && i == 1) {
+		if ((in_sg->length % 4) != 0)
+			i = 0;
+		in_sg = sg_next(in_sg);
+	}
+	if (i == 1 && op->len == 0)
+		dev_dbg(ss->dev, "We can DMA\n");
+
 	i = 0;
 	sg_miter_start(&mi, areq->src, sg_nents(areq->src),
 		       SG_MITER_FROM_SG | SG_MITER_ATOMIC);
@@ -285,7 +315,11 @@ int sun4i_hash_update(struct ahash_request *areq)
 			}
 		}
 	} while (i < end);
-	/* final linear */
+
+	/*
+	 * Now we have written to the device all that we can,
+	 * store the remaining bytes in op->buf
+	 */
 	if ((areq->nbytes - i) < 64) {
 		while (i < areq->nbytes && in_i < mi.length && op->len < 64) {
 			/* how many bytes we can read from current SG */
@@ -304,13 +338,21 @@ int sun4i_hash_update(struct ahash_request *areq)
 
 	sg_miter_stop(&mi);
 
+	/*
+	 * End of data process
+	 * Now if we have the flag final go to finalize part
+	 * If not, store the partial hash
+	 */
+	if ((op->flags & SS_HASH_FINAL) > 0)
+		goto hash_final;
+
 	writel(op->mode | SS_ENABLED | SS_DATA_END, ss->base + SS_CTL);
 	i = 0;
 	do {
 		v = readl(ss->base + SS_CTL);
 		i++;
 	} while (i < SS_TIMEOUT && (v & SS_DATA_END) > 0);
-	if (i >= SS_TIMEOUT) {
+	if (unlikely(i >= SS_TIMEOUT)) {
 		dev_err_ratelimited(ss->dev,
 				    "ERROR: hash end timeout %d>%d ctl=%x len=%u\n",
 				    i, SS_TIMEOUT, v, areq->nbytes);
@@ -318,56 +360,24 @@ int sun4i_hash_update(struct ahash_request *areq)
 		goto release_ss;
 	}
 
-	/* get the partial hash only if something was written */
 	for (i = 0; i < crypto_ahash_digestsize(tfm) / 4; i++)
 		op->hash[i] = readl(ss->base + SS_MD0 + i * 4);
 
-release_ss:
-	writel(0, ss->base + SS_CTL);
-	spin_unlock_bh(&ss->slock);
-	return err;
-}
+	goto release_ss;
 
 /*
- * sun4i_hash_final: finalize hashing operation
+ * hash_final: finalize hashing operation
  *
  * If we have some remaining bytes, we write them.
  * Then ask the SS for finalizing the hashing operation
  *
  * I do not check RX FIFO size in this function since the size is 32
  * after each enabling and this function neither write more than 32 words.
+ * If we come from the update part, we cannot have more than
+ * 3 remainings bytes to write and SS is fast enought to not care about it.
  */
-int sun4i_hash_final(struct ahash_request *areq)
-{
-	u32 v, ivmode = 0;
-	unsigned int i;
-	unsigned int j = 0;
-	int zeros, err = 0;
-	unsigned int index, padlen;
-	__be64 bits;
-	struct sun4i_req_ctx *op = ahash_request_ctx(areq);
-	struct sun4i_ss_ctx *ss = op->ss;
-	struct crypto_ahash *tfm = crypto_ahash_reqtfm(areq);
-	u32 bf[32];
-	u32 wb = 0;
-	unsigned int nwait, nbw = 0;
 
-	dev_dbg(ss->dev, "%s: byte=%llu len=%u mode=%x wl=%u h=%x",
-		__func__, op->byte_count, areq->nbytes, op->mode,
-		op->len, op->hash[0]);
-
-	spin_lock_bh(&ss->slock);
-
-	/*
-	 * if we have already written something,
-	 * restore the partial hash state
-	 */
-	if (op->byte_count > 0) {
-		ivmode = SS_IV_ARBITRARY;
-		for (i = 0; i < crypto_ahash_digestsize(tfm) / 4; i++)
-			writel(op->hash[i], ss->base + SS_IV0 + i * 4);
-	}
-	writel(op->mode | SS_ENABLED | ivmode, ss->base + SS_CTL);
+hash_final:
 
 	/* write the remaining words of the wait buffer */
 	if (op->len > 0) {
@@ -436,7 +446,7 @@ int sun4i_hash_final(struct ahash_request *areq)
 		v = readl(ss->base + SS_CTL);
 		i++;
 	} while (i < SS_TIMEOUT && (v & SS_DATA_END) > 0);
-	if (i >= SS_TIMEOUT) {
+	if (unlikely(i >= SS_TIMEOUT)) {
 		dev_err_ratelimited(ss->dev,
 				    "ERROR: hash end timeout %d>%d ctl=%x len=%u\n",
 				    i, SS_TIMEOUT, v, areq->nbytes);
@@ -463,30 +473,41 @@ release_ss:
 	return err;
 }
 
+int sun4i_hash_final(struct ahash_request *areq)
+{
+	struct sun4i_req_ctx *op = ahash_request_ctx(areq);
+
+	op->flags = SS_HASH_FINAL;
+	return sun4i_hash(areq);
+}
+
+int sun4i_hash_update(struct ahash_request *areq)
+{
+	struct sun4i_req_ctx *op = ahash_request_ctx(areq);
+
+	op->flags = SS_HASH_UPDATE;
+	return sun4i_hash(areq);
+}
+
 /* sun4i_hash_finup: finalize hashing operation after an update */
 int sun4i_hash_finup(struct ahash_request *areq)
 {
-	int err;
-
-	err = sun4i_hash_update(areq);
-	if (err != 0)
-		return err;
+	struct sun4i_req_ctx *op = ahash_request_ctx(areq);
 
-	return sun4i_hash_final(areq);
+	op->flags = SS_HASH_UPDATE | SS_HASH_FINAL;
+	return sun4i_hash(areq);
 }
 
 /* combo of init/update/final functions */
 int sun4i_hash_digest(struct ahash_request *areq)
 {
 	int err;
+	struct sun4i_req_ctx *op = ahash_request_ctx(areq);
 
 	err = sun4i_hash_init(areq);
 	if (err != 0)
 		return err;
 
-	err = sun4i_hash_update(areq);
-	if (err != 0)
-		return err;
-
-	return sun4i_hash_final(areq);
+	op->flags = SS_HASH_UPDATE | SS_HASH_FINAL;
+	return sun4i_hash(areq);
 }
diff --git a/drivers/crypto/sunxi-ss/sun4i-ss.h b/drivers/crypto/sunxi-ss/sun4i-ss.h
index 8e9c05f..ece5a1c 100644
--- a/drivers/crypto/sunxi-ss/sun4i-ss.h
+++ b/drivers/crypto/sunxi-ss/sun4i-ss.h
@@ -164,6 +164,7 @@ struct sun4i_req_ctx {
 	char buf[64];
 	unsigned int len;
 	struct sun4i_ss_ctx *ss;
+	int flags;
 };
 
 int sun4i_hash_crainit(struct crypto_tfm *tfm);
-- 
2.7.3
