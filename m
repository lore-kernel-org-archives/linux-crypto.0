Return-Path: <SRS0=X5ob=U7=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0EF5EC06510
	for <linux-crypto@archiver.kernel.org>; Tue,  2 Jul 2019 19:42:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DDFF421850
	for <linux-crypto@archiver.kernel.org>; Tue,  2 Jul 2019 19:42:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="vQm1OGzh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727084AbfGBTmi (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 2 Jul 2019 15:42:38 -0400
Received: from mail-lf1-f47.google.com ([209.85.167.47]:38246 "EHLO
        mail-lf1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727077AbfGBTmh (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 2 Jul 2019 15:42:37 -0400
Received: by mail-lf1-f47.google.com with SMTP id b11so12268243lfa.5
        for <linux-crypto@vger.kernel.org>; Tue, 02 Jul 2019 12:42:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=s+NhQ00hAhL+HJIqCr189mBOpkGb5PuAQij3uwTGDWg=;
        b=vQm1OGzhhvdX92Ew1zFqtbcLd9L5I8rOiqRKh5575j6jviesSFNzqvLTdWHuISXm/p
         Yl5ccJ2UCXeKUrBO7xeSAP1Jf5//rR2pKLchEwVD975XpdkRHpzX8xgA5p8pOnrjqzvP
         lrMMXcd+y94W41YoalMOKFrvHvXy9ybe3bVMCSwMtRI8aXf7X+ZKyLbLqmuwPQM7KPCD
         PyLWB66suIQNrZHbCASVUG1/+fMnu6xk+5mGG2aJ+TekYEkYRumVjOihPfw67uHPNLn5
         m78j1ydBk5NWVvypJ9azy1mKRxn7BeuLNySUSwXaDTIMZSSeVhutLETxh5pNPNQYgT6q
         WiPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=s+NhQ00hAhL+HJIqCr189mBOpkGb5PuAQij3uwTGDWg=;
        b=pNiP/ZmCnhL7MQ8kO0AmCy20JCKTAREFCcY4eKCpMPYgzRfckW63gKEUu0GAFK4NLV
         i11G6JcA4sFruyRGe718eBAfjG+n9eOyk9CSiBIg69dUNcm6o28IMDkT3PcNne1LIqkh
         Q7Tivk3xnm/TB15fDT0+whri9eXr+rt48e0uA9k4fYEWkYg4vNemb1AGcDhs5c/lSlHP
         hYQp/Vu3GKRQriCkaqggGhzQjAy95BCOGzQtb3R1/muugCfQLno6SPN9oS2oxxc875o7
         jyU9Hpvl1q6houKKYaAB1k8DT4CNLwtgO0UYtsmchNQt3dJjHh3ezmpkJBGgYXIm0FxO
         Zymw==
X-Gm-Message-State: APjAAAXEksUpur6PSfOGiUnRA0L2eD/5rigBOr+tqjZR+cgHOaKw+e/r
        JbYOm8wzbxnMyLSqe/w8HNx5/x5iKDX1d8yY
X-Google-Smtp-Source: APXvYqxqyVIbxJ9RTOK2ScNPusxvZyqUCpmuIhlumuNXPLmJ1xNJEvwRy3Evy1w0s9gH+q9e0TwqwA==
X-Received: by 2002:a19:80c4:: with SMTP id b187mr1104007lfd.122.1562096555686;
        Tue, 02 Jul 2019 12:42:35 -0700 (PDT)
Received: from e111045-lin.arm.com (89-212-78-239.static.t-2.net. [89.212.78.239])
        by smtp.gmail.com with ESMTPSA id 24sm4475163ljs.63.2019.07.02.12.42.34
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 02 Jul 2019 12:42:34 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@google.com,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v4 19/32] crypto: aes/arm - use native endiannes for key schedule
Date:   Tue,  2 Jul 2019 21:41:37 +0200
Message-Id: <20190702194150.10405-20-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190702194150.10405-1-ard.biesheuvel@linaro.org>
References: <20190702194150.10405-1-ard.biesheuvel@linaro.org>
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
2.17.1

