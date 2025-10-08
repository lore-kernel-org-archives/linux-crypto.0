Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF5452FB0A0
	for <linux-crypto@vger.kernel.org>; Wed,  8 Oct 2025 15:46:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759938420; cv=none; b=fNIH5DYF8Wn6DyWp1/EySq4Yv9Enpm7DJj4eP1+SV6oevyHEU6ReDHGzDDiCNcS+gcBO5+aL3/z9hSgcYQBeHy0PXxtB/BH7RNCZLawIPF6W8mCVX7omRqLx3wOW7RVX021/yQz0MJR/uix95HLtGpsGDWz2abc6tFTf8MNygFg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759938420; c=relaxed/simple;
	bh=RtakoNllASHXrHooobUros6OMf2QXz1XhPt9rY7cMgM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=VUYswrvPHIhytH927KqGui9iIh9Bk+0+bUVX/CiA2amw4SE9bulUleWloBmWvT2crugKtEdmX9xEdcgy8q99tl3DwbeqYMfvaEx/l2ZsE+IQ3NakJJSrS5sOtWxt4zAJlSW+ORzcCZNjTKGkzqoaxBBRaL4sx/pOJu28DpX1uOs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Bu/dNmak; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Bu/dNmak"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-46e3ed6540fso516915e9.0
        for <linux-crypto@vger.kernel.org>; Wed, 08 Oct 2025 08:46:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1759938415; x=1760543215; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=suglsX43a1PiFmk1IVTuyelqyhWxvfsGVtpIchz7pR4=;
        b=Bu/dNmakfKBr6y72p8WCXvjYuw10ljRmk9MDlFIkieSvIutsd4G2kFcqgCUxviK/U3
         mq4bU0oo3tYNsEpytrtVUSzpP5oqQwL+PyuRVH5PYjBt8ZZ/uFIx4IAKYXDyer2tRH2C
         9JRcI/DPge4lF+8FKo83rZqGHDxBpYvCz7r5yEB6Z/RmyvPSRmX3soSvIUtmKx0OtRXj
         uN97BdZcAR/GpAbv+06MHaMZ3OpZ0VqeC8aeLScVnfHY8KqgppK4g3ocHqniq8gqxTcV
         AeK39UeKKdQyGqdEUP3RNiNF8Lkd7WXwyjqU566HV50W/95Kxa3bcYvlGZ4rBIE537o0
         APCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759938415; x=1760543215;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=suglsX43a1PiFmk1IVTuyelqyhWxvfsGVtpIchz7pR4=;
        b=dCaNVq/323mrgKFa745B0GHc0HNGuf3uATPcqFAX3bHPD3sd5KffFriMK322QZ/fO9
         SvXFxpXn72NcZwB5FM63ZRzb7xxrHX5NSOkuUGFlh2evVhydGrQTL0PAUHBSCIlTfvgm
         kAOCBrOLItbSWqV1j5UXLZK+4VyKuIuZ/ekLUCfz0Limb+BvdolaJGufETqumFHVVySa
         OGg0pLk6Dejbvh+So+cUzcdja2UjXItmTwkJvBqRlD3phHh/zyvaXMCVL68gcOKIMQpn
         nqLWqJ3HZSGMJB07ETqFJYh96QQ9ll6YotcRHibYg0zkycRokDIIULv/G66VL02gIzcW
         p6ug==
X-Forwarded-Encrypted: i=1; AJvYcCVYh/qB6OyIiHtojucMg0uE/rgAX+q2DZSRzqvzjHdIeXARRpgQq0YF0ik0ILYI9ix3199+FwECt8wvb50=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyp3M/y4NGLiZJ2jy3R3gIVYdy1MItWz2gTkNwiHDk0+rKCE8ko
	COnUBP2eFDaa/xnIwcbBPoDK+gQrJqdGw3ty6sf1pM4sbQ4Iqb2blkF1s66nKG2v0pRujORedg=
	=
X-Google-Smtp-Source: AGHT+IFdfbQL0RA5gdPU5ap+qfVyAmYhR0j1pMraOOaIT9NAX6C6fTnoeZL9e/lDaNNwsknXNRyIUjcW
X-Received: from wmgg6.prod.google.com ([2002:a05:600d:6:b0:46f:aa50:d70d])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:8a8:b0:46d:38c4:1ac9
 with SMTP id 5b1f17b1804b1-46fa2952c99mr33990935e9.2.1759938415296; Wed, 08
 Oct 2025 08:46:55 -0700 (PDT)
Date: Wed,  8 Oct 2025 17:45:43 +0200
In-Reply-To: <20251008154533.3089255-23-ardb+git@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251008154533.3089255-23-ardb+git@google.com>
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=9625; i=ardb@kernel.org;
 h=from:subject; bh=MDqXRAAfE9gWZ5IvXlO00eYBvbAZGnLkU83dj+lis3o=;
 b=owGbwMvMwCVmkMcZplerG8N4Wi2JIeNZu8VNuWn3b4Qv2bbiAavdW1fxGuMb59l9g/wMFpcxV
 02PKN7ZUcrCIMbFICumyCIw+++7nacnStU6z5KFmcPKBDKEgYtTACZyt56R4eWc55Ou282UaWtU
 Sv46YXN8eaq/iXnjtembi7PWC7s/yGJkaDIuWSs5xWIdx8XWkIveTAKxEdY5B2V8vyxzZNruktT CBQA=
X-Mailer: git-send-email 2.51.0.710.ga91ca5db03-goog
Message-ID: <20251008154533.3089255-32-ardb+git@google.com>
Subject: [PATCH v3 09/21] lib/crypto: Switch ARM and arm64 to 'ksimd' scoped
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
 lib/crypto/arm/sha512.h     |  6 ++----
 lib/crypto/arm64/chacha.h   | 11 ++++-------
 lib/crypto/arm64/poly1305.h |  6 ++----
 lib/crypto/arm64/sha1.h     |  7 +++----
 lib/crypto/arm64/sha256.h   | 19 ++++++++-----------
 lib/crypto/arm64/sha512.h   |  8 ++++----
 10 files changed, 39 insertions(+), 55 deletions(-)

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
index d1b485dd275d..8d3af965d2b3 100644
--- a/lib/crypto/arm/sha512.h
+++ b/lib/crypto/arm/sha512.h
@@ -18,10 +18,8 @@ static void sha512_blocks(struct sha512_block_state *state,
 			  const u8 *data, size_t nblocks)
 {
 	if (IS_ENABLED(CONFIG_KERNEL_MODE_NEON) &&
-	    static_branch_likely(&have_neon) && likely(may_use_simd())) {
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
2.51.0.710.ga91ca5db03-goog

