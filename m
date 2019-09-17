Return-Path: <SRS0=aQ9n=XM=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72CDBC4CECE
	for <linux-crypto@archiver.kernel.org>; Tue, 17 Sep 2019 11:10:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 40E3D214AF
	for <linux-crypto@archiver.kernel.org>; Tue, 17 Sep 2019 11:10:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AVAtW4ao"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726091AbfIQLK4 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 17 Sep 2019 07:10:56 -0400
Received: from mail-ed1-f65.google.com ([209.85.208.65]:34216 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726106AbfIQLK4 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 17 Sep 2019 07:10:56 -0400
Received: by mail-ed1-f65.google.com with SMTP id p10so1126960edq.1
        for <linux-crypto@vger.kernel.org>; Tue, 17 Sep 2019 04:10:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=JMGijuVBDaDenJrhTm5WZLRlGbMeFLDTEP7N9jFf1yU=;
        b=AVAtW4ao03Jk+yBwCM8W80qYco9YtrVKtLahiUYl0kqErirpkpFnNB8jB2lUIV9eC1
         v121W+vx4GIWc0hhK5/oaBMYTMKiUNohODWGEEyx2qNCFVSgF4Jr+vTDjWggwJhfzafg
         GAK77vAcPptEg34B6ixVe6Bfr/SWIUDuJL8AA1QkLLzcU/DM2dz5EmuiPuCCXyc5ojn2
         FXbKj5OlwdJJ5Ag+KgXLc/4JqrtcP2AQzBbhQrjYj+9JYZXsD0hljXLvAmuJXpgtbsLl
         C8xSav6VjVha5Gjy3+r66FiCy0IUkPgQR5Blo+AQ6t/VY6WgJqfh1QNgdlD3foB3cSrP
         H+jA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=JMGijuVBDaDenJrhTm5WZLRlGbMeFLDTEP7N9jFf1yU=;
        b=GIEaJyU/SQHn1pyhXi6i6e5YZO8/H2J+YxBgoMiozgapRMzyO05vfbKJ5AacWEPOaH
         3tAvAwCT+SpeGsY53gM/0K5LSP8DE08eFjY9Mo518PBjTFhW/ScIQhDRW2XXgK2d7qLt
         Vepdo0SHyS5ycuibAThCn7VwMVvwnr+Sx4t9M8I30Yt6xM1PN3pKx/vq3Vu18DjcvnZj
         xub2l/WLgjLu9nnqbkWQ/2z3MOXigjOaLv49IO1aWU5ByiuvbRJ0mSYlNqFewN+GvXty
         vkZrcyg8uTm14o7Ssd6u4GJEZ1Gix91dOWVawwSXnVMQqzCoy357JMx7Y73dMK9ye1Nn
         ORUg==
X-Gm-Message-State: APjAAAX3IRktsiKo06+btdkjG30y5/m1+lTrc2ZJwKT0WUEzfyF4U77M
        WDAIYz0svmuRSlWhB0DhP7l6io+N
X-Google-Smtp-Source: APXvYqz6CPaEif9Z1gPTrR1iZiknNkGyQ1BmQOpgzj7UJtktXEkDBf8O+4zhx3cZhcw96bgZKnrrIg==
X-Received: by 2002:a50:fd83:: with SMTP id o3mr4001703edt.67.1568718652549;
        Tue, 17 Sep 2019 04:10:52 -0700 (PDT)
Received: from localhost.localdomain.com ([188.204.2.113])
        by smtp.gmail.com with ESMTPSA id a50sm376204eda.25.2019.09.17.04.10.51
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 17 Sep 2019 04:10:51 -0700 (PDT)
From:   Pascal van Leeuwen <pascalvanl@gmail.com>
X-Google-Original-From: Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
To:     linux-crypto@vger.kernel.org
Cc:     antoine.tenart@bootlin.com, herbert@gondor.apana.org.au,
        davem@davemloft.net,
        Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
Subject: [PATCH 2/3] crypto: inside-secure - Added support for the rfc4543(gcm(aes)) "AEAD"
Date:   Tue, 17 Sep 2019 12:08:00 +0200
Message-Id: <1568714881-30426-3-git-send-email-pvanleeuwen@verimatrix.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1568714881-30426-1-git-send-email-pvanleeuwen@verimatrix.com>
References: <1568714881-30426-1-git-send-email-pvanleeuwen@verimatrix.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This patch adds support for rfc4543(gcm(aes)) - i.e. AES-GMAC - for use
with IPsec ESP

Signed-off-by: Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
---
 drivers/crypto/inside-secure/safexcel.c        |  1 +
 drivers/crypto/inside-secure/safexcel.h        |  2 +
 drivers/crypto/inside-secure/safexcel_cipher.c | 86 +++++++++++++++++++++-----
 3 files changed, 74 insertions(+), 15 deletions(-)

diff --git a/drivers/crypto/inside-secure/safexcel.c b/drivers/crypto/inside-secure/safexcel.c
index 1914124..09d17f3 100644
--- a/drivers/crypto/inside-secure/safexcel.c
+++ b/drivers/crypto/inside-secure/safexcel.c
@@ -1205,6 +1205,7 @@ static int safexcel_request_ring_irq(void *pdev, int irqid,
 	&safexcel_alg_authenc_hmac_sha512_cbc_des,
 	&safexcel_alg_authenc_hmac_sha384_cbc_des,
 	&safexcel_alg_rfc4106_gcm,
+	&safexcel_alg_rfc4543_gcm,
 };
 
 static int safexcel_register_algorithms(struct safexcel_crypto_priv *priv)
diff --git a/drivers/crypto/inside-secure/safexcel.h b/drivers/crypto/inside-secure/safexcel.h
index 6c91d49..c172b97 100644
--- a/drivers/crypto/inside-secure/safexcel.h
+++ b/drivers/crypto/inside-secure/safexcel.h
@@ -407,6 +407,7 @@ struct safexcel_context_record {
 #define EIP197_XCM_MODE_CCM			2
 
 #define EIP197_AEAD_TYPE_IPSEC_ESP		2
+#define EIP197_AEAD_TYPE_IPSEC_ESP_GMAC		3
 #define EIP197_AEAD_IPSEC_IV_SIZE		8
 #define EIP197_AEAD_IPSEC_NONCE_SIZE		4
 
@@ -911,5 +912,6 @@ int safexcel_hmac_setkey(const char *alg, const u8 *key, unsigned int keylen,
 extern struct safexcel_alg_template safexcel_alg_authenc_hmac_sha512_cbc_des;
 extern struct safexcel_alg_template safexcel_alg_authenc_hmac_sha384_cbc_des;
 extern struct safexcel_alg_template safexcel_alg_rfc4106_gcm;
+extern struct safexcel_alg_template safexcel_alg_rfc4543_gcm;
 
 #endif
diff --git a/drivers/crypto/inside-secure/safexcel_cipher.c b/drivers/crypto/inside-secure/safexcel_cipher.c
index d0334b2..e895c5a 100644
--- a/drivers/crypto/inside-secure/safexcel_cipher.c
+++ b/drivers/crypto/inside-secure/safexcel_cipher.c
@@ -47,7 +47,7 @@ struct safexcel_cipher_ctx {
 
 	u32 mode;
 	enum safexcel_cipher_alg alg;
-	char aead; /* !=0=AEAD, 2=IPSec ESP AEAD */
+	char aead; /* !=0=AEAD, 2=IPSec ESP AEAD, 3=IPsec ESP GMAC */
 	char xcm;  /* 0=authenc, 1=GCM, 2 reserved for CCM */
 
 	__le32 key[16];
@@ -78,7 +78,7 @@ static void safexcel_cipher_token(struct safexcel_cipher_ctx *ctx, u8 *iv,
 	u32 block_sz = 0;
 
 	if (ctx->mode == CONTEXT_CONTROL_CRYPTO_MODE_CTR_LOAD ||
-	    ctx->aead == EIP197_AEAD_TYPE_IPSEC_ESP) {
+	    ctx->aead & EIP197_AEAD_TYPE_IPSEC_ESP) { /* _ESP and _ESP_GMAC */
 		cdesc->control_data.options |= EIP197_OPTION_4_TOKEN_IV_CMD;
 
 		/* 32 bit nonce */
@@ -219,7 +219,7 @@ static void safexcel_aead_token(struct safexcel_cipher_ctx *ctx, u8 *iv,
 	}
 
 	if (ctx->aead == EIP197_AEAD_TYPE_IPSEC_ESP) {
-		/* For ESP mode, skip over the IV */
+		/* For ESP mode (and not GMAC), skip over the IV */
 		token[7].opcode = EIP197_TOKEN_OPCODE_DIRECTION;
 		token[7].packet_length = EIP197_AEAD_IPSEC_IV_SIZE;
 
@@ -235,10 +235,18 @@ static void safexcel_aead_token(struct safexcel_cipher_ctx *ctx, u8 *iv,
 		token[10].opcode = EIP197_TOKEN_OPCODE_DIRECTION;
 		token[10].packet_length = cryptlen;
 		token[10].stat = EIP197_TOKEN_STAT_LAST_HASH;
-		token[10].instructions = EIP197_TOKEN_INS_LAST |
-					 EIP197_TOKEN_INS_TYPE_CRYPTO |
-					 EIP197_TOKEN_INS_TYPE_HASH |
-					 EIP197_TOKEN_INS_TYPE_OUTPUT;
+		if (unlikely(ctx->aead == EIP197_AEAD_TYPE_IPSEC_ESP_GMAC)) {
+			token[6].instructions = EIP197_TOKEN_INS_TYPE_HASH;
+			/* Do not send to crypt engine in case of GMAC */
+			token[10].instructions = EIP197_TOKEN_INS_LAST |
+						 EIP197_TOKEN_INS_TYPE_HASH |
+						 EIP197_TOKEN_INS_TYPE_OUTPUT;
+		} else {
+			token[10].instructions = EIP197_TOKEN_INS_LAST |
+						 EIP197_TOKEN_INS_TYPE_CRYPTO |
+						 EIP197_TOKEN_INS_TYPE_HASH |
+						 EIP197_TOKEN_INS_TYPE_OUTPUT;
+		}
 	} else if (ctx->xcm != EIP197_XCM_MODE_CCM) {
 		token[6].stat = EIP197_TOKEN_STAT_LAST_HASH;
 	}
@@ -494,17 +502,21 @@ static int safexcel_context_control(struct safexcel_cipher_ctx *ctx,
 				ctx->hash_alg |
 				CONTEXT_CONTROL_SIZE(ctrl_size);
 		}
-		if (sreq->direction == SAFEXCEL_ENCRYPT)
-			cdesc->control_data.control0 |=
-				(ctx->xcm == EIP197_XCM_MODE_CCM) ?
-					CONTEXT_CONTROL_TYPE_HASH_ENCRYPT_OUT :
-					CONTEXT_CONTROL_TYPE_ENCRYPT_HASH_OUT;
 
+		if (sreq->direction == SAFEXCEL_ENCRYPT &&
+		    (ctx->xcm == EIP197_XCM_MODE_CCM ||
+		     ctx->aead == EIP197_AEAD_TYPE_IPSEC_ESP_GMAC))
+			cdesc->control_data.control0 |=
+				CONTEXT_CONTROL_TYPE_HASH_ENCRYPT_OUT;
+		else if (sreq->direction == SAFEXCEL_ENCRYPT)
+			cdesc->control_data.control0 |=
+				CONTEXT_CONTROL_TYPE_ENCRYPT_HASH_OUT;
+		else if (ctx->xcm == EIP197_XCM_MODE_CCM)
+			cdesc->control_data.control0 |=
+				CONTEXT_CONTROL_TYPE_DECRYPT_HASH_IN;
 		else
 			cdesc->control_data.control0 |=
-				(ctx->xcm == EIP197_XCM_MODE_CCM) ?
-					CONTEXT_CONTROL_TYPE_DECRYPT_HASH_IN :
-					CONTEXT_CONTROL_TYPE_HASH_DECRYPT_IN;
+				CONTEXT_CONTROL_TYPE_HASH_DECRYPT_IN;
 	} else {
 		if (sreq->direction == SAFEXCEL_ENCRYPT)
 			cdesc->control_data.control0 =
@@ -3494,3 +3506,47 @@ struct safexcel_alg_template safexcel_alg_rfc4106_gcm = {
 		},
 	},
 };
+
+static int safexcel_rfc4543_gcm_setauthsize(struct crypto_aead *tfm,
+					    unsigned int authsize)
+{
+	if (authsize != GHASH_DIGEST_SIZE)
+		return -EINVAL;
+
+	return 0;
+}
+
+static int safexcel_rfc4543_gcm_cra_init(struct crypto_tfm *tfm)
+{
+	struct safexcel_cipher_ctx *ctx = crypto_tfm_ctx(tfm);
+	int ret;
+
+	ret = safexcel_aead_gcm_cra_init(tfm);
+	ctx->aead  = EIP197_AEAD_TYPE_IPSEC_ESP_GMAC;
+	return ret;
+}
+
+struct safexcel_alg_template safexcel_alg_rfc4543_gcm = {
+	.type = SAFEXCEL_ALG_TYPE_AEAD,
+	.algo_mask = SAFEXCEL_ALG_AES | SAFEXCEL_ALG_GHASH,
+	.alg.aead = {
+		.setkey = safexcel_rfc4106_gcm_setkey,
+		.setauthsize = safexcel_rfc4543_gcm_setauthsize,
+		.encrypt = safexcel_rfc4106_encrypt,
+		.decrypt = safexcel_rfc4106_decrypt,
+		.ivsize = GCM_RFC4543_IV_SIZE,
+		.maxauthsize = GHASH_DIGEST_SIZE,
+		.base = {
+			.cra_name = "rfc4543(gcm(aes))",
+			.cra_driver_name = "safexcel-rfc4543-gcm-aes",
+			.cra_priority = SAFEXCEL_CRA_PRIORITY,
+			.cra_flags = CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_KERN_DRIVER_ONLY,
+			.cra_blocksize = 1,
+			.cra_ctxsize = sizeof(struct safexcel_cipher_ctx),
+			.cra_alignmask = 0,
+			.cra_init = safexcel_rfc4543_gcm_cra_init,
+			.cra_exit = safexcel_aead_gcm_cra_exit,
+		},
+	},
+};
-- 
1.8.3.1

