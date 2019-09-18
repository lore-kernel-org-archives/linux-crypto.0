Return-Path: <SRS0=f1VZ=XN=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28506C4CEC4
	for <linux-crypto@archiver.kernel.org>; Wed, 18 Sep 2019 22:28:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F21A421925
	for <linux-crypto@archiver.kernel.org>; Wed, 18 Sep 2019 22:28:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MyIXzLwH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728823AbfIRW2x (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 18 Sep 2019 18:28:53 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:43272 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728744AbfIRW2x (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 18 Sep 2019 18:28:53 -0400
Received: by mail-ed1-f67.google.com with SMTP id r9so1356125edl.10
        for <linux-crypto@vger.kernel.org>; Wed, 18 Sep 2019 15:28:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=D7bfTP3BbEIRjR+dLccAyWVMdyo2xDIP7rrTjfYWbug=;
        b=MyIXzLwHfdt1G6gstR/gu/DOMSFEG2EN5bj2BWNam/VSOIA5nucFx/KnLdM3LM0x1v
         uwd/MnSpRhNPaWQ2tFiE4qkkEIq7ggVAreu3Tk1ZEGeqOcZvQBbQ9BB8niiv8jm857c5
         XC18uhA04px3SZ9H38fKbcM6dB5nrm/uifBKsIq9IG7muO8w+Sd9vnVHu/zvxMElRPjj
         H4y4Vu7Tbtugn2LyCRc8HnKhIMh+IDG/3C2JS+GAmWkr5FULH8crmcB+V1UA7tb9EijC
         1w0VZX7WmdaxBBRJy4jLUlYytFLO5mrf3ZXvp8ZKVEWhuNAftsoMV8KP2E13cBfeY8Zj
         pBdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=D7bfTP3BbEIRjR+dLccAyWVMdyo2xDIP7rrTjfYWbug=;
        b=GOC4A/n9l+Syv+Vs7rootuFyLCI32uoRKjZpFmRJm2Ar8GS2pRhet2UR4yfm8WzOTG
         4uTxQUO1/NRoWDnX7JUVEjPXNCcHqKYe8s/yaVl15KGl1REXWQwgiw6AHS9+hMch/XcR
         K84nYx6m0BWzA6ojuI5T4Y94FlLYMy6ZEWEkC6CIvoQoVMK1yqBu9xzzOJJzJSyIesoO
         MWrosdvB6yM7L0IJ2CvV6qLqN73KIaJXxTmTP4AwAO4CrTxTiOKoosrdRO2UKdVYLbDK
         RRgWyqYluL0Wpv/DCRTltXmWu0w6t1Pyy1l+XcP/ncFaST/S4edBwWW8lM/WuxL516jA
         eGvg==
X-Gm-Message-State: APjAAAWZI1fK7NB884Y1PtEDiIibMrwg6z55G+NoLQYAY+7GIssqwx31
        xqKHvZtpGesXW0PAcWsuDt2g6sl+
X-Google-Smtp-Source: APXvYqz9umLIQuaZnfCUydkArutiQ1duKJyXB57lwPYFzfAgiVOTDR9RlydJdbjAK6Ma8V/mheNC+A==
X-Received: by 2002:a50:a532:: with SMTP id y47mr12619255edb.273.1568845730516;
        Wed, 18 Sep 2019 15:28:50 -0700 (PDT)
Received: from localhost.localdomain.com ([188.204.2.113])
        by smtp.gmail.com with ESMTPSA id a3sm811951eje.90.2019.09.18.15.28.49
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 18 Sep 2019 15:28:49 -0700 (PDT)
From:   Pascal van Leeuwen <pascalvanl@gmail.com>
X-Google-Original-From: Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
To:     linux-crypto@vger.kernel.org
Cc:     antoine.tenart@bootlin.com, herbert@gondor.apana.org.au,
        davem@davemloft.net,
        Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
Subject: [PATCHv4 1/3] crypto: inside-secure - Added support for the CHACHA20 skcipher
Date:   Wed, 18 Sep 2019 23:25:56 +0200
Message-Id: <1568841958-14622-2-git-send-email-pvanleeuwen@verimatrix.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1568841958-14622-1-git-send-email-pvanleeuwen@verimatrix.com>
References: <1568841958-14622-1-git-send-email-pvanleeuwen@verimatrix.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Added support for the CHACHA20 skcipher algorithm.
Tested on an eip197c-iesb configuration in the Xilinx VCU118 devboard,
passes all testmgr vectors plus the extra fuzzing tests.

changes since v1:
- rebased on top of DES library changes done on cryptodev/master
- fixed crypto/Kconfig so that generic fallback is compiled as well

changes since v2:
- made switch entry SAFEXCEL_AES explit and added empty default, as
  requested by Antoine Tenart. Also needed to make SM4 patches apply.

changes since v3:
- nothing

Signed-off-by: Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
---
 drivers/crypto/inside-secure/safexcel.c        |  1 +
 drivers/crypto/inside-secure/safexcel.h        |  3 +
 drivers/crypto/inside-secure/safexcel_cipher.c | 83 +++++++++++++++++++++++++-
 3 files changed, 86 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/inside-secure/safexcel.c b/drivers/crypto/inside-secure/safexcel.c
index d0f49a5..f958c92 100644
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
index ef51f8c2..15d98a9 100644
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
 #include <crypto/internal/des.h>
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
@@ -480,6 +493,9 @@ static int safexcel_context_control(struct safexcel_cipher_ctx *ctx,
 				ctx->key_len >> ctx->xts);
 			return -EINVAL;
 		}
+	} else if (ctx->alg == SAFEXCEL_CHACHA20) {
+		cdesc->control_data.control0 |=
+			CONTEXT_CONTROL_CRYPTO_ALG_CHACHA20;
 	}

 	return 0;
@@ -2303,3 +2319,68 @@ struct safexcel_alg_template safexcel_alg_ccm = {
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
