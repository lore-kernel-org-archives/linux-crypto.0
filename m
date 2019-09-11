Return-Path: <SRS0=VsuX=XG=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 865F1C5ACAE
	for <linux-crypto@archiver.kernel.org>; Wed, 11 Sep 2019 11:41:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5DF5B2081B
	for <linux-crypto@archiver.kernel.org>; Wed, 11 Sep 2019 11:41:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lCjj3WnR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727749AbfIKLlR (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 11 Sep 2019 07:41:17 -0400
Received: from mail-ed1-f65.google.com ([209.85.208.65]:43833 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726952AbfIKLlR (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 11 Sep 2019 07:41:17 -0400
Received: by mail-ed1-f65.google.com with SMTP id c19so20285277edy.10
        for <linux-crypto@vger.kernel.org>; Wed, 11 Sep 2019 04:41:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=E/mqsgC4LeD6CjDeKpjvPAL1o99XNe6FkErpCzvZtP8=;
        b=lCjj3WnRhbmZ/9NyDO7ObnYc/spVBBPonGsVw+rK7+bLahTPMxvTJsF0bpwwFeJGjB
         TYuzVg8QR1h4EFJANJGCEcGhC9LbHY8cN1EyuFFGXwhbmIyyY21Sbtnb5GZ1GB2NpfaV
         WsTJmHzY95mTTIDZxJhH4cV6UTH+OlGdk4QIMYptonWbCg8DzRDtx2Ix/A3L4A7DAhVH
         TFCcLQIjbOZcoTY8OHcgmyV4RzSoYHTvg30lEfHkEWazvw3AC/FYPlRrmFYl3GPGMPPP
         DVPCles2kL8/jBFkqp/rE5Z5dLC9kA0Zn4nTZ/y8Tkzt86rKjsSdXCN2QbKkSDvsRayl
         JHcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=E/mqsgC4LeD6CjDeKpjvPAL1o99XNe6FkErpCzvZtP8=;
        b=OYb0vBNQfihCWupzBtLjmES5P2R3k2iuFDjy2lN7kpxFBTnRhYe6siPyX+YjkKb/3J
         kRMmRNhdovfisENtCmVmOCP46SCGLp6l9bPweb70NRQT5TP+8x9ekugSTkLwtnqJnPth
         QdPXUnXsCDKsTh4jszDx4oMan2jegsVLeuKxTGHLn55I7hRpgnvCkeSBQ5WXqV4DIcjI
         O7czbBQX/gxOqzd9zG9NSOZdKOwVgK/ZUnNBdvH0WApzOylrGyu8U1dfsyBJOWX2aWPp
         RHFEx9zfLqhHq6hvkD2e1sE3FmY4F4KiBNhq8x8VvicaDX/UMbUoKWy3S4TyWARwc7wS
         lB9g==
X-Gm-Message-State: APjAAAW5ZioAziAWDgQnDwKOC/l2Xnx1/o7/mGzaDb+D2b5mDJlUEUnm
        waYpWUgxMU9V0VC/bltUG85QL6qH
X-Google-Smtp-Source: APXvYqxiTgDu82HL0uxdYYeZAydxG4LGC+PpZpipg4/nclLX+buuiHnJ/GZW8D3AAdMKdHe/Umzcrw==
X-Received: by 2002:a17:906:4ac1:: with SMTP id u1mr28987277ejt.293.1568202075544;
        Wed, 11 Sep 2019 04:41:15 -0700 (PDT)
Received: from localhost.localdomain.com ([188.204.2.113])
        by smtp.gmail.com with ESMTPSA id z6sm2448022ejo.26.2019.09.11.04.41.14
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 11 Sep 2019 04:41:15 -0700 (PDT)
From:   Pascal van Leeuwen <pascalvanl@gmail.com>
X-Google-Original-From: Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
To:     linux-crypto@vger.kernel.org
Cc:     antoine.tenart@bootlin.com, herbert@gondor.apana.org.au,
        davem@davemloft.net,
        Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
Subject: [PATCH 6/7] crypto: inside-secure - Add support for the rfc3685(ctr(sm4)) skcipher
Date:   Wed, 11 Sep 2019 12:38:23 +0200
Message-Id: <1568198304-8101-7-git-send-email-pvanleeuwen@verimatrix.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1568198304-8101-1-git-send-email-pvanleeuwen@verimatrix.com>
References: <1568198304-8101-1-git-send-email-pvanleeuwen@verimatrix.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This patch adds support for SM4 in (32 bit) CTR mode, i.e. skcipher
rfc3686(ctr(sm4)).

Signed-off-by: Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
---
 drivers/crypto/inside-secure/safexcel.c        |  1 +
 drivers/crypto/inside-secure/safexcel.h        |  1 +
 drivers/crypto/inside-secure/safexcel_cipher.c | 51 ++++++++++++++++++++++++++
 3 files changed, 53 insertions(+)

diff --git a/drivers/crypto/inside-secure/safexcel.c b/drivers/crypto/inside-secure/safexcel.c
index 1679b41..7da4801 100644
--- a/drivers/crypto/inside-secure/safexcel.c
+++ b/drivers/crypto/inside-secure/safexcel.c
@@ -1182,6 +1182,7 @@ static int safexcel_request_ring_irq(void *pdev, int irqid,
 	&safexcel_alg_cbc_sm4,
 	&safexcel_alg_ofb_sm4,
 	&safexcel_alg_cfb_sm4,
+	&safexcel_alg_ctr_sm4,
 };
 
 static int safexcel_register_algorithms(struct safexcel_crypto_priv *priv)
diff --git a/drivers/crypto/inside-secure/safexcel.h b/drivers/crypto/inside-secure/safexcel.h
index 07aa46b..d45ecf3 100644
--- a/drivers/crypto/inside-secure/safexcel.h
+++ b/drivers/crypto/inside-secure/safexcel.h
@@ -877,5 +877,6 @@ int safexcel_hmac_setkey(const char *alg, const u8 *key, unsigned int keylen,
 extern struct safexcel_alg_template safexcel_alg_cbc_sm4;
 extern struct safexcel_alg_template safexcel_alg_ofb_sm4;
 extern struct safexcel_alg_template safexcel_alg_cfb_sm4;
+extern struct safexcel_alg_template safexcel_alg_ctr_sm4;
 
 #endif
diff --git a/drivers/crypto/inside-secure/safexcel_cipher.c b/drivers/crypto/inside-secure/safexcel_cipher.c
index 89cef28..5f65748 100644
--- a/drivers/crypto/inside-secure/safexcel_cipher.c
+++ b/drivers/crypto/inside-secure/safexcel_cipher.c
@@ -2818,3 +2818,54 @@ struct safexcel_alg_template safexcel_alg_cfb_sm4 = {
 		},
 	},
 };
+
+static int safexcel_skcipher_sm4ctr_setkey(struct crypto_skcipher *ctfm,
+					   const u8 *key, unsigned int len)
+{
+	struct crypto_tfm *tfm = crypto_skcipher_tfm(ctfm);
+	struct safexcel_cipher_ctx *ctx = crypto_tfm_ctx(tfm);
+
+	/* last 4 bytes of key are the nonce! */
+	ctx->nonce = *(u32 *)(key + len - CTR_RFC3686_NONCE_SIZE);
+	/* exclude the nonce here */
+	len -= CTR_RFC3686_NONCE_SIZE;
+
+	return safexcel_skcipher_sm4_setkey(ctfm, key, len);
+}
+
+static int safexcel_skcipher_sm4_ctr_cra_init(struct crypto_tfm *tfm)
+{
+	struct safexcel_cipher_ctx *ctx = crypto_tfm_ctx(tfm);
+
+	safexcel_skcipher_cra_init(tfm);
+	ctx->alg  = SAFEXCEL_SM4;
+	ctx->mode = CONTEXT_CONTROL_CRYPTO_MODE_CTR_LOAD;
+	return 0;
+}
+
+struct safexcel_alg_template safexcel_alg_ctr_sm4 = {
+	.type = SAFEXCEL_ALG_TYPE_SKCIPHER,
+	.algo_mask = SAFEXCEL_ALG_SM4,
+	.alg.skcipher = {
+		.setkey = safexcel_skcipher_sm4ctr_setkey,
+		.encrypt = safexcel_encrypt,
+		.decrypt = safexcel_decrypt,
+		/* Add nonce size */
+		.min_keysize = SM4_KEY_SIZE + CTR_RFC3686_NONCE_SIZE,
+		.max_keysize = SM4_KEY_SIZE + CTR_RFC3686_NONCE_SIZE,
+		.ivsize = CTR_RFC3686_IV_SIZE,
+		.base = {
+			.cra_name = "rfc3686(ctr(sm4))",
+			.cra_driver_name = "safexcel-ctr-sm4",
+			.cra_priority = SAFEXCEL_CRA_PRIORITY,
+			.cra_flags = CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_KERN_DRIVER_ONLY,
+			.cra_blocksize = 1,
+			.cra_ctxsize = sizeof(struct safexcel_cipher_ctx),
+			.cra_alignmask = 0,
+			.cra_init = safexcel_skcipher_sm4_ctr_cra_init,
+			.cra_exit = safexcel_skcipher_cra_exit,
+			.cra_module = THIS_MODULE,
+		},
+	},
+};
-- 
1.8.3.1

