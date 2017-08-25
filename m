From: Christian Lamparter <chunkeey@googlemail.com>
Subject: [RFC PATCH 08/12] crypto: crypto4xx: enable AES RFC3686, ECB, CFB and OFB offloads
Date: Fri, 25 Aug 2017 15:47:21 +0200
Message-ID: <668f5f89e62ccb2e410c5a63f35c64efe9bd0686.1503668705.git.chunkeey@googlemail.com>
References: <71020bd2e3f4100c3c0668a13fdad9d22c8884a7.1503668705.git.chunkeey@googlemail.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        David Miller <davem@davemloft.net>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wr0-f195.google.com ([209.85.128.195]:38671 "EHLO
        mail-wr0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932475AbdHYNre (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 25 Aug 2017 09:47:34 -0400
Received: by mail-wr0-f195.google.com with SMTP id o76so1138391wrb.5
        for <linux-crypto@vger.kernel.org>; Fri, 25 Aug 2017 06:47:34 -0700 (PDT)
In-Reply-To: <71020bd2e3f4100c3c0668a13fdad9d22c8884a7.1503668705.git.chunkeey@googlemail.com>
In-Reply-To: <0521bf298c4b6aeba2d1e1e89aac9929ebffd0d4.1503668705.git.chunkeey@googlemail.com>
References: <71020bd2e3f4100c3c0668a13fdad9d22c8884a7.1503668705.git.chunkeey@googlemail.com> <85532949069735593f777489c6efcb6d1b08cdec.1503668705.git.chunkeey@googlemail.com> <7f51944084eef13bebe5f052557533bf6ade4ebc.1503668705.git.chunkeey@googlemail.com> <44b9527904d134982932cb807a3fa6f36093acbf.1503668705.git.chunkeey@googlemail.com> <c623cda688571bc483f0c9a9fb4c17cda0514cdd.1503668705.git.chunkeey@googlemail.com> <575e998ebe72ea59e785263e11b2a44fb1c6d910.1503668705.git.chunkeey@googlemail.com> <0521bf298c4b6aeba2d1e1e89aac9929ebffd0d4.1503668705.git.chunkeey@googlemail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The crypto engine supports more than just aes-cbc. This patch
enables the remaining AES block cipher modes that pass the
testmanager's test vectors.

Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
---
 drivers/crypto/amcc/crypto4xx_alg.c  | 66 ++++++++++++++++++++++++
 drivers/crypto/amcc/crypto4xx_core.c | 98 ++++++++++++++++++++++++++++++++++++
 drivers/crypto/amcc/crypto4xx_core.h | 10 ++++
 drivers/crypto/amcc/crypto4xx_sa.h   |  3 ++
 4 files changed, 177 insertions(+)

diff --git a/drivers/crypto/amcc/crypto4xx_alg.c b/drivers/crypto/amcc/crypto4xx_alg.c
index 599b6326c3fb..c9597824a515 100644
--- a/drivers/crypto/amcc/crypto4xx_alg.c
+++ b/drivers/crypto/amcc/crypto4xx_alg.c
@@ -28,6 +28,7 @@
 #include <crypto/algapi.h>
 #include <crypto/aes.h>
 #include <crypto/sha.h>
+#include <crypto/ctr.h>
 #include "crypto4xx_reg_def.h"
 #include "crypto4xx_core.h"
 #include "crypto4xx_sa.h"
@@ -171,6 +172,71 @@ int crypto4xx_setkey_aes_cbc(struct crypto_ablkcipher *cipher,
 				    CRYPTO_FEEDBACK_MODE_NO_FB);
 }
 
+int crypto4xx_setkey_aes_cfb(struct crypto_ablkcipher *cipher,
+			     const u8 *key, unsigned int keylen)
+{
+	return crypto4xx_setkey_aes(cipher, key, keylen, CRYPTO_MODE_CFB,
+				    CRYPTO_FEEDBACK_MODE_128BIT_CFB);
+}
+
+int crypto4xx_setkey_aes_ecb(struct crypto_ablkcipher *cipher,
+			     const u8 *key, unsigned int keylen)
+{
+	return crypto4xx_setkey_aes(cipher, key, keylen, CRYPTO_MODE_ECB,
+				    CRYPTO_FEEDBACK_MODE_NO_FB);
+}
+
+int crypto4xx_setkey_aes_ofb(struct crypto_ablkcipher *cipher,
+			     const u8 *key, unsigned int keylen)
+{
+	return crypto4xx_setkey_aes(cipher, key, keylen, CRYPTO_MODE_OFB,
+				    CRYPTO_FEEDBACK_MODE_64BIT_OFB);
+}
+
+int crypto4xx_setkey_rfc3686(struct crypto_ablkcipher *cipher,
+			     const u8 *key, unsigned int keylen)
+{
+	struct crypto_tfm *tfm = crypto_ablkcipher_tfm(cipher);
+	struct crypto4xx_ctx *ctx = crypto_tfm_ctx(tfm);
+	int rc;
+
+	rc = crypto4xx_setkey_aes(cipher, key, keylen - CTR_RFC3686_NONCE_SIZE,
+		CRYPTO_MODE_CTR, CRYPTO_FEEDBACK_MODE_NO_FB);
+	if (rc)
+		return rc;
+
+	memcpy(ctx->state_record,
+		key + keylen - CTR_RFC3686_NONCE_SIZE, CTR_RFC3686_NONCE_SIZE);
+
+	return 0;
+}
+
+int crypto4xx_rfc3686_encrypt(struct ablkcipher_request *req)
+{
+	struct crypto4xx_ctx *ctx = crypto_tfm_ctx(req->base.tfm);
+	__be32 iv[AES_IV_SIZE / 4] = { *(u32 *)ctx->state_record,
+		*(u32 *) req->info, *(u32 *) (req->info + 4), cpu_to_be32(1) };
+
+	ctx->direction = DIR_OUTBOUND;
+	ctx->pd_ctl = 1;
+
+	return crypto4xx_build_pd(&req->base, ctx, req->src, req->dst,
+				  req->nbytes, iv, AES_IV_SIZE);
+}
+
+int crypto4xx_rfc3686_decrypt(struct ablkcipher_request *req)
+{
+	struct crypto4xx_ctx *ctx = crypto_tfm_ctx(req->base.tfm);
+	__be32 iv[AES_IV_SIZE / 4] = { *(u32 *)ctx->state_record,
+		*(u32 *) req->info, *(u32 *) (req->info + 4), cpu_to_be32(1) };
+
+	ctx->direction = DIR_INBOUND;
+	ctx->pd_ctl = 1;
+
+	return crypto4xx_build_pd(&req->base, ctx, req->src, req->dst,
+				  req->nbytes, iv, AES_IV_SIZE);
+}
+
 /**
  * HASH SHA1 Functions
  */
diff --git a/drivers/crypto/amcc/crypto4xx_core.c b/drivers/crypto/amcc/crypto4xx_core.c
index 9e96af725b31..3c086cf7b052 100644
--- a/drivers/crypto/amcc/crypto4xx_core.c
+++ b/drivers/crypto/amcc/crypto4xx_core.c
@@ -36,6 +36,7 @@
 #include <asm/dcr-regs.h>
 #include <asm/cacheflush.h>
 #include <crypto/aes.h>
+#include <crypto/ctr.h>
 #include <crypto/sha.h>
 #include "crypto4xx_reg_def.h"
 #include "crypto4xx_core.h"
@@ -1133,6 +1134,103 @@ struct crypto4xx_alg_common crypto4xx_alg[] = {
 			}
 		}
 	}},
+	{ .type = CRYPTO_ALG_TYPE_ABLKCIPHER, .u.cipher = {
+		.cra_name	= "cfb(aes)",
+		.cra_driver_name = "cfb-aes-ppc4xx",
+		.cra_priority	= CRYPTO4XX_CRYPTO_PRIORITY,
+		.cra_flags	= CRYPTO_ALG_TYPE_ABLKCIPHER |
+				  CRYPTO_ALG_ASYNC |
+				  CRYPTO_ALG_KERN_DRIVER_ONLY,
+		.cra_blocksize	= AES_BLOCK_SIZE,
+		.cra_ctxsize	= sizeof(struct crypto4xx_ctx),
+		.cra_type	= &crypto_ablkcipher_type,
+		.cra_init	= crypto4xx_alg_init,
+		.cra_exit	= crypto4xx_alg_exit,
+		.cra_module	= THIS_MODULE,
+		.cra_u		= {
+			.ablkcipher = {
+				.min_keysize	= AES_MIN_KEY_SIZE,
+				.max_keysize	= AES_MAX_KEY_SIZE,
+				.ivsize		= AES_IV_SIZE,
+				.setkey		= crypto4xx_setkey_aes_cfb,
+				.encrypt	= crypto4xx_encrypt,
+				.decrypt	= crypto4xx_decrypt,
+			}
+		}
+	} },
+	{ .type = CRYPTO_ALG_TYPE_ABLKCIPHER, .u.cipher = {
+		.cra_name	= "rfc3686(ctr(aes))",
+		.cra_driver_name = "rfc3686-ctr-aes-ppc4xx",
+		.cra_priority	= CRYPTO4XX_CRYPTO_PRIORITY,
+		.cra_flags	= CRYPTO_ALG_TYPE_ABLKCIPHER |
+				  CRYPTO_ALG_ASYNC |
+				  CRYPTO_ALG_KERN_DRIVER_ONLY,
+		.cra_blocksize	= AES_BLOCK_SIZE,
+		.cra_ctxsize	= sizeof(struct crypto4xx_ctx),
+		.cra_type	= &crypto_ablkcipher_type,
+		.cra_init	= crypto4xx_alg_init,
+		.cra_exit	= crypto4xx_alg_exit,
+		.cra_module	= THIS_MODULE,
+		.cra_u		= {
+			.ablkcipher = {
+				.min_keysize	= AES_MIN_KEY_SIZE +
+						  CTR_RFC3686_NONCE_SIZE,
+				.max_keysize	= AES_MAX_KEY_SIZE +
+						  CTR_RFC3686_NONCE_SIZE,
+				.ivsize		= CTR_RFC3686_IV_SIZE,
+				.setkey		= crypto4xx_setkey_rfc3686,
+				.encrypt	= crypto4xx_rfc3686_encrypt,
+				.decrypt	= crypto4xx_rfc3686_decrypt,
+			}
+		}
+	} },
+	{ .type = CRYPTO_ALG_TYPE_ABLKCIPHER, .u.cipher = {
+		.cra_name	= "ecb(aes)",
+		.cra_driver_name = "ecb-aes-ppc4xx",
+		.cra_priority	= CRYPTO4XX_CRYPTO_PRIORITY,
+		.cra_flags	= CRYPTO_ALG_TYPE_ABLKCIPHER |
+				  CRYPTO_ALG_ASYNC |
+				  CRYPTO_ALG_KERN_DRIVER_ONLY,
+		.cra_blocksize	= AES_BLOCK_SIZE,
+		.cra_ctxsize	= sizeof(struct crypto4xx_ctx),
+		.cra_type	= &crypto_ablkcipher_type,
+		.cra_init	= crypto4xx_alg_init,
+		.cra_exit	= crypto4xx_alg_exit,
+		.cra_module	= THIS_MODULE,
+		.cra_u		= {
+			.ablkcipher = {
+				.min_keysize	= AES_MIN_KEY_SIZE,
+				.max_keysize	= AES_MAX_KEY_SIZE,
+				.setkey		= crypto4xx_setkey_aes_ecb,
+				.encrypt	= crypto4xx_encrypt,
+				.decrypt	= crypto4xx_decrypt,
+			}
+		}
+	} },
+	{ .type = CRYPTO_ALG_TYPE_ABLKCIPHER, .u.cipher = {
+		.cra_name	= "ofb(aes)",
+		.cra_driver_name = "ofb-aes-ppc4xx",
+		.cra_priority	= CRYPTO4XX_CRYPTO_PRIORITY,
+		.cra_flags	= CRYPTO_ALG_TYPE_ABLKCIPHER |
+				  CRYPTO_ALG_ASYNC |
+				  CRYPTO_ALG_KERN_DRIVER_ONLY,
+		.cra_blocksize	= AES_BLOCK_SIZE,
+		.cra_ctxsize	= sizeof(struct crypto4xx_ctx),
+		.cra_type	= &crypto_ablkcipher_type,
+		.cra_init	= crypto4xx_alg_init,
+		.cra_exit	= crypto4xx_alg_exit,
+		.cra_module	= THIS_MODULE,
+		.cra_u		= {
+			.ablkcipher = {
+				.min_keysize	= AES_MIN_KEY_SIZE,
+				.max_keysize	= AES_MAX_KEY_SIZE,
+				.ivsize		= AES_IV_SIZE,
+				.setkey		= crypto4xx_setkey_aes_cbc,
+				.encrypt	= crypto4xx_encrypt,
+				.decrypt	= crypto4xx_decrypt,
+			}
+		}
+	} },
 };
 
 /**
diff --git a/drivers/crypto/amcc/crypto4xx_core.h b/drivers/crypto/amcc/crypto4xx_core.h
index e3b822907197..f886b8bdc868 100644
--- a/drivers/crypto/amcc/crypto4xx_core.h
+++ b/drivers/crypto/amcc/crypto4xx_core.h
@@ -171,8 +171,18 @@ u32 crypto4xx_build_pd(struct crypto_async_request *req,
 		       void *iv, u32 iv_len);
 int crypto4xx_setkey_aes_cbc(struct crypto_ablkcipher *cipher,
 			     const u8 *key, unsigned int keylen);
+int crypto4xx_setkey_aes_cfb(struct crypto_ablkcipher *cipher,
+			     const u8 *key, unsigned int keylen);
+int crypto4xx_setkey_aes_ecb(struct crypto_ablkcipher *cipher,
+			     const u8 *key, unsigned int keylen);
+int crypto4xx_setkey_aes_ofb(struct crypto_ablkcipher *cipher,
+			     const u8 *key, unsigned int keylen);
+int crypto4xx_setkey_rfc3686(struct crypto_ablkcipher *cipher,
+			     const u8 *key, unsigned int keylen);
 int crypto4xx_encrypt(struct ablkcipher_request *req);
 int crypto4xx_decrypt(struct ablkcipher_request *req);
+int crypto4xx_rfc3686_encrypt(struct ablkcipher_request *req);
+int crypto4xx_rfc3686_decrypt(struct ablkcipher_request *req);
 int crypto4xx_sha1_alg_init(struct crypto_tfm *tfm);
 int crypto4xx_hash_digest(struct ahash_request *req);
 int crypto4xx_hash_final(struct ahash_request *req);
diff --git a/drivers/crypto/amcc/crypto4xx_sa.h b/drivers/crypto/amcc/crypto4xx_sa.h
index 3c3dfcaf4e0f..7cc04f1ff8a0 100644
--- a/drivers/crypto/amcc/crypto4xx_sa.h
+++ b/drivers/crypto/amcc/crypto4xx_sa.h
@@ -112,6 +112,9 @@ union sa_command_0 {
 
 #define CRYPTO_MODE_ECB				0
 #define CRYPTO_MODE_CBC				1
+#define CRYPTO_MODE_OFB				2
+#define CRYPTO_MODE_CFB				3
+#define CRYPTO_MODE_CTR				4
 
 #define CRYPTO_FEEDBACK_MODE_NO_FB		0
 #define CRYPTO_FEEDBACK_MODE_64BIT_OFB		0
-- 
2.14.1
