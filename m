Return-Path: <SRS0=RljO=UV=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6AA0CC48BE7
	for <linux-crypto@archiver.kernel.org>; Sat, 22 Jun 2019 19:35:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3D75020657
	for <linux-crypto@archiver.kernel.org>; Sat, 22 Jun 2019 19:35:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="ge1zLkXR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726386AbfFVTfC (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 22 Jun 2019 15:35:02 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:40983 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726378AbfFVTfC (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 22 Jun 2019 15:35:02 -0400
Received: by mail-wr1-f68.google.com with SMTP id c2so9704832wrm.8
        for <linux-crypto@vger.kernel.org>; Sat, 22 Jun 2019 12:35:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=JgRwk7rV4YDW0Cr7MyntD6TN2vlr6LPUNeCX8j451cs=;
        b=ge1zLkXRgySqIvDpzQa7s1BcIusdV6uU80ACw2ZbtUmazBYKJVd93dvlO8TfcUXyaj
         wCOOI1uyObgEWUIGoAfEfPS11gVaK+M+Uc/7Qcg2mROc8IXhYW/krvQz+CJ2IVlnqjRr
         AaLb0E1Pk9GtbkUYccRy/Ijt+Dn/RCU1yGtbAYhGWCQBlSfblpUnpR4RuVKPIg1ChnJJ
         PCtUiKaIZ3zzNZ5Vic/p5cAxEJF3VUc8klrX69eibxSys8S2m1rtJvHsPKejdOaRJADp
         zZpetAlUlNByQ388Tb9Q15/+MYgqf3bBFMkYBKDSB2jCENZZSVEDJ6d3Xy6npJ03c9A7
         +v1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=JgRwk7rV4YDW0Cr7MyntD6TN2vlr6LPUNeCX8j451cs=;
        b=KQkzzlOpEMiaXAhWZDrQcx6WmppPeu63PAe6/i2IQZAGNA0tKqaxlYjp6gwi84p1zI
         OwAiR1fqEveIw3Tgpcrl3MoEg85SZbiCGulGJrJ2YLz6YN7fD7mN9vuMDS89NYKGRcmI
         NGy52gJmZHY1ZdRe4VVVNlfpLIfdecFLWQTh7T6ujW2CuJTtZCJ7urY1ERZ9Y6jWw03v
         w+n69DbruHsa3LeIEa5hkxr1SZoI9wU/3byBByvq4toAACvllSDM0fHqvdw61LjN7heM
         GGeSBRkcIB7O5IVyMjtbh25+JuLI4bg3h/gOnYVNH7hP1+4YLiTzaeXddbEo19WDRBWK
         ynyw==
X-Gm-Message-State: APjAAAUeu2Nyag6aQb92oebFw2nyWDh83zEDQDl6XkPjzQ7zCM4oWBkh
        9WtwnP0h8jxOnIrUdcMiMLTIWkuIF4+qNhx5
X-Google-Smtp-Source: APXvYqyi8qYWH+bwKjnVc+XaPPQLGQLMxyBOP+9527kiqEyFAlnxm1UZDR7OZjrYagGSKw1rsGWZDg==
X-Received: by 2002:adf:ff90:: with SMTP id j16mr23616872wrr.135.1561232100290;
        Sat, 22 Jun 2019 12:35:00 -0700 (PDT)
Received: from sudo.home ([2a01:cb1d:112:6f00:4bd:3f91:4ef8:ae7e])
        by smtp.gmail.com with ESMTPSA id h8sm4814494wmf.12.2019.06.22.12.34.59
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 22 Jun 2019 12:34:59 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@google.com,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v2 19/26] crypto: aes/arm - use native endiannes for key schedule
Date:   Sat, 22 Jun 2019 21:34:20 +0200
Message-Id: <20190622193427.20336-20-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190622193427.20336-1-ard.biesheuvel@linaro.org>
References: <20190622193427.20336-1-ard.biesheuvel@linaro.org>
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

