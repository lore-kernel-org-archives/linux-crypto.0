From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH v3 06/27] staging: ccree: copy larval digest from RAM
Date: Sun,  7 Jan 2018 12:14:17 +0000
Message-ID: <1515327285-8948-7-git-send-email-gilad@benyossef.com>
References: <1515327285-8948-1-git-send-email-gilad@benyossef.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, devel@driverdev.osuosl.org,
 driverdev-devel@linuxdriverproject.org, linux-kernel@vger.kernel.org,
 Ofir Drang <ofir.drang@arm.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <1515327285-8948-1-git-send-email-gilad@benyossef.com>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
List-Id: linux-crypto.vger.kernel.org

The ccree driver was using a DMA operation to copy larval digest
from the ccree SRAM to RAM. Replace it with a simple memcpy.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---
 drivers/staging/ccree/ssi_driver.c |   2 +
 drivers/staging/ccree/ssi_hash.c   | 121 ++++++++++++++++++++-----------------
 drivers/staging/ccree/ssi_hash.h   |   2 +
 3 files changed, 68 insertions(+), 57 deletions(-)

diff --git a/drivers/staging/ccree/ssi_driver.c b/drivers/staging/ccree/ssi_driver.c
index 3eabefb..b5df9b4 100644
--- a/drivers/staging/ccree/ssi_driver.c
+++ b/drivers/staging/ccree/ssi_driver.c
@@ -484,6 +484,8 @@ static int __init ccree_init(void)
 {
 	int ret;
 
+	cc_hash_global_init();
+
 	ret = cc_debugfs_global_init();
 	if (ret)
 		return ret;
diff --git a/drivers/staging/ccree/ssi_hash.c b/drivers/staging/ccree/ssi_hash.c
index 7a8a036..b51a1d4 100644
--- a/drivers/staging/ccree/ssi_hash.c
+++ b/drivers/staging/ccree/ssi_hash.c
@@ -41,10 +41,10 @@ static const u32 sha256_init[] = {
 #if (CC_DEV_SHA_MAX > 256)
 static const u32 digest_len_sha512_init[] = {
 	0x00000080, 0x00000000, 0x00000000, 0x00000000 };
-static const u64 sha384_init[] = {
+static u64 sha384_init[] = {
 	SHA384_H7, SHA384_H6, SHA384_H5, SHA384_H4,
 	SHA384_H3, SHA384_H2, SHA384_H1, SHA384_H0 };
-static const u64 sha512_init[] = {
+static u64 sha512_init[] = {
 	SHA512_H7, SHA512_H6, SHA512_H5, SHA512_H4,
 	SHA512_H3, SHA512_H2, SHA512_H1, SHA512_H0 };
 #endif
@@ -55,6 +55,8 @@ static void cc_setup_xcbc(struct ahash_request *areq, struct cc_hw_desc desc[],
 static void cc_setup_cmac(struct ahash_request *areq, struct cc_hw_desc desc[],
 			  unsigned int *seq_size);
 
+static const void *cc_larval_digest(struct device *dev, u32 mode);
+
 struct cc_hash_alg {
 	struct list_head entry;
 	int hash_mode;
@@ -126,10 +128,6 @@ static int cc_map_req(struct device *dev, struct ahash_req_ctx *state,
 		      struct cc_hash_ctx *ctx, gfp_t flags)
 {
 	bool is_hmac = ctx->is_hmac;
-	cc_sram_addr_t larval_digest_addr =
-		cc_larval_digest_addr(ctx->drvdata, ctx->hash_mode);
-	struct cc_crypto_req cc_req = {};
-	struct cc_hw_desc desc;
 	int rc = -ENOMEM;
 
 	state->buff0 = kzalloc(CC_MAX_HASH_BLCK_SIZE, flags);
@@ -203,9 +201,6 @@ static int cc_map_req(struct device *dev, struct ahash_req_ctx *state,
 			       HASH_LEN_SIZE);
 #endif
 		}
-		dma_sync_single_for_device(dev, state->digest_buff_dma_addr,
-					   ctx->inter_digestsize,
-					   DMA_BIDIRECTIONAL);
 
 		if (ctx->hash_mode != DRV_HASH_NULL) {
 			dma_sync_single_for_cpu(dev,
@@ -216,22 +211,15 @@ static int cc_map_req(struct device *dev, struct ahash_req_ctx *state,
 			       ctx->opad_tmp_keys_buff, ctx->inter_digestsize);
 		}
 	} else { /*hash*/
-		/* Copy the initial digests if hash flow. The SRAM contains the
-		 * initial digests in the expected order for all SHA*
-		 */
-		hw_desc_init(&desc);
-		set_din_sram(&desc, larval_digest_addr, ctx->inter_digestsize);
-		set_dout_dlli(&desc, state->digest_buff_dma_addr,
-			      ctx->inter_digestsize, NS_BIT, 0);
-		set_flow_mode(&desc, BYPASS);
+		/* Copy the initial digests if hash flow. */
+		const void *larval = cc_larval_digest(dev, ctx->hash_mode);
 
-		rc = send_request(ctx->drvdata, &cc_req, &desc, 1, 0);
-		if (rc) {
-			dev_err(dev, "send_request() failed (rc=%d)\n", rc);
-			goto fail4;
-		}
+		memcpy(state->digest_buff, larval, ctx->inter_digestsize);
 	}
 
+	dma_sync_single_for_device(dev, state->digest_buff_dma_addr,
+				   ctx->inter_digestsize, DMA_BIDIRECTIONAL);
+
 	if (ctx->hw_mode != DRV_CIPHER_XCBC_MAC) {
 		state->digest_bytes_len_dma_addr =
 			dma_map_single(dev, (void *)state->digest_bytes_len,
@@ -2003,11 +1991,7 @@ int cc_init_hash_sram(struct cc_drvdata *drvdata)
 	cc_sram_addr_t sram_buff_ofs = hash_handle->digest_len_sram_addr;
 	unsigned int larval_seq_len = 0;
 	struct cc_hw_desc larval_seq[CC_DIGEST_SIZE_MAX / sizeof(u32)];
-	struct device *dev = drvdata_to_dev(drvdata);
 	int rc = 0;
-#if (CC_DEV_SHA_MAX > 256)
-	int i;
-#endif
 
 	/* Copy-to-sram digest-len */
 	cc_set_sram_desc(digest_len_init, sram_buff_ofs,
@@ -2074,49 +2058,49 @@ int cc_init_hash_sram(struct cc_drvdata *drvdata)
 	larval_seq_len = 0;
 
 #if (CC_DEV_SHA_MAX > 256)
-	/* We are forced to swap each double-word larval before copying to
-	 * sram
-	 */
-	for (i = 0; i < ARRAY_SIZE(sha384_init); i++) {
-		const u32 const0 = ((u32 *)((u64 *)&sha384_init[i]))[1];
-		const u32 const1 = ((u32 *)((u64 *)&sha384_init[i]))[0];
-
-		cc_set_sram_desc(&const0, sram_buff_ofs, 1, larval_seq,
-				 &larval_seq_len);
-		sram_buff_ofs += sizeof(u32);
-		cc_set_sram_desc(&const1, sram_buff_ofs, 1, larval_seq,
-				 &larval_seq_len);
-		sram_buff_ofs += sizeof(u32);
-	}
+	cc_set_sram_desc((u32 *)sha384_init, sram_buff_ofs,
+			 (ARRAY_SIZE(sha384_init) * 2), larval_seq,
+			 &larval_seq_len);
 	rc = send_request_init(drvdata, larval_seq, larval_seq_len);
-	if (rc) {
-		dev_err(dev, "send_request() failed (rc = %d)\n", rc);
+	if (rc)
 		goto init_digest_const_err;
-	}
+	sram_buff_ofs += sizeof(sha384_init);
 	larval_seq_len = 0;
 
-	for (i = 0; i < ARRAY_SIZE(sha512_init); i++) {
-		const u32 const0 = ((u32 *)((u64 *)&sha512_init[i]))[1];
-		const u32 const1 = ((u32 *)((u64 *)&sha512_init[i]))[0];
-
-		cc_set_sram_desc(&const0, sram_buff_ofs, 1, larval_seq,
-				 &larval_seq_len);
-		sram_buff_ofs += sizeof(u32);
-		cc_set_sram_desc(&const1, sram_buff_ofs, 1, larval_seq,
-				 &larval_seq_len);
-		sram_buff_ofs += sizeof(u32);
-	}
+	cc_set_sram_desc((u32 *)sha512_init, sram_buff_ofs,
+			 (ARRAY_SIZE(sha512_init) * 2), larval_seq,
+			 &larval_seq_len);
 	rc = send_request_init(drvdata, larval_seq, larval_seq_len);
-	if (rc) {
-		dev_err(dev, "send_request() failed (rc = %d)\n", rc);
+	if (rc)
 		goto init_digest_const_err;
-	}
 #endif
 
 init_digest_const_err:
 	return rc;
 }
 
+static void __init cc_swap_dwords(u32 *buf, unsigned long size)
+{
+	int i;
+	u32 tmp;
+
+	for (i = 0; i < size; i += 2) {
+		tmp = buf[i];
+		buf[i] = buf[i + 1];
+		buf[i + 1] = tmp;
+	}
+}
+
+/*
+ * Due to the way the HW works we need to swap every
+ * double word in the SHA384 and SHA512 larval hashes
+ */
+void __init cc_hash_global_init(void)
+{
+	cc_swap_dwords((u32 *)&sha384_init, (ARRAY_SIZE(sha384_init) * 2));
+	cc_swap_dwords((u32 *)&sha512_init, (ARRAY_SIZE(sha512_init) * 2));
+}
+
 int cc_hash_alloc(struct cc_drvdata *drvdata)
 {
 	struct cc_hash_handle *hash_handle;
@@ -2373,6 +2357,29 @@ static void cc_set_desc(struct ahash_req_ctx *areq_ctx,
 	*seq_size = idx;
 }
 
+static const void *cc_larval_digest(struct device *dev, u32 mode)
+{
+	switch (mode) {
+	case DRV_HASH_MD5:
+		return md5_init;
+	case DRV_HASH_SHA1:
+		return sha1_init;
+	case DRV_HASH_SHA224:
+		return sha224_init;
+	case DRV_HASH_SHA256:
+		return sha256_init;
+#if (CC_DEV_SHA_MAX > 256)
+	case DRV_HASH_SHA384:
+		return sha384_init;
+	case DRV_HASH_SHA512:
+		return sha512_init;
+#endif
+	default:
+		dev_err(dev, "Invalid hash mode (%d)\n", mode);
+		return md5_init;
+	}
+}
+
 /*!
  * Gets the address of the initial digest in SRAM
  * according to the given hash mode
diff --git a/drivers/staging/ccree/ssi_hash.h b/drivers/staging/ccree/ssi_hash.h
index fa2cdb1..f78faae 100644
--- a/drivers/staging/ccree/ssi_hash.h
+++ b/drivers/staging/ccree/ssi_hash.h
@@ -90,5 +90,7 @@ cc_digest_len_addr(void *drvdata, u32 mode);
  */
 cc_sram_addr_t cc_larval_digest_addr(void *drvdata, u32 mode);
 
+void cc_hash_global_init(void);
+
 #endif /*__CC_HASH_H__*/
 
-- 
2.7.4
