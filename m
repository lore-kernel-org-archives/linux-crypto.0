Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECCAD3002CF
	for <linux-crypto@vger.kernel.org>; Fri, 27 Mar 2026 06:02:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774591352; cv=none; b=tZTGhMFxNDCfiUAnLV3H1sZ3SafHRA5nYy4vqH6UHi4GW6lfdGJV6sGXYPUsi7I3atWy6cTMnwRH+i+LL2nSfUWcVTljOjYYQXW57oLIVhMKnAzG5cmaDCUpq9l0WFZUSQEayLoTH4pxZ/2lQPjMNRW+sf3HnCk6MIv1nm+ibmg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774591352; c=relaxed/simple;
	bh=1Gy1ZkyfbPJGN/gD/ZZPMWNJIiamiZNTkeOoJS7nZaw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BAKcUdw+XvzB82CDZOFbhqWf71uAXUVuyU4TAysINTBod9Tjlw4tQ+/mg1LCIcH+snQEDS2IGAmHY1iWaRIMqMb0f55eoPU52cQm/Nvdoot5PXSQRCuNu81zMPo+shTLkUgnVR7lVXEtRtsyOlc6VdzQ6ynfaPeNnxR40D6ErbQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=sjDR3ml1; arc=none smtp.client-ip=209.85.221.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="sjDR3ml1"
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-43b40fb7f95so1496078f8f.3
        for <linux-crypto@vger.kernel.org>; Thu, 26 Mar 2026 23:02:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774591349; x=1775196149; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DMNJkheQOmXo7e7N2Os/3E05O7K3NNwW1iRasmpmKzM=;
        b=sjDR3ml1qglIzaKmPZuQy/ryVgWnDBr8UAQANerEY6J3hW/0uBO+Z3jkTpUGhCxPcm
         cUSw9Vj5CUKf4lTw9gPosemvIs+Tk391P4n8V2QH6qBsB+NxIryTVcQADd8I1bUxW/yn
         MUAb8yEO6AVQyE0YYePSdVGQ8AT/ieoXitNjQaxLkk1u7KHtZ0s4/gIwPsMvh8yqKRjz
         p/lsIDzdGxl+ezScFtl36V96XLrHLlX5D1oVJnxrmS98+tpzImlxvMLcbmOHwI9ORVX9
         j151p0EiR9iEy1A/2y2+gqM3gVPCV+M5H7HbklNjlkTGPN4oHSVrUW5YWDuvwpVfzOSL
         chGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774591349; x=1775196149;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=DMNJkheQOmXo7e7N2Os/3E05O7K3NNwW1iRasmpmKzM=;
        b=lJMoTgHPZsI2N4Td+mzohpTJ9d0n1N5HV1hmZLFB7T7VLL14pHcIl1HgsmMHFS1X7C
         SO6gRHqiUIunTCPNxt9iQjw0kZaBjUPQWIGigDJIJg97pCw6tAIyA9WE/0YAatNreC7h
         WvDOfmqmtmd4ku4Q6Ah2J6RGS1/UcrXvwVOyN7vpspTWaw1Skv8SGgQ8Lr6Rf5DBanat
         WJjHGqd3vkCsaZpu6tvlMhkigQIizM4cFCqIqwqQgHbXw+f5X/Crko4mMP8O+woDT4j1
         EuJeqalgJpV77KhQkFNMVFKwgs++Pj6iAcvqzZtWrbkAG1+WuUC6X/SRX6N7WQpx6ZnE
         0/VQ==
X-Gm-Message-State: AOJu0YzyQW2bcjm3rqFgjw2ygZ6k5oP/RSA2+zdxiNLLbbGOBZjWc3Em
	IgsblWDZaVbBWsRQUkM8eF1FneB7IZ6KkFe0gK/x9qKxNtByqtWx+mTJX/b2C/VV
X-Gm-Gg: ATEYQzyzh5FImKpvLty2DcHt2dcEQd6fr2e9u8eM4IT2LQuschE9kRKJWoWS8a8frRx
	NjcJ5MqGVadNNNz3Q1ac1ZzH6SeenKJadj4eDiK7Eh+XxP+Tf3UQmBaAqORnZUugHRLzswlviSX
	NfKZFdqOE0k2OWQNgCwP8FLF5DSdAv+MvnFlBEBiWo+sVH9lOv6oLfi8Zdkg5P+J1GYD7vNEBfT
	IWyTS1mu5yUg7/eyICNlihlEv0tLtrbo8uEUAgJgh2JMpt51DeaJNY0j3PeO7goDgqJtN+hdSdT
	MAo3GcPBsrMOBDt1558djyLbaFXe5VDUpUN/Ja209oS3R17Ap5a4uBRu4lOzNAdZUb1Ya7Qip7d
	EOftuq8vQxFXpCX+Pxbyv4+envuuiY1sSQqbuGhkZIEQB4IfOSenv01VsYrpFWDvbYbekb03DVD
	HA01kKJubY/h090tst30vSyUakgq8bsD17
X-Received: by 2002:a05:6000:2c0e:b0:43b:4980:b15a with SMTP id ffacd0b85a97d-43b9e9ea07fmr1386811f8f.13.1774591348781;
        Thu, 26 Mar 2026 23:02:28 -0700 (PDT)
Received: from lima-dev.. ([45.89.90.224])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43b919df85csm17960628f8f.28.2026.03.26.23.02.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Mar 2026 23:02:28 -0700 (PDT)
From: Demian Shulhan <demyansh@gmail.com>
To: linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: ebiggers@kernel.org,
	ardb@kernel.org,
	Demian Shulhan <demyansh@gmail.com>
Subject: [PATCH v2] lib/crc: arm64: add NEON accelerated CRC64-NVMe implementation
Date: Fri, 27 Mar 2026 06:02:11 +0000
Message-ID: <20260327060211.902077-1-demyansh@gmail.com>
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
- Safely falls back to the generic implementation on Big-Endian systems.

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
 lib/crc/Kconfig                  |  1 +
 lib/crc/Makefile                 |  8 +++-
 lib/crc/arm64/crc64-neon-inner.c | 82 ++++++++++++++++++++++++++++++++
 lib/crc/arm64/crc64.h            | 29 +++++++++++
 4 files changed, 119 insertions(+), 1 deletion(-)
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
index 000000000000..ad268ad35ab8
--- /dev/null
+++ b/lib/crc/arm64/crc64-neon-inner.c
@@ -0,0 +1,82 @@
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
+	/*
+	 * Reduce the 128-bit value to 64 bits.
+	 * By multiplying the high 64 bits by x^127 mod G (fold_consts_val[1])
+	 * and XORing the result with the low 64 bits.
+	 */
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
index 000000000000..2c1449d57486
--- /dev/null
+++ b/lib/crc/arm64/crc64.h
@@ -0,0 +1,29 @@
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
+			scoped_ksimd() crc = crc64_nvme_arm64_c(crc, p, chunk);
+
+			p += chunk;
+			len -= chunk;
+		} while (len >= 128);
+	}
+	return crc64_nvme_generic(crc, p, len);
+}
-- 
2.43.0

