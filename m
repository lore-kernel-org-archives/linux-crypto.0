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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 037ADC49ED7
	for <linux-crypto@archiver.kernel.org>; Fri, 13 Sep 2019 15:06:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C6DEC20830
	for <linux-crypto@archiver.kernel.org>; Fri, 13 Sep 2019 15:06:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="e9lyHUNO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390891AbfIMPGS (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 13 Sep 2019 11:06:18 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:45954 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390886AbfIMPGS (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 13 Sep 2019 11:06:18 -0400
Received: by mail-ed1-f68.google.com with SMTP id f19so27301555eds.12
        for <linux-crypto@vger.kernel.org>; Fri, 13 Sep 2019 08:06:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=N7+xpC7VX0TYdVfKZ+DLq11WZ98g8hK0Q/jiC2I8GR4=;
        b=e9lyHUNOoGwanO0MdZSum+r/0Bv9JjuYTWPIg7p5AQqYak0MQ2PSzIm+aWiqufyUox
         tqZDBE19xmpvn3TBccx8cO/zYAoo/8S4KApbcIfscN19aJXi++W1n0vSr1NEC/Pb7bkJ
         EywbKcUjQc4RuQ6/a/lwrdiRGrXUF5IpdTPMqqEtp4KBJAnlojYOACjytyDoKWwZht4F
         NMq86C6kkXjrQ5E5Du00FVe9mbz94PrXkc0jf5V6RHOp7M87RTKtbQsdd6RgpTcfsocW
         yDOZ3k2872uFsdtR4RSuiORiARFfZLe5EvZyYKA5VEmvdCrw/dgaLgT5lh049gs8uY9C
         8ANw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=N7+xpC7VX0TYdVfKZ+DLq11WZ98g8hK0Q/jiC2I8GR4=;
        b=NNOadsd/V6OwyGYmimAAdxMnOg2c7lJbSYyPSbTb4rmNv25fGoXrsB5SUlKsFAUHhj
         Lg4aaHHusyz5dROtCSUsFM88nod9IITbsdmCg2+eAJqVqhNuSML+yNwZS5R1ZzcRlDFi
         5Wz2hiiap5d4mU/Li/hJZ7F+99S6cMzJH5ysm5V4YAYZqdPN7xD+V6iNQf4mWs44Qn6P
         bcUC0KqUScBGx1IDD0oPI/cNtPLAnT2X0fDJyGwbK3OORmqfrkTExW/0GKh/7ATFIwUF
         5NZHRC/9BNtiMsrCAWBoUJcmInrzY9CoZQD73HFbJUpsTT17mbanzNLE2YXJYLg5iQLc
         aDMA==
X-Gm-Message-State: APjAAAVv6IHk9Dw4QqbN2HbqCcuzL9EjWNlqg/Oj2i0bi1RlCGxxMzH7
        m15GjWSWC8nt0KkcM7+tb/sSUDZN
X-Google-Smtp-Source: APXvYqzQeqGR3A86o/ntKaUkcLf2Lslkpyh/27cl3/s6UP5Am20dRjb6Jt3/94TPsHbBklT64INGvA==
X-Received: by 2002:aa7:dc56:: with SMTP id g22mr48603265edu.212.1568387175517;
        Fri, 13 Sep 2019 08:06:15 -0700 (PDT)
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
Subject: [PATCH 2/3] crypto: inside-secure - Added support for authenc HMAC-SHA2/3DES-CBC
Date:   Fri, 13 Sep 2019 16:03:25 +0200
Message-Id: <1568383406-8009-3-git-send-email-pvanleeuwen@verimatrix.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1568383406-8009-1-git-send-email-pvanleeuwen@verimatrix.com>
References: <1568383406-8009-1-git-send-email-pvanleeuwen@verimatrix.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This patch adds support for the authenc(hmac(sha224),cbc(des3_ede)),
authenc(hmac(sha256),cbc(des3_ede)), authenc(hmac(sha384),cbc(des3_ede))
and authenc(hmac(sha512),cbc(des3_ede)) aead's

Signed-off-by: Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
---
 drivers/crypto/inside-secure/safexcel.c        |   4 +
 drivers/crypto/inside-secure/safexcel.h        |   4 +
 drivers/crypto/inside-secure/safexcel_cipher.c | 136 +++++++++++++++++++++++++
 3 files changed, 144 insertions(+)

diff --git a/drivers/crypto/inside-secure/safexcel.c b/drivers/crypto/inside-secure/safexcel.c
index 617c70b..4222ffa 100644
--- a/drivers/crypto/inside-secure/safexcel.c
+++ b/drivers/crypto/inside-secure/safexcel.c
@@ -1196,6 +1196,10 @@ static int safexcel_request_ring_irq(void *pdev, int irqid,
 	&safexcel_alg_hmac_sha3_384,
 	&safexcel_alg_hmac_sha3_512,
 	&safexcel_alg_authenc_hmac_sha1_cbc_des,
+	&safexcel_alg_authenc_hmac_sha256_cbc_des3_ede,
+	&safexcel_alg_authenc_hmac_sha224_cbc_des3_ede,
+	&safexcel_alg_authenc_hmac_sha512_cbc_des3_ede,
+	&safexcel_alg_authenc_hmac_sha384_cbc_des3_ede,
 };
 
 static int safexcel_register_algorithms(struct safexcel_crypto_priv *priv)
diff --git a/drivers/crypto/inside-secure/safexcel.h b/drivers/crypto/inside-secure/safexcel.h
index b020e27..fd6798f 100644
--- a/drivers/crypto/inside-secure/safexcel.h
+++ b/drivers/crypto/inside-secure/safexcel.h
@@ -896,5 +896,9 @@ int safexcel_hmac_setkey(const char *alg, const u8 *key, unsigned int keylen,
 extern struct safexcel_alg_template safexcel_alg_hmac_sha3_384;
 extern struct safexcel_alg_template safexcel_alg_hmac_sha3_512;
 extern struct safexcel_alg_template safexcel_alg_authenc_hmac_sha1_cbc_des;
+extern struct safexcel_alg_template safexcel_alg_authenc_hmac_sha256_cbc_des3_ede;
+extern struct safexcel_alg_template safexcel_alg_authenc_hmac_sha224_cbc_des3_ede;
+extern struct safexcel_alg_template safexcel_alg_authenc_hmac_sha512_cbc_des3_ede;
+extern struct safexcel_alg_template safexcel_alg_authenc_hmac_sha384_cbc_des3_ede;
 
 #endif
diff --git a/drivers/crypto/inside-secure/safexcel_cipher.c b/drivers/crypto/inside-secure/safexcel_cipher.c
index 435f184..0d26bea 100644
--- a/drivers/crypto/inside-secure/safexcel_cipher.c
+++ b/drivers/crypto/inside-secure/safexcel_cipher.c
@@ -1865,6 +1865,142 @@ struct safexcel_alg_template safexcel_alg_authenc_hmac_sha1_cbc_des3_ede = {
 	},
 };
 
+static int safexcel_aead_sha256_des3_cra_init(struct crypto_tfm *tfm)
+{
+	struct safexcel_cipher_ctx *ctx = crypto_tfm_ctx(tfm);
+
+	safexcel_aead_sha256_cra_init(tfm);
+	ctx->alg = SAFEXCEL_3DES; /* override default */
+	return 0;
+}
+
+struct safexcel_alg_template safexcel_alg_authenc_hmac_sha256_cbc_des3_ede = {
+	.type = SAFEXCEL_ALG_TYPE_AEAD,
+	.algo_mask = SAFEXCEL_ALG_DES | SAFEXCEL_ALG_SHA2_256,
+	.alg.aead = {
+		.setkey = safexcel_aead_setkey,
+		.encrypt = safexcel_aead_encrypt,
+		.decrypt = safexcel_aead_decrypt,
+		.ivsize = DES3_EDE_BLOCK_SIZE,
+		.maxauthsize = SHA256_DIGEST_SIZE,
+		.base = {
+			.cra_name = "authenc(hmac(sha256),cbc(des3_ede))",
+			.cra_driver_name = "safexcel-authenc-hmac-sha256-cbc-des3_ede",
+			.cra_priority = SAFEXCEL_CRA_PRIORITY,
+			.cra_flags = CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_KERN_DRIVER_ONLY,
+			.cra_blocksize = DES3_EDE_BLOCK_SIZE,
+			.cra_ctxsize = sizeof(struct safexcel_cipher_ctx),
+			.cra_alignmask = 0,
+			.cra_init = safexcel_aead_sha256_des3_cra_init,
+			.cra_exit = safexcel_aead_cra_exit,
+			.cra_module = THIS_MODULE,
+		},
+	},
+};
+
+static int safexcel_aead_sha224_des3_cra_init(struct crypto_tfm *tfm)
+{
+	struct safexcel_cipher_ctx *ctx = crypto_tfm_ctx(tfm);
+
+	safexcel_aead_sha224_cra_init(tfm);
+	ctx->alg = SAFEXCEL_3DES; /* override default */
+	return 0;
+}
+
+struct safexcel_alg_template safexcel_alg_authenc_hmac_sha224_cbc_des3_ede = {
+	.type = SAFEXCEL_ALG_TYPE_AEAD,
+	.algo_mask = SAFEXCEL_ALG_DES | SAFEXCEL_ALG_SHA2_256,
+	.alg.aead = {
+		.setkey = safexcel_aead_setkey,
+		.encrypt = safexcel_aead_encrypt,
+		.decrypt = safexcel_aead_decrypt,
+		.ivsize = DES3_EDE_BLOCK_SIZE,
+		.maxauthsize = SHA224_DIGEST_SIZE,
+		.base = {
+			.cra_name = "authenc(hmac(sha224),cbc(des3_ede))",
+			.cra_driver_name = "safexcel-authenc-hmac-sha224-cbc-des3_ede",
+			.cra_priority = SAFEXCEL_CRA_PRIORITY,
+			.cra_flags = CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_KERN_DRIVER_ONLY,
+			.cra_blocksize = DES3_EDE_BLOCK_SIZE,
+			.cra_ctxsize = sizeof(struct safexcel_cipher_ctx),
+			.cra_alignmask = 0,
+			.cra_init = safexcel_aead_sha224_des3_cra_init,
+			.cra_exit = safexcel_aead_cra_exit,
+			.cra_module = THIS_MODULE,
+		},
+	},
+};
+
+static int safexcel_aead_sha512_des3_cra_init(struct crypto_tfm *tfm)
+{
+	struct safexcel_cipher_ctx *ctx = crypto_tfm_ctx(tfm);
+
+	safexcel_aead_sha512_cra_init(tfm);
+	ctx->alg = SAFEXCEL_3DES; /* override default */
+	return 0;
+}
+
+struct safexcel_alg_template safexcel_alg_authenc_hmac_sha512_cbc_des3_ede = {
+	.type = SAFEXCEL_ALG_TYPE_AEAD,
+	.algo_mask = SAFEXCEL_ALG_DES | SAFEXCEL_ALG_SHA2_512,
+	.alg.aead = {
+		.setkey = safexcel_aead_setkey,
+		.encrypt = safexcel_aead_encrypt,
+		.decrypt = safexcel_aead_decrypt,
+		.ivsize = DES3_EDE_BLOCK_SIZE,
+		.maxauthsize = SHA512_DIGEST_SIZE,
+		.base = {
+			.cra_name = "authenc(hmac(sha512),cbc(des3_ede))",
+			.cra_driver_name = "safexcel-authenc-hmac-sha512-cbc-des3_ede",
+			.cra_priority = SAFEXCEL_CRA_PRIORITY,
+			.cra_flags = CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_KERN_DRIVER_ONLY,
+			.cra_blocksize = DES3_EDE_BLOCK_SIZE,
+			.cra_ctxsize = sizeof(struct safexcel_cipher_ctx),
+			.cra_alignmask = 0,
+			.cra_init = safexcel_aead_sha512_des3_cra_init,
+			.cra_exit = safexcel_aead_cra_exit,
+			.cra_module = THIS_MODULE,
+		},
+	},
+};
+
+static int safexcel_aead_sha384_des3_cra_init(struct crypto_tfm *tfm)
+{
+	struct safexcel_cipher_ctx *ctx = crypto_tfm_ctx(tfm);
+
+	safexcel_aead_sha384_cra_init(tfm);
+	ctx->alg = SAFEXCEL_3DES; /* override default */
+	return 0;
+}
+
+struct safexcel_alg_template safexcel_alg_authenc_hmac_sha384_cbc_des3_ede = {
+	.type = SAFEXCEL_ALG_TYPE_AEAD,
+	.algo_mask = SAFEXCEL_ALG_DES | SAFEXCEL_ALG_SHA2_512,
+	.alg.aead = {
+		.setkey = safexcel_aead_setkey,
+		.encrypt = safexcel_aead_encrypt,
+		.decrypt = safexcel_aead_decrypt,
+		.ivsize = DES3_EDE_BLOCK_SIZE,
+		.maxauthsize = SHA384_DIGEST_SIZE,
+		.base = {
+			.cra_name = "authenc(hmac(sha384),cbc(des3_ede))",
+			.cra_driver_name = "safexcel-authenc-hmac-sha384-cbc-des3_ede",
+			.cra_priority = SAFEXCEL_CRA_PRIORITY,
+			.cra_flags = CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_KERN_DRIVER_ONLY,
+			.cra_blocksize = DES3_EDE_BLOCK_SIZE,
+			.cra_ctxsize = sizeof(struct safexcel_cipher_ctx),
+			.cra_alignmask = 0,
+			.cra_init = safexcel_aead_sha384_des3_cra_init,
+			.cra_exit = safexcel_aead_cra_exit,
+			.cra_module = THIS_MODULE,
+		},
+	},
+};
+
 static int safexcel_aead_sha1_des_cra_init(struct crypto_tfm *tfm)
 {
 	struct safexcel_cipher_ctx *ctx = crypto_tfm_ctx(tfm);
-- 
1.8.3.1

