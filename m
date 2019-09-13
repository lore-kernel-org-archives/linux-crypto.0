Return-Path: <SRS0=vORM=XI=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8794C4CEC5
	for <linux-crypto@archiver.kernel.org>; Fri, 13 Sep 2019 10:13:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B5AC22084F
	for <linux-crypto@archiver.kernel.org>; Fri, 13 Sep 2019 10:13:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dIMohzfI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729394AbfIMKNd (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 13 Sep 2019 06:13:33 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:37437 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729390AbfIMKNd (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 13 Sep 2019 06:13:33 -0400
Received: by mail-ed1-f68.google.com with SMTP id i1so26602757edv.4
        for <linux-crypto@vger.kernel.org>; Fri, 13 Sep 2019 03:13:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=C+mqKAiglc9zM+YkXXjohbwhh6LP/vTLI0OTUkKcPRM=;
        b=dIMohzfIjzrL4Une3Zg1t0TLjCdRHFf/bdfGzm86j240WdMaKlk6w0f3n3/8Ixm6sw
         WXfZQuSdZvzv4UIwPNBiIkrJKBK3KXy9bFb9Yi5RYRweRptbcw6JsrPkdqrBuj+gXZMr
         z4mPPu0v34rE/97jb13udcSAkM7mEqhbQamRokcoRLRjth2UBNmQa0BJfu6bB0TXEPYm
         eF66B55aPFAvsJZsj3S+Khl6Pl44eYLWlYNLswsFehknoyvygLpWBiZPrKYGk6bKGrGb
         VTGhVX8PDIFRUrT/JG4eWSaAsrQdeHQcBg3AjR+yXdPUn8t664YFAQoLgvIwK0PMbJJ8
         /D/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=C+mqKAiglc9zM+YkXXjohbwhh6LP/vTLI0OTUkKcPRM=;
        b=Hn4HyJ7ZNqZVqeGh3gaA+qwTw8aFoda0V1ZW/2pSplbEcvBnZhno0mLHK2NoNx50gL
         f5LrRXStI5eASFSG5Q1atU6Vio6/tpgQXiSHWEe0zjmY3WdipWYy0V8m3w1iuzomX9yq
         0nYb9A+HhywoIMA5ZhcFj181SOe7dDw1spDEvbbOJSSz23J8WWp5lT5YqafP2IAdDLZ2
         c4F7Wuk+Qb3rxjGVlHwSO+HW6OGvqHbRNm0ym/ZKMptvv71dC3oeGCcjIABQXCBBjDDv
         krKduY/d1+0NsY0fo6dGtwr9erg6k8ZMV1HKfum7GC26xbXmYWGUpiz3EKMACvpMcbnJ
         rmyA==
X-Gm-Message-State: APjAAAW1qsocxtHfc1WfN1sSbvScdvb82WkPpmI4QaoUyt4XBmutn1zp
        mmOZw1kOAgULBqLKNAVZIY1pi0Zy
X-Google-Smtp-Source: APXvYqxjT3VoECmsRWS1N7jbVZ4Uvl+F5n801QqxewnbNscAS+U0MbuFTzeNTqFPj55ibNdoL9ZE1g==
X-Received: by 2002:a17:906:6dc1:: with SMTP id j1mr38635007ejt.85.1568369610730;
        Fri, 13 Sep 2019 03:13:30 -0700 (PDT)
Received: from localhost.localdomain.com ([188.204.2.113])
        by smtp.gmail.com with ESMTPSA id z65sm5314382ede.86.2019.09.13.03.13.30
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 13 Sep 2019 03:13:30 -0700 (PDT)
From:   Pascal van Leeuwen <pascalvanl@gmail.com>
X-Google-Original-From: Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
To:     linux-crypto@vger.kernel.org
Cc:     antoine.tenart@bootlin.com, herbert@gondor.apana.org.au,
        davem@davemloft.net,
        Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
Subject: [PATCHv2 1/7] crypto: inside-secure - Add support for the ecb(sm4) skcipher
Date:   Fri, 13 Sep 2019 11:10:36 +0200
Message-Id: <1568365842-19905-2-git-send-email-pvanleeuwen@verimatrix.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1568365842-19905-1-git-send-email-pvanleeuwen@verimatrix.com>
References: <1568365842-19905-1-git-send-email-pvanleeuwen@verimatrix.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This patch adds support for SM4 in ECB mode, i.e. skcipher ecb(sm4).

changes since v1:
- make SAFEXCEL_SM4 case entry explit, using the proper SM4_BLOCK_SIZE
  instead of "borrowing" the AES code which "coincidentally" works

Signed-off-by: Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
---
 drivers/crypto/inside-secure/safexcel.c        |  1 +
 drivers/crypto/inside-secure/safexcel.h        |  2 +
 drivers/crypto/inside-secure/safexcel_cipher.c | 94 ++++++++++++++++++++++++++
 3 files changed, 97 insertions(+)

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
index 73055dc..7a3183e 100644
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
index 40f98f1..f389a3c 100644
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
@@ -139,6 +141,10 @@ static void safexcel_cipher_token(struct safexcel_cipher_ctx *ctx, u8 *iv,
 			block_sz = DES3_EDE_BLOCK_SIZE;
 			cdesc->control_data.options |= EIP197_OPTION_2_TOKEN_IV_CMD;
 			break;
+		case SAFEXCEL_SM4:
+			block_sz = SM4_BLOCK_SIZE;
+			cdesc->control_data.options |= EIP197_OPTION_4_TOKEN_IV_CMD;
+			break;
 		case SAFEXCEL_AES:
 			block_sz = AES_BLOCK_SIZE;
 			cdesc->control_data.options |= EIP197_OPTION_4_TOKEN_IV_CMD;
@@ -535,6 +541,9 @@ static int safexcel_context_control(struct safexcel_cipher_ctx *ctx,
 	} else if (ctx->alg == SAFEXCEL_CHACHA20) {
 		cdesc->control_data.control0 |=
 			CONTEXT_CONTROL_CRYPTO_ALG_CHACHA20;
+	} else if (ctx->alg == SAFEXCEL_SM4) {
+		cdesc->control_data.control0 |=
+			CONTEXT_CONTROL_CRYPTO_ALG_SM4;
 	}
 
 	return 0;
@@ -2626,3 +2635,88 @@ struct safexcel_alg_template safexcel_alg_chachapoly_esp = {
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

