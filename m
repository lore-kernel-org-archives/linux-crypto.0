Return-Path: <SRS0=VSoq=W2=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14890C3A5A6
	for <linux-crypto@archiver.kernel.org>; Fri, 30 Aug 2019 08:55:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DC75021726
	for <linux-crypto@archiver.kernel.org>; Fri, 30 Aug 2019 08:55:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bHU/vtJ+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727768AbfH3IzU (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 30 Aug 2019 04:55:20 -0400
Received: from mail-ed1-f45.google.com ([209.85.208.45]:34410 "EHLO
        mail-ed1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726492AbfH3IzR (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 30 Aug 2019 04:55:17 -0400
Received: by mail-ed1-f45.google.com with SMTP id s49so7197392edb.1
        for <linux-crypto@vger.kernel.org>; Fri, 30 Aug 2019 01:55:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=w3VdgrMr7X3NYHGz48j/rPdCwHMJfcgYryQUB4FBkgg=;
        b=bHU/vtJ+KNGsSFEsAOGrYL62/t7Tc5I1oLEE6pR4MNeY10cF+mUnGPiJ56Xksl25Wi
         5kiFFJe5mCnywerWalndvr+OLDf49bHb/dRAp28zbuGxa2WqRDeNQ7EpCQDvp5RLWrRw
         QCQwOuTk+E1pZynB3QBnwqU2bNNGMss7qmnrUstq/MARjM5MBbO/7YfQCLU+ngfMHqDw
         2jBlmtHfStaUPR6nL2oBCezl74T9p5BkuegeFySCDKythWpAerRAe78efh/G2AmC1xAi
         GYDnGNY0izMvFUsH7m7TPsVmm0sgufUB7kG5wNUr1GKn82xhTrBftJaYJ0RcZUC3uvdQ
         AOvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=w3VdgrMr7X3NYHGz48j/rPdCwHMJfcgYryQUB4FBkgg=;
        b=c7gQwF8IOEZhaf86PRSLFoOWQQrzekx3LWpsoytBZWf6qadj8ogpuc/myV4D7Am0vx
         nFIRdq6BS+wYmKn0N9nk24vXWPePIq/H9GVC6437Yv4smjGGQlREGNOgO7+w1pdXsRqU
         ImtpjvjUYPuxCfzwyMUrB5dzmU1CuPFCaKwlM0Mmy3zgAz97lk7uOmPXsb5D+EMMLGYK
         CPGK0SzjqIe4ZqdACKUwiRz82pN+MkuiCopqMrAZ7YPFVgeuvuEi/KwMd1ZKnOZ8ZNWu
         hhPZJfxXMgmjVXn2H4dSUYG1LhOv0WZE3H1GD9g133g9GfhFO8Zb9j920KpaxJJuL48j
         HAUA==
X-Gm-Message-State: APjAAAVhFu7CVsVUcMgbC0HBzW9XdLJz1Htcwa2gZrI4sJ6Oq0YQvE3N
        +OqBuG4Fbrg0gPhOO0MYugI7FkzN
X-Google-Smtp-Source: APXvYqzoqB8e+o/Wrhx0bEXejNd6NCh/F3IAcprKKIaBNL6J/LMSJRLnT1iEt3tik+qQYgTR7YBPRw==
X-Received: by 2002:a17:906:6d2:: with SMTP id v18mr2400055ejb.249.1567155315486;
        Fri, 30 Aug 2019 01:55:15 -0700 (PDT)
Received: from localhost.localdomain.com ([188.204.2.113])
        by smtp.gmail.com with ESMTPSA id l9sm335610eda.51.2019.08.30.01.55.14
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 30 Aug 2019 01:55:15 -0700 (PDT)
From:   Pascal van Leeuwen <pascalvanl@gmail.com>
X-Google-Original-From: Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
To:     linux-crypto@vger.kernel.org
Cc:     antoine.tenart@bootlin.com, herbert@gondor.apana.org.au,
        davem@davemloft.net,
        Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
Subject: [PATCH 2/4] crypto: inside-secure - Added AES-CFB support
Date:   Fri, 30 Aug 2019 09:52:31 +0200
Message-Id: <1567151553-11108-3-git-send-email-pvanleeuwen@verimatrix.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1567151553-11108-1-git-send-email-pvanleeuwen@verimatrix.com>
References: <1567151553-11108-1-git-send-email-pvanleeuwen@verimatrix.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This patch adds support for AES in 128 bit cipher feedback mode (AES-CFB).

Signed-off-by: Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
---
 drivers/crypto/inside-secure/safexcel.c        |  1 +
 drivers/crypto/inside-secure/safexcel.h        |  2 ++
 drivers/crypto/inside-secure/safexcel_cipher.c | 36 ++++++++++++++++++++++++++
 3 files changed, 39 insertions(+)

diff --git a/drivers/crypto/inside-secure/safexcel.c b/drivers/crypto/inside-secure/safexcel.c
index 46cdcbe..3196cb3 100644
--- a/drivers/crypto/inside-secure/safexcel.c
+++ b/drivers/crypto/inside-secure/safexcel.c
@@ -981,6 +981,7 @@ static int safexcel_request_ring_irq(void *pdev, int irqid,
 	&safexcel_alg_cbc_des3_ede,
 	&safexcel_alg_ecb_aes,
 	&safexcel_alg_cbc_aes,
+	&safexcel_alg_cfb_aes,
 	&safexcel_alg_ctr_aes,
 	&safexcel_alg_md5,
 	&safexcel_alg_sha1,
diff --git a/drivers/crypto/inside-secure/safexcel.h b/drivers/crypto/inside-secure/safexcel.h
index c6f93ec..6f781ed 100644
--- a/drivers/crypto/inside-secure/safexcel.h
+++ b/drivers/crypto/inside-secure/safexcel.h
@@ -336,6 +336,7 @@ struct safexcel_context_record {
 /* control1 */
 #define CONTEXT_CONTROL_CRYPTO_MODE_ECB		(0 << 0)
 #define CONTEXT_CONTROL_CRYPTO_MODE_CBC		(1 << 0)
+#define CONTEXT_CONTROL_CRYPTO_MODE_CFB		(5 << 0)
 #define CONTEXT_CONTROL_CRYPTO_MODE_CTR_LOAD	(6 << 0)
 #define CONTEXT_CONTROL_CRYPTO_MODE_XTS		(7 << 0)
 #define CONTEXT_CONTROL_CRYPTO_MODE_XCM		((6 << 0) | BIT(17))
@@ -767,6 +768,7 @@ int safexcel_hmac_setkey(const char *alg, const u8 *key, unsigned int keylen,
 extern struct safexcel_alg_template safexcel_alg_cbc_des3_ede;
 extern struct safexcel_alg_template safexcel_alg_ecb_aes;
 extern struct safexcel_alg_template safexcel_alg_cbc_aes;
+extern struct safexcel_alg_template safexcel_alg_cfb_aes;
 extern struct safexcel_alg_template safexcel_alg_ctr_aes;
 extern struct safexcel_alg_template safexcel_alg_md5;
 extern struct safexcel_alg_template safexcel_alg_sha1;
diff --git a/drivers/crypto/inside-secure/safexcel_cipher.c b/drivers/crypto/inside-secure/safexcel_cipher.c
index 6f088b4..2a7d51b 100644
--- a/drivers/crypto/inside-secure/safexcel_cipher.c
+++ b/drivers/crypto/inside-secure/safexcel_cipher.c
@@ -1142,6 +1142,42 @@ struct safexcel_alg_template safexcel_alg_cbc_aes = {
 	},
 };
 
+static int safexcel_skcipher_aes_cfb_cra_init(struct crypto_tfm *tfm)
+{
+	struct safexcel_cipher_ctx *ctx = crypto_tfm_ctx(tfm);
+
+	safexcel_skcipher_cra_init(tfm);
+	ctx->alg  = SAFEXCEL_AES;
+	ctx->mode = CONTEXT_CONTROL_CRYPTO_MODE_CFB;
+	return 0;
+}
+
+struct safexcel_alg_template safexcel_alg_cfb_aes = {
+	.type = SAFEXCEL_ALG_TYPE_SKCIPHER,
+	.algo_mask = SAFEXCEL_ALG_AES | SAFEXCEL_ALG_AES_XFB,
+	.alg.skcipher = {
+		.setkey = safexcel_skcipher_aes_setkey,
+		.encrypt = safexcel_encrypt,
+		.decrypt = safexcel_decrypt,
+		.min_keysize = AES_MIN_KEY_SIZE,
+		.max_keysize = AES_MAX_KEY_SIZE,
+		.ivsize = AES_BLOCK_SIZE,
+		.base = {
+			.cra_name = "cfb(aes)",
+			.cra_driver_name = "safexcel-cfb-aes",
+			.cra_priority = SAFEXCEL_CRA_PRIORITY,
+			.cra_flags = CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_KERN_DRIVER_ONLY,
+			.cra_blocksize = 1,
+			.cra_ctxsize = sizeof(struct safexcel_cipher_ctx),
+			.cra_alignmask = 0,
+			.cra_init = safexcel_skcipher_aes_cfb_cra_init,
+			.cra_exit = safexcel_skcipher_cra_exit,
+			.cra_module = THIS_MODULE,
+		},
+	},
+};
+
 static int safexcel_skcipher_aesctr_setkey(struct crypto_skcipher *ctfm,
 					   const u8 *key, unsigned int len)
 {
-- 
1.8.3.1

