Received: from lelvem-ot02.ext.ti.com (lelvem-ot02.ext.ti.com [198.47.23.235])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C38B2376E0;
	Tue, 18 Feb 2025 10:50:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.47.23.235
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739875849; cv=none; b=omfYKh79Z9ddXpeIoO+xT4DeeiB7lwtUiZJCHPtSId3iAHFOcQLykMJw8kGnF2l7pncBR7pbLBTlBNqP9ne0AQRfdi9tv8ZFb4VlFP6Sgb/KJypKjpslRsUbAUXnE9xTImBh2SYY0ay/9dph/mVEJc52IDiALNQlrB8NLa2td3k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739875849; c=relaxed/simple;
	bh=MjD5U9x66TlOrVAFJv4Rs+B+j3aGhOizucaYBE3Lbqc=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=I3BRkk577O+URien1lwvIju/lc6W7LAtsWxoymxINe6kGaav3Ci88genDfLeQfP9Ql1Znp+PVube3loubDzpxWJ7Uzwsro12S7nC3uwgq+vY1wKEBFlTS4DPXpRSZq22uCAGSbGdvDzl32BUnEQT2GjuorrZLce4rCw8tFuLZ+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b=Cm/C3y5n; arc=none smtp.client-ip=198.47.23.235
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="Cm/C3y5n"
Received: from lelv0266.itg.ti.com ([10.180.67.225])
	by lelvem-ot02.ext.ti.com (8.15.2/8.15.2) with ESMTPS id 51IAodM8841358
	(version=TLSv1.2 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
	Tue, 18 Feb 2025 04:50:40 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
	s=ti-com-17Q1; t=1739875840;
	bh=/VGh9WIW3r5L1e5lccjuES18Z8dzeznPtWHsfmhnHo8=;
	h=From:To:CC:Subject:Date:In-Reply-To:References;
	b=Cm/C3y5nherVZwg69+A1/856x2yIN59DmwNdp9auO8NbuySb1Ng3sWDlE2NoJKrem
	 LRS/eX3oiAZ1W7PodWyHNosQFOAtGm7tRE2m4LJXyl3g5soa6Tp234POipB2M9aGUD
	 Q3caIOFinRuKix0CBgP0R3dGyxmdx2y+QVzP1nes=
Received: from DFLE103.ent.ti.com (dfle103.ent.ti.com [10.64.6.24])
	by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTP id 51IAodnA034472;
	Tue, 18 Feb 2025 04:50:39 -0600
Received: from DFLE100.ent.ti.com (10.64.6.21) by DFLE103.ent.ti.com
 (10.64.6.24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.23; Tue, 18
 Feb 2025 04:50:39 -0600
Received: from lelvsmtp6.itg.ti.com (10.180.75.249) by DFLE100.ent.ti.com
 (10.64.6.21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.23 via
 Frontend Transport; Tue, 18 Feb 2025 04:50:39 -0600
Received: from pratham-Workstation-PC (pratham-workstation-pc.dhcp.ti.com [172.24.227.40])
	by lelvsmtp6.itg.ti.com (8.15.2/8.15.2) with ESMTP id 51IAobne130899;
	Tue, 18 Feb 2025 04:50:38 -0600
From: T Pratham <t-pratham@ti.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller"
	<davem@davemloft.net>, T Pratham <t-pratham@ti.com>
CC: <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Vignesh
 Raghavendra <vigneshr@ti.com>,
        Praneeth Bajjuri <praneeth@ti.com>,
        Kamlesh
 Gurudasani <kamlesh@ti.com>,
        Manorit Chawdhry <m-chawdhry@ti.com>
Subject: [PATCH RFC 1/2] crypto: ti: Add support for SHA224/256/384/512 in DTHE V2 driver
Date: Tue, 18 Feb 2025 16:19:42 +0530
Message-ID: <20250218104943.2304730-2-t-pratham@ti.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250218104943.2304730-1-t-pratham@ti.com>
References: <20250218104943.2304730-1-t-pratham@ti.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-C2ProcessedOrg: 333ef613-75bf-4e12-a4b1-8e3623f5dcea

Add support for SHA224, SHA256, SHA384, SHA512 algorithms in the Hashing
Engine of the DTHE v2 hardware crypto accelerator driver.

Signed-off-by: T Pratham <t-pratham@ti.com>
---
 drivers/crypto/ti/Kconfig  |   2 +
 drivers/crypto/ti/dthev2.c | 864 ++++++++++++++++++++++++++++++++++++-
 2 files changed, 855 insertions(+), 11 deletions(-)

diff --git a/drivers/crypto/ti/Kconfig b/drivers/crypto/ti/Kconfig
index c0f013336425..39d9d8cb6b78 100644
--- a/drivers/crypto/ti/Kconfig
+++ b/drivers/crypto/ti/Kconfig
@@ -4,6 +4,8 @@ config CRYPTO_DEV_TI_DTHE_V2
 	tristate "Support for TI DTHE V2 crypto accelerators"
 	depends on CRYPTO && CRYPTO_HW && ARCH_K3
 	select CRYPTO_SKCIPHER
+	select CRYPTO_SHA256
+	select CRYPTO_SHA512
 	help
 	  This enables support for the TI DTHE V2 hw crypto accelerator
 	  which can be found on TI K3 SOCs. Selecting this enables use
diff --git a/drivers/crypto/ti/dthev2.c b/drivers/crypto/ti/dthev2.c
index d610142dc5a7..d5ed0f4621f5 100644
--- a/drivers/crypto/ti/dthev2.c
+++ b/drivers/crypto/ti/dthev2.c
@@ -33,6 +33,19 @@
 
 /* Registers */
 
+// Hashing Engine
+#define DTHE_P_HASH_BASE		0x5000
+#define DTHE_P_HASH512_IDIGEST_A	0x0240
+#define DTHE_P_HASH512_DIGEST_COUNT	0x0280
+#define DTHE_P_HASH512_MODE		0x0284
+#define DTHE_P_HASH512_LENGTH		0x0288
+#define DTHE_P_HASH512_DATA_IN_START	0x0080
+#define DTHE_P_HASH512_DATA_IN_END	0x00FC
+
+#define DTHE_P_HASH_SYSCONFIG	0x0110
+#define DTHE_P_HASH_IRQSTATUS	0x0118
+#define DTHE_P_HASH_IRQENABLE	0x011C
+
 // AES Engine
 #define DTHE_P_AES_BASE		0x7000
 #define DTHE_P_AES_KEY1_0	0x0038
@@ -58,6 +71,26 @@
 #define DTHE_P_AES_IRQENABLE	0x0090
 
 /* Register write values and macros */
+enum dthe_hash_algSel {
+	DTHE_HASH_MD5		= 0,
+	DTHE_HASH_SHA1		= BIT(1),
+	DTHE_HASH_SHA224	= BIT(2),
+	DTHE_HASH_SHA256	= BIT(1) | BIT(2),
+	DTHE_HASH_SHA384	= BIT(0),
+	DTHE_HASH_SHA512	= BIT(0) | BIT(1)
+};
+
+#define DTHE_HASH_SYSCONFIG_INT_EN		BIT(2)
+#define DTHE_HASH_SYSCONFIG_DMA_EN		BIT(3)
+#define DTHE_HASH_IRQENABLE_EN_ALL		GENMASK(3, 0)
+#define DTHE_HASH_IRQSTATUS_OP_READY		BIT(0)
+#define DTHE_HASH_IRQSTATUS_IP_READY		BIT(1)
+#define DTHE_HASH_IRQSTATUS_PH_READY		BIT(2)
+#define DTHE_HASH_IRQSTATUS_CTX_READY		BIT(3)
+
+#define DTHE_HASH_MODE_USE_ALG_CONST		BIT(3)
+#define DTHE_HASH_MODE_CLOSE_HASH		BIT(4)
+
 enum dthe_aes_mode {
 	DTHE_AES_ECB = 0,
 	DTHE_AES_CBC,
@@ -99,6 +132,7 @@ struct dthe_tfm_ctx;
  * @dma_aes_tx: AES Tx DMA Channel
  * @dma_sha_tx: SHA Tx DMA Channel
  * @aes_mutex: Mutex protecting access to AES engine
+ * @hash_mutex: Mutex protecting access to HASH engine
  * @ctx: Transform context struct
  */
 struct dthe_data {
@@ -112,6 +146,7 @@ struct dthe_data {
 	struct dma_chan *dma_sha_tx;
 
 	struct mutex aes_mutex;
+	struct mutex hash_mutex;
 
 	struct dthe_tfm_ctx *ctx;
 };
@@ -126,6 +161,32 @@ struct dthe_list {
 	spinlock_t lock;
 };
 
+/**
+ * struct dthe_hash_ctx - Hashing engine ctx struct
+ * @mode: Hashing Engine mode
+ * @block_size: block size of hash algorithm selected
+ * @digest_size: digest size of hash algorithm selected
+ * @phash_available: flag indicating if a partial hash from a previous operation is available
+ * @phash: buffer to store a partial hash from a previous operation
+ * @phash_size: partial hash size of the hash algorithm selected
+ * @digestcnt: stores the digest count from a previous operation
+ * @data_buf: buffer to store part of input data to be carried over to next operation
+ * @buflen: length of input data stored in data_buf
+ * @hash_compl: Completion variable for use in manual completion in case of DMA callback failure
+ */
+struct dthe_hash_ctx {
+	enum dthe_hash_algSel mode;
+	u16 block_size;
+	u8 digest_size;
+	u8 phash_available;
+	u32 phash[SHA512_DIGEST_SIZE / sizeof(u32)];
+	u32 phash_size;
+	u32 digestcnt;
+	u8 data_buf[SHA512_BLOCK_SIZE];
+	u8 buflen;
+	struct completion hash_compl;
+};
+
 /**
  * struct dthe_aes_ctx - AES engine ctx struct
  * @mode: AES mode
@@ -151,6 +212,7 @@ struct dthe_tfm_ctx {
 	struct dthe_data *dev_data;
 	union {
 		struct dthe_aes_ctx *aes_ctx;
+		struct dthe_hash_ctx *hash_ctx;
 	} ctx_info;
 };
 
@@ -201,6 +263,674 @@ static struct dthe_data *dthe_get_dev(struct dthe_tfm_ctx *ctx)
 	return dev_data;
 }
 
+static struct scatterlist *dthe_set_src_sg(struct scatterlist *src, struct scatterlist *sg,
+					   int nents, int buflen)
+{
+	struct scatterlist *from_sg, *to_sg;
+	int sglen;
+
+	sg_init_table(src, nents);
+
+	for (to_sg = src, from_sg = sg; buflen && from_sg; buflen -= sglen) {
+		sglen = from_sg->length;
+		if (sglen > buflen)
+			sglen = buflen;
+		sg_set_buf(to_sg, sg_virt(from_sg), sglen);
+		from_sg = sg_next(from_sg);
+		to_sg = sg_next(to_sg);
+	}
+
+	return to_sg;
+}
+
+/**********************************************************************
+ *				SHA
+ **********************************************************************/
+
+static int dthe_sha512_cra_init(struct crypto_tfm *tfm)
+{
+	struct dthe_tfm_ctx *ctx = crypto_tfm_ctx(tfm);
+	struct dthe_data *dev_data = dthe_get_dev(ctx);
+
+	if (!dev_data)
+		return -ENODEV;
+
+	ctx->ctx_info.hash_ctx = kzalloc(sizeof(*ctx->ctx_info.hash_ctx), GFP_KERNEL);
+	if (!ctx->ctx_info.hash_ctx)
+		return -ENOMEM;
+
+	ctx->ctx_info.hash_ctx->mode = DTHE_HASH_SHA512;
+	ctx->ctx_info.hash_ctx->block_size = SHA512_BLOCK_SIZE;
+	ctx->ctx_info.hash_ctx->digest_size = SHA512_DIGEST_SIZE;
+	ctx->ctx_info.hash_ctx->phash_size = SHA512_DIGEST_SIZE;
+	return 0;
+}
+
+static int dthe_sha384_cra_init(struct crypto_tfm *tfm)
+{
+	struct dthe_tfm_ctx *ctx = crypto_tfm_ctx(tfm);
+	struct dthe_data *dev_data = dthe_get_dev(ctx);
+
+	if (!dev_data)
+		return -ENODEV;
+
+	ctx->ctx_info.hash_ctx = kzalloc(sizeof(*ctx->ctx_info.hash_ctx), GFP_KERNEL);
+	if (!ctx->ctx_info.hash_ctx)
+		return -ENOMEM;
+
+	ctx->ctx_info.hash_ctx->mode = DTHE_HASH_SHA384;
+	ctx->ctx_info.hash_ctx->block_size = SHA384_BLOCK_SIZE;
+	ctx->ctx_info.hash_ctx->digest_size = SHA384_DIGEST_SIZE;
+	ctx->ctx_info.hash_ctx->phash_size = SHA512_DIGEST_SIZE;
+	return 0;
+}
+
+static int dthe_sha256_cra_init(struct crypto_tfm *tfm)
+{
+	struct dthe_tfm_ctx *ctx = crypto_tfm_ctx(tfm);
+	struct dthe_data *dev_data = dthe_get_dev(ctx);
+
+	if (!dev_data)
+		return -ENODEV;
+
+	ctx->ctx_info.hash_ctx = kzalloc(sizeof(*ctx->ctx_info.hash_ctx), GFP_KERNEL);
+	if (!ctx->ctx_info.hash_ctx)
+		return -ENOMEM;
+
+	ctx->ctx_info.hash_ctx->mode = DTHE_HASH_SHA256;
+	ctx->ctx_info.hash_ctx->block_size = SHA256_BLOCK_SIZE;
+	ctx->ctx_info.hash_ctx->digest_size = SHA256_DIGEST_SIZE;
+	ctx->ctx_info.hash_ctx->phash_size = SHA256_DIGEST_SIZE;
+	return 0;
+}
+
+static int dthe_sha224_cra_init(struct crypto_tfm *tfm)
+{
+	struct dthe_tfm_ctx *ctx = crypto_tfm_ctx(tfm);
+	struct dthe_data *dev_data = dthe_get_dev(ctx);
+
+	if (!dev_data)
+		return -ENODEV;
+
+	ctx->ctx_info.hash_ctx = kzalloc(sizeof(*ctx->ctx_info.hash_ctx), GFP_KERNEL);
+	if (!ctx->ctx_info.hash_ctx)
+		return -ENOMEM;
+
+	ctx->ctx_info.hash_ctx->mode = DTHE_HASH_SHA224;
+	ctx->ctx_info.hash_ctx->block_size = SHA224_BLOCK_SIZE;
+	ctx->ctx_info.hash_ctx->digest_size = SHA224_DIGEST_SIZE;
+	ctx->ctx_info.hash_ctx->phash_size = SHA256_DIGEST_SIZE;
+	return 0;
+}
+
+static void dthe_hash_cra_exit(struct crypto_tfm *tfm)
+{
+	struct dthe_tfm_ctx *ctx = crypto_tfm_ctx(tfm);
+
+	kfree(ctx->ctx_info.hash_ctx);
+}
+
+static void dthe_hash_dma_in_callback(void *data)
+{
+	struct dthe_dma_data *desc = (struct dthe_dma_data *)data;
+	struct ahash_request *req = (struct ahash_request *)desc->req;
+
+	struct dthe_tfm_ctx *ctx = crypto_ahash_ctx(crypto_ahash_reqtfm(req));
+	struct dthe_data *dev_data = dthe_get_dev(ctx);
+	struct dthe_mapped_sg *mapped_sg = &desc->mapped_sg[0];
+	struct dthe_hash_ctx *sctx = ctx->ctx_info.hash_ctx;
+	u32 *data_out;
+	u32 out_len;
+	int waitcnt = 102400;
+
+	void __iomem *sha_base_reg = dev_data->regs + DTHE_P_HASH_BASE;
+
+	dma_unmap_sg(mapped_sg->dev, mapped_sg->sg, mapped_sg->nents, mapped_sg->dir);
+
+	while (waitcnt--) {
+		if (readl_relaxed(sha_base_reg + DTHE_P_HASH_IRQSTATUS) &
+		    (DTHE_HASH_IRQSTATUS_OP_READY | DTHE_HASH_IRQSTATUS_PH_READY))
+			break;
+	}
+
+	/*
+	 * Overloading the phash_available variable to indicate whether we are coming
+	 * here from digest, update, final or finup function.
+	 * phash_available = 0: digest
+	 * phash_available = 1: update
+	 * phash_available = 2: final
+	 * phash_available = 3: finup
+	 */
+	if (sctx->phash_available == 1) {
+		// If coming from update, we need to read the phash and store it for future
+		data_out = sctx->phash;
+		out_len = sctx->phash_size / sizeof(u32);
+	} else {
+		// If coming from digest or final, we need to read the final digest
+		data_out = (u32 *)req->result;
+		out_len = sctx->digest_size / sizeof(u32);
+	}
+
+	for (int i = 0; i < out_len; ++i)
+		data_out[i] = readl_relaxed(sha_base_reg + DTHE_P_HASH512_IDIGEST_A + (4 * i));
+
+	if (!sctx->phash_available)
+		if (req->nbytes % sctx->block_size)
+			kfree(sg_virt(&mapped_sg->sg[mapped_sg->nents - 1]));
+
+	if (sctx->phash_available == 3)
+		if ((req->nbytes + sctx->buflen) % sctx->block_size)
+			kfree(sg_virt(&mapped_sg->sg[mapped_sg->nents - 1]));
+
+	kfree(mapped_sg->sg);
+	kfree(desc);
+
+	sctx->digestcnt = readl_relaxed(sha_base_reg + DTHE_P_HASH512_DIGEST_COUNT);
+	sctx->phash_available = 1;
+
+	ahash_request_complete(req, 0);
+	if (sctx->phash_available)
+		complete(&sctx->hash_compl);
+	mutex_unlock(&dev_data->hash_mutex);
+}
+
+static int dthe_hash_dma_start(struct ahash_request *req, struct scatterlist *src, size_t len)
+{
+	struct dthe_tfm_ctx *ctx = crypto_ahash_ctx(crypto_ahash_reqtfm(req));
+	struct dthe_data *dev_data = dthe_get_dev(ctx);
+	struct dthe_hash_ctx *sctx = ctx->ctx_info.hash_ctx;
+	struct dma_slave_config cfg;
+	struct device *tx_dev;
+	struct dma_async_tx_descriptor *desc_out;
+	int src_nents;
+	int mapped_nents;
+	enum dma_data_direction src_dir = DMA_TO_DEVICE;
+	struct dthe_dma_data *tx_data;
+	int ret = 0;
+	int waitcnt = 1024;
+	void __iomem *sha_base_reg = dev_data->regs + DTHE_P_HASH_BASE;
+
+	// Config SHA DMA channel as per SHA mode
+	memzero_explicit(&cfg, sizeof(cfg));
+
+	cfg.dst_addr_width = DMA_SLAVE_BUSWIDTH_4_BYTES;
+	cfg.dst_maxburst = sctx->block_size / 4;
+
+	ret = dmaengine_slave_config(dev_data->dma_sha_tx, &cfg);
+	if (ret) {
+		dev_err(dev_data->dev, "Can't configure OUT2 dmaengine slave: %d\n", ret);
+		goto sha_err;
+	}
+
+	tx_dev = dmaengine_get_dma_device(dev_data->dma_sha_tx);
+	if (!tx_dev) {
+		ret = -ENODEV;
+		goto sha_err;
+	}
+
+	src_nents = sg_nents_for_len(src, len);
+	mapped_nents = dma_map_sg(tx_dev, src, src_nents, src_dir);
+	if (mapped_nents == 0) {
+		ret = -EINVAL;
+		goto sha_err;
+	}
+
+	desc_out = dmaengine_prep_slave_sg(dev_data->dma_sha_tx, src, mapped_nents,
+					   DMA_MEM_TO_DEV, DMA_PREP_INTERRUPT | DMA_CTRL_ACK);
+	if (!desc_out) {
+		dev_err(dev_data->dev, "OUT prep_slave_sg() failed\n");
+		ret = -EINVAL;
+		goto sha_err;
+	}
+
+	tx_data = kzalloc(sizeof(struct dthe_dma_data), GFP_KERNEL);
+	if (!tx_data) {
+		ret = -ENOMEM;
+		goto sha_err;
+	}
+
+	tx_data->mapped_sg[0] = (struct dthe_mapped_sg) {
+		.sg = src,
+		.nents = src_nents,
+		.dir = src_dir,
+		.dev = tx_dev
+	};
+	tx_data->req = req;
+
+	desc_out->callback = dthe_hash_dma_in_callback;
+	desc_out->callback_param = tx_data;
+
+	waitcnt = 1024;
+	while (waitcnt--) {
+		if (readl_relaxed(sha_base_reg + DTHE_P_HASH_IRQSTATUS) &
+		    DTHE_HASH_IRQSTATUS_IP_READY)
+			break;
+	}
+
+	init_completion(&sctx->hash_compl);
+
+	dmaengine_submit(desc_out);
+
+	dma_async_issue_pending(dev_data->dma_sha_tx);
+
+	ret = wait_for_completion_timeout(&sctx->hash_compl, msecs_to_jiffies(2000));
+	if (!ret) {
+		u32 *data_out;
+		u32 out_len;
+
+		ret = -ETIMEDOUT;
+		dma_unmap_sg(tx_dev, src, src_nents, src_dir);
+
+		if (sctx->phash_available == 1) {
+			data_out = sctx->phash;
+			out_len = sctx->phash_size / sizeof(u32);
+		} else {
+			data_out = (u32 *)req->result;
+			out_len = sctx->digest_size / sizeof(u32);
+		}
+
+		for (int i = 0; i < out_len; ++i)
+			data_out[i] = readl_relaxed(sha_base_reg +
+						    DTHE_P_HASH512_IDIGEST_A +
+						    (4 * i));
+
+		sctx->digestcnt = readl_relaxed(sha_base_reg + DTHE_P_HASH512_DIGEST_COUNT);
+
+		if (!sctx->phash_available)
+			if (req->nbytes % sctx->block_size)
+				kfree(sg_virt(&src[src_nents - 1]));
+
+		if (sctx->phash_available == 3)
+			if ((req->nbytes + sctx->buflen) % sctx->block_size)
+				kfree(sg_virt(&src[src_nents - 1]));
+
+		kfree(src);
+
+		ahash_request_complete(req, ret);
+		kfree(tx_data);
+		goto sha_err;
+	}
+	return 0;
+sha_err:
+	mutex_unlock(&dev_data->hash_mutex);
+	return ret;
+}
+
+static int dthe_hash_init(struct ahash_request *req)
+{
+	struct dthe_tfm_ctx *ctx = crypto_ahash_ctx(crypto_ahash_reqtfm(req));
+	struct dthe_data *dev_data = dthe_get_dev(ctx);
+
+	void __iomem *sha_base_reg = dev_data->regs + DTHE_P_HASH_BASE;
+	u32 sha_sysconfig_val = DTHE_HASH_SYSCONFIG_INT_EN | DTHE_HASH_SYSCONFIG_DMA_EN;
+
+	ctx->ctx_info.hash_ctx->phash_available = 0;
+	ctx->ctx_info.hash_ctx->buflen = 0;
+	ctx->ctx_info.hash_ctx->digestcnt = 0;
+
+	writel_relaxed(sha_sysconfig_val, sha_base_reg + DTHE_P_HASH_SYSCONFIG);
+	writel_relaxed(DTHE_HASH_IRQENABLE_EN_ALL, sha_base_reg + DTHE_P_HASH_IRQENABLE);
+	ahash_request_complete(req, 0);
+	return 0;
+}
+
+static int dthe_hash_update(struct ahash_request *req)
+{
+	struct dthe_tfm_ctx *ctx = crypto_ahash_ctx(crypto_ahash_reqtfm(req));
+	struct dthe_data *dev_data = dthe_get_dev(ctx);
+	struct dthe_hash_ctx *sctx = ctx->ctx_info.hash_ctx;
+
+	struct scatterlist *src;
+	struct scatterlist *tmp;
+	int src_nents = 0;
+	int in_nents = sg_nents_for_len(req->src, req->nbytes);
+	unsigned int tot_len, cur_len;
+	unsigned int len_to_send, len_to_push;
+	u32 hash_mode_val;
+	int waitcnt = 1024;
+	int ret;
+
+	void __iomem *sha_base_reg = dev_data->regs + DTHE_P_HASH_BASE;
+
+	if (req->nbytes == 0) {
+		if (!sctx->phash_available && !sctx->buflen) {
+			if (sctx->mode == DTHE_HASH_SHA512)
+				memcpy(sctx->phash, sha512_zero_message_hash, sctx->digest_size);
+			else if (sctx->mode == DTHE_HASH_SHA384)
+				memcpy(sctx->phash, sha384_zero_message_hash, sctx->digest_size);
+			else if (sctx->mode == DTHE_HASH_SHA256)
+				memcpy(sctx->phash, sha256_zero_message_hash, sctx->digest_size);
+			else if (sctx->mode == DTHE_HASH_SHA224)
+				memcpy(sctx->phash, sha224_zero_message_hash, sctx->digest_size);
+		}
+
+		return 0;
+	}
+
+	tot_len = sctx->buflen + req->nbytes;
+	len_to_send = tot_len - (tot_len % sctx->block_size);
+	len_to_push = ((len_to_send == 0) ? req->nbytes : (tot_len % sctx->block_size));
+	cur_len = 0;
+
+	if (tot_len % sctx->block_size == 0) {
+		len_to_send -= sctx->block_size;
+		if (tot_len == sctx->block_size)
+			len_to_push = req->nbytes;
+		else
+			len_to_push = sctx->block_size;
+	}
+
+	if (len_to_send == 0) {
+		sg_copy_to_buffer(req->src, in_nents, sctx->data_buf + sctx->buflen, len_to_push);
+		sctx->buflen += len_to_push;
+		return 0;
+	}
+
+	if (len_to_push < req->nbytes)
+		src_nents = sg_nents_for_len(req->src, req->nbytes - len_to_push);
+	if (sctx->buflen > 0)
+		src_nents++;
+
+	src = kcalloc(src_nents, sizeof(struct scatterlist), GFP_KERNEL);
+	if (!src)
+		return -ENOMEM;
+
+	tmp = src;
+
+	if (sctx->buflen > 0) {
+		sg_set_buf(tmp, sctx->data_buf, sctx->buflen);
+		tmp = sg_next(tmp);
+		cur_len += sctx->buflen;
+		src_nents--;
+	}
+	if (src_nents > 0)
+		dthe_set_src_sg(tmp, req->src, src_nents, len_to_send - cur_len);
+
+	waitcnt = 1024;
+
+	while (waitcnt--) {
+		if (readl_relaxed(sha_base_reg + DTHE_P_HASH_IRQSTATUS) &
+		    DTHE_HASH_IRQSTATUS_CTX_READY)
+			break;
+	}
+
+	mutex_lock(&dev_data->hash_mutex);
+
+	hash_mode_val = sctx->mode;
+	if (sctx->phash_available) {
+		for (int i = 0; i < sctx->phash_size / sizeof(u32); ++i)
+			writel_relaxed(sctx->phash[i],
+				       sha_base_reg + DTHE_P_HASH512_IDIGEST_A + (4 * i));
+
+		writel_relaxed(sctx->digestcnt, sha_base_reg + DTHE_P_HASH512_DIGEST_COUNT);
+	} else {
+		hash_mode_val |= DTHE_HASH_MODE_USE_ALG_CONST;
+	}
+
+	writel_relaxed(hash_mode_val, sha_base_reg + DTHE_P_HASH512_MODE);
+	writel_relaxed(len_to_send, sha_base_reg + DTHE_P_HASH512_LENGTH);
+
+	sctx->phash_available = 1;
+	ret = dthe_hash_dma_start(req, src, len_to_send);
+
+	sg_pcopy_to_buffer(req->src, in_nents, sctx->data_buf,
+			   len_to_push, req->nbytes - len_to_push);
+	sctx->buflen = len_to_push;
+
+	return ret;
+}
+
+static int dthe_hash_final(struct ahash_request *req)
+{
+	struct dthe_tfm_ctx *ctx = crypto_ahash_ctx(crypto_ahash_reqtfm(req));
+	struct dthe_data *dev_data = dthe_get_dev(ctx);
+	struct dthe_hash_ctx *sctx = ctx->ctx_info.hash_ctx;
+	struct scatterlist *src;
+
+	void __iomem *sha_base_reg = dev_data->regs + DTHE_P_HASH_BASE;
+	u32 sha_mode_val = sctx->mode | DTHE_HASH_MODE_CLOSE_HASH;
+	int waitcnt = 1024;
+
+	if (sctx->buflen > 0) {
+		while (waitcnt--) {
+			if (readl_relaxed(sha_base_reg + DTHE_P_HASH_IRQSTATUS) &
+			    DTHE_HASH_IRQSTATUS_CTX_READY)
+				break;
+		}
+
+		mutex_lock(&dev_data->hash_mutex);
+		if (sctx->phash_available) {
+			for (int i = 0; i < sctx->phash_size / sizeof(u32); ++i)
+				writel_relaxed(sctx->phash[i],
+					       sha_base_reg + DTHE_P_HASH512_IDIGEST_A + (4 * i));
+
+			writel_relaxed(sctx->digestcnt,
+				       sha_base_reg + DTHE_P_HASH512_DIGEST_COUNT);
+		} else {
+			sha_mode_val |= DTHE_HASH_MODE_USE_ALG_CONST;
+		}
+
+		writel_relaxed(sha_mode_val, sha_base_reg + DTHE_P_HASH512_MODE);
+		writel_relaxed(sctx->buflen, sha_base_reg + DTHE_P_HASH512_LENGTH);
+
+		src = kzalloc(sizeof(struct scatterlist), GFP_KERNEL);
+		if (!src) {
+			mutex_unlock(&dev_data->hash_mutex);
+			return -ENOMEM;
+		}
+
+		// Padding 0s. See note in digest function.
+		for (int i = sctx->buflen; i < sctx->block_size; ++i)
+			sctx->data_buf[i] = 0;
+
+		sg_set_buf(src, sctx->data_buf, sctx->block_size);
+
+		sctx->phash_available = 2;
+		return dthe_hash_dma_start(req, src, sctx->block_size);
+	} else if (!sctx->phash_available) {
+		if (sctx->mode == DTHE_HASH_SHA512)
+			memcpy(req->result, sha512_zero_message_hash, sctx->digest_size);
+		else if (sctx->mode == DTHE_HASH_SHA384)
+			memcpy(req->result, sha384_zero_message_hash, sctx->digest_size);
+		else if (sctx->mode == DTHE_HASH_SHA256)
+			memcpy(req->result, sha256_zero_message_hash, sctx->digest_size);
+		else if (sctx->mode == DTHE_HASH_SHA224)
+			memcpy(req->result, sha224_zero_message_hash, sctx->digest_size);
+	}
+
+	memcpy(req->result, sctx->phash, sctx->digest_size);
+
+	ahash_request_complete(req, 0);
+	return 0;
+}
+
+static int dthe_hash_finup(struct ahash_request *req)
+{
+	struct dthe_tfm_ctx *ctx = crypto_ahash_ctx(crypto_ahash_reqtfm(req));
+	struct dthe_data *dev_data = dthe_get_dev(ctx);
+	struct dthe_hash_ctx *sctx = ctx->ctx_info.hash_ctx;
+
+	unsigned int tot_len = sctx->buflen + req->nbytes;
+	unsigned int cur_len = 0;
+	unsigned int pad_len = 0;
+	struct scatterlist *src;
+	struct scatterlist *tmp_sg;
+	int src_nents = 0;
+	u32 hash_mode_val;
+	u8 *pad_buf;
+	int waitcnt = 64;
+
+	void __iomem *sha_base_reg = dev_data->regs + DTHE_P_HASH_BASE;
+
+	if (tot_len == 0) {
+		if (sctx->phash_available) {
+			memcpy(req->result, sctx->phash, sctx->digest_size);
+		} else {
+			if (sctx->mode == DTHE_HASH_SHA512)
+				memcpy(req->result, sha512_zero_message_hash, sctx->digest_size);
+			else if (sctx->mode == DTHE_HASH_SHA384)
+				memcpy(req->result, sha384_zero_message_hash, sctx->digest_size);
+			else if (sctx->mode == DTHE_HASH_SHA256)
+				memcpy(req->result, sha256_zero_message_hash, sctx->digest_size);
+			else if (sctx->mode == DTHE_HASH_SHA224)
+				memcpy(req->result, sha224_zero_message_hash, sctx->digest_size);
+		}
+		return 0;
+	}
+
+	if (tot_len % sctx->block_size)
+		pad_len = sctx->block_size - (tot_len % sctx->block_size);
+
+	if (req->nbytes > 0)
+		src_nents = sg_nents_for_len(req->src, req->nbytes);
+	if (sctx->buflen > 0)
+		src_nents++;
+	if (pad_len > 0)
+		src_nents++;
+
+	src = kcalloc(src_nents, sizeof(struct scatterlist), GFP_KERNEL);
+	if (!src)
+		return -ENOMEM;
+
+	tmp_sg = src;
+
+	if (sctx->buflen > 0) {
+		sg_set_buf(tmp_sg, sctx->data_buf, sctx->buflen);
+		tmp_sg = sg_next(tmp_sg);
+		cur_len += sctx->buflen;
+		src_nents--;
+	}
+	if (tot_len - cur_len > 0)
+		tmp_sg = dthe_set_src_sg(tmp_sg, req->src, src_nents, tot_len - cur_len);
+
+	if (pad_len > 0) {
+		pad_buf = kcalloc(pad_len, sizeof(u8), GFP_KERNEL);
+		if (!pad_buf)
+			return -ENOMEM;
+		sg_set_buf(tmp_sg, pad_buf, pad_len);
+	}
+
+	waitcnt = 1024;
+
+	while (waitcnt--) {
+		if (readl_relaxed(sha_base_reg + DTHE_P_HASH_IRQSTATUS) &
+		DTHE_HASH_IRQSTATUS_CTX_READY)
+			break;
+	}
+
+	mutex_lock(&dev_data->hash_mutex);
+
+	hash_mode_val = sctx->mode | DTHE_HASH_MODE_CLOSE_HASH;
+	if (!sctx->phash_available) {
+		hash_mode_val |= DTHE_HASH_MODE_USE_ALG_CONST;
+	} else {
+		for (int i = 0; i < sctx->phash_size / sizeof(u32); ++i)
+			writel_relaxed(sctx->phash[i],
+				       sha_base_reg + DTHE_P_HASH512_IDIGEST_A + (4 * i));
+
+		writel_relaxed(sctx->digestcnt,
+			       sha_base_reg + DTHE_P_HASH512_DIGEST_COUNT);
+	}
+
+	writel_relaxed(hash_mode_val, sha_base_reg + DTHE_P_HASH512_MODE);
+	writel_relaxed(tot_len, sha_base_reg + DTHE_P_HASH512_LENGTH);
+
+	sctx->phash_available = 3;
+	return dthe_hash_dma_start(req, src, tot_len + pad_len);
+}
+
+static int dthe_hash_digest(struct ahash_request *req)
+{
+	struct dthe_tfm_ctx *ctx = crypto_ahash_ctx(crypto_ahash_reqtfm(req));
+	struct dthe_data *dev_data = dthe_get_dev(ctx);
+	struct dthe_hash_ctx *sctx = ctx->ctx_info.hash_ctx;
+	struct scatterlist *src, *tmp_sg;
+	int src_nents;
+	unsigned int pad_len = 0;
+	u8 *pad_buf;
+
+	u32 hash_sysconfig_val = DTHE_HASH_SYSCONFIG_DMA_EN | DTHE_HASH_SYSCONFIG_INT_EN;
+	u32 hash_mode_val = DTHE_HASH_MODE_CLOSE_HASH |
+			    DTHE_HASH_MODE_USE_ALG_CONST |
+			    sctx->mode;
+	void __iomem *sha_base_reg = dev_data->regs + DTHE_P_HASH_BASE;
+
+	int waitcnt = 1024;
+
+	sctx->phash_available = 0;
+	sctx->buflen = 0;
+	sctx->digestcnt = 0;
+
+	if (req->nbytes == 0) {
+		if (sctx->mode == DTHE_HASH_SHA512)
+			memcpy(req->result, sha512_zero_message_hash, sctx->digest_size);
+		else if (sctx->mode == DTHE_HASH_SHA384)
+			memcpy(req->result, sha384_zero_message_hash, sctx->digest_size);
+		else if (sctx->mode == DTHE_HASH_SHA256)
+			memcpy(req->result, sha256_zero_message_hash, sctx->digest_size);
+		else if (sctx->mode == DTHE_HASH_SHA224)
+			memcpy(req->result, sha224_zero_message_hash, sctx->digest_size);
+		return 0;
+	}
+
+	writel_relaxed(hash_sysconfig_val, sha_base_reg + DTHE_P_HASH_SYSCONFIG);
+	writel_relaxed(DTHE_HASH_IRQENABLE_EN_ALL, sha_base_reg + DTHE_P_HASH_IRQENABLE);
+
+	while (waitcnt--) {
+		if (readl_relaxed(sha_base_reg + DTHE_P_HASH_IRQSTATUS) &
+		    DTHE_HASH_IRQSTATUS_CTX_READY)
+			break;
+	}
+
+	mutex_lock(&dev_data->hash_mutex);
+	writel_relaxed(hash_mode_val, sha_base_reg + DTHE_P_HASH512_MODE);
+	writel_relaxed(req->nbytes, sha_base_reg + DTHE_P_HASH512_LENGTH);
+
+	src_nents = sg_nents_for_len(req->src, req->nbytes);
+
+	if (req->nbytes % sctx->block_size)
+		src_nents++;
+
+	src = kzalloc(sizeof(struct scatterlist) * (src_nents), GFP_KERNEL);
+	if (!src) {
+		mutex_unlock(&dev_data->hash_mutex);
+		return -ENOMEM;
+	}
+
+	tmp_sg = dthe_set_src_sg(src, req->src, src_nents, req->nbytes);
+
+	/* Certain DMA restrictions forced us to send data in multiples of BLOCK_SIZE
+	 * bytes. So, add a padding nent at the end of src scatterlist if data is not a
+	 * multiple of block_size bytes. The extra data is ignored by the DTHE hardware.
+	 */
+	if (req->nbytes % sctx->block_size) {
+		pad_len = sctx->block_size - (req->nbytes % sctx->block_size);
+		pad_buf = kcalloc(pad_len, sizeof(u8), GFP_KERNEL);
+		if (!pad_buf)
+			return -ENOMEM;
+
+		sg_set_buf(tmp_sg, pad_buf, pad_len);
+	}
+
+	return dthe_hash_dma_start(req, src, req->nbytes + pad_len);
+}
+
+static int dthe_hash_export(struct ahash_request *req, void *out)
+{
+	struct dthe_tfm_ctx *ctx = crypto_ahash_ctx(crypto_ahash_reqtfm(req));
+
+	memcpy(out, ctx->ctx_info.hash_ctx, sizeof(struct dthe_hash_ctx));
+	return 0;
+}
+
+static int dthe_hash_import(struct ahash_request *req, const void *in)
+{
+	struct dthe_tfm_ctx *ctx = crypto_ahash_ctx(crypto_ahash_reqtfm(req));
+
+	memcpy(ctx->ctx_info.hash_ctx, in, sizeof(struct dthe_hash_ctx));
+	return 0;
+}
+
 /**********************************************************************
  *				AES
  **********************************************************************/
@@ -523,6 +1253,121 @@ static int dthe_aes_decrypt(struct skcipher_request *req)
 static unsigned int refcnt;
 static DEFINE_MUTEX(refcnt_lock);
 
+static struct ahash_alg hash_algs[] = {
+	{
+		.init	= dthe_hash_init,
+		.update	= dthe_hash_update,
+		.final	= dthe_hash_final,
+		.finup	= dthe_hash_finup,
+		.digest	= dthe_hash_digest,
+		.export = dthe_hash_export,
+		.import = dthe_hash_import,
+		.halg	= {
+			.digestsize = SHA512_DIGEST_SIZE,
+			.statesize = sizeof(struct dthe_hash_ctx),
+			.base = {
+				.cra_name	 = "sha512",
+				.cra_driver_name = "sha512-dthe_v2",
+				.cra_priority	 = 400,
+				.cra_flags	 = CRYPTO_ALG_TYPE_AHASH |
+						   CRYPTO_ALG_ASYNC |
+						   CRYPTO_ALG_OPTIONAL_KEY |
+						   CRYPTO_ALG_KERN_DRIVER_ONLY |
+						   CRYPTO_ALG_ALLOCATES_MEMORY,
+				.cra_blocksize	 = SHA512_BLOCK_SIZE,
+				.cra_ctxsize	 = sizeof(struct dthe_tfm_ctx),
+				.cra_module	 = THIS_MODULE,
+				.cra_init	 = dthe_sha512_cra_init,
+				.cra_exit	 = dthe_hash_cra_exit,
+			}
+		}
+	},
+	{
+		.init	= dthe_hash_init,
+		.update	= dthe_hash_update,
+		.final	= dthe_hash_final,
+		.finup	= dthe_hash_finup,
+		.digest	= dthe_hash_digest,
+		.export = dthe_hash_export,
+		.import = dthe_hash_import,
+		.halg	= {
+			.digestsize = SHA384_DIGEST_SIZE,
+			.statesize = sizeof(struct dthe_hash_ctx),
+			.base = {
+				.cra_name	 = "sha384",
+				.cra_driver_name = "sha384-dthe_v2",
+				.cra_priority	 = 400,
+				.cra_flags	 = CRYPTO_ALG_TYPE_AHASH |
+						   CRYPTO_ALG_ASYNC |
+						   CRYPTO_ALG_OPTIONAL_KEY |
+						   CRYPTO_ALG_KERN_DRIVER_ONLY |
+						   CRYPTO_ALG_ALLOCATES_MEMORY,
+				.cra_blocksize	 = SHA384_BLOCK_SIZE,
+				.cra_ctxsize	 = sizeof(struct dthe_tfm_ctx),
+				.cra_module	 = THIS_MODULE,
+				.cra_init	 = dthe_sha384_cra_init,
+				.cra_exit	 = dthe_hash_cra_exit,
+			}
+		}
+	},
+	{
+		.init	= dthe_hash_init,
+		.update	= dthe_hash_update,
+		.final	= dthe_hash_final,
+		.finup	= dthe_hash_finup,
+		.digest	= dthe_hash_digest,
+		.export = dthe_hash_export,
+		.import = dthe_hash_import,
+		.halg	= {
+			.digestsize = SHA256_DIGEST_SIZE,
+			.statesize = sizeof(struct dthe_hash_ctx),
+			.base = {
+				.cra_name	 = "sha256",
+				.cra_driver_name = "sha256-dthe_v2",
+				.cra_priority	 = 400,
+				.cra_flags	 = CRYPTO_ALG_TYPE_AHASH |
+						   CRYPTO_ALG_ASYNC |
+						   CRYPTO_ALG_OPTIONAL_KEY |
+						   CRYPTO_ALG_KERN_DRIVER_ONLY |
+						   CRYPTO_ALG_ALLOCATES_MEMORY,
+				.cra_blocksize	 = SHA256_BLOCK_SIZE,
+				.cra_ctxsize	 = sizeof(struct dthe_tfm_ctx),
+				.cra_module	 = THIS_MODULE,
+				.cra_init	 = dthe_sha256_cra_init,
+				.cra_exit	 = dthe_hash_cra_exit,
+			}
+		}
+	},
+	{
+		.init	= dthe_hash_init,
+		.update	= dthe_hash_update,
+		.final	= dthe_hash_final,
+		.finup	= dthe_hash_finup,
+		.digest	= dthe_hash_digest,
+		.export = dthe_hash_export,
+		.import = dthe_hash_import,
+		.halg	= {
+			.digestsize = SHA224_DIGEST_SIZE,
+			.statesize = sizeof(struct dthe_hash_ctx),
+			.base = {
+				.cra_name	 = "sha224",
+				.cra_driver_name = "sha224-dthe_v2",
+				.cra_priority	 = 400,
+				.cra_flags	 = CRYPTO_ALG_TYPE_AHASH |
+						   CRYPTO_ALG_ASYNC |
+						   CRYPTO_ALG_OPTIONAL_KEY |
+						   CRYPTO_ALG_KERN_DRIVER_ONLY |
+						   CRYPTO_ALG_ALLOCATES_MEMORY,
+				.cra_blocksize	 = SHA224_BLOCK_SIZE,
+				.cra_ctxsize	 = sizeof(struct dthe_tfm_ctx),
+				.cra_module	 = THIS_MODULE,
+				.cra_init	 = dthe_sha224_cra_init,
+				.cra_exit	 = dthe_hash_cra_exit,
+			}
+		}
+	},
+};
+
 static struct skcipher_alg cipher_algs[] = {
 	{
 		.setkey	= dthe_ecb_aes_setkey,
@@ -596,6 +1441,9 @@ static int dthe_dma_init(struct dthe_data *dev_data)
 		goto err_dma_sha_tx;
 	}
 
+	// Do AES Rx and Tx channel config here because it is invariant of AES mode
+	// SHA Tx channel config is done before DMA transfer depending on hashing algorithm
+
 	memzero_explicit(&cfg, sizeof(cfg));
 
 	cfg.src_addr_width = DMA_SLAVE_BUSWIDTH_4_BYTES;
@@ -616,17 +1464,6 @@ static int dthe_dma_init(struct dthe_data *dev_data)
 		goto err_dma_config;
 	}
 
-	memzero_explicit(&cfg, sizeof(cfg));
-
-	cfg.dst_addr_width = DMA_SLAVE_BUSWIDTH_4_BYTES;
-	cfg.dst_maxburst = 32;
-
-	ret = dmaengine_slave_config(dev_data->dma_sha_tx, &cfg);
-	if (ret) {
-		dev_err(dev_data->dev, "Can't configure OUT2 dmaengine slave: %d\n", ret);
-		goto err_dma_config;
-	}
-
 	return 0;
 
 err_dma_config:
@@ -643,6 +1480,7 @@ static int dthe_register_algs(void)
 {
 	int ret = 0;
 
+	ret |= crypto_register_ahashes(hash_algs, ARRAY_SIZE(hash_algs));
 	ret |= crypto_register_skciphers(cipher_algs, ARRAY_SIZE(cipher_algs));
 
 	return ret;
@@ -650,6 +1488,7 @@ static int dthe_register_algs(void)
 
 static void dthe_unregister_algs(void)
 {
+	crypto_unregister_ahashes(hash_algs, ARRAY_SIZE(hash_algs));
 	crypto_unregister_skciphers(cipher_algs, ARRAY_SIZE(cipher_algs));
 }
 
@@ -679,6 +1518,7 @@ static int dthe_probe(struct platform_device *pdev)
 	spin_unlock(&dthe_dev_list.lock);
 
 	mutex_init(&dev_data->aes_mutex);
+	mutex_init(&dev_data->hash_mutex);
 
 	mutex_lock(&refcnt_lock);
 	if (!refcnt) {
@@ -692,6 +1532,7 @@ static int dthe_probe(struct platform_device *pdev)
 			spin_unlock(&dthe_dev_list.lock);
 
 			mutex_destroy(&dev_data->aes_mutex);
+			mutex_destroy(&dev_data->hash_mutex);
 
 			dma_release_channel(dev_data->dma_aes_rx);
 			dma_release_channel(dev_data->dma_aes_tx);
@@ -715,6 +1556,7 @@ static void dthe_remove(struct platform_device *pdev)
 	spin_unlock(&dthe_dev_list.lock);
 
 	mutex_destroy(&dev_data->aes_mutex);
+	mutex_destroy(&dev_data->hash_mutex);
 
 	mutex_lock(&refcnt_lock);
 	if (!--refcnt)
-- 
2.34.1

