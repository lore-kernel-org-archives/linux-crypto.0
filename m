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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E81FC49ED7
	for <linux-crypto@archiver.kernel.org>; Fri, 13 Sep 2019 10:13:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DAA642089F
	for <linux-crypto@archiver.kernel.org>; Fri, 13 Sep 2019 10:13:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="rLQgfSUy"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729401AbfIMKNe (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 13 Sep 2019 06:13:34 -0400
Received: from mail-ed1-f52.google.com ([209.85.208.52]:44519 "EHLO
        mail-ed1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729368AbfIMKNe (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 13 Sep 2019 06:13:34 -0400
Received: by mail-ed1-f52.google.com with SMTP id p2so25345086edx.11
        for <linux-crypto@vger.kernel.org>; Fri, 13 Sep 2019 03:13:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=nTfuAyuLbmmlhQjE6Xlz+2mZhBEXtYfSxeThopYDhRs=;
        b=rLQgfSUy3oK44/3qr5l2mbTbqNV3+QPWVIU+suz0GJIVLh337p8pAveaS/FWvM/XSf
         fnG25he3pjBmKNcuffsJo/xGbacH0LlwWDIZHBlkVwMDMKJUvjCy5g3dWZ4+MC89dyOd
         la6k4ZASSmz48EUo1pgwHRKW44OAnaMNeMFzaVEAwN8Opl4W2Fiu35mOQUMTW10Xxt+8
         X+nqD6YxoGR5mzuhkrQHHx1fMRCuezEb4Xes7mKIOQqwQTHjF2T5swAseU6aIez4cFlJ
         H2poxrf9CLdZpAKDn+eLoPBCu5ZBvzJhzfmaFMMGKjsfx2/Pe2Ii+spLRmf1CK43HkGg
         ZINg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=nTfuAyuLbmmlhQjE6Xlz+2mZhBEXtYfSxeThopYDhRs=;
        b=s6AS9LZs+27jXmT3yEfJWG9oNG68haPN0GH63lUFHKcA/7DrmdEBW6HRlt9kPHoLVp
         QEebBDXqp8iTcvNNVJ+B8nN5csXwB4mtvu3qS0KG/erojE5KROqRCf7AngE3T9px0/sk
         sJZ2aWvMNFigcYqwGMgl2S6FImtF5bv8uU/ta4qLnG5GxN3tJBHU0sXtd6XW8exryheM
         WljC3HTMomWBOT+LeZ2hO3ymXoXdSfLzOWXiI8xOnriEwoD5bCD8x36iQl7nVw4NREDM
         Paw/aMzhl9qZTysr7ZR4u7B26c1ogZ2WbBeEzIzInbWVQgJl3uy5t0PLADA3IrgkQFVt
         MKQQ==
X-Gm-Message-State: APjAAAXh0yY40v/lc+Zg7BNc+imTKqtpmFIlolGuUB5JmozTtB2EP46b
        Oht7lF3MKJUNvcsHieMqMGCEPgtC
X-Google-Smtp-Source: APXvYqyXdcUZP9JFk2FdDxwY3kKvQJj5PMs0kbtaZ69MKspXFUgfqMKpHONjAyTQfv9D83zctZVsYA==
X-Received: by 2002:a17:906:400c:: with SMTP id v12mr37935957ejj.15.1568369612397;
        Fri, 13 Sep 2019 03:13:32 -0700 (PDT)
Received: from localhost.localdomain.com ([188.204.2.113])
        by smtp.gmail.com with ESMTPSA id z65sm5314382ede.86.2019.09.13.03.13.31
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 13 Sep 2019 03:13:31 -0700 (PDT)
From:   Pascal van Leeuwen <pascalvanl@gmail.com>
X-Google-Original-From: Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
To:     linux-crypto@vger.kernel.org
Cc:     antoine.tenart@bootlin.com, herbert@gondor.apana.org.au,
        davem@davemloft.net,
        Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
Subject: [PATCHv2 3/7] crypto: inside-secure - Add support for the ofb(sm4) skcipher
Date:   Fri, 13 Sep 2019 11:10:38 +0200
Message-Id: <1568365842-19905-4-git-send-email-pvanleeuwen@verimatrix.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1568365842-19905-1-git-send-email-pvanleeuwen@verimatrix.com>
References: <1568365842-19905-1-git-send-email-pvanleeuwen@verimatrix.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This patch adds support for SM4 in OFB mode, i.e. skcipher ofb(sm4).

changes since v1:
- nothing

Signed-off-by: Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
---
 drivers/crypto/inside-secure/safexcel.c        |  1 +
 drivers/crypto/inside-secure/safexcel.h        |  1 +
 drivers/crypto/inside-secure/safexcel_cipher.c | 36 ++++++++++++++++++++++++++
 3 files changed, 38 insertions(+)

diff --git a/drivers/crypto/inside-secure/safexcel.c b/drivers/crypto/inside-secure/safexcel.c
index 4320992..fbfda68 100644
--- a/drivers/crypto/inside-secure/safexcel.c
+++ b/drivers/crypto/inside-secure/safexcel.c
@@ -1180,6 +1180,7 @@ static int safexcel_request_ring_irq(void *pdev, int irqid,
 	&safexcel_alg_hmac_sm3,
 	&safexcel_alg_ecb_sm4,
 	&safexcel_alg_cbc_sm4,
+	&safexcel_alg_ofb_sm4,
 };
 
 static int safexcel_register_algorithms(struct safexcel_crypto_priv *priv)
diff --git a/drivers/crypto/inside-secure/safexcel.h b/drivers/crypto/inside-secure/safexcel.h
index 71eec5c..8e01d24 100644
--- a/drivers/crypto/inside-secure/safexcel.h
+++ b/drivers/crypto/inside-secure/safexcel.h
@@ -875,5 +875,6 @@ int safexcel_hmac_setkey(const char *alg, const u8 *key, unsigned int keylen,
 extern struct safexcel_alg_template safexcel_alg_hmac_sm3;
 extern struct safexcel_alg_template safexcel_alg_ecb_sm4;
 extern struct safexcel_alg_template safexcel_alg_cbc_sm4;
+extern struct safexcel_alg_template safexcel_alg_ofb_sm4;
 
 #endif
diff --git a/drivers/crypto/inside-secure/safexcel_cipher.c b/drivers/crypto/inside-secure/safexcel_cipher.c
index ae2b634..95f9214 100644
--- a/drivers/crypto/inside-secure/safexcel_cipher.c
+++ b/drivers/crypto/inside-secure/safexcel_cipher.c
@@ -2756,3 +2756,39 @@ struct safexcel_alg_template safexcel_alg_cbc_sm4 = {
 		},
 	},
 };
+
+static int safexcel_skcipher_sm4_ofb_cra_init(struct crypto_tfm *tfm)
+{
+	struct safexcel_cipher_ctx *ctx = crypto_tfm_ctx(tfm);
+
+	safexcel_skcipher_cra_init(tfm);
+	ctx->alg  = SAFEXCEL_SM4;
+	ctx->mode = CONTEXT_CONTROL_CRYPTO_MODE_OFB;
+	return 0;
+}
+
+struct safexcel_alg_template safexcel_alg_ofb_sm4 = {
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
+			.cra_name = "ofb(sm4)",
+			.cra_driver_name = "safexcel-ofb-sm4",
+			.cra_priority = SAFEXCEL_CRA_PRIORITY,
+			.cra_flags = CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_KERN_DRIVER_ONLY,
+			.cra_blocksize = 1,
+			.cra_ctxsize = sizeof(struct safexcel_cipher_ctx),
+			.cra_alignmask = 0,
+			.cra_init = safexcel_skcipher_sm4_ofb_cra_init,
+			.cra_exit = safexcel_skcipher_cra_exit,
+			.cra_module = THIS_MODULE,
+		},
+	},
+};
-- 
1.8.3.1

