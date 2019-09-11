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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43206ECDE2A
	for <linux-crypto@archiver.kernel.org>; Wed, 11 Sep 2019 11:41:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0D87420872
	for <linux-crypto@archiver.kernel.org>; Wed, 11 Sep 2019 11:41:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AyjeTdfM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727779AbfIKLlP (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 11 Sep 2019 07:41:15 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:46818 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727749AbfIKLlO (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 11 Sep 2019 07:41:14 -0400
Received: by mail-ed1-f67.google.com with SMTP id i8so20272644edn.13
        for <linux-crypto@vger.kernel.org>; Wed, 11 Sep 2019 04:41:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=oDWh0PfuOEYRj5yeDVqEmYIGYXhJ8f9PajvmcjVvmoI=;
        b=AyjeTdfMNQsymhlEkE3ZTIpxFrT2YzbcXe2uGvI1iVHm9c1uEHnGRiXWkjjfgHiP5G
         k4yFpV4/Lk1o3hSvsUizINRe4yH7Kutl7wMkjl1Q9SrOVcNh4Wz1YnE8KV6lR7sEbjDS
         T7GcYbXWIdsf4/ciW9ASxB93bHILHlwwvAwqTZ4Mp5q5+n83WeYb6nKqvLjha87mFaJE
         ZB1PSjyTdKbcw4EA8hBv5JFoGvdB/f7YSVkWbwwz11zszVFoz9ASOYT+IQAH6gs/4fs2
         iJm/cxJwUwZ25NOovsB3Ai/KLzKdeHeve/+OMwam91wwcieitKu7mLjDtOWjEChcsT4s
         4Lpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=oDWh0PfuOEYRj5yeDVqEmYIGYXhJ8f9PajvmcjVvmoI=;
        b=MOOrvsSlZUlC9GkV2EuiKERF3QlcdJ+9WAVfziZarrzLX/atzvdbBX40XdeFVd3rsA
         TbWsk325kfNZgrzbsDtlyjdocVHYAHKz4cAIm/F0HsOXyzQZIimeMsY9gb5XWNWdDRfE
         CPUqhYBBkmSnxCaXLOHWgSngS+9TzzdVqOlUCLt2KKYDOfj2O0hwfNiFmqZ7LT42IrxP
         OwZdWJJqCrHBKsgAlBV8G6fzfVwbRRPznaSCQ1c9BmHNZTt93DJJRNc/o+GUYNjgXG2N
         tEYmn0ltGH1KVGdlU4+/g1vwioY329lYMYPvWHifrDsWT1UmU2+mp/EN1kQJ7cVWED9e
         E4vw==
X-Gm-Message-State: APjAAAXhrnPG2qTkE1FiH4WcHQqlwhr7GeJZJWqpolu58gfajrId2S7n
        VxwFhb9Aa/j93gCcfIAq50mfJYEK
X-Google-Smtp-Source: APXvYqzYcgB+558aqm1KuztjrFBEWuKxhc8WjWG7ZJ0uqevg7/UseGB29akfqkVXO/bl9wynI81rzQ==
X-Received: by 2002:a50:8a9a:: with SMTP id j26mr36070987edj.251.1568202073408;
        Wed, 11 Sep 2019 04:41:13 -0700 (PDT)
Received: from localhost.localdomain.com ([188.204.2.113])
        by smtp.gmail.com with ESMTPSA id z6sm2448022ejo.26.2019.09.11.04.41.12
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 11 Sep 2019 04:41:12 -0700 (PDT)
From:   Pascal van Leeuwen <pascalvanl@gmail.com>
X-Google-Original-From: Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
To:     linux-crypto@vger.kernel.org
Cc:     antoine.tenart@bootlin.com, herbert@gondor.apana.org.au,
        davem@davemloft.net,
        Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
Subject: [PATCH 3/7] crypto: inside-secure - Add support for the ofb(sm4) skcipher
Date:   Wed, 11 Sep 2019 12:38:20 +0200
Message-Id: <1568198304-8101-4-git-send-email-pvanleeuwen@verimatrix.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1568198304-8101-1-git-send-email-pvanleeuwen@verimatrix.com>
References: <1568198304-8101-1-git-send-email-pvanleeuwen@verimatrix.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This patch adds support for SM4 in OFB mode, i.e. skcipher ofb(sm4).

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
index 1339f0e..448db38 100644
--- a/drivers/crypto/inside-secure/safexcel.h
+++ b/drivers/crypto/inside-secure/safexcel.h
@@ -875,5 +875,6 @@ int safexcel_hmac_setkey(const char *alg, const u8 *key, unsigned int keylen,
 extern struct safexcel_alg_template safexcel_alg_hmac_sm3;
 extern struct safexcel_alg_template safexcel_alg_ecb_sm4;
 extern struct safexcel_alg_template safexcel_alg_cbc_sm4;
+extern struct safexcel_alg_template safexcel_alg_ofb_sm4;
 
 #endif
diff --git a/drivers/crypto/inside-secure/safexcel_cipher.c b/drivers/crypto/inside-secure/safexcel_cipher.c
index a2e65fd..0a30e7a 100644
--- a/drivers/crypto/inside-secure/safexcel_cipher.c
+++ b/drivers/crypto/inside-secure/safexcel_cipher.c
@@ -2746,3 +2746,39 @@ struct safexcel_alg_template safexcel_alg_cbc_sm4 = {
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

