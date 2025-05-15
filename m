Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D73A153800
	for <linux-crypto@vger.kernel.org>; Thu, 15 May 2025 14:27:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747319242; cv=none; b=llu3SoVzNhlbgd58X9O9EYThtGr5xzGEB8rK2aPp7Y8MSSsB5jeIU3oUREAuJabjng0BONNBvHXMrG2SNwhRzJj0Sy5XQF/M784jzD+rXVXqJjv6KNiiWX2pTFM/Qkl15HZ/gpS1bmx8CEeILCXGAXyQluVo9GkyS29gu188W1M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747319242; c=relaxed/simple;
	bh=/kDbsfT44aoLlAqKuvpgu+LStBXAwgol9QgzQln2Kek=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=JZ7vWULgQ+piinpX/XcgZ8VXrfPIWy9uytsM1B9/jQO3dmekq4Y25Aqod2zm+gE2UHqKL4FBCZzDiOQmNKJrMZZKdtBlpqQMkTpL+9jZlV8LMK7OU7wcD6Qysktz/SZ5/peNMtnYhdf6vjMYXTSRLLkP8BxDMSMK0T/lW+jh8us=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=KrLTrdx0; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="KrLTrdx0"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-442cd12d151so7685615e9.1
        for <linux-crypto@vger.kernel.org>; Thu, 15 May 2025 07:27:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747319237; x=1747924037; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=IPogphGbrEpR3QBLdoY3zq221jsJuMh2u53C5NvwS2Q=;
        b=KrLTrdx0JcURa+dFw5jfXDvtsNxB23RlQawZFUWCSsNNIF8UbnoXCvq0TzLHdlAzfj
         5y4B4qoWS+Ke00MZVpKNd67dD9vwvUrkeQ8ORb9dbnV5sl1XTP8J9ahLaGIpoL2NHUt2
         RhLv9oPgsCqrnQQo7YpAcsoWnvPLAvQ1pDH0TZpcu5vw4klDLBNtYyzltde7EE5isjIB
         E0kkNFkkz86pmHLN9wDToKubumC4VCMIyYNnnt7dqw9qgQzkfnLbwuKlFUfYZRphjPhR
         ka8PjYG0Oj5Tx8WsEYqUlsVotgGzEq0tgSk3xbeEKT5+FhNMJfiABr9EqI+arzL247wX
         ufmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747319237; x=1747924037;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=IPogphGbrEpR3QBLdoY3zq221jsJuMh2u53C5NvwS2Q=;
        b=YTGUcevEbe7rLXxFM+4++EzdnFJb7we8ZgLHaEmvIaJNue8mXazmkRKomW/KY/mGV5
         LVfuKXP45wzlbXgN2Au8zbEyZdj1VsZrPm1V9WdjSLtFTz+V3GcR1QKPNDcGR/G7c+En
         JvNBz8J8vRZnumn2OAHTzEw1xLHh3pHTeuC0Q+GQaFclVhLZciSuHgYbabw8Do7p8bRQ
         63NnjvU7oBcMLytzigxIZRoeMa5mtSBmVLF+ltEba5e7R1BLs9kJE61E7Qk9OF4cKgHO
         FWDh9RVIblWt1kg0JQE/kLqzk+GRcpzv4Ys7E5JQs34RoB9nmIPvJS0jAfyG1w1IsdUm
         68PA==
X-Gm-Message-State: AOJu0YztTF2UDVx9YnLJQO7p9x2TNJb6HCvfxnNVG4YIv/CkJSxbX0kw
	8xK7pNMdVcmiGIsu9wu0+0zieh6NWqthM69O8ZJFkZF3tOezYO9gUH6Yvj4tR0U1ND3xT4ASih3
	SEYt8GvQfx00omuZy6K7EXSyRnANqP9h839fc29CFMDtfmmEjQJqZ1t8q2t5/u9wD945Rvbaxo7
	MFng1uGvjTHWl2XU4D9LaqNNqyve98uw==
X-Google-Smtp-Source: AGHT+IFFsCgdakG5u4bEFXO2J5LKqOHIG9Zn7He//Wb/roAQpWxVzwumPw1uqPb5QXelrTfoVthC6PGR
X-Received: from wmbhj24.prod.google.com ([2002:a05:600c:5298:b0:442:cd17:732c])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:1e84:b0:43c:f64c:44a4
 with SMTP id 5b1f17b1804b1-442f97a5d2amr27534375e9.8.1747319236918; Thu, 15
 May 2025 07:27:16 -0700 (PDT)
Date: Thu, 15 May 2025 16:27:03 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=6048; i=ardb@kernel.org;
 h=from:subject; bh=qvxJ+h9gMcNlJUb5JcUPXfq+gkLOGOQD7jPdNNZG/eU=;
 b=owGbwMvMwCFmkMcZplerG8N4Wi2JIUP157bEGwvfiEtuXG0n+WJpYkLa1y+PstQCvhVuE87eF
 fGk+o1eRykLgxgHg6yYIovA7L/vdp6eKFXrPEsWZg4rE8gQBi5OAZjIiVqGf0qGlx7ecXp289W/
 NSYznmh2r1vP+FON1/4b3xJH35o5TY8ZGTZsdPu//BhHz0nujWmy09pL5eYmh5zzOfXVqNxcLlH 4NgcA
X-Mailer: git-send-email 2.49.0.1101.gccaa498523-goog
Message-ID: <20250515142702.2592942-2-ardb+git@google.com>
Subject: [PATCH] crypto: arm64 - Drop asm fallback macros for older binutils
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-crypto@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, ebiggers@kernel.org, 
	herbert@gondor.apana.org.au, Ard Biesheuvel <ardb@kernel.org>
Content-Type: text/plain; charset="UTF-8"

From: Ard Biesheuvel <ardb@kernel.org>

Now that the oldest supported binutils version is 2.30, the asm macros
to implement the various crypto opcodes for SHA-512, SHA-3, SM-3 and
SM-4 are no longer needed. So drop them.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
The binutils version bump is queued up in -next, so I suppose this could
be queued up for the next cycle too.

 arch/arm64/crypto/sha3-ce-core.S    | 24 +------------
 arch/arm64/crypto/sha512-ce-core.S  | 21 +-----------
 arch/arm64/crypto/sm3-ce-core.S     | 36 ++------------------
 arch/arm64/crypto/sm4-ce-ccm-core.S | 10 +-----
 arch/arm64/crypto/sm4-ce-core.S     | 15 +-------
 arch/arm64/crypto/sm4-ce-gcm-core.S | 10 +-----
 6 files changed, 8 insertions(+), 108 deletions(-)

diff --git a/arch/arm64/crypto/sha3-ce-core.S b/arch/arm64/crypto/sha3-ce-core.S
index 9c77313f5a60..61623c7ad3a1 100644
--- a/arch/arm64/crypto/sha3-ce-core.S
+++ b/arch/arm64/crypto/sha3-ce-core.S
@@ -12,29 +12,7 @@
 #include <linux/linkage.h>
 #include <asm/assembler.h>
 
-	.irp	b,0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31
-	.set	.Lv\b\().2d, \b
-	.set	.Lv\b\().16b, \b
-	.endr
-
-	/*
-	 * ARMv8.2 Crypto Extensions instructions
-	 */
-	.macro	eor3, rd, rn, rm, ra
-	.inst	0xce000000 | .L\rd | (.L\rn << 5) | (.L\ra << 10) | (.L\rm << 16)
-	.endm
-
-	.macro	rax1, rd, rn, rm
-	.inst	0xce608c00 | .L\rd | (.L\rn << 5) | (.L\rm << 16)
-	.endm
-
-	.macro	bcax, rd, rn, rm, ra
-	.inst	0xce200000 | .L\rd | (.L\rn << 5) | (.L\ra << 10) | (.L\rm << 16)
-	.endm
-
-	.macro	xar, rd, rn, rm, imm6
-	.inst	0xce800000 | .L\rd | (.L\rn << 5) | ((\imm6) << 10) | (.L\rm << 16)
-	.endm
+	.arch	armv8-a+sha3
 
 	/*
 	 * int sha3_ce_transform(u64 *st, const u8 *data, int blocks, int dg_size)
diff --git a/arch/arm64/crypto/sha512-ce-core.S b/arch/arm64/crypto/sha512-ce-core.S
index 91ef68b15fcc..deb2469ab631 100644
--- a/arch/arm64/crypto/sha512-ce-core.S
+++ b/arch/arm64/crypto/sha512-ce-core.S
@@ -12,26 +12,7 @@
 #include <linux/linkage.h>
 #include <asm/assembler.h>
 
-	.irp		b,0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19
-	.set		.Lq\b, \b
-	.set		.Lv\b\().2d, \b
-	.endr
-
-	.macro		sha512h, rd, rn, rm
-	.inst		0xce608000 | .L\rd | (.L\rn << 5) | (.L\rm << 16)
-	.endm
-
-	.macro		sha512h2, rd, rn, rm
-	.inst		0xce608400 | .L\rd | (.L\rn << 5) | (.L\rm << 16)
-	.endm
-
-	.macro		sha512su0, rd, rn
-	.inst		0xcec08000 | .L\rd | (.L\rn << 5)
-	.endm
-
-	.macro		sha512su1, rd, rn, rm
-	.inst		0xce608800 | .L\rd | (.L\rn << 5) | (.L\rm << 16)
-	.endm
+	.arch	armv8-a+sha3
 
 	/*
 	 * The SHA-512 round constants
diff --git a/arch/arm64/crypto/sm3-ce-core.S b/arch/arm64/crypto/sm3-ce-core.S
index ca70cfacd0d0..94a97ca367f0 100644
--- a/arch/arm64/crypto/sm3-ce-core.S
+++ b/arch/arm64/crypto/sm3-ce-core.S
@@ -9,44 +9,14 @@
 #include <linux/cfi_types.h>
 #include <asm/assembler.h>
 
-	.irp		b, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12
-	.set		.Lv\b\().4s, \b
-	.endr
-
-	.macro		sm3partw1, rd, rn, rm
-	.inst		0xce60c000 | .L\rd | (.L\rn << 5) | (.L\rm << 16)
-	.endm
-
-	.macro		sm3partw2, rd, rn, rm
-	.inst		0xce60c400 | .L\rd | (.L\rn << 5) | (.L\rm << 16)
-	.endm
-
-	.macro		sm3ss1, rd, rn, rm, ra
-	.inst		0xce400000 | .L\rd | (.L\rn << 5) | (.L\ra << 10) | (.L\rm << 16)
-	.endm
-
-	.macro		sm3tt1a, rd, rn, rm, imm2
-	.inst		0xce408000 | .L\rd | (.L\rn << 5) | ((\imm2) << 12) | (.L\rm << 16)
-	.endm
-
-	.macro		sm3tt1b, rd, rn, rm, imm2
-	.inst		0xce408400 | .L\rd | (.L\rn << 5) | ((\imm2) << 12) | (.L\rm << 16)
-	.endm
-
-	.macro		sm3tt2a, rd, rn, rm, imm2
-	.inst		0xce408800 | .L\rd | (.L\rn << 5) | ((\imm2) << 12) | (.L\rm << 16)
-	.endm
-
-	.macro		sm3tt2b, rd, rn, rm, imm2
-	.inst		0xce408c00 | .L\rd | (.L\rn << 5) | ((\imm2) << 12) | (.L\rm << 16)
-	.endm
+	.arch		armv8-a+sm4
 
 	.macro		round, ab, s0, t0, t1, i
 	sm3ss1		v5.4s, v8.4s, \t0\().4s, v9.4s
 	shl		\t1\().4s, \t0\().4s, #1
 	sri		\t1\().4s, \t0\().4s, #31
-	sm3tt1\ab	v8.4s, v5.4s, v10.4s, \i
-	sm3tt2\ab	v9.4s, v5.4s, \s0\().4s, \i
+	sm3tt1\ab	v8.4s, v5.4s, v10.s[\i]
+	sm3tt2\ab	v9.4s, v5.4s, \s0\().s[\i]
 	.endm
 
 	.macro		qround, ab, s0, s1, s2, s3, s4
diff --git a/arch/arm64/crypto/sm4-ce-ccm-core.S b/arch/arm64/crypto/sm4-ce-ccm-core.S
index fa85856f33ce..b658cf2577d1 100644
--- a/arch/arm64/crypto/sm4-ce-ccm-core.S
+++ b/arch/arm64/crypto/sm4-ce-ccm-core.S
@@ -12,15 +12,7 @@
 #include <asm/assembler.h>
 #include "sm4-ce-asm.h"
 
-.arch	armv8-a+crypto
-
-.irp b, 0, 1, 8, 9, 10, 11, 12, 13, 14, 15, 16, 24, 25, 26, 27, 28, 29, 30, 31
-	.set .Lv\b\().4s, \b
-.endr
-
-.macro sm4e, vd, vn
-	.inst 0xcec08400 | (.L\vn << 5) | .L\vd
-.endm
+.arch	armv8-a+sm4
 
 /* Register macros */
 
diff --git a/arch/arm64/crypto/sm4-ce-core.S b/arch/arm64/crypto/sm4-ce-core.S
index 1f3625c2c67e..dd4e86b0a526 100644
--- a/arch/arm64/crypto/sm4-ce-core.S
+++ b/arch/arm64/crypto/sm4-ce-core.S
@@ -12,20 +12,7 @@
 #include <asm/assembler.h>
 #include "sm4-ce-asm.h"
 
-.arch	armv8-a+crypto
-
-.irp b, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, \
-		20, 24, 25, 26, 27, 28, 29, 30, 31
-	.set .Lv\b\().4s, \b
-.endr
-
-.macro sm4e, vd, vn
-	.inst 0xcec08400 | (.L\vn << 5) | .L\vd
-.endm
-
-.macro sm4ekey, vd, vn, vm
-	.inst 0xce60c800 | (.L\vm << 16) | (.L\vn << 5) | .L\vd
-.endm
+.arch	armv8-a+sm4
 
 /* Register macros */
 
diff --git a/arch/arm64/crypto/sm4-ce-gcm-core.S b/arch/arm64/crypto/sm4-ce-gcm-core.S
index 347f25d75727..92d26d8a9254 100644
--- a/arch/arm64/crypto/sm4-ce-gcm-core.S
+++ b/arch/arm64/crypto/sm4-ce-gcm-core.S
@@ -13,15 +13,7 @@
 #include <asm/assembler.h>
 #include "sm4-ce-asm.h"
 
-.arch	armv8-a+crypto
-
-.irp b, 0, 1, 2, 3, 24, 25, 26, 27, 28, 29, 30, 31
-	.set .Lv\b\().4s, \b
-.endr
-
-.macro sm4e, vd, vn
-	.inst 0xcec08400 | (.L\vn << 5) | .L\vd
-.endm
+	.arch		armv8-a+sm4+aes
 
 /* Register macros */
 
-- 
2.49.0.1101.gccaa498523-goog

