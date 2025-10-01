Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CFFC3112BD
	for <linux-crypto@vger.kernel.org>; Wed,  1 Oct 2025 21:04:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759352645; cv=none; b=Tuh/vqGK8gPud3mVG1i/cLmIynWGVBewQ7ZDLpcqEKtcUpYPYkJDjbA96HRvVRBmaPoXygL5ayRVSyIJk6A5A4JiQ4hZidncM9LImX6f7VWz0pMhEmwKyQ1SGVsOYJ7Yemndt04fB+SmeqO0BShfAIkcKpEQLLWfqHOrBBbNKgs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759352645; c=relaxed/simple;
	bh=DRYUDExVWqLdJx9CQihH/WVn5tjIj8wKdtaKatPJHTg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=mqPOSZGPxvo8thyorxBjoRNCigFPEPlh7SjWAZyH399TziyhDq93MoKI1Rrt6cfJRfNOtTdpssyyY9CtGdXCofyvc45hfp68XoLAnB4jDcqfhTy08KrnWC+6PFzzgs61Fq09ms0vHqipt1d/oBZW1QJlMSBoFX1e6QRosgQFN/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=oxrhPPOm; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="oxrhPPOm"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-46e4cc8ed76so726785e9.1
        for <linux-crypto@vger.kernel.org>; Wed, 01 Oct 2025 14:04:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1759352641; x=1759957441; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=vE8eXwwbGKy5p5WbHU/i1dMObS51JLHu730fwFC+Odw=;
        b=oxrhPPOmXUBYITnhFzHIpIkkoeKNcX23Rmm02DLrZknKOLSK2ftkw4aeZhxBYYxy23
         vWpX081AFeTDbokDVj/qfqtNfEnn/Wv2fdo+a1SHwLPK0yH5gXP6KYxRXgT1yKWNGw3Z
         wIUIE8rLdXtZg/omEhGoRJa+TMtYeWzgNJbFSIArN3BGjYkZMdYH4nJBPMMEJfWgVvlL
         nF5DHWb3fATaz83kIf5sPFc/oHY86MgNusqGAkAsFjpMGrKeqIjAQxiDzZ/RBpj08n4D
         z3Z9NdmIH+lin1O+CQ+CHWnvu1QqwIJMGRtN5HkF/NAF/Q0ylXijI59T28V9z9+KIFj3
         17qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759352641; x=1759957441;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vE8eXwwbGKy5p5WbHU/i1dMObS51JLHu730fwFC+Odw=;
        b=ZTzFrcPaYW7185EB1bPsq6H78c6cNfJB4qOgYjsgpSbWo24SrCYYgXxnZeCflgu4Cb
         Op03XSznK2YwAL6OgVHaTv+zaM7ICF0Yj13T/lYWiUMVD2xJZEunI+2D85Aqpty9l8Kh
         u8isrC9F8AmUfZMW2WRwDrUjMM+KZID3eHfCbhQJhhukQIt+osMrWn0r/xkjeOo1sGLv
         HDkxoX7wZ/RypOmwwhg32mAuraifmcfsmXyO8x5JP5GeW9ifvY13jKnRzxgVrpJByt/k
         ylRq6k0fL3+gVngSQLMvqHQF+5mkpKVmbJV8aLB1ID77/ZZG0AE3BjU/qNNuv7m+JZim
         lK6A==
X-Gm-Message-State: AOJu0YyP4E09mCGm+x9OuRZLKDYHy47LaliXTugVe/RBvlED58eWeFBF
	sSjP8BAy+C0SLwCXm/OyzdynNFXl4WumYRJmRKX/Xyo5gYZe0Y3ihfj7D3M7hTwgVB5P5RrGAA=
	=
X-Google-Smtp-Source: AGHT+IH7ZtZzU237M2m1tNwTXmJBPEEEg2ifHIsvYzIIZQnXlN2lH+rAVb8JyGkAh+fVohPUM/1C32AM
X-Received: from wmlv6.prod.google.com ([2002:a05:600c:2146:b0:46e:19f9:cfe9])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:8414:b0:46e:206a:78cc
 with SMTP id 5b1f17b1804b1-46e612c9042mr40692505e9.28.1759352641678; Wed, 01
 Oct 2025 14:04:01 -0700 (PDT)
Date: Wed,  1 Oct 2025 23:02:11 +0200
In-Reply-To: <20251001210201.838686-22-ardb+git@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251001210201.838686-22-ardb+git@google.com>
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=5792; i=ardb@kernel.org;
 h=from:subject; bh=u6utO88LPPilhPgrmOnUNkYpCEnFY27X7HNtZdaOtj0=;
 b=owGbwMvMwCVmkMcZplerG8N4Wi2JIePutA9cXKLzKkytjZfvzuMw27rm9IWJmorzmss7FggGd
 Tm/kFjfUcrCIMbFICumyCIw+++7nacnStU6z5KFmcPKBDKEgYtTACaiYsLwv25T0T8WyXkR2rOy
 xBgyucWuPZu+c35P51XpqCxjrQq1xQz/3Zkj9jtHHaqsdJ52+exfZmlp3ycpykUPWr0XWZw6cje DHwA=
X-Mailer: git-send-email 2.51.0.618.g983fd99d29-goog
Message-ID: <20251001210201.838686-31-ardb+git@google.com>
Subject: [PATCH v2 09/20] lib/crc: Switch ARM and arm64 to 'ksimd' scoped
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
 lib/crc/arm/crc-t10dif.h   | 16 +++++-----------
 lib/crc/arm/crc32.h        | 11 ++++-------
 lib/crc/arm64/crc-t10dif.h | 16 +++++-----------
 lib/crc/arm64/crc32.h      | 16 ++++++----------
 4 files changed, 20 insertions(+), 39 deletions(-)

diff --git a/lib/crc/arm/crc-t10dif.h b/lib/crc/arm/crc-t10dif.h
index 2edf7e9681d0..133a773b8248 100644
--- a/lib/crc/arm/crc-t10dif.h
+++ b/lib/crc/arm/crc-t10dif.h
@@ -7,7 +7,6 @@
 
 #include <crypto/internal/simd.h>
 
-#include <asm/neon.h>
 #include <asm/simd.h>
 
 static __ro_after_init DEFINE_STATIC_KEY_FALSE(have_neon);
@@ -22,21 +21,16 @@ asmlinkage void crc_t10dif_pmull8(u16 init_crc, const u8 *buf, size_t len,
 static inline u16 crc_t10dif_arch(u16 crc, const u8 *data, size_t length)
 {
 	if (length >= CRC_T10DIF_PMULL_CHUNK_SIZE) {
-		if (static_branch_likely(&have_pmull)) {
-			if (crypto_simd_usable()) {
-				kernel_neon_begin();
-				crc = crc_t10dif_pmull64(crc, data, length);
-				kernel_neon_end();
-				return crc;
-			}
+		if (static_branch_likely(&have_pmull) && crypto_simd_usable()) {
+			scoped_ksimd()
+				return crc_t10dif_pmull64(crc, data, length);
 		} else if (length > CRC_T10DIF_PMULL_CHUNK_SIZE &&
 			   static_branch_likely(&have_neon) &&
 			   crypto_simd_usable()) {
 			u8 buf[16] __aligned(16);
 
-			kernel_neon_begin();
-			crc_t10dif_pmull8(crc, data, length, buf);
-			kernel_neon_end();
+			scoped_ksimd()
+				crc_t10dif_pmull8(crc, data, length, buf);
 
 			return crc_t10dif_generic(0, buf, sizeof(buf));
 		}
diff --git a/lib/crc/arm/crc32.h b/lib/crc/arm/crc32.h
index 018007e162a2..32ad299319cd 100644
--- a/lib/crc/arm/crc32.h
+++ b/lib/crc/arm/crc32.h
@@ -10,7 +10,6 @@
 #include <crypto/internal/simd.h>
 
 #include <asm/hwcap.h>
-#include <asm/neon.h>
 #include <asm/simd.h>
 
 static __ro_after_init DEFINE_STATIC_KEY_FALSE(have_crc32);
@@ -44,9 +43,8 @@ static inline u32 crc32_le_arch(u32 crc, const u8 *p, size_t len)
 			len -= n;
 		}
 		n = round_down(len, 16);
-		kernel_neon_begin();
-		crc = crc32_pmull_le(p, n, crc);
-		kernel_neon_end();
+		scoped_ksimd()
+			crc = crc32_pmull_le(p, n, crc);
 		p += n;
 		len -= n;
 	}
@@ -73,9 +71,8 @@ static inline u32 crc32c_arch(u32 crc, const u8 *p, size_t len)
 			len -= n;
 		}
 		n = round_down(len, 16);
-		kernel_neon_begin();
-		crc = crc32c_pmull_le(p, n, crc);
-		kernel_neon_end();
+		scoped_ksimd()
+			crc = crc32c_pmull_le(p, n, crc);
 		p += n;
 		len -= n;
 	}
diff --git a/lib/crc/arm64/crc-t10dif.h b/lib/crc/arm64/crc-t10dif.h
index c4521a7f1ee9..dcbee08801d6 100644
--- a/lib/crc/arm64/crc-t10dif.h
+++ b/lib/crc/arm64/crc-t10dif.h
@@ -9,7 +9,6 @@
 
 #include <crypto/internal/simd.h>
 
-#include <asm/neon.h>
 #include <asm/simd.h>
 
 static __ro_after_init DEFINE_STATIC_KEY_FALSE(have_asimd);
@@ -24,21 +23,16 @@ asmlinkage u16 crc_t10dif_pmull_p64(u16 init_crc, const u8 *buf, size_t len);
 static inline u16 crc_t10dif_arch(u16 crc, const u8 *data, size_t length)
 {
 	if (length >= CRC_T10DIF_PMULL_CHUNK_SIZE) {
-		if (static_branch_likely(&have_pmull)) {
-			if (crypto_simd_usable()) {
-				kernel_neon_begin();
-				crc = crc_t10dif_pmull_p64(crc, data, length);
-				kernel_neon_end();
-				return crc;
-			}
+		if (static_branch_likely(&have_pmull) && crypto_simd_usable()) {
+			scoped_ksimd()
+				return crc_t10dif_pmull_p64(crc, data, length);
 		} else if (length > CRC_T10DIF_PMULL_CHUNK_SIZE &&
 			   static_branch_likely(&have_asimd) &&
 			   crypto_simd_usable()) {
 			u8 buf[16];
 
-			kernel_neon_begin();
-			crc_t10dif_pmull_p8(crc, data, length, buf);
-			kernel_neon_end();
+			scoped_ksimd()
+				crc_t10dif_pmull_p8(crc, data, length, buf);
 
 			return crc_t10dif_generic(0, buf, sizeof(buf));
 		}
diff --git a/lib/crc/arm64/crc32.h b/lib/crc/arm64/crc32.h
index 6e5dec45f05d..2b5cbb686a13 100644
--- a/lib/crc/arm64/crc32.h
+++ b/lib/crc/arm64/crc32.h
@@ -2,7 +2,6 @@
 
 #include <asm/alternative.h>
 #include <asm/cpufeature.h>
-#include <asm/neon.h>
 #include <asm/simd.h>
 
 #include <crypto/internal/simd.h>
@@ -24,9 +23,8 @@ static inline u32 crc32_le_arch(u32 crc, const u8 *p, size_t len)
 		return crc32_le_base(crc, p, len);
 
 	if (len >= min_len && cpu_have_named_feature(PMULL) && crypto_simd_usable()) {
-		kernel_neon_begin();
-		crc = crc32_le_arm64_4way(crc, p, len);
-		kernel_neon_end();
+		scoped_ksimd()
+			crc = crc32_le_arm64_4way(crc, p, len);
 
 		p += round_down(len, 64);
 		len %= 64;
@@ -44,9 +42,8 @@ static inline u32 crc32c_arch(u32 crc, const u8 *p, size_t len)
 		return crc32c_base(crc, p, len);
 
 	if (len >= min_len && cpu_have_named_feature(PMULL) && crypto_simd_usable()) {
-		kernel_neon_begin();
-		crc = crc32c_le_arm64_4way(crc, p, len);
-		kernel_neon_end();
+		scoped_ksimd()
+			crc = crc32c_le_arm64_4way(crc, p, len);
 
 		p += round_down(len, 64);
 		len %= 64;
@@ -64,9 +61,8 @@ static inline u32 crc32_be_arch(u32 crc, const u8 *p, size_t len)
 		return crc32_be_base(crc, p, len);
 
 	if (len >= min_len && cpu_have_named_feature(PMULL) && crypto_simd_usable()) {
-		kernel_neon_begin();
-		crc = crc32_be_arm64_4way(crc, p, len);
-		kernel_neon_end();
+		scoped_ksimd()
+			crc = crc32_be_arm64_4way(crc, p, len);
 
 		p += round_down(len, 64);
 		len %= 64;
-- 
2.51.0.618.g983fd99d29-goog

