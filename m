Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E95B92C842
	for <linux-crypto@vger.kernel.org>; Thu, 18 Jan 2024 17:07:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705597676; cv=none; b=QSerL/ioI0dpmo1z72TONelQmWkcbfVYJCyZt1L3YkNzlAZCYwO4mX3QeWwurkdZ0QiMrUqJtsqUMc2Ozaskx3xBxqoLrNGF1gaWCg1Y2J9IookaUorEaum2d3pZYrCC3H/AZoNd1QzOMv7c/4CrNjMw30gLK2e8ZduJk9KNu2E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705597676; c=relaxed/simple;
	bh=P8ZS8tnkvpafVPNfBL+HYmJ3VqCNBCKke6HdO3S7Qts=;
	h=Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Google-Smtp-Source:X-Received:Date:
	 In-Reply-To:Mime-Version:References:X-Developer-Key:
	 X-Developer-Signature:X-Mailer:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=FrP+FQlXYNG+c2ETle8GdhR57PjPrEaAyw8z7ln1hOuTYF+F8i1VWhUgmm3lgYQlI3C9YjcpZLQHAElnHvfvx52Dm0IBmLNuXGCFsQGmqVCbkR62An6E70byZ89acVN41H0N/AR5/3/Z3avQroWo8oMXjXF8wM7uJXcxbDuzCFA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=fmGqiKas; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="fmGqiKas"
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-dc221ed88d9so4925856276.3
        for <linux-crypto@vger.kernel.org>; Thu, 18 Jan 2024 09:07:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1705597674; x=1706202474; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=s9Xi02Cj/kvnksvbQxFMC/EAI5U7xlC86fT0j1fgH/w=;
        b=fmGqiKasapW9RC4S7YCMEeMNSou4PMsbG5j5xVrYm5oGd+YNMW28vGeIYiGkJvgOSF
         /GJ8UwPVjE/A2VJq4j5XSF3W4zEKnj3qTFe86CU+6uYXZAXLfp3AKGFYfzD+0SQCeJQF
         K/ZAtde2MqobjpbSxZqK8+nGowC+cPT52A/tt2D48qA24giRBoXI/ns74ylb3C8l7JZM
         O1PbR8cwJCWxVh5mwjqfRZxP0P7sRz9QUz8cia2ODeJyPfUzcpHN5SJO8S18npX2gn3G
         fOd+E5e+Yb+mQQmdqCoF9Nd0WXTXBrj2SH1/uuYr7ua4sR+BZg699s4fPeBAm3x/XCsV
         25Jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705597674; x=1706202474;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=s9Xi02Cj/kvnksvbQxFMC/EAI5U7xlC86fT0j1fgH/w=;
        b=H6Pv8nrSCCvW9AYOEoK1FWKpTBH6iKIsWSr2aRNlS4k1UPKIJGNfOaYM4PzSSkuNSq
         Wmjh340gqPbQldJVTPss1APxVZV/BS0vfZ9xGvNHgg9tJ8w7ffVN/ElcQgtj/YMfttUX
         jy35Hs0uF1jUJgmELjMspSJGIjrvUFPmbbY3q67aN2slrzdODUriALO7YzkIlW6uQ1y+
         FQTA+xL5A8lmloqDXbNF6VI0533frHWn/gl7gDezgiU64xxL6SyNzeAanMkq5N0PRawT
         Rip/BHZRrhDYyN2IDnEw++PQsnc2a0O13tg3MZ9eNVWHFTpWdvWnBmoudK0WxYZxitsb
         WUsw==
X-Gm-Message-State: AOJu0YxJGz1yGHA2b0Bk+GJEDoVKklRcrB2hCXBjBfxPH4MRucvS7Dy2
	6rXURLFMK/JInMYEnutN+vrzkSD3BmAS8oHJRRXBqHFUQbz09lEGSx8XiKTddPurLXuBTsoIlJ1
	ZrfOgwUFwmORMFsCTA1iomNrAusv6YHEoNntNLi32yz7D5RlINlsEbzgNbLDqK6y2LYQ/T5gc/o
	td3LrCJuiTPBhFuiOHJhxWvS54lATPzA==
X-Google-Smtp-Source: AGHT+IHYaFErAT8pg8KMTc/iQW4EQYkdOrynw1i4wcwKw1v+e8+uezrSPAhWSFVEQP0rzzAQc5I8+6WH
X-Received: from palermo.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:118a])
 (user=ardb job=sendgmr) by 2002:a05:6902:2705:b0:dbd:73bd:e55a with SMTP id
 dz5-20020a056902270500b00dbd73bde55amr65386ybb.4.1705597674009; Thu, 18 Jan
 2024 09:07:54 -0800 (PST)
Date: Thu, 18 Jan 2024 18:06:36 +0100
In-Reply-To: <20240118170628.3049797-10-ardb+git@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240118170628.3049797-10-ardb+git@google.com>
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=3338; i=ardb@kernel.org;
 h=from:subject; bh=qGTwt2Caay9GHLXmY5Vb1w8QJbkrtTgRZpTpYGzKVU0=;
 b=owGbwMvMwCFmkMcZplerG8N4Wi2JIXVl1JzEDtOPKTMj+E7MqH5xsHBK341mifNPN/b3nNnwS
 4A3OXxRRykLgxgHg6yYIovA7L/vdp6eKFXrPEsWZg4rE8gQBi5OAZhI8XaGPxzL9j+d9irx6Z4V
 Zu0VR003Xz0581Xyq8jsdza1zZPc/XoY/unNjH0n8dLcVmH2xX6zT69kQyZeKbO1kvVY/t5M85P 5Tj4A
X-Mailer: git-send-email 2.43.0.381.gb435a96ce8-goog
Message-ID: <20240118170628.3049797-17-ardb+git@google.com>
Subject: [PATCH v2 7/8] crypto: arm64/aes-ccm - Merge encrypt and decrypt tail handling
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-crypto@vger.kernel.org
Cc: ebiggers@kernel.org, herbert@gondor.apana.org.au, 
	Ard Biesheuvel <ardb@kernel.org>
Content-Type: text/plain; charset="UTF-8"

From: Ard Biesheuvel <ardb@kernel.org>

The encryption and decryption code paths are mostly identical, except
for a small difference where the plaintext input into the MAC is taken
from either the input or the output block.

We can factor this in quite easily using a vector bit select, and a few
additional XORs, without the need for branches. This way, we can use the
same tail handling logic on the encrypt and decrypt code paths, allowing
further consolidation of the asm helpers in a subsequent patch.

(In the main loop, adding just a handful of ALU instructions results in
a noticeable performance hit [around 5% on Apple M2], so those routines
are kept separate)

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/arm64/crypto/aes-ce-ccm-core.S | 26 ++++++++++----------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff --git a/arch/arm64/crypto/aes-ce-ccm-core.S b/arch/arm64/crypto/aes-ce-ccm-core.S
index 0ec59fc4ef3e..bf3a888a5615 100644
--- a/arch/arm64/crypto/aes-ce-ccm-core.S
+++ b/arch/arm64/crypto/aes-ce-ccm-core.S
@@ -77,7 +77,7 @@ CPU_LE(	rev	x8, x8			)	/* keep swabbed ctr in reg */
 	aes_encrypt	v0, v1, w4
 
 	subs	w2, w2, #16
-	bmi	6f				/* partial block? */
+	bmi	ce_aes_ccm_crypt_tail
 	ld1	{v2.16b}, [x1], #16		/* load next input block */
 	.if	\enc == 1
 	eor	v2.16b, v2.16b, v5.16b		/* final round enc+mac */
@@ -93,8 +93,10 @@ CPU_LE(	rev	x8, x8			)
 	st1	{v0.16b}, [x5]			/* store mac */
 	str	x8, [x6, #8]			/* store lsb end of ctr (BE) */
 5:	ret
+	.endm
 
-6:	eor	v0.16b, v0.16b, v5.16b		/* final round mac */
+SYM_FUNC_START_LOCAL(ce_aes_ccm_crypt_tail)
+	eor	v0.16b, v0.16b, v5.16b		/* final round mac */
 	eor	v1.16b, v1.16b, v5.16b		/* final round enc */
 
 	add	x1, x1, w2, sxtw		/* rewind the input pointer (w2 < 0) */
@@ -108,20 +110,16 @@ CPU_LE(	rev	x8, x8			)
 
 	ld1	{v2.16b}, [x1]			/* load a full block of input */
 	tbl	v1.16b, {v1.16b}, v7.16b	/* move keystream to end of register */
-	.if	\enc == 1
-	tbl	v7.16b, {v2.16b}, v9.16b	/* copy plaintext to start of v7 */
-	eor	v2.16b, v2.16b, v1.16b		/* encrypt partial input block */
-	.else
-	eor	v2.16b, v2.16b, v1.16b		/* decrypt partial input block */
-	tbl	v7.16b, {v2.16b}, v9.16b	/* copy plaintext to start of v7 */
-	.endif
-	eor	v0.16b, v0.16b, v7.16b		/* fold plaintext into mac */
-	tbx	v2.16b, {v6.16b}, v8.16b	/* insert output from previous iteration */
+	eor	v7.16b, v2.16b, v1.16b		/* encrypt partial input block */
+	bif	v2.16b, v7.16b, v22.16b		/* select plaintext */
+	tbx	v7.16b, {v6.16b}, v8.16b	/* insert output from previous iteration */
+	tbl	v2.16b, {v2.16b}, v9.16b	/* copy plaintext to start of v2 */
+	eor	v0.16b, v0.16b, v2.16b		/* fold plaintext into mac */
 
 	st1	{v0.16b}, [x5]			/* store mac */
-	st1	{v2.16b}, [x0]			/* store output block */
+	st1	{v7.16b}, [x0]			/* store output block */
 	ret
-	.endm
+SYM_FUNC_END(ce_aes_ccm_crypt_tail)
 
 	/*
 	 * void ce_aes_ccm_encrypt(u8 out[], u8 const in[], u32 cbytes,
@@ -132,10 +130,12 @@ CPU_LE(	rev	x8, x8			)
 	 * 			   u8 ctr[]);
 	 */
 SYM_FUNC_START(ce_aes_ccm_encrypt)
+	movi	v22.16b, #255
 	aes_ccm_do_crypt	1
 SYM_FUNC_END(ce_aes_ccm_encrypt)
 
 SYM_FUNC_START(ce_aes_ccm_decrypt)
+	movi	v22.16b, #0
 	aes_ccm_do_crypt	0
 SYM_FUNC_END(ce_aes_ccm_decrypt)
 
-- 
2.43.0.381.gb435a96ce8-goog

