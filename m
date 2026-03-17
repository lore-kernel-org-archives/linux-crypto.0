Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D12C8347BA7
	for <linux-crypto@vger.kernel.org>; Tue, 17 Mar 2026 06:54:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773730475; cv=none; b=Wo95MOra4G3xZJflRFxrhhIJ1xHLp7er9PnkUEj6DOsd0xeP64rH0twKG7ejWecvz7cWzoeCEkHQlIwlt9Ay7ST2lLjoQ21bBmNr93BgCC4ZPv46ITsj413ySuckgxrnhtthdLeniopAoUTuwq3iSpequ7orSjtndb3P73KUZv0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773730475; c=relaxed/simple;
	bh=s6K1qXuHNPYIqMODAxuXiD/RSS2leplf/53YgH2Kg/c=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=eB9fnHL1CpjNPOqGBRYtzGGXXTbPi2A3gu1jebSlRT4Xhu8QiF9cJOdOp+yAzrTxhmsJD6WViDM3ptgfIeIK5Wm+419Y3qSwOxu1aWk0TjQN0R+0cse9lTjIluE6uROFYKdNTYe8m1N5GJfcQMqaDA+WBBYEanxiWSdsg9fAFpQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EvcQ67hp; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EvcQ67hp"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-48557c8ad47so32007235e9.0
        for <linux-crypto@vger.kernel.org>; Mon, 16 Mar 2026 23:54:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773730472; x=1774335272; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=mrGCC+CocmzcGgukR3GRPQgs/6PmrQrlXMtbOYcjWzs=;
        b=EvcQ67hpkKViQbKH+12rkfIac7Rw+g8jHZTXYSYAcew/paLBLbrxVEAbOLBU9/7PkK
         ww9Cv8RCg9I5+A22VOVG1iieDEcgWqvcWG/58wuE9YYjHIBpqHb79ilugBB9CdjtsVEr
         VeeADTaB4YRArMiPpvsVgvZz2FJjShE7cRQ+tTi+0+8PduFR1IqEX2aw/Pj7TsM0sGZK
         dFSg8/HHBGetpqV1QBOHTYasgGLgbFdAyWuwWNJBI0tGP8ZwPrQAU8AXMug9N2Nr9z53
         tMeMzvq6fZE4IgL3bufJbAk154gNHxMm3YcgyJeNR1UNstFtw1ihJ9yBtYQP6yagjyjm
         Ck+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773730472; x=1774335272;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mrGCC+CocmzcGgukR3GRPQgs/6PmrQrlXMtbOYcjWzs=;
        b=Nh72HWbkiO0rjORlLV1sjvInpqnSSUgbvEflgHICZJglA7hAGgbrTF+EurV/a7puR2
         Ejh5AtBlxS2P0TozSaICCrpA3NYv5mty4C/CDKw90XitFuaNpxUe9kzl3Syw11/V1jCP
         JYTCFQBYORtqNTE/kYf+IAHfJHBpvCRHLlzFUPJCdj81oiNhTSqt501otMhjqEGwcu0O
         SzPc78fvA/YX+F1Zch5WHuFC4Xp76Ft+TWe4XteYHKhF4fyNhazTKgpVc+3buA8hMN92
         u8ZmGSgMnAlHLCCQMZEDuj+SYbuIMv4/bOncpQ+0lbbndOyS5Hgmbn+ykVlmPRy6C/9F
         gl4g==
X-Gm-Message-State: AOJu0YwsX+8ecvvNsjzFeR9hmVPRipjHLjBhqpSprJJXHpSXrm++4BL8
	BZlJWOXbixSSqV4df3L1GjZHYnFDqm2okXxoZVGmJDtEPNdVpjCsQN/5
X-Gm-Gg: ATEYQzyn02GdytpmRyGnxXW1VQ2ZZ3bx4v7Bg7DVM2+Q0U9rL3jWN0D0y01o7GVy3Db
	8vkBH9HbSB9h201M5hAeulomN1TW2RDE2kGX7fy1dYkm+dDJdJrjKmqs4cUonZk9maYYK0kvL06
	ZS1cUpcCpj5eZTUOqAoe8Biw9JF/fvY6ZnMbakdHMuQVFZyOIxFpMQx8ftl/UYb/dQd262P+f5A
	9ULhlGqxz4w4Ep4VDI3IW5U1dA020w4f9NOPtIprSKLsIs8j+ZolfZ8IBZvnovU0UareY4o4yd7
	vPZNJ3AM3AvFFtz2I6TMpMENIRuEpxird7d3L+Qk5giTdn5o3KWHPNmgbLRXYhk4+loW/ttyDic
	q0mJFy6Ozaj3pzSJ2/SnCHwC3ikHGh81Cw74t6mDnauC2w2JdOeVLL8BpS23dC9fc2PXWCIGIqY
	HLT3nxVW2MoEgsKBPr1bQVYOCqvN7U6KaPQw==
X-Received: by 2002:a05:600c:1d0f:b0:485:3f38:3de3 with SMTP id 5b1f17b1804b1-485566d2fc4mr258602615e9.3.1773730471823;
        Mon, 16 Mar 2026 23:54:31 -0700 (PDT)
Received: from lima-dev.. ([45.89.90.224])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4857f49d327sm10404455e9.11.2026.03.16.23.54.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Mar 2026 23:54:31 -0700 (PDT)
From: Demian Shulhan <demyansh@gmail.com>
To: ebiggers@kernel.org,
	ardb@kernel.org
Cc: linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Demian Shulhan <demyansh@gmail.com>
Subject: [PATCH] lib/crc: arm64: add NEON accelerated CRC64-NVMe implementation
Date: Tue, 17 Mar 2026 06:54:25 +0000
Message-ID: <20260317065425.2684093-1-demyansh@gmail.com>
X-Mailer: git-send-email 2.43.0
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
- Safely falls back to the generic implementation on Big-Endian systems.

Performance results (kunit crc_benchmark on Cortex-A72):
- Generic (len=4096): ~268 MB/s
- PMULL (len=4096): ~1556 MB/s (nearly 6x improvement)

Signed-off-by: Demian Shulhan <demyansh@gmail.com>
---
 lib/crc/Kconfig                  |  1 +
 lib/crc/Makefile                 |  4 ++
 lib/crc/arm64/crc64-neon-inner.c | 82 ++++++++++++++++++++++++++++++++
 lib/crc/arm64/crc64.h            | 35 ++++++++++++++
 4 files changed, 122 insertions(+)
 create mode 100644 lib/crc/arm64/crc64-neon-inner.c
 create mode 100644 lib/crc/arm64/crc64.h

diff --git a/lib/crc/Kconfig b/lib/crc/Kconfig
index 70e7a6016de3..6b6c7d9f5ea5 100644
--- a/lib/crc/Kconfig
+++ b/lib/crc/Kconfig
@@ -82,6 +82,7 @@ config CRC64
 config CRC64_ARCH
 	bool
 	depends on CRC64 && CRC_OPTIMIZATIONS
+	default y if ARM64 && KERNEL_MODE_NEON
 	default y if RISCV && RISCV_ISA_ZBC && 64BIT
 	default y if X86_64
 
diff --git a/lib/crc/Makefile b/lib/crc/Makefile
index 7543ad295ab6..552760f28003 100644
--- a/lib/crc/Makefile
+++ b/lib/crc/Makefile
@@ -38,6 +38,10 @@ obj-$(CONFIG_CRC64) += crc64.o
 crc64-y := crc64-main.o
 ifeq ($(CONFIG_CRC64_ARCH),y)
 CFLAGS_crc64-main.o += -I$(src)/$(SRCARCH)
+CFLAGS_REMOVE_arm64/crc64-neon-inner.o += -mgeneral-regs-only
+CFLAGS_arm64/crc64-neon-inner.o += -ffreestanding -march=armv8-a+crypto
+CFLAGS_arm64/crc64-neon-inner.o += -isystem $(shell $(CC) -print-file-name=include)
+crc64-$(CONFIG_ARM64) += arm64/crc64-neon-inner.o
 crc64-$(CONFIG_RISCV) += riscv/crc64_lsb.o riscv/crc64_msb.o
 crc64-$(CONFIG_X86) += x86/crc64-pclmul.o
 endif
diff --git a/lib/crc/arm64/crc64-neon-inner.c b/lib/crc/arm64/crc64-neon-inner.c
new file mode 100644
index 000000000000..beefdec5456b
--- /dev/null
+++ b/lib/crc/arm64/crc64-neon-inner.c
@@ -0,0 +1,82 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Accelerated CRC64 (NVMe) using ARM NEON C intrinsics
+ */
+
+#include <linux/types.h>
+#include <linux/crc64.h>
+#ifdef CONFIG_ARM64
+#include <asm/neon-intrinsics.h>
+#else
+#include <arm_neon.h>
+#endif
+
+#define GET_P64_0(v) ((poly64_t)vgetq_lane_u64(vreinterpretq_u64_p64(v), 0))
+#define GET_P64_1(v) ((poly64_t)vgetq_lane_u64(vreinterpretq_u64_p64(v), 1))
+
+static const u64 fold_consts_val[2] = {0xeadc41fd2ba3d420ULL, 0x21e9761e252621acULL};
+static const u64 bconsts_val[2] = {0x27ecfa329aef9f77ULL, 0x34d926535897936aULL};
+
+u64 crc64_nvme_arm64_c(u64 crc, const u8 *p, size_t len)
+{
+	if (len == 0)
+		return crc;
+
+	uint64x2_t v0_u64 = {crc, 0};
+	poly64x2_t v0 = vreinterpretq_p64_u64(v0_u64);
+
+	poly64x2_t fold_consts = vreinterpretq_p64_u64(vld1q_u64(fold_consts_val));
+
+	if (len >= 16) {
+		poly64x2_t v1 = vreinterpretq_p64_u8(vld1q_u8(p));
+
+		v0 = vreinterpretq_p64_u8(veorq_u8(vreinterpretq_u8_p64(v0),
+						   vreinterpretq_u8_p64(v1)));
+		p += 16;
+		len -= 16;
+
+		while (len >= 16) {
+			v1 = vreinterpretq_p64_u8(vld1q_u8(p));
+
+			poly128_t v2 = vmull_high_p64(fold_consts, v0);
+			poly128_t v0_128 = vmull_p64(GET_P64_0(fold_consts), GET_P64_0(v0));
+
+			uint8x16_t x0 = veorq_u8(vreinterpretq_u8_p128(v0_128),
+						 vreinterpretq_u8_p128(v2));
+
+			x0 = veorq_u8(x0, vreinterpretq_u8_p64(v1));
+			v0 = vreinterpretq_p64_u8(x0);
+
+			p += 16;
+			len -= 16;
+		}
+
+		poly64x2_t v7 = vreinterpretq_p64_u64((uint64x2_t){0, 0});
+
+		poly128_t v1_128 = vmull_p64(GET_P64_1(fold_consts), GET_P64_0(v0));
+
+		uint8x16_t ext_v0 = vextq_u8(vreinterpretq_u8_p64(v0), vreinterpretq_u8_p64(v7), 8);
+		uint8x16_t x0 = veorq_u8(ext_v0, vreinterpretq_u8_p128(v1_128));
+
+		v0 = vreinterpretq_p64_u8(x0);
+
+		poly64x2_t bconsts = vreinterpretq_p64_u64(vld1q_u64(bconsts_val));
+
+		v1_128 = vmull_p64(GET_P64_0(bconsts), GET_P64_0(v0));
+
+		poly64x2_t v1_64 = vreinterpretq_p64_u8(vreinterpretq_u8_p128(v1_128));
+		poly128_t v3_128 = vmull_p64(GET_P64_1(bconsts), GET_P64_0(v1_64));
+
+		x0 = veorq_u8(vreinterpretq_u8_p64(v0), vreinterpretq_u8_p128(v3_128));
+
+		uint8x16_t ext_v2 = vextq_u8(vreinterpretq_u8_p64(v7),
+					     vreinterpretq_u8_p128(v1_128), 8);
+
+		x0 = veorq_u8(x0, ext_v2);
+
+		v0 = vreinterpretq_p64_u8(x0);
+		crc = vgetq_lane_u64(vreinterpretq_u64_p64(v0), 1);
+	}
+
+	return crc;
+}
diff --git a/lib/crc/arm64/crc64.h b/lib/crc/arm64/crc64.h
new file mode 100644
index 000000000000..12b1a8bd518a
--- /dev/null
+++ b/lib/crc/arm64/crc64.h
@@ -0,0 +1,35 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * CRC64 using ARM64 PMULL instructions
+ */
+#ifndef _ARM64_CRC64_H
+#define _ARM64_CRC64_H
+
+#include <asm/cpufeature.h>
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
+	if (!IS_ENABLED(CONFIG_CPU_BIG_ENDIAN) && len >= 128 &&
+	    cpu_have_named_feature(PMULL) && likely(may_use_simd())) {
+		while (len >= 128) {
+			size_t chunk = min_t(size_t, len & ~15, SZ_4K);
+
+			scoped_ksimd() {
+				crc = crc64_nvme_arm64_c(crc, p, chunk);
+			}
+			p += chunk;
+			len -= chunk;
+		}
+	}
+	return crc64_nvme_generic(crc, p, len);
+}
+
+#endif /* _ARM64_CRC64_H */
+
-- 
2.43.0

