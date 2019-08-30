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
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6DABC3A5A6
	for <linux-crypto@archiver.kernel.org>; Fri, 30 Aug 2019 08:55:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9FACA21726
	for <linux-crypto@archiver.kernel.org>; Fri, 30 Aug 2019 08:55:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="J7MW5/Hl"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726495AbfH3IzS (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 30 Aug 2019 04:55:18 -0400
Received: from mail-ed1-f41.google.com ([209.85.208.41]:34408 "EHLO
        mail-ed1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727125AbfH3IzR (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 30 Aug 2019 04:55:17 -0400
Received: by mail-ed1-f41.google.com with SMTP id s49so7197436edb.1
        for <linux-crypto@vger.kernel.org>; Fri, 30 Aug 2019 01:55:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=smhViiXIJXblfhnsNWm/TA8dyuw/uxFK/cFDIU0Wcao=;
        b=J7MW5/HlXCcU2LVBmoscDg5PZBE7KSzymWAB5FDVgsbkYrFoXWykrFQTQbBZABCqiF
         wK6NV0yM3uooB9os1yxH7f1O9XlW8piDRIeqWgFSws28UKGPxGuKVPNZV22b+gjjX22t
         WmTZBisWhFQTXkM9kMCtAUpLUBBVmKgYEAyWm3HwiKzNCUx7uyi4kEDWUvSL0debyclC
         RsIY+w9po+52CT5aaZs3pqqOVdD7jA+jEpF/k7+W483EKNTmLzbLMA4Uq3DC6qOnjIgT
         V1FLhFcnKTpr+Nu8oG/4ZnlqwEJWwI0i2fvT/A5ZawXhNpX7xgo4+MQ+2uHTdxDPDgxX
         BwFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=smhViiXIJXblfhnsNWm/TA8dyuw/uxFK/cFDIU0Wcao=;
        b=JrGmRMcwHMLuSzWwJm8L8arjlM5oVdtBIg2kpiHjeMHneTn+vRV/EgCAP9WMnmUsme
         7M5wQhYqknq7NmfJipx8TKlA4NM8OZ9BP+aizcgnjbnfEp7S10MZzR5VQn25bCWpOK8U
         6JFJxRGBGqIAnc9zVppmqrC89g4GPS26z3ZclHLC10v5sRBxQBg2kvCGglTxAdg5vqEg
         rZw3kMAE1Em5MH1bNG6jlWyEknyb6cA41mrCiHEQxIjTO9sUoa6W2m7t1mfu+qD0Dtm4
         mtIX5bNIs46NR/5YpvUjfBTABwhOX/7iWQdtKUv3ZxTrO5MfZUMXEL0jZKbq78sw1eZg
         3yUQ==
X-Gm-Message-State: APjAAAV/2yQt6QVXNiG88vPQV0zJoR8e6xaqAxIxz1nT/HSPQXYnJrhO
        lu14CvbWveu96PCDMs/I5/lFCGdL
X-Google-Smtp-Source: APXvYqzdIaih8WfyK4GoOMTND1rL/rzDV0XVn8ieZ8yIJHAXc8nB3dnrg64D+KWx1xz07akF8Px9XQ==
X-Received: by 2002:aa7:d80d:: with SMTP id v13mr8850368edq.168.1567155316136;
        Fri, 30 Aug 2019 01:55:16 -0700 (PDT)
Received: from localhost.localdomain.com ([188.204.2.113])
        by smtp.gmail.com with ESMTPSA id l9sm335610eda.51.2019.08.30.01.55.15
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 30 Aug 2019 01:55:15 -0700 (PDT)
From:   Pascal van Leeuwen <pascalvanl@gmail.com>
X-Google-Original-From: Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
To:     linux-crypto@vger.kernel.org
Cc:     antoine.tenart@bootlin.com, herbert@gondor.apana.org.au,
        davem@davemloft.net,
        Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
Subject: [PATCH 3/4] crypto: inside-secure - Added AES-OFB support
Date:   Fri, 30 Aug 2019 09:52:32 +0200
Message-Id: <1567151553-11108-4-git-send-email-pvanleeuwen@verimatrix.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1567151553-11108-1-git-send-email-pvanleeuwen@verimatrix.com>
References: <1567151553-11108-1-git-send-email-pvanleeuwen@verimatrix.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This patch adds support for AES in output feedback mode (AES-OFB).

Signed-off-by: Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
---
 drivers/crypto/inside-secure/safexcel.c        |  1 +
 drivers/crypto/inside-secure/safexcel.h        |  2 ++
 drivers/crypto/inside-secure/safexcel_cipher.c | 36 ++++++++++++++++++++++++++
 3 files changed, 39 insertions(+)

diff --git a/drivers/crypto/inside-secure/safexcel.c b/drivers/crypto/inside-secure/safexcel.c
index 3196cb3..5ad4feb 100644
--- a/drivers/crypto/inside-secure/safexcel.c
+++ b/drivers/crypto/inside-secure/safexcel.c
@@ -982,6 +982,7 @@ static int safexcel_request_ring_irq(void *pdev, int irqid,
 	&safexcel_alg_ecb_aes,
 	&safexcel_alg_cbc_aes,
 	&safexcel_alg_cfb_aes,
+	&safexcel_alg_ofb_aes,
 	&safexcel_alg_ctr_aes,
 	&safexcel_alg_md5,
 	&safexcel_alg_sha1,
diff --git a/drivers/crypto/inside-secure/safexcel.h b/drivers/crypto/inside-secure/safexcel.h
index 6f781ed..0eb3445 100644
--- a/drivers/crypto/inside-secure/safexcel.h
+++ b/drivers/crypto/inside-secure/safexcel.h
@@ -336,6 +336,7 @@ struct safexcel_context_record {
 /* control1 */
 #define CONTEXT_CONTROL_CRYPTO_MODE_ECB		(0 << 0)
 #define CONTEXT_CONTROL_CRYPTO_MODE_CBC		(1 << 0)
+#define CONTEXT_CONTROL_CRYPTO_MODE_OFB		(4 << 0)
 #define CONTEXT_CONTROL_CRYPTO_MODE_CFB		(5 << 0)
 #define CONTEXT_CONTROL_CRYPTO_MODE_CTR_LOAD	(6 << 0)
 #define CONTEXT_CONTROL_CRYPTO_MODE_XTS		(7 << 0)
@@ -769,6 +770,7 @@ int safexcel_hmac_setkey(const char *alg, const u8 *key, unsigned int keylen,
 extern struct safexcel_alg_template safexcel_alg_ecb_aes;
 extern struct safexcel_alg_template safexcel_alg_cbc_aes;
 extern struct safexcel_alg_template safexcel_alg_cfb_aes;
+extern struct safexcel_alg_template safexcel_alg_ofb_aes;
 extern struct safexcel_alg_template safexcel_alg_ctr_aes;
 extern struct safexcel_alg_template safexcel_alg_md5;
 extern struct safexcel_alg_template safexcel_alg_sha1;
diff --git a/drivers/crypto/inside-secure/safexcel_cipher.c b/drivers/crypto/inside-secure/safexcel_cipher.c
index 2a7d51b..bc4ebc7 100644
--- a/drivers/crypto/inside-secure/safexcel_cipher.c
+++ b/drivers/crypto/inside-secure/safexcel_cipher.c
@@ -1178,6 +1178,42 @@ struct safexcel_alg_template safexcel_alg_cfb_aes = {
 	},
 };
 
+static int safexcel_skcipher_aes_ofb_cra_init(struct crypto_tfm *tfm)
+{
+	struct safexcel_cipher_ctx *ctx = crypto_tfm_ctx(tfm);
+
+	safexcel_skcipher_cra_init(tfm);
+	ctx->alg  = SAFEXCEL_AES;
+	ctx->mode = CONTEXT_CONTROL_CRYPTO_MODE_OFB;
+	return 0;
+}
+
+struct safexcel_alg_template safexcel_alg_ofb_aes = {
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
+			.cra_name = "ofb(aes)",
+			.cra_driver_name = "safexcel-ofb-aes",
+			.cra_priority = SAFEXCEL_CRA_PRIORITY,
+			.cra_flags = CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_KERN_DRIVER_ONLY,
+			.cra_blocksize = 1,
+			.cra_ctxsize = sizeof(struct safexcel_cipher_ctx),
+			.cra_alignmask = 0,
+			.cra_init = safexcel_skcipher_aes_ofb_cra_init,
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

