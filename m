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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E8FAC3A5A4
	for <linux-crypto@archiver.kernel.org>; Fri, 30 Aug 2019 08:45:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 35537238C5
	for <linux-crypto@archiver.kernel.org>; Fri, 30 Aug 2019 08:45:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="u3wBfoP4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727426AbfH3Ipo (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 30 Aug 2019 04:45:44 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:44435 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727307AbfH3Ipo (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 30 Aug 2019 04:45:44 -0400
Received: by mail-ed1-f68.google.com with SMTP id a21so7096081edt.11
        for <linux-crypto@vger.kernel.org>; Fri, 30 Aug 2019 01:45:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=MEQTHbrV4YK/jaxZIJK6+p/9f7KjQ3xx07jnaP9Ceps=;
        b=u3wBfoP4u3GvVac4CDwNTOOdT82uCO7WXou/OdRrP8+tM0ME4XZ3fJuurSB3qGa1df
         h/kKdMoJ6IeOnKt/356FaSKC5ilgvrbuurpfd4+7+abUDaKnJT/kPNLhx8603hhK0jmG
         qeAqh0TZ3GCWoy2aJV0pBaiG5qTnk5KktC7wkD2+ZeKgGsf7soN6ZF3u8gwnreylaElS
         uvx3TtD3dQpiliHqtn7b3NZh0seR52xNwX9JHpZrGuyAUl6Ztabq+VNMo6eNKVs5IimF
         1oP2KyegFmxtroXFhUDQG6kpfz2WUcOCHOCQv7lZgnONid1AUJUxCHhriwDLL/Fw1slm
         /q8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=MEQTHbrV4YK/jaxZIJK6+p/9f7KjQ3xx07jnaP9Ceps=;
        b=DZxkNDIASAZs0f0FJc4o1fLOHE8fyzNiaGklx6vpfkw8gY72iXZvI303jsrwmc2l0p
         OeAyITuLf5B1xXBm9V5RGcoVrHZetCjVsxn4gqTzXGnWwRbUJl1ahp7ipW92xr9dnN6y
         Z0A/m5/xg597vFxQvVuqnsjPvbKAS42YpQdirShGT1NtbD3J+r4AGfPdvprCinvXEQYI
         nE0/01Z4KS+/qoRn7zEgzNMU7KnNxEc2eEyMehbdjDGxY1KacaflAY8pzU+AFGZ1PnN9
         lCMe3umjPbMct2HTCRO1hzRdmwIAdkVp/xnqFLMNDkdHKJCLROF7H9W/lC861+6Xeu4U
         t7nA==
X-Gm-Message-State: APjAAAVoM/1yOK046qm6ePSEXDoaQpCRgtGlL9V5o12EQT6/+M7MK0QM
        smtaDjkfJ37RSnU/S3iXBUStxmPb
X-Google-Smtp-Source: APXvYqwGSLT5bG/sxgd9Ne/F8W+RXR0A6TES9WaGX4QvIeA3kZ2kJR32Eit4v4ECm1GAk9Zc4l/8JA==
X-Received: by 2002:a17:906:74d4:: with SMTP id z20mr870524ejl.191.1567154742245;
        Fri, 30 Aug 2019 01:45:42 -0700 (PDT)
Received: from localhost.localdomain.com ([188.204.2.113])
        by smtp.gmail.com with ESMTPSA id k16sm282643ejv.87.2019.08.30.01.45.41
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 30 Aug 2019 01:45:41 -0700 (PDT)
From:   Pascal van Leeuwen <pascalvanl@gmail.com>
X-Google-Original-From: Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
To:     linux-crypto@vger.kernel.org
Cc:     antoine.tenart@bootlin.com, herbert@gondor.apana.org.au,
        davem@davemloft.net,
        Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
Subject: [PATCH] crypto: inside-secure - Minor code cleanup and optimizations
Date:   Fri, 30 Aug 2019 09:43:01 +0200
Message-Id: <1567150981-10853-1-git-send-email-pvanleeuwen@verimatrix.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Some minor cleanup changing e.g. "if (!x) A else B" to "if (x) B else A",
merging some back-to-back if's with the same condition, collapsing some
back-to-back assignments to the same variable and replacing some weird
assignments with proper symbolics.

Signed-off-by: Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
---
 drivers/crypto/inside-secure/safexcel_cipher.c | 86 ++++++++++++++------------
 1 file changed, 47 insertions(+), 39 deletions(-)

diff --git a/drivers/crypto/inside-secure/safexcel_cipher.c b/drivers/crypto/inside-secure/safexcel_cipher.c
index 917a4b7..c82d003 100644
--- a/drivers/crypto/inside-secure/safexcel_cipher.c
+++ b/drivers/crypto/inside-secure/safexcel_cipher.c
@@ -126,9 +126,6 @@ static void safexcel_aead_token(struct safexcel_cipher_ctx *ctx, u8 *iv,
 
 	safexcel_cipher_token(ctx, iv, cdesc);
 
-	if (direction == SAFEXCEL_DECRYPT)
-		cryptlen -= digestsize;
-
 	if (direction == SAFEXCEL_ENCRYPT) {
 		/* align end of instruction sequence to end of token */
 		token = (struct safexcel_token *)(cdesc->control_data.token +
@@ -141,6 +138,8 @@ static void safexcel_aead_token(struct safexcel_cipher_ctx *ctx, u8 *iv,
 		token[2].instructions = EIP197_TOKEN_INS_TYPE_OUTPUT |
 					EIP197_TOKEN_INS_INSERT_HASH_DIGEST;
 	} else {
+		cryptlen -= digestsize;
+
 		/* align end of instruction sequence to end of token */
 		token = (struct safexcel_token *)(cdesc->control_data.token +
 			 EIP197_MAX_TOKENS - 4);
@@ -159,13 +158,7 @@ static void safexcel_aead_token(struct safexcel_cipher_ctx *ctx, u8 *iv,
 		token[3].instructions = EIP197_TOKEN_INS_TYPE_OUTPUT;
 	}
 
-	if (unlikely(!cryptlen)) {
-		token[1].opcode = EIP197_TOKEN_OPCODE_DIRECTION;
-		token[1].packet_length = assoclen;
-		token[1].stat = EIP197_TOKEN_STAT_LAST_HASH;
-		token[1].instructions = EIP197_TOKEN_INS_LAST |
-					EIP197_TOKEN_INS_TYPE_HASH;
-	} else {
+	if (likely(cryptlen)) {
 		if (likely(assoclen)) {
 			token[0].opcode = EIP197_TOKEN_OPCODE_DIRECTION;
 			token[0].packet_length = assoclen;
@@ -179,6 +172,12 @@ static void safexcel_aead_token(struct safexcel_cipher_ctx *ctx, u8 *iv,
 					EIP197_TOKEN_INS_TYPE_CRYPTO |
 					EIP197_TOKEN_INS_TYPE_HASH |
 					EIP197_TOKEN_INS_TYPE_OUTPUT;
+	} else {
+		token[1].opcode = EIP197_TOKEN_OPCODE_DIRECTION;
+		token[1].packet_length = assoclen;
+		token[1].stat = EIP197_TOKEN_STAT_LAST_HASH;
+		token[1].instructions = EIP197_TOKEN_INS_LAST |
+					EIP197_TOKEN_INS_TYPE_HASH;
 	}
 }
 
@@ -331,45 +330,60 @@ static int safexcel_context_control(struct safexcel_cipher_ctx *ctx,
 				    struct safexcel_command_desc *cdesc)
 {
 	struct safexcel_crypto_priv *priv = ctx->priv;
-	int ctrl_size;
+	int ctrl_size = ctx->key_len / sizeof(u32);
+
+	cdesc->control_data.control1 = ctx->mode;
 
 	if (ctx->aead) {
+		/* Take in account the ipad+opad digests */
+		ctrl_size += ctx->state_sz / sizeof(u32) * 2;
+
 		if (sreq->direction == SAFEXCEL_ENCRYPT)
-			cdesc->control_data.control0 |= CONTEXT_CONTROL_TYPE_ENCRYPT_HASH_OUT;
+			cdesc->control_data.control0 =
+				CONTEXT_CONTROL_TYPE_ENCRYPT_HASH_OUT |
+				CONTEXT_CONTROL_DIGEST_HMAC |
+				CONTEXT_CONTROL_KEY_EN |
+				ctx->hash_alg |
+				CONTEXT_CONTROL_SIZE(ctrl_size);
 		else
-			cdesc->control_data.control0 |= CONTEXT_CONTROL_TYPE_HASH_DECRYPT_IN;
+			cdesc->control_data.control0 =
+				CONTEXT_CONTROL_TYPE_HASH_DECRYPT_IN |
+				CONTEXT_CONTROL_DIGEST_HMAC |
+				CONTEXT_CONTROL_KEY_EN |
+				ctx->hash_alg |
+				CONTEXT_CONTROL_SIZE(ctrl_size);
 	} else {
-		cdesc->control_data.control0 |= CONTEXT_CONTROL_TYPE_CRYPTO_OUT;
-
-		/* The decryption control type is a combination of the
-		 * encryption type and CONTEXT_CONTROL_TYPE_NULL_IN, for all
-		 * types.
-		 */
-		if (sreq->direction == SAFEXCEL_DECRYPT)
-			cdesc->control_data.control0 |= CONTEXT_CONTROL_TYPE_NULL_IN;
+		if (sreq->direction == SAFEXCEL_ENCRYPT)
+			cdesc->control_data.control0 =
+				CONTEXT_CONTROL_TYPE_CRYPTO_OUT |
+				CONTEXT_CONTROL_KEY_EN |
+				CONTEXT_CONTROL_SIZE(ctrl_size);
+		else
+			cdesc->control_data.control0 =
+				CONTEXT_CONTROL_TYPE_CRYPTO_IN |
+				CONTEXT_CONTROL_KEY_EN |
+				CONTEXT_CONTROL_SIZE(ctrl_size);
 	}
 
-	cdesc->control_data.control0 |= CONTEXT_CONTROL_KEY_EN;
-	cdesc->control_data.control1 |= ctx->mode;
-
-	if (ctx->aead)
-		cdesc->control_data.control0 |= CONTEXT_CONTROL_DIGEST_HMAC |
-						ctx->hash_alg;
-
 	if (ctx->alg == SAFEXCEL_DES) {
-		cdesc->control_data.control0 |= CONTEXT_CONTROL_CRYPTO_ALG_DES;
+		cdesc->control_data.control0 |=
+			CONTEXT_CONTROL_CRYPTO_ALG_DES;
 	} else if (ctx->alg == SAFEXCEL_3DES) {
-		cdesc->control_data.control0 |= CONTEXT_CONTROL_CRYPTO_ALG_3DES;
+		cdesc->control_data.control0 |=
+			CONTEXT_CONTROL_CRYPTO_ALG_3DES;
 	} else if (ctx->alg == SAFEXCEL_AES) {
 		switch (ctx->key_len >> ctx->xts) {
 		case AES_KEYSIZE_128:
-			cdesc->control_data.control0 |= CONTEXT_CONTROL_CRYPTO_ALG_AES128;
+			cdesc->control_data.control0 |=
+				CONTEXT_CONTROL_CRYPTO_ALG_AES128;
 			break;
 		case AES_KEYSIZE_192:
-			cdesc->control_data.control0 |= CONTEXT_CONTROL_CRYPTO_ALG_AES192;
+			cdesc->control_data.control0 |=
+				CONTEXT_CONTROL_CRYPTO_ALG_AES192;
 			break;
 		case AES_KEYSIZE_256:
-			cdesc->control_data.control0 |= CONTEXT_CONTROL_CRYPTO_ALG_AES256;
+			cdesc->control_data.control0 |=
+				CONTEXT_CONTROL_CRYPTO_ALG_AES256;
 			break;
 		default:
 			dev_err(priv->dev, "aes keysize not supported: %u\n",
@@ -378,12 +392,6 @@ static int safexcel_context_control(struct safexcel_cipher_ctx *ctx,
 		}
 	}
 
-	ctrl_size = ctx->key_len / sizeof(u32);
-	if (ctx->aead)
-		/* Take in account the ipad+opad digests */
-		ctrl_size += ctx->state_sz / sizeof(u32) * 2;
-	cdesc->control_data.control0 |= CONTEXT_CONTROL_SIZE(ctrl_size);
-
 	return 0;
 }
 
-- 
1.8.3.1

