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
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD281C4CEC5
	for <linux-crypto@archiver.kernel.org>; Fri, 13 Sep 2019 21:07:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B2B7120830
	for <linux-crypto@archiver.kernel.org>; Fri, 13 Sep 2019 21:07:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WMmdIALx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730456AbfIMVHi (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 13 Sep 2019 17:07:38 -0400
Received: from mail-ed1-f65.google.com ([209.85.208.65]:42959 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731020AbfIMVHi (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 13 Sep 2019 17:07:38 -0400
Received: by mail-ed1-f65.google.com with SMTP id y91so28168384ede.9
        for <linux-crypto@vger.kernel.org>; Fri, 13 Sep 2019 14:07:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=T0XJs6xYjnAkAUeCuLXDk/UWl8sRDszfPQJlbQPmYnA=;
        b=WMmdIALx0Rar6Cy806COLsyr+a5g7yOTgWwiq5xKg5c1/bkiIVyZ47xhA8/07UfdZ+
         q8yMPib7LB0ofrboLE98pqke1xD1en1n+0vYNktyzvqr89a00bMKiFnSufxkLOzv+7kw
         tJGSMz2CO57TXUn0nc1YLlqRWsBfR0RGPC74DWv1ApwPYJteL5PP6sJMEH4Auhk2US3l
         DOB4u/YM5et8WKUZCn0p7ihT9fbfx03Zy8l6QvclfWKgJgWnjGVPnk8gwauhwy5+gjX+
         yuEZQkJrqF31WN0QOPDHUF5/HnIRKXFRuCjMiyIwLAr3MGbFRjUB3Seww1GKo347hTrw
         d4jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=T0XJs6xYjnAkAUeCuLXDk/UWl8sRDszfPQJlbQPmYnA=;
        b=XPwDCz3Q4/qD5pUtthnbIRvCVnkSXbSoV3buSo8plRdj+hbK3ZyobcJe2gWr+852hc
         XIz4Aclzi3aYianQR5Ua/AqeDnt4Qw6f/gflnk0L6JebsTUrJmcxTTEvijx2J9Mp62Yz
         zd1lyP6+yX2rw63hnqhMwSVKI768ZETP2fqyGqAOOhul/GIShHB6U5pGi+T9xhTdpc/w
         cJdfZbuZ41lO1bpxR1AiLuGw0r8Dj8h3F3CvJfYvRv49iO961jxiiLKi06zdPYYpU2hI
         28A3Nip+OJ4kHVCoVqfr/ES87vlfK260fQCxFgMpL/6PENHWMCXc1Dwn6rcig2Nm6sDj
         xmhw==
X-Gm-Message-State: APjAAAXO127rzE6BFFZXWhZGDMAblJCkEb0VSgwTT/K2K2e/nnMS74zI
        gKyyFAygXkYnKwCzNCpwGKvgkx+s
X-Google-Smtp-Source: APXvYqyFKuZ4ZgW6q95sIpaEUhegRT1sgXSZRRMOU6DZjsH74Fi0O/dPb8ZiTH+2LEtIHQvW4PrjnA==
X-Received: by 2002:a17:906:d78d:: with SMTP id pj13mr41742605ejb.62.1568408855955;
        Fri, 13 Sep 2019 14:07:35 -0700 (PDT)
Received: from localhost.localdomain.com ([188.204.2.113])
        by smtp.gmail.com with ESMTPSA id e44sm1411296ede.34.2019.09.13.14.07.35
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 13 Sep 2019 14:07:35 -0700 (PDT)
From:   Pascal van Leeuwen <pascalvanl@gmail.com>
X-Google-Original-From: Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
To:     linux-crypto@vger.kernel.org
Cc:     antoine.tenart@bootlin.com, herbert@gondor.apana.org.au,
        davem@davemloft.net,
        Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
Subject: [PATCHv2 1/3] crypto: inside-secure - Added support for authenc HMAC-SHA1/DES-CBC
Date:   Fri, 13 Sep 2019 22:04:44 +0200
Message-Id: <1568405086-7898-2-git-send-email-pvanleeuwen@verimatrix.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1568405086-7898-1-git-send-email-pvanleeuwen@verimatrix.com>
References: <1568405086-7898-1-git-send-email-pvanleeuwen@verimatrix.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This patch adds support for the authenc(hmac(sha1),cbc(des)) aead

changes since v1:
- rebased on top of DES changes made to cryptodev/master

Signed-off-by: Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
---
 drivers/crypto/inside-secure/safexcel.c        |  1 +
 drivers/crypto/inside-secure/safexcel.h        |  1 +
 drivers/crypto/inside-secure/safexcel_cipher.c | 39 ++++++++++++++++++++++++++
 3 files changed, 41 insertions(+)

diff --git a/drivers/crypto/inside-secure/safexcel.c b/drivers/crypto/inside-secure/safexcel.c
index c8157f2..462dbf6 100644
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
index 275f8b5..fe00b87 100644
--- a/drivers/crypto/inside-secure/safexcel.h
+++ b/drivers/crypto/inside-secure/safexcel.h
@@ -901,5 +901,6 @@ int safexcel_hmac_setkey(const char *alg, const u8 *key, unsigned int keylen,
 extern struct safexcel_alg_template safexcel_alg_hmac_sha3_256;
 extern struct safexcel_alg_template safexcel_alg_hmac_sha3_384;
 extern struct safexcel_alg_template safexcel_alg_hmac_sha3_512;
+extern struct safexcel_alg_template safexcel_alg_authenc_hmac_sha1_cbc_des;
 
 #endif
diff --git a/drivers/crypto/inside-secure/safexcel_cipher.c b/drivers/crypto/inside-secure/safexcel_cipher.c
index 616c214..91cab26 100644
--- a/drivers/crypto/inside-secure/safexcel_cipher.c
+++ b/drivers/crypto/inside-secure/safexcel_cipher.c
@@ -366,6 +366,11 @@ static int safexcel_aead_setkey(struct crypto_aead *ctfm, const u8 *key,
 
 	/* Encryption key */
 	switch (ctx->alg) {
+	case SAFEXCEL_DES:
+		err = verify_aead_des_key(ctfm, keys.enckey, keys.enckeylen);
+		if (unlikely(err))
+			goto badkey_expflags;
+		break;
 	case SAFEXCEL_3DES:
 		err = verify_aead_des3_key(ctfm, keys.enckey, keys.enckeylen);
 		if (unlikely(err))
@@ -1841,6 +1846,40 @@ struct safexcel_alg_template safexcel_alg_authenc_hmac_sha1_cbc_des3_ede = {
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

