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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0CBCAECDE20
	for <linux-crypto@archiver.kernel.org>; Wed, 11 Sep 2019 11:41:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D69282081B
	for <linux-crypto@archiver.kernel.org>; Wed, 11 Sep 2019 11:41:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="S+w/yNpp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727740AbfIKLlO (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 11 Sep 2019 07:41:14 -0400
Received: from mail-ed1-f51.google.com ([209.85.208.51]:33799 "EHLO
        mail-ed1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727745AbfIKLlO (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 11 Sep 2019 07:41:14 -0400
Received: by mail-ed1-f51.google.com with SMTP id c20so11316080eds.1
        for <linux-crypto@vger.kernel.org>; Wed, 11 Sep 2019 04:41:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=ulbi2R+ZAw3wpW+xEZ5EPih00BeH2OA8SyaWTPW8uyk=;
        b=S+w/yNppjRaNnV1OdcxsgYoGKtfGLWET9DFblphXF6mFdiRrXqGXJKfVp9PWdLQFu0
         ClCm0VjqjnGcuRqpuf430u5GmRCt7H7PAQw/CpMWMjMqz64HIjzTQywz0+wZiu/8Q3Kv
         NydFtVFdp6TDIz/0rcexLhoNS1JjrCKQPvrvxg5f5Nn0Wj1d6rmjbNtiBrXmonXpmtAR
         FD6Q/k01o8ZZvwwNdZBl/ZoOAJqRc96gRiJq5/DcuSJd8qbiV9SiN+68YCwAAlINcv/z
         gENLfIU5sUmac6Oe68CGmbwJicugy9ii+8bqCiqmd1foqWXmf/TCJbpWDFwdDv6wGhEL
         zkuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=ulbi2R+ZAw3wpW+xEZ5EPih00BeH2OA8SyaWTPW8uyk=;
        b=Yjc/wlTwmRPUpeUp82Pz+YgVi7t26w6WYZIiuGZnXNB36bIHcEjdW0DZ/QAkD0EwKb
         K5DOq+yvbXUKfpxvAapaBwMEqimuqsMpk5FKdEMO70mXSSzut+0McIHuGgua/0rVLe8I
         qq+UEqItyHcPFacsdhx13jgu04ONeWTLVR5OLv3t0HfNpQSnxYJUVQD6BRNLHltxzvgf
         DGmm1+IwvNLcvRdZUByD4UqPa5DyvBKLa5MlmoQm1oDpiVVP9Jd7JWdrBBfThm7oUJze
         qygmbeNUMoif0t+x3Vu2lKxYuApl45YvnfImeqHk/dUcsG7G6IX3smEaqDkWpQAIAM6o
         noZg==
X-Gm-Message-State: APjAAAVwUZJmgC7lRy4/S+3X0n23IA9jt60ObQ5c+LWoGaSRFVZKo8ee
        HZ7GrQsDt2BES8WsdF4Qk7dznpFF
X-Google-Smtp-Source: APXvYqyURXlrggL4x3kaTYS8E80PlpxSl0Ipll5u9DolM34U8ZcYKV37z247J8Vn32L58698TmGPeg==
X-Received: by 2002:a17:906:308a:: with SMTP id 10mr25880532ejv.277.1568202072682;
        Wed, 11 Sep 2019 04:41:12 -0700 (PDT)
Received: from localhost.localdomain.com ([188.204.2.113])
        by smtp.gmail.com with ESMTPSA id z6sm2448022ejo.26.2019.09.11.04.41.11
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 11 Sep 2019 04:41:12 -0700 (PDT)
From:   Pascal van Leeuwen <pascalvanl@gmail.com>
X-Google-Original-From: Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
To:     linux-crypto@vger.kernel.org
Cc:     antoine.tenart@bootlin.com, herbert@gondor.apana.org.au,
        davem@davemloft.net,
        Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
Subject: [PATCH 2/7] crypto: inside-secure - Add support for the cbc(sm4) skcipher
Date:   Wed, 11 Sep 2019 12:38:19 +0200
Message-Id: <1568198304-8101-3-git-send-email-pvanleeuwen@verimatrix.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1568198304-8101-1-git-send-email-pvanleeuwen@verimatrix.com>
References: <1568198304-8101-1-git-send-email-pvanleeuwen@verimatrix.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This patch adds support for SM4 in CBC mode, i.e. skcipher cbc(sm4).

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
index 970b5cd..1339f0e 100644
--- a/drivers/crypto/inside-secure/safexcel.h
+++ b/drivers/crypto/inside-secure/safexcel.h
@@ -874,5 +874,6 @@ int safexcel_hmac_setkey(const char *alg, const u8 *key, unsigned int keylen,
 extern struct safexcel_alg_template safexcel_alg_sm3;
 extern struct safexcel_alg_template safexcel_alg_hmac_sm3;
 extern struct safexcel_alg_template safexcel_alg_ecb_sm4;
+extern struct safexcel_alg_template safexcel_alg_cbc_sm4;
 
 #endif
diff --git a/drivers/crypto/inside-secure/safexcel_cipher.c b/drivers/crypto/inside-secure/safexcel_cipher.c
index fc75f2f..a2e65fd 100644
--- a/drivers/crypto/inside-secure/safexcel_cipher.c
+++ b/drivers/crypto/inside-secure/safexcel_cipher.c
@@ -2710,3 +2710,39 @@ struct safexcel_alg_template safexcel_alg_ecb_sm4 = {
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

