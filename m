Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E46822C843
	for <linux-crypto@vger.kernel.org>; Thu, 18 Jan 2024 17:07:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705597669; cv=none; b=KDTRMKDRG/OcH9rGEZDwxhl4UCFofYtS3+CadySaMkHrZWze+j75Pgo6Jz9+hms8OrLsLWi7TvGjbu8/0TuYvvPyW/opCdUDqmUWXgtEDl2ZS/Lnz6ddSoOxcC17TjL08ysmnzIiwuhktIQNxDVIw7I6J04fuZl7/THtWTNXvg4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705597669; c=relaxed/simple;
	bh=gwH56e0c63ZRWs77oxSFBaciVUVHWYbhYw5bqsppNZA=;
	h=Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Google-Smtp-Source:X-Received:Date:
	 In-Reply-To:Mime-Version:References:X-Developer-Key:
	 X-Developer-Signature:X-Mailer:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=azPyCsAoy8p6NK2qbpHMOTi68vQf2jbD2fHrqSfI7awuIW2wEDn2QYcAWy4Tl/8k4Z8sBP0spC5NXRZdhsrmRUWTuqAKtYQigvp/oZwow21zvz3RSC4j6YrcEcLWbEXjo8cFVo2i/nMlH9DzSUi6v4qw4cB8mH3sKuk9SBBRdNE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=hT8dYwzr; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="hT8dYwzr"
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-5ecfd153ccfso225585697b3.2
        for <linux-crypto@vger.kernel.org>; Thu, 18 Jan 2024 09:07:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1705597667; x=1706202467; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=MugIpKeTh5Ryctd5MeYebeB9tSZn9LJ8sjM7L85sl5s=;
        b=hT8dYwzr17gbbX4jPF9pRSqQFBi0yuSOwi2QUDxLZonQ/b8LtaecCb3lD1/Gyx3K6I
         +nYLOoXdvw27xbTiWuXoJAdcgAG7hEqU9w2YlugZGmn17etPRehlPXA8vyozzd5ectQv
         1QncdM7JPNAKYpj/NvA9jbMylnnk/CRwoBvysmtupKY8LOrCHhQuQFdsciiutcuhj917
         heUryRarzhrqxYoVrW7buGSB86doVEd20EzqKmwt4ec2/yDc/MkQpN+XOAIxHsjWOnAy
         +77crtCAJ82CntlNgwo1EF6Y1xSsFEwK7INTXy0nO1sw3qAiQOy9maoW9LjIil71DfEV
         h7ZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705597667; x=1706202467;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=MugIpKeTh5Ryctd5MeYebeB9tSZn9LJ8sjM7L85sl5s=;
        b=MGZVW9qM9z4extV+P/ApOgoNFZrH6paCve771li50chUlDwucQkc1jSyLZtY3qwVgL
         MxsuKM+cc5NMe4sifJNvEcZqNurcVflMZhQtyS0pdD3RhsPr/Fh/Cm8zRegNPESWqRXO
         obDL+LDMur8Bo9BkRuev81VBtUGtgxfh4g3YiKAvFXWxeTkrIM4AcRO2sA5c7woIgvsm
         gevpMXtCBZbZ+3KfBfGAyJo7EJgh+Y63DmKS6KMUgZbC30a02tfMHcSPvTzIDG32AazR
         zG/fXb3MJuq+I35W7L03CKO3B521KbjQisuYz/D3fzPdpkfL93cYs1A06hlRtA8aElCI
         d79g==
X-Gm-Message-State: AOJu0Yy5CgyyLbm7hwhSdSGLIqQZDYgP3GSg7nNrc0PnfnO8PrH2+seW
	4sMLbPp4uNbWc4flCJav6KYeFkWVTYmcKc1mh1x4u9FsIveNqg5HuwXUGON3beQ6gq87FQc0J/Y
	lxs6dvWfrGZN8SrOxLAMYK7lcbKwhKVncCigosztu4nWbdBOw0QHz3TmrDpD+sjsKHKah3TtvQ2
	36tZKnesoFtdRseq2Dh+kdY/hG8dgysA==
X-Google-Smtp-Source: AGHT+IFzmFGMYipPUCWCf9jhIQke5LXuXQ3dIF3FvFy0k4NF6AROINPy/3x80U2ZRc2GZ92bfBLCAfTc
X-Received: from palermo.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:118a])
 (user=ardb job=sendgmr) by 2002:a25:dc82:0:b0:dc2:23f5:1791 with SMTP id
 y124-20020a25dc82000000b00dc223f51791mr474218ybe.6.1705597666848; Thu, 18 Jan
 2024 09:07:46 -0800 (PST)
Date: Thu, 18 Jan 2024 18:06:33 +0100
In-Reply-To: <20240118170628.3049797-10-ardb+git@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240118170628.3049797-10-ardb+git@google.com>
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=3968; i=ardb@kernel.org;
 h=from:subject; bh=quStLKK0aPxXFozIrYQnjP2Hf1TbtvIgMZfqOvsyWqg=;
 b=owGbwMvMwCFmkMcZplerG8N4Wi2JIXVl1MzNXs/nZJ6/xnKh379QU9J7V11KY53qLmfmp9m1/
 OHK7godpSwMYhwMsmKKLAKz/77beXqiVK3zLFmYOaxMIEMYuDgFYCINsgz/60q0fD4pCPFVH9PI
 seWIz2sWUQ4IDg9ZXGgrsOLV+T8vGf7pOdf5PpDuF3zoGrQ3+XvBhP4Z31bOiYoLy7arsFO6UME BAA==
X-Mailer: git-send-email 2.43.0.381.gb435a96ce8-goog
Message-ID: <20240118170628.3049797-14-ardb+git@google.com>
Subject: [PATCH v2 4/8] crypto: arm64/aes-ccm - Replace bytewise tail handling
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
 1 file changed, 38 insertions(+), 21 deletions(-)

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
-- 
2.43.0.381.gb435a96ce8-goog

