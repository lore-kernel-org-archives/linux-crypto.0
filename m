Return-Path: <SRS0=vORM=XI=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60AD7C4CEC7
	for <linux-crypto@archiver.kernel.org>; Fri, 13 Sep 2019 10:13:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 388612084F
	for <linux-crypto@archiver.kernel.org>; Fri, 13 Sep 2019 10:13:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LT0vJXWv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388087AbfIMKNe (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 13 Sep 2019 06:13:34 -0400
Received: from mail-ed1-f51.google.com ([209.85.208.51]:42174 "EHLO
        mail-ed1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729390AbfIMKNe (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 13 Sep 2019 06:13:34 -0400
Received: by mail-ed1-f51.google.com with SMTP id y91so26539456ede.9
        for <linux-crypto@vger.kernel.org>; Fri, 13 Sep 2019 03:13:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=dHHzqej96tGxM6bVJLpSRZWkABSlgEkahG3uNvghCD8=;
        b=LT0vJXWvZnfbp/TX8hUT1MHzAfsy4IEvL9uX4mgNqP9BrKJEft0HXsUTm2RL0VJiyk
         HuJAm38WKffC1vvZMZePAF8vvlMtR9bwmbAZRT2mBLyNQ1nKhgP/fsSYjfpvi/Jhlw3S
         eHmGWYMzPMOFw7kicmrO9KRkqRgG9tSzzZnj46LT7uzc+09HRsDeaYkrIDeAs2NYdDnl
         kPbhzJl9TwY6i1elVyAILMQIfF6H6leJ6rC5ZLRwGvPmipIjpv0tPuHMbEXmvF7iWIm4
         aIpGi3zxAnEhPB47SI39Vyb6tki+MBhz+cSwVAuMKosVbivQoa1dgR7zULmJFJNQDajV
         PYIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=dHHzqej96tGxM6bVJLpSRZWkABSlgEkahG3uNvghCD8=;
        b=JsUvAIPWizMRIatqk5rFsKyqBl6ah53IId0XabS0Cwyfmqt9h9+tI1HiYMd7Nk8j3l
         xt3unyzVXw+h9+67cPXoalgHQOdp6jx4etiDw2TR1y1QyHOwLAy3wyDXrJFi1lbiKOVl
         dhWQ2GJQ/Jo+2FcicyS4Zpygc9I8Bys1NJ3HWlN+ouge2U90s1ksA/botGC8Ar0n9gmZ
         K4HhsWhH5dypFhf/b3BgortwQSxXlKWfhZhUFQjWR/C6RhjFskQMjY81mMh1Xx6qITcr
         z/BmsLMSMKtx2n9ewttd215KYjfO/2veFDWsjJP47390gnKq+Yapx3t5CHQ1sl0U0e+M
         kOaA==
X-Gm-Message-State: APjAAAWTj/iKGUwZfqGDcdStZDo4DEShGsVm6UPDCpTuJkwuxgVbFirA
        EU1fAJbwEkKvt2EawYQ/hgVlphk8
X-Google-Smtp-Source: APXvYqxB+4KNj4qAeZb7d8fVlRNQd0PU38Yi4qxSClP40s8C0Z8ZflQfX8Gt2PeaANlnYnH+Uz7BSg==
X-Received: by 2002:a50:a8c5:: with SMTP id k63mr7048147edc.122.1568369611498;
        Fri, 13 Sep 2019 03:13:31 -0700 (PDT)
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
Subject: [PATCHv2 2/7] crypto: inside-secure - Add support for the cbc(sm4) skcipher
Date:   Fri, 13 Sep 2019 11:10:37 +0200
Message-Id: <1568365842-19905-3-git-send-email-pvanleeuwen@verimatrix.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1568365842-19905-1-git-send-email-pvanleeuwen@verimatrix.com>
References: <1568365842-19905-1-git-send-email-pvanleeuwen@verimatrix.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This patch adds support for SM4 in CBC mode, i.e. skcipher cbc(sm4).

changes since v1:
- nothing

Signed-off-by: Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
---
 drivers/crypto/inside-secure/safexcel.c        |  1 +
 drivers/crypto/inside-secure/safexcel.h        |  1 +
 drivers/crypto/inside-secure/safexcel_cipher.c | 36 ++++++++++++++++++++++++++
 3 files changed, 38 insertions(+)

diff --git a/drivers/crypto/inside-secure/safexcel.c b/drivers/crypto/inside-secure/safexcel.c
index fe785e8..4320992 100644
--- a/drivers/crypto/inside-secure/safexcel.c
+++ b/drivers/crypto/inside-secure/safexcel.c
@@ -1179,6 +1179,7 @@ static int safexcel_request_ring_irq(void *pdev, int irqid,
 	&safexcel_alg_sm3,
 	&safexcel_alg_hmac_sm3,
 	&safexcel_alg_ecb_sm4,
+	&safexcel_alg_cbc_sm4,
 };
 
 static int safexcel_register_algorithms(struct safexcel_crypto_priv *priv)
diff --git a/drivers/crypto/inside-secure/safexcel.h b/drivers/crypto/inside-secure/safexcel.h
index 7a3183e..71eec5c 100644
--- a/drivers/crypto/inside-secure/safexcel.h
+++ b/drivers/crypto/inside-secure/safexcel.h
@@ -874,5 +874,6 @@ int safexcel_hmac_setkey(const char *alg, const u8 *key, unsigned int keylen,
 extern struct safexcel_alg_template safexcel_alg_sm3;
 extern struct safexcel_alg_template safexcel_alg_hmac_sm3;
 extern struct safexcel_alg_template safexcel_alg_ecb_sm4;
+extern struct safexcel_alg_template safexcel_alg_cbc_sm4;
 
 #endif
diff --git a/drivers/crypto/inside-secure/safexcel_cipher.c b/drivers/crypto/inside-secure/safexcel_cipher.c
index f389a3c..ae2b634 100644
--- a/drivers/crypto/inside-secure/safexcel_cipher.c
+++ b/drivers/crypto/inside-secure/safexcel_cipher.c
@@ -2720,3 +2720,39 @@ struct safexcel_alg_template safexcel_alg_ecb_sm4 = {
 		},
 	},
 };
+
+static int safexcel_skcipher_sm4_cbc_cra_init(struct crypto_tfm *tfm)
+{
+	struct safexcel_cipher_ctx *ctx = crypto_tfm_ctx(tfm);
+
+	safexcel_skcipher_cra_init(tfm);
+	ctx->alg  = SAFEXCEL_SM4;
+	ctx->mode = CONTEXT_CONTROL_CRYPTO_MODE_CBC;
+	return 0;
+}
+
+struct safexcel_alg_template safexcel_alg_cbc_sm4 = {
+	.type = SAFEXCEL_ALG_TYPE_SKCIPHER,
+	.algo_mask = SAFEXCEL_ALG_SM4,
+	.alg.skcipher = {
+		.setkey = safexcel_skcipher_sm4_setkey,
+		.encrypt = safexcel_sm4_blk_encrypt,
+		.decrypt = safexcel_sm4_blk_decrypt,
+		.min_keysize = SM4_KEY_SIZE,
+		.max_keysize = SM4_KEY_SIZE,
+		.ivsize = SM4_BLOCK_SIZE,
+		.base = {
+			.cra_name = "cbc(sm4)",
+			.cra_driver_name = "safexcel-cbc-sm4",
+			.cra_priority = SAFEXCEL_CRA_PRIORITY,
+			.cra_flags = CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_KERN_DRIVER_ONLY,
+			.cra_blocksize = SM4_BLOCK_SIZE,
+			.cra_ctxsize = sizeof(struct safexcel_cipher_ctx),
+			.cra_alignmask = 0,
+			.cra_init = safexcel_skcipher_sm4_cbc_cra_init,
+			.cra_exit = safexcel_skcipher_cra_exit,
+			.cra_module = THIS_MODULE,
+		},
+	},
+};
-- 
1.8.3.1

