Return-Path: <SRS0=/8o3=XH=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 424BEC5ACAE
	for <linux-crypto@archiver.kernel.org>; Thu, 12 Sep 2019 10:00:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0DF87208C2
	for <linux-crypto@archiver.kernel.org>; Thu, 12 Sep 2019 10:00:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="pp6tm6OI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730831AbfILKAj (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 12 Sep 2019 06:00:39 -0400
Received: from mail-ed1-f50.google.com ([209.85.208.50]:35691 "EHLO
        mail-ed1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730807AbfILKAj (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 12 Sep 2019 06:00:39 -0400
Received: by mail-ed1-f50.google.com with SMTP id f24so5788047edv.2
        for <linux-crypto@vger.kernel.org>; Thu, 12 Sep 2019 03:00:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=jEn2yEYChnUZTCj8Jwr+Zgfd5CrMdl5dN83KPZV0NO4=;
        b=pp6tm6OIiQc2TkmXOaz3ikbv2Xp8wZ95PpuE4sxruKlk2Ki4HLGSxZLqysj8W3mKw+
         gTiur0xzsxjnzC1Me9M1peq78/NNGdap1E0QjZQYHfIdHcPLSkWjGtOmlZNftvuYMh5n
         1OdsG4U8Z78UucgnGBFUJIyBZz7JTxfO2+LJlbPKfg8PRXS636bMur6eqDxdQlrGasmD
         L2B4XHNyYfuYeys1xjYQnGcfVO1xxi7nz8b66SOoMhXPbjEkIq0SOZdrDNyd8Vk1DZWy
         fPT20qYG/ODU/MFOvZkHfLhJdFbI5FYAH3tTmBZwZxNfpp/oKZsNoqgN6iDNr5BJEUMU
         3wRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=jEn2yEYChnUZTCj8Jwr+Zgfd5CrMdl5dN83KPZV0NO4=;
        b=fdXV2PyYGXh7DVGCHeL7WJymhVawLLjnShsydqjRcdjKK1T/BIndeuAFjH2xUFCGjl
         PuJ0YSNa8R5pIvcuXwIR63Zlni5CZA3Nj5cAuVsM61gJ2l46KMSKmCPF+iPIOfFrJEuX
         aqNnFjG6j1oehULze+MLAMVdo0vdv5aAPzqDfQraPZpWQ5qqMm/YHikhvprpf5Wj6mbd
         pGmEQJTWaOQdPgmIMSWwpJE/G63lpS1/3sLAx9qpFzx+QDSbfAl5dQ3D1NwzJmArdJ8X
         Mxq02a9xdlzXbejpKVlbTtx8+KipvYMF+o8kfZtarBWXJPR5w8chKFFJURrXlJ5wlcYi
         i4cQ==
X-Gm-Message-State: APjAAAV2rgYU6bxBjdAvI14XytL+MJP/pcfkQIm79hK9dLFJvmJjWAxv
        8A1+6wnSPtMkAK//zY8tWSKDG5LL
X-Google-Smtp-Source: APXvYqwSZhlhR2AVCqaCByL8uFQNVgYT1kgXJzZRGE3qzw4QFZB+YlTi7mbr9i2MB6Ajl09VL2C8tw==
X-Received: by 2002:a17:906:edca:: with SMTP id sb10mr34319722ejb.1.1568282436939;
        Thu, 12 Sep 2019 03:00:36 -0700 (PDT)
Received: from localhost.localdomain.com ([188.204.2.113])
        by smtp.gmail.com with ESMTPSA id r18sm4734705edl.6.2019.09.12.03.00.36
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 12 Sep 2019 03:00:36 -0700 (PDT)
From:   Pascal van Leeuwen <pascalvanl@gmail.com>
X-Google-Original-From: Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
To:     linux-crypto@vger.kernel.org
Cc:     antoine.tenart@bootlin.com, herbert@gondor.apana.org.au,
        davem@davemloft.net,
        Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
Subject: [PATCHv2 1/2] crypto: inside-secure - Added support for the CHACHA20 skcipher
Date:   Thu, 12 Sep 2019 10:57:47 +0200
Message-Id: <1568278668-15571-2-git-send-email-pvanleeuwen@verimatrix.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1568278668-15571-1-git-send-email-pvanleeuwen@verimatrix.com>
References: <1568278668-15571-1-git-send-email-pvanleeuwen@verimatrix.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Added support for the CHACHA20 skcipher algorithm.
Tested on an eip197c-iesb configuration in the Xilinx VCU118 devboard,
passes all testmgr vectors plus the extra fuzzing tests.

changes since v1:
- changed switch statement entry from default to explicit+empty default

Signed-off-by: Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
---
 drivers/crypto/inside-secure/safexcel.c        |  1 +
 drivers/crypto/inside-secure/safexcel.h        |  3 +
 drivers/crypto/inside-secure/safexcel_cipher.c | 83 +++++++++++++++++++++++++-
 3 files changed, 86 insertions(+), 1 deletion(-)

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
index 023cabc..63b2269 100644
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
 
@@ -116,6 +127,8 @@ static void safexcel_cipher_token(struct safexcel_cipher_ctx *ctx, u8 *iv,
 			block_sz = AES_BLOCK_SIZE;
 			cdesc->control_data.options |= EIP197_OPTION_4_TOKEN_IV_CMD;
 			break;
+		default:
+			break;
 		}
 		memcpy(cdesc->control_data.token, iv, block_sz);
 	}
@@ -486,6 +499,9 @@ static int safexcel_context_control(struct safexcel_cipher_ctx *ctx,
 				ctx->key_len >> ctx->xts);
 			return -EINVAL;
 		}
+	} else if (ctx->alg == SAFEXCEL_CHACHA20) {
+		cdesc->control_data.control0 |=
+			CONTEXT_CONTROL_CRYPTO_ALG_CHACHA20;
 	}
 
 	return 0;
@@ -2313,3 +2329,68 @@ struct safexcel_alg_template safexcel_alg_ccm = {
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

