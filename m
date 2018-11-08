Return-Path: <SRS0=HYoH=NT=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from inva021.nxp.com ([92.121.34.21]:37014 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726684AbeKHXMa (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 8 Nov 2018 18:12:30 -0500
From: =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "David S. Miller" <davem@davemloft.net>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        Cristian Stoica <cristian.stoica@microchip.com>,
        linux-crypto@vger.kernel.org, Carmen Iorga <carmen.iorga@nxp.com>
Subject: [PATCH 2/5] crypto: caam/qi2 - add support for ChaCha20
Date: Thu,  8 Nov 2018 15:36:28 +0200
Message-Id: <20181108133631.15779-3-horia.geanta@nxp.com>
In-Reply-To: <20181108133631.15779-1-horia.geanta@nxp.com>
References: <20181108133631.15779-1-horia.geanta@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Add support for ChaCha20 skcipher algorithm.

Signed-off-by: Carmen Iorga <carmen.iorga@nxp.com>
Signed-off-by: Horia Geantă <horia.geanta@nxp.com>
---
 drivers/crypto/caam/caamalg_desc.c |  6 ++++--
 drivers/crypto/caam/caamalg_qi2.c  | 27 +++++++++++++++++++++++++--
 drivers/crypto/caam/compat.h       |  1 +
 drivers/crypto/caam/desc.h         |  6 ++++++
 4 files changed, 36 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/caam/caamalg_desc.c b/drivers/crypto/caam/caamalg_desc.c
index 1a6f0da14106..d850590079a2 100644
--- a/drivers/crypto/caam/caamalg_desc.c
+++ b/drivers/crypto/caam/caamalg_desc.c
@@ -1228,7 +1228,8 @@ static inline void skcipher_append_src_dst(u32 *desc)
  * @desc: pointer to buffer used for descriptor construction
  * @cdata: pointer to block cipher transform definitions
  *         Valid algorithm values - one of OP_ALG_ALGSEL_{AES, DES, 3DES} ANDed
- *         with OP_ALG_AAI_CBC or OP_ALG_AAI_CTR_MOD128.
+ *         with OP_ALG_AAI_CBC or OP_ALG_AAI_CTR_MOD128
+ *                                - OP_ALG_ALGSEL_CHACHA20
  * @ivsize: initialization vector size
  * @is_rfc3686: true when ctr(aes) is wrapped by rfc3686 template
  * @ctx1_iv_off: IV offset in CONTEXT1 register
@@ -1293,7 +1294,8 @@ EXPORT_SYMBOL(cnstr_shdsc_skcipher_encap);
  * @desc: pointer to buffer used for descriptor construction
  * @cdata: pointer to block cipher transform definitions
  *         Valid algorithm values - one of OP_ALG_ALGSEL_{AES, DES, 3DES} ANDed
- *         with OP_ALG_AAI_CBC or OP_ALG_AAI_CTR_MOD128.
+ *         with OP_ALG_AAI_CBC or OP_ALG_AAI_CTR_MOD128
+ *                                - OP_ALG_ALGSEL_CHACHA20
  * @ivsize: initialization vector size
  * @is_rfc3686: true when ctr(aes) is wrapped by rfc3686 template
  * @ctx1_iv_off: IV offset in CONTEXT1 register
diff --git a/drivers/crypto/caam/caamalg_qi2.c b/drivers/crypto/caam/caamalg_qi2.c
index 7d8ac0222fa3..a9e264bb9629 100644
--- a/drivers/crypto/caam/caamalg_qi2.c
+++ b/drivers/crypto/caam/caamalg_qi2.c
@@ -816,7 +816,9 @@ static int skcipher_setkey(struct crypto_skcipher *skcipher, const u8 *key,
 	u32 *desc;
 	u32 ctx1_iv_off = 0;
 	const bool ctr_mode = ((ctx->cdata.algtype & OP_ALG_AAI_MASK) ==
-			       OP_ALG_AAI_CTR_MOD128);
+			       OP_ALG_AAI_CTR_MOD128) &&
+			       ((ctx->cdata.algtype & OP_ALG_ALGSEL_MASK) !=
+			       OP_ALG_ALGSEL_CHACHA20);
 	const bool is_rfc3686 = alg->caam.rfc3686;
 
 	print_hex_dump_debug("key in @" __stringify(__LINE__)": ",
@@ -1494,7 +1496,23 @@ static struct caam_skcipher_alg driver_algs[] = {
 			.ivsize = AES_BLOCK_SIZE,
 		},
 		.caam.class1_alg_type = OP_ALG_ALGSEL_AES | OP_ALG_AAI_XTS,
-	}
+	},
+	{
+		.skcipher = {
+			.base = {
+				.cra_name = "chacha20",
+				.cra_driver_name = "chacha20-caam-qi2",
+				.cra_blocksize = 1,
+			},
+			.setkey = skcipher_setkey,
+			.encrypt = skcipher_encrypt,
+			.decrypt = skcipher_decrypt,
+			.min_keysize = CHACHA20_KEY_SIZE,
+			.max_keysize = CHACHA20_KEY_SIZE,
+			.ivsize = CHACHA20_IV_SIZE,
+		},
+		.caam.class1_alg_type = OP_ALG_ALGSEL_CHACHA20,
+	},
 };
 
 static struct caam_aead_alg driver_aeads[] = {
@@ -4908,6 +4926,11 @@ static int dpaa2_caam_probe(struct fsl_mc_device *dpseci_dev)
 		    alg_sel == OP_ALG_ALGSEL_AES)
 			continue;
 
+		/* Skip CHACHA20 algorithms if not supported by device */
+		if (alg_sel == OP_ALG_ALGSEL_CHACHA20 &&
+		    !priv->sec_attr.ccha_acc_num)
+			continue;
+
 		t_alg->caam.dev = dev;
 		caam_skcipher_alg_init(t_alg);
 
diff --git a/drivers/crypto/caam/compat.h b/drivers/crypto/caam/compat.h
index 9604ff7a335e..a5081b4050b6 100644
--- a/drivers/crypto/caam/compat.h
+++ b/drivers/crypto/caam/compat.h
@@ -36,6 +36,7 @@
 #include <crypto/gcm.h>
 #include <crypto/sha.h>
 #include <crypto/md5.h>
+#include <crypto/chacha20.h>
 #include <crypto/internal/aead.h>
 #include <crypto/authenc.h>
 #include <crypto/akcipher.h>
diff --git a/drivers/crypto/caam/desc.h b/drivers/crypto/caam/desc.h
index ec1ef06049b4..9d117e51629f 100644
--- a/drivers/crypto/caam/desc.h
+++ b/drivers/crypto/caam/desc.h
@@ -1159,6 +1159,7 @@
 #define OP_ALG_ALGSEL_KASUMI	(0x70 << OP_ALG_ALGSEL_SHIFT)
 #define OP_ALG_ALGSEL_CRC	(0x90 << OP_ALG_ALGSEL_SHIFT)
 #define OP_ALG_ALGSEL_SNOW_F9	(0xA0 << OP_ALG_ALGSEL_SHIFT)
+#define OP_ALG_ALGSEL_CHACHA20	(0xD0 << OP_ALG_ALGSEL_SHIFT)
 
 #define OP_ALG_AAI_SHIFT	4
 #define OP_ALG_AAI_MASK		(0x1ff << OP_ALG_AAI_SHIFT)
@@ -1206,6 +1207,11 @@
 #define OP_ALG_AAI_RNG4_AI	(0x80 << OP_ALG_AAI_SHIFT)
 #define OP_ALG_AAI_RNG4_SK	(0x100 << OP_ALG_AAI_SHIFT)
 
+/* Chacha20 AAI set */
+#define OP_ALG_AAI_AEAD	(0x002 << OP_ALG_AAI_SHIFT)
+#define OP_ALG_AAI_KEYSTREAM	(0x001 << OP_ALG_AAI_SHIFT)
+#define OP_ALG_AAI_BC8		(0x008 << OP_ALG_AAI_SHIFT)
+
 /* hmac/smac AAI set */
 #define OP_ALG_AAI_HASH		(0x00 << OP_ALG_AAI_SHIFT)
 #define OP_ALG_AAI_HMAC		(0x01 << OP_ALG_AAI_SHIFT)
-- 
2.16.2
