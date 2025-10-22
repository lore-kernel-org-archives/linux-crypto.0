Received: from lelvem-ot01.ext.ti.com (lelvem-ot01.ext.ti.com [198.47.23.234])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1169E2FE048;
	Wed, 22 Oct 2025 18:03:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.47.23.234
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761156220; cv=none; b=KtBm45VUE2B/12r1KXCWbJv5j+QfmfZwUToS65Ye2rpwKDlhXVleIuxnqCEbWqi1Hxl4jOrsBBUlDyNajhAll5Jh2N7qMpepOMqhRftNRs+OZLQlXOqxEH0Wv1wKz003AxXJiQVDuMymMZdMjsBaO88riUeWR7tBsJPafsgEtWY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761156220; c=relaxed/simple;
	bh=CWWvWlCmp5lnV2QSgssL2GNmcICNuWiZP5idG/Ndsl8=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=l+lbVuzezSdISyqmpnc4OUufJQEW37RlVLrCouomnmcyxYWSZQhDkvlKEsCAM2Q+TVG4XC+efaEyFVScwyDZdG2W/4k/Pc88UvtsblDz1yis5RdOv+8ZDsjIgk03PJMrMxR4P0F/H1tckEjT2rlB+ux+AcEYU6qYECR3/MGljsc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b=tBw/B7pb; arc=none smtp.client-ip=198.47.23.234
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="tBw/B7pb"
Received: from lelvem-sh01.itg.ti.com ([10.180.77.71])
	by lelvem-ot01.ext.ti.com (8.15.2/8.15.2) with ESMTP id 59MI3YVX1477225;
	Wed, 22 Oct 2025 13:03:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
	s=ti-com-17Q1; t=1761156214;
	bh=PKC599RkvKtLxFCsJ46IgIo6hP4F2Yr27hBp84tdG3U=;
	h=From:To:CC:Subject:Date:In-Reply-To:References;
	b=tBw/B7pbARoch3Fapbn4ThGvnGQKPvXEHsDI2quoAxk2CsqJCMnWBrEOivbV63XzT
	 PGut2jH2y39LQ4mWPdMkl+92dWm3Mjl2n73UC/YgxYh7vsVTkuKtx1cZde/oIxVj18
	 oSzW9Mnj1zN1Gf9pOP3g4X5IpeDvkqZQJZf7FNLw=
Received: from DLEE205.ent.ti.com (dlee205.ent.ti.com [157.170.170.85])
	by lelvem-sh01.itg.ti.com (8.18.1/8.18.1) with ESMTPS id 59MI3Y2d2112080
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Wed, 22 Oct 2025 13:03:34 -0500
Received: from DLEE201.ent.ti.com (157.170.170.76) by DLEE205.ent.ti.com
 (157.170.170.85) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Wed, 22 Oct
 2025 13:03:33 -0500
Received: from lelvem-mr06.itg.ti.com (10.180.75.8) by DLEE201.ent.ti.com
 (157.170.170.76) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Wed, 22 Oct 2025 13:03:33 -0500
Received: from pratham-Workstation-PC (pratham-workstation-pc.dhcp.ti.com [10.24.69.191])
	by lelvem-mr06.itg.ti.com (8.18.1/8.18.1) with ESMTP id 59MI3WT71614080;
	Wed, 22 Oct 2025 13:03:33 -0500
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
Subject: [PATCH v5 4/4] crypto: ti - Add support for AES-CCM in DTHEv2 driver
Date: Wed, 22 Oct 2025 23:15:42 +0530
Message-ID: <20251022180302.729728-5-t-pratham@ti.com>
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

AES-CCM is an AEAD algorithm supporting both encryption and
authentication of data. This patch introduces support for AES-CCM AEAD
algorithm in the DTHEv2 driver.

Signed-off-by: T Pratham <t-pratham@ti.com>
---
 drivers/crypto/ti/Kconfig         |   1 +
 drivers/crypto/ti/dthev2-aes.c    | 129 ++++++++++++++++++++++++++----
 drivers/crypto/ti/dthev2-common.h |   1 +
 3 files changed, 115 insertions(+), 16 deletions(-)

diff --git a/drivers/crypto/ti/Kconfig b/drivers/crypto/ti/Kconfig
index 221e483737439..1a3a571ac8cef 100644
--- a/drivers/crypto/ti/Kconfig
+++ b/drivers/crypto/ti/Kconfig
@@ -9,6 +9,7 @@ config CRYPTO_DEV_TI_DTHEV2
 	select CRYPTO_CTR
 	select CRYPTO_XTS
 	select CRYPTO_GCM
+	select CRYPTO_CCM
 	select SG_SPLIT
 	help
 	  This enables support for the TI DTHE V2 hw cryptography engine
diff --git a/drivers/crypto/ti/dthev2-aes.c b/drivers/crypto/ti/dthev2-aes.c
index c63e3eac3346f..8c627539cf5c8 100644
--- a/drivers/crypto/ti/dthev2-aes.c
+++ b/drivers/crypto/ti/dthev2-aes.c
@@ -16,6 +16,7 @@
 
 #include "dthev2-common.h"
 
+#include <linux/bitfield.h>
 #include <linux/delay.h>
 #include <linux/dmaengine.h>
 #include <linux/dma-mapping.h>
@@ -69,6 +70,7 @@ enum aes_ctrl_mode_masks {
 	AES_CTRL_CTR_MASK = BIT(6),
 	AES_CTRL_XTS_MASK = BIT(12) | BIT(11),
 	AES_CTRL_GCM_MASK = BIT(17) | BIT(16) | BIT(6),
+	AES_CTRL_CCM_MASK = BIT(18) | BIT(6),
 };
 
 #define DTHE_AES_CTRL_MODE_CLEAR_MASK		~GENMASK(28, 5)
@@ -81,6 +83,11 @@ enum aes_ctrl_mode_masks {
 
 #define DTHE_AES_CTRL_CTR_WIDTH_128B		(BIT(7) | BIT(8))
 
+#define DTHE_AES_CCM_L_FROM_IV_MASK		GENMASK(2, 0)
+#define DTHE_AES_CCM_M_BITS			GENMASK(2, 0)
+#define DTHE_AES_CTRL_CCM_L_FIELD_MASK		GENMASK(21, 19)
+#define DTHE_AES_CTRL_CCM_M_FIELD_MASK		GENMASK(24, 22)
+
 #define DTHE_AES_CTRL_SAVE_CTX_SET		BIT(29)
 
 #define DTHE_AES_CTRL_OUTPUT_READY		BIT_MASK(0)
@@ -96,6 +103,8 @@ enum aes_ctrl_mode_masks {
 #define AES_BLOCK_WORDS				(AES_BLOCK_SIZE / sizeof(u32))
 #define AES_IV_WORDS				AES_BLOCK_WORDS
 #define DTHE_AES_GCM_AAD_MAXLEN			(BIT_ULL(32) - 1)
+#define DTHE_AES_CCM_AAD_MAXLEN			(BIT(16) - BIT(8))
+#define DTHE_AES_CCM_CRYPT_MAXLEN		(BIT_ULL(61) - 1)
 #define POLL_TIMEOUT_INTERVAL			HZ
 
 static int dthe_cipher_init_tfm(struct crypto_skcipher *tfm)
@@ -264,6 +273,13 @@ static void dthe_aes_set_ctrl_key(struct dthe_tfm_ctx *ctx,
 	case DTHE_AES_GCM:
 		ctrl_val |= AES_CTRL_GCM_MASK;
 		break;
+	case DTHE_AES_CCM:
+		ctrl_val |= AES_CTRL_CCM_MASK;
+		ctrl_val |= FIELD_PREP(DTHE_AES_CTRL_CCM_L_FIELD_MASK,
+				       (iv_in[0] & DTHE_AES_CCM_L_FROM_IV_MASK));
+		ctrl_val |= FIELD_PREP(DTHE_AES_CTRL_CCM_M_FIELD_MASK,
+				       ((ctx->authsize - 2) >> 1) & DTHE_AES_CCM_M_BITS);
+		break;
 	}
 
 	if (iv_in) {
@@ -785,10 +801,6 @@ static int dthe_aead_setkey(struct crypto_aead *tfm, const u8 *key, unsigned int
 	if (keylen != AES_KEYSIZE_128 && keylen != AES_KEYSIZE_192 && keylen != AES_KEYSIZE_256)
 		return -EINVAL;
 
-	ctx->aes_mode = DTHE_AES_GCM;
-	ctx->keylen = keylen;
-	memcpy(ctx->key, key, keylen);
-
 	crypto_sync_aead_clear_flags(ctx->aead_fb, CRYPTO_TFM_REQ_MASK);
 	crypto_sync_aead_set_flags(ctx->aead_fb,
 				   crypto_aead_get_flags(tfm) &
@@ -797,6 +809,28 @@ static int dthe_aead_setkey(struct crypto_aead *tfm, const u8 *key, unsigned int
 	return crypto_sync_aead_setkey(ctx->aead_fb, key, keylen);
 }
 
+static int dthe_gcm_aes_setkey(struct crypto_aead *tfm, const u8 *key, unsigned int keylen)
+{
+	struct dthe_tfm_ctx *ctx = crypto_aead_ctx(tfm);
+
+	ctx->aes_mode = DTHE_AES_GCM;
+	ctx->keylen = keylen;
+	memcpy(ctx->key, key, keylen);
+
+	return dthe_aead_setkey(tfm, key, keylen);
+}
+
+static int dthe_ccm_aes_setkey(struct crypto_aead *tfm, const u8 *key, unsigned int keylen)
+{
+	struct dthe_tfm_ctx *ctx = crypto_aead_ctx(tfm);
+
+	ctx->aes_mode = DTHE_AES_CCM;
+	ctx->keylen = keylen;
+	memcpy(ctx->key, key, keylen);
+
+	return dthe_aead_setkey(tfm, key, keylen);
+}
+
 static int dthe_aead_setauthsize(struct crypto_aead *tfm, unsigned int authsize)
 {
 	struct dthe_tfm_ctx *ctx = crypto_aead_ctx(tfm);
@@ -939,14 +973,18 @@ static int dthe_aead_run(struct crypto_engine *engine, void *areq)
 		writel_relaxed(1, aes_base_reg + DTHE_P_AES_AUTH_LENGTH);
 	}
 
-	if (req->iv) {
-		memcpy(iv_in, req->iv, GCM_AES_IV_SIZE);
+	if (ctx->aes_mode == DTHE_AES_GCM) {
+		if (req->iv) {
+			memcpy(iv_in, req->iv, GCM_AES_IV_SIZE);
+		} else {
+			iv_in[0] = 0;
+			iv_in[1] = 0;
+			iv_in[2] = 0;
+		}
+		iv_in[3] = 0x01000000;
 	} else {
-		iv_in[0] = 0;
-		iv_in[1] = 0;
-		iv_in[2] = 0;
+		memcpy(iv_in, req->iv, AES_IV_SIZE);
 	}
-	iv_in[3] = 0x01000000;
 
 	/* Clear key2 to reset previous GHASH intermediate data */
 	for (int i = 0; i < AES_KEYSIZE_256 / sizeof(u32); ++i)
@@ -1014,20 +1052,54 @@ static int dthe_aead_crypt(struct aead_request *req)
 	struct dthe_data *dev_data = dthe_get_dev(ctx);
 	struct crypto_engine *engine;
 	unsigned int cryptlen = req->cryptlen;
+	bool is_zero_ctr = true;
 
 	/* In decryption, last authsize bytes are the TAG */
 	if (!rctx->enc)
 		cryptlen -= ctx->authsize;
 
+	if (ctx->aes_mode == DTHE_AES_CCM) {
+		/*
+		 * For CCM Mode, the 128-bit IV contains the following:
+		 * | 0 .. 2 | 3 .. 7 | 8 .. (127-8*L) | (128-8*L) .. 127 |
+		 * |   L-1  |  Zero  |     Nonce      |      Counter     |
+		 * L needs to be between 2-8 (inclusive), i.e. 1 <= (L-1) <= 7
+		 * and the next 5 bits need to be zeroes. Else return -EINVAL
+		 */
+		u8 *iv = req->iv;
+		u8 L = iv[0];
+
+		if (L < 1 || L > 7)
+			return -EINVAL;
+		/*
+		 * DTHEv2 HW can only work with zero initial counter in CCM mode.
+		 * Check if the initial counter value is zero or not
+		 */
+		for (int i = 0; i < L + 1; ++i) {
+			if (iv[AES_IV_SIZE - 1 - i] != 0) {
+				is_zero_ctr = false;
+				break;
+			}
+		}
+	}
+
 	/*
 	 * Need to fallback to software in the following cases due to HW restrictions:
 	 * - Both AAD and plaintext/ciphertext are zero length
-	 * - AAD length is more than 2^32 - 1 bytes
-	 * PS: req->cryptlen is currently unsigned int type, which causes the above condition
-	 * tautologically false. If req->cryptlen were to be changed to a 64-bit type,
-	 * the check for this would need to be added below.
+	 * - For AES-GCM, AAD length is more than 2^32 - 1 bytes
+	 * - For AES-CCM, AAD length is more than 2^16 - 2^8 bytes
+	 * - For AES-CCM, plaintext/ciphertext length is more than 2^61 - 1 bytes
+	 * - For AES-CCM, AAD length is non-zero but plaintext/ciphertext length is zero
+	 * - For AES-CCM, the initial counter (last L+1 bytes of IV) is not all zeroes
+	 *
+	 * PS: req->cryptlen is currently unsigned int type, which causes the second and fourth
+	 * cases above tautologically false. If req->cryptlen is to be changed to a 64-bit
+	 * type, the check for these would also need to be added below.
 	 */
-	if (req->assoclen == 0 && cryptlen == 0) {
+	if ((req->assoclen == 0 && cryptlen == 0) ||
+	    (ctx->aes_mode == DTHE_AES_CCM && req->assoclen > DTHE_AES_CCM_AAD_MAXLEN) ||
+	    (ctx->aes_mode == DTHE_AES_CCM && cryptlen == 0) ||
+	    (ctx->aes_mode == DTHE_AES_CCM && !is_zero_ctr)) {
 		SYNC_AEAD_REQUEST_ON_STACK(subreq, ctx->aead_fb);
 
 		aead_request_set_callback(subreq, aead_request_flags(req),
@@ -1161,7 +1233,7 @@ static struct aead_engine_alg aead_algs[] = {
 	{
 		.base.init			= dthe_aead_init_tfm,
 		.base.exit			= dthe_aead_exit_tfm,
-		.base.setkey			= dthe_aead_setkey,
+		.base.setkey			= dthe_gcm_aes_setkey,
 		.base.setauthsize		= dthe_aead_setauthsize,
 		.base.maxauthsize		= AES_BLOCK_SIZE,
 		.base.encrypt			= dthe_aead_encrypt,
@@ -1183,6 +1255,31 @@ static struct aead_engine_alg aead_algs[] = {
 		},
 		.op.do_one_request = dthe_aead_run,
 	}, /* GCM AES */
+	{
+		.base.init			= dthe_aead_init_tfm,
+		.base.exit			= dthe_aead_exit_tfm,
+		.base.setkey			= dthe_ccm_aes_setkey,
+		.base.setauthsize		= dthe_aead_setauthsize,
+		.base.maxauthsize		= AES_BLOCK_SIZE,
+		.base.encrypt			= dthe_aead_encrypt,
+		.base.decrypt			= dthe_aead_decrypt,
+		.base.chunksize			= AES_BLOCK_SIZE,
+		.base.ivsize			= AES_IV_SIZE,
+		.base.base = {
+			.cra_name		= "ccm(aes)",
+			.cra_driver_name	= "ccm-aes-dthev2",
+			.cra_priority		= 299,
+			.cra_flags		= CRYPTO_ALG_TYPE_AEAD |
+						  CRYPTO_ALG_KERN_DRIVER_ONLY |
+						  CRYPTO_ALG_ASYNC |
+						  CRYPTO_ALG_NEED_FALLBACK,
+			.cra_blocksize		= 1,
+			.cra_ctxsize		= sizeof(struct dthe_tfm_ctx),
+			.cra_reqsize		= sizeof(struct dthe_aes_req_ctx),
+			.cra_module		= THIS_MODULE,
+		},
+		.op.do_one_request = dthe_aead_run,
+	}, /* CCM AES */
 };
 
 int dthe_register_aes_algs(void)
diff --git a/drivers/crypto/ti/dthev2-common.h b/drivers/crypto/ti/dthev2-common.h
index 7c54291359bf5..3b8d30b3408a0 100644
--- a/drivers/crypto/ti/dthev2-common.h
+++ b/drivers/crypto/ti/dthev2-common.h
@@ -39,6 +39,7 @@ enum dthe_aes_mode {
 	DTHE_AES_CTR,
 	DTHE_AES_XTS,
 	DTHE_AES_GCM,
+	DTHE_AES_CCM,
 };
 
 /* Driver specific struct definitions */
-- 
2.43.0

