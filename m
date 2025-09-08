Received: from lelvem-ot02.ext.ti.com (lelvem-ot02.ext.ti.com [198.47.23.235])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 336C730BBA4;
	Mon,  8 Sep 2025 14:10:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.47.23.235
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757340609; cv=none; b=ky1kM6bWFt2t8NCjF4y5Luax0084+/yB2qjjcTY+DLByX+SKHlriQIgBU7RIB7FipP9WYkkFCAFH7B7+9FJLRSaU8UegA5HrX93Ef5+cfetc/t+hUCqxkSinqSgp8iNkStGGA3PzHtPI8Dmd4W0fkq4xra1j4n3E1Ep/sMH0pFg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757340609; c=relaxed/simple;
	bh=5lagy10vP+ElfLNZ4XPQUjfGJpMlZht7fVKsoNotb30=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ln1DP5C29Ot8HQR3LQ1wbXnmPnaS4QAcfHLHRF7f4t2qfnnxqAMfPX/4D1BWYIwAATcT+IqrhfyBZoNNUmqHG3bAWAxfTrSUGktC5FSk2XSxq8cvqQ7np2OS1QpAUEzCf/PV0+n0Xuq/ChZjvx1UXfVVUYH8Oh0+1ZfkbQoD0HQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b=i0OJDsqn; arc=none smtp.client-ip=198.47.23.235
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="i0OJDsqn"
Received: from lelvem-sh02.itg.ti.com ([10.180.78.226])
	by lelvem-ot02.ext.ti.com (8.15.2/8.15.2) with ESMTP id 588EA3qn116878;
	Mon, 8 Sep 2025 09:10:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
	s=ti-com-17Q1; t=1757340603;
	bh=LRS0GaO8Vw+EmQvBRmovB7EJCsf65v1b7tdlOx4p+hY=;
	h=From:To:CC:Subject:Date:In-Reply-To:References;
	b=i0OJDsqnZkRoy+Vj2wMWLxpLviy9F8pLZk4IpUyvoU4+fjWusQjIcPpIizRciXqm+
	 lzKAf5sE05Q9Zct/wzY6LDQ0ZHi5K3W+Qzfih3oOL3ORuJoesyoyqz9aTstRavx8eK
	 XW3xfQjdCP2ORz2U+ZTjW4R/JxAIeadliIPBsp3s=
Received: from DLEE101.ent.ti.com (dlee101.ent.ti.com [157.170.170.31])
	by lelvem-sh02.itg.ti.com (8.18.1/8.18.1) with ESMTPS id 588EA32I3009212
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-SHA256 bits=128 verify=FAIL);
	Mon, 8 Sep 2025 09:10:03 -0500
Received: from DLEE114.ent.ti.com (157.170.170.25) by DLEE101.ent.ti.com
 (157.170.170.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.55; Mon, 8
 Sep 2025 09:10:02 -0500
Received: from lelvem-mr05.itg.ti.com (10.180.75.9) by DLEE114.ent.ti.com
 (157.170.170.25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.55 via
 Frontend Transport; Mon, 8 Sep 2025 09:10:02 -0500
Received: from pratham-Workstation-PC (pratham-workstation-pc.dhcp.ti.com [10.24.69.191])
	by lelvem-mr05.itg.ti.com (8.18.1/8.18.1) with ESMTP id 588EA1Hq1013989;
	Mon, 8 Sep 2025 09:10:02 -0500
From: T Pratham <t-pratham@ti.com>
To: T Pratham <t-pratham@ti.com>, Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
CC: Kamlesh Gurudasani <kamlesh@ti.com>, Manorit Chawdhry <m-chawdhry@ti.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Praneeth Bajjuri <praneeth@ti.com>, Vishal Mahaveer <vishalm@ti.com>,
        Kavitha Malarvizhi <k-malarvizhi@ti.com>,
        <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 2/4] crypto: ti: Add support for AES-CTR in DTHEv2 driver
Date: Mon, 8 Sep 2025 19:28:14 +0530
Message-ID: <20250908140928.2801062-3-t-pratham@ti.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250908140928.2801062-1-t-pratham@ti.com>
References: <20250908140928.2801062-1-t-pratham@ti.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-C2ProcessedOrg: 333ef613-75bf-4e12-a4b1-8e3623f5dcea

Add support for CTR mode of operation for AES algorithm in the AES
Engine of the DTHEv2 hardware cryptographic engine.

Signed-off-by: T Pratham <t-pratham@ti.com>
---
 drivers/crypto/ti/Kconfig         |  1 +
 drivers/crypto/ti/dthev2-aes.c    | 80 +++++++++++++++++++++++++++++--
 drivers/crypto/ti/dthev2-common.c | 19 ++++++++
 drivers/crypto/ti/dthev2-common.h | 15 ++++++
 4 files changed, 110 insertions(+), 5 deletions(-)

diff --git a/drivers/crypto/ti/Kconfig b/drivers/crypto/ti/Kconfig
index bdb7f652e093..b36733a8c734 100644
--- a/drivers/crypto/ti/Kconfig
+++ b/drivers/crypto/ti/Kconfig
@@ -6,6 +6,7 @@ config CRYPTO_DEV_TI_DTHEV2
 	select CRYPTO_SKCIPHER
 	select CRYPTO_ECB
 	select CRYPTO_CBC
+	select CRYPTO_CTR
 	select CRYPTO_XTS
 	help
 	  This enables support for the TI DTHE V2 hw cryptography engine
diff --git a/drivers/crypto/ti/dthev2-aes.c b/drivers/crypto/ti/dthev2-aes.c
index 21e7e5b8d6da..07787f0ae4fd 100644
--- a/drivers/crypto/ti/dthev2-aes.c
+++ b/drivers/crypto/ti/dthev2-aes.c
@@ -63,6 +63,7 @@
 enum aes_ctrl_mode_masks {
 	AES_CTRL_ECB_MASK = 0x00,
 	AES_CTRL_CBC_MASK = BIT(5),
+	AES_CTRL_CTR_MASK = BIT(6),
 	AES_CTRL_XTS_MASK = BIT(12) | BIT(11),
 };
 
@@ -74,6 +75,8 @@ enum aes_ctrl_mode_masks {
 #define DTHE_AES_CTRL_KEYSIZE_24B		BIT(4)
 #define DTHE_AES_CTRL_KEYSIZE_32B		(BIT(3) | BIT(4))
 
+#define DTHE_AES_CTRL_CTR_WIDTH_128B		(BIT(7) | BIT(8))
+
 #define DTHE_AES_CTRL_SAVE_CTX_SET		BIT(29)
 
 #define DTHE_AES_CTRL_OUTPUT_READY		BIT_MASK(0)
@@ -131,6 +134,15 @@ static int dthe_aes_cbc_setkey(struct crypto_skcipher *tfm, const u8 *key, unsig
 	return dthe_aes_setkey(tfm, key, keylen);
 }
 
+static int dthe_aes_ctr_setkey(struct crypto_skcipher *tfm, const u8 *key, unsigned int keylen)
+{
+	struct dthe_tfm_ctx *ctx = crypto_skcipher_ctx(tfm);
+
+	ctx->aes_mode = DTHE_AES_CTR;
+
+	return dthe_aes_setkey(tfm, key, keylen);
+}
+
 static int dthe_aes_xts_setkey(struct crypto_skcipher *tfm, const u8 *key, unsigned int keylen)
 {
 	struct dthe_tfm_ctx *ctx = crypto_skcipher_ctx(tfm);
@@ -206,6 +218,10 @@ static void dthe_aes_set_ctrl_key(struct dthe_tfm_ctx *ctx,
 	case DTHE_AES_CBC:
 		ctrl_val |= AES_CTRL_CBC_MASK;
 		break;
+	case DTHE_AES_CTR:
+		ctrl_val |= AES_CTRL_CTR_MASK;
+		ctrl_val |= DTHE_AES_CTRL_CTR_WIDTH_128B;
+		break;
 	case DTHE_AES_XTS:
 		ctrl_val |= AES_CTRL_XTS_MASK;
 		break;
@@ -246,6 +262,9 @@ static int dthe_aes_run(struct crypto_engine *engine, void *areq)
 	int src_mapped_nents;
 	int dst_mapped_nents;
 
+	u8 pad_buf[AES_BLOCK_SIZE] = {0};
+	int pad_len = 0;
+
 	bool diff_dst;
 	enum dma_data_direction src_dir, dst_dir;
 
@@ -265,6 +284,29 @@ static int dthe_aes_run(struct crypto_engine *engine, void *areq)
 	aes_irqenable_val |= DTHE_AES_IRQENABLE_EN_ALL;
 	writel_relaxed(aes_irqenable_val, aes_base_reg + DTHE_P_AES_IRQENABLE);
 
+	if (ctx->aes_mode == DTHE_AES_CTR) {
+		/*
+		 * CTR mode can operate on any input length, but the hardware
+		 * requires input length to be a multiple of the block size.
+		 * We need to handle the padding in the driver.
+		 */
+		if (req->cryptlen % AES_BLOCK_SIZE) {
+			/* Need to create a new SG list with padding */
+			pad_len = ALIGN(req->cryptlen, AES_BLOCK_SIZE) - req->cryptlen;
+			struct scatterlist *sg;
+
+			src = kmalloc_array((src_nents + 1), sizeof(*src), GFP_KERNEL);
+			if (!src) {
+				ret = -ENOMEM;
+				goto aes_alloc_err;
+			}
+			sg_init_table(src, src_nents + 1);
+			sg = dthe_copy_sg(src, req->src, req->cryptlen);
+			sg_set_buf(sg, pad_buf, pad_len);
+			src_nents++;
+		}
+	}
+
 	if (src == dst) {
 		diff_dst = false;
 		src_dir = DMA_BIDIRECTIONAL;
@@ -281,7 +323,7 @@ static int dthe_aes_run(struct crypto_engine *engine, void *areq)
 	src_mapped_nents = dma_map_sg(tx_dev, src, src_nents, src_dir);
 	if (src_mapped_nents == 0) {
 		ret = -EINVAL;
-		goto aes_err;
+		goto aes_map_src_err;
 	}
 
 	if (!diff_dst) {
@@ -293,7 +335,7 @@ static int dthe_aes_run(struct crypto_engine *engine, void *areq)
 		if (dst_mapped_nents == 0) {
 			dma_unmap_sg(tx_dev, src, src_nents, src_dir);
 			ret = -EINVAL;
-			goto aes_err;
+			goto aes_map_dst_err;
 		}
 	}
 
@@ -356,11 +398,16 @@ static int dthe_aes_run(struct crypto_engine *engine, void *areq)
 	}
 
 aes_prep_err:
-	dma_unmap_sg(tx_dev, src, src_nents, src_dir);
 	if (dst_dir != DMA_BIDIRECTIONAL)
 		dma_unmap_sg(rx_dev, dst, dst_nents, dst_dir);
+aes_map_dst_err:
+	dma_unmap_sg(tx_dev, src, src_nents, src_dir);
 
-aes_err:
+aes_map_src_err:
+	if (ctx->aes_mode == DTHE_AES_CTR && req->cryptlen % AES_BLOCK_SIZE)
+		kfree(src);
+
+aes_alloc_err:
 	local_bh_disable();
 	crypto_finalize_skcipher_request(dev_data->engine, req, ret);
 	local_bh_enable();
@@ -375,9 +422,10 @@ static int dthe_aes_crypt(struct skcipher_request *req)
 
 	/*
 	 * If data is not a multiple of AES_BLOCK_SIZE, need to return -EINVAL
+	 * except in CTR mode, where any length is supported.
 	 * If data length input is zero, no need to do any operation.
 	 */
-	if (req->cryptlen % AES_BLOCK_SIZE)
+	if (req->cryptlen % AES_BLOCK_SIZE && ctx->aes_mode != DTHE_AES_CTR)
 		return -EINVAL;
 
 	if (req->cryptlen == 0)
@@ -447,6 +495,28 @@ static struct skcipher_engine_alg cipher_algs[] = {
 		},
 		.op.do_one_request = dthe_aes_run,
 	}, /* CBC AES */
+	{
+		.base.init			= dthe_cipher_init_tfm,
+		.base.setkey			= dthe_aes_ctr_setkey,
+		.base.encrypt			= dthe_aes_encrypt,
+		.base.decrypt			= dthe_aes_decrypt,
+		.base.min_keysize		= AES_MIN_KEY_SIZE,
+		.base.max_keysize		= AES_MAX_KEY_SIZE,
+		.base.ivsize			= AES_IV_SIZE,
+		.base.base = {
+			.cra_name		= "ctr(aes)",
+			.cra_driver_name	= "ctr-aes-dthev2",
+			.cra_priority		= 299,
+			.cra_flags		= CRYPTO_ALG_TYPE_SKCIPHER |
+						  CRYPTO_ALG_KERN_DRIVER_ONLY,
+			.cra_alignmask		= AES_BLOCK_SIZE - 1,
+			.cra_blocksize		= 1,
+			.cra_ctxsize		= sizeof(struct dthe_tfm_ctx),
+			.cra_reqsize		= sizeof(struct dthe_aes_req_ctx),
+			.cra_module		= THIS_MODULE,
+		},
+		.op.do_one_request = dthe_aes_run,
+	}, /* CTR AES */
 	{
 		.base.init			= dthe_cipher_init_tfm,
 		.base.setkey			= dthe_aes_xts_setkey,
diff --git a/drivers/crypto/ti/dthev2-common.c b/drivers/crypto/ti/dthev2-common.c
index c39d37933b9e..a2ad79bec105 100644
--- a/drivers/crypto/ti/dthev2-common.c
+++ b/drivers/crypto/ti/dthev2-common.c
@@ -48,6 +48,25 @@ struct dthe_data *dthe_get_dev(struct dthe_tfm_ctx *ctx)
 	return dev_data;
 }
 
+struct scatterlist *dthe_copy_sg(struct scatterlist *dst,
+				 struct scatterlist *src,
+				 int buflen)
+{
+	struct scatterlist *from_sg, *to_sg;
+	int sglen;
+
+	for (to_sg = dst, from_sg = src; buflen && from_sg; buflen -= sglen) {
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
 static int dthe_dma_init(struct dthe_data *dev_data)
 {
 	int ret;
diff --git a/drivers/crypto/ti/dthev2-common.h b/drivers/crypto/ti/dthev2-common.h
index e2d901e70fcc..629f45a3ab33 100644
--- a/drivers/crypto/ti/dthev2-common.h
+++ b/drivers/crypto/ti/dthev2-common.h
@@ -36,6 +36,7 @@
 enum dthe_aes_mode {
 	DTHE_AES_ECB = 0,
 	DTHE_AES_CBC,
+	DTHE_AES_CTR,
 	DTHE_AES_XTS,
 };
 
@@ -101,6 +102,20 @@ struct dthe_aes_req_ctx {
 
 struct dthe_data *dthe_get_dev(struct dthe_tfm_ctx *ctx);
 
+/**
+ * dthe_copy_sg - Copy sg entries from src to dst
+ * @dst: Destination sg to be filled
+ * @src: Source sg to be copied from
+ * @buflen: Number of bytes to be copied
+ *
+ * Description:
+ *   Copy buflen bytes of data from src to dst.
+ *
+ **/
+struct scatterlist *dthe_copy_sg(struct scatterlist *dst,
+				 struct scatterlist *src,
+				 int buflen);
+
 int dthe_register_aes_algs(void);
 void dthe_unregister_aes_algs(void);
 
-- 
2.43.0

