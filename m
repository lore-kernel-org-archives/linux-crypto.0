Received: from lelvem-ot02.ext.ti.com (lelvem-ot02.ext.ti.com [198.47.23.235])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35FF03168E3;
	Wed, 10 Sep 2025 10:08:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.47.23.235
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757498911; cv=none; b=Sesj2frahSNkXNENM0f92MeE7DVzgjsPxrmJ9rF17ntg36Qed7uhSyAxlra17MA7u3Q8RItA4Lb2GmMe0eQuvNZyjU6AU9odjAtyZ6z1nYEOXyJ0zP8pQDDttcw35bawrU+D9Bh16NI/KbW5Q3fr8Hp2jgwYrjVnr/MPh/fIg38=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757498911; c=relaxed/simple;
	bh=VB5cgXo2xxVwk9IAD5Uf+ULaKOy+5RNY9wME4q2c45c=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BBPXEtJbAsBqwXHrpNmrSgURExuvb9brB47vfnUKhLH/jFJqynP3+o8gEqDeYopxdOu52KF/yWEdcdXatUiKpG+cQBkfLesR3241v4QNu+njd8LDtq4IvC/v1F8BzrkFHVfgnzFvpk9pJSQhsbwoqwSBVY5iQ4/iSV0z3T3MeP8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b=ljv+NdLq; arc=none smtp.client-ip=198.47.23.235
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="ljv+NdLq"
Received: from fllvem-sh04.itg.ti.com ([10.64.41.54])
	by lelvem-ot02.ext.ti.com (8.15.2/8.15.2) with ESMTP id 58AA8P1N545522;
	Wed, 10 Sep 2025 05:08:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
	s=ti-com-17Q1; t=1757498905;
	bh=7NzzeGx5+r6n9YJMU71Yapk0WyZVB72LHdmmk/QXsTQ=;
	h=From:To:CC:Subject:Date:In-Reply-To:References;
	b=ljv+NdLqaCTtyPF6TL/eEqnR2+nCtIHxln1ETOIUCF2T3xClmEOAf/5q6LhEc/tpu
	 KvF6CnR9mBIgxIir+fxEpiFR2RGJRxzvyIWNvqS9nXJmyb+ZeMRU/Abk2CXDJqaUgQ
	 5int8nn++K9mbsgq/2Ne4OH8V7shZR13Y5WBeC+o=
Received: from DFLE104.ent.ti.com (dfle104.ent.ti.com [10.64.6.25])
	by fllvem-sh04.itg.ti.com (8.18.1/8.18.1) with ESMTPS id 58AA8PHb1074300
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-SHA256 bits=128 verify=FAIL);
	Wed, 10 Sep 2025 05:08:25 -0500
Received: from DFLE213.ent.ti.com (10.64.6.71) by DFLE104.ent.ti.com
 (10.64.6.25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.55; Wed, 10
 Sep 2025 05:08:24 -0500
Received: from lelvem-mr05.itg.ti.com (10.180.75.9) by DFLE213.ent.ti.com
 (10.64.6.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Wed, 10 Sep 2025 05:08:25 -0500
Received: from pratham-Workstation-PC (pratham-workstation-pc.dhcp.ti.com [10.24.69.191])
	by lelvem-mr05.itg.ti.com (8.18.1/8.18.1) with ESMTP id 58AA8NlW318114;
	Wed, 10 Sep 2025 05:08:24 -0500
From: T Pratham <t-pratham@ti.com>
To: T Pratham <t-pratham@ti.com>, Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
CC: Kamlesh Gurudasani <kamlesh@ti.com>, Manorit Chawdhry <m-chawdhry@ti.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Praneeth Bajjuri <praneeth@ti.com>, Vishal Mahaveer <vishalm@ti.com>,
        Kavitha Malarvizhi <k-malarvizhi@ti.com>,
        <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v3 4/4] crypto: ti: Add support for AES-CCM in DTHEv2 driver
Date: Wed, 10 Sep 2025 14:46:56 +0530
Message-ID: <20250910100742.3747614-5-t-pratham@ti.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250910100742.3747614-1-t-pratham@ti.com>
References: <20250910100742.3747614-1-t-pratham@ti.com>
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
 drivers/crypto/ti/Kconfig         |  1 +
 drivers/crypto/ti/dthev2-aes.c    | 97 ++++++++++++++++++++++++++-----
 drivers/crypto/ti/dthev2-common.h |  1 +
 3 files changed, 83 insertions(+), 16 deletions(-)

diff --git a/drivers/crypto/ti/Kconfig b/drivers/crypto/ti/Kconfig
index e1ef84b39267..02eff4f0e04b 100644
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
index ddcdefbc375a..271f99b57c81 100644
--- a/drivers/crypto/ti/dthev2-aes.c
+++ b/drivers/crypto/ti/dthev2-aes.c
@@ -16,6 +16,7 @@
 
 #include "dthev2-common.h"
 
+#include <linux/bitfield.h>
 #include <linux/delay.h>
 #include <linux/dmaengine.h>
 #include <linux/dma-mapping.h>
@@ -68,6 +69,7 @@ enum aes_ctrl_mode_masks {
 	AES_CTRL_CTR_MASK = BIT(6),
 	AES_CTRL_XTS_MASK = BIT(12) | BIT(11),
 	AES_CTRL_GCM_MASK = BIT(17) | BIT(16) | BIT(6),
+	AES_CTRL_CCM_MASK = BIT(18) | BIT(6),
 };
 
 #define DTHE_AES_CTRL_MODE_CLEAR_MASK		~GENMASK(28, 5)
@@ -80,6 +82,10 @@ enum aes_ctrl_mode_masks {
 
 #define DTHE_AES_CTRL_CTR_WIDTH_128B		(BIT(7) | BIT(8))
 
+#define DTHE_AES_CCM_L_FROM_IV_MASK		GENMASK(2, 0)
+#define DTHE_AES_CTRL_CCM_L_MASK		GENMASK(21, 19)
+#define DTHE_AES_CTRL_CCM_M_MAXVAL		GENMASK(24, 22)
+
 #define DTHE_AES_CTRL_SAVE_CTX_SET		BIT(29)
 
 #define DTHE_AES_CTRL_OUTPUT_READY		BIT_MASK(0)
@@ -95,6 +101,8 @@ enum aes_ctrl_mode_masks {
 #define AES_BLOCK_WORDS				(AES_BLOCK_SIZE / sizeof(u32))
 #define AES_IV_WORDS				AES_BLOCK_WORDS
 #define DTHE_AES_GCM_AAD_MAXLEN			(BIT_ULL(32) - 1)
+#define DTHE_AES_CCM_AAD_MAXLEN			(BIT(16) - BIT(8))
+#define DTHE_AES_CCM_CRYPT_MAXLEN		(BIT_ULL(61) - 1)
 #define POLL_TIMEOUT_INTERVAL			HZ
 
 static int dthe_poll_reg(struct dthe_data *dev_data, u32 reg, u32 bit)
@@ -246,6 +254,12 @@ static void dthe_aes_set_ctrl_key(struct dthe_tfm_ctx *ctx,
 	case DTHE_AES_GCM:
 		ctrl_val |= AES_CTRL_GCM_MASK;
 		break;
+	case DTHE_AES_CCM:
+		ctrl_val |= AES_CTRL_CCM_MASK;
+		ctrl_val |= FIELD_PREP(DTHE_AES_CTRL_CCM_L_MASK,
+				       (iv_in[0] & DTHE_AES_CCM_L_FROM_IV_MASK));
+		ctrl_val |= DTHE_AES_CTRL_CCM_M_MAXVAL;
+		break;
 	}
 
 	if (iv_in) {
@@ -732,10 +746,6 @@ static int dthe_aead_setkey(struct crypto_aead *tfm, const u8 *key, unsigned int
 	if (keylen != AES_KEYSIZE_128 && keylen != AES_KEYSIZE_192 && keylen != AES_KEYSIZE_256)
 		return -EINVAL;
 
-	ctx->aes_mode = DTHE_AES_GCM;
-	ctx->keylen = keylen;
-	memcpy(ctx->key, key, keylen);
-
 	crypto_aead_clear_flags(ctx->aead_fb, CRYPTO_TFM_REQ_MASK);
 	crypto_aead_set_flags(ctx->aead_fb,
 			      crypto_aead_get_flags(tfm) &
@@ -744,6 +754,28 @@ static int dthe_aead_setkey(struct crypto_aead *tfm, const u8 *key, unsigned int
 	return crypto_aead_setkey(ctx->aead_fb, key, keylen);
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
@@ -881,14 +913,18 @@ static int dthe_aead_run(struct crypto_engine *engine, void *areq)
 
 	u32 iv_in[AES_IV_WORDS];
 
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
@@ -975,12 +1011,16 @@ static int dthe_aead_crypt(struct aead_request *req)
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
+	 *
+	 * PS: req->cryptlen is currently unsigned int type, which causes the second and fourth
+	 * cases above tautologically false. If req->cryptlen is to be changed to a 64-bit
+	 * type, the check for these would also need to be added below.
 	 */
-	if (req->assoclen == 0 && cryptlen == 0) {
+	if ((req->assoclen == 0 && cryptlen == 0) ||
+	    (ctx->aes_mode == DTHE_AES_CCM && req->assoclen > DTHE_AES_CCM_AAD_MAXLEN)) {
 		struct aead_request *subreq = &rctx->fb_req;
 		int ret;
 
@@ -1111,7 +1151,7 @@ static struct aead_engine_alg aead_algs[] = {
 	{
 		.base.init			= dthe_aead_init_tfm,
 		.base.exit			= dthe_aead_exit_tfm,
-		.base.setkey			= dthe_aead_setkey,
+		.base.setkey			= dthe_gcm_aes_setkey,
 		.base.setauthsize		= dthe_aead_setauthsize,
 		.base.maxauthsize		= AES_BLOCK_SIZE,
 		.base.encrypt			= dthe_aead_encrypt,
@@ -1133,6 +1173,31 @@ static struct aead_engine_alg aead_algs[] = {
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
index 3c9fe0633cca..3b3b133fc984 100644
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

