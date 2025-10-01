Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CB8A3112DE
	for <linux-crypto@vger.kernel.org>; Wed,  1 Oct 2025 21:04:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759352646; cv=none; b=RNexF9uNSsXbrb+B/f6xqkhu4cwj5XiBFab6qJzc0o/h8XmtRqPgfaHyrOlvDkUpz0r+a+W8KOOXyKUnBKb0lc3HzcWgM1QLmcVmLXPh+i5v8aiXaoeJJA/jkErgw6GUBFXIVMScRCX2J+w+yENjJ45pEuKrU1yiIic7VvkFm4g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759352646; c=relaxed/simple;
	bh=zG+BMEqFMjLimSd+uHsTmtpB2rdFbSN9A/I9ca/nWJc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=elZ6YlS3LAQej1MNmj6Yr9dRqbG4AEJdLz2bSjKwD3Vgx17wn+y/eNMu6UFzzc7ULF2F+sa26yqA7chwUEqoe9vjvTzoht95zpIZBu4NaF1gTRp3aUrzqn+tt4p3T6XQkvmsCipgNDWEr6BO7yKfZvD8gXpLopnWz/t5XhKrM1Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=rET3glda; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="rET3glda"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-46e36f9c651so1713465e9.3
        for <linux-crypto@vger.kernel.org>; Wed, 01 Oct 2025 14:04:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1759352643; x=1759957443; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=wjS59fjLSBp23Zb/zP6WgADegb2YBV3/Wv9KxGpAaxY=;
        b=rET3gldaM/OfsOaOJhABFNOsJt0X/urWxae2BG/reYSOLcTMefgKohOHwsjMaaX+Md
         tmO414idunEvFOO3g4YptUeVXLjQU4YJNUNyOgbIth8vggos5uf/A4+sxbA5n4ancdow
         /nI942QGEa4ef/n38aDAMht5x87SYeE9EAYAbOSaZnpgKGSEEvGR6CJtUsVJd6tR0Ann
         gm1SzGi5DRoymfUyxBqAEqXcIRtpHC/EwTUxCB44c1C/aCaCTVohxlcAYo5/JurHLEYt
         +Y10zrS128R/joTG75nH/SYOfj91wrNI3rXb2+plvxHWGo/iwn2tA0FHtXHKPRhchJ4E
         y8mA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759352643; x=1759957443;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wjS59fjLSBp23Zb/zP6WgADegb2YBV3/Wv9KxGpAaxY=;
        b=rsS2yYTJ90ddB2/A85yDokLR48qwQLVJqdZ56B78dsuYtwEq/InslfXLOY6covzEg5
         Q40xpxnEzYqY7nxFkXGAtCNI6lfFKGeMdRtMjnuDmNdw3Pv3HhKxJrb7BTLD3mBm3umb
         tjn/se2eWfLD906wBB4tPWQHkOKis2Hk7ZpZxq1ImJIzi7deQ2YHWJ+TWISYb25rg2Td
         kTW7KwtZeDb5K7mxTyO61HVj7i/gqeq2QeawTELTYyB+t0BSEEkilfAw11uKJh1M8gND
         +pyznwnbd+8+0sUe8XNcmC/t5CcERAdfhsWEiNiyDMZNj/amlRaKyl/8Za0QGPl474Bs
         AlhA==
X-Gm-Message-State: AOJu0YwArPvAanlu/rHrpl88jUAHQ0MSCwP32Q0BOUWZoAWqrUNFs1+7
	NVEvn/5Ywh1maHtthUdFWGMRGxfTPUr2HOljLurgfAkIxP2HvvuTti2D9GjU4kN7FKudJmnbcg=
	=
X-Google-Smtp-Source: AGHT+IEuIn0Xw8cSb0i16YD4euJ4+Kdw5OD8+fY/WVV0z4DuW0G513nRxE00Rg9xEjZ/WTTSw7yU1AAt
X-Received: from wmcu7.prod.google.com ([2002:a7b:c047:0:b0:46e:3190:9ce])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:820c:b0:46e:4882:94c7
 with SMTP id 5b1f17b1804b1-46e612cb269mr38395125e9.28.1759352642677; Wed, 01
 Oct 2025 14:04:02 -0700 (PDT)
Date: Wed,  1 Oct 2025 23:02:12 +0200
In-Reply-To: <20251001210201.838686-22-ardb+git@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251001210201.838686-22-ardb+git@google.com>
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=9679; i=ardb@kernel.org;
 h=from:subject; bh=2x6PFDcDyExpe+QvLhnrBBMaZb8fzyr9//78pWmLSeM=;
 b=owGbwMvMwCVmkMcZplerG8N4Wi2JIePutC8aWtMOahe/uP15eVdzpfyKr+IGu7exxaxkcM5rX
 +RYwv2qo5SFQYyLQVZMkUVg9t93O09PlKp1niULM4eVCWQIAxenAEwkcRUjQwdTaMu7taGPZ98u
 lwx8s7Px0My84NWPth/49DM9af5WG6CKr+tNrpyZcUZph+bui8JeH/80b/1yz3l5gtNDxsddDT8 yOAA=
X-Mailer: git-send-email 2.51.0.618.g983fd99d29-goog
Message-ID: <20251001210201.838686-32-ardb+git@google.com>
Subject: [PATCH v2 10/20] lib/crypto: Switch ARM and arm64 to 'ksimd' scoped
 guard API
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
	herbert@gondor.apana.org.au, linux@armlinux.org.uk, 
	Ard Biesheuvel <ardb@kernel.org>, Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, Kees Cook <keescook@chromium.org>, 
	Catalin Marinas <catalin.marinas@arm.com>, Mark Brown <broonie@kernel.org>, 
	Eric Biggers <ebiggers@kernel.org>
Content-Type: text/plain; charset="UTF-8"

From: Ard Biesheuvel <ardb@kernel.org>

Before modifying the prototypes of kernel_neon_begin() and
kernel_neon_end() to accommodate kernel mode FP/SIMD state buffers
allocated on the stack, move arm64 to the new 'ksimd' scoped guard API,
which encapsulates the calls to those functions.

For symmetry, do the same for 32-bit ARM too.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 lib/crypto/arm/chacha-glue.c        |  6 ++----
 lib/crypto/arm/poly1305-glue.c      |  6 ++----
 lib/crypto/arm/sha1.h               | 13 ++++++-------
 lib/crypto/arm/sha256.h             | 14 +++++++-------
 lib/crypto/arm/sha512.h             |  6 +++---
 lib/crypto/arm64/chacha-neon-glue.c | 11 ++++-------
 lib/crypto/arm64/poly1305-glue.c    |  6 ++----
 lib/crypto/arm64/sha1.h             |  7 +++----
 lib/crypto/arm64/sha256.h           | 15 +++++++--------
 lib/crypto/arm64/sha512.h           |  8 ++++----
 10 files changed, 40 insertions(+), 52 deletions(-)

diff --git a/lib/crypto/arm/chacha-glue.c b/lib/crypto/arm/chacha-glue.c
index 88ec96415283..9c2e8d5edf20 100644
--- a/lib/crypto/arm/chacha-glue.c
+++ b/lib/crypto/arm/chacha-glue.c
@@ -14,7 +14,6 @@
 
 #include <asm/cputype.h>
 #include <asm/hwcap.h>
-#include <asm/neon.h>
 #include <asm/simd.h>
 
 asmlinkage void chacha_block_xor_neon(const struct chacha_state *state,
@@ -90,9 +89,8 @@ void chacha_crypt_arch(struct chacha_state *state, u8 *dst, const u8 *src,
 	do {
 		unsigned int todo = min_t(unsigned int, bytes, SZ_4K);
 
-		kernel_neon_begin();
-		chacha_doneon(state, dst, src, todo, nrounds);
-		kernel_neon_end();
+		scoped_ksimd()
+			chacha_doneon(state, dst, src, todo, nrounds);
 
 		bytes -= todo;
 		src += todo;
diff --git a/lib/crypto/arm/poly1305-glue.c b/lib/crypto/arm/poly1305-glue.c
index 2d86c78af883..3e4624477e9f 100644
--- a/lib/crypto/arm/poly1305-glue.c
+++ b/lib/crypto/arm/poly1305-glue.c
@@ -6,7 +6,6 @@
  */
 
 #include <asm/hwcap.h>
-#include <asm/neon.h>
 #include <asm/simd.h>
 #include <crypto/internal/poly1305.h>
 #include <linux/cpufeature.h>
@@ -39,9 +38,8 @@ void poly1305_blocks_arch(struct poly1305_block_state *state, const u8 *src,
 		do {
 			unsigned int todo = min_t(unsigned int, len, SZ_4K);
 
-			kernel_neon_begin();
-			poly1305_blocks_neon(state, src, todo, padbit);
-			kernel_neon_end();
+			scoped_ksimd()
+				poly1305_blocks_neon(state, src, todo, padbit);
 
 			len -= todo;
 			src += todo;
diff --git a/lib/crypto/arm/sha1.h b/lib/crypto/arm/sha1.h
index fa1e92419000..a4296ffefd05 100644
--- a/lib/crypto/arm/sha1.h
+++ b/lib/crypto/arm/sha1.h
@@ -4,7 +4,6 @@
  *
  * Copyright 2025 Google LLC
  */
-#include <asm/neon.h>
 #include <asm/simd.h>
 
 static __ro_after_init DEFINE_STATIC_KEY_FALSE(have_neon);
@@ -22,12 +21,12 @@ static void sha1_blocks(struct sha1_block_state *state,
 {
 	if (IS_ENABLED(CONFIG_KERNEL_MODE_NEON) &&
 	    static_branch_likely(&have_neon) && likely(may_use_simd())) {
-		kernel_neon_begin();
-		if (static_branch_likely(&have_ce))
-			sha1_ce_transform(state, data, nblocks);
-		else
-			sha1_transform_neon(state, data, nblocks);
-		kernel_neon_end();
+		scoped_ksimd() {
+			if (static_branch_likely(&have_ce))
+				sha1_ce_transform(state, data, nblocks);
+			else
+				sha1_transform_neon(state, data, nblocks);
+		}
 	} else {
 		sha1_block_data_order(state, data, nblocks);
 	}
diff --git a/lib/crypto/arm/sha256.h b/lib/crypto/arm/sha256.h
index da75cbdc51d4..df861cc5b9ff 100644
--- a/lib/crypto/arm/sha256.h
+++ b/lib/crypto/arm/sha256.h
@@ -4,7 +4,7 @@
  *
  * Copyright 2025 Google LLC
  */
-#include <asm/neon.h>
+#include <asm/simd.h>
 #include <crypto/internal/simd.h>
 
 asmlinkage void sha256_block_data_order(struct sha256_block_state *state,
@@ -22,12 +22,12 @@ static void sha256_blocks(struct sha256_block_state *state,
 {
 	if (IS_ENABLED(CONFIG_KERNEL_MODE_NEON) &&
 	    static_branch_likely(&have_neon) && crypto_simd_usable()) {
-		kernel_neon_begin();
-		if (static_branch_likely(&have_ce))
-			sha256_ce_transform(state, data, nblocks);
-		else
-			sha256_block_data_order_neon(state, data, nblocks);
-		kernel_neon_end();
+		scoped_ksimd() {
+			if (static_branch_likely(&have_ce))
+				sha256_ce_transform(state, data, nblocks);
+			else
+				sha256_block_data_order_neon(state, data, nblocks);
+		}
 	} else {
 		sha256_block_data_order(state, data, nblocks);
 	}
diff --git a/lib/crypto/arm/sha512.h b/lib/crypto/arm/sha512.h
index f147b6490d6c..35b80e7e7db7 100644
--- a/lib/crypto/arm/sha512.h
+++ b/lib/crypto/arm/sha512.h
@@ -6,6 +6,7 @@
  */
 
 #include <asm/neon.h>
+#include <asm/simd.h>
 #include <crypto/internal/simd.h>
 
 static __ro_after_init DEFINE_STATIC_KEY_FALSE(have_neon);
@@ -20,9 +21,8 @@ static void sha512_blocks(struct sha512_block_state *state,
 {
 	if (IS_ENABLED(CONFIG_KERNEL_MODE_NEON) &&
 	    static_branch_likely(&have_neon) && likely(crypto_simd_usable())) {
-		kernel_neon_begin();
-		sha512_block_data_order_neon(state, data, nblocks);
-		kernel_neon_end();
+		scoped_ksimd()
+			sha512_block_data_order_neon(state, data, nblocks);
 	} else {
 		sha512_block_data_order(state, data, nblocks);
 	}
diff --git a/lib/crypto/arm64/chacha-neon-glue.c b/lib/crypto/arm64/chacha-neon-glue.c
index d0188f974ca5..a3d109f0ce1e 100644
--- a/lib/crypto/arm64/chacha-neon-glue.c
+++ b/lib/crypto/arm64/chacha-neon-glue.c
@@ -25,7 +25,6 @@
 #include <linux/module.h>
 
 #include <asm/hwcap.h>
-#include <asm/neon.h>
 #include <asm/simd.h>
 
 asmlinkage void chacha_block_xor_neon(const struct chacha_state *state,
@@ -67,9 +66,8 @@ void hchacha_block_arch(const struct chacha_state *state,
 	if (!static_branch_likely(&have_neon) || !crypto_simd_usable()) {
 		hchacha_block_generic(state, out, nrounds);
 	} else {
-		kernel_neon_begin();
-		hchacha_block_neon(state, out, nrounds);
-		kernel_neon_end();
+		scoped_ksimd()
+			hchacha_block_neon(state, out, nrounds);
 	}
 }
 EXPORT_SYMBOL(hchacha_block_arch);
@@ -84,9 +82,8 @@ void chacha_crypt_arch(struct chacha_state *state, u8 *dst, const u8 *src,
 	do {
 		unsigned int todo = min_t(unsigned int, bytes, SZ_4K);
 
-		kernel_neon_begin();
-		chacha_doneon(state, dst, src, todo, nrounds);
-		kernel_neon_end();
+		scoped_ksimd()
+			chacha_doneon(state, dst, src, todo, nrounds);
 
 		bytes -= todo;
 		src += todo;
diff --git a/lib/crypto/arm64/poly1305-glue.c b/lib/crypto/arm64/poly1305-glue.c
index 31aea21ce42f..c83ce7d835d9 100644
--- a/lib/crypto/arm64/poly1305-glue.c
+++ b/lib/crypto/arm64/poly1305-glue.c
@@ -6,7 +6,6 @@
  */
 
 #include <asm/hwcap.h>
-#include <asm/neon.h>
 #include <asm/simd.h>
 #include <crypto/internal/poly1305.h>
 #include <linux/cpufeature.h>
@@ -38,9 +37,8 @@ void poly1305_blocks_arch(struct poly1305_block_state *state, const u8 *src,
 		do {
 			unsigned int todo = min_t(unsigned int, len, SZ_4K);
 
-			kernel_neon_begin();
-			poly1305_blocks_neon(state, src, todo, padbit);
-			kernel_neon_end();
+			scoped_ksimd()
+				poly1305_blocks_neon(state, src, todo, padbit);
 
 			len -= todo;
 			src += todo;
diff --git a/lib/crypto/arm64/sha1.h b/lib/crypto/arm64/sha1.h
index f822563538cc..3d0da0045fed 100644
--- a/lib/crypto/arm64/sha1.h
+++ b/lib/crypto/arm64/sha1.h
@@ -4,7 +4,6 @@
  *
  * Copyright 2025 Google LLC
  */
-#include <asm/neon.h>
 #include <asm/simd.h>
 #include <linux/cpufeature.h>
 
@@ -20,9 +19,9 @@ static void sha1_blocks(struct sha1_block_state *state,
 		do {
 			size_t rem;
 
-			kernel_neon_begin();
-			rem = __sha1_ce_transform(state, data, nblocks);
-			kernel_neon_end();
+			scoped_ksimd()
+				rem = __sha1_ce_transform(state, data, nblocks);
+
 			data += (nblocks - rem) * SHA1_BLOCK_SIZE;
 			nblocks = rem;
 		} while (nblocks);
diff --git a/lib/crypto/arm64/sha256.h b/lib/crypto/arm64/sha256.h
index a211966c124a..0a9f9d70bb43 100644
--- a/lib/crypto/arm64/sha256.h
+++ b/lib/crypto/arm64/sha256.h
@@ -4,7 +4,7 @@
  *
  * Copyright 2025 Google LLC
  */
-#include <asm/neon.h>
+#include <asm/simd.h>
 #include <crypto/internal/simd.h>
 #include <linux/cpufeature.h>
 
@@ -27,17 +27,16 @@ static void sha256_blocks(struct sha256_block_state *state,
 			do {
 				size_t rem;
 
-				kernel_neon_begin();
-				rem = __sha256_ce_transform(state,
-							    data, nblocks);
-				kernel_neon_end();
+				scoped_ksimd()
+					rem = __sha256_ce_transform(state, data,
+								    nblocks);
+
 				data += (nblocks - rem) * SHA256_BLOCK_SIZE;
 				nblocks = rem;
 			} while (nblocks);
 		} else {
-			kernel_neon_begin();
-			sha256_block_neon(state, data, nblocks);
-			kernel_neon_end();
+			scoped_ksimd()
+				sha256_block_neon(state, data, nblocks);
 		}
 	} else {
 		sha256_block_data_order(state, data, nblocks);
diff --git a/lib/crypto/arm64/sha512.h b/lib/crypto/arm64/sha512.h
index 6abb40b467f2..1b6c3974d553 100644
--- a/lib/crypto/arm64/sha512.h
+++ b/lib/crypto/arm64/sha512.h
@@ -5,7 +5,7 @@
  * Copyright 2025 Google LLC
  */
 
-#include <asm/neon.h>
+#include <asm/simd.h>
 #include <crypto/internal/simd.h>
 #include <linux/cpufeature.h>
 
@@ -25,9 +25,9 @@ static void sha512_blocks(struct sha512_block_state *state,
 		do {
 			size_t rem;
 
-			kernel_neon_begin();
-			rem = __sha512_ce_transform(state, data, nblocks);
-			kernel_neon_end();
+			scoped_ksimd()
+				rem = __sha512_ce_transform(state, data, nblocks);
+
 			data += (nblocks - rem) * SHA512_BLOCK_SIZE;
 			nblocks = rem;
 		} while (nblocks);
-- 
2.51.0.618.g983fd99d29-goog

