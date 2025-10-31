Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 863203446B2
	for <linux-crypto@vger.kernel.org>; Fri, 31 Oct 2025 10:39:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761907198; cv=none; b=GQuH4rC0nDraVGR96npn2/4ZavMYebekmBImmuDxrJNKrQ2UG4n2hMEQ+o73L4eCf92GDB0/8SrJ9JV7cz5TAbTH24ieafxhr8LlyqdgFw44JMHA9PU/6+D95BUUUbFfvH5sp+isguyP7jYcE4+KUYwlSpBQzBoJ+2UOmidpeOw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761907198; c=relaxed/simple;
	bh=micg+uwnrglgHVal5EtYXqgPUjbxDWvBRDhUQ3SFgjA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=M6fJJtLuJUo4krSZQ+/IfWgjWKaKj1Wwa+LcRzV1hFQ57cm9++SaKDwjVLSqyX6m4RRrfaSdu0SV1ajgqyatLZDL5FyP8rHsOsF53AAxhNdZc8C4I/SFs6QbdysshSwOlDu8fMYTcOzjrApGFF9dLreTh+HaX+98uGTljucQUus=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ZeYciOut; arc=none smtp.client-ip=209.85.221.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ZeYciOut"
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-429b7b46eebso1812185f8f.2
        for <linux-crypto@vger.kernel.org>; Fri, 31 Oct 2025 03:39:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761907195; x=1762511995; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=nlol8jlCrwU+dDQLpe8bM4Z+Y39WEsP00gTragHj4Rc=;
        b=ZeYciOut2+NKr9+n+xvSV14XcLOlxZEmxmHGAuDTQs3Tzx1I1UgsddPUG0W6GgdmMz
         AcXv50dr6uk8hGzQO0K1YNbzANTrPrLuIQ/7/aBDZwbvt1Ttp11tmgISgxZt0Rsglb6o
         QOHFboUhZHoAyBLutZz+KwAlRAtFUdi0tVircUlzcd+chJN6/xMhlJlugz9cxDYFXmTM
         1mOQ6b0lWEqcCx3KYhYkiPxL1kNojJWJmmC3bzrZu49zB1XCsH14oGAmjdmgR92o84rJ
         hMYHk59UoSUHHVvEvpzpZsoPMAltkh3wJV/PsrBPNCLC/AAd0X6Ogl4rotoF3AYXVevT
         Q73w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761907195; x=1762511995;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nlol8jlCrwU+dDQLpe8bM4Z+Y39WEsP00gTragHj4Rc=;
        b=HfuukFpnv9GDTKzBsO+BLVsyT48uvfYldQqAlQY6V3cg8HL4SrRs+R1iWsFq27Rj3E
         ofqspNaxu2SSOnTbZ8IhatVHVrLKpouMZbOGRIt1F+mdFdIV4ls0ll7HfL3YoLvAMDjQ
         +r5J0eBXwrd7ziQUvV365S2yc7Z7YHVH7DRH7KhFcwKqbos+GvD5tqo6K8saCh1slwDl
         FF8C6IDPXitTlnE/YwCcxWCu6MGrwCf558qwA9pQAYCLEJ9ThxzGMRU+lhoK3zsuGTZe
         R+jW734EwNaESoXAw14lb4iK88xifA7wHY/zDAeGflA/n1hBLffPsFd7vWFWqa3AvBus
         ZI1w==
X-Forwarded-Encrypted: i=1; AJvYcCVoNWwFhFg1RzWY0Se3pqbg9KUya9a/mjK1pHMC+wR1o4bCNNE4xjH7W5+TgprzGvQ1EN61deQb/E54UYw=@vger.kernel.org
X-Gm-Message-State: AOJu0YzSP7PAFOiCyMSJSR7vh3kYYjwnrsGgRWgK+9gk//cfuwfys5YL
	ASmlqZLu3qDrfuKf5OVNK+71fKs1mrgICzd29bIlavTNg4ksIZBpKiGKQfB1O6Bg1BcbTRAqQw=
	=
X-Google-Smtp-Source: AGHT+IEQo+IgSEHdcMiYz77LsIcY8TwOhGlEenTve1eoVqnDIxVO+kbrC2+61YhJ3qT6ML4IQGiBjP00
X-Received: from wrme11.prod.google.com ([2002:adf:e38b:0:b0:3ec:e23c:988f])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6000:25c2:b0:429:b718:167c
 with SMTP id ffacd0b85a97d-429bd68847fmr2351214f8f.28.1761907194945; Fri, 31
 Oct 2025 03:39:54 -0700 (PDT)
Date: Fri, 31 Oct 2025 11:39:08 +0100
In-Reply-To: <20251031103858.529530-23-ardb+git@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251031103858.529530-23-ardb+git@google.com>
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=9584; i=ardb@kernel.org;
 h=from:subject; bh=NAEDE4qtKhFGVJRETAhS4vJcuLrplU7qZJjmEUjIxNE=;
 b=owGbwMvMwCVmkMcZplerG8N4Wi2JIZNl4oWTawUlGKbMPhxh+IFJa77kWuVTa6o+rtAO+rtTs
 e7AEoeGjlIWBjEuBlkxRRaB2X/f7Tw9UarWeZYszBxWJpAhDFycAjARPgmGf8YNBi18M3KZX10O
 8i6cNtHgu9LSmtjyWB2/fdrqabI7TjD8lRJafc5n8ebYDs9JK0/mRgqtEGQ5c+DF2eU5fHfnNOw 3ZgYA
X-Mailer: git-send-email 2.51.1.930.gacf6e81ea2-goog
Message-ID: <20251031103858.529530-32-ardb+git@google.com>
Subject: [PATCH v4 09/21] lib/crypto: Switch ARM and arm64 to 'ksimd' scoped
 guard API
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org, 
	herbert@gondor.apana.org.au, ebiggers@kernel.org, 
	Ard Biesheuvel <ardb@kernel.org>
Content-Type: text/plain; charset="UTF-8"

From: Ard Biesheuvel <ardb@kernel.org>

Before modifying the prototypes of kernel_neon_begin() and
kernel_neon_end() to accommodate kernel mode FP/SIMD state buffers
allocated on the stack, move arm64 to the new 'ksimd' scoped guard API,
which encapsulates the calls to those functions.

For symmetry, do the same for 32-bit ARM too.

Reviewed-by: Eric Biggers <ebiggers@kernel.org>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 lib/crypto/arm/chacha.h     |  6 ++----
 lib/crypto/arm/poly1305.h   |  6 ++----
 lib/crypto/arm/sha1.h       | 13 ++++++-------
 lib/crypto/arm/sha256.h     | 12 ++++++------
 lib/crypto/arm/sha512.h     |  5 ++---
 lib/crypto/arm64/chacha.h   | 11 ++++-------
 lib/crypto/arm64/poly1305.h |  6 ++----
 lib/crypto/arm64/sha1.h     |  7 +++----
 lib/crypto/arm64/sha256.h   | 19 ++++++++-----------
 lib/crypto/arm64/sha512.h   |  8 ++++----
 10 files changed, 39 insertions(+), 54 deletions(-)

diff --git a/lib/crypto/arm/chacha.h b/lib/crypto/arm/chacha.h
index 0cae30f8ee5d..b27ba00b3b23 100644
--- a/lib/crypto/arm/chacha.h
+++ b/lib/crypto/arm/chacha.h
@@ -12,7 +12,6 @@
 
 #include <asm/cputype.h>
 #include <asm/hwcap.h>
-#include <asm/neon.h>
 #include <asm/simd.h>
 
 asmlinkage void chacha_block_xor_neon(const struct chacha_state *state,
@@ -87,9 +86,8 @@ static void chacha_crypt_arch(struct chacha_state *state, u8 *dst,
 	do {
 		unsigned int todo = min_t(unsigned int, bytes, SZ_4K);
 
-		kernel_neon_begin();
-		chacha_doneon(state, dst, src, todo, nrounds);
-		kernel_neon_end();
+		scoped_ksimd()
+			chacha_doneon(state, dst, src, todo, nrounds);
 
 		bytes -= todo;
 		src += todo;
diff --git a/lib/crypto/arm/poly1305.h b/lib/crypto/arm/poly1305.h
index 0021cf368307..0fe903d8de55 100644
--- a/lib/crypto/arm/poly1305.h
+++ b/lib/crypto/arm/poly1305.h
@@ -6,7 +6,6 @@
  */
 
 #include <asm/hwcap.h>
-#include <asm/neon.h>
 #include <asm/simd.h>
 #include <linux/cpufeature.h>
 #include <linux/jump_label.h>
@@ -32,9 +31,8 @@ static void poly1305_blocks(struct poly1305_block_state *state, const u8 *src,
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
index 29f8bcad0447..3e2d8c7cab9f 100644
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
index 7556457b3094..ae7e52dd6e3b 100644
--- a/lib/crypto/arm/sha256.h
+++ b/lib/crypto/arm/sha256.h
@@ -22,12 +22,12 @@ static void sha256_blocks(struct sha256_block_state *state,
 {
 	if (IS_ENABLED(CONFIG_KERNEL_MODE_NEON) &&
 	    static_branch_likely(&have_neon) && likely(may_use_simd())) {
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
index d1b485dd275d..ed9bd81d6d78 100644
--- a/lib/crypto/arm/sha512.h
+++ b/lib/crypto/arm/sha512.h
@@ -19,9 +19,8 @@ static void sha512_blocks(struct sha512_block_state *state,
 {
 	if (IS_ENABLED(CONFIG_KERNEL_MODE_NEON) &&
 	    static_branch_likely(&have_neon) && likely(may_use_simd())) {
-		kernel_neon_begin();
-		sha512_block_data_order_neon(state, data, nblocks);
-		kernel_neon_end();
+		scoped_ksimd()
+			sha512_block_data_order_neon(state, data, nblocks);
 	} else {
 		sha512_block_data_order(state, data, nblocks);
 	}
diff --git a/lib/crypto/arm64/chacha.h b/lib/crypto/arm64/chacha.h
index ba6c22d46086..ca8c6a8b0578 100644
--- a/lib/crypto/arm64/chacha.h
+++ b/lib/crypto/arm64/chacha.h
@@ -23,7 +23,6 @@
 #include <linux/kernel.h>
 
 #include <asm/hwcap.h>
-#include <asm/neon.h>
 #include <asm/simd.h>
 
 asmlinkage void chacha_block_xor_neon(const struct chacha_state *state,
@@ -65,9 +64,8 @@ static void hchacha_block_arch(const struct chacha_state *state,
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
 
@@ -81,9 +79,8 @@ static void chacha_crypt_arch(struct chacha_state *state, u8 *dst,
 	do {
 		unsigned int todo = min_t(unsigned int, bytes, SZ_4K);
 
-		kernel_neon_begin();
-		chacha_doneon(state, dst, src, todo, nrounds);
-		kernel_neon_end();
+		scoped_ksimd()
+			chacha_doneon(state, dst, src, todo, nrounds);
 
 		bytes -= todo;
 		src += todo;
diff --git a/lib/crypto/arm64/poly1305.h b/lib/crypto/arm64/poly1305.h
index aed5921ccd9a..b77669767cd6 100644
--- a/lib/crypto/arm64/poly1305.h
+++ b/lib/crypto/arm64/poly1305.h
@@ -6,7 +6,6 @@
  */
 
 #include <asm/hwcap.h>
-#include <asm/neon.h>
 #include <asm/simd.h>
 #include <linux/cpufeature.h>
 #include <linux/jump_label.h>
@@ -31,9 +30,8 @@ static void poly1305_blocks(struct poly1305_block_state *state, const u8 *src,
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
index aaef4ebfc5e3..bc7071f1be09 100644
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
index 80d06df27d3a..568dff0f276a 100644
--- a/lib/crypto/arm64/sha256.h
+++ b/lib/crypto/arm64/sha256.h
@@ -4,7 +4,6 @@
  *
  * Copyright 2025 Google LLC
  */
-#include <asm/neon.h>
 #include <asm/simd.h>
 #include <linux/cpufeature.h>
 
@@ -27,17 +26,16 @@ static void sha256_blocks(struct sha256_block_state *state,
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
@@ -66,9 +64,8 @@ static bool sha256_finup_2x_arch(const struct __sha256_ctx *ctx,
 	if (IS_ENABLED(CONFIG_KERNEL_MODE_NEON) &&
 	    static_branch_likely(&have_ce) && len >= SHA256_BLOCK_SIZE &&
 	    len <= 65536 && likely(may_use_simd())) {
-		kernel_neon_begin();
-		sha256_ce_finup2x(ctx, data1, data2, len, out1, out2);
-		kernel_neon_end();
+		scoped_ksimd()
+			sha256_ce_finup2x(ctx, data1, data2, len, out1, out2);
 		kmsan_unpoison_memory(out1, SHA256_DIGEST_SIZE);
 		kmsan_unpoison_memory(out2, SHA256_DIGEST_SIZE);
 		return true;
diff --git a/lib/crypto/arm64/sha512.h b/lib/crypto/arm64/sha512.h
index ddb0d256f73a..7eb7ef04d268 100644
--- a/lib/crypto/arm64/sha512.h
+++ b/lib/crypto/arm64/sha512.h
@@ -4,7 +4,7 @@
  *
  * Copyright 2025 Google LLC
  */
-#include <asm/neon.h>
+
 #include <asm/simd.h>
 #include <linux/cpufeature.h>
 
@@ -24,9 +24,9 @@ static void sha512_blocks(struct sha512_block_state *state,
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
2.51.1.930.gacf6e81ea2-goog

