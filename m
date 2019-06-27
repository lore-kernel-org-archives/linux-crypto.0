Return-Path: <SRS0=CUNG=U2=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 508D9C48BD7
	for <linux-crypto@archiver.kernel.org>; Thu, 27 Jun 2019 10:28:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 29CB42086D
	for <linux-crypto@archiver.kernel.org>; Thu, 27 Jun 2019 10:28:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="LbL/3Rpq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726382AbfF0K2O (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 27 Jun 2019 06:28:14 -0400
Received: from mail-wm1-f52.google.com ([209.85.128.52]:52003 "EHLO
        mail-wm1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726669AbfF0K2N (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 27 Jun 2019 06:28:13 -0400
Received: by mail-wm1-f52.google.com with SMTP id 207so5186655wma.1
        for <linux-crypto@vger.kernel.org>; Thu, 27 Jun 2019 03:28:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=JgRwk7rV4YDW0Cr7MyntD6TN2vlr6LPUNeCX8j451cs=;
        b=LbL/3RpqaXV6IJH+KwFIsRaEzDlymHrfnWS+TLt48c+YJKKUiudhNceRorjI8YOG2V
         hus8CmnRWKtWW+Df7e9OUaheziY8BdwIdeau9Gqt9SXAqcsRKh7PSrwekMPEslPX4+hl
         d0ntvwoWTKZKIutRBwhOeSmIBH3APnZYid5Yyiv5tzM7/USKPk9fx3BJhHi9aglDKkaS
         4tAh7th4amPKhUE+0xMZlaZXPhpPj6gyUOqdVVBtf7bz7fE3Y6uK9FGy7CVk7hSH77tj
         EXWxY6oXjibKEX6CLiPf4wqT60pE0o1VKYKgGelkdI9Mhm+rtK1+FDqOOeKiH19L158Y
         FA1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=JgRwk7rV4YDW0Cr7MyntD6TN2vlr6LPUNeCX8j451cs=;
        b=SLxgPkID2LhXMfghS5gIlTnBDA6PQpAHvD2Liz34407a+RT1dpNZB5zadYpGhTvgdj
         ghwVoOXdZAdYfJMnSX9+zi0hfFHt6uZT/HSq/nyircnjJiwQ++8qFQuAQIxKq4mY5dTM
         XDO2bYuevUhxOsnINrgJVzxMdq60m5S8XDEXFnCKna9gDzswl1naSslkBgzKp6E5gpOC
         DA0u1b3zcnI9Rk+n3blYYkvE5b1iI6I5Bnb6dJR8kJqJQLNliLo0r8FSR/yqvLKwFU6r
         xezZN9cHmsWZLRKxSoyWXbRuGuZ5LoQOgpyhuXuYQ1e1ZiDU3oDK2xt6oqJz5xIrLBy8
         KxIQ==
X-Gm-Message-State: APjAAAU0XGl3pxJPoFRzlCsDNSxwGnBOxFrZSiE0oqQqQkUrfD8pdrw8
        76pgGxEaMxFncvjNM7oZVaV+cP7Nhwk=
X-Google-Smtp-Source: APXvYqxox/3fuLt9HSAjA8bhy/3y9iklZC77zbHijdWGkZTkUQD3Q0wKE/LnTNI7sx702WB4hraz2A==
X-Received: by 2002:a1c:7a01:: with SMTP id v1mr2846599wmc.10.1561631291353;
        Thu, 27 Jun 2019 03:28:11 -0700 (PDT)
Received: from localhost.localdomain (aaubervilliers-681-1-8-173.w90-88.abo.wanadoo.fr. [90.88.13.173])
        by smtp.gmail.com with ESMTPSA id g2sm5584533wmh.0.2019.06.27.03.28.10
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 27 Jun 2019 03:28:10 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@kernel.org,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v3 19/32] crypto: aes/arm - use native endiannes for key schedule
Date:   Thu, 27 Jun 2019 12:26:34 +0200
Message-Id: <20190627102647.2992-20-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190627102647.2992-1-ard.biesheuvel@linaro.org>
References: <20190627102647.2992-1-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Align ARM's hw instruction based AES implementation with other versions
that keep the key schedule in native endianness. This will allow us to
merge the various implementations going forward.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm/crypto/aes-ce-core.S | 20 ++++++++++----------
 arch/arm/crypto/aes-ce-glue.c |  9 +++------
 2 files changed, 13 insertions(+), 16 deletions(-)

diff --git a/arch/arm/crypto/aes-ce-core.S b/arch/arm/crypto/aes-ce-core.S
index bc53bcaa772e..3692b8735ef7 100644
--- a/arch/arm/crypto/aes-ce-core.S
+++ b/arch/arm/crypto/aes-ce-core.S
@@ -91,19 +91,19 @@
 
 	.macro		do_block, dround, fround
 	cmp		r3, #12			@ which key size?
-	vld1.8		{q10-q11}, [ip]!
+	vld1.32		{q10-q11}, [ip]!
 	\dround		q8, q9
-	vld1.8		{q12-q13}, [ip]!
+	vld1.32		{q12-q13}, [ip]!
 	\dround		q10, q11
-	vld1.8		{q10-q11}, [ip]!
+	vld1.32		{q10-q11}, [ip]!
 	\dround		q12, q13
-	vld1.8		{q12-q13}, [ip]!
+	vld1.32		{q12-q13}, [ip]!
 	\dround		q10, q11
 	blo		0f			@ AES-128: 10 rounds
-	vld1.8		{q10-q11}, [ip]!
+	vld1.32		{q10-q11}, [ip]!
 	\dround		q12, q13
 	beq		1f			@ AES-192: 12 rounds
-	vld1.8		{q12-q13}, [ip]
+	vld1.32		{q12-q13}, [ip]
 	\dround		q10, q11
 0:	\fround		q12, q13, q14
 	bx		lr
@@ -152,8 +152,8 @@ ENDPROC(aes_decrypt_3x)
 
 	.macro		prepare_key, rk, rounds
 	add		ip, \rk, \rounds, lsl #4
-	vld1.8		{q8-q9}, [\rk]		@ load first 2 round keys
-	vld1.8		{q14}, [ip]		@ load last round key
+	vld1.32		{q8-q9}, [\rk]		@ load first 2 round keys
+	vld1.32		{q14}, [ip]		@ load last round key
 	.endm
 
 	/*
@@ -508,8 +508,8 @@ ENDPROC(ce_aes_sub)
 	 *                                        operation on round key *src
 	 */
 ENTRY(ce_aes_invert)
-	vld1.8		{q0}, [r1]
+	vld1.32		{q0}, [r1]
 	aesimc.8	q0, q0
-	vst1.8		{q0}, [r0]
+	vst1.32		{q0}, [r0]
 	bx		lr
 ENDPROC(ce_aes_invert)
diff --git a/arch/arm/crypto/aes-ce-glue.c b/arch/arm/crypto/aes-ce-glue.c
index 04ba66903674..e6da3e30018b 100644
--- a/arch/arm/crypto/aes-ce-glue.c
+++ b/arch/arm/crypto/aes-ce-glue.c
@@ -10,6 +10,7 @@
 
 #include <asm/hwcap.h>
 #include <asm/neon.h>
+#include <asm/unaligned.h>
 #include <crypto/aes.h>
 #include <crypto/internal/simd.h>
 #include <crypto/internal/skcipher.h>
@@ -80,21 +81,17 @@ static int ce_aes_expandkey(struct crypto_aes_ctx *ctx, const u8 *in_key,
 	    key_len != AES_KEYSIZE_256)
 		return -EINVAL;
 
-	memcpy(ctx->key_enc, in_key, key_len);
 	ctx->key_length = key_len;
+	for (i = 0; i < kwords; i++)
+		ctx->key_enc[i] = get_unaligned_le32(in_key + i * sizeof(u32));
 
 	kernel_neon_begin();
 	for (i = 0; i < sizeof(rcon); i++) {
 		u32 *rki = ctx->key_enc + (i * kwords);
 		u32 *rko = rki + kwords;
 
-#ifndef CONFIG_CPU_BIG_ENDIAN
 		rko[0] = ror32(ce_aes_sub(rki[kwords - 1]), 8);
 		rko[0] = rko[0] ^ rki[0] ^ rcon[i];
-#else
-		rko[0] = rol32(ce_aes_sub(rki[kwords - 1]), 8);
-		rko[0] = rko[0] ^ rki[0] ^ (rcon[i] << 24);
-#endif
 		rko[1] = rko[0] ^ rki[1];
 		rko[2] = rko[1] ^ rki[2];
 		rko[3] = rko[2] ^ rki[3];
-- 
2.20.1

