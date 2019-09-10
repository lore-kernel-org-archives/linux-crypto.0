Return-Path: <SRS0=06DT=XF=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ACAF9C49ED9
	for <linux-crypto@archiver.kernel.org>; Tue, 10 Sep 2019 15:41:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7BB9F21479
	for <linux-crypto@archiver.kernel.org>; Tue, 10 Sep 2019 15:41:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GW1mRJl0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730875AbfIJPlD (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 10 Sep 2019 11:41:03 -0400
Received: from mail-ed1-f66.google.com ([209.85.208.66]:36444 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731756AbfIJPlD (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 10 Sep 2019 11:41:03 -0400
Received: by mail-ed1-f66.google.com with SMTP id f2so11201034edw.3
        for <linux-crypto@vger.kernel.org>; Tue, 10 Sep 2019 08:41:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=ne9sn1QAVZoon3MszFj0moaSHShKWDRkNitirJQ85YI=;
        b=GW1mRJl0Ko1fKb+/g7GzMnq0vzbwhQdIhoPZzRKtF/ZpvVA6SNBF1qi2gYp810F5s9
         cZcAWuf5Ycjjea1B+6GH+67zFMdp1caXe+ihEt1kn1yDWi8rqlLzdgjkHaQ88ZxX3x9q
         kXBwhY3MEhKsyEvo1RGUskLtN1JpoqP/4IlDtRu4qJEuDfd95eq5Vg3gyz9ql523eQcl
         AuiGiU5Z2RR7yRRhehwmuKzuQENw7fxduDEK+DIM0KKiUa/hmeTowNktp7SD2qim3dWP
         pwwYtGfkWV1LiRs9a3D8MrkTmJItZp2lIoDeHjN5wipZKng1Sj6N6Ie8wTEm7EL9Ru7p
         +TfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=ne9sn1QAVZoon3MszFj0moaSHShKWDRkNitirJQ85YI=;
        b=EFeWgB5OguALHSxGu4DHFvSOHwjmvvCdoTPZMUFw3TYt35GaIszNhSS7WUeTtakPK7
         GYh6TQaoTtiqUAO7CkmP8Rxfi4Igv9IFMdbo59bQdWjS2dnC8PIVxgnW52T8iCkoyz6c
         FOShfY/wi1s5SCGa2KtsAaIBnLPj9CtcKJ6InQPSpI+9N2llTWMAnAHhh6jr+wzXaeWt
         JiGykr4gwVIdT1kEL9Q7OJ5qzFeWmZsakFwAss7WxefjaFRsuKih1c+5gQjk5PRsd5p1
         o+X4+JrzhAPAavU1Kd5KKxtaIv9/tl83oOPeGVT+UNuCnQj2dqvxbvHiBaUsJJmBF/xk
         IeRw==
X-Gm-Message-State: APjAAAWhMSbqwwM59smZfRNM1Q6Clh+IOAtdvoXjpcj+xEJgcz17IPKc
        43fmjt+AqsT/8NvOrRHHd0Zft2C4
X-Google-Smtp-Source: APXvYqzWQls7zsd+C2Sk/r0C0OW0bfVWQ06tN//VIMlEwZJV2FsOV0kKPYjQ45TWpqSlJtSfGa1y/A==
X-Received: by 2002:a17:906:d216:: with SMTP id w22mr8160119ejz.14.1568130061509;
        Tue, 10 Sep 2019 08:41:01 -0700 (PDT)
Received: from localhost.localdomain.com ([188.204.2.113])
        by smtp.gmail.com with ESMTPSA id w14sm3676014eda.69.2019.09.10.08.41.00
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 10 Sep 2019 08:41:00 -0700 (PDT)
From:   Pascal van Leeuwen <pascalvanl@gmail.com>
X-Google-Original-From: Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
To:     linux-crypto@vger.kernel.org
Cc:     antoine.tenart@bootlin.com, herbert@gondor.apana.org.au,
        davem@davemloft.net,
        Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
Subject: [PATCH 1/2] crypto: inside-secure - Added support for the CHACHA20 skcipher
Date:   Tue, 10 Sep 2019 16:38:12 +0200
Message-Id: <1568126293-4039-2-git-send-email-pvanleeuwen@verimatrix.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1568126293-4039-1-git-send-email-pvanleeuwen@verimatrix.com>
References: <1568126293-4039-1-git-send-email-pvanleeuwen@verimatrix.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Added support for the CHACHA20 skcipher algorithm.
Tested on an eip197c-iesb configuration in the Xilinx VCU118 devboard,
passes all testmgr vectors plus the extra fuzzing tests.

Signed-off-by: Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
---
 drivers/crypto/inside-secure/safexcel.c        |  1 +
 drivers/crypto/inside-secure/safexcel.h        |  3 +
 drivers/crypto/inside-secure/safexcel_cipher.c | 83 +++++++++++++++++++++++++-
 3 files changed, 85 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/inside-secure/safexcel.c b/drivers/crypto/inside-secure/safexcel.c
index a34bf8c..fd9c9e7 100644
--- a/drivers/crypto/inside-secure/safexcel.c
+++ b/drivers/crypto/inside-secure/safexcel.c
@@ -1173,6 +1173,7 @@ static int safexcel_request_ring_irq(void *pdev, int irqid,
 	&safexcel_alg_cbcmac,
 	&safexcel_alg_xcbcmac,
 	&safexcel_alg_cmac,
+	&safexcel_alg_chacha20,
 };
 
 static int safexcel_register_algorithms(struct safexcel_crypto_priv *priv)
diff --git a/drivers/crypto/inside-secure/safexcel.h b/drivers/crypto/inside-secure/safexcel.h
index 6ddc6d1..c7f1a20 100644
--- a/drivers/crypto/inside-secure/safexcel.h
+++ b/drivers/crypto/inside-secure/safexcel.h
@@ -358,6 +358,7 @@ struct safexcel_context_record {
 #define CONTEXT_CONTROL_CRYPTO_ALG_AES128	(0x5 << 17)
 #define CONTEXT_CONTROL_CRYPTO_ALG_AES192	(0x6 << 17)
 #define CONTEXT_CONTROL_CRYPTO_ALG_AES256	(0x7 << 17)
+#define CONTEXT_CONTROL_CRYPTO_ALG_CHACHA20	(0x8 << 17)
 #define CONTEXT_CONTROL_DIGEST_PRECOMPUTED	(0x1 << 21)
 #define CONTEXT_CONTROL_DIGEST_XCM		(0x2 << 21)
 #define CONTEXT_CONTROL_DIGEST_HMAC		(0x3 << 21)
@@ -378,6 +379,7 @@ struct safexcel_context_record {
 /* control1 */
 #define CONTEXT_CONTROL_CRYPTO_MODE_ECB		(0 << 0)
 #define CONTEXT_CONTROL_CRYPTO_MODE_CBC		(1 << 0)
+#define CONTEXT_CONTROL_CHACHA20_MODE_256_32	(2 << 0)
 #define CONTEXT_CONTROL_CRYPTO_MODE_OFB		(4 << 0)
 #define CONTEXT_CONTROL_CRYPTO_MODE_CFB		(5 << 0)
 #define CONTEXT_CONTROL_CRYPTO_MODE_CTR_LOAD	(6 << 0)
@@ -858,5 +860,6 @@ int safexcel_hmac_setkey(const char *alg, const u8 *key, unsigned int keylen,
 extern struct safexcel_alg_template safexcel_alg_cbcmac;
 extern struct safexcel_alg_template safexcel_alg_xcbcmac;
 extern struct safexcel_alg_template safexcel_alg_cmac;
+extern struct safexcel_alg_template safexcel_alg_chacha20;
 
 #endif
diff --git a/drivers/crypto/inside-secure/safexcel_cipher.c b/drivers/crypto/inside-secure/safexcel_cipher.c
index 023cabc..44dc13a 100644
--- a/drivers/crypto/inside-secure/safexcel_cipher.c
+++ b/drivers/crypto/inside-secure/safexcel_cipher.c
@@ -5,13 +5,14 @@
  * Antoine Tenart <antoine.tenart@free-electrons.com>
  */
 
+#include <asm/unaligned.h>
 #include <linux/device.h>
 #include <linux/dma-mapping.h>
 #include <linux/dmapool.h>
-
 #include <crypto/aead.h>
 #include <crypto/aes.h>
 #include <crypto/authenc.h>
+#include <crypto/chacha.h>
 #include <crypto/ctr.h>
 #include <crypto/des.h>
 #include <crypto/gcm.h>
@@ -33,6 +34,7 @@ enum safexcel_cipher_alg {
 	SAFEXCEL_DES,
 	SAFEXCEL_3DES,
 	SAFEXCEL_AES,
+	SAFEXCEL_CHACHA20,
 };
 
 struct safexcel_cipher_ctx {
@@ -81,6 +83,15 @@ static void safexcel_cipher_token(struct safexcel_cipher_ctx *ctx, u8 *iv,
 		cdesc->control_data.token[3] = cpu_to_be32(1);
 
 		return;
+	} else if (ctx->alg == SAFEXCEL_CHACHA20) {
+		cdesc->control_data.options |= EIP197_OPTION_4_TOKEN_IV_CMD;
+
+		/* 96 bit nonce part */
+		memcpy(&cdesc->control_data.token[0], &iv[4], 12);
+		/* 32 bit counter */
+		cdesc->control_data.token[3] = *(u32 *)iv;
+
+		return;
 	} else if (ctx->xcm == EIP197_XCM_MODE_GCM) {
 		cdesc->control_data.options |= EIP197_OPTION_4_TOKEN_IV_CMD;
 
@@ -112,7 +123,7 @@ static void safexcel_cipher_token(struct safexcel_cipher_ctx *ctx, u8 *iv,
 			block_sz = DES3_EDE_BLOCK_SIZE;
 			cdesc->control_data.options |= EIP197_OPTION_2_TOKEN_IV_CMD;
 			break;
-		case SAFEXCEL_AES:
+		default: /* case SAFEXCEL_AES */
 			block_sz = AES_BLOCK_SIZE;
 			cdesc->control_data.options |= EIP197_OPTION_4_TOKEN_IV_CMD;
 			break;
@@ -486,6 +497,9 @@ static int safexcel_context_control(struct safexcel_cipher_ctx *ctx,
 				ctx->key_len >> ctx->xts);
 			return -EINVAL;
 		}
+	} else if (ctx->alg == SAFEXCEL_CHACHA20) {
+		cdesc->control_data.control0 |=
+			CONTEXT_CONTROL_CRYPTO_ALG_CHACHA20;
 	}
 
 	return 0;
@@ -2313,3 +2327,68 @@ struct safexcel_alg_template safexcel_alg_ccm = {
 		},
 	},
 };
+
+static int safexcel_skcipher_chacha20_setkey(struct crypto_skcipher *ctfm,
+					     const u8 *key, unsigned int len)
+{
+	struct safexcel_cipher_ctx *ctx = crypto_skcipher_ctx(ctfm);
+	struct safexcel_crypto_priv *priv = ctx->priv;
+	int i;
+
+	if (len != CHACHA_KEY_SIZE) {
+		crypto_skcipher_set_flags(ctfm, CRYPTO_TFM_RES_BAD_KEY_LEN);
+		return -EINVAL;
+	}
+
+	if (priv->flags & EIP197_TRC_CACHE && ctx->base.ctxr_dma) {
+		for (i = 0; i < CHACHA_KEY_SIZE / sizeof(u32); i++) {
+			if (ctx->key[i] !=
+			    get_unaligned_le32(key + i * sizeof(u32))) {
+				ctx->base.needs_inv = true;
+				break;
+			}
+		}
+	}
+
+	for (i = 0; i < CHACHA_KEY_SIZE / sizeof(u32); i++)
+		ctx->key[i] = get_unaligned_le32(key + i * sizeof(u32));
+	ctx->key_len = CHACHA_KEY_SIZE;
+
+	return 0;
+}
+
+static int safexcel_skcipher_chacha20_cra_init(struct crypto_tfm *tfm)
+{
+	struct safexcel_cipher_ctx *ctx = crypto_tfm_ctx(tfm);
+
+	safexcel_skcipher_cra_init(tfm);
+	ctx->alg  = SAFEXCEL_CHACHA20;
+	ctx->mode = CONTEXT_CONTROL_CHACHA20_MODE_256_32;
+	return 0;
+}
+
+struct safexcel_alg_template safexcel_alg_chacha20 = {
+	.type = SAFEXCEL_ALG_TYPE_SKCIPHER,
+	.algo_mask = SAFEXCEL_ALG_CHACHA20,
+	.alg.skcipher = {
+		.setkey = safexcel_skcipher_chacha20_setkey,
+		.encrypt = safexcel_encrypt,
+		.decrypt = safexcel_decrypt,
+		.min_keysize = CHACHA_KEY_SIZE,
+		.max_keysize = CHACHA_KEY_SIZE,
+		.ivsize = CHACHA_IV_SIZE,
+		.base = {
+			.cra_name = "chacha20",
+			.cra_driver_name = "safexcel-chacha20",
+			.cra_priority = SAFEXCEL_CRA_PRIORITY,
+			.cra_flags = CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_KERN_DRIVER_ONLY,
+			.cra_blocksize = 1,
+			.cra_ctxsize = sizeof(struct safexcel_cipher_ctx),
+			.cra_alignmask = 0,
+			.cra_init = safexcel_skcipher_chacha20_cra_init,
+			.cra_exit = safexcel_skcipher_cra_exit,
+			.cra_module = THIS_MODULE,
+		},
+	},
+};
-- 
1.8.3.1

