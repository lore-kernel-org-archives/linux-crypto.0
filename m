Return-Path: <SRS0=vORM=XI=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB402C49ED7
	for <linux-crypto@archiver.kernel.org>; Fri, 13 Sep 2019 10:13:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 89AFB2089F
	for <linux-crypto@archiver.kernel.org>; Fri, 13 Sep 2019 10:13:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CK5M2Kvr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728288AbfIMKNg (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 13 Sep 2019 06:13:36 -0400
Received: from mail-ed1-f47.google.com ([209.85.208.47]:37644 "EHLO
        mail-ed1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729368AbfIMKNf (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 13 Sep 2019 06:13:35 -0400
Received: by mail-ed1-f47.google.com with SMTP id i1so26602902edv.4
        for <linux-crypto@vger.kernel.org>; Fri, 13 Sep 2019 03:13:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=UYy53SLOHv6gLrbFzpJDDVMR1KWHaUykeLFBDRcrIXs=;
        b=CK5M2KvriG1wnKRO0gt0lMf83dCHOVbaW9KAPJG+xLj3vBD0UvGEFBsrJ2wk4+ZHe0
         aSX31PXOvHwYPfY4HQiEo59AwtEV217dhdhzw2IXaok6XZbEjRXZcgjJGFBh/+ZfQF+E
         yZ4ooW80T0cS0URt/RgYa3A4nZWxoenByvnOpSHnzWKfZw7EZe0tG3gNGrBcEBztMj/U
         zrdyQ5RVXWW8ntN4JL1eehRVH5QRNibe9IQbUsrAeBRjWXSVhOfHgRINEcis6qMwQWIo
         Tgz1j+Uf/LJoy8Qu3VYSiB/YLSoM7hYpZZAH41AUn+GXtHQpDXqSq3e2rOdiDeBXDgmu
         3Y8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=UYy53SLOHv6gLrbFzpJDDVMR1KWHaUykeLFBDRcrIXs=;
        b=HCQkY0ZBsMTFlEO3ef4g6ltziH5lrvpBRvH4TcHDEP/3n+zf6Tc74sUYjbtQvqfqtr
         i8+gqtTSWlzYysAF53DKKNFZu0sMxG8pD7l1tbYFR6xHCiVr8vbh86tajyZPOLpljaZo
         a5HQZTHj+LUk5cIpp+2qBGcd58ia2fGxhhpQGcTI0cIaILkBCC+0+zOuHXMG4Z2GAdTM
         FMPf3FSvsjXfx/GQWe/hUWjCfyaUSsiZuwxd5BQSUXtk7pQVtsRXBGgWXF55ke6FIkg9
         KQEudiXtiQXGpzuRNGlxgkLmTxaEcrf0z8qU/JvXsegjZ8nSrcuHq/gqLcsON5UtDC87
         36SQ==
X-Gm-Message-State: APjAAAXTxRvEW0BSXKdODHWbVYGDrLybV7opuMStjxCMHNKc/aGnvLkT
        O+W9kw8u/O3pAnCZmWeBKvY4KMN9
X-Google-Smtp-Source: APXvYqwC6hVOOcn3x+PPanQkyoVhPfcoh3LBZN6pY7P+xz13efCrMeQFB5KzMi54KVBgifMLgjmn0Q==
X-Received: by 2002:a50:b582:: with SMTP id a2mr31314431ede.98.1568369614063;
        Fri, 13 Sep 2019 03:13:34 -0700 (PDT)
Received: from localhost.localdomain.com ([188.204.2.113])
        by smtp.gmail.com with ESMTPSA id z65sm5314382ede.86.2019.09.13.03.13.33
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 13 Sep 2019 03:13:33 -0700 (PDT)
From:   Pascal van Leeuwen <pascalvanl@gmail.com>
X-Google-Original-From: Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
To:     linux-crypto@vger.kernel.org
Cc:     antoine.tenart@bootlin.com, herbert@gondor.apana.org.au,
        davem@davemloft.net,
        Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
Subject: [PATCHv2 5/7] crypto: inside-secure - Add support for the cfb(sm4) skcipher
Date:   Fri, 13 Sep 2019 11:10:40 +0200
Message-Id: <1568365842-19905-6-git-send-email-pvanleeuwen@verimatrix.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1568365842-19905-1-git-send-email-pvanleeuwen@verimatrix.com>
References: <1568365842-19905-1-git-send-email-pvanleeuwen@verimatrix.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This patch adds support for SM4 in CFB mode, i.e. skcipher cfb(sm4).

changes since v1:
- nothing

Signed-off-by: Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
---
 drivers/crypto/inside-secure/safexcel.c        |  1 +
 drivers/crypto/inside-secure/safexcel.h        |  1 +
 drivers/crypto/inside-secure/safexcel_cipher.c | 36 ++++++++++++++++++++++++++
 3 files changed, 38 insertions(+)

diff --git a/drivers/crypto/inside-secure/safexcel.c b/drivers/crypto/inside-secure/safexcel.c
index fbfda68..1679b41 100644
--- a/drivers/crypto/inside-secure/safexcel.c
+++ b/drivers/crypto/inside-secure/safexcel.c
@@ -1181,6 +1181,7 @@ static int safexcel_request_ring_irq(void *pdev, int irqid,
 	&safexcel_alg_ecb_sm4,
 	&safexcel_alg_cbc_sm4,
 	&safexcel_alg_ofb_sm4,
+	&safexcel_alg_cfb_sm4,
 };
 
 static int safexcel_register_algorithms(struct safexcel_crypto_priv *priv)
diff --git a/drivers/crypto/inside-secure/safexcel.h b/drivers/crypto/inside-secure/safexcel.h
index 8e01d24..db9bc80 100644
--- a/drivers/crypto/inside-secure/safexcel.h
+++ b/drivers/crypto/inside-secure/safexcel.h
@@ -876,5 +876,6 @@ int safexcel_hmac_setkey(const char *alg, const u8 *key, unsigned int keylen,
 extern struct safexcel_alg_template safexcel_alg_ecb_sm4;
 extern struct safexcel_alg_template safexcel_alg_cbc_sm4;
 extern struct safexcel_alg_template safexcel_alg_ofb_sm4;
+extern struct safexcel_alg_template safexcel_alg_cfb_sm4;
 
 #endif
diff --git a/drivers/crypto/inside-secure/safexcel_cipher.c b/drivers/crypto/inside-secure/safexcel_cipher.c
index 95f9214..1d8aca2 100644
--- a/drivers/crypto/inside-secure/safexcel_cipher.c
+++ b/drivers/crypto/inside-secure/safexcel_cipher.c
@@ -2792,3 +2792,39 @@ struct safexcel_alg_template safexcel_alg_ofb_sm4 = {
 		},
 	},
 };
+
+static int safexcel_skcipher_sm4_cfb_cra_init(struct crypto_tfm *tfm)
+{
+	struct safexcel_cipher_ctx *ctx = crypto_tfm_ctx(tfm);
+
+	safexcel_skcipher_cra_init(tfm);
+	ctx->alg  = SAFEXCEL_SM4;
+	ctx->mode = CONTEXT_CONTROL_CRYPTO_MODE_CFB;
+	return 0;
+}
+
+struct safexcel_alg_template safexcel_alg_cfb_sm4 = {
+	.type = SAFEXCEL_ALG_TYPE_SKCIPHER,
+	.algo_mask = SAFEXCEL_ALG_SM4 | SAFEXCEL_ALG_AES_XFB,
+	.alg.skcipher = {
+		.setkey = safexcel_skcipher_sm4_setkey,
+		.encrypt = safexcel_encrypt,
+		.decrypt = safexcel_decrypt,
+		.min_keysize = SM4_KEY_SIZE,
+		.max_keysize = SM4_KEY_SIZE,
+		.ivsize = SM4_BLOCK_SIZE,
+		.base = {
+			.cra_name = "cfb(sm4)",
+			.cra_driver_name = "safexcel-cfb-sm4",
+			.cra_priority = SAFEXCEL_CRA_PRIORITY,
+			.cra_flags = CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_KERN_DRIVER_ONLY,
+			.cra_blocksize = 1,
+			.cra_ctxsize = sizeof(struct safexcel_cipher_ctx),
+			.cra_alignmask = 0,
+			.cra_init = safexcel_skcipher_sm4_cfb_cra_init,
+			.cra_exit = safexcel_skcipher_cra_exit,
+			.cra_module = THIS_MODULE,
+		},
+	},
+};
-- 
1.8.3.1

