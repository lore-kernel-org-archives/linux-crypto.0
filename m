Received: from fllvem-ot04.ext.ti.com (fllvem-ot04.ext.ti.com [198.47.19.246])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83D4A2E8B76;
	Wed, 22 Oct 2025 18:03:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.47.19.246
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761156213; cv=none; b=kL7MoIn3chgoFLmlGox97qzyP5JVqgf8rfE4KajKpNUW4JBCt/+pZ8xMepuYUzSI2W3IPL0XSgS3IU7nKQqQ5gBhxx4Avm4KSavxVxUkkY7tVHwwLreRIa9npuJPKTxW44eLbapYz5KZs9Hws5QLuu9YD3gVpMU6RmPqdRHnrQg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761156213; c=relaxed/simple;
	bh=VkK27ZhfmincAg70vfPA3cZUu1H6JlSdE01gXAm7KRA=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=oKHPF4Rk9pQGAi6+Apt7z1SgSwI8k29AkW//9++Zbp0+s+YJ1iIAO+p0QXSlceV6RqWrGUMu0wsntbfJIdVcK1wSvZwGEQkvEuCf/yzbiGyRXNqL0X2ICzqfQxbaZJq0PMLnUfEyDNELx7IkohW3nHCLhxyQLbpG/uVH1Rqzn9s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b=MEqMKGLw; arc=none smtp.client-ip=198.47.19.246
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="MEqMKGLw"
Received: from lelvem-sh02.itg.ti.com ([10.180.78.226])
	by fllvem-ot04.ext.ti.com (8.15.2/8.15.2) with ESMTP id 59MI3Qup329071;
	Wed, 22 Oct 2025 13:03:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
	s=ti-com-17Q1; t=1761156206;
	bh=j4n2M5nh9LshvIgR4+lBY4FdiOnBtOnEonMgz/sBspk=;
	h=From:To:CC:Subject:Date:In-Reply-To:References;
	b=MEqMKGLwcciTDo2dcemV3vmOJ2jTt20dhErjaMR2X1N1MwV7iUVCn6vrPrQxttwE5
	 R/tafwLwA+jfKZoN31Yh28aYonV8UvTWFyY1o5UQsMYWIScJCkJctZehABwz8BzqMD
	 M1WmAbVD/zfP7bD/FrOxVbb30DwZoF3+20UW3nqA=
Received: from DFLE214.ent.ti.com (dfle214.ent.ti.com [10.64.6.72])
	by lelvem-sh02.itg.ti.com (8.18.1/8.18.1) with ESMTPS id 59MI3QCo2531883
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Wed, 22 Oct 2025 13:03:26 -0500
Received: from DFLE210.ent.ti.com (10.64.6.68) by DFLE214.ent.ti.com
 (10.64.6.72) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Wed, 22 Oct
 2025 13:03:26 -0500
Received: from lelvem-mr05.itg.ti.com (10.180.75.9) by DFLE210.ent.ti.com
 (10.64.6.68) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Wed, 22 Oct 2025 13:03:26 -0500
Received: from pratham-Workstation-PC (pratham-workstation-pc.dhcp.ti.com [10.24.69.191])
	by lelvem-mr05.itg.ti.com (8.18.1/8.18.1) with ESMTP id 59MI3PYj1602193;
	Wed, 22 Oct 2025 13:03:25 -0500
From: T Pratham <t-pratham@ti.com>
To: T Pratham <t-pratham@ti.com>, Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
CC: Manorit Chawdhry <m-chawdhry@ti.com>, Kamlesh Gurudasani <kamlesh@ti.com>,
        Shiva Tripathi <s-tripathi1@ti.com>,
        Kavitha Malarvizhi
	<k-malarvizhi@ti.com>,
        Vishal Mahaveer <vishalm@ti.com>, Praneeth Bajjuri
	<praneeth@ti.com>,
        <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v5 2/4] crypto: ti - Add support for AES-CTR in DTHEv2 driver
Date: Wed, 22 Oct 2025 23:15:40 +0530
Message-ID: <20251022180302.729728-3-t-pratham@ti.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251022180302.729728-1-t-pratham@ti.com>
References: <20251022180302.729728-1-t-pratham@ti.com>
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
 drivers/crypto/ti/Kconfig         |   1 +
 drivers/crypto/ti/dthev2-aes.c    | 101 +++++++++++++++++++++++++++---
 drivers/crypto/ti/dthev2-common.c |  19 ++++++
 drivers/crypto/ti/dthev2-common.h |  15 +++++
 4 files changed, 127 insertions(+), 9 deletions(-)

diff --git a/drivers/crypto/ti/Kconfig b/drivers/crypto/ti/Kconfig
index a3692ceec49bc..6027e12de279d 100644
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
index 156729ccc50ec..bf55167f7871d 100644
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
@@ -156,6 +159,15 @@ static int dthe_aes_cbc_setkey(struct crypto_skcipher *tfm, const u8 *key, unsig
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
@@ -236,6 +248,10 @@ static void dthe_aes_set_ctrl_key(struct dthe_tfm_ctx *ctx,
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
@@ -271,11 +287,14 @@ static int dthe_aes_run(struct crypto_engine *engine, void *areq)
 	struct scatterlist *dst = req->dst;
 
 	int src_nents = sg_nents_for_len(src, len);
-	int dst_nents;
+	int dst_nents = sg_nents_for_len(dst, len);
 
 	int src_mapped_nents;
 	int dst_mapped_nents;
 
+	u8 pad_buf[AES_BLOCK_SIZE] = {0};
+	int pad_len = 0;
+
 	bool diff_dst;
 	enum dma_data_direction src_dir, dst_dir;
 
@@ -295,6 +314,39 @@ static int dthe_aes_run(struct crypto_engine *engine, void *areq)
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
+				goto aes_src_alloc_err;
+			}
+			sg_init_table(src, src_nents + 1);
+			sg = dthe_copy_sg(src, req->src, req->cryptlen);
+			sg_set_buf(sg, pad_buf, pad_len);
+			src_nents++;
+
+			dst = kmalloc_array(dst_nents + 1, sizeof(*dst), GFP_KERNEL);
+			if (!dst) {
+				ret = -ENOMEM;
+				goto aes_dst_alloc_err;
+			}
+			sg_init_table(dst, dst_nents + 1);
+			sg = dthe_copy_sg(dst, req->dst, req->cryptlen);
+			sg_set_buf(sg, pad_buf, pad_len);
+			dst_nents++;
+		}
+	}
+
 	if (src == dst) {
 		diff_dst = false;
 		src_dir = DMA_BIDIRECTIONAL;
@@ -311,19 +363,16 @@ static int dthe_aes_run(struct crypto_engine *engine, void *areq)
 	src_mapped_nents = dma_map_sg(tx_dev, src, src_nents, src_dir);
 	if (src_mapped_nents == 0) {
 		ret = -EINVAL;
-		goto aes_err;
+		goto aes_map_src_err;
 	}
 
 	if (!diff_dst) {
-		dst_nents = src_nents;
 		dst_mapped_nents = src_mapped_nents;
 	} else {
-		dst_nents = sg_nents_for_len(dst, len);
 		dst_mapped_nents = dma_map_sg(rx_dev, dst, dst_nents, dst_dir);
 		if (dst_mapped_nents == 0) {
-			dma_unmap_sg(tx_dev, src, src_nents, src_dir);
 			ret = -EINVAL;
-			goto aes_err;
+			goto aes_map_dst_err;
 		}
 	}
 
@@ -386,11 +435,19 @@ static int dthe_aes_run(struct crypto_engine *engine, void *areq)
 	}
 
 aes_prep_err:
-	dma_unmap_sg(tx_dev, src, src_nents, src_dir);
 	if (dst_dir != DMA_BIDIRECTIONAL)
 		dma_unmap_sg(rx_dev, dst, dst_nents, dst_dir);
+aes_map_dst_err:
+	dma_unmap_sg(tx_dev, src, src_nents, src_dir);
+
+aes_map_src_err:
+	if (ctx->aes_mode == DTHE_AES_CTR && req->cryptlen % AES_BLOCK_SIZE) {
+		kfree(dst);
+aes_dst_alloc_err:
+		kfree(src);
+	}
 
-aes_err:
+aes_src_alloc_err:
 	local_bh_disable();
 	crypto_finalize_skcipher_request(dev_data->engine, req, ret);
 	local_bh_enable();
@@ -408,6 +465,7 @@ static int dthe_aes_crypt(struct skcipher_request *req)
 	 * If data is not a multiple of AES_BLOCK_SIZE:
 	 * - need to return -EINVAL for ECB, CBC as they are block ciphers
 	 * - need to fallback to software as H/W doesn't support Ciphertext Stealing for XTS
+	 * - do nothing for CTR
 	 */
 	if (req->cryptlen % AES_BLOCK_SIZE) {
 		if (ctx->aes_mode == DTHE_AES_XTS) {
@@ -421,7 +479,8 @@ static int dthe_aes_crypt(struct skcipher_request *req)
 			return rctx->enc ? crypto_skcipher_encrypt(subreq) :
 				crypto_skcipher_decrypt(subreq);
 		}
-		return -EINVAL;
+		if (ctx->aes_mode != DTHE_AES_CTR)
+			return -EINVAL;
 	}
 
 	/*
@@ -500,6 +559,30 @@ static struct skcipher_engine_alg cipher_algs[] = {
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
+		.base.chunksize			= AES_BLOCK_SIZE,
+		.base.base = {
+			.cra_name		= "ctr(aes)",
+			.cra_driver_name	= "ctr-aes-dthev2",
+			.cra_priority		= 299,
+			.cra_flags		= CRYPTO_ALG_TYPE_SKCIPHER |
+						  CRYPTO_ALG_ASYNC |
+						  CRYPTO_ALG_KERN_DRIVER_ONLY |
+						  CRYPTO_ALG_ALLOCATES_MEMORY,
+			.cra_blocksize		= 1,
+			.cra_ctxsize		= sizeof(struct dthe_tfm_ctx),
+			.cra_reqsize		= sizeof(struct dthe_aes_req_ctx),
+			.cra_module		= THIS_MODULE,
+		},
+		.op.do_one_request = dthe_aes_run,
+	}, /* CTR AES */
 	{
 		.base.init			= dthe_cipher_xts_init_tfm,
 		.base.exit			= dthe_cipher_xts_exit_tfm,
diff --git a/drivers/crypto/ti/dthev2-common.c b/drivers/crypto/ti/dthev2-common.c
index c39d37933b9ee..a2ad79bec105a 100644
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
index c7a06a4c353ff..f12b94d64e134 100644
--- a/drivers/crypto/ti/dthev2-common.h
+++ b/drivers/crypto/ti/dthev2-common.h
@@ -36,6 +36,7 @@
 enum dthe_aes_mode {
 	DTHE_AES_ECB = 0,
 	DTHE_AES_CBC,
+	DTHE_AES_CTR,
 	DTHE_AES_XTS,
 };
 
@@ -103,6 +104,20 @@ struct dthe_aes_req_ctx {
 
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

