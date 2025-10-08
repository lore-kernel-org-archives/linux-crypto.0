Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9882F2F9DAF
	for <linux-crypto@vger.kernel.org>; Wed,  8 Oct 2025 15:46:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759938417; cv=none; b=XVAqc83JoWAFCXmN4m1OofRpavILnXlABAO4PTHUaKrY4QlHxkcwG7zfF2X4xXM4ukS/yNa9PyDaRG+diO50NRHUlptOy4Tt1YOSObHi702HTJYP70KOOR7zbgUWn3l87m3f30VkuBWS4aNPaIOKr+ZTRa39URFiU//WQyaPpRQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759938417; c=relaxed/simple;
	bh=tm0KHalsNoubgIAXcvxcEVr5CUh06XQoWaGdoTKv1YQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=XKvri9JEedTPCMDRdiZ8Ke4oHlCE461f40vJcz2LpLqocAg1RuKeO0P9pTlIt88FBiXIdzZlolC7k7T/uc3QlhTWsqNjj1noeFQb3utZOLsylSe7FZxIh6njQ3ca/78rHUYgfLuzFAcMDuZXyYIAHtBQL+3yPOjSOa7sQNZQx8A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=e65mljDN; arc=none smtp.client-ip=209.85.221.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="e65mljDN"
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-3f3787688b0so62471f8f.0
        for <linux-crypto@vger.kernel.org>; Wed, 08 Oct 2025 08:46:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1759938414; x=1760543214; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=8GJQeBDpX+7SHx9ZUHYa1E43jiFPF1VO+DzB2+02pPc=;
        b=e65mljDNjcHZhIPsS+wJrpmBOKZfjguJ9zUGO9Sug2vAeCGpJJqeIM2wkGi8AYAzQs
         oriZKYrECDvtVzFjZWjd5kchShMmYBwTWzJP8nl+Op3WiQ01uO4COEZdR/Z/nA1geJ+U
         esRQgdZcBC48y9weV7j27HjzJ943nnzJ9Wrzo9LXf/kojo0OcNdpL+z3vcKoL3pptq5n
         wJ27kY+5tuZUJs4Qn6bA8CJ4CjSeMkF6qFanxmY1bWZrsQfER1bPIGzOyOybXQEHr6c3
         CgbWHwA0yNIkA0YigQjrVCe+/WDfKkvjoXwy05B2CMSwjGz4jg2sDAdaEgOf22G11u5l
         +cNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759938414; x=1760543214;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8GJQeBDpX+7SHx9ZUHYa1E43jiFPF1VO+DzB2+02pPc=;
        b=OO31r6uPQp4Zv0HQM/0kmSMTgUb+Gukt2rXCORoeKVtFHS8v1eSStS0MpXgRgEj/mn
         btH/pqPcjQ/nEwNbWTCN/lw1cBa9qvYyivxRcO6jkomdWfkQOlaB3ZJWbjsbFHzVfdIw
         OHpjtlB8nJr+JZpkFEm5H3tb6YzmraIy1vK/h58ePpdpKl+Ak9JJNKdG5wOyMwo/vG/y
         rlscKbhMRcawpv632HvjDV1x3bhuKtxUsQNhv5kp2w1scabdj5dKgB+VXyP841+6SbA7
         cYLOVMyY9c6BA5/+5pu3QraVdHbfhG1rmgLPsp41dR4+aNSIA9BOQRpPBDMVY0h6rN62
         vTEw==
X-Forwarded-Encrypted: i=1; AJvYcCV+hG5HrXaEjc1vykRf+4OLhnI7pM+WngL+WfcxujO3FaTcdpWuoFA0KyCRUG3nk3+LLbmHLWuOdBsRvNc=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzfj38j+K+ahQfYvgZMMQKPborYUPiAsZKlu0hr2/rTEAFK9JyI
	bew+RbDThbgcUygm//xbta3XDPSod/4tLIPXSxoOfVODscsVsybPfG8DlJ18H/HWaOqpUjrohw=
	=
X-Google-Smtp-Source: AGHT+IHyGaKna1+bfZgQfPNXrTuRy57DagmSjcMNtJQ4By+4hEW1MTsC+nnKDwLQxtbqhtrb+xnIDUJa
X-Received: from wmdd12.prod.google.com ([2002:a05:600c:a20c:b0:45f:2b4d:3c2b])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a5d:64e8:0:b0:425:855c:5879
 with SMTP id ffacd0b85a97d-4266e7d63f2mr2739411f8f.15.1759938414048; Wed, 08
 Oct 2025 08:46:54 -0700 (PDT)
Date: Wed,  8 Oct 2025 17:45:42 +0200
In-Reply-To: <20251008154533.3089255-23-ardb+git@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251008154533.3089255-23-ardb+git@google.com>
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=5822; i=ardb@kernel.org;
 h=from:subject; bh=O+ioOVuVxfCkNommld21t7f0rh0GyrQ0rc9ryRMpovY=;
 b=owGbwMvMwCVmkMcZplerG8N4Wi2JIeNZu2ncnGkrmH5Nlrmdd3pvbf+RzjMHxE+wpLz4L6FsI
 Fbx7lR4RykLgxgXg6yYIovA7L/vdp6eKFXrPEsWZg4rE8gQBi5OAZiIthAjwwPGupk2RlMYkrPX
 VGawxjzSnVZ2/rCH+xKLy2x/lCXdVBgZpn7h0nxfJPkwOzOMbZa/Am9JvbtFR870LfOPFtedK+/ nAgA=
X-Mailer: git-send-email 2.51.0.710.ga91ca5db03-goog
Message-ID: <20251008154533.3089255-31-ardb+git@google.com>
Subject: [PATCH v3 08/21] lib/crc: Switch ARM and arm64 to 'ksimd' scoped
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
 lib/crc/arm/crc-t10dif.h   | 16 +++++-----------
 lib/crc/arm/crc32.h        | 11 ++++-------
 lib/crc/arm64/crc-t10dif.h | 16 +++++-----------
 lib/crc/arm64/crc32.h      | 16 ++++++----------
 4 files changed, 20 insertions(+), 39 deletions(-)

diff --git a/lib/crc/arm/crc-t10dif.h b/lib/crc/arm/crc-t10dif.h
index 63441de5e3f1..7f02a767f675 100644
--- a/lib/crc/arm/crc-t10dif.h
+++ b/lib/crc/arm/crc-t10dif.h
@@ -5,7 +5,6 @@
  * Copyright (C) 2016 Linaro Ltd <ard.biesheuvel@linaro.org>
  */
 
-#include <asm/neon.h>
 #include <asm/simd.h>
 
 static __ro_after_init DEFINE_STATIC_KEY_FALSE(have_neon);
@@ -20,21 +19,16 @@ asmlinkage void crc_t10dif_pmull8(u16 init_crc, const u8 *buf, size_t len,
 static inline u16 crc_t10dif_arch(u16 crc, const u8 *data, size_t length)
 {
 	if (length >= CRC_T10DIF_PMULL_CHUNK_SIZE) {
-		if (static_branch_likely(&have_pmull)) {
-			if (likely(may_use_simd())) {
-				kernel_neon_begin();
-				crc = crc_t10dif_pmull64(crc, data, length);
-				kernel_neon_end();
-				return crc;
-			}
+		if (static_branch_likely(&have_pmull) && likely(may_use_simd()) {
+			scoped_ksimd()
+				return crc_t10dif_pmull64(crc, data, length);
 		} else if (length > CRC_T10DIF_PMULL_CHUNK_SIZE &&
 			   static_branch_likely(&have_neon) &&
 			   likely(may_use_simd())) {
 			u8 buf[16] __aligned(16);
 
-			kernel_neon_begin();
-			crc_t10dif_pmull8(crc, data, length, buf);
-			kernel_neon_end();
+			scoped_ksimd()
+				crc_t10dif_pmull8(crc, data, length, buf);
 
 			return crc_t10dif_generic(0, buf, sizeof(buf));
 		}
diff --git a/lib/crc/arm/crc32.h b/lib/crc/arm/crc32.h
index 7b76f52f6907..f33de6b22cd4 100644
--- a/lib/crc/arm/crc32.h
+++ b/lib/crc/arm/crc32.h
@@ -8,7 +8,6 @@
 #include <linux/cpufeature.h>
 
 #include <asm/hwcap.h>
-#include <asm/neon.h>
 #include <asm/simd.h>
 
 static __ro_after_init DEFINE_STATIC_KEY_FALSE(have_crc32);
@@ -42,9 +41,8 @@ static inline u32 crc32_le_arch(u32 crc, const u8 *p, size_t len)
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
@@ -71,9 +69,8 @@ static inline u32 crc32c_arch(u32 crc, const u8 *p, size_t len)
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
index f88db2971805..0de03ab1aeab 100644
--- a/lib/crc/arm64/crc-t10dif.h
+++ b/lib/crc/arm64/crc-t10dif.h
@@ -7,7 +7,6 @@
 
 #include <linux/cpufeature.h>
 
-#include <asm/neon.h>
 #include <asm/simd.h>
 
 static __ro_after_init DEFINE_STATIC_KEY_FALSE(have_asimd);
@@ -22,21 +21,16 @@ asmlinkage u16 crc_t10dif_pmull_p64(u16 init_crc, const u8 *buf, size_t len);
 static inline u16 crc_t10dif_arch(u16 crc, const u8 *data, size_t length)
 {
 	if (length >= CRC_T10DIF_PMULL_CHUNK_SIZE) {
-		if (static_branch_likely(&have_pmull)) {
-			if (likely(may_use_simd())) {
-				kernel_neon_begin();
-				crc = crc_t10dif_pmull_p64(crc, data, length);
-				kernel_neon_end();
-				return crc;
-			}
+		if (static_branch_likely(&have_pmull) && likely(may_use_simd())) {
+			scoped_ksimd()
+				return crc_t10dif_pmull_p64(crc, data, length);
 		} else if (length > CRC_T10DIF_PMULL_CHUNK_SIZE &&
 			   static_branch_likely(&have_asimd) &&
 			   likely(may_use_simd())) {
 			u8 buf[16];
 
-			kernel_neon_begin();
-			crc_t10dif_pmull_p8(crc, data, length, buf);
-			kernel_neon_end();
+			scoped_ksimd()
+				crc_t10dif_pmull_p8(crc, data, length, buf);
 
 			return crc_t10dif_generic(0, buf, sizeof(buf));
 		}
diff --git a/lib/crc/arm64/crc32.h b/lib/crc/arm64/crc32.h
index 31e649cd40a2..1939a5dee477 100644
--- a/lib/crc/arm64/crc32.h
+++ b/lib/crc/arm64/crc32.h
@@ -2,7 +2,6 @@
 
 #include <asm/alternative.h>
 #include <asm/cpufeature.h>
-#include <asm/neon.h>
 #include <asm/simd.h>
 
 // The minimum input length to consider the 4-way interleaved code path
@@ -23,9 +22,8 @@ static inline u32 crc32_le_arch(u32 crc, const u8 *p, size_t len)
 
 	if (len >= min_len && cpu_have_named_feature(PMULL) &&
 	    likely(may_use_simd())) {
-		kernel_neon_begin();
-		crc = crc32_le_arm64_4way(crc, p, len);
-		kernel_neon_end();
+		scoped_ksimd()
+			crc = crc32_le_arm64_4way(crc, p, len);
 
 		p += round_down(len, 64);
 		len %= 64;
@@ -44,9 +42,8 @@ static inline u32 crc32c_arch(u32 crc, const u8 *p, size_t len)
 
 	if (len >= min_len && cpu_have_named_feature(PMULL) &&
 	    likely(may_use_simd())) {
-		kernel_neon_begin();
-		crc = crc32c_le_arm64_4way(crc, p, len);
-		kernel_neon_end();
+		scoped_ksimd()
+			crc = crc32c_le_arm64_4way(crc, p, len);
 
 		p += round_down(len, 64);
 		len %= 64;
@@ -65,9 +62,8 @@ static inline u32 crc32_be_arch(u32 crc, const u8 *p, size_t len)
 
 	if (len >= min_len && cpu_have_named_feature(PMULL) &&
 	    likely(may_use_simd())) {
-		kernel_neon_begin();
-		crc = crc32_be_arm64_4way(crc, p, len);
-		kernel_neon_end();
+		scoped_ksimd()
+			crc = crc32_be_arm64_4way(crc, p, len);
 
 		p += round_down(len, 64);
 		len %= 64;
-- 
2.51.0.710.ga91ca5db03-goog

