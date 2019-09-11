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
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7922C49ED6
	for <linux-crypto@archiver.kernel.org>; Wed, 11 Sep 2019 11:41:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 902C82084D
	for <linux-crypto@archiver.kernel.org>; Wed, 11 Sep 2019 11:41:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VrhOiXqM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727745AbfIKLlR (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 11 Sep 2019 07:41:17 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:34611 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727749AbfIKLlQ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 11 Sep 2019 07:41:16 -0400
Received: by mail-ed1-f68.google.com with SMTP id c20so11316175eds.1
        for <linux-crypto@vger.kernel.org>; Wed, 11 Sep 2019 04:41:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Y0Lk4o11XplOQxZQof1l1napulxeDQKiKC8CZ4zYa5c=;
        b=VrhOiXqMwxtSl1F9nCnDGAleKXI6qHJaqVVBMGr+7mPoC6zOSoljyZib8XjG49EP2e
         QYTuLTUWXIO82yQyo+hKC4nSoUobjvtz9KY6FVUZWdBeWmbPUs82G4dxJX8tkTV/N8xG
         d4t7PpMtyi3Lx+MrouNjP7NeaH9iCuzw2LIv2KxmhntPgMk6lCUoWA5CMiQ1L8BMJtvK
         o3czjZtJWblPQBmuCjH7qGODS74Mtw881VLnbLutt3iGs1ou12KqQvaYajFDnsiW1qxF
         Js84SoMfdyBW8ccURhLNU98Y3IpP/2JcRDQNbgKKLgWcooWuUS0de0pwlBHK7Rxw8TIA
         ArWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Y0Lk4o11XplOQxZQof1l1napulxeDQKiKC8CZ4zYa5c=;
        b=Wu/ZX0BAZOks38UHrHRQWVoRk4YcxXqZRJgGDgntPZlRd2R4nbmH/s0Z8dqMs0x33L
         LO0JZMSfd7lrTv9QL3POyRUAUmbwQYn27et3AeyAvjWMxKzD9yZfV+BFLsHj/hIyw0Or
         N9T7wJ5EIJ82kgq8xW2DWJTYpHOl6SpHjQdN9AoXNrDjhFrRkUlksiU1WayxMmfXhc+6
         9cqdQ589zFYKYBtb4s1755SXE5fhtWnraltoJezL5HYMhg0/lOkxc7V/pV3K1GB7b9ha
         +do78NGJUhe22V/668m9a/c6ab69KNITtMk6BsE3KX/JISp6UKxobyVgnaK/HdkQBpVS
         GR2A==
X-Gm-Message-State: APjAAAWX9RsTfCTmtiwyxsJIe05yzdNSWy4n4jXs5AEjo5rTEinYqaty
        aevQtOObwh4FuFtZRHiE/ie0PxD7
X-Google-Smtp-Source: APXvYqyYaT0CDQ1Ea61RMNU/dhZspzaZfFsSh5DLRXxJ0K4Sb3PL27mp+LZSRDdrZ7ZVm0MGgloBCg==
X-Received: by 2002:a50:ab58:: with SMTP id t24mr35845049edc.131.1568202074879;
        Wed, 11 Sep 2019 04:41:14 -0700 (PDT)
Received: from localhost.localdomain.com ([188.204.2.113])
        by smtp.gmail.com with ESMTPSA id z6sm2448022ejo.26.2019.09.11.04.41.14
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 11 Sep 2019 04:41:14 -0700 (PDT)
From:   Pascal van Leeuwen <pascalvanl@gmail.com>
X-Google-Original-From: Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
To:     linux-crypto@vger.kernel.org
Cc:     antoine.tenart@bootlin.com, herbert@gondor.apana.org.au,
        davem@davemloft.net,
        Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
Subject: [PATCH 5/7] crypto: inside-secure - Add support for the cfb(sm4) skcipher
Date:   Wed, 11 Sep 2019 12:38:22 +0200
Message-Id: <1568198304-8101-6-git-send-email-pvanleeuwen@verimatrix.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1568198304-8101-1-git-send-email-pvanleeuwen@verimatrix.com>
References: <1568198304-8101-1-git-send-email-pvanleeuwen@verimatrix.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This patch adds support for SM4 in CFB mode, i.e. skcipher cfb(sm4).

Signed-off-by: Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
---
 drivers/crypto/inside-secure/safexcel.c        |  1 +
 drivers/crypto/inside-secure/safexcel.h        |  1 +
 drivers/crypto/inside-secure/safexcel_cipher.c | 36 ++++++++++++++++++++++++++
 3 files changed, 38 insertions(+)

diff --git a/drivers/crypto/inside-secure/safexcel.c b/drivers/crypto/inside-secure/safexcel.c
index fbfda68..1679b41 100644
--- a/drivers/crypto/inside-secure/safexcel.c
+++ b/drivers/crypto/inside-secure/safexcel.c
@@ -1181,6 +1181,7 @@ static int safexcel_request_ring_irq(void *pdev, int irqid,
 	&safexcel_alg_ecb_sm4,
 	&safexcel_alg_cbc_sm4,
 	&safexcel_alg_ofb_sm4,
+	&safexcel_alg_cfb_sm4,
 };
 
 static int safexcel_register_algorithms(struct safexcel_crypto_priv *priv)
diff --git a/drivers/crypto/inside-secure/safexcel.h b/drivers/crypto/inside-secure/safexcel.h
index 448db38..07aa46b 100644
--- a/drivers/crypto/inside-secure/safexcel.h
+++ b/drivers/crypto/inside-secure/safexcel.h
@@ -876,5 +876,6 @@ int safexcel_hmac_setkey(const char *alg, const u8 *key, unsigned int keylen,
 extern struct safexcel_alg_template safexcel_alg_ecb_sm4;
 extern struct safexcel_alg_template safexcel_alg_cbc_sm4;
 extern struct safexcel_alg_template safexcel_alg_ofb_sm4;
+extern struct safexcel_alg_template safexcel_alg_cfb_sm4;
 
 #endif
diff --git a/drivers/crypto/inside-secure/safexcel_cipher.c b/drivers/crypto/inside-secure/safexcel_cipher.c
index 0a30e7a..89cef28 100644
--- a/drivers/crypto/inside-secure/safexcel_cipher.c
+++ b/drivers/crypto/inside-secure/safexcel_cipher.c
@@ -2782,3 +2782,39 @@ struct safexcel_alg_template safexcel_alg_ofb_sm4 = {
 		},
 	},
 };
+
+static int safexcel_skcipher_sm4_cfb_cra_init(struct crypto_tfm *tfm)
+{
+	struct safexcel_cipher_ctx *ctx = crypto_tfm_ctx(tfm);
+
+	safexcel_skcipher_cra_init(tfm);
+	ctx->alg  = SAFEXCEL_SM4;
+	ctx->mode = CONTEXT_CONTROL_CRYPTO_MODE_CFB;
+	return 0;
+}
+
+struct safexcel_alg_template safexcel_alg_cfb_sm4 = {
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
+			.cra_name = "cfb(sm4)",
+			.cra_driver_name = "safexcel-cfb-sm4",
+			.cra_priority = SAFEXCEL_CRA_PRIORITY,
+			.cra_flags = CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_KERN_DRIVER_ONLY,
+			.cra_blocksize = 1,
+			.cra_ctxsize = sizeof(struct safexcel_cipher_ctx),
+			.cra_alignmask = 0,
+			.cra_init = safexcel_skcipher_sm4_cfb_cra_init,
+			.cra_exit = safexcel_skcipher_cra_exit,
+			.cra_module = THIS_MODULE,
+		},
+	},
+};
-- 
1.8.3.1

