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
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3039C4CEC7
	for <linux-crypto@archiver.kernel.org>; Fri, 13 Sep 2019 15:06:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8C10C21479
	for <linux-crypto@archiver.kernel.org>; Fri, 13 Sep 2019 15:06:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="M7sFQzzj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390534AbfIMPGQ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 13 Sep 2019 11:06:16 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:34076 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390884AbfIMPGQ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 13 Sep 2019 11:06:16 -0400
Received: by mail-ed1-f68.google.com with SMTP id c20so18331835eds.1
        for <linux-crypto@vger.kernel.org>; Fri, 13 Sep 2019 08:06:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=D1obSY9nfUdRFVnNn9GkF9dsWdkuAYC9BDDOLIvbeo4=;
        b=M7sFQzzj+GkVmrrVN4gYESIjJiXWMp109CJ21+Ne/8cTHV7RTn/x3UzjU8l6TYry3b
         D9/gqa0leO8T07Yryi0B29gz1NUYVSzdfDQqM2h8S38JdI4KRJSSldwNNbI9jioFAbm5
         B4WxkxEAQcdN9UgrtEMZLUmizWv9WcxRN9AiUw246tCSUgNiNOI+WwAB0LJmcX6SukkV
         5U0UQY56Ql6Aepa1B+1ZI5nxqcZO7UxTLfV6kgjgdlKBWRMYhz9kynuooxHn0ggkLUGB
         XBtqAR7Mis8OA/m5eZo8dgBAKoiNlL50jki00FBQFAVKmN6Q3YzFZI/WNh5GEiTatAzL
         dV8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=D1obSY9nfUdRFVnNn9GkF9dsWdkuAYC9BDDOLIvbeo4=;
        b=nHrZ748FJFXUNYy3nY2fF/yXc4ZyRVdAwYqvBsLBs8lolCL+ORMO44i0/+aYDub4jH
         dJHV1wgG0K/0mvjWsovpAPf8Nfi14CnSElLIZAQeevtgSymKu0WG2J+lmW6eTmh7j72c
         619QtO/2z7RTKItnV2FQjcR24ki5tlvb+wv4hPqj8RwXDq8aYaEjeqUmVtHPpxgUAdcF
         vnBsV4SZhcbya7MKvZrNFww4xAKYimOImHoP7BZSjKhLJFTZbz7Ew+y6k6vtk8m07uU+
         BbQXj5+httZAfgSZy9i+kSHnxyYi1ZSKCBl2/STPwTfp4LAeKC2quuuy6TIWxHq7nQe4
         VwGQ==
X-Gm-Message-State: APjAAAXVNbdP6Qrcw8EE4GLQ8j2Fss8PEZcblvTgLuSJZA6/ewIM+Utg
        Y1c7p1guqngFvzvfZexd5XpoSih4
X-Google-Smtp-Source: APXvYqwSmH6phuiu8I4cE6tZaNxKuLV5B2r5c/qInnM/4yjKvO9R/xa5hI9a37KQGMkUndA4GJmQUw==
X-Received: by 2002:a17:906:f13:: with SMTP id z19mr13040469eji.209.1568387174605;
        Fri, 13 Sep 2019 08:06:14 -0700 (PDT)
Received: from localhost.localdomain.com ([188.204.2.113])
        by smtp.gmail.com with ESMTPSA id ly10sm3206654ejb.59.2019.09.13.08.06.14
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 13 Sep 2019 08:06:14 -0700 (PDT)
From:   Pascal van Leeuwen <pascalvanl@gmail.com>
X-Google-Original-From: Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
To:     linux-crypto@vger.kernel.org
Cc:     antoine.tenart@bootlin.com, herbert@gondor.apana.org.au,
        davem@davemloft.net,
        Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
Subject: [PATCH 1/3] crypto: inside-secure - Added support for authenc HMAC-SHA1/DES-CBC
Date:   Fri, 13 Sep 2019 16:03:24 +0200
Message-Id: <1568383406-8009-2-git-send-email-pvanleeuwen@verimatrix.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1568383406-8009-1-git-send-email-pvanleeuwen@verimatrix.com>
References: <1568383406-8009-1-git-send-email-pvanleeuwen@verimatrix.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This patch adds support for the authenc(hmac(sha1),cbc(des)) aead

Signed-off-by: Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
---
 drivers/crypto/inside-secure/safexcel.c        |  1 +
 drivers/crypto/inside-secure/safexcel.h        |  1 +
 drivers/crypto/inside-secure/safexcel_cipher.c | 45 ++++++++++++++++++++++++++
 3 files changed, 47 insertions(+)

diff --git a/drivers/crypto/inside-secure/safexcel.c b/drivers/crypto/inside-secure/safexcel.c
index 12cb939..617c70b 100644
--- a/drivers/crypto/inside-secure/safexcel.c
+++ b/drivers/crypto/inside-secure/safexcel.c
@@ -1195,6 +1195,7 @@ static int safexcel_request_ring_irq(void *pdev, int irqid,
 	&safexcel_alg_hmac_sha3_256,
 	&safexcel_alg_hmac_sha3_384,
 	&safexcel_alg_hmac_sha3_512,
+	&safexcel_alg_authenc_hmac_sha1_cbc_des,
 };
 
 static int safexcel_register_algorithms(struct safexcel_crypto_priv *priv)
diff --git a/drivers/crypto/inside-secure/safexcel.h b/drivers/crypto/inside-secure/safexcel.h
index 82953b3..b020e27 100644
--- a/drivers/crypto/inside-secure/safexcel.h
+++ b/drivers/crypto/inside-secure/safexcel.h
@@ -895,5 +895,6 @@ int safexcel_hmac_setkey(const char *alg, const u8 *key, unsigned int keylen,
 extern struct safexcel_alg_template safexcel_alg_hmac_sha3_256;
 extern struct safexcel_alg_template safexcel_alg_hmac_sha3_384;
 extern struct safexcel_alg_template safexcel_alg_hmac_sha3_512;
+extern struct safexcel_alg_template safexcel_alg_authenc_hmac_sha1_cbc_des;
 
 #endif
diff --git a/drivers/crypto/inside-secure/safexcel_cipher.c b/drivers/crypto/inside-secure/safexcel_cipher.c
index bf2b1f9..435f184 100644
--- a/drivers/crypto/inside-secure/safexcel_cipher.c
+++ b/drivers/crypto/inside-secure/safexcel_cipher.c
@@ -348,6 +348,7 @@ static int safexcel_aead_setkey(struct crypto_aead *ctfm, const u8 *key,
 	struct safexcel_crypto_priv *priv = ctx->priv;
 	struct crypto_authenc_keys keys;
 	struct crypto_aes_ctx aes;
+	u32 tmp[DES_EXPKEY_WORDS];
 	u32 flags;
 	int err = -EINVAL;
 
@@ -367,6 +368,16 @@ static int safexcel_aead_setkey(struct crypto_aead *ctfm, const u8 *key,
 
 	/* Encryption key */
 	switch (ctx->alg) {
+	case SAFEXCEL_DES:
+		if (keys.enckeylen != DES_KEY_SIZE)
+			goto badkey;
+		err = des_ekey(tmp, key);
+		if (unlikely(!err && (tfm->crt_flags &
+				      CRYPTO_TFM_REQ_FORBID_WEAK_KEYS))) {
+			tfm->crt_flags |= CRYPTO_TFM_RES_WEAK_KEY;
+			goto badkey_expflags;
+		}
+		break;
 	case SAFEXCEL_3DES:
 		if (keys.enckeylen != DES3_EDE_KEY_SIZE)
 			goto badkey;
@@ -1854,6 +1865,40 @@ struct safexcel_alg_template safexcel_alg_authenc_hmac_sha1_cbc_des3_ede = {
 	},
 };
 
+static int safexcel_aead_sha1_des_cra_init(struct crypto_tfm *tfm)
+{
+	struct safexcel_cipher_ctx *ctx = crypto_tfm_ctx(tfm);
+
+	safexcel_aead_sha1_cra_init(tfm);
+	ctx->alg = SAFEXCEL_DES; /* override default */
+	return 0;
+}
+
+struct safexcel_alg_template safexcel_alg_authenc_hmac_sha1_cbc_des = {
+	.type = SAFEXCEL_ALG_TYPE_AEAD,
+	.algo_mask = SAFEXCEL_ALG_DES | SAFEXCEL_ALG_SHA1,
+	.alg.aead = {
+		.setkey = safexcel_aead_setkey,
+		.encrypt = safexcel_aead_encrypt,
+		.decrypt = safexcel_aead_decrypt,
+		.ivsize = DES_BLOCK_SIZE,
+		.maxauthsize = SHA1_DIGEST_SIZE,
+		.base = {
+			.cra_name = "authenc(hmac(sha1),cbc(des))",
+			.cra_driver_name = "safexcel-authenc-hmac-sha1-cbc-des",
+			.cra_priority = SAFEXCEL_CRA_PRIORITY,
+			.cra_flags = CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_KERN_DRIVER_ONLY,
+			.cra_blocksize = DES_BLOCK_SIZE,
+			.cra_ctxsize = sizeof(struct safexcel_cipher_ctx),
+			.cra_alignmask = 0,
+			.cra_init = safexcel_aead_sha1_des_cra_init,
+			.cra_exit = safexcel_aead_cra_exit,
+			.cra_module = THIS_MODULE,
+		},
+	},
+};
+
 static int safexcel_aead_sha1_ctr_cra_init(struct crypto_tfm *tfm)
 {
 	struct safexcel_cipher_ctx *ctx = crypto_tfm_ctx(tfm);
-- 
1.8.3.1

