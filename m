From: Ryder Lee <ryder.lee@mediatek.com>
Subject: [PATCH v3 1/2] Add crypto driver support for some MediaTek chips
Date: Mon, 19 Dec 2016 10:20:44 +0800
Message-ID: <1482114045-18716-2-git-send-email-ryder.lee@mediatek.com>
References: <1482114045-18716-1-git-send-email-ryder.lee@mediatek.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <devicetree@vger.kernel.org>, <linux-mediatek@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Roy Luo <cheng-hao.luo@mediatek.com>,
        Ryder Lee <ryder.lee@mediatek.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Matthias Brugger <matthias.bgg@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1482114045-18716-1-git-send-email-ryder.lee@mediatek.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

This adds support for the MediaTek hardware accelerator on
mt7623/mt2701/mt8521p SoC.

This driver currently implement:
- SHA1 and SHA2 family(HMAC) hash algorithms.
- AES block cipher in CBC/ECB mode with 128/196/256 bits keys.

Signed-off-by: Ryder Lee <ryder.lee@mediatek.com>
---
 drivers/crypto/Kconfig                 |   17 +
 drivers/crypto/Makefile                |    1 +
 drivers/crypto/mediatek/Makefile       |    2 +
 drivers/crypto/mediatek/mtk-aes.c      |  765 +++++++++++++++++
 drivers/crypto/mediatek/mtk-platform.c |  604 ++++++++++++++
 drivers/crypto/mediatek/mtk-platform.h |  238 ++++++
 drivers/crypto/mediatek/mtk-regs.h     |  194 +++++
 drivers/crypto/mediatek/mtk-sha.c      | 1437 ++++++++++++++++++++++++++++++++
 8 files changed, 3258 insertions(+)
 create mode 100644 drivers/crypto/mediatek/Makefile
 create mode 100644 drivers/crypto/mediatek/mtk-aes.c
 create mode 100644 drivers/crypto/mediatek/mtk-platform.c
 create mode 100644 drivers/crypto/mediatek/mtk-platform.h
 create mode 100644 drivers/crypto/mediatek/mtk-regs.h
 create mode 100644 drivers/crypto/mediatek/mtk-sha.c

diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
index 4d2b81f..937039d 100644
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -553,6 +553,23 @@ config CRYPTO_DEV_ROCKCHIP
 	  This driver interfaces with the hardware crypto accelerator.
 	  Supporting cbc/ecb chainmode, and aes/des/des3_ede cipher mode.
 
+config CRYPTO_DEV_MEDIATEK
+	tristate "MediaTek's EIP97 Cryptographic Engine driver"
+	depends on ARM && (ARCH_MEDIATEK || COMPILE_TEST)
+	select NEON
+	select KERNEL_MODE_NEON
+	select ARM_CRYPTO
+	select CRYPTO_AES
+	select CRYPTO_BLKCIPHER
+	select CRYPTO_SHA1_ARM_NEON
+	select CRYPTO_SHA256_ARM
+	select CRYPTO_SHA512_ARM
+	select CRYPTO_HMAC
+	help
+	  This driver allows you to utilize the hardware crypto accelerator
+	  EIP97 which can be found on the MT7623 MT2701, MT8521p, etc ....
+	  Select this if you want to use it for AES/SHA1/SHA2 algorithms.
+
 source "drivers/crypto/chelsio/Kconfig"
 
 endif # CRYPTO_HW
diff --git a/drivers/crypto/Makefile b/drivers/crypto/Makefile
index ad7250f..272b51a 100644
--- a/drivers/crypto/Makefile
+++ b/drivers/crypto/Makefile
@@ -10,6 +10,7 @@ obj-$(CONFIG_CRYPTO_DEV_IMGTEC_HASH) += img-hash.o
 obj-$(CONFIG_CRYPTO_DEV_IXP4XX) += ixp4xx_crypto.o
 obj-$(CONFIG_CRYPTO_DEV_MV_CESA) += mv_cesa.o
 obj-$(CONFIG_CRYPTO_DEV_MARVELL_CESA) += marvell/
+obj-$(CONFIG_CRYPTO_DEV_MEDIATEK) += mediatek/
 obj-$(CONFIG_CRYPTO_DEV_MXS_DCP) += mxs-dcp.o
 obj-$(CONFIG_CRYPTO_DEV_NIAGARA2) += n2_crypto.o
 n2_crypto-y := n2_core.o n2_asm.o
diff --git a/drivers/crypto/mediatek/Makefile b/drivers/crypto/mediatek/Makefile
new file mode 100644
index 0000000..187be79
--- /dev/null
+++ b/drivers/crypto/mediatek/Makefile
@@ -0,0 +1,2 @@
+obj-$(CONFIG_CRYPTO_DEV_MEDIATEK) += mtk-crypto.o
+mtk-crypto-objs:= mtk-platform.o mtk-aes.o mtk-sha.o
diff --git a/drivers/crypto/mediatek/mtk-aes.c b/drivers/crypto/mediatek/mtk-aes.c
new file mode 100644
index 0000000..3271471
--- /dev/null
+++ b/drivers/crypto/mediatek/mtk-aes.c
@@ -0,0 +1,765 @@
+/*
+ * Cryptographic API.
+ *
+ * Driver for EIP97 AES acceleration.
+ *
+ * Copyright (c) 2016 Ryder Lee <ryder.lee@mediatek.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * Some ideas are from atmel-aes.c drivers.
+ */
+
+#include <crypto/aes.h>
+#include "mtk-platform.h"
+
+#define AES_QUEUE_SIZE		512
+#define AES_BUF_ORDER		2
+#define AES_BUF_SIZE		((PAGE_SIZE << AES_BUF_ORDER) \
+				& ~(AES_BLOCK_SIZE - 1))
+
+/* AES command token */
+#define AES_CT_SIZE_ECB		2
+#define AES_CT_SIZE_CBC		3
+#define AES_CT_CTRL_HDR		cpu_to_le32(0x00220000)
+#define AES_COMMAND0		cpu_to_le32(0x05000000)
+#define AES_COMMAND1		cpu_to_le32(0x2d060000)
+#define AES_COMMAND2		cpu_to_le32(0xe4a63806)
+
+/* AES transform information */
+#define AES_TFM_ECB		cpu_to_le32(0x0 << 0)
+#define AES_TFM_CBC		cpu_to_le32(0x1 << 0)
+#define AES_TFM_DECRYPT		cpu_to_le32(0x5 << 0)
+#define AES_TFM_ENCRYPT		cpu_to_le32(0x4 << 0)
+#define AES_TFM_SIZE(x)		cpu_to_le32((x) << 8)
+#define AES_TFM_128BITS		cpu_to_le32(0xb << 16)
+#define AES_TFM_192BITS		cpu_to_le32(0xd << 16)
+#define AES_TFM_256BITS		cpu_to_le32(0xf << 16)
+#define AES_TFM_FULL_IV		cpu_to_le32(0xf << 5)
+
+/* AES flags */
+#define AES_FLAGS_MODE_MSK	0x7
+#define AES_FLAGS_ECB		BIT(0)
+#define AES_FLAGS_CBC		BIT(1)
+#define AES_FLAGS_ENCRYPT	BIT(2)
+#define AES_FLAGS_BUSY		BIT(3)
+
+/**
+ * mtk_aes_ct is a set of hardware instructions(command token)
+ * that are used to control engine's processing flow of AES.
+ */
+struct mtk_aes_ct {
+	__le32 ct_ctrl0;
+	__le32 ct_ctrl1;
+	__le32 ct_ctrl2;
+};
+
+/**
+ * mtk_aes_tfm is used to define AES transform state
+ * and contains all keys and initial vectors.
+ */
+struct mtk_aes_tfm {
+	__le32 tfm_ctrl0;
+	__le32 tfm_ctrl1;
+	__le32 state[SIZE_IN_WORDS(AES_KEYSIZE_256 + AES_BLOCK_SIZE)];
+};
+
+/**
+ * mtk_aes_info consists of command token and transform state of AES,
+ * which should be encapsulated in command and result descriptors.
+ *
+ * The engine requires this information to do:
+ * - Commands decoding and control of the engine's data path.
+ * - Coordinating hardware data fetch and store operations.
+ * - Result token construction and output.
+ */
+struct mtk_aes_info {
+	struct mtk_aes_ct ct;
+	struct mtk_aes_tfm tfm;
+};
+
+struct mtk_aes_reqctx {
+	u64 mode;
+};
+
+struct mtk_aes_ctx {
+	struct mtk_cryp *cryp;
+	struct mtk_aes_info info;
+	u32 keylen;
+};
+
+struct mtk_aes_drv {
+	struct list_head dev_list;
+	/* Device list lock */
+	spinlock_t lock;
+};
+
+static struct mtk_aes_drv mtk_aes = {
+	.dev_list = LIST_HEAD_INIT(mtk_aes.dev_list),
+	.lock = __SPIN_LOCK_UNLOCKED(mtk_aes.lock),
+};
+
+static inline u32 mtk_aes_read(struct mtk_cryp *cryp, u32 offset)
+{
+	return readl_relaxed(cryp->base + offset);
+}
+
+static inline void mtk_aes_write(struct mtk_cryp *cryp,
+				 u32 offset, u32 value)
+{
+	writel_relaxed(value, cryp->base + offset);
+}
+
+static struct mtk_cryp *mtk_aes_find_dev(struct mtk_aes_ctx *ctx)
+{
+	struct mtk_cryp *cryp = NULL;
+	struct mtk_cryp *tmp;
+
+	spin_lock_bh(&mtk_aes.lock);
+	if (!ctx->cryp) {
+		list_for_each_entry(tmp, &mtk_aes.dev_list, aes_list) {
+			cryp = tmp;
+			break;
+		}
+		ctx->cryp = cryp;
+	} else {
+		cryp = ctx->cryp;
+	}
+	spin_unlock_bh(&mtk_aes.lock);
+
+	return cryp;
+}
+
+static inline size_t mtk_aes_padlen(size_t len)
+{
+	len &= AES_BLOCK_SIZE - 1;
+	return len ? AES_BLOCK_SIZE - len : 0;
+}
+
+static bool mtk_aes_check_aligned(struct scatterlist *sg, size_t len,
+				  struct mtk_aes_dma *dma)
+{
+	int nents;
+
+	if (!IS_ALIGNED(len, AES_BLOCK_SIZE))
+		return false;
+
+	for (nents = 0; sg; sg = sg_next(sg), ++nents) {
+		if (!IS_ALIGNED(sg->offset, sizeof(u32)))
+			return false;
+
+		if (len <= sg->length) {
+			if (!IS_ALIGNED(len, AES_BLOCK_SIZE))
+				return false;
+
+			dma->nents = nents + 1;
+			dma->remainder = sg->length - len;
+			sg->length = len;
+			return true;
+		}
+
+		if (!IS_ALIGNED(sg->length, AES_BLOCK_SIZE))
+			return false;
+
+		len -= sg->length;
+	}
+
+	return false;
+}
+
+/* Initialize and map transform information of AES */
+static int mtk_aes_info_map(struct mtk_cryp *cryp,
+			    struct mtk_aes_rec *aes,
+			    size_t len)
+{
+	struct mtk_aes_ctx *ctx = crypto_ablkcipher_ctx(
+			crypto_ablkcipher_reqtfm(aes->req));
+	struct mtk_aes_info *info = aes->info;
+	struct mtk_aes_ct *ct = &info->ct;
+	struct mtk_aes_tfm *tfm = &info->tfm;
+
+	aes->ct_hdr = AES_CT_CTRL_HDR | cpu_to_le32(len);
+
+	if (aes->flags & AES_FLAGS_ENCRYPT)
+		tfm->tfm_ctrl0 = AES_TFM_ENCRYPT;
+	else
+		tfm->tfm_ctrl0 = AES_TFM_DECRYPT;
+
+	if (ctx->keylen == SIZE_IN_WORDS(AES_KEYSIZE_128))
+		tfm->tfm_ctrl0 |= AES_TFM_128BITS;
+	else if (ctx->keylen == SIZE_IN_WORDS(AES_KEYSIZE_256))
+		tfm->tfm_ctrl0 |= AES_TFM_256BITS;
+	else if (ctx->keylen == SIZE_IN_WORDS(AES_KEYSIZE_192))
+		tfm->tfm_ctrl0 |= AES_TFM_192BITS;
+
+	ct->ct_ctrl0 = AES_COMMAND0 | cpu_to_le32(len);
+	ct->ct_ctrl1 = AES_COMMAND1;
+
+	if (aes->flags & AES_FLAGS_CBC) {
+		const u32 *iv = (const u32 *)aes->req->info;
+		u32 *iv_state = tfm->state + ctx->keylen;
+		int i;
+
+		aes->ct_size = AES_CT_SIZE_CBC;
+		ct->ct_ctrl2 = AES_COMMAND2;
+
+		tfm->tfm_ctrl0 |= AES_TFM_SIZE(ctx->keylen +
+				  SIZE_IN_WORDS(AES_BLOCK_SIZE));
+		tfm->tfm_ctrl1 = AES_TFM_CBC | AES_TFM_FULL_IV;
+
+		for (i = 0; i < SIZE_IN_WORDS(AES_BLOCK_SIZE); i++)
+			iv_state[i] = cpu_to_le32(iv[i]);
+
+	} else if (aes->flags & AES_FLAGS_ECB) {
+		aes->ct_size = AES_CT_SIZE_ECB;
+		tfm->tfm_ctrl0 |= AES_TFM_SIZE(ctx->keylen);
+		tfm->tfm_ctrl1 = AES_TFM_ECB;
+	}
+
+	aes->ct_dma = dma_map_single(cryp->dev, info, sizeof(*info),
+					DMA_TO_DEVICE);
+	if (unlikely(dma_mapping_error(cryp->dev, aes->ct_dma))) {
+		dev_err(cryp->dev, "dma %d bytes error\n", sizeof(*info));
+		return -EINVAL;
+	}
+	aes->tfm_dma = aes->ct_dma + sizeof(*ct);
+
+	return 0;
+}
+
+static int mtk_aes_xmit(struct mtk_cryp *cryp, struct mtk_aes_rec *aes)
+{
+	struct mtk_ring *ring = cryp->ring[aes->id];
+	struct mtk_desc *cmd = NULL, *res = NULL;
+	struct scatterlist *ssg, *dsg;
+	u32 len = aes->src.sg_len;
+	int nents;
+
+	/* Fill in the command/result descriptors */
+	for (nents = 0; nents < len; ++nents) {
+		ssg = &aes->src.sg[nents];
+		dsg = &aes->dst.sg[nents];
+
+		cmd = ring->cmd_base + ring->pos;
+		cmd->hdr = MTK_DESC_BUF_LEN(ssg->length);
+		cmd->buf = cpu_to_le32(sg_dma_address(ssg));
+
+		res = ring->res_base + ring->pos;
+		res->hdr = MTK_DESC_BUF_LEN(dsg->length);
+		res->buf = cpu_to_le32(sg_dma_address(dsg));
+
+		if (nents == 0) {
+			res->hdr |= MTK_DESC_FIRST;
+			cmd->hdr |= MTK_DESC_FIRST |
+				    MTK_DESC_CT_LEN(aes->ct_size);
+			cmd->ct = cpu_to_le32(aes->ct_dma);
+			cmd->ct_hdr = aes->ct_hdr;
+			cmd->tfm = cpu_to_le32(aes->tfm_dma);
+		}
+
+		if (++ring->pos == MTK_DESC_NUM)
+			ring->pos = 0;
+	}
+
+	cmd->hdr |= MTK_DESC_LAST;
+	res->hdr |= MTK_DESC_LAST;
+
+	/*
+	 * Make sure that all changes to the DMA ring are done before we
+	 * start engine.
+	 */
+	wmb();
+	/* Start DMA transfer */
+	mtk_aes_write(cryp, RDR_PREP_COUNT(aes->id), MTK_DESC_CNT(len));
+	mtk_aes_write(cryp, CDR_PREP_COUNT(aes->id), MTK_DESC_CNT(len));
+
+	return -EINPROGRESS;
+}
+
+static inline void mtk_aes_restore_sg(const struct mtk_aes_dma *dma)
+{
+	struct scatterlist *sg = dma->sg;
+	int nents = dma->nents;
+
+	if (!dma->remainder)
+		return;
+
+	while (--nents > 0 && sg)
+		sg = sg_next(sg);
+
+	if (!sg)
+		return;
+
+	sg->length += dma->remainder;
+}
+
+static int mtk_aes_map(struct mtk_cryp *cryp, struct mtk_aes_rec *aes)
+{
+	struct scatterlist *src = aes->req->src;
+	struct scatterlist *dst = aes->req->dst;
+	size_t len = aes->req->nbytes;
+	size_t padlen = 0;
+	bool src_aligned, dst_aligned;
+
+	aes->total = len;
+	aes->src.sg = src;
+	aes->dst.sg = dst;
+	aes->real_dst = dst;
+
+	src_aligned = mtk_aes_check_aligned(src, len, &aes->src);
+	if (src == dst)
+		dst_aligned = src_aligned;
+	else
+		dst_aligned = mtk_aes_check_aligned(dst, len, &aes->dst);
+
+	if (!src_aligned || !dst_aligned) {
+		padlen = mtk_aes_padlen(len);
+
+		if (len + padlen > AES_BUF_SIZE)
+			return -ENOMEM;
+
+		if (!src_aligned) {
+			sg_copy_to_buffer(src, sg_nents(src), aes->buf, len);
+			aes->src.sg = &aes->aligned_sg;
+			aes->src.nents = 1;
+			aes->src.remainder = 0;
+		}
+
+		if (!dst_aligned) {
+			aes->dst.sg = &aes->aligned_sg;
+			aes->dst.nents = 1;
+			aes->dst.remainder = 0;
+		}
+
+		sg_init_table(&aes->aligned_sg, 1);
+		sg_set_buf(&aes->aligned_sg, aes->buf, len + padlen);
+	}
+
+	if (aes->src.sg == aes->dst.sg) {
+		aes->src.sg_len = dma_map_sg(cryp->dev, aes->src.sg,
+				aes->src.nents, DMA_BIDIRECTIONAL);
+		aes->dst.sg_len = aes->src.sg_len;
+		if (unlikely(!aes->src.sg_len))
+			return -EFAULT;
+	} else {
+		aes->src.sg_len = dma_map_sg(cryp->dev, aes->src.sg,
+				aes->src.nents, DMA_TO_DEVICE);
+		if (unlikely(!aes->src.sg_len))
+			return -EFAULT;
+
+		aes->dst.sg_len = dma_map_sg(cryp->dev, aes->dst.sg,
+				aes->dst.nents, DMA_FROM_DEVICE);
+		if (unlikely(!aes->dst.sg_len)) {
+			dma_unmap_sg(cryp->dev, aes->src.sg,
+				     aes->src.nents, DMA_TO_DEVICE);
+			return -EFAULT;
+		}
+	}
+
+	return mtk_aes_info_map(cryp, aes, len + padlen);
+}
+
+static int mtk_aes_handle_queue(struct mtk_cryp *cryp, u8 id,
+				struct ablkcipher_request *req)
+{
+	struct mtk_aes_rec *aes = cryp->aes[id];
+	struct crypto_async_request *areq, *backlog;
+	struct mtk_aes_reqctx *rctx;
+	struct mtk_aes_ctx *ctx;
+	unsigned long flags;
+	int err, ret = 0;
+
+	spin_lock_irqsave(&aes->lock, flags);
+	if (req)
+		ret = ablkcipher_enqueue_request(&aes->queue, req);
+	if (aes->flags & AES_FLAGS_BUSY) {
+		spin_unlock_irqrestore(&aes->lock, flags);
+		return ret;
+	}
+	backlog = crypto_get_backlog(&aes->queue);
+	areq = crypto_dequeue_request(&aes->queue);
+	if (areq)
+		aes->flags |= AES_FLAGS_BUSY;
+	spin_unlock_irqrestore(&aes->lock, flags);
+
+	if (!areq)
+		return ret;
+
+	if (backlog)
+		backlog->complete(backlog, -EINPROGRESS);
+
+	req = ablkcipher_request_cast(areq);
+	ctx = crypto_ablkcipher_ctx(crypto_ablkcipher_reqtfm(req));
+	rctx = ablkcipher_request_ctx(req);
+	rctx->mode &= AES_FLAGS_MODE_MSK;
+	/* Assign new request to device */
+	aes->req = req;
+	aes->info = &ctx->info;
+	aes->flags = (aes->flags & ~AES_FLAGS_MODE_MSK) | rctx->mode;
+
+	err = mtk_aes_map(cryp, aes);
+	if (err)
+		return err;
+
+	return mtk_aes_xmit(cryp, aes);
+}
+
+static void mtk_aes_unmap(struct mtk_cryp *cryp, struct mtk_aes_rec *aes)
+{
+	dma_unmap_single(cryp->dev, aes->ct_dma,
+			 sizeof(struct mtk_aes_info), DMA_TO_DEVICE);
+
+	if (aes->src.sg == aes->dst.sg) {
+		dma_unmap_sg(cryp->dev, aes->src.sg,
+			     aes->src.nents, DMA_BIDIRECTIONAL);
+
+		if (aes->src.sg != &aes->aligned_sg)
+			mtk_aes_restore_sg(&aes->src);
+	} else {
+		dma_unmap_sg(cryp->dev, aes->dst.sg,
+			     aes->dst.nents, DMA_FROM_DEVICE);
+
+		if (aes->dst.sg != &aes->aligned_sg)
+			mtk_aes_restore_sg(&aes->dst);
+
+		dma_unmap_sg(cryp->dev, aes->src.sg,
+			     aes->src.nents, DMA_TO_DEVICE);
+
+		if (aes->src.sg != &aes->aligned_sg)
+			mtk_aes_restore_sg(&aes->src);
+	}
+
+	if (aes->dst.sg == &aes->aligned_sg)
+		sg_copy_from_buffer(aes->real_dst,
+				    sg_nents(aes->real_dst),
+				    aes->buf, aes->total);
+}
+
+static inline void mtk_aes_complete(struct mtk_cryp *cryp,
+				    struct mtk_aes_rec *aes)
+{
+	aes->flags &= ~AES_FLAGS_BUSY;
+
+	aes->req->base.complete(&aes->req->base, 0);
+
+	/* Handle new request */
+	mtk_aes_handle_queue(cryp, aes->id, NULL);
+}
+
+/* Check and set the AES key to transform state buffer */
+static int mtk_aes_setkey(struct crypto_ablkcipher *tfm,
+			  const u8 *key, u32 keylen)
+{
+	struct mtk_aes_ctx *ctx = crypto_ablkcipher_ctx(tfm);
+	const u32 *key_tmp = (const u32 *)key;
+	u32 *key_state = ctx->info.tfm.state;
+	int i;
+
+	if (keylen != AES_KEYSIZE_128 &&
+	    keylen != AES_KEYSIZE_192 &&
+	    keylen != AES_KEYSIZE_256) {
+		crypto_ablkcipher_set_flags(tfm, CRYPTO_TFM_RES_BAD_KEY_LEN);
+		return -EINVAL;
+	}
+
+	ctx->keylen = SIZE_IN_WORDS(keylen);
+
+	for (i = 0; i < ctx->keylen; i++)
+		key_state[i] = cpu_to_le32(key_tmp[i]);
+
+	return 0;
+}
+
+static int mtk_aes_crypt(struct ablkcipher_request *req, u64 mode)
+{
+	struct mtk_aes_ctx *ctx = crypto_ablkcipher_ctx(
+			crypto_ablkcipher_reqtfm(req));
+	struct mtk_aes_reqctx *rctx = ablkcipher_request_ctx(req);
+
+	rctx->mode = mode;
+
+	return mtk_aes_handle_queue(ctx->cryp,
+			!(mode & AES_FLAGS_ENCRYPT), req);
+}
+
+static int mtk_ecb_encrypt(struct ablkcipher_request *req)
+{
+	return mtk_aes_crypt(req, AES_FLAGS_ENCRYPT | AES_FLAGS_ECB);
+}
+
+static int mtk_ecb_decrypt(struct ablkcipher_request *req)
+{
+	return mtk_aes_crypt(req, AES_FLAGS_ECB);
+}
+
+static int mtk_cbc_encrypt(struct ablkcipher_request *req)
+{
+	return mtk_aes_crypt(req, AES_FLAGS_ENCRYPT | AES_FLAGS_CBC);
+}
+
+static int mtk_cbc_decrypt(struct ablkcipher_request *req)
+{
+	return mtk_aes_crypt(req, AES_FLAGS_CBC);
+}
+
+static int mtk_aes_cra_init(struct crypto_tfm *tfm)
+{
+	struct mtk_aes_ctx *ctx = crypto_tfm_ctx(tfm);
+	struct mtk_cryp *cryp = NULL;
+
+	tfm->crt_ablkcipher.reqsize = sizeof(struct mtk_aes_reqctx);
+
+	cryp = mtk_aes_find_dev(ctx);
+	if (!cryp) {
+		pr_err("can't find crypto device\n");
+		return -ENODEV;
+	}
+
+	return 0;
+}
+
+static struct crypto_alg aes_algs[] = {
+{
+	.cra_name		=	"cbc(aes)",
+	.cra_driver_name	=	"cbc-aes-mtk",
+	.cra_priority		=	400,
+	.cra_flags		=	CRYPTO_ALG_TYPE_ABLKCIPHER |
+						CRYPTO_ALG_ASYNC,
+	.cra_init		=	mtk_aes_cra_init,
+	.cra_blocksize		=	AES_BLOCK_SIZE,
+	.cra_ctxsize		=	sizeof(struct mtk_aes_ctx),
+	.cra_alignmask		=	15,
+	.cra_type		=	&crypto_ablkcipher_type,
+	.cra_module		=	THIS_MODULE,
+	.cra_u.ablkcipher	=	{
+		.min_keysize	=	AES_MIN_KEY_SIZE,
+		.max_keysize	=	AES_MAX_KEY_SIZE,
+		.setkey		=	mtk_aes_setkey,
+		.encrypt	=	mtk_cbc_encrypt,
+		.decrypt	=	mtk_cbc_decrypt,
+		.ivsize		=	AES_BLOCK_SIZE,
+	}
+},
+{
+	.cra_name		=	"ecb(aes)",
+	.cra_driver_name	=	"ecb-aes-mtk",
+	.cra_priority		=	400,
+	.cra_flags		=	CRYPTO_ALG_TYPE_ABLKCIPHER |
+						CRYPTO_ALG_ASYNC,
+	.cra_init		=	mtk_aes_cra_init,
+	.cra_blocksize		=	AES_BLOCK_SIZE,
+	.cra_ctxsize		=	sizeof(struct mtk_aes_ctx),
+	.cra_alignmask		=	15,
+	.cra_type		=	&crypto_ablkcipher_type,
+	.cra_module		=	THIS_MODULE,
+	.cra_u.ablkcipher	=	{
+		.min_keysize	=	AES_MIN_KEY_SIZE,
+		.max_keysize	=	AES_MAX_KEY_SIZE,
+		.setkey		=	mtk_aes_setkey,
+		.encrypt	=	mtk_ecb_encrypt,
+		.decrypt	=	mtk_ecb_decrypt,
+	}
+},
+};
+
+static void mtk_aes_enc_task(unsigned long data)
+{
+	struct mtk_cryp *cryp = (struct mtk_cryp *)data;
+	struct mtk_aes_rec *aes = cryp->aes[0];
+
+	mtk_aes_unmap(cryp, aes);
+	mtk_aes_complete(cryp, aes);
+}
+
+static void mtk_aes_dec_task(unsigned long data)
+{
+	struct mtk_cryp *cryp = (struct mtk_cryp *)data;
+	struct mtk_aes_rec *aes = cryp->aes[1];
+
+	mtk_aes_unmap(cryp, aes);
+	mtk_aes_complete(cryp, aes);
+}
+
+static irqreturn_t mtk_aes_enc_irq(int irq, void *dev_id)
+{
+	struct mtk_cryp *cryp = (struct mtk_cryp *)dev_id;
+	struct mtk_aes_rec *aes = cryp->aes[0];
+	u32 val = mtk_aes_read(cryp, RDR_STAT(RING0));
+
+	mtk_aes_write(cryp, RDR_STAT(RING0), val);
+
+	if (likely(AES_FLAGS_BUSY & aes->flags)) {
+		mtk_aes_write(cryp, RDR_PROC_COUNT(RING0), MTK_CNT_RST);
+		mtk_aes_write(cryp, RDR_THRESH(RING0),
+			      MTK_RDR_PROC_THRESH | MTK_RDR_PROC_MODE);
+
+		tasklet_schedule(&aes->task);
+	} else {
+		dev_warn(cryp->dev, "AES interrupt when no active requests.\n");
+	}
+	return IRQ_HANDLED;
+}
+
+static irqreturn_t mtk_aes_dec_irq(int irq, void *dev_id)
+{
+	struct mtk_cryp *cryp = (struct mtk_cryp *)dev_id;
+	struct mtk_aes_rec *aes = cryp->aes[1];
+	u32 val = mtk_aes_read(cryp, RDR_STAT(RING1));
+
+	mtk_aes_write(cryp, RDR_STAT(RING1), val);
+
+	if (likely(AES_FLAGS_BUSY & aes->flags)) {
+		mtk_aes_write(cryp, RDR_PROC_COUNT(RING1), MTK_CNT_RST);
+		mtk_aes_write(cryp, RDR_THRESH(RING1),
+			      MTK_RDR_PROC_THRESH | MTK_RDR_PROC_MODE);
+
+		tasklet_schedule(&aes->task);
+	} else {
+		dev_warn(cryp->dev, "AES interrupt when no active requests.\n");
+	}
+	return IRQ_HANDLED;
+}
+
+/*
+ * The purpose of creating encryption and decryption records is
+ * to process outbound/inbound data in parallel, it can improve
+ * performance in most use cases, such as IPSec VPN, especially
+ * under heavy network traffic.
+ */
+static int mtk_aes_record_init(struct mtk_cryp *cryp)
+{
+	struct mtk_aes_rec **aes = cryp->aes;
+	int i, err = -ENOMEM;
+
+	for (i = 0; i < MTK_REC_NUM; i++) {
+		aes[i] = kzalloc(sizeof(**aes), GFP_KERNEL);
+		if (!aes[i])
+			goto err_cleanup;
+
+		aes[i]->buf = (void *)__get_free_pages(GFP_KERNEL,
+						AES_BUF_ORDER);
+		if (!aes[i]->buf)
+			goto err_cleanup;
+
+		aes[i]->id = i;
+
+		spin_lock_init(&aes[i]->lock);
+		crypto_init_queue(&aes[i]->queue, AES_QUEUE_SIZE);
+	}
+
+	tasklet_init(&aes[0]->task, mtk_aes_enc_task, (unsigned long)cryp);
+	tasklet_init(&aes[1]->task, mtk_aes_dec_task, (unsigned long)cryp);
+
+	return 0;
+
+err_cleanup:
+	for (; i--; ) {
+		free_page((unsigned long)aes[i]->buf);
+		kfree(aes[i]);
+	}
+
+	return err;
+}
+
+static void mtk_aes_record_free(struct mtk_cryp *cryp)
+{
+	int i;
+
+	for (i = 0; i < MTK_REC_NUM; i++) {
+		tasklet_kill(&cryp->aes[i]->task);
+		free_page((unsigned long)cryp->aes[i]->buf);
+		kfree(cryp->aes[i]);
+	}
+}
+
+static void mtk_aes_unregister_algs(void)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(aes_algs); i++)
+		crypto_unregister_alg(&aes_algs[i]);
+}
+
+static int mtk_aes_register_algs(void)
+{
+	int err, i;
+
+	for (i = 0; i < ARRAY_SIZE(aes_algs); i++) {
+		err = crypto_register_alg(&aes_algs[i]);
+		if (err)
+			goto err_aes_algs;
+	}
+
+	return 0;
+
+err_aes_algs:
+	for (; i--; )
+		crypto_unregister_alg(&aes_algs[i]);
+
+	return err;
+}
+
+int mtk_cipher_alg_register(struct mtk_cryp *cryp)
+{
+	int ret;
+
+	INIT_LIST_HEAD(&cryp->aes_list);
+
+	/* Initialize two cipher records */
+	ret = mtk_aes_record_init(cryp);
+	if (ret)
+		goto err_record;
+
+	/* Ring0 is use by encryption record */
+	ret = devm_request_irq(cryp->dev, cryp->irq[RING0], mtk_aes_enc_irq,
+			       IRQF_TRIGGER_LOW, "mtk-aes", cryp);
+	if (ret) {
+		dev_err(cryp->dev, "unable to request AES encryption irq.\n");
+		goto err_res;
+	}
+
+	/* Ring1 is use by decryption record */
+	ret = devm_request_irq(cryp->dev, cryp->irq[RING1], mtk_aes_dec_irq,
+			       IRQF_TRIGGER_LOW, "mtk-aes", cryp);
+	if (ret) {
+		dev_err(cryp->dev, "unable to request AES decryption irq.\n");
+		goto err_res;
+	}
+
+	/* Enable ring0 and ring1 interrupt */
+	mtk_aes_write(cryp, AIC_ENABLE_SET(RING0), MTK_IRQ_RDR0);
+	mtk_aes_write(cryp, AIC_ENABLE_SET(RING1), MTK_IRQ_RDR1);
+
+	spin_lock(&mtk_aes.lock);
+	list_add_tail(&cryp->aes_list, &mtk_aes.dev_list);
+	spin_unlock(&mtk_aes.lock);
+
+	ret = mtk_aes_register_algs();
+	if (ret)
+		goto err_algs;
+
+	return 0;
+
+err_algs:
+	spin_lock(&mtk_aes.lock);
+	list_del(&cryp->aes_list);
+	spin_unlock(&mtk_aes.lock);
+err_res:
+	mtk_aes_record_free(cryp);
+err_record:
+
+	dev_err(cryp->dev, "mtk-aes initialization failed.\n");
+	return ret;
+}
+
+void mtk_cipher_alg_release(struct mtk_cryp *cryp)
+{
+	spin_lock(&mtk_aes.lock);
+	list_del(&cryp->aes_list);
+	spin_unlock(&mtk_aes.lock);
+
+	mtk_aes_unregister_algs();
+	mtk_aes_record_free(cryp);
+}
diff --git a/drivers/crypto/mediatek/mtk-platform.c b/drivers/crypto/mediatek/mtk-platform.c
new file mode 100644
index 0000000..286296f
--- /dev/null
+++ b/drivers/crypto/mediatek/mtk-platform.c
@@ -0,0 +1,604 @@
+/*
+ * Driver for EIP97 cryptographic accelerator.
+ *
+ * Copyright (c) 2016 Ryder Lee <ryder.lee@mediatek.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ */
+
+#include <linux/clk.h>
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/pm_runtime.h>
+#include "mtk-platform.h"
+
+#define MTK_BURST_SIZE_MSK		GENMASK(7, 4)
+#define MTK_BURST_SIZE(x)		((x) << 4)
+#define MTK_DESC_SIZE(x)		((x) << 0)
+#define MTK_DESC_OFFSET(x)		((x) << 16)
+#define MTK_DESC_FETCH_SIZE(x)		((x) << 0)
+#define MTK_DESC_FETCH_THRESH(x)	((x) << 16)
+#define MTK_DESC_OVL_IRQ_EN		BIT(25)
+#define MTK_DESC_ATP_PRESENT		BIT(30)
+
+#define MTK_DFSE_IDLE			GENMASK(3, 0)
+#define MTK_DFSE_THR_CTRL_EN		BIT(30)
+#define MTK_DFSE_THR_CTRL_RESET		BIT(31)
+#define MTK_DFSE_RING_ID(x)		(((x) >> 12) & GENMASK(3, 0))
+#define MTK_DFSE_MIN_DATA(x)		((x) << 0)
+#define MTK_DFSE_MAX_DATA(x)		((x) << 8)
+#define MTK_DFE_MIN_CTRL(x)		((x) << 16)
+#define MTK_DFE_MAX_CTRL(x)		((x) << 24)
+
+#define MTK_IN_BUF_MIN_THRESH(x)	((x) << 8)
+#define MTK_IN_BUF_MAX_THRESH(x)	((x) << 12)
+#define MTK_OUT_BUF_MIN_THRESH(x)	((x) << 0)
+#define MTK_OUT_BUF_MAX_THRESH(x)	((x) << 4)
+#define MTK_IN_TBUF_SIZE(x)		(((x) >> 4) & GENMASK(3, 0))
+#define MTK_IN_DBUF_SIZE(x)		(((x) >> 8) & GENMASK(3, 0))
+#define MTK_OUT_DBUF_SIZE(x)		(((x) >> 16) & GENMASK(3, 0))
+#define MTK_CMD_FIFO_SIZE(x)		(((x) >> 8) & GENMASK(3, 0))
+#define MTK_RES_FIFO_SIZE(x)		(((x) >> 12) & GENMASK(3, 0))
+
+#define MTK_PE_TK_LOC_AVL		BIT(2)
+#define MTK_PE_PROC_HELD		BIT(14)
+#define MTK_PE_TK_TIMEOUT_EN		BIT(22)
+#define MTK_PE_INPUT_DMA_ERR		BIT(0)
+#define MTK_PE_OUTPUT_DMA_ERR		BIT(1)
+#define MTK_PE_PKT_PORC_ERR		BIT(2)
+#define MTK_PE_PKT_TIMEOUT		BIT(3)
+#define MTK_PE_FATAL_ERR		BIT(14)
+#define MTK_PE_INPUT_DMA_ERR_EN		BIT(16)
+#define MTK_PE_OUTPUT_DMA_ERR_EN	BIT(17)
+#define MTK_PE_PKT_PORC_ERR_EN		BIT(18)
+#define MTK_PE_PKT_TIMEOUT_EN		BIT(19)
+#define MTK_PE_FATAL_ERR_EN		BIT(30)
+#define MTK_PE_INT_OUT_EN		BIT(31)
+
+#define MTK_HIA_SIGNATURE		((u16)0x35ca)
+#define MTK_HIA_DATA_WIDTH(x)		(((x) >> 25) & GENMASK(1, 0))
+#define MTK_HIA_DMA_LENGTH(x)		(((x) >> 20) & GENMASK(4, 0))
+#define MTK_CDR_STAT_CLR		GENMASK(4, 0)
+#define MTK_RDR_STAT_CLR		GENMASK(7, 0)
+
+#define MTK_AIC_INT_MSK			GENMASK(5, 0)
+#define MTK_AIC_VER_MSK			(GENMASK(15, 0) | GENMASK(27, 20))
+#define MTK_AIC_VER11			0x011036c9
+#define MTK_AIC_VER12			0x012036c9
+#define MTK_AIC_G_CLR			GENMASK(30, 20)
+
+/**
+ * EIP97 is an integrated security subsystem to accelerate cryptographic
+ * functions and protocols to offload the host processor.
+ * Some important hardware modules are briefly introduced below:
+ *
+ * Host Interface Adapter(HIA) - the main interface between the host
+ * system and the hardware subsystem. It is responsible for attaching
+ * processing engine to the specific host bus interface and provides a
+ * standardized software view for off loading tasks to the engine.
+ *
+ * Command Descriptor Ring Manager(CDR Manager) - keeps track of how many
+ * CD the host has prepared in the CDR. It monitors the fill level of its
+ * CD-FIFO and if there's sufficient space for the next block of descriptors,
+ * then it fires off a DMA request to fetch a block of CDs.
+ *
+ * Data fetch engine(DFE) - It is responsible for parsing the CD and
+ * setting up the required control and packet data DMA transfers from
+ * system memory to the processing engine.
+ *
+ * Result Descriptor Ring Manager(RDR Manager) - same as CDR Manager,
+ * but target is result descriptors, Moreover, it also handles the RD
+ * updates under control of the DSE. For each packet data segment
+ * processed, the DSE triggers the RDR Manager to write the updated RD.
+ * If triggered to update, the RDR Manager sets up a DMA operation to
+ * copy the RD from the DSE to the correct location in the RDR.
+ *
+ * Data Store Engine(DSE) - It is responsible for parsing the prepared RD
+ * and setting up the required control and packet data DMA transfers from
+ * the processing engine to system memory.
+ *
+ * Advanced Interrupt Controllers(AICs) - receive interrupt request signals
+ * from various sources and combine them into one interrupt output.
+ * The AICs are used by:
+ * - One for the HIA global and processing engine interrupts.
+ * - The others for the descriptor ring interrupts.
+ */
+
+/* Cryptographic engine capabilities */
+struct mtk_sys_cap {
+	/* host interface adapter */
+	u32 hia_ver;
+	u32 hia_opt;
+	/* packet engine */
+	u32 pkt_eng_opt;
+	/* global hardware */
+	u32 hw_opt;
+};
+
+static void mtk_desc_ring_link(struct mtk_cryp *cryp, u32 mask)
+{
+	/* Assign rings to DFE/DSE thread and enable it */
+	writel(MTK_DFSE_THR_CTRL_EN | mask, cryp->base + DFE_THR_CTRL);
+	writel(MTK_DFSE_THR_CTRL_EN | mask, cryp->base + DSE_THR_CTRL);
+}
+
+static void mtk_dfe_dse_buf_setup(struct mtk_cryp *cryp,
+				  struct mtk_sys_cap *cap)
+{
+	u32 width = MTK_HIA_DATA_WIDTH(cap->hia_opt) + 2;
+	u32 len = MTK_HIA_DMA_LENGTH(cap->hia_opt) - 1;
+	u32 ipbuf = min((u32)MTK_IN_DBUF_SIZE(cap->hw_opt) + width, len);
+	u32 opbuf = min((u32)MTK_OUT_DBUF_SIZE(cap->hw_opt) + width, len);
+	u32 itbuf = min((u32)MTK_IN_TBUF_SIZE(cap->hw_opt) + width, len);
+
+	writel(MTK_DFSE_MIN_DATA(ipbuf - 1) |
+	       MTK_DFSE_MAX_DATA(ipbuf) |
+	       MTK_DFE_MIN_CTRL(itbuf - 1) |
+	       MTK_DFE_MAX_CTRL(itbuf),
+	       cryp->base + DFE_CFG);
+
+	writel(MTK_DFSE_MIN_DATA(opbuf - 1) |
+	       MTK_DFSE_MAX_DATA(opbuf),
+	       cryp->base + DSE_CFG);
+
+	writel(MTK_IN_BUF_MIN_THRESH(ipbuf - 1) |
+	       MTK_IN_BUF_MAX_THRESH(ipbuf),
+	       cryp->base + PE_IN_DBUF_THRESH);
+
+	writel(MTK_IN_BUF_MIN_THRESH(itbuf - 1) |
+	       MTK_IN_BUF_MAX_THRESH(itbuf),
+	       cryp->base + PE_IN_TBUF_THRESH);
+
+	writel(MTK_OUT_BUF_MIN_THRESH(opbuf - 1) |
+	       MTK_OUT_BUF_MAX_THRESH(opbuf),
+	       cryp->base + PE_OUT_DBUF_THRESH);
+
+	writel(0, cryp->base + PE_OUT_TBUF_THRESH);
+	writel(0, cryp->base + PE_OUT_BUF_CTRL);
+}
+
+static int mtk_dfe_dse_state_check(struct mtk_cryp *cryp)
+{
+	int ret = -EINVAL;
+	u32 val;
+
+	/* Check for completion of all DMA transfers */
+	val = readl(cryp->base + DFE_THR_STAT);
+	if (MTK_DFSE_RING_ID(val) == MTK_DFSE_IDLE) {
+		val = readl(cryp->base + DSE_THR_STAT);
+		if (MTK_DFSE_RING_ID(val) == MTK_DFSE_IDLE)
+			ret = 0;
+	}
+
+	if (!ret) {
+		/* Take DFE/DSE thread out of reset */
+		writel(0, cryp->base + DFE_THR_CTRL);
+		writel(0, cryp->base + DSE_THR_CTRL);
+	} else {
+		return -EBUSY;
+	}
+
+	return 0;
+}
+
+static int mtk_dfe_dse_reset(struct mtk_cryp *cryp)
+{
+	int err;
+
+	/* Reset DSE/DFE and correct system priorities for all rings. */
+	writel(MTK_DFSE_THR_CTRL_RESET, cryp->base + DFE_THR_CTRL);
+	writel(0, cryp->base + DFE_PRIO_0);
+	writel(0, cryp->base + DFE_PRIO_1);
+	writel(0, cryp->base + DFE_PRIO_2);
+	writel(0, cryp->base + DFE_PRIO_3);
+
+	writel(MTK_DFSE_THR_CTRL_RESET, cryp->base + DSE_THR_CTRL);
+	writel(0, cryp->base + DSE_PRIO_0);
+	writel(0, cryp->base + DSE_PRIO_1);
+	writel(0, cryp->base + DSE_PRIO_2);
+	writel(0, cryp->base + DSE_PRIO_3);
+
+	err = mtk_dfe_dse_state_check(cryp);
+	if (err)
+		return err;
+
+	return 0;
+}
+
+static void mtk_cmd_desc_ring_setup(struct mtk_cryp *cryp,
+				    int i, struct mtk_sys_cap *cap)
+{
+	/* Full descriptor that fits FIFO minus one */
+	u32 count =
+		((1 << MTK_CMD_FIFO_SIZE(cap->hia_opt)) / MTK_DESC_SZ) - 1;
+
+	/* Temporarily disable external triggering */
+	writel(0, cryp->base + CDR_CFG(i));
+
+	/* Clear CDR count */
+	writel(MTK_CNT_RST, cryp->base + CDR_PREP_COUNT(i));
+	writel(MTK_CNT_RST, cryp->base + CDR_PROC_COUNT(i));
+
+	writel(0, cryp->base + CDR_PREP_PNTR(i));
+	writel(0, cryp->base + CDR_PROC_PNTR(i));
+	writel(0, cryp->base + CDR_DMA_CFG(i));
+
+	/* Configure CDR host address space */
+	writel(0, cryp->base + CDR_BASE_ADDR_HI(i));
+	writel(cryp->ring[i]->cmd_dma, cryp->base + CDR_BASE_ADDR_LO(i));
+
+	writel(MTK_DESC_RING_SZ, cryp->base + CDR_RING_SIZE(i));
+
+	/* Clear and disable all CDR interrupts */
+	writel(MTK_CDR_STAT_CLR, cryp->base + CDR_STAT(i));
+
+	/*
+	 * Set command descriptor offset and enable additional
+	 * token present in descriptor.
+	 */
+	writel(MTK_DESC_SIZE(MTK_DESC_SZ) |
+		   MTK_DESC_OFFSET(MTK_DESC_OFF) |
+	       MTK_DESC_ATP_PRESENT,
+	       cryp->base + CDR_DESC_SIZE(i));
+
+	writel(MTK_DESC_FETCH_SIZE(count * MTK_DESC_OFF) |
+		   MTK_DESC_FETCH_THRESH(count * MTK_DESC_SZ),
+		   cryp->base + CDR_CFG(i));
+}
+
+static void mtk_res_desc_ring_setup(struct mtk_cryp *cryp,
+				    int i, struct mtk_sys_cap *cap)
+{
+	u32 rndup = 2;
+	u32 count = ((1 << MTK_RES_FIFO_SIZE(cap->hia_opt)) / rndup) - 1;
+
+	/* Temporarily disable external triggering */
+	writel(0, cryp->base + RDR_CFG(i));
+
+	/* Clear RDR count */
+	writel(MTK_CNT_RST, cryp->base + RDR_PREP_COUNT(i));
+	writel(MTK_CNT_RST, cryp->base + RDR_PROC_COUNT(i));
+
+	writel(0, cryp->base + RDR_PREP_PNTR(i));
+	writel(0, cryp->base + RDR_PROC_PNTR(i));
+	writel(0, cryp->base + RDR_DMA_CFG(i));
+
+	/* Configure RDR host address space */
+	writel(0, cryp->base + RDR_BASE_ADDR_HI(i));
+	writel(cryp->ring[i]->res_dma, cryp->base + RDR_BASE_ADDR_LO(i));
+
+	writel(MTK_DESC_RING_SZ, cryp->base + RDR_RING_SIZE(i));
+	writel(MTK_RDR_STAT_CLR, cryp->base + RDR_STAT(i));
+
+	/*
+	 * RDR manager generates update interrupts on a per-completed-packet,
+	 * and the rd_proc_thresh_irq interrupt is fired when proc_pkt_count
+	 * for the RDR exceeds the number of packets.
+	 */
+	writel(MTK_RDR_PROC_THRESH | MTK_RDR_PROC_MODE,
+	       cryp->base + RDR_THRESH(i));
+
+	/*
+	 * Configure a threshold and time-out value for the processed
+	 * result descriptors (or complete packets) that are written to
+	 * the RDR.
+	 */
+	writel(MTK_DESC_SIZE(MTK_DESC_SZ) | MTK_DESC_OFFSET(MTK_DESC_OFF),
+	       cryp->base + RDR_DESC_SIZE(i));
+
+	/*
+	 * Configure HIA fetch size and fetch threshold that are used to
+	 * fetch blocks of multiple descriptors.
+	 */
+	writel(MTK_DESC_FETCH_SIZE(count * MTK_DESC_OFF) |
+	       MTK_DESC_FETCH_THRESH(count * rndup) |
+	       MTK_DESC_OVL_IRQ_EN,
+		   cryp->base + RDR_CFG(i));
+}
+
+static int mtk_packet_engine_setup(struct mtk_cryp *cryp)
+{
+	struct mtk_sys_cap cap;
+	int i, err;
+	u32 val;
+
+	cap.hia_ver = readl(cryp->base + HIA_VERSION);
+	cap.hia_opt = readl(cryp->base + HIA_OPTIONS);
+	cap.hw_opt = readl(cryp->base + EIP97_OPTIONS);
+
+	if (!(((u16)cap.hia_ver) == MTK_HIA_SIGNATURE))
+		return -EINVAL;
+
+	/* Configure endianness conversion method for master (DMA) interface */
+	writel(0, cryp->base + EIP97_MST_CTRL);
+
+	/* Set HIA burst size */
+	val = readl(cryp->base + HIA_MST_CTRL);
+	val &= ~MTK_BURST_SIZE_MSK;
+	val |= MTK_BURST_SIZE(5);
+	writel(val, cryp->base + HIA_MST_CTRL);
+
+	err = mtk_dfe_dse_reset(cryp);
+	if (err) {
+		dev_err(cryp->dev, "Failed to reset DFE and DSE.\n");
+		return err;
+	}
+
+	mtk_dfe_dse_buf_setup(cryp, &cap);
+
+	/* Enable the 4 rings for the packet engines. */
+	mtk_desc_ring_link(cryp, 0xf);
+
+	for (i = 0; i < RING_MAX; i++) {
+		mtk_cmd_desc_ring_setup(cryp, i, &cap);
+		mtk_res_desc_ring_setup(cryp, i, &cap);
+	}
+
+	writel(MTK_PE_TK_LOC_AVL | MTK_PE_PROC_HELD | MTK_PE_TK_TIMEOUT_EN,
+	       cryp->base + PE_TOKEN_CTRL_STAT);
+
+	/* Clear all pending interrupts */
+	writel(MTK_AIC_G_CLR, cryp->base + AIC_G_ACK);
+	writel(MTK_PE_INPUT_DMA_ERR | MTK_PE_OUTPUT_DMA_ERR |
+	       MTK_PE_PKT_PORC_ERR | MTK_PE_PKT_TIMEOUT |
+	       MTK_PE_FATAL_ERR | MTK_PE_INPUT_DMA_ERR_EN |
+	       MTK_PE_OUTPUT_DMA_ERR_EN | MTK_PE_PKT_PORC_ERR_EN |
+	       MTK_PE_PKT_TIMEOUT_EN | MTK_PE_FATAL_ERR_EN |
+	       MTK_PE_INT_OUT_EN,
+	       cryp->base + PE_INTERRUPT_CTRL_STAT);
+
+	return 0;
+}
+
+static int mtk_aic_cap_check(struct mtk_cryp *cryp, int hw)
+{
+	u32 val;
+
+	if (hw == RING_MAX)
+		val = readl(cryp->base + AIC_G_VERSION);
+	else
+		val = readl(cryp->base + AIC_VERSION(hw));
+
+	val &= MTK_AIC_VER_MSK;
+	if (val != MTK_AIC_VER11 && val != MTK_AIC_VER12)
+		return -ENXIO;
+
+	if (hw == RING_MAX)
+		val = readl(cryp->base + AIC_G_OPTIONS);
+	else
+		val = readl(cryp->base + AIC_OPTIONS(hw));
+
+	val &= MTK_AIC_INT_MSK;
+	if (!val || val > 32)
+		return -ENXIO;
+
+	return 0;
+}
+
+static int mtk_aic_init(struct mtk_cryp *cryp, int hw)
+{
+	int err;
+
+	err = mtk_aic_cap_check(cryp, hw);
+	if (err)
+		return err;
+
+	/* Disable all interrupts and set initial configuration */
+	if (hw == RING_MAX) {
+		writel(0, cryp->base + AIC_G_ENABLE_CTRL);
+		writel(0, cryp->base + AIC_G_POL_CTRL);
+		writel(0, cryp->base + AIC_G_TYPE_CTRL);
+		writel(0, cryp->base + AIC_G_ENABLE_SET);
+	} else {
+		writel(0, cryp->base + AIC_ENABLE_CTRL(hw));
+		writel(0, cryp->base + AIC_POL_CTRL(hw));
+		writel(0, cryp->base + AIC_TYPE_CTRL(hw));
+		writel(0, cryp->base + AIC_ENABLE_SET(hw));
+	}
+
+	return 0;
+}
+
+static int mtk_accelerator_init(struct mtk_cryp *cryp)
+{
+	int i, err;
+
+	/* Initialize advanced interrupt controller(AIC) */
+	for (i = 0; i < MTK_IRQ_NUM; i++) {
+		err = mtk_aic_init(cryp, i);
+		if (err) {
+			dev_err(cryp->dev, "Failed to initialize AIC.\n");
+			return err;
+		}
+	}
+
+	/* Initialize packet engine */
+	err = mtk_packet_engine_setup(cryp);
+	if (err) {
+		dev_err(cryp->dev, "Failed to configure packet engine.\n");
+		return err;
+	}
+
+	return 0;
+}
+
+static void mtk_desc_dma_free(struct mtk_cryp *cryp)
+{
+	int i;
+
+	for (i = 0; i < RING_MAX; i++) {
+		dma_free_coherent(cryp->dev, MTK_DESC_RING_SZ,
+				  cryp->ring[i]->res_base,
+				  cryp->ring[i]->res_dma);
+		dma_free_coherent(cryp->dev, MTK_DESC_RING_SZ,
+				  cryp->ring[i]->cmd_base,
+				  cryp->ring[i]->cmd_dma);
+		kfree(cryp->ring[i]);
+	}
+}
+
+static int mtk_desc_ring_alloc(struct mtk_cryp *cryp)
+{
+	struct mtk_ring **ring = cryp->ring;
+	int i, err = ENOMEM;
+
+	for (i = 0; i < RING_MAX; i++) {
+		ring[i] = kzalloc(sizeof(**ring), GFP_KERNEL);
+		if (!ring[i])
+			goto err_cleanup;
+
+		ring[i]->cmd_base = dma_zalloc_coherent(cryp->dev,
+					   MTK_DESC_RING_SZ,
+					   &ring[i]->cmd_dma,
+					   GFP_KERNEL);
+		if (!ring[i]->cmd_base)
+			goto err_cleanup;
+
+		ring[i]->res_base = dma_zalloc_coherent(cryp->dev,
+					   MTK_DESC_RING_SZ,
+					   &ring[i]->res_dma,
+					   GFP_KERNEL);
+		if (!ring[i]->res_base)
+			goto err_cleanup;
+	}
+	return 0;
+
+err_cleanup:
+	for (; i--; ) {
+		dma_free_coherent(cryp->dev, MTK_DESC_RING_SZ,
+				  ring[i]->res_base, ring[i]->res_dma);
+		dma_free_coherent(cryp->dev, MTK_DESC_RING_SZ,
+				  ring[i]->cmd_base, ring[i]->cmd_dma);
+		kfree(ring[i]);
+	}
+	return err;
+}
+
+static int mtk_crypto_probe(struct platform_device *pdev)
+{
+	struct resource *res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	struct mtk_cryp *cryp;
+	int i, err;
+
+	cryp = devm_kzalloc(&pdev->dev, sizeof(*cryp), GFP_KERNEL);
+	if (!cryp)
+		return -ENOMEM;
+
+	cryp->base = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(cryp->base))
+		return PTR_ERR(cryp->base);
+
+	for (i = 0; i < MTK_IRQ_NUM; i++) {
+		cryp->irq[i] = platform_get_irq(pdev, i);
+		if (cryp->irq[i] < 0) {
+			dev_err(cryp->dev, "no IRQ:%d resource info\n", i);
+			return -ENXIO;
+		}
+	}
+
+	cryp->clk_ethif = devm_clk_get(&pdev->dev, "ethif");
+	cryp->clk_cryp = devm_clk_get(&pdev->dev, "cryp");
+	if (IS_ERR(cryp->clk_ethif) || IS_ERR(cryp->clk_cryp))
+		return -EPROBE_DEFER;
+
+	cryp->dev = &pdev->dev;
+	pm_runtime_enable(cryp->dev);
+	pm_runtime_get_sync(cryp->dev);
+
+	err = clk_prepare_enable(cryp->clk_ethif);
+	if (err)
+		goto err_clk_ethif;
+
+	err = clk_prepare_enable(cryp->clk_cryp);
+	if (err)
+		goto err_clk_cryp;
+
+	/* Allocate four command/result descriptor rings */
+	err = mtk_desc_ring_alloc(cryp);
+	if (err) {
+		dev_err(cryp->dev, "Unable to allocate descriptor rings.\n");
+		goto err_resource;
+	}
+
+	/* Initialize hardware modules */
+	err = mtk_accelerator_init(cryp);
+	if (err) {
+		dev_err(cryp->dev, "Failed to initialize cryptographic engine.\n");
+		goto err_engine;
+	}
+
+	err = mtk_cipher_alg_register(cryp);
+	if (err) {
+		dev_err(cryp->dev, "Unable to register cipher algorithm.\n");
+		goto err_cipher;
+	}
+
+	err = mtk_hash_alg_register(cryp);
+	if (err) {
+		dev_err(cryp->dev, "Unable to register hash algorithm.\n");
+		goto err_hash;
+	}
+
+	platform_set_drvdata(pdev, cryp);
+	return 0;
+
+err_hash:
+	mtk_cipher_alg_release(cryp);
+err_cipher:
+	mtk_dfe_dse_reset(cryp);
+err_engine:
+	mtk_desc_dma_free(cryp);
+err_resource:
+	clk_disable_unprepare(cryp->clk_cryp);
+err_clk_cryp:
+	clk_disable_unprepare(cryp->clk_ethif);
+err_clk_ethif:
+	pm_runtime_put_sync(cryp->dev);
+	pm_runtime_disable(cryp->dev);
+
+	return err;
+}
+
+static int mtk_crypto_remove(struct platform_device *pdev)
+{
+	struct mtk_cryp *cryp = platform_get_drvdata(pdev);
+
+	mtk_hash_alg_release(cryp);
+	mtk_cipher_alg_release(cryp);
+	mtk_desc_dma_free(cryp);
+
+	clk_disable_unprepare(cryp->clk_cryp);
+	clk_disable_unprepare(cryp->clk_ethif);
+
+	pm_runtime_put_sync(cryp->dev);
+	pm_runtime_disable(cryp->dev);
+	platform_set_drvdata(pdev, NULL);
+
+	return 0;
+}
+
+const struct of_device_id of_crypto_id[] = {
+	{ .compatible = "mediatek,eip97-crypto" },
+	{},
+};
+MODULE_DEVICE_TABLE(of, of_crypto_id);
+
+static struct platform_driver mtk_crypto_driver = {
+	.probe = mtk_crypto_probe,
+	.remove = mtk_crypto_remove,
+	.driver = {
+		   .name = "mtk-crypto",
+		   .owner = THIS_MODULE,
+		   .of_match_table = of_crypto_id,
+	},
+};
+module_platform_driver(mtk_crypto_driver);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Ryder Lee <ryder.lee@mediatek.com>");
+MODULE_DESCRIPTION("Cryptographic accelerator driver for EIP97");
diff --git a/drivers/crypto/mediatek/mtk-platform.h b/drivers/crypto/mediatek/mtk-platform.h
new file mode 100644
index 0000000..4d4309a
--- /dev/null
+++ b/drivers/crypto/mediatek/mtk-platform.h
@@ -0,0 +1,238 @@
+/*
+ * Driver for EIP97 cryptographic accelerator.
+ *
+ * Copyright (c) 2016 Ryder Lee <ryder.lee@mediatek.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ */
+
+#ifndef __MTK_PLATFORM_H_
+#define __MTK_PLATFORM_H_
+
+#include <crypto/algapi.h>
+#include <crypto/internal/hash.h>
+#include <crypto/scatterwalk.h>
+#include <linux/crypto.h>
+#include <linux/dma-mapping.h>
+#include <linux/interrupt.h>
+#include <linux/scatterlist.h>
+#include "mtk-regs.h"
+
+#define MTK_RDR_PROC_THRESH	BIT(0)
+#define MTK_RDR_PROC_MODE	BIT(23)
+#define MTK_CNT_RST		BIT(31)
+#define MTK_IRQ_RDR0		BIT(1)
+#define MTK_IRQ_RDR1		BIT(3)
+#define MTK_IRQ_RDR2		BIT(5)
+#define MTK_IRQ_RDR3		BIT(7)
+
+#define SIZE_IN_WORDS(x)	((x) >> 2)
+
+/**
+ * Ring 0/1 are used by AES encrypt and decrypt.
+ * Ring 2/3 are used by SHA.
+ */
+enum {
+	RING0 = 0,
+	RING1,
+	RING2,
+	RING3,
+	RING_MAX,
+};
+
+#define MTK_REC_NUM		(RING_MAX / 2)
+#define MTK_IRQ_NUM		5
+
+/**
+ * struct mtk_desc - DMA descriptor
+ * @hdr:	the descriptor control header
+ * @buf:	DMA address of input buffer segment
+ * @ct:		DMA address of command token that control operation flow
+ * @ct_hdr:	the command token control header
+ * @tag:	the user-defined field
+ * @tfm:	DMA address of transform state
+ * @bound:	align descriptors offset boundary
+ *
+ * Structure passed to the crypto engine to describe where source
+ * data needs to be fetched and how it needs to be processed.
+ */
+struct mtk_desc {
+	__le32 hdr;
+	__le32 buf;
+	__le32 ct;
+	__le32 ct_hdr;
+	__le32 tag;
+	__le32 tfm;
+	__le32 bound[2];
+};
+
+#define MTK_DESC_NUM		512
+#define MTK_DESC_OFF		SIZE_IN_WORDS(sizeof(struct mtk_desc))
+#define MTK_DESC_SZ		(MTK_DESC_OFF - 2)
+#define MTK_DESC_RING_SZ	((sizeof(struct mtk_desc) * MTK_DESC_NUM))
+#define MTK_DESC_CNT(x)		((MTK_DESC_OFF * (x)) << 2)
+#define MTK_DESC_LAST		cpu_to_le32(BIT(22))
+#define MTK_DESC_FIRST		cpu_to_le32(BIT(23))
+#define MTK_DESC_BUF_LEN(x)	cpu_to_le32(x)
+#define MTK_DESC_CT_LEN(x)	cpu_to_le32((x) << 24)
+
+/**
+ * struct mtk_ring - Descriptor ring
+ * @cmd_base:	pointer to command descriptor ring base
+ * @cmd_dma:	DMA address of command descriptor ring
+ * @res_base:	pointer to result descriptor ring base
+ * @res_dma:	DMA address of result descriptor ring
+ * @pos:	current position in the ring
+ *
+ * A descriptor ring is a circular buffer that is used to manage
+ * one or more descriptors. There are two type of descriptor rings;
+ * the command descriptor ring and result descriptor ring.
+ */
+struct mtk_ring {
+	struct mtk_desc *cmd_base;
+	dma_addr_t cmd_dma;
+	struct mtk_desc *res_base;
+	dma_addr_t res_dma;
+	u32 pos;
+};
+
+/**
+ * struct mtk_aes_dma - Structure that holds sg list info
+ * @sg:		pointer to scatter-gather list
+ * @nents:	number of entries in the sg list
+ * @remainder:	remainder of sg list
+ * @sg_len:	number of entries in the sg mapped list
+ */
+struct mtk_aes_dma {
+	struct scatterlist *sg;
+	int nents;
+	u32 remainder;
+	u32 sg_len;
+};
+
+/**
+ * struct mtk_aes_rec - AES operation record
+ * @queue:	crypto request queue
+ * @req:	pointer to ablkcipher request
+ * @task:	the tasklet is use in AES interrupt
+ * @src:	the structure that holds source sg list info
+ * @dst:	the structure that holds destination sg list info
+ * @aligned_sg:	the scatter list is use to alignment
+ * @real_dst:	pointer to the destination sg list
+ * @total:	request buffer length
+ * @buf:	pointer to page buffer
+ * @info:	pointer to AES transform state and command token
+ * @ct_hdr:	AES command token control field
+ * @ct_size:	size of AES command token
+ * @ct_dma:	DMA address of AES command token
+ * @tfm_dma:	DMA address of AES transform state
+ * @id:		record identification
+ * @flags:	it's describing AES operation state
+ * @lock:	the ablkcipher queue lock
+ *
+ * Structure used to record AES execution state.
+ */
+struct mtk_aes_rec {
+	struct crypto_queue queue;
+	struct ablkcipher_request *req;
+	struct tasklet_struct task;
+	struct mtk_aes_dma src;
+	struct mtk_aes_dma dst;
+
+	struct scatterlist aligned_sg;
+	struct scatterlist *real_dst;
+
+	size_t total;
+	void *buf;
+
+	void *info;
+	__le32 ct_hdr;
+	u32 ct_size;
+	dma_addr_t ct_dma;
+	dma_addr_t tfm_dma;
+
+	u8 id;
+	unsigned long flags;
+	/* queue lock */
+	spinlock_t lock;
+};
+
+/**
+ * struct mtk_sha_rec - SHA operation record
+ * @queue:	crypto request queue
+ * @req:	pointer to ahash request
+ * @task:	the tasklet is use in SHA interrupt
+ * @info:	pointer to SHA transform state and command token
+ * @ct_hdr:	SHA command token control field
+ * @ct_size:	size of SHA command token
+ * @ct_dma:	DMA address of SHA command token
+ * @tfm_dma:	DMA address of SHA transform state
+ * @id:		record identification
+ * @flags:	it's describing SHA operation state
+ * @lock:	the ablkcipher queue lock
+ *
+ * Structure used to record SHA execution state.
+ */
+struct mtk_sha_rec {
+	struct crypto_queue queue;
+	struct ahash_request *req;
+	struct tasklet_struct task;
+
+	void *info;
+	__le32 ct_hdr;
+	u32 ct_size;
+	dma_addr_t ct_dma;
+	dma_addr_t tfm_dma;
+
+	u8 id;
+	unsigned long flags;
+	/* queue lock */
+	spinlock_t lock;
+};
+
+/**
+ * struct mtk_cryp - Cryptographic device
+ * @base:	pointer to mapped register I/O base
+ * @dev:	pointer to device
+ * @clk_ethif:	pointer to ethif clock
+ * @clk_cryp:	pointer to crypto clock
+ * @irq:	global system and rings IRQ
+ * @ring:	pointer to execution state of AES
+ * @aes:	pointer to execution state of SHA
+ * @sha:	each execution record map to a ring
+ * @aes_list:	device list of AES
+ * @sha_list:	device list of SHA
+ * @tmp:	pointer to temporary buffer for internal use
+ * @tmp_dma:	DMA address of temporary buffer
+ * @rec:	it's used to select SHA record for tfm
+ *
+ * Structure storing cryptographic device information.
+ */
+struct mtk_cryp {
+	void __iomem *base;
+	struct device *dev;
+	struct clk *clk_ethif;
+	struct clk *clk_cryp;
+	int irq[MTK_IRQ_NUM];
+
+	struct mtk_ring *ring[RING_MAX];
+	struct mtk_aes_rec *aes[MTK_REC_NUM];
+	struct mtk_sha_rec *sha[MTK_REC_NUM];
+
+	struct list_head aes_list;
+	struct list_head sha_list;
+
+	void *tmp;
+	dma_addr_t tmp_dma;
+	bool rec;
+};
+
+int mtk_cipher_alg_register(struct mtk_cryp *cryp);
+void mtk_cipher_alg_release(struct mtk_cryp *cryp);
+int mtk_hash_alg_register(struct mtk_cryp *cryp);
+void mtk_hash_alg_release(struct mtk_cryp *cryp);
+
+#endif /* __MTK_PLATFORM_H_ */
diff --git a/drivers/crypto/mediatek/mtk-regs.h b/drivers/crypto/mediatek/mtk-regs.h
new file mode 100644
index 0000000..94f4eb8
--- /dev/null
+++ b/drivers/crypto/mediatek/mtk-regs.h
@@ -0,0 +1,194 @@
+/*
+ * Support for MediaTek cryptographic accelerator.
+ *
+ * Copyright (c) 2016 MediaTek Inc.
+ * Author: Ryder Lee <ryder.lee@mediatek.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License.
+ *
+ */
+
+#ifndef __MTK_REGS_H__
+#define __MTK_REGS_H__
+
+/* HIA, Command Descriptor Ring Manager */
+#define CDR_BASE_ADDR_LO(x)		(0x0 + ((x) << 12))
+#define CDR_BASE_ADDR_HI(x)		(0x4 + ((x) << 12))
+#define CDR_DATA_BASE_ADDR_LO(x)	(0x8 + ((x) << 12))
+#define CDR_DATA_BASE_ADDR_HI(x)	(0xC + ((x) << 12))
+#define CDR_ACD_BASE_ADDR_LO(x)		(0x10 + ((x) << 12))
+#define CDR_ACD_BASE_ADDR_HI(x)		(0x14 + ((x) << 12))
+#define CDR_RING_SIZE(x)		(0x18 + ((x) << 12))
+#define CDR_DESC_SIZE(x)		(0x1C + ((x) << 12))
+#define CDR_CFG(x)			(0x20 + ((x) << 12))
+#define CDR_DMA_CFG(x)			(0x24 + ((x) << 12))
+#define CDR_THRESH(x)			(0x28 + ((x) << 12))
+#define CDR_PREP_COUNT(x)		(0x2C + ((x) << 12))
+#define CDR_PROC_COUNT(x)		(0x30 + ((x) << 12))
+#define CDR_PREP_PNTR(x)		(0x34 + ((x) << 12))
+#define CDR_PROC_PNTR(x)		(0x38 + ((x) << 12))
+#define CDR_STAT(x)			(0x3C + ((x) << 12))
+
+/* HIA, Result Descriptor Ring Manager */
+#define RDR_BASE_ADDR_LO(x)		(0x800 + ((x) << 12))
+#define RDR_BASE_ADDR_HI(x)		(0x804 + ((x) << 12))
+#define RDR_DATA_BASE_ADDR_LO(x)	(0x808 + ((x) << 12))
+#define RDR_DATA_BASE_ADDR_HI(x)	(0x80C + ((x) << 12))
+#define RDR_ACD_BASE_ADDR_LO(x)		(0x810 + ((x) << 12))
+#define RDR_ACD_BASE_ADDR_HI(x)		(0x814 + ((x) << 12))
+#define RDR_RING_SIZE(x)		(0x818 + ((x) << 12))
+#define RDR_DESC_SIZE(x)		(0x81C + ((x) << 12))
+#define RDR_CFG(x)			(0x820 + ((x) << 12))
+#define RDR_DMA_CFG(x)			(0x824 + ((x) << 12))
+#define RDR_THRESH(x)			(0x828 + ((x) << 12))
+#define RDR_PREP_COUNT(x)		(0x82C + ((x) << 12))
+#define RDR_PROC_COUNT(x)		(0x830 + ((x) << 12))
+#define RDR_PREP_PNTR(x)		(0x834 + ((x) << 12))
+#define RDR_PROC_PNTR(x)		(0x838 + ((x) << 12))
+#define RDR_STAT(x)			(0x83C + ((x) << 12))
+
+/* HIA, Ring AIC */
+#define AIC_POL_CTRL(x)			(0xE000 - ((x) << 12))
+#define	AIC_TYPE_CTRL(x)		(0xE004 - ((x) << 12))
+#define	AIC_ENABLE_CTRL(x)		(0xE008 - ((x) << 12))
+#define	AIC_RAW_STAL(x)			(0xE00C - ((x) << 12))
+#define	AIC_ENABLE_SET(x)		(0xE00C - ((x) << 12))
+#define	AIC_ENABLED_STAT(x)		(0xE010 - ((x) << 12))
+#define	AIC_ACK(x)			(0xE010 - ((x) << 12))
+#define	AIC_ENABLE_CLR(x)		(0xE014 - ((x) << 12))
+#define	AIC_OPTIONS(x)			(0xE018 - ((x) << 12))
+#define	AIC_VERSION(x)			(0xE01C - ((x) << 12))
+
+/* HIA, Global AIC */
+#define AIC_G_POL_CTRL			0xF800
+#define AIC_G_TYPE_CTRL			0xF804
+#define AIC_G_ENABLE_CTRL		0xF808
+#define AIC_G_RAW_STAT			0xF80C
+#define AIC_G_ENABLE_SET		0xF80C
+#define AIC_G_ENABLED_STAT		0xF810
+#define AIC_G_ACK			0xF810
+#define AIC_G_ENABLE_CLR		0xF814
+#define AIC_G_OPTIONS			0xF818
+#define AIC_G_VERSION			0xF81C
+
+/* HIA, Data Fetch Engine */
+#define DFE_CFG				0xF000
+#define DFE_PRIO_0			0xF010
+#define DFE_PRIO_1			0xF014
+#define DFE_PRIO_2			0xF018
+#define DFE_PRIO_3			0xF01C
+
+/* HIA, Data Fetch Engine access monitoring for CDR */
+#define DFE_RING_REGION_LO(x)		(0xF080 + ((x) << 3))
+#define DFE_RING_REGION_HI(x)		(0xF084 + ((x) << 3))
+
+/* HIA, Data Fetch Engine thread control and status for thread */
+#define DFE_THR_CTRL			0xF200
+#define DFE_THR_STAT			0xF204
+#define DFE_THR_DESC_CTRL		0xF208
+#define DFE_THR_DESC_DPTR_LO		0xF210
+#define DFE_THR_DESC_DPTR_HI		0xF214
+#define DFE_THR_DESC_ACDPTR_LO		0xF218
+#define DFE_THR_DESC_ACDPTR_HI		0xF21C
+
+/* HIA, Data Store Engine */
+#define DSE_CFG				0xF400
+#define DSE_PRIO_0			0xF410
+#define DSE_PRIO_1			0xF414
+#define DSE_PRIO_2			0xF418
+#define DSE_PRIO_3			0xF41C
+
+/* HIA, Data Store Engine access monitoring for RDR */
+#define DSE_RING_REGION_LO(x)		(0xF480 + ((x) << 3))
+#define DSE_RING_REGION_HI(x)		(0xF484 + ((x) << 3))
+
+/* HIA, Data Store Engine thread control and status for thread */
+#define DSE_THR_CTRL			0xF600
+#define DSE_THR_STAT			0xF604
+#define DSE_THR_DESC_CTRL		0xF608
+#define DSE_THR_DESC_DPTR_LO		0xF610
+#define DSE_THR_DESC_DPTR_HI		0xF614
+#define DSE_THR_DESC_S_DPTR_LO		0xF618
+#define DSE_THR_DESC_S_DPTR_HI		0xF61C
+#define DSE_THR_ERROR_STAT		0xF620
+
+/* HIA Global */
+#define HIA_MST_CTRL			0xFFF4
+#define HIA_OPTIONS			0xFFF8
+#define HIA_VERSION			0xFFFC
+
+/* Processing Engine Input Side, Processing Engine */
+#define PE_IN_DBUF_THRESH		0x10000
+#define PE_IN_TBUF_THRESH		0x10100
+
+/* Packet Engine Configuration / Status Registers */
+#define PE_TOKEN_CTRL_STAT		0x11000
+#define PE_FUNCTION_EN			0x11004
+#define PE_CONTEXT_CTRL			0x11008
+#define PE_INTERRUPT_CTRL_STAT		0x11010
+#define PE_CONTEXT_STAT			0x1100C
+#define PE_OUT_TRANS_CTRL_STAT		0x11018
+#define PE_OUT_BUF_CTRL			0x1101C
+
+/* Packet Engine PRNG Registers */
+#define PE_PRNG_STAT			0x11040
+#define PE_PRNG_CTRL			0x11044
+#define PE_PRNG_SEED_L			0x11048
+#define PE_PRNG_SEED_H			0x1104C
+#define PE_PRNG_KEY_0_L			0x11050
+#define PE_PRNG_KEY_0_H			0x11054
+#define PE_PRNG_KEY_1_L			0x11058
+#define PE_PRNG_KEY_1_H			0x1105C
+#define PE_PRNG_RES_0			0x11060
+#define PE_PRNG_RES_1			0x11064
+#define PE_PRNG_RES_2			0x11068
+#define PE_PRNG_RES_3			0x1106C
+#define PE_PRNG_LFSR_L			0x11070
+#define PE_PRNG_LFSR_H			0x11074
+
+/* Packet Engine AIC */
+#define PE_EIP96_AIC_POL_CTRL		0x113C0
+#define PE_EIP96_AIC_TYPE_CTRL		0x113C4
+#define PE_EIP96_AIC_ENABLE_CTRL	0x113C8
+#define PE_EIP96_AIC_RAW_STAT		0x113CC
+#define PE_EIP96_AIC_ENABLE_SET		0x113CC
+#define PE_EIP96_AIC_ENABLED_STAT	0x113D0
+#define PE_EIP96_AIC_ACK		0x113D0
+#define PE_EIP96_AIC_ENABLE_CLR		0x113D4
+#define PE_EIP96_AIC_OPTIONS		0x113D8
+#define PE_EIP96_AIC_VERSION		0x113DC
+
+/* Packet Engine Options & Version Registers */
+#define PE_EIP96_OPTIONS		0x113F8
+#define PE_EIP96_VERSION		0x113FC
+
+/* Processing Engine Output Side */
+#define PE_OUT_DBUF_THRESH		0x11C00
+#define PE_OUT_TBUF_THRESH		0x11D00
+
+/* Processing Engine Local AIC */
+#define PE_AIC_POL_CTRL			0x11F00
+#define PE_AIC_TYPE_CTRL		0x11F04
+#define PE_AIC_ENABLE_CTRL		0x11F08
+#define PE_AIC_RAW_STAT			0x11F0C
+#define PE_AIC_ENABLE_SET		0x11F0C
+#define PE_AIC_ENABLED_STAT		0x11F10
+#define PE_AIC_ENABLE_CLR		0x11F14
+#define PE_AIC_OPTIONS			0x11F18
+#define PE_AIC_VERSION			0x11F1C
+
+/* Processing Engine General Configuration and Version */
+#define PE_IN_FLIGHT			0x11FF0
+#define PE_OPTIONS			0x11FF8
+#define PE_VERSION			0x11FFC
+
+/* EIP-97 - Global */
+#define EIP97_CLOCK_STATE		0x1FFE4
+#define EIP97_FORCE_CLOCK_ON		0x1FFE8
+#define EIP97_FORCE_CLOCK_OFF		0x1FFEC
+#define EIP97_MST_CTRL			0x1FFF4
+#define EIP97_OPTIONS			0x1FFF8
+#define EIP97_VERSION			0x1FFFC
+#endif /* __MTK_REGS_H__ */
diff --git a/drivers/crypto/mediatek/mtk-sha.c b/drivers/crypto/mediatek/mtk-sha.c
new file mode 100644
index 0000000..8951363
--- /dev/null
+++ b/drivers/crypto/mediatek/mtk-sha.c
@@ -0,0 +1,1437 @@
+/*
+ * Cryptographic API.
+ *
+ * Driver for EIP97 SHA1/SHA2(HMAC) acceleration.
+ *
+ * Copyright (c) 2016 Ryder Lee <ryder.lee@mediatek.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * Some ideas are from atmel-sha.c and omap-sham.c drivers.
+ */
+
+#include <crypto/sha.h>
+#include "mtk-platform.h"
+
+#define SHA_ALIGN_MSK		(sizeof(u32) - 1)
+#define SHA_QUEUE_SIZE		512
+#define SHA_TMP_BUF_SIZE	512
+#define SHA_BUF_SIZE		((u32)PAGE_SIZE)
+
+#define SHA_OP_UPDATE		1
+#define SHA_OP_FINAL		2
+
+#define SHA_DATA_LEN_MSK	cpu_to_le32(GENMASK(16, 0))
+
+/* SHA command token */
+#define SHA_CT_SIZE		5
+#define SHA_CT_CTRL_HDR		cpu_to_le32(0x02220000)
+#define SHA_COMMAND0		cpu_to_le32(0x03020000)
+#define SHA_COMMAND1		cpu_to_le32(0x21060000)
+#define SHA_COMMAND2		cpu_to_le32(0xe0e63802)
+
+/* SHA transform information */
+#define SHA_TFM_HASH		cpu_to_le32(0x2 << 0)
+#define SHA_TFM_INNER_DIG	cpu_to_le32(0x1 << 21)
+#define SHA_TFM_SIZE(x)		cpu_to_le32((x) << 8)
+#define SHA_TFM_START		cpu_to_le32(0x1 << 4)
+#define SHA_TFM_CONTINUE	cpu_to_le32(0x1 << 5)
+#define SHA_TFM_HASH_STORE	cpu_to_le32(0x1 << 19)
+#define SHA_TFM_SHA1		cpu_to_le32(0x2 << 23)
+#define SHA_TFM_SHA256		cpu_to_le32(0x3 << 23)
+#define SHA_TFM_SHA224		cpu_to_le32(0x4 << 23)
+#define SHA_TFM_SHA512		cpu_to_le32(0x5 << 23)
+#define SHA_TFM_SHA384		cpu_to_le32(0x6 << 23)
+#define SHA_TFM_DIGEST(x)	cpu_to_le32(((x) & GENMASK(3, 0)) << 24)
+
+/* SHA flags */
+#define SHA_FLAGS_BUSY		BIT(0)
+#define	SHA_FLAGS_FINAL		BIT(1)
+#define SHA_FLAGS_FINUP		BIT(2)
+#define SHA_FLAGS_SG		BIT(3)
+#define SHA_FLAGS_ALGO_MSK	GENMASK(8, 4)
+#define SHA_FLAGS_SHA1		BIT(4)
+#define SHA_FLAGS_SHA224	BIT(5)
+#define SHA_FLAGS_SHA256	BIT(6)
+#define SHA_FLAGS_SHA384	BIT(7)
+#define SHA_FLAGS_SHA512	BIT(8)
+#define SHA_FLAGS_HMAC		BIT(9)
+#define SHA_FLAGS_PAD		BIT(10)
+
+/**
+ * mtk_sha_ct is a set of hardware instructions(command token)
+ * that are used to control engine's processing flow of SHA,
+ * and it contains the first two words of transform state.
+ */
+struct mtk_sha_ct {
+	__le32 tfm_ctrl0;
+	__le32 tfm_ctrl1;
+	__le32 ct_ctrl0;
+	__le32 ct_ctrl1;
+	__le32 ct_ctrl2;
+};
+
+/**
+ * mtk_sha_tfm is used to define SHA transform state
+ * and store result digest that produced by engine.
+ */
+struct mtk_sha_tfm {
+	__le32 tfm_ctrl0;
+	__le32 tfm_ctrl1;
+	__le32 digest[SIZE_IN_WORDS(SHA512_DIGEST_SIZE)];
+};
+
+/**
+ * mtk_sha_info consists of command token and transform state
+ * of SHA, its role is similar to mtk_aes_info.
+ */
+struct mtk_sha_info {
+	struct mtk_sha_ct ct;
+	struct mtk_sha_tfm tfm;
+};
+
+struct mtk_sha_reqctx {
+	struct mtk_sha_info info;
+	unsigned long flags;
+	unsigned long op;
+
+	u64 digcnt;
+	bool start;
+	size_t bufcnt;
+	dma_addr_t dma_addr;
+
+	/* Walk state */
+	struct scatterlist *sg;
+	u32 offset;	/* Offset in current sg */
+	u32 total;	/* Total request */
+	size_t ds;
+	size_t bs;
+
+	u8 *buffer;
+};
+
+struct mtk_sha_hmac_ctx {
+	struct crypto_shash	*shash;
+	u8 ipad[SHA512_BLOCK_SIZE] __aligned(sizeof(u32));
+	u8 opad[SHA512_BLOCK_SIZE] __aligned(sizeof(u32));
+};
+
+struct mtk_sha_ctx {
+	struct mtk_cryp *cryp;
+	unsigned long flags;
+	u8 id;
+	u8 buf[SHA_BUF_SIZE] __aligned(sizeof(u32));
+
+	struct mtk_sha_hmac_ctx	base[0];
+};
+
+struct mtk_sha_drv {
+	struct list_head dev_list;
+	/* Device list lock */
+	spinlock_t lock;
+};
+
+static struct mtk_sha_drv mtk_sha = {
+	.dev_list = LIST_HEAD_INIT(mtk_sha.dev_list),
+	.lock = __SPIN_LOCK_UNLOCKED(mtk_sha.lock),
+};
+
+static int mtk_sha_handle_queue(struct mtk_cryp *cryp, u8 id,
+				struct ahash_request *req);
+
+static inline u32 mtk_sha_read(struct mtk_cryp *cryp, u32 offset)
+{
+	return readl_relaxed(cryp->base + offset);
+}
+
+static inline void mtk_sha_write(struct mtk_cryp *cryp,
+				 u32 offset, u32 value)
+{
+	writel_relaxed(value, cryp->base + offset);
+}
+
+static struct mtk_cryp *mtk_sha_find_dev(struct mtk_sha_ctx *tctx)
+{
+	struct mtk_cryp *cryp = NULL;
+	struct mtk_cryp *tmp;
+
+	spin_lock_bh(&mtk_sha.lock);
+	if (!tctx->cryp) {
+		list_for_each_entry(tmp, &mtk_sha.dev_list, sha_list) {
+			cryp = tmp;
+			break;
+		}
+		tctx->cryp = cryp;
+	} else {
+		cryp = tctx->cryp;
+	}
+
+	/*
+	 * Assign record id to tfm in round-robin fashion, and this
+	 * will help tfm to bind  to corresponding descriptor rings.
+	 */
+	tctx->id = cryp->rec;
+	cryp->rec = !cryp->rec;
+
+	spin_unlock_bh(&mtk_sha.lock);
+
+	return cryp;
+}
+
+static int mtk_sha_append_sg(struct mtk_sha_reqctx *ctx)
+{
+	size_t count;
+
+	while ((ctx->bufcnt < SHA_BUF_SIZE) && ctx->total) {
+		count = min(ctx->sg->length - ctx->offset, ctx->total);
+		count = min(count, SHA_BUF_SIZE - ctx->bufcnt);
+
+		if (count <= 0) {
+			/*
+			 * Check if count <= 0 because the buffer is full or
+			 * because the sg length is 0. In the latest case,
+			 * check if there is another sg in the list, a 0 length
+			 * sg doesn't necessarily mean the end of the sg list.
+			 */
+			if ((ctx->sg->length == 0) && !sg_is_last(ctx->sg)) {
+				ctx->sg = sg_next(ctx->sg);
+				continue;
+			} else {
+				break;
+			}
+		}
+
+		scatterwalk_map_and_copy(ctx->buffer + ctx->bufcnt, ctx->sg,
+					 ctx->offset, count, 0);
+
+		ctx->bufcnt += count;
+		ctx->offset += count;
+		ctx->total -= count;
+
+		if (ctx->offset == ctx->sg->length) {
+			ctx->sg = sg_next(ctx->sg);
+			if (ctx->sg)
+				ctx->offset = 0;
+			else
+				ctx->total = 0;
+		}
+	}
+
+	return 0;
+}
+
+/*
+ * The purpose of this padding is to ensure that the padded message is a
+ * multiple of 512 bits (SHA1/SHA224/SHA256) or 1024 bits (SHA384/SHA512).
+ * The bit "1" is appended at the end of the message followed by
+ * "padlen-1" zero bits. Then a 64 bits block (SHA1/SHA224/SHA256) or
+ * 128 bits block (SHA384/SHA512) equals to the message length in bits
+ * is appended.
+ *
+ * For SHA1/SHA224/SHA256, padlen is calculated as followed:
+ *  - if message length < 56 bytes then padlen = 56 - message length
+ *  - else padlen = 64 + 56 - message length
+ *
+ * For SHA384/SHA512, padlen is calculated as followed:
+ *  - if message length < 112 bytes then padlen = 112 - message length
+ *  - else padlen = 128 + 112 - message length
+ */
+static void mtk_sha_fill_padding(struct mtk_sha_reqctx *ctx, u32 len)
+{
+	u32 index, padlen;
+	u64 bits[2];
+	u64 size = ctx->digcnt;
+
+	size += ctx->bufcnt;
+	size += len;
+
+	bits[1] = cpu_to_be64(size << 3);
+	bits[0] = cpu_to_be64(size >> 61);
+
+	if (ctx->flags & (SHA_FLAGS_SHA384 | SHA_FLAGS_SHA512)) {
+		index = ctx->bufcnt & 0x7f;
+		padlen = (index < 112) ? (112 - index) : ((128 + 112) - index);
+		*(ctx->buffer + ctx->bufcnt) = 0x80;
+		memset(ctx->buffer + ctx->bufcnt + 1, 0, padlen - 1);
+		memcpy(ctx->buffer + ctx->bufcnt + padlen, bits, 16);
+		ctx->bufcnt += padlen + 16;
+		ctx->flags |= SHA_FLAGS_PAD;
+	} else {
+		index = ctx->bufcnt & 0x3f;
+		padlen = (index < 56) ? (56 - index) : ((64 + 56) - index);
+		*(ctx->buffer + ctx->bufcnt) = 0x80;
+		memset(ctx->buffer + ctx->bufcnt + 1, 0, padlen - 1);
+		memcpy(ctx->buffer + ctx->bufcnt + padlen, &bits[1], 8);
+		ctx->bufcnt += padlen + 8;
+		ctx->flags |= SHA_FLAGS_PAD;
+	}
+}
+
+/* Initialize basic transform information of SHA */
+static void mtk_sha_info_init(struct mtk_sha_rec *sha,
+			      struct mtk_sha_reqctx *ctx)
+{
+	struct mtk_sha_info *info = sha->info;
+	struct mtk_sha_ct *ct = &info->ct;
+	struct mtk_sha_tfm *tfm = &info->tfm;
+
+	sha->ct_hdr = SHA_CT_CTRL_HDR;
+	sha->ct_size = SHA_CT_SIZE;
+
+	tfm->tfm_ctrl0 = SHA_TFM_HASH | SHA_TFM_INNER_DIG |
+			 SHA_TFM_SIZE(SIZE_IN_WORDS(ctx->ds));
+
+	switch (ctx->flags & SHA_FLAGS_ALGO_MSK) {
+	case SHA_FLAGS_SHA1:
+		tfm->tfm_ctrl0 |= SHA_TFM_SHA1;
+		break;
+	case SHA_FLAGS_SHA224:
+		tfm->tfm_ctrl0 |= SHA_TFM_SHA224;
+		break;
+	case SHA_FLAGS_SHA256:
+		tfm->tfm_ctrl0 |= SHA_TFM_SHA256;
+		break;
+	case SHA_FLAGS_SHA384:
+		tfm->tfm_ctrl0 |= SHA_TFM_SHA384;
+		break;
+	case SHA_FLAGS_SHA512:
+		tfm->tfm_ctrl0 |= SHA_TFM_SHA512;
+		break;
+
+	default:
+		/* Should not happen... */
+		return;
+	}
+
+	tfm->tfm_ctrl1 = SHA_TFM_HASH_STORE;
+	ct->tfm_ctrl0 = tfm->tfm_ctrl0 | SHA_TFM_CONTINUE | SHA_TFM_START;
+	ct->tfm_ctrl1 = tfm->tfm_ctrl1;
+
+	ct->ct_ctrl0 = SHA_COMMAND0;
+	ct->ct_ctrl1 = SHA_COMMAND1;
+	ct->ct_ctrl2 = SHA_COMMAND2 | SHA_TFM_DIGEST(SIZE_IN_WORDS(ctx->ds));
+}
+
+/*
+ * Update input data length field of transform information and
+ * map it to DMA region.
+ */
+static int mtk_sha_info_map(struct mtk_cryp *cryp,
+			    struct mtk_sha_rec *sha,
+			    size_t len)
+{
+	struct mtk_sha_reqctx *ctx = ahash_request_ctx(sha->req);
+	struct mtk_sha_info *info = sha->info;
+	struct mtk_sha_ct *ct = &info->ct;
+
+	if (ctx->start)
+		ctx->start = false;
+	else
+		ct->tfm_ctrl0 &= ~SHA_TFM_START;
+
+	sha->ct_hdr &= ~SHA_DATA_LEN_MSK;
+	sha->ct_hdr |= cpu_to_le32(len);
+	ct->ct_ctrl0 &= ~SHA_DATA_LEN_MSK;
+	ct->ct_ctrl0 |= cpu_to_le32(len);
+
+	ctx->digcnt += len;
+
+	sha->ct_dma = dma_map_single(cryp->dev, info, sizeof(*info),
+				      DMA_BIDIRECTIONAL);
+	if (unlikely(dma_mapping_error(cryp->dev, sha->ct_dma))) {
+		dev_err(cryp->dev, "dma %d bytes error\n", sizeof(*info));
+		return -EINVAL;
+	}
+	sha->tfm_dma = sha->ct_dma + sizeof(*ct);
+
+	return 0;
+}
+
+/*
+ * Because of hardware limitation, we must pre-calculate the inner
+ * and outer digest that need to be processed firstly by engine, then
+ * apply the result digest to the input message. These complex hashing
+ * procedures limits HMAC performance, so we use fallback SW encoding.
+ */
+static int mtk_sha_finish_hmac(struct ahash_request *req)
+{
+	struct mtk_sha_ctx *tctx = crypto_tfm_ctx(req->base.tfm);
+	struct mtk_sha_hmac_ctx *bctx = tctx->base;
+	struct mtk_sha_reqctx *ctx = ahash_request_ctx(req);
+
+	SHASH_DESC_ON_STACK(shash, bctx->shash);
+
+	shash->tfm = bctx->shash;
+	shash->flags = 0; /* not CRYPTO_TFM_REQ_MAY_SLEEP */
+
+	return crypto_shash_init(shash) ?:
+	       crypto_shash_update(shash, bctx->opad, ctx->bs) ?:
+	       crypto_shash_finup(shash, req->result, ctx->ds, req->result);
+}
+
+/* Initialize request context */
+static int mtk_sha_init(struct ahash_request *req)
+{
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
+	struct mtk_sha_ctx *tctx = crypto_ahash_ctx(tfm);
+	struct mtk_sha_reqctx *ctx = ahash_request_ctx(req);
+
+	ctx->flags = 0;
+	ctx->ds = crypto_ahash_digestsize(tfm);
+
+	switch (ctx->ds) {
+	case SHA1_DIGEST_SIZE:
+		ctx->flags |= SHA_FLAGS_SHA1;
+		ctx->bs = SHA1_BLOCK_SIZE;
+		break;
+	case SHA224_DIGEST_SIZE:
+		ctx->flags |= SHA_FLAGS_SHA224;
+		ctx->bs = SHA224_BLOCK_SIZE;
+		break;
+	case SHA256_DIGEST_SIZE:
+		ctx->flags |= SHA_FLAGS_SHA256;
+		ctx->bs = SHA256_BLOCK_SIZE;
+		break;
+	case SHA384_DIGEST_SIZE:
+		ctx->flags |= SHA_FLAGS_SHA384;
+		ctx->bs = SHA384_BLOCK_SIZE;
+		break;
+	case SHA512_DIGEST_SIZE:
+		ctx->flags |= SHA_FLAGS_SHA512;
+		ctx->bs = SHA512_BLOCK_SIZE;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	ctx->bufcnt = 0;
+	ctx->digcnt = 0;
+	ctx->buffer = tctx->buf;
+	ctx->start = true;
+
+	if (tctx->flags & SHA_FLAGS_HMAC) {
+		struct mtk_sha_hmac_ctx *bctx = tctx->base;
+
+		memcpy(ctx->buffer, bctx->ipad, ctx->bs);
+		ctx->bufcnt = ctx->bs;
+		ctx->flags |= SHA_FLAGS_HMAC;
+	}
+
+	return 0;
+}
+
+static int mtk_sha_xmit(struct mtk_cryp *cryp, struct mtk_sha_rec *sha,
+			dma_addr_t addr, size_t len)
+{
+	struct mtk_ring *ring = cryp->ring[sha->id];
+	struct mtk_desc *cmd = ring->cmd_base + ring->pos;
+	struct mtk_desc *res = ring->res_base + ring->pos;
+	int err;
+
+	err = mtk_sha_info_map(cryp, sha, len);
+	if (err)
+		return err;
+
+	/* Fill in the command/result descriptors */
+	res->hdr = MTK_DESC_FIRST |
+		   MTK_DESC_LAST |
+		   MTK_DESC_BUF_LEN(len);
+
+	res->buf = cpu_to_le32(cryp->tmp_dma);
+
+	cmd->hdr = MTK_DESC_FIRST |
+		   MTK_DESC_LAST |
+		   MTK_DESC_BUF_LEN(len) |
+		   MTK_DESC_CT_LEN(sha->ct_size);
+
+	cmd->buf = cpu_to_le32(addr);
+	cmd->ct = cpu_to_le32(sha->ct_dma);
+	cmd->ct_hdr = sha->ct_hdr;
+	cmd->tfm = cpu_to_le32(sha->tfm_dma);
+
+	if (++ring->pos == MTK_DESC_NUM)
+		ring->pos = 0;
+
+	/*
+	 * Make sure that all changes to the DMA ring are done before we
+	 * start engine.
+	 */
+	wmb();
+	/* Start DMA transfer */
+	mtk_sha_write(cryp, RDR_PREP_COUNT(sha->id), MTK_DESC_CNT(1));
+	mtk_sha_write(cryp, CDR_PREP_COUNT(sha->id), MTK_DESC_CNT(1));
+
+	return -EINPROGRESS;
+}
+
+static int mtk_sha_xmit2(struct mtk_cryp *cryp,
+			 struct mtk_sha_rec *sha,
+			 struct mtk_sha_reqctx *ctx,
+			 size_t len1, size_t len2)
+{
+	struct mtk_ring *ring = cryp->ring[sha->id];
+	struct mtk_desc *cmd = ring->cmd_base + ring->pos;
+	struct mtk_desc *res = ring->res_base + ring->pos;
+	int err;
+
+	err = mtk_sha_info_map(cryp, sha, len1 + len2);
+	if (err)
+		return err;
+
+	/* Fill in the command/result descriptors */
+	res->hdr = MTK_DESC_BUF_LEN(len1) | MTK_DESC_FIRST;
+	res->buf = cpu_to_le32(cryp->tmp_dma);
+
+	cmd->hdr = MTK_DESC_BUF_LEN(len1) |
+		   MTK_DESC_FIRST |
+		   MTK_DESC_CT_LEN(sha->ct_size);
+	cmd->buf = cpu_to_le32(sg_dma_address(ctx->sg));
+	cmd->ct = cpu_to_le32(sha->ct_dma);
+	cmd->ct_hdr = sha->ct_hdr;
+	cmd->tfm = cpu_to_le32(sha->tfm_dma);
+
+	if (++ring->pos == MTK_DESC_NUM)
+		ring->pos = 0;
+
+	cmd = ring->cmd_base + ring->pos;
+	res = ring->res_base + ring->pos;
+
+	res->hdr = MTK_DESC_BUF_LEN(len2) | MTK_DESC_LAST;
+	res->buf = cpu_to_le32(cryp->tmp_dma);
+
+	cmd->hdr = MTK_DESC_BUF_LEN(len2) | MTK_DESC_LAST;
+	cmd->buf = cpu_to_le32(ctx->dma_addr);
+
+	if (++ring->pos == MTK_DESC_NUM)
+		ring->pos = 0;
+
+	/*
+	 * Make sure that all changes to the DMA ring are done before we
+	 * start engine.
+	 */
+	wmb();
+	/* Start DMA transfer */
+	mtk_sha_write(cryp, RDR_PREP_COUNT(sha->id), MTK_DESC_CNT(2));
+	mtk_sha_write(cryp, CDR_PREP_COUNT(sha->id), MTK_DESC_CNT(2));
+
+	return -EINPROGRESS;
+}
+
+static int mtk_sha_dma_map(struct mtk_cryp *cryp,
+			   struct mtk_sha_rec *sha,
+			   struct mtk_sha_reqctx *ctx,
+			   size_t count)
+{
+	ctx->dma_addr = dma_map_single(cryp->dev, ctx->buffer,
+				SHA_BUF_SIZE, DMA_TO_DEVICE);
+	if (unlikely(dma_mapping_error(cryp->dev, ctx->dma_addr))) {
+		dev_err(cryp->dev, "dma map error\n");
+		return -EINVAL;
+	}
+
+	ctx->flags &= ~SHA_FLAGS_SG;
+
+	return mtk_sha_xmit(cryp, sha, ctx->dma_addr, count);
+}
+
+static int mtk_sha_update_slow(struct mtk_cryp *cryp,
+			       struct mtk_sha_rec *sha)
+{
+	struct mtk_sha_reqctx *ctx = ahash_request_ctx(sha->req);
+	size_t count;
+	u32 final;
+
+	mtk_sha_append_sg(ctx);
+
+	final = (ctx->flags & SHA_FLAGS_FINUP) && !ctx->total;
+
+	dev_dbg(cryp->dev, "slow: bufcnt: %u\n", ctx->bufcnt);
+
+	if (final) {
+		sha->flags |= SHA_FLAGS_FINAL;
+		mtk_sha_fill_padding(ctx, 0);
+	}
+
+	if (final || (ctx->bufcnt == SHA_BUF_SIZE && ctx->total)) {
+		count = ctx->bufcnt;
+		ctx->bufcnt = 0;
+
+		return mtk_sha_dma_map(cryp, sha, ctx, count);
+	}
+	return 0;
+}
+
+static int mtk_sha_update_start(struct mtk_cryp *cryp,
+				struct mtk_sha_rec *sha)
+{
+	struct mtk_sha_reqctx *ctx = ahash_request_ctx(sha->req);
+	u32 len, final, tail;
+	struct scatterlist *sg;
+
+	if (!ctx->total)
+		return 0;
+
+	if (ctx->bufcnt || ctx->offset)
+		return mtk_sha_update_slow(cryp, sha);
+
+	sg = ctx->sg;
+
+	if (!IS_ALIGNED(sg->offset, sizeof(u32)))
+		return mtk_sha_update_slow(cryp, sha);
+
+	if (!sg_is_last(sg) && !IS_ALIGNED(sg->length, ctx->bs))
+		/* size is not ctx->bs aligned */
+		return mtk_sha_update_slow(cryp, sha);
+
+	len = min(ctx->total, sg->length);
+
+	if (sg_is_last(sg)) {
+		if (!(ctx->flags & SHA_FLAGS_FINUP)) {
+			/* not last sg must be ctx->bs aligned */
+			tail = len & (ctx->bs - 1);
+			len -= tail;
+		}
+	}
+
+	ctx->total -= len;
+	ctx->offset = len; /* offset where to start slow */
+
+	final = (ctx->flags & SHA_FLAGS_FINUP) && !ctx->total;
+
+	/* Add padding */
+	if (final) {
+		size_t count;
+
+		tail = len & (ctx->bs - 1);
+		len -= tail;
+		ctx->total += tail;
+		ctx->offset = len; /* offset where to start slow */
+
+		sg = ctx->sg;
+		mtk_sha_append_sg(ctx);
+		mtk_sha_fill_padding(ctx, len);
+
+		ctx->dma_addr = dma_map_single(cryp->dev, ctx->buffer,
+			SHA_BUF_SIZE, DMA_TO_DEVICE);
+		if (unlikely(dma_mapping_error(cryp->dev, ctx->dma_addr))) {
+			dev_err(cryp->dev, "dma map bytes error\n");
+			return -EINVAL;
+		}
+
+		sha->flags |= SHA_FLAGS_FINAL;
+		count = ctx->bufcnt;
+		ctx->bufcnt = 0;
+
+		if (len == 0) {
+			ctx->flags &= ~SHA_FLAGS_SG;
+			return mtk_sha_xmit(cryp, sha, ctx->dma_addr, count);
+
+		} else {
+			ctx->sg = sg;
+			if (!dma_map_sg(cryp->dev, ctx->sg, 1, DMA_TO_DEVICE)) {
+				dev_err(cryp->dev, "dma_map_sg error\n");
+				return -EINVAL;
+			}
+
+			ctx->flags |= SHA_FLAGS_SG;
+			return mtk_sha_xmit2(cryp, sha, ctx, len, count);
+		}
+	}
+
+	if (!dma_map_sg(cryp->dev, ctx->sg, 1, DMA_TO_DEVICE)) {
+		dev_err(cryp->dev, "dma_map_sg  error\n");
+		return -EINVAL;
+	}
+
+	ctx->flags |= SHA_FLAGS_SG;
+
+	return mtk_sha_xmit(cryp, sha, sg_dma_address(ctx->sg), len);
+}
+
+static int mtk_sha_final_req(struct mtk_cryp *cryp,
+			     struct mtk_sha_rec *sha)
+{
+	struct ahash_request *req = sha->req;
+	struct mtk_sha_reqctx *ctx = ahash_request_ctx(req);
+	size_t count;
+
+	mtk_sha_fill_padding(ctx, 0);
+
+	sha->flags |= SHA_FLAGS_FINAL;
+	count = ctx->bufcnt;
+	ctx->bufcnt = 0;
+
+	return mtk_sha_dma_map(cryp, sha, ctx, count);
+}
+
+/* Copy ready hash (+ finalize hmac) */
+static int mtk_sha_finish(struct ahash_request *req)
+{
+	struct mtk_sha_reqctx *ctx = ahash_request_ctx(req);
+	u32 *digest = ctx->info.tfm.digest;
+	u32 *result = (u32 *)req->result;
+	int i;
+
+	/* Get the hash from the digest buffer */
+	for (i = 0; i < SIZE_IN_WORDS(ctx->ds); i++)
+		result[i] = le32_to_cpu(digest[i]);
+
+	if (ctx->flags & SHA_FLAGS_HMAC)
+		return mtk_sha_finish_hmac(req);
+
+	return 0;
+}
+
+static void mtk_sha_finish_req(struct mtk_cryp *cryp,
+			       struct mtk_sha_rec *sha, int err)
+{
+	if (likely(!err && (SHA_FLAGS_FINAL & sha->flags)))
+		err = mtk_sha_finish(sha->req);
+
+	sha->flags &= ~(SHA_FLAGS_BUSY | SHA_FLAGS_FINAL);
+
+	sha->req->base.complete(&sha->req->base, err);
+
+	/* Handle new request */
+	mtk_sha_handle_queue(cryp, sha->id - RING2, NULL);
+}
+
+static int mtk_sha_handle_queue(struct mtk_cryp *cryp, u8 id,
+				struct ahash_request *req)
+{
+	struct mtk_sha_rec *sha = cryp->sha[id];
+	struct crypto_async_request *async_req, *backlog;
+	struct mtk_sha_reqctx *ctx;
+	unsigned long flags;
+	int err = 0, ret = 0;
+
+	spin_lock_irqsave(&sha->lock, flags);
+	if (req)
+		ret = ahash_enqueue_request(&sha->queue, req);
+
+	if (SHA_FLAGS_BUSY & sha->flags) {
+		spin_unlock_irqrestore(&sha->lock, flags);
+		return ret;
+	}
+
+	backlog = crypto_get_backlog(&sha->queue);
+	async_req = crypto_dequeue_request(&sha->queue);
+	if (async_req)
+		sha->flags |= SHA_FLAGS_BUSY;
+	spin_unlock_irqrestore(&sha->lock, flags);
+
+	if (!async_req)
+		return ret;
+
+	if (backlog)
+		backlog->complete(backlog, -EINPROGRESS);
+
+	req = ahash_request_cast(async_req);
+	ctx = ahash_request_ctx(req);
+
+	sha->req = req;
+	sha->info = &ctx->info;
+
+	mtk_sha_info_init(sha, ctx);
+
+	if (ctx->op == SHA_OP_UPDATE) {
+		err = mtk_sha_update_start(cryp, sha);
+		if (err != -EINPROGRESS && (ctx->flags & SHA_FLAGS_FINUP))
+			/* No final() after finup() */
+			err = mtk_sha_final_req(cryp, sha);
+	} else if (ctx->op == SHA_OP_FINAL) {
+		err = mtk_sha_final_req(cryp, sha);
+	}
+
+	if (unlikely(err != -EINPROGRESS))
+		/* Task will not finish it, so do it here */
+		mtk_sha_finish_req(cryp, sha, err);
+
+	return ret;
+}
+
+static int mtk_sha_enqueue(struct ahash_request *req, u32 op)
+{
+	struct mtk_sha_reqctx *ctx = ahash_request_ctx(req);
+	struct mtk_sha_ctx *tctx = crypto_tfm_ctx(req->base.tfm);
+
+	ctx->op = op;
+
+	return mtk_sha_handle_queue(tctx->cryp, tctx->id, req);
+}
+
+static void mtk_sha_unmap(struct mtk_cryp *cryp, struct mtk_sha_rec *sha)
+{
+	struct mtk_sha_reqctx *ctx = ahash_request_ctx(sha->req);
+
+	dma_unmap_single(cryp->dev, sha->ct_dma,
+			 sizeof(struct mtk_sha_info), DMA_BIDIRECTIONAL);
+
+	if (ctx->flags & SHA_FLAGS_SG) {
+		dma_unmap_sg(cryp->dev, ctx->sg, 1, DMA_TO_DEVICE);
+		if (ctx->sg->length == ctx->offset) {
+			ctx->sg = sg_next(ctx->sg);
+			if (ctx->sg)
+				ctx->offset = 0;
+		}
+		if (ctx->flags & SHA_FLAGS_PAD) {
+			dma_unmap_single(cryp->dev, ctx->dma_addr,
+					 SHA_BUF_SIZE, DMA_TO_DEVICE);
+		}
+	} else
+		dma_unmap_single(cryp->dev, ctx->dma_addr,
+				 SHA_BUF_SIZE, DMA_TO_DEVICE);
+}
+
+static void mtk_sha_complete(struct mtk_cryp *cryp,
+			     struct mtk_sha_rec *sha)
+{
+	int err = 0;
+
+	err = mtk_sha_update_start(cryp, sha);
+	if (err != -EINPROGRESS)
+		mtk_sha_finish_req(cryp, sha, err);
+}
+
+static int mtk_sha_update(struct ahash_request *req)
+{
+	struct mtk_sha_reqctx *ctx = ahash_request_ctx(req);
+
+	ctx->total = req->nbytes;
+	ctx->sg = req->src;
+	ctx->offset = 0;
+
+	if ((ctx->bufcnt + ctx->total < SHA_BUF_SIZE) &&
+	    !(ctx->flags & SHA_FLAGS_FINUP))
+		return mtk_sha_append_sg(ctx);
+
+	return mtk_sha_enqueue(req, SHA_OP_UPDATE);
+}
+
+static int mtk_sha_final(struct ahash_request *req)
+{
+	struct mtk_sha_reqctx *ctx = ahash_request_ctx(req);
+
+	ctx->flags |= SHA_FLAGS_FINUP;
+
+	if (ctx->flags & SHA_FLAGS_PAD)
+		return mtk_sha_finish(req);
+
+	return mtk_sha_enqueue(req, SHA_OP_FINAL);
+}
+
+static int mtk_sha_finup(struct ahash_request *req)
+{
+	struct mtk_sha_reqctx *ctx = ahash_request_ctx(req);
+	int err1, err2;
+
+	ctx->flags |= SHA_FLAGS_FINUP;
+
+	err1 = mtk_sha_update(req);
+	if (err1 == -EINPROGRESS || err1 == -EBUSY)
+		return err1;
+	/*
+	 * final() has to be always called to cleanup resources
+	 * even if update() failed
+	 */
+	err2 = mtk_sha_final(req);
+
+	return err1 ?: err2;
+}
+
+static int mtk_sha_digest(struct ahash_request *req)
+{
+	return mtk_sha_init(req) ?: mtk_sha_finup(req);
+}
+
+static int mtk_sha_setkey(struct crypto_ahash *tfm,
+			  const unsigned char *key, u32 keylen)
+{
+	struct mtk_sha_ctx *tctx = crypto_ahash_ctx(tfm);
+	struct mtk_sha_hmac_ctx *bctx = tctx->base;
+	size_t bs = crypto_shash_blocksize(bctx->shash);
+	size_t ds = crypto_shash_digestsize(bctx->shash);
+	int err, i;
+
+	SHASH_DESC_ON_STACK(shash, bctx->shash);
+
+	shash->tfm = bctx->shash;
+	shash->flags = crypto_shash_get_flags(bctx->shash) &
+			CRYPTO_TFM_REQ_MAY_SLEEP;
+
+	if (keylen > bs) {
+		err = crypto_shash_digest(shash, key, keylen, bctx->ipad);
+		if (err)
+			return err;
+		keylen = ds;
+	} else {
+		memcpy(bctx->ipad, key, keylen);
+	}
+
+	memset(bctx->ipad + keylen, 0, bs - keylen);
+	memcpy(bctx->opad, bctx->ipad, bs);
+
+	for (i = 0; i < bs; i++) {
+		bctx->ipad[i] ^= 0x36;
+		bctx->opad[i] ^= 0x5c;
+	}
+
+	return err;
+}
+
+static int mtk_sha_export(struct ahash_request *req, void *out)
+{
+	const struct mtk_sha_reqctx *ctx = ahash_request_ctx(req);
+
+	memcpy(out, ctx, sizeof(*ctx));
+	return 0;
+}
+
+static int mtk_sha_import(struct ahash_request *req, const void *in)
+{
+	struct mtk_sha_reqctx *ctx = ahash_request_ctx(req);
+
+	memcpy(ctx, in, sizeof(*ctx));
+	return 0;
+}
+
+static int mtk_sha_cra_init_alg(struct crypto_tfm *tfm,
+				const char *alg_base)
+{
+	struct mtk_sha_ctx *tctx = crypto_tfm_ctx(tfm);
+	struct mtk_cryp *cryp = NULL;
+
+	cryp = mtk_sha_find_dev(tctx);
+	if (!cryp)
+		return -ENODEV;
+
+	crypto_ahash_set_reqsize(__crypto_ahash_cast(tfm),
+				 sizeof(struct mtk_sha_reqctx));
+
+	if (alg_base) {
+		struct mtk_sha_hmac_ctx *bctx = tctx->base;
+
+		tctx->flags |= SHA_FLAGS_HMAC;
+		bctx->shash = crypto_alloc_shash(alg_base, 0,
+					CRYPTO_ALG_NEED_FALLBACK);
+		if (IS_ERR(bctx->shash)) {
+			pr_err("base driver %s could not be loaded.\n",
+			       alg_base);
+
+			return PTR_ERR(bctx->shash);
+		}
+	}
+	return 0;
+}
+
+static int mtk_sha_cra_init(struct crypto_tfm *tfm)
+{
+	return mtk_sha_cra_init_alg(tfm, NULL);
+}
+
+static int mtk_sha_cra_sha1_init(struct crypto_tfm *tfm)
+{
+	return mtk_sha_cra_init_alg(tfm, "sha1");
+}
+
+static int mtk_sha_cra_sha224_init(struct crypto_tfm *tfm)
+{
+	return mtk_sha_cra_init_alg(tfm, "sha224");
+}
+
+static int mtk_sha_cra_sha256_init(struct crypto_tfm *tfm)
+{
+	return mtk_sha_cra_init_alg(tfm, "sha256");
+}
+
+static int mtk_sha_cra_sha384_init(struct crypto_tfm *tfm)
+{
+	return mtk_sha_cra_init_alg(tfm, "sha384");
+}
+
+static int mtk_sha_cra_sha512_init(struct crypto_tfm *tfm)
+{
+	return mtk_sha_cra_init_alg(tfm, "sha512");
+}
+
+static void mtk_sha_cra_exit(struct crypto_tfm *tfm)
+{
+	struct mtk_sha_ctx *tctx = crypto_tfm_ctx(tfm);
+
+	if (tctx->flags & SHA_FLAGS_HMAC) {
+		struct mtk_sha_hmac_ctx *bctx = tctx->base;
+
+		crypto_free_shash(bctx->shash);
+	}
+}
+
+static struct ahash_alg algs_sha1_sha224_sha256[] = {
+{
+	.init		= mtk_sha_init,
+	.update		= mtk_sha_update,
+	.final		= mtk_sha_final,
+	.finup		= mtk_sha_finup,
+	.digest		= mtk_sha_digest,
+	.export		= mtk_sha_export,
+	.import		= mtk_sha_import,
+	.halg.digestsize	= SHA1_DIGEST_SIZE,
+	.halg.statesize = sizeof(struct mtk_sha_reqctx),
+	.halg.base	= {
+		.cra_name		= "sha1",
+		.cra_driver_name	= "mtk-sha1",
+		.cra_priority		= 400,
+		.cra_flags		= CRYPTO_ALG_ASYNC,
+		.cra_blocksize		= SHA1_BLOCK_SIZE,
+		.cra_ctxsize		= sizeof(struct mtk_sha_ctx),
+		.cra_alignmask		= SHA_ALIGN_MSK,
+		.cra_module		= THIS_MODULE,
+		.cra_init		= mtk_sha_cra_init,
+		.cra_exit		= mtk_sha_cra_exit,
+	}
+},
+{
+	.init		= mtk_sha_init,
+	.update		= mtk_sha_update,
+	.final		= mtk_sha_final,
+	.finup		= mtk_sha_finup,
+	.digest		= mtk_sha_digest,
+	.export		= mtk_sha_export,
+	.import		= mtk_sha_import,
+	.halg.digestsize	= SHA224_DIGEST_SIZE,
+	.halg.statesize = sizeof(struct mtk_sha_reqctx),
+	.halg.base	= {
+		.cra_name		= "sha224",
+		.cra_driver_name	= "mtk-sha224",
+		.cra_priority		= 400,
+		.cra_flags		= CRYPTO_ALG_ASYNC,
+		.cra_blocksize		= SHA224_BLOCK_SIZE,
+		.cra_ctxsize		= sizeof(struct mtk_sha_ctx),
+		.cra_alignmask		= SHA_ALIGN_MSK,
+		.cra_module		= THIS_MODULE,
+		.cra_init		= mtk_sha_cra_init,
+		.cra_exit		= mtk_sha_cra_exit,
+	}
+},
+{
+	.init		= mtk_sha_init,
+	.update		= mtk_sha_update,
+	.final		= mtk_sha_final,
+	.finup		= mtk_sha_finup,
+	.digest		= mtk_sha_digest,
+	.export		= mtk_sha_export,
+	.import		= mtk_sha_import,
+	.halg.digestsize	= SHA256_DIGEST_SIZE,
+	.halg.statesize = sizeof(struct mtk_sha_reqctx),
+	.halg.base	= {
+		.cra_name		= "sha256",
+		.cra_driver_name	= "mtk-sha256",
+		.cra_priority		= 400,
+		.cra_flags		= CRYPTO_ALG_ASYNC,
+		.cra_blocksize		= SHA256_BLOCK_SIZE,
+		.cra_ctxsize		= sizeof(struct mtk_sha_ctx),
+		.cra_alignmask		= SHA_ALIGN_MSK,
+		.cra_module		= THIS_MODULE,
+		.cra_init		= mtk_sha_cra_init,
+		.cra_exit		= mtk_sha_cra_exit,
+	}
+},
+{
+	.init		= mtk_sha_init,
+	.update		= mtk_sha_update,
+	.final		= mtk_sha_final,
+	.finup		= mtk_sha_finup,
+	.digest		= mtk_sha_digest,
+	.export		= mtk_sha_export,
+	.import		= mtk_sha_import,
+	.setkey		= mtk_sha_setkey,
+	.halg.digestsize	= SHA1_DIGEST_SIZE,
+	.halg.statesize = sizeof(struct mtk_sha_reqctx),
+	.halg.base	= {
+		.cra_name		= "hmac(sha1)",
+		.cra_driver_name	= "mtk-hmac-sha1",
+		.cra_priority		= 400,
+		.cra_flags		= CRYPTO_ALG_ASYNC |
+					  CRYPTO_ALG_NEED_FALLBACK,
+		.cra_blocksize		= SHA1_BLOCK_SIZE,
+		.cra_ctxsize		= sizeof(struct mtk_sha_ctx) +
+					sizeof(struct mtk_sha_hmac_ctx),
+		.cra_alignmask		= SHA_ALIGN_MSK,
+		.cra_module		= THIS_MODULE,
+		.cra_init		= mtk_sha_cra_sha1_init,
+		.cra_exit		= mtk_sha_cra_exit,
+	}
+},
+{
+	.init		= mtk_sha_init,
+	.update		= mtk_sha_update,
+	.final		= mtk_sha_final,
+	.finup		= mtk_sha_finup,
+	.digest		= mtk_sha_digest,
+	.export		= mtk_sha_export,
+	.import		= mtk_sha_import,
+	.setkey		= mtk_sha_setkey,
+	.halg.digestsize	= SHA224_DIGEST_SIZE,
+	.halg.statesize = sizeof(struct mtk_sha_reqctx),
+	.halg.base	= {
+		.cra_name		= "hmac(sha224)",
+		.cra_driver_name	= "mtk-hmac-sha224",
+		.cra_priority		= 400,
+		.cra_flags		= CRYPTO_ALG_ASYNC |
+					  CRYPTO_ALG_NEED_FALLBACK,
+		.cra_blocksize		= SHA224_BLOCK_SIZE,
+		.cra_ctxsize		= sizeof(struct mtk_sha_ctx) +
+					sizeof(struct mtk_sha_hmac_ctx),
+		.cra_alignmask		= SHA_ALIGN_MSK,
+		.cra_module		= THIS_MODULE,
+		.cra_init		= mtk_sha_cra_sha224_init,
+		.cra_exit		= mtk_sha_cra_exit,
+	}
+},
+{
+	.init		= mtk_sha_init,
+	.update		= mtk_sha_update,
+	.final		= mtk_sha_final,
+	.finup		= mtk_sha_finup,
+	.digest		= mtk_sha_digest,
+	.export		= mtk_sha_export,
+	.import		= mtk_sha_import,
+	.setkey		= mtk_sha_setkey,
+	.halg.digestsize	= SHA256_DIGEST_SIZE,
+	.halg.statesize = sizeof(struct mtk_sha_reqctx),
+	.halg.base	= {
+		.cra_name		= "hmac(sha256)",
+		.cra_driver_name	= "mtk-hmac-sha256",
+		.cra_priority		= 400,
+		.cra_flags		= CRYPTO_ALG_ASYNC |
+					  CRYPTO_ALG_NEED_FALLBACK,
+		.cra_blocksize		= SHA256_BLOCK_SIZE,
+		.cra_ctxsize		= sizeof(struct mtk_sha_ctx) +
+					sizeof(struct mtk_sha_hmac_ctx),
+		.cra_alignmask		= SHA_ALIGN_MSK,
+		.cra_module		= THIS_MODULE,
+		.cra_init		= mtk_sha_cra_sha256_init,
+		.cra_exit		= mtk_sha_cra_exit,
+	}
+},
+};
+
+static struct ahash_alg algs_sha384_sha512[] = {
+{
+	.init		= mtk_sha_init,
+	.update		= mtk_sha_update,
+	.final		= mtk_sha_final,
+	.finup		= mtk_sha_finup,
+	.digest		= mtk_sha_digest,
+	.export		= mtk_sha_export,
+	.import		= mtk_sha_import,
+	.halg.digestsize	= SHA384_DIGEST_SIZE,
+	.halg.statesize = sizeof(struct mtk_sha_reqctx),
+	.halg.base	= {
+		.cra_name		= "sha384",
+		.cra_driver_name	= "mtk-sha384",
+		.cra_priority		= 400,
+		.cra_flags		= CRYPTO_ALG_ASYNC,
+		.cra_blocksize		= SHA384_BLOCK_SIZE,
+		.cra_ctxsize		= sizeof(struct mtk_sha_ctx),
+		.cra_alignmask		= SHA_ALIGN_MSK,
+		.cra_module		= THIS_MODULE,
+		.cra_init		= mtk_sha_cra_init,
+		.cra_exit		= mtk_sha_cra_exit,
+	}
+},
+{
+	.init		= mtk_sha_init,
+	.update		= mtk_sha_update,
+	.final		= mtk_sha_final,
+	.finup		= mtk_sha_finup,
+	.digest		= mtk_sha_digest,
+	.export		= mtk_sha_export,
+	.import		= mtk_sha_import,
+	.halg.digestsize	= SHA512_DIGEST_SIZE,
+	.halg.statesize = sizeof(struct mtk_sha_reqctx),
+	.halg.base	= {
+		.cra_name		= "sha512",
+		.cra_driver_name	= "mtk-sha512",
+		.cra_priority		= 400,
+		.cra_flags		= CRYPTO_ALG_ASYNC,
+		.cra_blocksize		= SHA512_BLOCK_SIZE,
+		.cra_ctxsize		= sizeof(struct mtk_sha_ctx),
+		.cra_alignmask		= SHA_ALIGN_MSK,
+		.cra_module		= THIS_MODULE,
+		.cra_init		= mtk_sha_cra_init,
+		.cra_exit		= mtk_sha_cra_exit,
+	}
+},
+{
+	.init		= mtk_sha_init,
+	.update		= mtk_sha_update,
+	.final		= mtk_sha_final,
+	.finup		= mtk_sha_finup,
+	.digest		= mtk_sha_digest,
+	.export		= mtk_sha_export,
+	.import		= mtk_sha_import,
+	.setkey		= mtk_sha_setkey,
+	.halg.digestsize	= SHA384_DIGEST_SIZE,
+	.halg.statesize = sizeof(struct mtk_sha_reqctx),
+	.halg.base	= {
+		.cra_name		= "hmac(sha384)",
+		.cra_driver_name	= "mtk-hmac-sha384",
+		.cra_priority		= 400,
+		.cra_flags		= CRYPTO_ALG_ASYNC |
+					  CRYPTO_ALG_NEED_FALLBACK,
+		.cra_blocksize		= SHA384_BLOCK_SIZE,
+		.cra_ctxsize		= sizeof(struct mtk_sha_ctx) +
+					sizeof(struct mtk_sha_hmac_ctx),
+		.cra_alignmask		= SHA_ALIGN_MSK,
+		.cra_module		= THIS_MODULE,
+		.cra_init		= mtk_sha_cra_sha384_init,
+		.cra_exit		= mtk_sha_cra_exit,
+	}
+},
+{
+	.init		= mtk_sha_init,
+	.update		= mtk_sha_update,
+	.final		= mtk_sha_final,
+	.finup		= mtk_sha_finup,
+	.digest		= mtk_sha_digest,
+	.export		= mtk_sha_export,
+	.import		= mtk_sha_import,
+	.setkey		= mtk_sha_setkey,
+	.halg.digestsize	= SHA512_DIGEST_SIZE,
+	.halg.statesize = sizeof(struct mtk_sha_reqctx),
+	.halg.base	= {
+		.cra_name		= "hmac(sha512)",
+		.cra_driver_name	= "mtk-hmac-sha512",
+		.cra_priority		= 400,
+		.cra_flags		= CRYPTO_ALG_ASYNC |
+					  CRYPTO_ALG_NEED_FALLBACK,
+		.cra_blocksize		= SHA512_BLOCK_SIZE,
+		.cra_ctxsize		= sizeof(struct mtk_sha_ctx) +
+					sizeof(struct mtk_sha_hmac_ctx),
+		.cra_alignmask		= SHA_ALIGN_MSK,
+		.cra_module		= THIS_MODULE,
+		.cra_init		= mtk_sha_cra_sha512_init,
+		.cra_exit		= mtk_sha_cra_exit,
+	}
+},
+};
+
+static void mtk_sha_task0(unsigned long data)
+{
+	struct mtk_cryp *cryp = (struct mtk_cryp *)data;
+	struct mtk_sha_rec *sha = cryp->sha[0];
+
+	mtk_sha_unmap(cryp, sha);
+	mtk_sha_complete(cryp, sha);
+}
+
+static void mtk_sha_task1(unsigned long data)
+{
+	struct mtk_cryp *cryp = (struct mtk_cryp *)data;
+	struct mtk_sha_rec *sha = cryp->sha[1];
+
+	mtk_sha_unmap(cryp, sha);
+	mtk_sha_complete(cryp, sha);
+}
+
+static irqreturn_t mtk_sha_ring2_irq(int irq, void *dev_id)
+{
+	struct mtk_cryp *cryp = (struct mtk_cryp *)dev_id;
+	struct mtk_sha_rec *sha = cryp->sha[0];
+	u32 val = mtk_sha_read(cryp, RDR_STAT(RING2));
+
+	mtk_sha_write(cryp, RDR_STAT(RING2), val);
+
+	if (likely((SHA_FLAGS_BUSY & sha->flags))) {
+		mtk_sha_write(cryp, RDR_PROC_COUNT(RING2), MTK_CNT_RST);
+		mtk_sha_write(cryp, RDR_THRESH(RING2),
+			      MTK_RDR_PROC_THRESH | MTK_RDR_PROC_MODE);
+
+		tasklet_schedule(&sha->task);
+	} else {
+		dev_warn(cryp->dev, "AES interrupt when no active requests.\n");
+	}
+	return IRQ_HANDLED;
+}
+
+static irqreturn_t mtk_sha_ring3_irq(int irq, void *dev_id)
+{
+	struct mtk_cryp *cryp = (struct mtk_cryp *)dev_id;
+	struct mtk_sha_rec *sha = cryp->sha[1];
+	u32 val = mtk_sha_read(cryp, RDR_STAT(RING3));
+
+	mtk_sha_write(cryp, RDR_STAT(RING3), val);
+
+	if (likely((SHA_FLAGS_BUSY & sha->flags))) {
+		mtk_sha_write(cryp, RDR_PROC_COUNT(RING3), MTK_CNT_RST);
+		mtk_sha_write(cryp, RDR_THRESH(RING3),
+			      MTK_RDR_PROC_THRESH | MTK_RDR_PROC_MODE);
+
+		tasklet_schedule(&sha->task);
+	} else {
+		dev_warn(cryp->dev, "AES interrupt when no active requests.\n");
+	}
+	return IRQ_HANDLED;
+}
+
+/*
+ * The purpose of two SHA records is used to get extra performance.
+ * It is similar to mtk_aes_record_init().
+ */
+static int mtk_sha_record_init(struct mtk_cryp *cryp)
+{
+	struct mtk_sha_rec **sha = cryp->sha;
+	int i, err = -ENOMEM;
+
+	for (i = 0; i < MTK_REC_NUM; i++) {
+		sha[i] = kzalloc(sizeof(**sha), GFP_KERNEL);
+		if (!sha[i])
+			goto err_cleanup;
+
+		sha[i]->id = i + RING2;
+
+		spin_lock_init(&sha[i]->lock);
+		crypto_init_queue(&sha[i]->queue, SHA_QUEUE_SIZE);
+	}
+
+	tasklet_init(&sha[0]->task, mtk_sha_task0, (unsigned long)cryp);
+	tasklet_init(&sha[1]->task, mtk_sha_task1, (unsigned long)cryp);
+
+	cryp->rec = 1;
+
+	return 0;
+
+err_cleanup:
+	for (; i--; )
+		kfree(sha[i]);
+	return err;
+}
+
+static void mtk_sha_record_free(struct mtk_cryp *cryp)
+{
+	int i;
+
+	for (i = 0; i < MTK_REC_NUM; i++) {
+		tasklet_kill(&cryp->sha[i]->task);
+		kfree(cryp->sha[i]);
+	}
+}
+
+static void mtk_sha_unregister_algs(void)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(algs_sha1_sha224_sha256); i++)
+		crypto_unregister_ahash(&algs_sha1_sha224_sha256[i]);
+
+	for (i = 0; i < ARRAY_SIZE(algs_sha384_sha512); i++)
+		crypto_unregister_ahash(&algs_sha384_sha512[i]);
+}
+
+static int mtk_sha_register_algs(void)
+{
+	int err, i;
+
+	for (i = 0; i < ARRAY_SIZE(algs_sha1_sha224_sha256); i++) {
+		err = crypto_register_ahash(&algs_sha1_sha224_sha256[i]);
+		if (err)
+			goto err_sha_224_256_algs;
+	}
+
+	for (i = 0; i < ARRAY_SIZE(algs_sha384_sha512); i++) {
+		err = crypto_register_ahash(&algs_sha384_sha512[i]);
+		if (err)
+			goto err_sha_384_512_algs;
+	}
+
+	return 0;
+
+err_sha_384_512_algs:
+	for (; i--; )
+		crypto_unregister_ahash(&algs_sha384_sha512[i]);
+	i = ARRAY_SIZE(algs_sha1_sha224_sha256);
+err_sha_224_256_algs:
+	for (; i--; )
+		crypto_unregister_ahash(&algs_sha1_sha224_sha256[i]);
+
+	return err;
+}
+
+int mtk_hash_alg_register(struct mtk_cryp *cryp)
+{
+	int err;
+
+	INIT_LIST_HEAD(&cryp->sha_list);
+
+	/* Initialize two hash records */
+	err = mtk_sha_record_init(cryp);
+	if (err)
+		goto err_record;
+
+	/* Ring2 is use by SHA record0 */
+	err = devm_request_irq(cryp->dev, cryp->irq[RING2],
+			       mtk_sha_ring2_irq, IRQF_TRIGGER_LOW,
+			       "mtk-sha", cryp);
+	if (err) {
+		dev_err(cryp->dev, "unable to request sha irq0.\n");
+		goto err_res;
+	}
+
+	/* Ring3 is use by SHA record1 */
+	err = devm_request_irq(cryp->dev, cryp->irq[RING3],
+			       mtk_sha_ring3_irq, IRQF_TRIGGER_LOW,
+			       "mtk-sha", cryp);
+	if (err) {
+		dev_err(cryp->dev, "unable to request sha irq1.\n");
+		goto err_res;
+	}
+
+	/* Enable ring2 and ring3 interrupt for hash */
+	mtk_sha_write(cryp, AIC_ENABLE_SET(RING2), MTK_IRQ_RDR2);
+	mtk_sha_write(cryp, AIC_ENABLE_SET(RING3), MTK_IRQ_RDR3);
+
+	cryp->tmp = dma_alloc_coherent(cryp->dev, SHA_TMP_BUF_SIZE,
+					&cryp->tmp_dma, GFP_KERNEL);
+	if (!cryp->tmp) {
+		dev_err(cryp->dev, "unable to allocate tmp buffer.\n");
+		err = -EINVAL;
+		goto err_res;
+	}
+
+	spin_lock(&mtk_sha.lock);
+	list_add_tail(&cryp->sha_list, &mtk_sha.dev_list);
+	spin_unlock(&mtk_sha.lock);
+
+	err = mtk_sha_register_algs();
+	if (err)
+		goto err_algs;
+
+	return 0;
+
+err_algs:
+	spin_lock(&mtk_sha.lock);
+	list_del(&cryp->sha_list);
+	spin_unlock(&mtk_sha.lock);
+	dma_free_coherent(cryp->dev, SHA_TMP_BUF_SIZE,
+			  cryp->tmp, cryp->tmp_dma);
+err_res:
+	mtk_sha_record_free(cryp);
+err_record:
+
+	dev_err(cryp->dev, "mtk-sha initialization failed.\n");
+	return err;
+}
+
+void mtk_hash_alg_release(struct mtk_cryp *cryp)
+{
+	spin_lock(&mtk_sha.lock);
+	list_del(&cryp->sha_list);
+	spin_unlock(&mtk_sha.lock);
+
+	mtk_sha_unregister_algs();
+	dma_free_coherent(cryp->dev, SHA_TMP_BUF_SIZE,
+			  cryp->tmp, cryp->tmp_dma);
+	mtk_sha_record_free(cryp);
+}
-- 
1.9.1
