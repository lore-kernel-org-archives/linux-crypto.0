Return-Path: <SRS0=VsuX=XG=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A735BC5ACAE
	for <linux-crypto@archiver.kernel.org>; Wed, 11 Sep 2019 11:41:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 646632081B
	for <linux-crypto@archiver.kernel.org>; Wed, 11 Sep 2019 11:41:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="tCapUBxf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727774AbfIKLlO (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 11 Sep 2019 07:41:14 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:33525 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726696AbfIKLlO (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 11 Sep 2019 07:41:14 -0400
Received: by mail-ed1-f67.google.com with SMTP id o9so20374723edq.0
        for <linux-crypto@vger.kernel.org>; Wed, 11 Sep 2019 04:41:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=AYNFu8fdMLNug/H3N/upkSvOZWVoaglxXWaKcdOIFac=;
        b=tCapUBxfI0hoVJtSzz+LZ+ZSIhGkvRbdkEVGWU764kl9zvnk6ZgdnWSwsyprpdXHgX
         KJMYnQRjO4CHC1owJoD2JsdrVM7C+vX6+6B2r2vkjA1JfAh0DaTWuLjBWFNoJpxCMBIn
         iAJF1YXLSC6wPZ1ELTbXMyjhH1ZDOiQlFqVfdd0p3hT/AM/pkHsQTLsgifH7mHIolmG3
         cg7o3gxiGpnwbN3HX8OcdJiZpwAfBOu6lcFaOmW841VPpUp9uXXXzcwOa+iHRbduiOc5
         qBUhgxI79IH3gnFTVdeRzwqfkZ26NYSZyA+wdLyTuyqmqSFj+eklQfxGVUuQpQBntfHL
         2NPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=AYNFu8fdMLNug/H3N/upkSvOZWVoaglxXWaKcdOIFac=;
        b=bWRjAD9vIkVjPAvE3QL/zXzZu4oiVdtGEeUxfRIisUcAYyBwnbPRpN1ZIz0ZCYZYxO
         gfeiuDZv5GvbSAjo2WzYv9eKZhU+QFHFUpHGPvvEmKskEB9B28HC3OW8Jbwoux35aVut
         y8NJaf/G+VuSd7T6Rc4Lgx/aE4WIgE0A6tGfdMcZTvWXuACRmlT8TJJ6qQgTS18yVgjC
         cPhBtGn/9LKzo7OLhl7V/xKomMimYi9GaZKCcn4p9+DMI2WS1TMjjCKimovmeWPFQhD3
         Qwudn/7BMn66JEkDMToKj3kIdtt0R6DtORfNMdsUroWS+2ekotgD7+v+sAf4l3B7q7Z2
         Cpgw==
X-Gm-Message-State: APjAAAUPC5LFVUeEw+JA1cbq+tvyHorP/8KONszWmvhC2M8g6IAHSUNQ
        NMIWdMiSmfA7RlUIrr5+j81f7RYx
X-Google-Smtp-Source: APXvYqwAC2+RQOEqd+byL4we/0gLff6zrJA5GVrpkg2p5VyQZ4jN6R8uKMaOVuI/TeyJXK7jRDtOsA==
X-Received: by 2002:a17:906:2f92:: with SMTP id w18mr11620761eji.33.1568202071890;
        Wed, 11 Sep 2019 04:41:11 -0700 (PDT)
Received: from localhost.localdomain.com ([188.204.2.113])
        by smtp.gmail.com with ESMTPSA id z6sm2448022ejo.26.2019.09.11.04.41.11
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 11 Sep 2019 04:41:11 -0700 (PDT)
From:   Pascal van Leeuwen <pascalvanl@gmail.com>
X-Google-Original-From: Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
To:     linux-crypto@vger.kernel.org
Cc:     antoine.tenart@bootlin.com, herbert@gondor.apana.org.au,
        davem@davemloft.net,
        Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
Subject: [PATCH 1/7] crypto: inside-secure - Add support for the ecb(sm4) skcipher
Date:   Wed, 11 Sep 2019 12:38:18 +0200
Message-Id: <1568198304-8101-2-git-send-email-pvanleeuwen@verimatrix.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1568198304-8101-1-git-send-email-pvanleeuwen@verimatrix.com>
References: <1568198304-8101-1-git-send-email-pvanleeuwen@verimatrix.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This patch adds support for SM4 in ECB mode, i.e. skcipher ecb(sm4).

Signed-off-by: Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
---
 drivers/crypto/inside-secure/safexcel.c        |  1 +
 drivers/crypto/inside-secure/safexcel.h        |  2 +
 drivers/crypto/inside-secure/safexcel_cipher.c | 90 ++++++++++++++++++++++++++
 3 files changed, 93 insertions(+)

diff --git a/drivers/crypto/inside-secure/safexcel.c b/drivers/crypto/inside-secure/safexcel.c
index 7d907d5..fe785e8 100644
--- a/drivers/crypto/inside-secure/safexcel.c
+++ b/drivers/crypto/inside-secure/safexcel.c
@@ -1178,6 +1178,7 @@ static int safexcel_request_ring_irq(void *pdev, int irqid,
 	&safexcel_alg_chachapoly_esp,
 	&safexcel_alg_sm3,
 	&safexcel_alg_hmac_sm3,
+	&safexcel_alg_ecb_sm4,
 };
 
 static int safexcel_register_algorithms(struct safexcel_crypto_priv *priv)
diff --git a/drivers/crypto/inside-secure/safexcel.h b/drivers/crypto/inside-secure/safexcel.h
index 7ee09fe..970b5cd 100644
--- a/drivers/crypto/inside-secure/safexcel.h
+++ b/drivers/crypto/inside-secure/safexcel.h
@@ -359,6 +359,7 @@ struct safexcel_context_record {
 #define CONTEXT_CONTROL_CRYPTO_ALG_AES192	(0x6 << 17)
 #define CONTEXT_CONTROL_CRYPTO_ALG_AES256	(0x7 << 17)
 #define CONTEXT_CONTROL_CRYPTO_ALG_CHACHA20	(0x8 << 17)
+#define CONTEXT_CONTROL_CRYPTO_ALG_SM4		(0xd << 17)
 #define CONTEXT_CONTROL_DIGEST_PRECOMPUTED	(0x1 << 21)
 #define CONTEXT_CONTROL_DIGEST_XCM		(0x2 << 21)
 #define CONTEXT_CONTROL_DIGEST_HMAC		(0x3 << 21)
@@ -872,5 +873,6 @@ int safexcel_hmac_setkey(const char *alg, const u8 *key, unsigned int keylen,
 extern struct safexcel_alg_template safexcel_alg_chachapoly_esp;
 extern struct safexcel_alg_template safexcel_alg_sm3;
 extern struct safexcel_alg_template safexcel_alg_hmac_sm3;
+extern struct safexcel_alg_template safexcel_alg_ecb_sm4;
 
 #endif
diff --git a/drivers/crypto/inside-secure/safexcel_cipher.c b/drivers/crypto/inside-secure/safexcel_cipher.c
index 00bf220..fc75f2f 100644
--- a/drivers/crypto/inside-secure/safexcel_cipher.c
+++ b/drivers/crypto/inside-secure/safexcel_cipher.c
@@ -19,6 +19,7 @@
 #include <crypto/ghash.h>
 #include <crypto/poly1305.h>
 #include <crypto/sha.h>
+#include <crypto/sm4.h>
 #include <crypto/xts.h>
 #include <crypto/skcipher.h>
 #include <crypto/internal/aead.h>
@@ -36,6 +37,7 @@ enum safexcel_cipher_alg {
 	SAFEXCEL_3DES,
 	SAFEXCEL_AES,
 	SAFEXCEL_CHACHA20,
+	SAFEXCEL_SM4,
 };
 
 struct safexcel_cipher_ctx {
@@ -530,6 +532,9 @@ static int safexcel_context_control(struct safexcel_cipher_ctx *ctx,
 	} else if (ctx->alg == SAFEXCEL_CHACHA20) {
 		cdesc->control_data.control0 |=
 			CONTEXT_CONTROL_CRYPTO_ALG_CHACHA20;
+	} else if (ctx->alg == SAFEXCEL_SM4) {
+		cdesc->control_data.control0 |=
+			CONTEXT_CONTROL_CRYPTO_ALG_SM4;
 	}
 
 	return 0;
@@ -2620,3 +2625,88 @@ struct safexcel_alg_template safexcel_alg_chachapoly_esp = {
 		},
 	},
 };
+
+static int safexcel_skcipher_sm4_setkey(struct crypto_skcipher *ctfm,
+					const u8 *key, unsigned int len)
+{
+	struct crypto_tfm *tfm = crypto_skcipher_tfm(ctfm);
+	struct safexcel_cipher_ctx *ctx = crypto_tfm_ctx(tfm);
+	struct safexcel_crypto_priv *priv = ctx->priv;
+	int i;
+
+	if (len != SM4_KEY_SIZE) {
+		crypto_skcipher_set_flags(ctfm, CRYPTO_TFM_RES_BAD_KEY_LEN);
+		return -EINVAL;
+	}
+
+	if (priv->flags & EIP197_TRC_CACHE && ctx->base.ctxr_dma) {
+		for (i = 0; i < SM4_KEY_SIZE / sizeof(u32); i++) {
+			if (ctx->key[i] !=
+			    get_unaligned_le32(key + i * sizeof(u32))) {
+				ctx->base.needs_inv = true;
+				break;
+			}
+		}
+	}
+
+	for (i = 0; i < SM4_KEY_SIZE / sizeof(u32); i++)
+		ctx->key[i] = get_unaligned_le32(key + i * sizeof(u32));
+	ctx->key_len = SM4_KEY_SIZE;
+
+	return 0;
+}
+
+static int safexcel_sm4_blk_encrypt(struct skcipher_request *req)
+{
+	/* Workaround for HW bug: EIP96 4.3 does not report blocksize error */
+	if (req->cryptlen & (SM4_BLOCK_SIZE - 1))
+		return -EINVAL;
+	else
+		return safexcel_queue_req(&req->base, skcipher_request_ctx(req),
+					  SAFEXCEL_ENCRYPT);
+}
+
+static int safexcel_sm4_blk_decrypt(struct skcipher_request *req)
+{
+	/* Workaround for HW bug: EIP96 4.3 does not report blocksize error */
+	if (req->cryptlen & (SM4_BLOCK_SIZE - 1))
+		return -EINVAL;
+	else
+		return safexcel_queue_req(&req->base, skcipher_request_ctx(req),
+					  SAFEXCEL_DECRYPT);
+}
+
+static int safexcel_skcipher_sm4_ecb_cra_init(struct crypto_tfm *tfm)
+{
+	struct safexcel_cipher_ctx *ctx = crypto_tfm_ctx(tfm);
+
+	safexcel_skcipher_cra_init(tfm);
+	ctx->alg  = SAFEXCEL_SM4;
+	ctx->mode = CONTEXT_CONTROL_CRYPTO_MODE_ECB;
+	return 0;
+}
+
+struct safexcel_alg_template safexcel_alg_ecb_sm4 = {
+	.type = SAFEXCEL_ALG_TYPE_SKCIPHER,
+	.algo_mask = SAFEXCEL_ALG_SM4,
+	.alg.skcipher = {
+		.setkey = safexcel_skcipher_sm4_setkey,
+		.encrypt = safexcel_sm4_blk_encrypt,
+		.decrypt = safexcel_sm4_blk_decrypt,
+		.min_keysize = SM4_KEY_SIZE,
+		.max_keysize = SM4_KEY_SIZE,
+		.base = {
+			.cra_name = "ecb(sm4)",
+			.cra_driver_name = "safexcel-ecb-sm4",
+			.cra_priority = SAFEXCEL_CRA_PRIORITY,
+			.cra_flags = CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_KERN_DRIVER_ONLY,
+			.cra_blocksize = SM4_BLOCK_SIZE,
+			.cra_ctxsize = sizeof(struct safexcel_cipher_ctx),
+			.cra_alignmask = 0,
+			.cra_init = safexcel_skcipher_sm4_ecb_cra_init,
+			.cra_exit = safexcel_skcipher_cra_exit,
+			.cra_module = THIS_MODULE,
+		},
+	},
+};
-- 
1.8.3.1

