Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D62D38947E
	for <linux-crypto@vger.kernel.org>; Wed, 22 Apr 2026 17:17:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776878243; cv=none; b=mdelb8TCZxy1aMmUffgexAdRQNMf24clJGIaUnsV0LH3ezWi6jHekyZTRyl704qfIF/m/6h9IWONbfLM9lGMEwAQfpyrD5GKNKJasuiWVLsH+qrdtWDWQHADLZy4eqlptXxrRw5VqC1vzN54NZ7/tXbhwC7qk348JGEHpUeaDv4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776878243; c=relaxed/simple;
	bh=Zp9AmTLrsJCkG2/xhZ1MByaY57ZCrDxTPOrbVUzPoPQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ZcnNwVYO7fRTc3sKiPSsjgtWf3X4spQ6pn7u4J/ZPJoV6NRGNaPFSDN2uxMNp+b5YJcIH2UKvW/LlC2QsS4G0HnxSxmrK/uMfIUFNT8v8Fl6NXs0QGRZA3v73VgBh92R8kpHmiuv3OT0azRlymv9j9bjXfTQGQ+EyvM763EwXOo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=WU3LlH3M; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="WU3LlH3M"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-48a55d82e0eso16056555e9.1
        for <linux-crypto@vger.kernel.org>; Wed, 22 Apr 2026 10:17:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1776878239; x=1777483039; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=j05evVTJoFi4nPqM9vHvWwCsjf2KXcfy9+lOE3+LEQ4=;
        b=WU3LlH3Mf6XyD0nOLItQVXOIFysDGZ8vOOl2pbKxwQojv8DP4aMFKuOHSGhwtEJpOb
         /1SMMLJoSgYGm/eURfpswNH9pUtgBtLkrv7+jSeZCIehAu8nEoL9/to/uD5BbgjZCF64
         0gu4Db7r+TjpRsacPI/m67TMnzLj7oCdzjIIlChz+9pSI009GKiKdFyBbF8w8HHZUt1k
         WPX8hDA3IvcDPM5DKKI6sYe9FT7ZBfr/N9LbV4sNx0jjw9kFmFtGPPpiD9PoVyEeeTGR
         zyU+5i44UUIKQ/DLagtkPfA8ejhiF7OQ4U8AtGx6birgTskfL7MPtTgiWrclPO7DFkHv
         IVNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776878239; x=1777483039;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=j05evVTJoFi4nPqM9vHvWwCsjf2KXcfy9+lOE3+LEQ4=;
        b=Y9GEQ0VSxSdxF/PYEHtfOSIkDwDe5J1e0eu3Jp63QP1Yz+p3TYHFkDA0LDWn1FJG24
         6jjPou6xrAsHwuv3Jd+qM2i17rQzNB7AJgKgHu42fabMPnzBpg7XOWQHvL23HJeR8DhH
         3hre2rU5wQrWtCrbMl2CFkdNhj8V4CPZ5Po6xt7QnTUTGK4Q2WRtSK0YRBNritSdJMpD
         R63+Mftx76Pb7N3r+t+9cbyCPeCPjHggz7mzuH4OsIuDZKp36PxPeDrJXLEmvHy5XXHI
         Ko+ayv4F3Q25/wvahvG2tD0gTK9bz4mEShAFBzsJ7cEWFTQOuc+/yRcNCLwcT//WkEpr
         o5Cg==
X-Gm-Message-State: AOJu0YxOxD52DYx6mCIYDCktRKSU264bauCiCUBz6b8e1NwdR/CMBlgH
	IPK5DyH5ZBFxK2YqKcezuuhlEYG3AeFTsdYXO9xDlTCC25IyhCT+OwVRUbUf0WD82HKUFCXZJw=
	=
X-Received: from wmey23.prod.google.com ([2002:a05:600c:2b17:b0:489:201f:2be])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:3513:b0:488:a977:8de
 with SMTP id 5b1f17b1804b1-488fb77a3a7mr340342055e9.16.1776878239419; Wed, 22
 Apr 2026 10:17:19 -0700 (PDT)
Date: Wed, 22 Apr 2026 19:16:59 +0200
In-Reply-To: <20260422171655.3437334-10-ardb+git@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260422171655.3437334-10-ardb+git@google.com>
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=15841; i=ardb@kernel.org;
 h=from:subject; bh=5HxTnqdIs1fSiI9qa7d5k7esps358zo//dxEAHMwChI=;
 b=owGbwMvMwCVmkMcZplerG8N4Wi2JIfMlU2/+jyuTpVQ+ubxfznXk/FNNiWky/efi9prJCtnoP
 1TJn/ugo5SFQYyLQVZMkUVg9t93O09PlKp1niULM4eVCWQIAxenAEzkcTLD//Sfx1d1CJr3HNrs
 faTm+5Xs1MNzFCbOcQi5sGLeKr/3j9UYGfZZnOvrfCTtFfDBs5Bj35a3i2XeJvyvevHJQnKG0k7 TP8wA
X-Mailer: git-send-email 2.54.0.rc2.544.gc7ae2d5bb8-goog
Message-ID: <20260422171655.3437334-13-ardb+git@google.com>
Subject: [PATCH 3/8] xor/arm64: Use shared NEON intrinsics implementation from
 32-bit ARM
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-crypto@vger.kernel.org, linux-raid@vger.kernel.org, 
	Ard Biesheuvel <ardb@kernel.org>, Christoph Hellwig <hch@lst.de>, Russell King <linux@armlinux.org.uk>, 
	Arnd Bergmann <arnd@arndb.de>, Eric Biggers <ebiggers@kernel.org>
Content-Type: text/plain; charset="UTF-8"

From: Ard Biesheuvel <ardb@kernel.org>

Tweak the arm64 code so that the pure NEON intrinsics implementation of
XOR is shared between arm64 and ARM. While at it, rename the arm64
specific piece xor-eor3.c to reflect that only the version based on the
EOR3 instruction is kept there.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 lib/raid/xor/Makefile         |   7 +-
 lib/raid/xor/arm64/xor-eor3.c | 146 +++++++++
 lib/raid/xor/arm64/xor-neon.c | 312 --------------------
 lib/raid/xor/xor-neon.c       |   4 +
 4 files changed, 154 insertions(+), 315 deletions(-)

diff --git a/lib/raid/xor/Makefile b/lib/raid/xor/Makefile
index d78400f2427a..e8ecec3c09f9 100644
--- a/lib/raid/xor/Makefile
+++ b/lib/raid/xor/Makefile
@@ -19,7 +19,8 @@ xor-$(CONFIG_ARM)		+= arm/xor.o
 ifeq ($(CONFIG_ARM),y)
 xor-$(CONFIG_KERNEL_MODE_NEON)	+= xor-neon.o arm/xor-neon-glue.o
 endif
-xor-$(CONFIG_ARM64)		+= arm64/xor-neon.o arm64/xor-neon-glue.o
+xor-$(CONFIG_ARM64)		+= xor-neon.o arm64/xor-eor3.o \
+				   arm64/xor-neon-glue.o
 xor-$(CONFIG_CPU_HAS_LSX)	+= loongarch/xor_simd.o
 xor-$(CONFIG_CPU_HAS_LSX)	+= loongarch/xor_simd_glue.o
 xor-$(CONFIG_ALTIVEC)		+= powerpc/xor_vmx.o powerpc/xor_vmx_glue.o
@@ -34,8 +35,8 @@ obj-y				+= tests/
 CFLAGS_xor-neon.o		+= $(CC_FLAGS_FPU) -I$(src)/$(SRCARCH)
 CFLAGS_REMOVE_xor-neon.o	+= $(CC_FLAGS_NO_FPU)
 
-CFLAGS_arm64/xor-neon.o		+= $(CC_FLAGS_FPU)
-CFLAGS_REMOVE_arm64/xor-neon.o	+= $(CC_FLAGS_NO_FPU)
+CFLAGS_arm64/xor-eor3.o		+= $(CC_FLAGS_FPU)
+CFLAGS_REMOVE_arm64/xor-eor3.o	+= $(CC_FLAGS_NO_FPU)
 
 CFLAGS_powerpc/xor_vmx.o	+= -mhard-float -maltivec \
 				   $(call cc-option,-mabi=altivec) \
diff --git a/lib/raid/xor/arm64/xor-eor3.c b/lib/raid/xor/arm64/xor-eor3.c
new file mode 100644
index 000000000000..e44016c363f1
--- /dev/null
+++ b/lib/raid/xor/arm64/xor-eor3.c
@@ -0,0 +1,146 @@
+// SPDX-License-Identifier: GPL-2.0-only
+
+#include <linux/cache.h>
+#include <asm/neon-intrinsics.h>
+#include "xor_impl.h"
+#include "xor_arch.h"
+#include "xor-neon.h"
+
+extern void __xor_eor3_2(unsigned long bytes, unsigned long * __restrict p1,
+		const unsigned long * __restrict p2);
+
+static inline uint64x2_t eor3(uint64x2_t p, uint64x2_t q, uint64x2_t r)
+{
+	uint64x2_t res;
+
+	asm(ARM64_ASM_PREAMBLE ".arch_extension sha3\n"
+	    "eor3 %0.16b, %1.16b, %2.16b, %3.16b"
+	    : "=w"(res) : "w"(p), "w"(q), "w"(r));
+	return res;
+}
+
+static void __xor_eor3_3(unsigned long bytes, unsigned long * __restrict p1,
+		const unsigned long * __restrict p2,
+		const unsigned long * __restrict p3)
+{
+	uint64_t *dp1 = (uint64_t *)p1;
+	uint64_t *dp2 = (uint64_t *)p2;
+	uint64_t *dp3 = (uint64_t *)p3;
+
+	register uint64x2_t v0, v1, v2, v3;
+	long lines = bytes / (sizeof(uint64x2_t) * 4);
+
+	do {
+		/* p1 ^= p2 ^ p3 */
+		v0 = eor3(vld1q_u64(dp1 + 0), vld1q_u64(dp2 + 0),
+			  vld1q_u64(dp3 + 0));
+		v1 = eor3(vld1q_u64(dp1 + 2), vld1q_u64(dp2 + 2),
+			  vld1q_u64(dp3 + 2));
+		v2 = eor3(vld1q_u64(dp1 + 4), vld1q_u64(dp2 + 4),
+			  vld1q_u64(dp3 + 4));
+		v3 = eor3(vld1q_u64(dp1 + 6), vld1q_u64(dp2 + 6),
+			  vld1q_u64(dp3 + 6));
+
+		/* store */
+		vst1q_u64(dp1 + 0, v0);
+		vst1q_u64(dp1 + 2, v1);
+		vst1q_u64(dp1 + 4, v2);
+		vst1q_u64(dp1 + 6, v3);
+
+		dp1 += 8;
+		dp2 += 8;
+		dp3 += 8;
+	} while (--lines > 0);
+}
+
+static void __xor_eor3_4(unsigned long bytes, unsigned long * __restrict p1,
+		const unsigned long * __restrict p2,
+		const unsigned long * __restrict p3,
+		const unsigned long * __restrict p4)
+{
+	uint64_t *dp1 = (uint64_t *)p1;
+	uint64_t *dp2 = (uint64_t *)p2;
+	uint64_t *dp3 = (uint64_t *)p3;
+	uint64_t *dp4 = (uint64_t *)p4;
+
+	register uint64x2_t v0, v1, v2, v3;
+	long lines = bytes / (sizeof(uint64x2_t) * 4);
+
+	do {
+		/* p1 ^= p2 ^ p3 */
+		v0 = eor3(vld1q_u64(dp1 + 0), vld1q_u64(dp2 + 0),
+			  vld1q_u64(dp3 + 0));
+		v1 = eor3(vld1q_u64(dp1 + 2), vld1q_u64(dp2 + 2),
+			  vld1q_u64(dp3 + 2));
+		v2 = eor3(vld1q_u64(dp1 + 4), vld1q_u64(dp2 + 4),
+			  vld1q_u64(dp3 + 4));
+		v3 = eor3(vld1q_u64(dp1 + 6), vld1q_u64(dp2 + 6),
+			  vld1q_u64(dp3 + 6));
+
+		/* p1 ^= p4 */
+		v0 = veorq_u64(v0, vld1q_u64(dp4 + 0));
+		v1 = veorq_u64(v1, vld1q_u64(dp4 + 2));
+		v2 = veorq_u64(v2, vld1q_u64(dp4 + 4));
+		v3 = veorq_u64(v3, vld1q_u64(dp4 + 6));
+
+		/* store */
+		vst1q_u64(dp1 + 0, v0);
+		vst1q_u64(dp1 + 2, v1);
+		vst1q_u64(dp1 + 4, v2);
+		vst1q_u64(dp1 + 6, v3);
+
+		dp1 += 8;
+		dp2 += 8;
+		dp3 += 8;
+		dp4 += 8;
+	} while (--lines > 0);
+}
+
+static void __xor_eor3_5(unsigned long bytes, unsigned long * __restrict p1,
+		const unsigned long * __restrict p2,
+		const unsigned long * __restrict p3,
+		const unsigned long * __restrict p4,
+		const unsigned long * __restrict p5)
+{
+	uint64_t *dp1 = (uint64_t *)p1;
+	uint64_t *dp2 = (uint64_t *)p2;
+	uint64_t *dp3 = (uint64_t *)p3;
+	uint64_t *dp4 = (uint64_t *)p4;
+	uint64_t *dp5 = (uint64_t *)p5;
+
+	register uint64x2_t v0, v1, v2, v3;
+	long lines = bytes / (sizeof(uint64x2_t) * 4);
+
+	do {
+		/* p1 ^= p2 ^ p3 */
+		v0 = eor3(vld1q_u64(dp1 + 0), vld1q_u64(dp2 + 0),
+			  vld1q_u64(dp3 + 0));
+		v1 = eor3(vld1q_u64(dp1 + 2), vld1q_u64(dp2 + 2),
+			  vld1q_u64(dp3 + 2));
+		v2 = eor3(vld1q_u64(dp1 + 4), vld1q_u64(dp2 + 4),
+			  vld1q_u64(dp3 + 4));
+		v3 = eor3(vld1q_u64(dp1 + 6), vld1q_u64(dp2 + 6),
+			  vld1q_u64(dp3 + 6));
+
+		/* p1 ^= p4 ^ p5 */
+		v0 = eor3(v0, vld1q_u64(dp4 + 0), vld1q_u64(dp5 + 0));
+		v1 = eor3(v1, vld1q_u64(dp4 + 2), vld1q_u64(dp5 + 2));
+		v2 = eor3(v2, vld1q_u64(dp4 + 4), vld1q_u64(dp5 + 4));
+		v3 = eor3(v3, vld1q_u64(dp4 + 6), vld1q_u64(dp5 + 6));
+
+		/* store */
+		vst1q_u64(dp1 + 0, v0);
+		vst1q_u64(dp1 + 2, v1);
+		vst1q_u64(dp1 + 4, v2);
+		vst1q_u64(dp1 + 6, v3);
+
+		dp1 += 8;
+		dp2 += 8;
+		dp3 += 8;
+		dp4 += 8;
+		dp5 += 8;
+	} while (--lines > 0);
+}
+
+__DO_XOR_BLOCKS(eor3_inner, __xor_eor3_2, __xor_eor3_3, __xor_eor3_4,
+		__xor_eor3_5);
diff --git a/lib/raid/xor/arm64/xor-neon.c b/lib/raid/xor/arm64/xor-neon.c
deleted file mode 100644
index 97ef3cb92496..000000000000
--- a/lib/raid/xor/arm64/xor-neon.c
+++ /dev/null
@@ -1,312 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0-only
-/*
- * Authors: Jackie Liu <liuyun01@kylinos.cn>
- * Copyright (C) 2018,Tianjin KYLIN Information Technology Co., Ltd.
- */
-
-#include <linux/cache.h>
-#include <asm/neon-intrinsics.h>
-#include "xor_impl.h"
-#include "xor_arch.h"
-#include "xor-neon.h"
-
-static void __xor_neon_2(unsigned long bytes, unsigned long * __restrict p1,
-		const unsigned long * __restrict p2)
-{
-	uint64_t *dp1 = (uint64_t *)p1;
-	uint64_t *dp2 = (uint64_t *)p2;
-
-	register uint64x2_t v0, v1, v2, v3;
-	long lines = bytes / (sizeof(uint64x2_t) * 4);
-
-	do {
-		/* p1 ^= p2 */
-		v0 = veorq_u64(vld1q_u64(dp1 +  0), vld1q_u64(dp2 +  0));
-		v1 = veorq_u64(vld1q_u64(dp1 +  2), vld1q_u64(dp2 +  2));
-		v2 = veorq_u64(vld1q_u64(dp1 +  4), vld1q_u64(dp2 +  4));
-		v3 = veorq_u64(vld1q_u64(dp1 +  6), vld1q_u64(dp2 +  6));
-
-		/* store */
-		vst1q_u64(dp1 +  0, v0);
-		vst1q_u64(dp1 +  2, v1);
-		vst1q_u64(dp1 +  4, v2);
-		vst1q_u64(dp1 +  6, v3);
-
-		dp1 += 8;
-		dp2 += 8;
-	} while (--lines > 0);
-}
-
-static void __xor_neon_3(unsigned long bytes, unsigned long * __restrict p1,
-		const unsigned long * __restrict p2,
-		const unsigned long * __restrict p3)
-{
-	uint64_t *dp1 = (uint64_t *)p1;
-	uint64_t *dp2 = (uint64_t *)p2;
-	uint64_t *dp3 = (uint64_t *)p3;
-
-	register uint64x2_t v0, v1, v2, v3;
-	long lines = bytes / (sizeof(uint64x2_t) * 4);
-
-	do {
-		/* p1 ^= p2 */
-		v0 = veorq_u64(vld1q_u64(dp1 +  0), vld1q_u64(dp2 +  0));
-		v1 = veorq_u64(vld1q_u64(dp1 +  2), vld1q_u64(dp2 +  2));
-		v2 = veorq_u64(vld1q_u64(dp1 +  4), vld1q_u64(dp2 +  4));
-		v3 = veorq_u64(vld1q_u64(dp1 +  6), vld1q_u64(dp2 +  6));
-
-		/* p1 ^= p3 */
-		v0 = veorq_u64(v0, vld1q_u64(dp3 +  0));
-		v1 = veorq_u64(v1, vld1q_u64(dp3 +  2));
-		v2 = veorq_u64(v2, vld1q_u64(dp3 +  4));
-		v3 = veorq_u64(v3, vld1q_u64(dp3 +  6));
-
-		/* store */
-		vst1q_u64(dp1 +  0, v0);
-		vst1q_u64(dp1 +  2, v1);
-		vst1q_u64(dp1 +  4, v2);
-		vst1q_u64(dp1 +  6, v3);
-
-		dp1 += 8;
-		dp2 += 8;
-		dp3 += 8;
-	} while (--lines > 0);
-}
-
-static void __xor_neon_4(unsigned long bytes, unsigned long * __restrict p1,
-		const unsigned long * __restrict p2,
-		const unsigned long * __restrict p3,
-		const unsigned long * __restrict p4)
-{
-	uint64_t *dp1 = (uint64_t *)p1;
-	uint64_t *dp2 = (uint64_t *)p2;
-	uint64_t *dp3 = (uint64_t *)p3;
-	uint64_t *dp4 = (uint64_t *)p4;
-
-	register uint64x2_t v0, v1, v2, v3;
-	long lines = bytes / (sizeof(uint64x2_t) * 4);
-
-	do {
-		/* p1 ^= p2 */
-		v0 = veorq_u64(vld1q_u64(dp1 +  0), vld1q_u64(dp2 +  0));
-		v1 = veorq_u64(vld1q_u64(dp1 +  2), vld1q_u64(dp2 +  2));
-		v2 = veorq_u64(vld1q_u64(dp1 +  4), vld1q_u64(dp2 +  4));
-		v3 = veorq_u64(vld1q_u64(dp1 +  6), vld1q_u64(dp2 +  6));
-
-		/* p1 ^= p3 */
-		v0 = veorq_u64(v0, vld1q_u64(dp3 +  0));
-		v1 = veorq_u64(v1, vld1q_u64(dp3 +  2));
-		v2 = veorq_u64(v2, vld1q_u64(dp3 +  4));
-		v3 = veorq_u64(v3, vld1q_u64(dp3 +  6));
-
-		/* p1 ^= p4 */
-		v0 = veorq_u64(v0, vld1q_u64(dp4 +  0));
-		v1 = veorq_u64(v1, vld1q_u64(dp4 +  2));
-		v2 = veorq_u64(v2, vld1q_u64(dp4 +  4));
-		v3 = veorq_u64(v3, vld1q_u64(dp4 +  6));
-
-		/* store */
-		vst1q_u64(dp1 +  0, v0);
-		vst1q_u64(dp1 +  2, v1);
-		vst1q_u64(dp1 +  4, v2);
-		vst1q_u64(dp1 +  6, v3);
-
-		dp1 += 8;
-		dp2 += 8;
-		dp3 += 8;
-		dp4 += 8;
-	} while (--lines > 0);
-}
-
-static void __xor_neon_5(unsigned long bytes, unsigned long * __restrict p1,
-		const unsigned long * __restrict p2,
-		const unsigned long * __restrict p3,
-		const unsigned long * __restrict p4,
-		const unsigned long * __restrict p5)
-{
-	uint64_t *dp1 = (uint64_t *)p1;
-	uint64_t *dp2 = (uint64_t *)p2;
-	uint64_t *dp3 = (uint64_t *)p3;
-	uint64_t *dp4 = (uint64_t *)p4;
-	uint64_t *dp5 = (uint64_t *)p5;
-
-	register uint64x2_t v0, v1, v2, v3;
-	long lines = bytes / (sizeof(uint64x2_t) * 4);
-
-	do {
-		/* p1 ^= p2 */
-		v0 = veorq_u64(vld1q_u64(dp1 +  0), vld1q_u64(dp2 +  0));
-		v1 = veorq_u64(vld1q_u64(dp1 +  2), vld1q_u64(dp2 +  2));
-		v2 = veorq_u64(vld1q_u64(dp1 +  4), vld1q_u64(dp2 +  4));
-		v3 = veorq_u64(vld1q_u64(dp1 +  6), vld1q_u64(dp2 +  6));
-
-		/* p1 ^= p3 */
-		v0 = veorq_u64(v0, vld1q_u64(dp3 +  0));
-		v1 = veorq_u64(v1, vld1q_u64(dp3 +  2));
-		v2 = veorq_u64(v2, vld1q_u64(dp3 +  4));
-		v3 = veorq_u64(v3, vld1q_u64(dp3 +  6));
-
-		/* p1 ^= p4 */
-		v0 = veorq_u64(v0, vld1q_u64(dp4 +  0));
-		v1 = veorq_u64(v1, vld1q_u64(dp4 +  2));
-		v2 = veorq_u64(v2, vld1q_u64(dp4 +  4));
-		v3 = veorq_u64(v3, vld1q_u64(dp4 +  6));
-
-		/* p1 ^= p5 */
-		v0 = veorq_u64(v0, vld1q_u64(dp5 +  0));
-		v1 = veorq_u64(v1, vld1q_u64(dp5 +  2));
-		v2 = veorq_u64(v2, vld1q_u64(dp5 +  4));
-		v3 = veorq_u64(v3, vld1q_u64(dp5 +  6));
-
-		/* store */
-		vst1q_u64(dp1 +  0, v0);
-		vst1q_u64(dp1 +  2, v1);
-		vst1q_u64(dp1 +  4, v2);
-		vst1q_u64(dp1 +  6, v3);
-
-		dp1 += 8;
-		dp2 += 8;
-		dp3 += 8;
-		dp4 += 8;
-		dp5 += 8;
-	} while (--lines > 0);
-}
-
-__DO_XOR_BLOCKS(neon_inner, __xor_neon_2, __xor_neon_3, __xor_neon_4,
-		__xor_neon_5);
-
-static inline uint64x2_t eor3(uint64x2_t p, uint64x2_t q, uint64x2_t r)
-{
-	uint64x2_t res;
-
-	asm(ARM64_ASM_PREAMBLE ".arch_extension sha3\n"
-	    "eor3 %0.16b, %1.16b, %2.16b, %3.16b"
-	    : "=w"(res) : "w"(p), "w"(q), "w"(r));
-	return res;
-}
-
-static void __xor_eor3_3(unsigned long bytes, unsigned long * __restrict p1,
-		const unsigned long * __restrict p2,
-		const unsigned long * __restrict p3)
-{
-	uint64_t *dp1 = (uint64_t *)p1;
-	uint64_t *dp2 = (uint64_t *)p2;
-	uint64_t *dp3 = (uint64_t *)p3;
-
-	register uint64x2_t v0, v1, v2, v3;
-	long lines = bytes / (sizeof(uint64x2_t) * 4);
-
-	do {
-		/* p1 ^= p2 ^ p3 */
-		v0 = eor3(vld1q_u64(dp1 + 0), vld1q_u64(dp2 + 0),
-			  vld1q_u64(dp3 + 0));
-		v1 = eor3(vld1q_u64(dp1 + 2), vld1q_u64(dp2 + 2),
-			  vld1q_u64(dp3 + 2));
-		v2 = eor3(vld1q_u64(dp1 + 4), vld1q_u64(dp2 + 4),
-			  vld1q_u64(dp3 + 4));
-		v3 = eor3(vld1q_u64(dp1 + 6), vld1q_u64(dp2 + 6),
-			  vld1q_u64(dp3 + 6));
-
-		/* store */
-		vst1q_u64(dp1 + 0, v0);
-		vst1q_u64(dp1 + 2, v1);
-		vst1q_u64(dp1 + 4, v2);
-		vst1q_u64(dp1 + 6, v3);
-
-		dp1 += 8;
-		dp2 += 8;
-		dp3 += 8;
-	} while (--lines > 0);
-}
-
-static void __xor_eor3_4(unsigned long bytes, unsigned long * __restrict p1,
-		const unsigned long * __restrict p2,
-		const unsigned long * __restrict p3,
-		const unsigned long * __restrict p4)
-{
-	uint64_t *dp1 = (uint64_t *)p1;
-	uint64_t *dp2 = (uint64_t *)p2;
-	uint64_t *dp3 = (uint64_t *)p3;
-	uint64_t *dp4 = (uint64_t *)p4;
-
-	register uint64x2_t v0, v1, v2, v3;
-	long lines = bytes / (sizeof(uint64x2_t) * 4);
-
-	do {
-		/* p1 ^= p2 ^ p3 */
-		v0 = eor3(vld1q_u64(dp1 + 0), vld1q_u64(dp2 + 0),
-			  vld1q_u64(dp3 + 0));
-		v1 = eor3(vld1q_u64(dp1 + 2), vld1q_u64(dp2 + 2),
-			  vld1q_u64(dp3 + 2));
-		v2 = eor3(vld1q_u64(dp1 + 4), vld1q_u64(dp2 + 4),
-			  vld1q_u64(dp3 + 4));
-		v3 = eor3(vld1q_u64(dp1 + 6), vld1q_u64(dp2 + 6),
-			  vld1q_u64(dp3 + 6));
-
-		/* p1 ^= p4 */
-		v0 = veorq_u64(v0, vld1q_u64(dp4 + 0));
-		v1 = veorq_u64(v1, vld1q_u64(dp4 + 2));
-		v2 = veorq_u64(v2, vld1q_u64(dp4 + 4));
-		v3 = veorq_u64(v3, vld1q_u64(dp4 + 6));
-
-		/* store */
-		vst1q_u64(dp1 + 0, v0);
-		vst1q_u64(dp1 + 2, v1);
-		vst1q_u64(dp1 + 4, v2);
-		vst1q_u64(dp1 + 6, v3);
-
-		dp1 += 8;
-		dp2 += 8;
-		dp3 += 8;
-		dp4 += 8;
-	} while (--lines > 0);
-}
-
-static void __xor_eor3_5(unsigned long bytes, unsigned long * __restrict p1,
-		const unsigned long * __restrict p2,
-		const unsigned long * __restrict p3,
-		const unsigned long * __restrict p4,
-		const unsigned long * __restrict p5)
-{
-	uint64_t *dp1 = (uint64_t *)p1;
-	uint64_t *dp2 = (uint64_t *)p2;
-	uint64_t *dp3 = (uint64_t *)p3;
-	uint64_t *dp4 = (uint64_t *)p4;
-	uint64_t *dp5 = (uint64_t *)p5;
-
-	register uint64x2_t v0, v1, v2, v3;
-	long lines = bytes / (sizeof(uint64x2_t) * 4);
-
-	do {
-		/* p1 ^= p2 ^ p3 */
-		v0 = eor3(vld1q_u64(dp1 + 0), vld1q_u64(dp2 + 0),
-			  vld1q_u64(dp3 + 0));
-		v1 = eor3(vld1q_u64(dp1 + 2), vld1q_u64(dp2 + 2),
-			  vld1q_u64(dp3 + 2));
-		v2 = eor3(vld1q_u64(dp1 + 4), vld1q_u64(dp2 + 4),
-			  vld1q_u64(dp3 + 4));
-		v3 = eor3(vld1q_u64(dp1 + 6), vld1q_u64(dp2 + 6),
-			  vld1q_u64(dp3 + 6));
-
-		/* p1 ^= p4 ^ p5 */
-		v0 = eor3(v0, vld1q_u64(dp4 + 0), vld1q_u64(dp5 + 0));
-		v1 = eor3(v1, vld1q_u64(dp4 + 2), vld1q_u64(dp5 + 2));
-		v2 = eor3(v2, vld1q_u64(dp4 + 4), vld1q_u64(dp5 + 4));
-		v3 = eor3(v3, vld1q_u64(dp4 + 6), vld1q_u64(dp5 + 6));
-
-		/* store */
-		vst1q_u64(dp1 + 0, v0);
-		vst1q_u64(dp1 + 2, v1);
-		vst1q_u64(dp1 + 4, v2);
-		vst1q_u64(dp1 + 6, v3);
-
-		dp1 += 8;
-		dp2 += 8;
-		dp3 += 8;
-		dp4 += 8;
-		dp5 += 8;
-	} while (--lines > 0);
-}
-
-__DO_XOR_BLOCKS(eor3_inner, __xor_neon_2, __xor_eor3_3, __xor_eor3_4,
-		__xor_eor3_5);
diff --git a/lib/raid/xor/xor-neon.c b/lib/raid/xor/xor-neon.c
index a3e2b4af8d36..c7c3cf634e23 100644
--- a/lib/raid/xor/xor-neon.c
+++ b/lib/raid/xor/xor-neon.c
@@ -173,3 +173,7 @@ static void __xor_neon_5(unsigned long bytes, unsigned long * __restrict p1,
 
 __DO_XOR_BLOCKS(neon_inner, __xor_neon_2, __xor_neon_3, __xor_neon_4,
 		__xor_neon_5);
+
+#ifdef CONFIG_ARM64
+extern typeof(__xor_neon_2) __xor_eor3_2 __alias(__xor_neon_2);
+#endif
-- 
2.54.0.rc1.555.g9c883467ad-goog

