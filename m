From: Ryder Lee <ryder.lee-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 1/8] crypto: mediatek - move HW control data to transformation
 context
Date: Fri, 20 Jan 2017 13:41:08 +0800
Message-ID: <1484890875-57105-2-git-send-email-ryder.lee@mediatek.com>
References: <1484890875-57105-1-git-send-email-ryder.lee@mediatek.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Ryder Lee <ryder.lee-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org>, linux-mediatek-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org,
 linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org,
 linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>, "David S. Miller"
 <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>
Return-path: <linux-mediatek-bounces+glpam-linux-mediatek=m.gmane.org-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
In-Reply-To: <1484890875-57105-1-git-send-email-ryder.lee-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-mediatek>,
 <mailto:linux-mediatek-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-mediatek/>
List-Post: <mailto:linux-mediatek-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
List-Help: <mailto:linux-mediatek-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-mediatek>,
 <mailto:linux-mediatek-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=subscribe>
Sender: "Linux-mediatek" <linux-mediatek-bounces-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
Errors-To: linux-mediatek-bounces+glpam-linux-mediatek=m.gmane.org-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

This patch moves hardware control block members from
mtk_*_rec to transformation context and refines related
definition. This makes operational context to manage its
own control information easily for each DMA transfer.

Signed-off-by: Ryder Lee <ryder.lee-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org>
---
 drivers/crypto/mediatek/mtk-aes.c      | 144 ++++++++++++++++-----------------
 drivers/crypto/mediatek/mtk-platform.h |  26 +-----
 drivers/crypto/mediatek/mtk-sha.c      | 101 ++++++++++++-----------
 3 files changed, 126 insertions(+), 145 deletions(-)

diff --git a/drivers/crypto/mediatek/mtk-aes.c b/drivers/crypto/mediatek/mtk-aes.c
index 1370cab..126b93c 100644
--- a/drivers/crypto/mediatek/mtk-aes.c
+++ b/drivers/crypto/mediatek/mtk-aes.c
@@ -20,23 +20,25 @@
 #define AES_BUF_SIZE		((PAGE_SIZE << AES_BUF_ORDER) \
 				& ~(AES_BLOCK_SIZE - 1))
 
-/* AES command token */
+/* AES command token size */
 #define AES_CT_SIZE_ECB		2
 #define AES_CT_SIZE_CBC		3
 #define AES_CT_CTRL_HDR		cpu_to_le32(0x00220000)
-#define AES_COMMAND0		cpu_to_le32(0x05000000)
-#define AES_COMMAND1		cpu_to_le32(0x2d060000)
-#define AES_COMMAND2		cpu_to_le32(0xe4a63806)
-
-/* AES transform information */
-#define AES_TFM_ECB		cpu_to_le32(0x0 << 0)
-#define AES_TFM_CBC		cpu_to_le32(0x1 << 0)
-#define AES_TFM_DECRYPT		cpu_to_le32(0x5 << 0)
-#define AES_TFM_ENCRYPT		cpu_to_le32(0x4 << 0)
+/* AES-CBC/ECB command token */
+#define AES_CMD0		cpu_to_le32(0x05000000)
+#define AES_CMD1		cpu_to_le32(0x2d060000)
+#define AES_CMD2		cpu_to_le32(0xe4a63806)
+
+/* AES transform information word 0 fields */
+#define AES_TFM_BASIC_OUT	cpu_to_le32(0x4 << 0)
+#define AES_TFM_BASIC_IN	cpu_to_le32(0x5 << 0)
 #define AES_TFM_SIZE(x)		cpu_to_le32((x) << 8)
 #define AES_TFM_128BITS		cpu_to_le32(0xb << 16)
 #define AES_TFM_192BITS		cpu_to_le32(0xd << 16)
 #define AES_TFM_256BITS		cpu_to_le32(0xf << 16)
+/* AES transform information word 1 fields */
+#define AES_TFM_ECB		cpu_to_le32(0x0 << 0)
+#define AES_TFM_CBC		cpu_to_le32(0x1 << 0)
 #define AES_TFM_FULL_IV		cpu_to_le32(0xf << 5)
 
 /* AES flags */
@@ -47,47 +49,41 @@
 #define AES_FLAGS_BUSY		BIT(3)
 
 /**
- * mtk_aes_ct is a set of hardware instructions(command token)
- * that are used to control engine's processing flow of AES.
+ * Command token(CT) is a set of hardware instructions that
+ * are used to control engine's processing flow of AES.
+ *
+ * Transform information(TFM) is used to define AES state and
+ * contains all keys and initial vectors.
+ *
+ * The engine requires CT and TFM to do:
+ * - Commands decoding and control of the engine's data path.
+ * - Coordinating hardware data fetch and store operations.
+ * - Result token construction and output.
  */
 struct mtk_aes_ct {
-	__le32 ct_ctrl0;
-	__le32 ct_ctrl1;
-	__le32 ct_ctrl2;
+	__le32 cmd[AES_CT_SIZE_CBC];
 };
 
-/**
- * mtk_aes_tfm is used to define AES transform state
- * and contains all keys and initial vectors.
- */
 struct mtk_aes_tfm {
-	__le32 tfm_ctrl0;
-	__le32 tfm_ctrl1;
+	__le32 ctrl[2];
 	__le32 state[SIZE_IN_WORDS(AES_KEYSIZE_256 + AES_BLOCK_SIZE)];
 };
 
-/**
- * mtk_aes_info consists of command token and transform state of AES,
- * which should be encapsulated in command and result descriptors.
- *
- * The engine requires this information to do:
- * - Commands decoding and control of the engine's data path.
- * - Coordinating hardware data fetch and store operations.
- * - Result token construction and output.
- */
-struct mtk_aes_info {
-	struct mtk_aes_ct ct;
-	struct mtk_aes_tfm tfm;
-};
-
 struct mtk_aes_reqctx {
 	u64 mode;
 };
 
 struct mtk_aes_ctx {
 	struct mtk_cryp *cryp;
-	struct mtk_aes_info info;
 	u32 keylen;
+
+	struct mtk_aes_ct ct;
+	dma_addr_t ct_dma;
+	struct mtk_aes_tfm tfm;
+	dma_addr_t tfm_dma;
+
+	__le32 ct_hdr;
+	u32 ct_size;
 };
 
 struct mtk_aes_drv {
@@ -174,57 +170,57 @@ static int mtk_aes_info_map(struct mtk_cryp *cryp,
 			    struct mtk_aes_rec *aes,
 			    size_t len)
 {
-	struct mtk_aes_ctx *ctx = crypto_ablkcipher_ctx(
-			crypto_ablkcipher_reqtfm(aes->req));
-	struct mtk_aes_info *info = aes->info;
-	struct mtk_aes_ct *ct = &info->ct;
-	struct mtk_aes_tfm *tfm = &info->tfm;
+	struct mtk_aes_ctx *ctx = aes->ctx;
 
-	aes->ct_hdr = AES_CT_CTRL_HDR | cpu_to_le32(len);
+	ctx->ct_hdr = AES_CT_CTRL_HDR | cpu_to_le32(len);
+	ctx->ct.cmd[0] = AES_CMD0 | cpu_to_le32(len);
+	ctx->ct.cmd[1] = AES_CMD1;
 
 	if (aes->flags & AES_FLAGS_ENCRYPT)
-		tfm->tfm_ctrl0 = AES_TFM_ENCRYPT;
+		ctx->tfm.ctrl[0] = AES_TFM_BASIC_OUT;
 	else
-		tfm->tfm_ctrl0 = AES_TFM_DECRYPT;
+		ctx->tfm.ctrl[0] = AES_TFM_BASIC_IN;
 
 	if (ctx->keylen == SIZE_IN_WORDS(AES_KEYSIZE_128))
-		tfm->tfm_ctrl0 |= AES_TFM_128BITS;
+		ctx->tfm.ctrl[0] |= AES_TFM_128BITS;
 	else if (ctx->keylen == SIZE_IN_WORDS(AES_KEYSIZE_256))
-		tfm->tfm_ctrl0 |= AES_TFM_256BITS;
+		ctx->tfm.ctrl[0] |= AES_TFM_256BITS;
 	else if (ctx->keylen == SIZE_IN_WORDS(AES_KEYSIZE_192))
-		tfm->tfm_ctrl0 |= AES_TFM_192BITS;
-
-	ct->ct_ctrl0 = AES_COMMAND0 | cpu_to_le32(len);
-	ct->ct_ctrl1 = AES_COMMAND1;
+		ctx->tfm.ctrl[0] |= AES_TFM_192BITS;
 
 	if (aes->flags & AES_FLAGS_CBC) {
 		const u32 *iv = (const u32 *)aes->req->info;
-		u32 *iv_state = tfm->state + ctx->keylen;
+		u32 *iv_state = ctx->tfm.state + ctx->keylen;
 		int i;
 
-		aes->ct_size = AES_CT_SIZE_CBC;
-		ct->ct_ctrl2 = AES_COMMAND2;
-
-		tfm->tfm_ctrl0 |= AES_TFM_SIZE(ctx->keylen +
+		ctx->tfm.ctrl[0] |= AES_TFM_SIZE(ctx->keylen +
 				  SIZE_IN_WORDS(AES_BLOCK_SIZE));
-		tfm->tfm_ctrl1 = AES_TFM_CBC | AES_TFM_FULL_IV;
+		ctx->tfm.ctrl[1] = AES_TFM_CBC | AES_TFM_FULL_IV;
 
 		for (i = 0; i < SIZE_IN_WORDS(AES_BLOCK_SIZE); i++)
 			iv_state[i] = cpu_to_le32(iv[i]);
 
+		ctx->ct.cmd[2] = AES_CMD2;
+		ctx->ct_size  = AES_CT_SIZE_CBC;
 	} else if (aes->flags & AES_FLAGS_ECB) {
-		aes->ct_size = AES_CT_SIZE_ECB;
-		tfm->tfm_ctrl0 |= AES_TFM_SIZE(ctx->keylen);
-		tfm->tfm_ctrl1 = AES_TFM_ECB;
+		ctx->tfm.ctrl[0] |= AES_TFM_SIZE(ctx->keylen);
+		ctx->tfm.ctrl[1] = AES_TFM_ECB;
+
+		ctx->ct_size = AES_CT_SIZE_ECB;
 	}
 
-	aes->ct_dma = dma_map_single(cryp->dev, info, sizeof(*info),
-					DMA_TO_DEVICE);
-	if (unlikely(dma_mapping_error(cryp->dev, aes->ct_dma))) {
-		dev_err(cryp->dev, "dma %zu bytes error\n", sizeof(*info));
+	ctx->ct_dma = dma_map_single(cryp->dev, &ctx->ct, sizeof(ctx->ct),
+				     DMA_TO_DEVICE);
+	if (unlikely(dma_mapping_error(cryp->dev, ctx->ct_dma)))
+		return -EINVAL;
+
+	ctx->tfm_dma = dma_map_single(cryp->dev, &ctx->tfm, sizeof(ctx->tfm),
+				      DMA_TO_DEVICE);
+	if (unlikely(dma_mapping_error(cryp->dev, ctx->tfm_dma))) {
+		dma_unmap_single(cryp->dev, ctx->tfm_dma, sizeof(ctx->tfm),
+				 DMA_TO_DEVICE);
 		return -EINVAL;
 	}
-	aes->tfm_dma = aes->ct_dma + sizeof(*ct);
 
 	return 0;
 }
@@ -253,10 +249,10 @@ static int mtk_aes_xmit(struct mtk_cryp *cryp, struct mtk_aes_rec *aes)
 		if (nents == 0) {
 			res->hdr |= MTK_DESC_FIRST;
 			cmd->hdr |= MTK_DESC_FIRST |
-				    MTK_DESC_CT_LEN(aes->ct_size);
-			cmd->ct = cpu_to_le32(aes->ct_dma);
-			cmd->ct_hdr = aes->ct_hdr;
-			cmd->tfm = cpu_to_le32(aes->tfm_dma);
+				    MTK_DESC_CT_LEN(aes->ctx->ct_size);
+			cmd->ct = cpu_to_le32(aes->ctx->ct_dma);
+			cmd->ct_hdr = aes->ctx->ct_hdr;
+			cmd->tfm = cpu_to_le32(aes->ctx->tfm_dma);
 		}
 
 		if (++ring->pos == MTK_DESC_NUM)
@@ -396,7 +392,7 @@ static int mtk_aes_handle_queue(struct mtk_cryp *cryp, u8 id,
 	rctx->mode &= AES_FLAGS_MODE_MSK;
 	/* Assign new request to device */
 	aes->req = req;
-	aes->info = &ctx->info;
+	aes->ctx = ctx;
 	aes->flags = (aes->flags & ~AES_FLAGS_MODE_MSK) | rctx->mode;
 
 	err = mtk_aes_map(cryp, aes);
@@ -408,8 +404,12 @@ static int mtk_aes_handle_queue(struct mtk_cryp *cryp, u8 id,
 
 static void mtk_aes_unmap(struct mtk_cryp *cryp, struct mtk_aes_rec *aes)
 {
-	dma_unmap_single(cryp->dev, aes->ct_dma,
-			 sizeof(struct mtk_aes_info), DMA_TO_DEVICE);
+	struct mtk_aes_ctx *ctx = aes->ctx;
+
+	dma_unmap_single(cryp->dev, ctx->ct_dma, sizeof(ctx->ct),
+			 DMA_TO_DEVICE);
+	dma_unmap_single(cryp->dev, ctx->tfm_dma, sizeof(ctx->tfm),
+			 DMA_TO_DEVICE);
 
 	if (aes->src.sg == aes->dst.sg) {
 		dma_unmap_sg(cryp->dev, aes->src.sg,
@@ -454,7 +454,7 @@ static int mtk_aes_setkey(struct crypto_ablkcipher *tfm,
 {
 	struct mtk_aes_ctx *ctx = crypto_ablkcipher_ctx(tfm);
 	const u32 *key_tmp = (const u32 *)key;
-	u32 *key_state = ctx->info.tfm.state;
+	u32 *key_state = ctx->tfm.state;
 	int i;
 
 	if (keylen != AES_KEYSIZE_128 &&
diff --git a/drivers/crypto/mediatek/mtk-platform.h b/drivers/crypto/mediatek/mtk-platform.h
index 4d4309a..1516786 100644
--- a/drivers/crypto/mediatek/mtk-platform.h
+++ b/drivers/crypto/mediatek/mtk-platform.h
@@ -113,22 +113,20 @@ struct mtk_aes_dma {
 	u32 sg_len;
 };
 
+struct mtk_aes_ctx;
+
 /**
  * struct mtk_aes_rec - AES operation record
  * @queue:	crypto request queue
  * @req:	pointer to ablkcipher request
  * @task:	the tasklet is use in AES interrupt
+ * @ctx:	pointer to current context
  * @src:	the structure that holds source sg list info
  * @dst:	the structure that holds destination sg list info
  * @aligned_sg:	the scatter list is use to alignment
  * @real_dst:	pointer to the destination sg list
  * @total:	request buffer length
  * @buf:	pointer to page buffer
- * @info:	pointer to AES transform state and command token
- * @ct_hdr:	AES command token control field
- * @ct_size:	size of AES command token
- * @ct_dma:	DMA address of AES command token
- * @tfm_dma:	DMA address of AES transform state
  * @id:		record identification
  * @flags:	it's describing AES operation state
  * @lock:	the ablkcipher queue lock
@@ -139,6 +137,7 @@ struct mtk_aes_rec {
 	struct crypto_queue queue;
 	struct ablkcipher_request *req;
 	struct tasklet_struct task;
+	struct mtk_aes_ctx *ctx;
 	struct mtk_aes_dma src;
 	struct mtk_aes_dma dst;
 
@@ -148,12 +147,6 @@ struct mtk_aes_rec {
 	size_t total;
 	void *buf;
 
-	void *info;
-	__le32 ct_hdr;
-	u32 ct_size;
-	dma_addr_t ct_dma;
-	dma_addr_t tfm_dma;
-
 	u8 id;
 	unsigned long flags;
 	/* queue lock */
@@ -165,11 +158,6 @@ struct mtk_aes_rec {
  * @queue:	crypto request queue
  * @req:	pointer to ahash request
  * @task:	the tasklet is use in SHA interrupt
- * @info:	pointer to SHA transform state and command token
- * @ct_hdr:	SHA command token control field
- * @ct_size:	size of SHA command token
- * @ct_dma:	DMA address of SHA command token
- * @tfm_dma:	DMA address of SHA transform state
  * @id:		record identification
  * @flags:	it's describing SHA operation state
  * @lock:	the ablkcipher queue lock
@@ -181,12 +169,6 @@ struct mtk_sha_rec {
 	struct ahash_request *req;
 	struct tasklet_struct task;
 
-	void *info;
-	__le32 ct_hdr;
-	u32 ct_size;
-	dma_addr_t ct_dma;
-	dma_addr_t tfm_dma;
-
 	u8 id;
 	unsigned long flags;
 	/* queue lock */
diff --git a/drivers/crypto/mediatek/mtk-sha.c b/drivers/crypto/mediatek/mtk-sha.c
index f1e188b..8cbff21 100644
--- a/drivers/crypto/mediatek/mtk-sha.c
+++ b/drivers/crypto/mediatek/mtk-sha.c
@@ -28,9 +28,9 @@
 /* SHA command token */
 #define SHA_CT_SIZE		5
 #define SHA_CT_CTRL_HDR		cpu_to_le32(0x02220000)
-#define SHA_COMMAND0		cpu_to_le32(0x03020000)
-#define SHA_COMMAND1		cpu_to_le32(0x21060000)
-#define SHA_COMMAND2		cpu_to_le32(0xe0e63802)
+#define SHA_CMD0		cpu_to_le32(0x03020000)
+#define SHA_CMD1		cpu_to_le32(0x21060000)
+#define SHA_CMD2		cpu_to_le32(0xe0e63802)
 
 /* SHA transform information */
 #define SHA_TFM_HASH		cpu_to_le32(0x2 << 0)
@@ -66,11 +66,8 @@
  * and it contains the first two words of transform state.
  */
 struct mtk_sha_ct {
-	__le32 tfm_ctrl0;
-	__le32 tfm_ctrl1;
-	__le32 ct_ctrl0;
-	__le32 ct_ctrl1;
-	__le32 ct_ctrl2;
+	__le32 ctrl[2];
+	__le32 cmd[3];
 };
 
 /**
@@ -78,8 +75,7 @@ struct mtk_sha_ct {
  * and store result digest that produced by engine.
  */
 struct mtk_sha_tfm {
-	__le32 tfm_ctrl0;
-	__le32 tfm_ctrl1;
+	__le32 ctrl[2];
 	__le32 digest[SIZE_IN_WORDS(SHA512_DIGEST_SIZE)];
 };
 
@@ -102,6 +98,11 @@ struct mtk_sha_reqctx {
 	size_t bufcnt;
 	dma_addr_t dma_addr;
 
+	__le32 ct_hdr;
+	u32 ct_size;
+	dma_addr_t ct_dma;
+	dma_addr_t tfm_dma;
+
 	/* Walk state */
 	struct scatterlist *sg;
 	u32 offset;	/* Offset in current sg */
@@ -270,34 +271,32 @@ static void mtk_sha_fill_padding(struct mtk_sha_reqctx *ctx, u32 len)
 }
 
 /* Initialize basic transform information of SHA */
-static void mtk_sha_info_init(struct mtk_sha_rec *sha,
-			      struct mtk_sha_reqctx *ctx)
+static void mtk_sha_info_init(struct mtk_sha_reqctx *ctx)
 {
-	struct mtk_sha_info *info = sha->info;
-	struct mtk_sha_ct *ct = &info->ct;
-	struct mtk_sha_tfm *tfm = &info->tfm;
+	struct mtk_sha_ct *ct = &ctx->info.ct;
+	struct mtk_sha_tfm *tfm = &ctx->info.tfm;
 
-	sha->ct_hdr = SHA_CT_CTRL_HDR;
-	sha->ct_size = SHA_CT_SIZE;
+	ctx->ct_hdr = SHA_CT_CTRL_HDR;
+	ctx->ct_size = SHA_CT_SIZE;
 
-	tfm->tfm_ctrl0 = SHA_TFM_HASH | SHA_TFM_INNER_DIG |
-			 SHA_TFM_SIZE(SIZE_IN_WORDS(ctx->ds));
+	tfm->ctrl[0] = SHA_TFM_HASH | SHA_TFM_INNER_DIG |
+		       SHA_TFM_SIZE(SIZE_IN_WORDS(ctx->ds));
 
 	switch (ctx->flags & SHA_FLAGS_ALGO_MSK) {
 	case SHA_FLAGS_SHA1:
-		tfm->tfm_ctrl0 |= SHA_TFM_SHA1;
+		tfm->ctrl[0] |= SHA_TFM_SHA1;
 		break;
 	case SHA_FLAGS_SHA224:
-		tfm->tfm_ctrl0 |= SHA_TFM_SHA224;
+		tfm->ctrl[0] |= SHA_TFM_SHA224;
 		break;
 	case SHA_FLAGS_SHA256:
-		tfm->tfm_ctrl0 |= SHA_TFM_SHA256;
+		tfm->ctrl[0] |= SHA_TFM_SHA256;
 		break;
 	case SHA_FLAGS_SHA384:
-		tfm->tfm_ctrl0 |= SHA_TFM_SHA384;
+		tfm->ctrl[0] |= SHA_TFM_SHA384;
 		break;
 	case SHA_FLAGS_SHA512:
-		tfm->tfm_ctrl0 |= SHA_TFM_SHA512;
+		tfm->ctrl[0] |= SHA_TFM_SHA512;
 		break;
 
 	default:
@@ -305,13 +304,13 @@ static void mtk_sha_info_init(struct mtk_sha_rec *sha,
 		return;
 	}
 
-	tfm->tfm_ctrl1 = SHA_TFM_HASH_STORE;
-	ct->tfm_ctrl0 = tfm->tfm_ctrl0 | SHA_TFM_CONTINUE | SHA_TFM_START;
-	ct->tfm_ctrl1 = tfm->tfm_ctrl1;
+	tfm->ctrl[1] = SHA_TFM_HASH_STORE;
+	ct->ctrl[0] = tfm->ctrl[0] | SHA_TFM_CONTINUE | SHA_TFM_START;
+	ct->ctrl[1] = tfm->ctrl[1];
 
-	ct->ct_ctrl0 = SHA_COMMAND0;
-	ct->ct_ctrl1 = SHA_COMMAND1;
-	ct->ct_ctrl2 = SHA_COMMAND2 | SHA_TFM_DIGEST(SIZE_IN_WORDS(ctx->ds));
+	ct->cmd[0] = SHA_CMD0;
+	ct->cmd[1] = SHA_CMD1;
+	ct->cmd[2] = SHA_CMD2 | SHA_TFM_DIGEST(SIZE_IN_WORDS(ctx->ds));
 }
 
 /*
@@ -323,28 +322,28 @@ static int mtk_sha_info_map(struct mtk_cryp *cryp,
 			    size_t len)
 {
 	struct mtk_sha_reqctx *ctx = ahash_request_ctx(sha->req);
-	struct mtk_sha_info *info = sha->info;
+	struct mtk_sha_info *info = &ctx->info;
 	struct mtk_sha_ct *ct = &info->ct;
 
 	if (ctx->start)
 		ctx->start = false;
 	else
-		ct->tfm_ctrl0 &= ~SHA_TFM_START;
+		ct->ctrl[0] &= ~SHA_TFM_START;
 
-	sha->ct_hdr &= ~SHA_DATA_LEN_MSK;
-	sha->ct_hdr |= cpu_to_le32(len);
-	ct->ct_ctrl0 &= ~SHA_DATA_LEN_MSK;
-	ct->ct_ctrl0 |= cpu_to_le32(len);
+	ctx->ct_hdr &= ~SHA_DATA_LEN_MSK;
+	ctx->ct_hdr |= cpu_to_le32(len);
+	ct->cmd[0] &= ~SHA_DATA_LEN_MSK;
+	ct->cmd[0] |= cpu_to_le32(len);
 
 	ctx->digcnt += len;
 
-	sha->ct_dma = dma_map_single(cryp->dev, info, sizeof(*info),
+	ctx->ct_dma = dma_map_single(cryp->dev, info, sizeof(*info),
 				      DMA_BIDIRECTIONAL);
-	if (unlikely(dma_mapping_error(cryp->dev, sha->ct_dma))) {
+	if (unlikely(dma_mapping_error(cryp->dev, ctx->ct_dma))) {
 		dev_err(cryp->dev, "dma %zu bytes error\n", sizeof(*info));
 		return -EINVAL;
 	}
-	sha->tfm_dma = sha->ct_dma + sizeof(*ct);
+	ctx->tfm_dma = ctx->ct_dma + sizeof(*ct);
 
 	return 0;
 }
@@ -425,6 +424,7 @@ static int mtk_sha_init(struct ahash_request *req)
 static int mtk_sha_xmit(struct mtk_cryp *cryp, struct mtk_sha_rec *sha,
 			dma_addr_t addr, size_t len)
 {
+	struct mtk_sha_reqctx *ctx = ahash_request_ctx(sha->req);
 	struct mtk_ring *ring = cryp->ring[sha->id];
 	struct mtk_desc *cmd = ring->cmd_base + ring->pos;
 	struct mtk_desc *res = ring->res_base + ring->pos;
@@ -444,12 +444,12 @@ static int mtk_sha_xmit(struct mtk_cryp *cryp, struct mtk_sha_rec *sha,
 	cmd->hdr = MTK_DESC_FIRST |
 		   MTK_DESC_LAST |
 		   MTK_DESC_BUF_LEN(len) |
-		   MTK_DESC_CT_LEN(sha->ct_size);
+		   MTK_DESC_CT_LEN(ctx->ct_size);
 
 	cmd->buf = cpu_to_le32(addr);
-	cmd->ct = cpu_to_le32(sha->ct_dma);
-	cmd->ct_hdr = sha->ct_hdr;
-	cmd->tfm = cpu_to_le32(sha->tfm_dma);
+	cmd->ct = cpu_to_le32(ctx->ct_dma);
+	cmd->ct_hdr = ctx->ct_hdr;
+	cmd->tfm = cpu_to_le32(ctx->tfm_dma);
 
 	if (++ring->pos == MTK_DESC_NUM)
 		ring->pos = 0;
@@ -486,11 +486,11 @@ static int mtk_sha_xmit2(struct mtk_cryp *cryp,
 
 	cmd->hdr = MTK_DESC_BUF_LEN(len1) |
 		   MTK_DESC_FIRST |
-		   MTK_DESC_CT_LEN(sha->ct_size);
+		   MTK_DESC_CT_LEN(ctx->ct_size);
 	cmd->buf = cpu_to_le32(sg_dma_address(ctx->sg));
-	cmd->ct = cpu_to_le32(sha->ct_dma);
-	cmd->ct_hdr = sha->ct_hdr;
-	cmd->tfm = cpu_to_le32(sha->tfm_dma);
+	cmd->ct = cpu_to_le32(ctx->ct_dma);
+	cmd->ct_hdr = ctx->ct_hdr;
+	cmd->tfm = cpu_to_le32(ctx->tfm_dma);
 
 	if (++ring->pos == MTK_DESC_NUM)
 		ring->pos = 0;
@@ -732,9 +732,8 @@ static int mtk_sha_handle_queue(struct mtk_cryp *cryp, u8 id,
 	ctx = ahash_request_ctx(req);
 
 	sha->req = req;
-	sha->info = &ctx->info;
 
-	mtk_sha_info_init(sha, ctx);
+	mtk_sha_info_init(ctx);
 
 	if (ctx->op == SHA_OP_UPDATE) {
 		err = mtk_sha_update_start(cryp, sha);
@@ -766,8 +765,8 @@ static void mtk_sha_unmap(struct mtk_cryp *cryp, struct mtk_sha_rec *sha)
 {
 	struct mtk_sha_reqctx *ctx = ahash_request_ctx(sha->req);
 
-	dma_unmap_single(cryp->dev, sha->ct_dma,
-			 sizeof(struct mtk_sha_info), DMA_BIDIRECTIONAL);
+	dma_unmap_single(cryp->dev, ctx->ct_dma, sizeof(ctx->info),
+			 DMA_BIDIRECTIONAL);
 
 	if (ctx->flags & SHA_FLAGS_SG) {
 		dma_unmap_sg(cryp->dev, ctx->sg, 1, DMA_TO_DEVICE);
-- 
1.9.1
