Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A154115AC2
	for <linux-crypto@vger.kernel.org>; Thu, 11 Jan 2024 12:33:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="sM+3e7an"
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-dbdb69bc114so7191588276.0
        for <linux-crypto@vger.kernel.org>; Thu, 11 Jan 2024 04:33:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1704976412; x=1705581212; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=QHDclY05fjEWHWVFdqEeEWldPY0XAnoENh1KcMswByg=;
        b=sM+3e7an8st+nPA96L0jxlU6mILtzay/ZH3amyfPAFWh43pN6QYzL+dgNkXvkIcY9n
         UeDjItnZe5jktP2Yaw+02Gnk006sJ7i95154jta7U03cuXTAvz1bI08PVOkkw2CTqJD0
         D/iJG+qXRekqYlZFaGHcqY6wnlTxpCF99hq45TwXEB1GC5l2v6Z7ui30Rw9HGNgH82b4
         ppy4DTpYEf5DVWmbjACOem9vU6LflNRA5oNxL1qcbrhPw+ufKP66zU8iHqui/p8mMX21
         urqrbMlc5ZA1+Oaincip1joRFnYW1YaMTiHg+Hl4bhoeDUfTo+1zns3TOYkw5l8Pp9jt
         CVYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704976412; x=1705581212;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QHDclY05fjEWHWVFdqEeEWldPY0XAnoENh1KcMswByg=;
        b=oI+jx/BM71e139N6kApKOAHptkrRQT94iBwlyV8ufVtliyGNg5bY0sgibUaISaUo+V
         An451LIgJ3XOXxhR8pLLB5/j60oLovNhlxOWeHL+ATkNHNil4/G7eI9GP44n4pGvCo9T
         dtX7N1IwlotMnmUt2kgnqDX7skrkjq/CU8TkBKCEI0kOJNX5qpEctk01kGCMcPCeibT+
         RiaUplzYGxqRklWZQM7z53xwzDfEsPt7K5Qly+TIRRtz3IzdDVKqlBzNsdoOfM29YpZ8
         OeJhcn2EPcMNTZ2+Y4MfsPzNNv+Pg42Pkvch/38fkATYBXlOceoVqkqwtAQkGGOXQQfT
         hipg==
X-Gm-Message-State: AOJu0YzWjFhhg6xqJIHrusi3ZQUsvr08XTDSE0FM2ZN8ID1Ta4s67Gqy
	JNRrK8CHPOpx4ynvL5zGBNxK4P7nWFw5cDHqqtiCevctA4ZCTMHSQ7A1gXHLLWFs7f0LnWqLv06
	9yjwlEKhb7+IsFuXy+aPx+5UBKK6kVHqVsj7+4FetJnsDQJHRz8VN58lLn9VAmeGU+K23Hsk=
X-Google-Smtp-Source: AGHT+IFUEAx5y8BVxQp1jrTICbSiLjwdyWaDzrAPpVT11wT+s5zJ2GtGVHd4GtOEX8p7B835X/U9W0ZY
X-Received: from palermo.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:118a])
 (user=ardb job=sendgmr) by 2002:a05:6902:2843:b0:dbe:a220:68f9 with SMTP id
 ee3-20020a056902284300b00dbea22068f9mr475521ybb.0.1704976412450; Thu, 11 Jan
 2024 04:33:32 -0800 (PST)
Date: Thu, 11 Jan 2024 13:33:07 +0100
In-Reply-To: <20240111123302.589910-10-ardb+git@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240111123302.589910-10-ardb+git@google.com>
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=5865; i=ardb@kernel.org;
 h=from:subject; bh=tZlQQtnd9aDoIsH9u1ZAwbpmkDhKIfhCzBwvMQih1VI=;
 b=owGbwMvMwCFmkMcZplerG8N4Wi2JIXX+A6aLR29cVglR8/L4uHh65ptaqTlFJnuz915gjy5Nm
 6WuJvS3o5SFQYyDQVZMkUVg9t93O09PlKp1niULM4eVCWQIAxenAEyEXZ7hr7DOohXHX8h+XXc7
 UUJiU7LlpccnGDol5sVdlZypv3imgBgjw5GgBUJJ25/PmHV+2eY7mzYeT3zgvPagcYBVj8ad4/N 81nADAA==
X-Mailer: git-send-email 2.43.0.275.g3460e3d667-goog
Message-ID: <20240111123302.589910-14-ardb+git@google.com>
Subject: [PATCH 4/8] crypto: arm64/aes-ccm - Replace bytewise tail handling
 with NEON permute
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-crypto@vger.kernel.org
Cc: ebiggers@kernel.org, herbert@gondor.apana.org.au, 
	Ard Biesheuvel <ardb@kernel.org>
Content-Type: text/plain; charset="UTF-8"

From: Ard Biesheuvel <ardb@kernel.org>

Implement the CCM tail handling using a single sequence that uses
permute vectors and overlapping loads and stores, rather than going over
the tail byte by byte in a loop, and using scalar operations. This is
more efficient, even though the measured speedup is only around 1-2% on
the CPUs I have tried.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/arm64/crypto/aes-ce-ccm-core.S | 59 +++++++++++++-------
 arch/arm64/crypto/aes-ce-ccm-glue.c | 20 +++----
 2 files changed, 48 insertions(+), 31 deletions(-)

diff --git a/arch/arm64/crypto/aes-ce-ccm-core.S b/arch/arm64/crypto/aes-ce-ccm-core.S
index b03f7f71f893..b21a9b759ab2 100644
--- a/arch/arm64/crypto/aes-ce-ccm-core.S
+++ b/arch/arm64/crypto/aes-ce-ccm-core.S
@@ -1,8 +1,11 @@
 /* SPDX-License-Identifier: GPL-2.0-only */
 /*
- * aesce-ccm-core.S - AES-CCM transform for ARMv8 with Crypto Extensions
+ * aes-ce-ccm-core.S - AES-CCM transform for ARMv8 with Crypto Extensions
  *
- * Copyright (C) 2013 - 2017 Linaro Ltd <ard.biesheuvel@linaro.org>
+ * Copyright (C) 2013 - 2017 Linaro Ltd.
+ * Copyright (C) 2024 Google LLC
+ *
+ * Author: Ard Biesheuvel <ardb@kernel.org>
  */
 
 #include <linux/linkage.h>
@@ -168,13 +171,13 @@ CPU_LE(	rev	x8, x8			)	/* keep swabbed ctr in reg */
 	ld1	{v2.16b}, [x1], #16		/* load next input block */
 	.if	\enc == 1
 	eor	v2.16b, v2.16b, v5.16b		/* final round enc+mac */
-	eor	v1.16b, v1.16b, v2.16b		/* xor with crypted ctr */
+	eor	v6.16b, v1.16b, v2.16b		/* xor with crypted ctr */
 	.else
 	eor	v2.16b, v2.16b, v1.16b		/* xor with crypted ctr */
-	eor	v1.16b, v2.16b, v5.16b		/* final round enc */
+	eor	v6.16b, v2.16b, v5.16b		/* final round enc */
 	.endif
 	eor	v0.16b, v0.16b, v2.16b		/* xor mac with pt ^ rk[last] */
-	st1	{v1.16b}, [x0], #16		/* write output block */
+	st1	{v6.16b}, [x0], #16		/* write output block */
 	bne	0b
 CPU_LE(	rev	x8, x8			)
 	st1	{v0.16b}, [x5]			/* store mac */
@@ -183,25 +186,31 @@ CPU_LE(	rev	x8, x8			)
 
 6:	eor	v0.16b, v0.16b, v5.16b		/* final round mac */
 	eor	v1.16b, v1.16b, v5.16b		/* final round enc */
-	st1	{v0.16b}, [x5]			/* store mac */
-	add	w2, w2, #16			/* process partial tail block */
-7:	ldrb	w9, [x1], #1			/* get 1 byte of input */
-	umov	w6, v1.b[0]			/* get top crypted ctr byte */
-	umov	w7, v0.b[0]			/* get top mac byte */
+
+	add	x1, x1, w2, sxtw		/* rewind the input pointer (w2 < 0) */
+	add	x0, x0, w2, sxtw		/* rewind the output pointer */
+
+	adr_l	x8, .Lpermute			/* load permute vectors */
+	add	x9, x8, w2, sxtw
+	sub	x8, x8, w2, sxtw
+	ld1	{v7.16b-v8.16b}, [x9]
+	ld1	{v9.16b}, [x8]
+
+	ld1	{v2.16b}, [x1]			/* load a full block of input */
+	tbl	v1.16b, {v1.16b}, v7.16b	/* move keystream to end of register */
 	.if	\enc == 1
-	eor	w7, w7, w9
-	eor	w9, w9, w6
+	tbl	v7.16b, {v2.16b}, v9.16b	/* copy plaintext to start of v7 */
+	eor	v2.16b, v2.16b, v1.16b		/* encrypt partial input block */
 	.else
-	eor	w9, w9, w6
-	eor	w7, w7, w9
+	eor	v2.16b, v2.16b, v1.16b		/* decrypt partial input block */
+	tbl	v7.16b, {v2.16b}, v9.16b	/* copy plaintext to start of v7 */
 	.endif
-	strb	w9, [x0], #1			/* store out byte */
-	strb	w7, [x5], #1			/* store mac byte */
-	subs	w2, w2, #1
-	beq	5b
-	ext	v0.16b, v0.16b, v0.16b, #1	/* shift out mac byte */
-	ext	v1.16b, v1.16b, v1.16b, #1	/* shift out ctr byte */
-	b	7b
+	eor	v0.16b, v0.16b, v7.16b		/* fold plaintext into mac */
+	tbx	v2.16b, {v6.16b}, v8.16b	/* insert output from previous iteration */
+
+	st1	{v0.16b}, [x5]			/* store mac */
+	st1	{v2.16b}, [x0]			/* store output block */
+	ret
 	.endm
 
 	/*
@@ -219,3 +228,11 @@ SYM_FUNC_END(ce_aes_ccm_encrypt)
 SYM_FUNC_START(ce_aes_ccm_decrypt)
 	aes_ccm_do_crypt	0
 SYM_FUNC_END(ce_aes_ccm_decrypt)
+
+	.section ".rodata", "a"
+	.align	6
+	.fill	15, 1, 0xff
+.Lpermute:
+	.byte	0x0, 0x1, 0x2, 0x3, 0x4, 0x5, 0x6, 0x7
+	.byte	0x8, 0x9, 0xa, 0xb, 0xc, 0xd, 0xe, 0xf
+	.fill	15, 1, 0xff
diff --git a/arch/arm64/crypto/aes-ce-ccm-glue.c b/arch/arm64/crypto/aes-ce-ccm-glue.c
index 2f4e6a318fcd..4710e59075f5 100644
--- a/arch/arm64/crypto/aes-ce-ccm-glue.c
+++ b/arch/arm64/crypto/aes-ce-ccm-glue.c
@@ -181,16 +181,16 @@ static int ccm_encrypt(struct aead_request *req)
 		if (walk.nbytes == walk.total)
 			tail = 0;
 
-		if (unlikely(walk.total < AES_BLOCK_SIZE))
-			src = dst = memcpy(buf + sizeof(buf) - walk.total,
-					   src, walk.total);
+		if (unlikely(walk.nbytes < AES_BLOCK_SIZE))
+			src = dst = memcpy(&buf[sizeof(buf) - walk.nbytes],
+					   src, walk.nbytes);
 
 		ce_aes_ccm_encrypt(dst, src, walk.nbytes - tail,
 				   ctx->key_enc, num_rounds(ctx),
 				   mac, walk.iv);
 
-		if (unlikely(walk.total < AES_BLOCK_SIZE))
-			memcpy(walk.dst.virt.addr, dst, walk.total);
+		if (unlikely(walk.nbytes < AES_BLOCK_SIZE))
+			memcpy(walk.dst.virt.addr, dst, walk.nbytes);
 
 		if (walk.nbytes == walk.total)
 			ce_aes_ccm_final(mac, orig_iv, ctx->key_enc, num_rounds(ctx));
@@ -248,16 +248,16 @@ static int ccm_decrypt(struct aead_request *req)
 		if (walk.nbytes == walk.total)
 			tail = 0;
 
-		if (unlikely(walk.total < AES_BLOCK_SIZE))
-			src = dst = memcpy(buf + sizeof(buf) - walk.total,
-					   src, walk.total);
+		if (unlikely(walk.nbytes < AES_BLOCK_SIZE))
+			src = dst = memcpy(&buf[sizeof(buf) - walk.nbytes],
+					   src, walk.nbytes);
 
 		ce_aes_ccm_decrypt(dst, src, walk.nbytes - tail,
 				   ctx->key_enc, num_rounds(ctx),
 				   mac, walk.iv);
 
-		if (unlikely(walk.total < AES_BLOCK_SIZE))
-			memcpy(walk.dst.virt.addr, dst, walk.total);
+		if (unlikely(walk.nbytes < AES_BLOCK_SIZE))
+			memcpy(walk.dst.virt.addr, dst, walk.nbytes);
 
 		if (walk.nbytes == walk.total)
 			ce_aes_ccm_final(mac, orig_iv, ctx->key_enc, num_rounds(ctx));
-- 
2.43.0.275.g3460e3d667-goog

