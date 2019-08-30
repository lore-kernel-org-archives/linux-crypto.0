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
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7024C3A5A7
	for <linux-crypto@archiver.kernel.org>; Fri, 30 Aug 2019 08:43:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 68924238C7
	for <linux-crypto@archiver.kernel.org>; Fri, 30 Aug 2019 08:43:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="oVF7QOv4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728596AbfH3Inp (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 30 Aug 2019 04:43:45 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:36430 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727739AbfH3Ino (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 30 Aug 2019 04:43:44 -0400
Received: by mail-ed1-f67.google.com with SMTP id g24so7148877edu.3
        for <linux-crypto@vger.kernel.org>; Fri, 30 Aug 2019 01:43:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=K057mmt9wd5BB/IrQHd8zA9LYDifKSgk3TRaoD2oHm8=;
        b=oVF7QOv4um34NhSRfO0VklDUFIMwl6dYb4v57FGIqoa1BvBAkyTpiMGhbONjTWpLyP
         mWt0/cS3PVGrx3XpGc8g4wAgYAt5TPZeQQloZ+5BLbPR4eFooEaAI8YGD7fxlotqPb6z
         bnrQG4eZAUn9gJv5VH5D2gXUdJcmnOLW0ksRbk8bQbAEJSmEaWRK+r5jJ209ZWG2w6Xv
         tAKiT6O9E+EnnBj0aPtLmYHBtx2wki5KWHP2L3/TIH2BQBZmpzqGn+8mv4TPfFeO+ihY
         ZILXQJftgRFo4HPkTzr0DhBqXTD969lCj8zHspX3rEgrvpGmFq8vX5ApceBiOV9ot6vB
         2xuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=K057mmt9wd5BB/IrQHd8zA9LYDifKSgk3TRaoD2oHm8=;
        b=fkhs7Mi7tLRLxk1EOtVh50gGkmr8Gd/n43C105zAbjwvBZcXZSZwEFn26jNm+6HGNA
         zbaXn9ltTlgd9/L+h7PmsJHgesKr1iF91Ac2by71R/GV79OdCjUEyldURWsAFyUyqVx8
         Fib1hHUkJF8GFW+inz0+wEODOJuOWVYmxBsH2Q2M7z/iQ0Wg0NibbY1cwRnuER4188j5
         lunmvmEtGu/tf8dfhwa7y7+go1GE92cqrFwD/H0t9ilN2Z9ysLqPigP/ZqpGEh2w1Qj8
         zflS3iFk8Kxuoz4y0obPcZmA5gBmjsVacNSRSYnpOzYseu83qNKQxjg9MMEeBYjmfhTr
         2IXw==
X-Gm-Message-State: APjAAAVM82QK+Rw35pKujj9Of/iJqHlqiLmKoIunjFajUV7EbxU8D55h
        Xh//fRYznLZWDSOcYQWg9iP7u+nV
X-Google-Smtp-Source: APXvYqz8vJOxkr6Ge/jHXNShCsKNrWxgEfoldgdyJqec933+ikp8rNaf0k2YkEhe44BhkGwgVmbZ+Q==
X-Received: by 2002:a17:906:4890:: with SMTP id v16mr12138817ejq.296.1567154621758;
        Fri, 30 Aug 2019 01:43:41 -0700 (PDT)
Received: from localhost.localdomain.com ([188.204.2.113])
        by smtp.gmail.com with ESMTPSA id x11sm705823eju.26.2019.08.30.01.43.41
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 30 Aug 2019 01:43:41 -0700 (PDT)
From:   Pascal van Leeuwen <pascalvanl@gmail.com>
X-Google-Original-From: Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
To:     linux-crypto@vger.kernel.org
Cc:     antoine.tenart@bootlin.com, herbert@gondor.apana.org.au,
        davem@davemloft.net,
        Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
Subject: [PATCH 3/3] crypto: inside-secure - Only enable algorithms advertised by the hardware
Date:   Fri, 30 Aug 2019 09:40:54 +0200
Message-Id: <1567150854-10589-4-git-send-email-pvanleeuwen@verimatrix.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1567150854-10589-1-git-send-email-pvanleeuwen@verimatrix.com>
References: <1567150854-10589-1-git-send-email-pvanleeuwen@verimatrix.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This patch probes the supported algorithms from the hardware and only
registers the ones that the hardware actually supports. This is necessary
because this is a generic driver supposed to run on a wide variety of
engines, which may or may not implement certain algorithms.

Signed-off-by: Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
---
 drivers/crypto/inside-secure/safexcel.c        | 36 ++++++++++++++++++++++++--
 drivers/crypto/inside-secure/safexcel.h        | 33 +++++++++++++++++++++++
 drivers/crypto/inside-secure/safexcel_cipher.c | 19 ++++++++++++++
 drivers/crypto/inside-secure/safexcel_hash.c   | 12 +++++++++
 4 files changed, 98 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/inside-secure/safexcel.c b/drivers/crypto/inside-secure/safexcel.c
index 9941861..25285d6 100644
--- a/drivers/crypto/inside-secure/safexcel.c
+++ b/drivers/crypto/inside-secure/safexcel.c
@@ -284,7 +284,7 @@ static int eip197_load_firmwares(struct safexcel_crypto_priv *priv)
 	ipuesz = eip197_write_firmware(priv, fw[FW_IPUE]);
 
 	if (eip197_start_firmware(priv, ipuesz, ifppsz, minifw)) {
-		dev_dbg(priv->dev, "Firmware loaded successfully");
+		dev_dbg(priv->dev, "Firmware loaded successfully\n");
 		return 0;
 	}
 
@@ -1014,6 +1014,12 @@ static int safexcel_register_algorithms(struct safexcel_crypto_priv *priv)
 	for (i = 0; i < ARRAY_SIZE(safexcel_algs); i++) {
 		safexcel_algs[i]->priv = priv;
 
+		/* Do we have all required base algorithms available? */
+		if ((safexcel_algs[i]->algo_mask & priv->hwconfig.algo_flags) !=
+		    safexcel_algs[i]->algo_mask)
+			/* No, so don't register this ciphersuite */
+			continue;
+
 		if (safexcel_algs[i]->type == SAFEXCEL_ALG_TYPE_SKCIPHER)
 			ret = crypto_register_skcipher(&safexcel_algs[i]->alg.skcipher);
 		else if (safexcel_algs[i]->type == SAFEXCEL_ALG_TYPE_AEAD)
@@ -1029,6 +1035,12 @@ static int safexcel_register_algorithms(struct safexcel_crypto_priv *priv)
 
 fail:
 	for (j = 0; j < i; j++) {
+		/* Do we have all required base algorithms available? */
+		if ((safexcel_algs[j]->algo_mask & priv->hwconfig.algo_flags) !=
+		    safexcel_algs[j]->algo_mask)
+			/* No, so don't unregister this ciphersuite */
+			continue;
+
 		if (safexcel_algs[j]->type == SAFEXCEL_ALG_TYPE_SKCIPHER)
 			crypto_unregister_skcipher(&safexcel_algs[j]->alg.skcipher);
 		else if (safexcel_algs[j]->type == SAFEXCEL_ALG_TYPE_AEAD)
@@ -1045,6 +1057,12 @@ static void safexcel_unregister_algorithms(struct safexcel_crypto_priv *priv)
 	int i;
 
 	for (i = 0; i < ARRAY_SIZE(safexcel_algs); i++) {
+		/* Do we have all required base algorithms available? */
+		if ((safexcel_algs[i]->algo_mask & priv->hwconfig.algo_flags) !=
+		    safexcel_algs[i]->algo_mask)
+			/* No, so don't unregister this ciphersuite */
+			continue;
+
 		if (safexcel_algs[i]->type == SAFEXCEL_ALG_TYPE_SKCIPHER)
 			crypto_unregister_skcipher(&safexcel_algs[i]->alg.skcipher);
 		else if (safexcel_algs[i]->type == SAFEXCEL_ALG_TYPE_AEAD)
@@ -1123,6 +1141,7 @@ static int safexcel_probe_generic(void *pdev,
 				  int is_pci_dev)
 {
 	struct device *dev = priv->dev;
+	u32 peid;
 	int i, ret;
 
 	priv->context_pool = dmam_pool_create("safexcel-context", dev,
@@ -1133,8 +1152,21 @@ static int safexcel_probe_generic(void *pdev,
 
 	safexcel_init_register_offsets(priv);
 
-	if (priv->version != EIP97IES_MRVL)
+	/* Get supported algorithms from EIP96 transform engine */
+	priv->hwconfig.algo_flags = readl(EIP197_PE(priv) +
+				    EIP197_PE_EIP96_OPTIONS(0));
+
+	if (priv->version == EIP97IES_MRVL) {
+		peid = 97;
+	} else {
 		priv->flags |= EIP197_TRC_CACHE;
+		peid = 197;
+	}
+
+	/* Dump some debug information important during development */
+	dev_dbg(priv->dev, "Inside Secure EIP%d packetengine\n", peid);
+	dev_dbg(priv->dev, "Supported algorithms: %08x\n",
+			   priv->hwconfig.algo_flags);
 
 	safexcel_configure(priv);
 
diff --git a/drivers/crypto/inside-secure/safexcel.h b/drivers/crypto/inside-secure/safexcel.h
index 0a30a7b..b5ff62f 100644
--- a/drivers/crypto/inside-secure/safexcel.h
+++ b/drivers/crypto/inside-secure/safexcel.h
@@ -145,6 +145,7 @@
 #define EIP197_PE_EIP96_FUNCTION_EN(n)		(0x1004 + (0x2000 * (n)))
 #define EIP197_PE_EIP96_CONTEXT_CTRL(n)		(0x1008 + (0x2000 * (n)))
 #define EIP197_PE_EIP96_CONTEXT_STAT(n)		(0x100c + (0x2000 * (n)))
+#define EIP197_PE_EIP96_OPTIONS(n)		(0x13f8 + (0x2000 * (n)))
 #define EIP197_PE_OUT_DBUF_THRES(n)		(0x1c00 + (0x2000 * (n)))
 #define EIP197_PE_OUT_TBUF_THRES(n)		(0x1d00 + (0x2000 * (n)))
 #define EIP197_MST_CTRL				0xfff4
@@ -597,6 +598,32 @@ enum safexcel_eip_version {
 	EIP197_DEVBRD
 };
 
+/* EIP algorithm presence flags */
+enum safexcel_eip_algorithms {
+	SAFEXCEL_ALG_BC0      = BIT(5),
+	SAFEXCEL_ALG_SM4      = BIT(6),
+	SAFEXCEL_ALG_SM3      = BIT(7),
+	SAFEXCEL_ALG_CHACHA20 = BIT(8),
+	SAFEXCEL_ALG_POLY1305 = BIT(9),
+	SAFEXCEL_SEQMASK_256   = BIT(10),
+	SAFEXCEL_SEQMASK_384   = BIT(11),
+	SAFEXCEL_ALG_AES      = BIT(12),
+	SAFEXCEL_ALG_AES_XFB  = BIT(13),
+	SAFEXCEL_ALG_DES      = BIT(15),
+	SAFEXCEL_ALG_DES_XFB  = BIT(16),
+	SAFEXCEL_ALG_ARC4     = BIT(18),
+	SAFEXCEL_ALG_AES_XTS  = BIT(20),
+	SAFEXCEL_ALG_WIRELESS = BIT(21),
+	SAFEXCEL_ALG_MD5      = BIT(22),
+	SAFEXCEL_ALG_SHA1     = BIT(23),
+	SAFEXCEL_ALG_SHA2_256 = BIT(25),
+	SAFEXCEL_ALG_SHA2_512 = BIT(26),
+	SAFEXCEL_ALG_XCBC_MAC = BIT(27),
+	SAFEXCEL_ALG_CBC_MAC_ALL = BIT(29),
+	SAFEXCEL_ALG_GHASH    = BIT(30),
+	SAFEXCEL_ALG_SHA3     = BIT(31),
+};
+
 struct safexcel_register_offsets {
 	u32 hia_aic;
 	u32 hia_aic_g;
@@ -614,6 +641,10 @@ enum safexcel_flags {
 	EIP197_TRC_CACHE = BIT(0),
 };
 
+struct safexcel_hwconfig {
+	enum safexcel_eip_algorithms algo_flags;
+};
+
 struct safexcel_crypto_priv {
 	void __iomem *base;
 	struct device *dev;
@@ -623,6 +654,7 @@ struct safexcel_crypto_priv {
 
 	enum safexcel_eip_version version;
 	struct safexcel_register_offsets offsets;
+	struct safexcel_hwconfig hwconfig;
 	u32 flags;
 
 	/* context DMA pool */
@@ -667,6 +699,7 @@ struct safexcel_ahash_export_state {
 struct safexcel_alg_template {
 	struct safexcel_crypto_priv *priv;
 	enum safexcel_alg_type type;
+	enum safexcel_eip_algorithms algo_mask;
 	union {
 		struct skcipher_alg skcipher;
 		struct aead_alg aead;
diff --git a/drivers/crypto/inside-secure/safexcel_cipher.c b/drivers/crypto/inside-secure/safexcel_cipher.c
index 5ab0ee0..2bf75ea 100644
--- a/drivers/crypto/inside-secure/safexcel_cipher.c
+++ b/drivers/crypto/inside-secure/safexcel_cipher.c
@@ -1040,6 +1040,7 @@ static int safexcel_skcipher_aes_ecb_cra_init(struct crypto_tfm *tfm)
 
 struct safexcel_alg_template safexcel_alg_ecb_aes = {
 	.type = SAFEXCEL_ALG_TYPE_SKCIPHER,
+	.algo_mask = SAFEXCEL_ALG_AES,
 	.alg.skcipher = {
 		.setkey = safexcel_skcipher_aes_setkey,
 		.encrypt = safexcel_encrypt,
@@ -1074,6 +1075,7 @@ static int safexcel_skcipher_aes_cbc_cra_init(struct crypto_tfm *tfm)
 
 struct safexcel_alg_template safexcel_alg_cbc_aes = {
 	.type = SAFEXCEL_ALG_TYPE_SKCIPHER,
+	.algo_mask = SAFEXCEL_ALG_AES,
 	.alg.skcipher = {
 		.setkey = safexcel_skcipher_aes_setkey,
 		.encrypt = safexcel_encrypt,
@@ -1147,6 +1149,7 @@ static int safexcel_skcipher_aes_ctr_cra_init(struct crypto_tfm *tfm)
 
 struct safexcel_alg_template safexcel_alg_ctr_aes = {
 	.type = SAFEXCEL_ALG_TYPE_SKCIPHER,
+	.algo_mask = SAFEXCEL_ALG_AES,
 	.alg.skcipher = {
 		.setkey = safexcel_skcipher_aesctr_setkey,
 		.encrypt = safexcel_encrypt,
@@ -1208,6 +1211,7 @@ static int safexcel_skcipher_des_cbc_cra_init(struct crypto_tfm *tfm)
 
 struct safexcel_alg_template safexcel_alg_cbc_des = {
 	.type = SAFEXCEL_ALG_TYPE_SKCIPHER,
+	.algo_mask = SAFEXCEL_ALG_DES,
 	.alg.skcipher = {
 		.setkey = safexcel_des_setkey,
 		.encrypt = safexcel_encrypt,
@@ -1243,6 +1247,7 @@ static int safexcel_skcipher_des_ecb_cra_init(struct crypto_tfm *tfm)
 
 struct safexcel_alg_template safexcel_alg_ecb_des = {
 	.type = SAFEXCEL_ALG_TYPE_SKCIPHER,
+	.algo_mask = SAFEXCEL_ALG_DES,
 	.alg.skcipher = {
 		.setkey = safexcel_des_setkey,
 		.encrypt = safexcel_encrypt,
@@ -1300,6 +1305,7 @@ static int safexcel_skcipher_des3_cbc_cra_init(struct crypto_tfm *tfm)
 
 struct safexcel_alg_template safexcel_alg_cbc_des3_ede = {
 	.type = SAFEXCEL_ALG_TYPE_SKCIPHER,
+	.algo_mask = SAFEXCEL_ALG_DES,
 	.alg.skcipher = {
 		.setkey = safexcel_des3_ede_setkey,
 		.encrypt = safexcel_encrypt,
@@ -1335,6 +1341,7 @@ static int safexcel_skcipher_des3_ecb_cra_init(struct crypto_tfm *tfm)
 
 struct safexcel_alg_template safexcel_alg_ecb_des3_ede = {
 	.type = SAFEXCEL_ALG_TYPE_SKCIPHER,
+	.algo_mask = SAFEXCEL_ALG_DES,
 	.alg.skcipher = {
 		.setkey = safexcel_des3_ede_setkey,
 		.encrypt = safexcel_encrypt,
@@ -1403,6 +1410,7 @@ static int safexcel_aead_sha1_cra_init(struct crypto_tfm *tfm)
 
 struct safexcel_alg_template safexcel_alg_authenc_hmac_sha1_cbc_aes = {
 	.type = SAFEXCEL_ALG_TYPE_AEAD,
+	.algo_mask = SAFEXCEL_ALG_AES | SAFEXCEL_ALG_SHA1,
 	.alg.aead = {
 		.setkey = safexcel_aead_setkey,
 		.encrypt = safexcel_aead_encrypt,
@@ -1437,6 +1445,7 @@ static int safexcel_aead_sha256_cra_init(struct crypto_tfm *tfm)
 
 struct safexcel_alg_template safexcel_alg_authenc_hmac_sha256_cbc_aes = {
 	.type = SAFEXCEL_ALG_TYPE_AEAD,
+	.algo_mask = SAFEXCEL_ALG_AES | SAFEXCEL_ALG_SHA2_256,
 	.alg.aead = {
 		.setkey = safexcel_aead_setkey,
 		.encrypt = safexcel_aead_encrypt,
@@ -1471,6 +1480,7 @@ static int safexcel_aead_sha224_cra_init(struct crypto_tfm *tfm)
 
 struct safexcel_alg_template safexcel_alg_authenc_hmac_sha224_cbc_aes = {
 	.type = SAFEXCEL_ALG_TYPE_AEAD,
+	.algo_mask = SAFEXCEL_ALG_AES | SAFEXCEL_ALG_SHA2_256,
 	.alg.aead = {
 		.setkey = safexcel_aead_setkey,
 		.encrypt = safexcel_aead_encrypt,
@@ -1505,6 +1515,7 @@ static int safexcel_aead_sha512_cra_init(struct crypto_tfm *tfm)
 
 struct safexcel_alg_template safexcel_alg_authenc_hmac_sha512_cbc_aes = {
 	.type = SAFEXCEL_ALG_TYPE_AEAD,
+	.algo_mask = SAFEXCEL_ALG_AES | SAFEXCEL_ALG_SHA2_512,
 	.alg.aead = {
 		.setkey = safexcel_aead_setkey,
 		.encrypt = safexcel_aead_encrypt,
@@ -1539,6 +1550,7 @@ static int safexcel_aead_sha384_cra_init(struct crypto_tfm *tfm)
 
 struct safexcel_alg_template safexcel_alg_authenc_hmac_sha384_cbc_aes = {
 	.type = SAFEXCEL_ALG_TYPE_AEAD,
+	.algo_mask = SAFEXCEL_ALG_AES | SAFEXCEL_ALG_SHA2_512,
 	.alg.aead = {
 		.setkey = safexcel_aead_setkey,
 		.encrypt = safexcel_aead_encrypt,
@@ -1572,6 +1584,7 @@ static int safexcel_aead_sha1_des3_cra_init(struct crypto_tfm *tfm)
 
 struct safexcel_alg_template safexcel_alg_authenc_hmac_sha1_cbc_des3_ede = {
 	.type = SAFEXCEL_ALG_TYPE_AEAD,
+	.algo_mask = SAFEXCEL_ALG_DES | SAFEXCEL_ALG_SHA1,
 	.alg.aead = {
 		.setkey = safexcel_aead_setkey,
 		.encrypt = safexcel_aead_encrypt,
@@ -1605,6 +1618,7 @@ static int safexcel_aead_sha1_ctr_cra_init(struct crypto_tfm *tfm)
 
 struct safexcel_alg_template safexcel_alg_authenc_hmac_sha1_ctr_aes = {
 	.type = SAFEXCEL_ALG_TYPE_AEAD,
+	.algo_mask = SAFEXCEL_ALG_AES | SAFEXCEL_ALG_SHA1,
 	.alg.aead = {
 		.setkey = safexcel_aead_setkey,
 		.encrypt = safexcel_aead_encrypt,
@@ -1638,6 +1652,7 @@ static int safexcel_aead_sha256_ctr_cra_init(struct crypto_tfm *tfm)
 
 struct safexcel_alg_template safexcel_alg_authenc_hmac_sha256_ctr_aes = {
 	.type = SAFEXCEL_ALG_TYPE_AEAD,
+	.algo_mask = SAFEXCEL_ALG_AES | SAFEXCEL_ALG_SHA2_256,
 	.alg.aead = {
 		.setkey = safexcel_aead_setkey,
 		.encrypt = safexcel_aead_encrypt,
@@ -1671,6 +1686,7 @@ static int safexcel_aead_sha224_ctr_cra_init(struct crypto_tfm *tfm)
 
 struct safexcel_alg_template safexcel_alg_authenc_hmac_sha224_ctr_aes = {
 	.type = SAFEXCEL_ALG_TYPE_AEAD,
+	.algo_mask = SAFEXCEL_ALG_AES | SAFEXCEL_ALG_SHA2_256,
 	.alg.aead = {
 		.setkey = safexcel_aead_setkey,
 		.encrypt = safexcel_aead_encrypt,
@@ -1704,6 +1720,7 @@ static int safexcel_aead_sha512_ctr_cra_init(struct crypto_tfm *tfm)
 
 struct safexcel_alg_template safexcel_alg_authenc_hmac_sha512_ctr_aes = {
 	.type = SAFEXCEL_ALG_TYPE_AEAD,
+	.algo_mask = SAFEXCEL_ALG_AES | SAFEXCEL_ALG_SHA2_512,
 	.alg.aead = {
 		.setkey = safexcel_aead_setkey,
 		.encrypt = safexcel_aead_encrypt,
@@ -1737,6 +1754,7 @@ static int safexcel_aead_sha384_ctr_cra_init(struct crypto_tfm *tfm)
 
 struct safexcel_alg_template safexcel_alg_authenc_hmac_sha384_ctr_aes = {
 	.type = SAFEXCEL_ALG_TYPE_AEAD,
+	.algo_mask = SAFEXCEL_ALG_AES | SAFEXCEL_ALG_SHA2_512,
 	.alg.aead = {
 		.setkey = safexcel_aead_setkey,
 		.encrypt = safexcel_aead_encrypt,
@@ -1850,6 +1868,7 @@ static int safexcel_decrypt_xts(struct skcipher_request *req)
 
 struct safexcel_alg_template safexcel_alg_xts_aes = {
 	.type = SAFEXCEL_ALG_TYPE_SKCIPHER,
+	.algo_mask = SAFEXCEL_ALG_AES | SAFEXCEL_ALG_AES_XTS,
 	.alg.skcipher = {
 		.setkey = safexcel_skcipher_aesxts_setkey,
 		.encrypt = safexcel_encrypt_xts,
diff --git a/drivers/crypto/inside-secure/safexcel_hash.c b/drivers/crypto/inside-secure/safexcel_hash.c
index 626dd82..e60838f 100644
--- a/drivers/crypto/inside-secure/safexcel_hash.c
+++ b/drivers/crypto/inside-secure/safexcel_hash.c
@@ -845,6 +845,7 @@ static void safexcel_ahash_cra_exit(struct crypto_tfm *tfm)
 
 struct safexcel_alg_template safexcel_alg_sha1 = {
 	.type = SAFEXCEL_ALG_TYPE_AHASH,
+	.algo_mask = SAFEXCEL_ALG_SHA1,
 	.alg.ahash = {
 		.init = safexcel_sha1_init,
 		.update = safexcel_ahash_update,
@@ -1085,6 +1086,7 @@ static int safexcel_hmac_sha1_setkey(struct crypto_ahash *tfm, const u8 *key,
 
 struct safexcel_alg_template safexcel_alg_hmac_sha1 = {
 	.type = SAFEXCEL_ALG_TYPE_AHASH,
+	.algo_mask = SAFEXCEL_ALG_SHA1,
 	.alg.ahash = {
 		.init = safexcel_hmac_sha1_init,
 		.update = safexcel_ahash_update,
@@ -1140,6 +1142,7 @@ static int safexcel_sha256_digest(struct ahash_request *areq)
 
 struct safexcel_alg_template safexcel_alg_sha256 = {
 	.type = SAFEXCEL_ALG_TYPE_AHASH,
+	.algo_mask = SAFEXCEL_ALG_SHA2_256,
 	.alg.ahash = {
 		.init = safexcel_sha256_init,
 		.update = safexcel_ahash_update,
@@ -1194,6 +1197,7 @@ static int safexcel_sha224_digest(struct ahash_request *areq)
 
 struct safexcel_alg_template safexcel_alg_sha224 = {
 	.type = SAFEXCEL_ALG_TYPE_AHASH,
+	.algo_mask = SAFEXCEL_ALG_SHA2_256,
 	.alg.ahash = {
 		.init = safexcel_sha224_init,
 		.update = safexcel_ahash_update,
@@ -1262,6 +1266,7 @@ static int safexcel_hmac_sha224_digest(struct ahash_request *areq)
 
 struct safexcel_alg_template safexcel_alg_hmac_sha224 = {
 	.type = SAFEXCEL_ALG_TYPE_AHASH,
+	.algo_mask = SAFEXCEL_ALG_SHA2_256,
 	.alg.ahash = {
 		.init = safexcel_hmac_sha224_init,
 		.update = safexcel_ahash_update,
@@ -1331,6 +1336,7 @@ static int safexcel_hmac_sha256_digest(struct ahash_request *areq)
 
 struct safexcel_alg_template safexcel_alg_hmac_sha256 = {
 	.type = SAFEXCEL_ALG_TYPE_AHASH,
+	.algo_mask = SAFEXCEL_ALG_SHA2_256,
 	.alg.ahash = {
 		.init = safexcel_hmac_sha256_init,
 		.update = safexcel_ahash_update,
@@ -1386,6 +1392,7 @@ static int safexcel_sha512_digest(struct ahash_request *areq)
 
 struct safexcel_alg_template safexcel_alg_sha512 = {
 	.type = SAFEXCEL_ALG_TYPE_AHASH,
+	.algo_mask = SAFEXCEL_ALG_SHA2_512,
 	.alg.ahash = {
 		.init = safexcel_sha512_init,
 		.update = safexcel_ahash_update,
@@ -1440,6 +1447,7 @@ static int safexcel_sha384_digest(struct ahash_request *areq)
 
 struct safexcel_alg_template safexcel_alg_sha384 = {
 	.type = SAFEXCEL_ALG_TYPE_AHASH,
+	.algo_mask = SAFEXCEL_ALG_SHA2_512,
 	.alg.ahash = {
 		.init = safexcel_sha384_init,
 		.update = safexcel_ahash_update,
@@ -1508,6 +1516,7 @@ static int safexcel_hmac_sha512_digest(struct ahash_request *areq)
 
 struct safexcel_alg_template safexcel_alg_hmac_sha512 = {
 	.type = SAFEXCEL_ALG_TYPE_AHASH,
+	.algo_mask = SAFEXCEL_ALG_SHA2_512,
 	.alg.ahash = {
 		.init = safexcel_hmac_sha512_init,
 		.update = safexcel_ahash_update,
@@ -1577,6 +1586,7 @@ static int safexcel_hmac_sha384_digest(struct ahash_request *areq)
 
 struct safexcel_alg_template safexcel_alg_hmac_sha384 = {
 	.type = SAFEXCEL_ALG_TYPE_AHASH,
+	.algo_mask = SAFEXCEL_ALG_SHA2_512,
 	.alg.ahash = {
 		.init = safexcel_hmac_sha384_init,
 		.update = safexcel_ahash_update,
@@ -1632,6 +1642,7 @@ static int safexcel_md5_digest(struct ahash_request *areq)
 
 struct safexcel_alg_template safexcel_alg_md5 = {
 	.type = SAFEXCEL_ALG_TYPE_AHASH,
+	.algo_mask = SAFEXCEL_ALG_MD5,
 	.alg.ahash = {
 		.init = safexcel_md5_init,
 		.update = safexcel_ahash_update,
@@ -1701,6 +1712,7 @@ static int safexcel_hmac_md5_digest(struct ahash_request *areq)
 
 struct safexcel_alg_template safexcel_alg_hmac_md5 = {
 	.type = SAFEXCEL_ALG_TYPE_AHASH,
+	.algo_mask = SAFEXCEL_ALG_MD5,
 	.alg.ahash = {
 		.init = safexcel_hmac_md5_init,
 		.update = safexcel_ahash_update,
-- 
1.8.3.1

