Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF96B26ED59
	for <linux-crypto@vger.kernel.org>; Sun, 29 Mar 2026 07:43:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774770226; cv=none; b=g/F/AsGv2M9Eo/ENkKsrximUK8cxa5Eq+bWIN+fy3ULhU1abIdr0K/IxOZNBeIH1bB762/eNhgHtnd/jN4kHBrGuEhD74HxY5gRmT6Q5vzQdQgf5rD4+wFwgNIriSfzh61BhD8Wu2ir3u04qa/IrOUW27YvF0azGiLEjc2LVip0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774770226; c=relaxed/simple;
	bh=ZQxTUnGJ7EyXTmiyyB9+ysKAsAt1gRuRaGjAPxV88fc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oOaxaw5k/ZsSKjr/M20tgobcFFuo0RIDfTAWaq1GpCA0O+382+nZxSXtQ1VkuLxNpdK5/4RVwuFt5RWjh2SbABxAZLvO1ImQS6GzlYRkHX9egRhdjJq2ckoOm5jiYYpIjPwvQvAB7WgROEx14Ztzjxx01GJmbxmZ+fFGLmiQLbU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=d34oj+z4; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="d34oj+z4"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-486fd5360d4so45747425e9.1
        for <linux-crypto@vger.kernel.org>; Sun, 29 Mar 2026 00:43:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774770222; x=1775375022; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mR7zW5huiWH1x5CVyoEzlAdCsPYlEqDzaC0AadT8DWY=;
        b=d34oj+z40cPqo3BbYPhEwncEeElBDQRfbnXoK9DfzdTxxacQGQXnwKTF7EKxYWrxvb
         RWuUum/z8F31WwQxi7p/qwKmWiS19A9vJjrsZ+soVLyYw6C3kMuxf95g4zD2BUh/4/Kt
         w1gNZhjC0mJ9bJvxSwQUg3LcZG6ku2gFn3Te+lSnKmD5cQaODiIbu5cw57XvT60Es4//
         R/r3O2Iv86CqZqe8bOjPQ81gylQnrdCGfhCq/hkqbSO2dTaf79O6WErTbgdqiEagDQyX
         UJZIuYBEmmx4CgSj3gsJtq4+nsu2Gm8cc8kCXNrms2VGDDIyHz5NTxRHimFR3o+kV77J
         9TtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774770222; x=1775375022;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=mR7zW5huiWH1x5CVyoEzlAdCsPYlEqDzaC0AadT8DWY=;
        b=m6p14JGD7sKEzeoPr2p4YD6+PKpEw08Ix36EZEV40hyX82dZ7MK00eYux5EYB7XMgT
         TQpqCiFilI/PGu8Ol5bQk1sRkf/WwbBqyPfnuRcjOZrXJdQwOLQyeL+ANokQERLN3QQ9
         gAn+pchvL1MhcpdY2zxiwUAyb/4ihdDiIZjya7jvzj34sUj98RXsqAa9gfCco6IYZ9Ae
         M0TXArZVocUS+9EVYOfJlIySiKbGU4I0efCjk84xDfi16SVm2utYlagzf+uw25nTbWg2
         zBI1B6AarFahqGalaQWmyy7ywvV9Fo1JrVAA7IZDclvemnA55IeimPNbconmeXxcLIfN
         6rCQ==
X-Gm-Message-State: AOJu0YwMg2qif6yUCABcvrpqCLj+B98Fo6po2YSg+Gu5D7/Y2wNbn5Pf
	s7+LoEP9ghFK5Efq8HI7rdolqQ0FsCu6EHPoM2h/EXYTOaDH6IXOhQJSHgtYhEgB
X-Gm-Gg: ATEYQzyn3lD46Z6xYifVa8gwP29M2ur90h/OkBYiqXCrAsgfdEbySLBrFDNWYo3Nbgd
	M56lWAqG7c0OKDSrHcZlxn5t3ahY+to7y0dJvQXjqJfgQ3BmF6kTyhu/Ju7AAISFook7OxAfUDv
	7RhwMvJse11V1jM3kaNefSMuDuSebDcrxL29I66HLtALLUKE1f7egnDD3qPnjyZbN53/LPYF8Oh
	c8vq4WG7dlBmw0dJomRkHZJp8UtVZr62g5wUBblsOiyjOR14ZX7VUzELoDC1f/RwQNm7Y+b/4Zk
	dTcbmrr1zVq9sHOSlWGSIrjSyk00G6db5JKlthSU5VSpbXyXfksfcMOA1sOKKiMmMBIEl0WP1MG
	ebVcS1bKW52s3jK9ORTVoeOru7fq9L5G6uwx/RvuaT/uc5/qv7rZ5mnjQL4ZrHALD3TMxSMeoXt
	0OnXGRXVqpiwt8VDzEU3SVmhG4ItLlXmZR
X-Received: by 2002:a05:600c:8b31:b0:485:30f7:6e88 with SMTP id 5b1f17b1804b1-48727efabdemr165719785e9.31.1774770221785;
        Sun, 29 Mar 2026 00:43:41 -0700 (PDT)
Received: from lima-dev.. ([45.89.90.224])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48722d38a5fsm193112255e9.12.2026.03.29.00.43.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 29 Mar 2026 00:43:41 -0700 (PDT)
From: Demian Shulhan <demyansh@gmail.com>
To: linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: ebiggers@kernel.org,
	ardb@kernel.org,
	Demian Shulhan <demyansh@gmail.com>
Subject: [PATCH v3] lib/crc: arm64: add NEON accelerated CRC64-NVMe implementation
Date: Sun, 29 Mar 2026 07:43:38 +0000
Message-ID: <20260329074338.1053550-1-demyansh@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260317065425.2684093-1-demyansh@gmail.com>
References: <20260317065425.2684093-1-demyansh@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Implement an optimized CRC64 (NVMe) algorithm for ARM64 using NEON
Polynomial Multiply Long (PMULL) instructions. The generic shift-and-XOR
software implementation is slow, which creates a bottleneck in NVMe and
other storage subsystems.

The acceleration is implemented using C intrinsics (<arm_neon.h>) rather
than raw assembly for better readability and maintainability.

Key highlights of this implementation:
- Uses 4KB chunking inside scoped_ksimd() to avoid preemption latency
  spikes on large buffers.
- Pre-calculates and loads fold constants via vld1q_u64() to minimize
  register spilling.
- Benchmarks show the break-even point against the generic implementation
  is around 128 bytes. The PMULL path is enabled only for len >= 128.

Performance results (kunit crc_benchmark on Cortex-A72):
- Generic (len=4096): ~268 MB/s
- PMULL (len=4096): ~1556 MB/s (nearly 6x improvement)

Signed-off-by: Demian Shulhan <demyansh@gmail.com>
---
v2: - Removed KERNEL_MODE_NEON check from Kconfig as it's redundant on arm64.
  - Added missing prototype for crc64_nvme_arm64_c to fix sparse/W=1 warning.
  - Improved readability in Makefile with extra newlines and comments.
  - Removed redundant include guards in crc64.h.
  - Switched to do-while loops for better optimization in hot paths.
  - Added comments explaining the magic constants (fold/Barrett).
---
v3: - Removed big-endian fallback from the commit message.
  - Rewrote the comment explaining the final Barrett reduction step.
  - Adjusted the formatting of the scoped_ksimd() call.
---
 lib/crc/Kconfig                  |  1 +
 lib/crc/Makefile                 |  8 +++-
 lib/crc/arm64/crc64-neon-inner.c | 78 ++++++++++++++++++++++++++++++++
 lib/crc/arm64/crc64.h            | 30 ++++++++++++
 4 files changed, 116 insertions(+), 1 deletion(-)
 create mode 100644 lib/crc/arm64/crc64-neon-inner.c
 create mode 100644 lib/crc/arm64/crc64.h

diff --git a/lib/crc/Kconfig b/lib/crc/Kconfig
index 70e7a6016de3..16cb42d5e306 100644
--- a/lib/crc/Kconfig
+++ b/lib/crc/Kconfig
@@ -82,6 +82,7 @@ config CRC64
 config CRC64_ARCH
 	bool
 	depends on CRC64 && CRC_OPTIMIZATIONS
+	default y if ARM64
 	default y if RISCV && RISCV_ISA_ZBC && 64BIT
 	default y if X86_64
 
diff --git a/lib/crc/Makefile b/lib/crc/Makefile
index 7543ad295ab6..c9c35419b39c 100644
--- a/lib/crc/Makefile
+++ b/lib/crc/Makefile
@@ -38,9 +38,15 @@ obj-$(CONFIG_CRC64) += crc64.o
 crc64-y := crc64-main.o
 ifeq ($(CONFIG_CRC64_ARCH),y)
 CFLAGS_crc64-main.o += -I$(src)/$(SRCARCH)
+
+CFLAGS_REMOVE_arm64/crc64-neon-inner.o += -mgeneral-regs-only
+CFLAGS_arm64/crc64-neon-inner.o += -ffreestanding -march=armv8-a+crypto
+CFLAGS_arm64/crc64-neon-inner.o += -isystem $(shell $(CC) -print-file-name=include)
+crc64-$(CONFIG_ARM64) += arm64/crc64-neon-inner.o
+
 crc64-$(CONFIG_RISCV) += riscv/crc64_lsb.o riscv/crc64_msb.o
 crc64-$(CONFIG_X86) += x86/crc64-pclmul.o
-endif
+endif # CONFIG_CRC64_ARCH
 
 obj-y += tests/
 
diff --git a/lib/crc/arm64/crc64-neon-inner.c b/lib/crc/arm64/crc64-neon-inner.c
new file mode 100644
index 000000000000..881cdafadb37
--- /dev/null
+++ b/lib/crc/arm64/crc64-neon-inner.c
@@ -0,0 +1,78 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Accelerated CRC64 (NVMe) using ARM NEON C intrinsics
+ */
+
+#include <linux/types.h>
+#include <asm/neon-intrinsics.h>
+
+u64 crc64_nvme_arm64_c(u64 crc, const u8 *p, size_t len);
+
+#define GET_P64_0(v) ((poly64_t)vgetq_lane_u64(vreinterpretq_u64_p64(v), 0))
+#define GET_P64_1(v) ((poly64_t)vgetq_lane_u64(vreinterpretq_u64_p64(v), 1))
+
+/* x^191 mod G, x^127 mod G */
+static const u64 fold_consts_val[2] = { 0xeadc41fd2ba3d420ULL,
+					0x21e9761e252621acULL };
+/* floor(x^127 / G), (G - x^64) / x */
+static const u64 bconsts_val[2] = { 0x27ecfa329aef9f77ULL,
+				    0x34d926535897936aULL };
+
+u64 crc64_nvme_arm64_c(u64 crc, const u8 *p, size_t len)
+{
+	uint64x2_t v0_u64 = { crc, 0 };
+	poly64x2_t v0 = vreinterpretq_p64_u64(v0_u64);
+	poly64x2_t fold_consts =
+		vreinterpretq_p64_u64(vld1q_u64(fold_consts_val));
+	poly64x2_t v1 = vreinterpretq_p64_u8(vld1q_u8(p));
+
+	v0 = vreinterpretq_p64_u8(veorq_u8(vreinterpretq_u8_p64(v0),
+					   vreinterpretq_u8_p64(v1)));
+	p += 16;
+	len -= 16;
+
+	do {
+		v1 = vreinterpretq_p64_u8(vld1q_u8(p));
+
+		poly128_t v2 = vmull_high_p64(fold_consts, v0);
+		poly128_t v0_128 =
+			vmull_p64(GET_P64_0(fold_consts), GET_P64_0(v0));
+
+		uint8x16_t x0 = veorq_u8(vreinterpretq_u8_p128(v0_128),
+					 vreinterpretq_u8_p128(v2));
+
+		x0 = veorq_u8(x0, vreinterpretq_u8_p64(v1));
+		v0 = vreinterpretq_p64_u8(x0);
+
+		p += 16;
+		len -= 16;
+	} while (len >= 16);
+
+	/* Multiply the 128-bit value by x^64 and reduce it back to 128 bits. */
+	poly64x2_t v7 = vreinterpretq_p64_u64((uint64x2_t){ 0, 0 });
+	poly128_t v1_128 = vmull_p64(GET_P64_1(fold_consts), GET_P64_0(v0));
+
+	uint8x16_t ext_v0 =
+		vextq_u8(vreinterpretq_u8_p64(v0), vreinterpretq_u8_p64(v7), 8);
+	uint8x16_t x0 = veorq_u8(ext_v0, vreinterpretq_u8_p128(v1_128));
+
+	v0 = vreinterpretq_p64_u8(x0);
+
+	/* Final Barrett reduction */
+	poly64x2_t bconsts = vreinterpretq_p64_u64(vld1q_u64(bconsts_val));
+
+	v1_128 = vmull_p64(GET_P64_0(bconsts), GET_P64_0(v0));
+
+	poly64x2_t v1_64 = vreinterpretq_p64_u8(vreinterpretq_u8_p128(v1_128));
+	poly128_t v3_128 = vmull_p64(GET_P64_1(bconsts), GET_P64_0(v1_64));
+
+	x0 = veorq_u8(vreinterpretq_u8_p64(v0), vreinterpretq_u8_p128(v3_128));
+
+	uint8x16_t ext_v2 = vextq_u8(vreinterpretq_u8_p64(v7),
+				     vreinterpretq_u8_p128(v1_128), 8);
+
+	x0 = veorq_u8(x0, ext_v2);
+
+	v0 = vreinterpretq_p64_u8(x0);
+	return vgetq_lane_u64(vreinterpretq_u64_p64(v0), 1);
+}
diff --git a/lib/crc/arm64/crc64.h b/lib/crc/arm64/crc64.h
new file mode 100644
index 000000000000..cc65abeee24c
--- /dev/null
+++ b/lib/crc/arm64/crc64.h
@@ -0,0 +1,30 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * CRC64 using ARM64 PMULL instructions
+ */
+
+#include <linux/cpufeature.h>
+#include <asm/simd.h>
+#include <linux/minmax.h>
+#include <linux/sizes.h>
+
+u64 crc64_nvme_arm64_c(u64 crc, const u8 *p, size_t len);
+
+#define crc64_be_arch crc64_be_generic
+
+static inline u64 crc64_nvme_arch(u64 crc, const u8 *p, size_t len)
+{
+	if (len >= 128 && cpu_have_named_feature(PMULL) &&
+	    likely(may_use_simd())) {
+		do {
+			size_t chunk = min_t(size_t, len & ~15, SZ_4K);
+
+			scoped_ksimd()
+				crc = crc64_nvme_arm64_c(crc, p, chunk);
+
+			p += chunk;
+			len -= chunk;
+		} while (len >= 128);
+	}
+	return crc64_nvme_generic(crc, p, len);
+}
-- 
2.43.0

