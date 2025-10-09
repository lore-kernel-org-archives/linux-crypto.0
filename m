Received: from fllvem-ot03.ext.ti.com (fllvem-ot03.ext.ti.com [198.47.19.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF90C2C2340;
	Thu,  9 Oct 2025 11:18:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.47.19.245
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760008705; cv=none; b=eMjPuyh8IEpapL8ApmuLlYVSm3zUjv0bx7aXd6dXjVrWvuSHoFTvN+AewiO4e08fk9FOS/dflA2z34shZwiMXVXuxt+Me5oXk6tJU6XFnhfcpyv2DL3Ax9D9529TFcDaw+hx9br+blNaGXKcpmQE5MuvM7P7vEWn6HphVCxleVk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760008705; c=relaxed/simple;
	bh=/FfrjzS4ynU0ByjFL+vsILt5+RcOJXg3CHIIJAt6J9g=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gnz9tHQd3kZj9rfopZti30USOCN6SuWjSFquhSf0qGGHnMZkIbqxwXDkgMXu261XEd4nN0TOQM3q+7TdkmlkQTjwTXuZ1O9I8Fld7t2ZeTPmyLFlrmA7NdjJa5zvqnrkrfarEd7si4G211WPMzG39rhsIT9lcrIEn/oZnY8YFeM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b=ThFno+0W; arc=none smtp.client-ip=198.47.19.245
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="ThFno+0W"
Received: from lelvem-sh01.itg.ti.com ([10.180.77.71])
	by fllvem-ot03.ext.ti.com (8.15.2/8.15.2) with ESMTP id 599BICtL002929;
	Thu, 9 Oct 2025 06:18:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
	s=ti-com-17Q1; t=1760008692;
	bh=waRxt/cdydOyY7OUHU8Crg3EpbzsGYrIcELcd38sboE=;
	h=From:To:CC:Subject:Date:In-Reply-To:References;
	b=ThFno+0WXCuY8oKuD2moNQRwTw/v1kys+9rTFLDQKNHsgGdL79QlG7nWz1n5sQeo1
	 W1kQje2ldQhj3bx+tiPF4FIdXqXFdQGCqivcnR3jDNoEcRSAGzIzxkxFqGLbJlSf21
	 d7RNXrcXUk/07e8m7YN3foGh/F3/nFVTeEWabH3k=
Received: from DFLE109.ent.ti.com (dfle109.ent.ti.com [10.64.6.30])
	by lelvem-sh01.itg.ti.com (8.18.1/8.18.1) with ESMTPS id 599BICIu263613
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-SHA256 bits=128 verify=FAIL);
	Thu, 9 Oct 2025 06:18:12 -0500
Received: from DFLE204.ent.ti.com (10.64.6.62) by DFLE109.ent.ti.com
 (10.64.6.30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.55; Thu, 9
 Oct 2025 06:18:12 -0500
Received: from lelvem-mr05.itg.ti.com (10.180.75.9) by DFLE204.ent.ti.com
 (10.64.6.62) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Thu, 9 Oct 2025 06:18:12 -0500
Received: from pratham-Workstation-PC (pratham-workstation-pc.dhcp.ti.com [10.24.69.191])
	by lelvem-mr05.itg.ti.com (8.18.1/8.18.1) with ESMTP id 599BIATB168783;
	Thu, 9 Oct 2025 06:18:11 -0500
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
Subject: [PATCH v4 1/4] crypto: ti - Add support for AES-XTS in DTHEv2 driver
Date: Thu, 9 Oct 2025 16:11:31 +0530
Message-ID: <20251009111727.911738-2-t-pratham@ti.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251009111727.911738-1-t-pratham@ti.com>
References: <20251009111727.911738-1-t-pratham@ti.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-C2ProcessedOrg: 333ef613-75bf-4e12-a4b1-8e3623f5dcea

Add support for XTS mode of operation for AES algorithm in the AES
Engine of the DTHEv2 hardware cryptographic engine.

Signed-off-by: T Pratham <t-pratham@ti.com>
---
 drivers/crypto/ti/Kconfig         |   1 +
 drivers/crypto/ti/dthev2-aes.c    | 144 ++++++++++++++++++++++++++++--
 drivers/crypto/ti/dthev2-common.h |  12 ++-
 3 files changed, 150 insertions(+), 7 deletions(-)

diff --git a/drivers/crypto/ti/Kconfig b/drivers/crypto/ti/Kconfig
index d4f91c1e0cb55..a3692ceec49bc 100644
--- a/drivers/crypto/ti/Kconfig
+++ b/drivers/crypto/ti/Kconfig
@@ -6,6 +6,7 @@ config CRYPTO_DEV_TI_DTHEV2
 	select CRYPTO_SKCIPHER
 	select CRYPTO_ECB
 	select CRYPTO_CBC
+	select CRYPTO_XTS
 	help
 	  This enables support for the TI DTHE V2 hw cryptography engine
 	  which can be found on TI K3 SOCs. Selecting this enables use
diff --git a/drivers/crypto/ti/dthev2-aes.c b/drivers/crypto/ti/dthev2-aes.c
index 3547c41fa4ed3..4a1113e56c328 100644
--- a/drivers/crypto/ti/dthev2-aes.c
+++ b/drivers/crypto/ti/dthev2-aes.c
@@ -25,6 +25,7 @@
 
 // AES Engine
 #define DTHE_P_AES_BASE		0x7000
+
 #define DTHE_P_AES_KEY1_0	0x0038
 #define DTHE_P_AES_KEY1_1	0x003C
 #define DTHE_P_AES_KEY1_2	0x0030
@@ -33,6 +34,16 @@
 #define DTHE_P_AES_KEY1_5	0x002C
 #define DTHE_P_AES_KEY1_6	0x0020
 #define DTHE_P_AES_KEY1_7	0x0024
+
+#define DTHE_P_AES_KEY2_0	0x0018
+#define DTHE_P_AES_KEY2_1	0x001C
+#define DTHE_P_AES_KEY2_2	0x0010
+#define DTHE_P_AES_KEY2_3	0x0014
+#define DTHE_P_AES_KEY2_4	0x0008
+#define DTHE_P_AES_KEY2_5	0x000C
+#define DTHE_P_AES_KEY2_6	0x0000
+#define DTHE_P_AES_KEY2_7	0x0004
+
 #define DTHE_P_AES_IV_IN_0	0x0040
 #define DTHE_P_AES_IV_IN_1	0x0044
 #define DTHE_P_AES_IV_IN_2	0x0048
@@ -52,6 +63,7 @@
 enum aes_ctrl_mode_masks {
 	AES_CTRL_ECB_MASK = 0x00,
 	AES_CTRL_CBC_MASK = BIT(5),
+	AES_CTRL_XTS_MASK = BIT(12) | BIT(11),
 };
 
 #define DTHE_AES_CTRL_MODE_CLEAR_MASK		~GENMASK(28, 5)
@@ -88,6 +100,34 @@ static int dthe_cipher_init_tfm(struct crypto_skcipher *tfm)
 	return 0;
 }
 
+static int dthe_cipher_xts_init_tfm(struct crypto_skcipher *tfm)
+{
+	struct dthe_tfm_ctx *ctx = crypto_skcipher_ctx(tfm);
+	struct dthe_data *dev_data = dthe_get_dev(ctx);
+
+	ctx->dev_data = dev_data;
+	ctx->keylen = 0;
+
+	const char *alg_name = crypto_tfm_alg_name(crypto_skcipher_tfm(tfm));
+
+	ctx->skcipher_fb = crypto_alloc_skcipher(alg_name, 0,
+						 CRYPTO_ALG_NEED_FALLBACK);
+	if (IS_ERR(ctx->skcipher_fb)) {
+		dev_err(dev_data->dev, "fallback driver %s couldn't be loaded\n",
+			alg_name);
+		return PTR_ERR(ctx->skcipher_fb);
+	}
+
+	return 0;
+}
+
+static void dthe_cipher_xts_exit_tfm(struct crypto_skcipher *tfm)
+{
+	struct dthe_tfm_ctx *ctx = crypto_skcipher_ctx(tfm);
+
+	crypto_free_skcipher(ctx->skcipher_fb);
+}
+
 static int dthe_aes_setkey(struct crypto_skcipher *tfm, const u8 *key, unsigned int keylen)
 {
 	struct dthe_tfm_ctx *ctx = crypto_skcipher_ctx(tfm);
@@ -119,6 +159,27 @@ static int dthe_aes_cbc_setkey(struct crypto_skcipher *tfm, const u8 *key, unsig
 	return dthe_aes_setkey(tfm, key, keylen);
 }
 
+static int dthe_aes_xts_setkey(struct crypto_skcipher *tfm, const u8 *key, unsigned int keylen)
+{
+	struct dthe_tfm_ctx *ctx = crypto_skcipher_ctx(tfm);
+
+	if (keylen != 2 * AES_KEYSIZE_128 &&
+	    keylen != 2 * AES_KEYSIZE_192 &&
+	    keylen != 2 * AES_KEYSIZE_256)
+		return -EINVAL;
+
+	ctx->aes_mode = DTHE_AES_XTS;
+	ctx->keylen = keylen / 2;
+	memcpy(ctx->key, key, keylen);
+
+	crypto_skcipher_clear_flags(ctx->skcipher_fb, CRYPTO_TFM_REQ_MASK);
+	crypto_skcipher_set_flags(ctx->skcipher_fb,
+				  crypto_skcipher_get_flags(tfm) &
+				  CRYPTO_TFM_REQ_MASK);
+
+	return crypto_skcipher_setkey(ctx->skcipher_fb, key, keylen);
+}
+
 static void dthe_aes_set_ctrl_key(struct dthe_tfm_ctx *ctx,
 				  struct dthe_aes_req_ctx *rctx,
 				  u32 *iv_in)
@@ -141,6 +202,24 @@ static void dthe_aes_set_ctrl_key(struct dthe_tfm_ctx *ctx,
 		writel_relaxed(ctx->key[7], aes_base_reg + DTHE_P_AES_KEY1_7);
 	}
 
+	if (ctx->aes_mode == DTHE_AES_XTS) {
+		size_t key2_offset = ctx->keylen / sizeof(u32);
+
+		writel_relaxed(ctx->key[key2_offset + 0], aes_base_reg + DTHE_P_AES_KEY2_0);
+		writel_relaxed(ctx->key[key2_offset + 1], aes_base_reg + DTHE_P_AES_KEY2_1);
+		writel_relaxed(ctx->key[key2_offset + 2], aes_base_reg + DTHE_P_AES_KEY2_2);
+		writel_relaxed(ctx->key[key2_offset + 3], aes_base_reg + DTHE_P_AES_KEY2_3);
+
+		if (ctx->keylen > AES_KEYSIZE_128) {
+			writel_relaxed(ctx->key[key2_offset + 4], aes_base_reg + DTHE_P_AES_KEY2_4);
+			writel_relaxed(ctx->key[key2_offset + 5], aes_base_reg + DTHE_P_AES_KEY2_5);
+		}
+		if (ctx->keylen == AES_KEYSIZE_256) {
+			writel_relaxed(ctx->key[key2_offset + 6], aes_base_reg + DTHE_P_AES_KEY2_6);
+			writel_relaxed(ctx->key[key2_offset + 7], aes_base_reg + DTHE_P_AES_KEY2_7);
+		}
+	}
+
 	if (rctx->enc)
 		ctrl_val |= DTHE_AES_CTRL_DIR_ENC;
 
@@ -160,6 +239,9 @@ static void dthe_aes_set_ctrl_key(struct dthe_tfm_ctx *ctx,
 	case DTHE_AES_CBC:
 		ctrl_val |= AES_CTRL_CBC_MASK;
 		break;
+	case DTHE_AES_XTS:
+		ctrl_val |= AES_CTRL_XTS_MASK;
+		break;
 	}
 
 	if (iv_in) {
@@ -315,24 +397,49 @@ static int dthe_aes_run(struct crypto_engine *engine, void *areq)
 	local_bh_disable();
 	crypto_finalize_skcipher_request(dev_data->engine, req, ret);
 	local_bh_enable();
-	return ret;
+	return 0;
 }
 
 static int dthe_aes_crypt(struct skcipher_request *req)
 {
 	struct dthe_tfm_ctx *ctx = crypto_skcipher_ctx(crypto_skcipher_reqtfm(req));
+	struct dthe_aes_req_ctx *rctx = skcipher_request_ctx(req);
 	struct dthe_data *dev_data = dthe_get_dev(ctx);
 	struct crypto_engine *engine;
 
 	/*
-	 * If data is not a multiple of AES_BLOCK_SIZE, need to return -EINVAL
-	 * If data length input is zero, no need to do any operation.
+	 * If data is not a multiple of AES_BLOCK_SIZE:
+	 * - need to return -EINVAL for ECB, CBC as they are block ciphers
+	 * - need to fallback to software as H/W doesn't support Ciphertext Stealing for XTS
 	 */
-	if (req->cryptlen % AES_BLOCK_SIZE)
+	if (req->cryptlen % AES_BLOCK_SIZE) {
+		if (ctx->aes_mode == DTHE_AES_XTS) {
+			struct skcipher_request *subreq = &rctx->skcipher_fb_req;
+			int ret;
+
+			skcipher_request_set_tfm(subreq, ctx->skcipher_fb);
+			skcipher_request_set_callback(subreq, skcipher_request_flags(req),
+						      req->base.complete, req->base.data);
+			skcipher_request_set_crypt(subreq, req->src, req->dst,
+						   req->cryptlen, req->iv);
+
+			ret = rctx->enc ? crypto_skcipher_encrypt(subreq) :
+				crypto_skcipher_decrypt(subreq);
+
+			return ret;
+		}
 		return -EINVAL;
+	}
 
-	if (req->cryptlen == 0)
+	/*
+	 * If data length input is zero, no need to do any operation.
+	 * Except for XTS mode, where data should be non-zero.
+	 */
+	if (req->cryptlen == 0) {
+		if (ctx->aes_mode == DTHE_AES_XTS)
+			return -EINVAL;
 		return 0;
+	}
 
 	engine = dev_data->engine;
 	return crypto_transfer_skcipher_request_to_engine(engine, req);
@@ -399,7 +506,32 @@ static struct skcipher_engine_alg cipher_algs[] = {
 			.cra_module		= THIS_MODULE,
 		},
 		.op.do_one_request = dthe_aes_run,
-	} /* CBC AES */
+	}, /* CBC AES */
+	{
+		.base.init			= dthe_cipher_xts_init_tfm,
+		.base.exit			= dthe_cipher_xts_exit_tfm,
+		.base.setkey			= dthe_aes_xts_setkey,
+		.base.encrypt			= dthe_aes_encrypt,
+		.base.decrypt			= dthe_aes_decrypt,
+		.base.min_keysize		= AES_MIN_KEY_SIZE * 2,
+		.base.max_keysize		= AES_MAX_KEY_SIZE * 2,
+		.base.ivsize			= AES_IV_SIZE,
+		.base.base = {
+			.cra_name		= "xts(aes)",
+			.cra_driver_name	= "xts-aes-dthev2",
+			.cra_priority		= 299,
+			.cra_flags		= CRYPTO_ALG_TYPE_SKCIPHER |
+						  CRYPTO_ALG_ASYNC |
+						  CRYPTO_ALG_KERN_DRIVER_ONLY |
+						  CRYPTO_ALG_NEED_FALLBACK,
+			.cra_alignmask		= AES_BLOCK_SIZE - 1,
+			.cra_blocksize		= AES_BLOCK_SIZE,
+			.cra_ctxsize		= sizeof(struct dthe_tfm_ctx),
+			.cra_reqsize		= sizeof(struct dthe_aes_req_ctx),
+			.cra_module		= THIS_MODULE,
+		},
+		.op.do_one_request = dthe_aes_run,
+	}, /* XTS AES */
 };
 
 int dthe_register_aes_algs(void)
diff --git a/drivers/crypto/ti/dthev2-common.h b/drivers/crypto/ti/dthev2-common.h
index 68c94acda8aaa..4399ab62e1b12 100644
--- a/drivers/crypto/ti/dthev2-common.h
+++ b/drivers/crypto/ti/dthev2-common.h
@@ -27,10 +27,16 @@
 
 #define DTHE_REG_SIZE		4
 #define DTHE_DMA_TIMEOUT_MS	2000
+/*
+ * Size of largest possible key (of all algorithms) to be stored in dthe_tfm_ctx
+ * This is currently the keysize of XTS-AES-256 which is 512 bits (64 bytes)
+ */
+#define DTHE_MAX_KEYSIZE	(AES_MAX_KEY_SIZE * 2)
 
 enum dthe_aes_mode {
 	DTHE_AES_ECB = 0,
 	DTHE_AES_CBC,
+	DTHE_AES_XTS,
 };
 
 /* Driver specific struct definitions */
@@ -73,22 +79,26 @@ struct dthe_list {
  * @keylen: AES key length
  * @key: AES key
  * @aes_mode: AES mode
+ * @skcipher_fb: Fallback crypto skcipher handle for AES-XTS mode
  */
 struct dthe_tfm_ctx {
 	struct dthe_data *dev_data;
 	unsigned int keylen;
-	u32 key[AES_KEYSIZE_256 / sizeof(u32)];
+	u32 key[DTHE_MAX_KEYSIZE / sizeof(u32)];
 	enum dthe_aes_mode aes_mode;
+	struct crypto_skcipher *skcipher_fb;
 };
 
 /**
  * struct dthe_aes_req_ctx - AES engine req ctx struct
  * @enc: flag indicating encryption or decryption operation
  * @aes_compl: Completion variable for use in manual completion in case of DMA callback failure
+ * @skcipher_fb_req: skcipher request for fallback operation in case of AES-XTS mode
  */
 struct dthe_aes_req_ctx {
 	int enc;
 	struct completion aes_compl;
+	struct skcipher_request skcipher_fb_req;
 };
 
 /* Struct definitions end */
-- 
2.43.0

