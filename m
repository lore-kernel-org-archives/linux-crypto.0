Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00F0B347532
	for <linux-crypto@vger.kernel.org>; Wed, 22 Apr 2026 17:17:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776878244; cv=none; b=NRNnYfGtvK+HFfC8EsfTuB7kiYOcKlPQyJTyvmBvdhUd/E4fE+E62BUOjDrO82/Yzm+OMvaR9NdYA0VkI0MAeZYePBCfKAPBzxx7GlW/cewdXp0YzKwXmTLtD8lMEdzACQLTjd94f9xha1Rhi/Y3iX+ZvF2v3kRiMrjAdOBQ3bk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776878244; c=relaxed/simple;
	bh=hF3dHYxyJgYlp94GIvkLxwm/zVdatybx8AAETislGMA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=a73ogXJG4c/SefdikokWeECXLgJi5/zzeljzbZb1jcXQ5HpohbujZcFY5WY411FynYMh0YwPW6FpBOFaoWDdIz3K/dRrdjo+yWeijEevwSb0jSZ8+tZwWjpojtn3EH6rBzkT83CzIBxjNwqPREQFfuMIyHZbaQ1Zmt41tCMP3oc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=v2ZFGnPd; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="v2ZFGnPd"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-488d8deb75fso45845645e9.3
        for <linux-crypto@vger.kernel.org>; Wed, 22 Apr 2026 10:17:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1776878241; x=1777483041; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=NcINISGc0KST4+Nvm9mjXv44pjIWS9tTY4a9BkZBdcs=;
        b=v2ZFGnPdtn+on3ZrjuVz0Y/XJy1TrmWrgrG2eMzIqN75XUq2zOshj7LPZnaGZJMCM1
         h/vzOv2oetiqBV3XeYmXBQUbOK8z8vJ7u0eV8bJm3ZEX0t4Uk6sI2PRvD9fZDvgBAcv9
         jYnbNY9jZiCQp1X2qBehk3DPf1cmZiR04kEDElkM9il5Y9/QSFyoWd9FGp7w3bj8uvy9
         2XVYR3+k8NGtt9Pqk99kOhVsMF1KlpGpX5q1TFq2n1VOSg4YIUFQzVc16CYMkVJBKIKl
         NVnO0Soo2QKM2UgJmm2j1OetL1DprKPZgFMg+KNe+gxzWpMtHG8/sU10sltju0fOF/WY
         VHCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776878241; x=1777483041;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NcINISGc0KST4+Nvm9mjXv44pjIWS9tTY4a9BkZBdcs=;
        b=ESjCxlhIA2zFfRVz0E2rY3KGFKArKrWwLP0YOqKYQwvaF7XD/eagUHyrqY6N0SpjZw
         juiIHbIbpO7g8zleW/2CT5jsqLjcs/JbvMlmV+cMM2pYW5KHUTWMztSypPECQEUNB+a+
         5DLVPC+/bNVR7HnwDKcnNJOeICdjJR8evqbtexuLhG66gcy7XM/SPpAbRhXvM2fnWS/z
         6XclncxOLqudK2Gv+luixlnY64jMaqadM/+omKiRLyvXTCtizJQvn+VMy5+/rRbkpwFH
         bFdyFlWF713Yuje7Bmbzzpa9GJaqeYybCxhMcLVqjDvUz+Ueog9y/hgHvWf00pivcBOo
         W/ag==
X-Gm-Message-State: AOJu0Yyguzy1yXYGOIRyrhs8O2jHE6qSGNPBUaE4BJuscbhMr98L0aiF
	ARMQUn7fpxkkBssvbWq17t35S/zbbR+U5HhausUQcJfF+Wie/U6fXkg+KFHWQYHqBVE5C2TZ9Q=
	=
X-Received: from wmbjq20.prod.google.com ([2002:a05:600c:55d4:b0:488:e127:ac83])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:8587:b0:485:3f30:6250
 with SMTP id 5b1f17b1804b1-488fb7856b9mr255517905e9.20.1776878241449; Wed, 22
 Apr 2026 10:17:21 -0700 (PDT)
Date: Wed, 22 Apr 2026 19:17:01 +0200
In-Reply-To: <20260422171655.3437334-10-ardb+git@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260422171655.3437334-10-ardb+git@google.com>
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=5409; i=ardb@kernel.org;
 h=from:subject; bh=ca3n2psIM2wJk1WPOo/STNIlxMD5Xef04Kw+2CG+jJ8=;
 b=owGbwMvMwCVmkMcZplerG8N4Wi2JIfMl04SqXWqv7RQbNd9bCZgty7y0/xw3a853fXV5vdD9g
 dtXTJPuKGVhEONikBVTZBGY/ffdztMTpWqdZ8nCzGFlAhnCwMUpABPRbGD4H3dZaT7P/CDj4jfh
 CRldKeuPCB5Un3qN69bHOhf2dVpnnRkZdjb8WFxtr7Z7rVfZ9Lt8PjNNnrf0by629J8/9a3xeae LrAA=
X-Mailer: git-send-email 2.54.0.rc2.544.gc7ae2d5bb8-goog
Message-ID: <20260422171655.3437334-15-ardb+git@google.com>
Subject: [PATCH 5/8] lib/crc: arm: Enable arm64's NEON intrinsics
 implementation of crc64
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-crypto@vger.kernel.org, linux-raid@vger.kernel.org, 
	Ard Biesheuvel <ardb@kernel.org>, Christoph Hellwig <hch@lst.de>, Russell King <linux@armlinux.org.uk>, 
	Arnd Bergmann <arnd@arndb.de>, Eric Biggers <ebiggers@kernel.org>
Content-Type: text/plain; charset="UTF-8"

From: Ard Biesheuvel <ardb@kernel.org>

Tweak the NEON intrinsics crc64 code written for arm64 so it can be
built for 32-bit ARM as well. The only workaround needed is to provide
alternatives for vmull_p64() and vmull_high_p64() on Clang, which only
defines those when building for the AArch64 or arm64ec ISA. Use the same
helpers for GCC too, to avoid doubling the size of the test/validation
matrix.

KUnit benchmark results (Cortex-A53 @ 1 Ghz)

Before:

   # crc64_nvme_benchmark: len=1: 35 MB/s
   # crc64_nvme_benchmark: len=16: 78 MB/s
   # crc64_nvme_benchmark: len=64: 87 MB/s
   # crc64_nvme_benchmark: len=127: 88 MB/s
   # crc64_nvme_benchmark: len=128: 88 MB/s
   # crc64_nvme_benchmark: len=200: 89 MB/s
   # crc64_nvme_benchmark: len=256: 89 MB/s
   # crc64_nvme_benchmark: len=511: 89 MB/s
   # crc64_nvme_benchmark: len=512: 89 MB/s
   # crc64_nvme_benchmark: len=1024: 90 MB/s
   # crc64_nvme_benchmark: len=3173: 90 MB/s
   # crc64_nvme_benchmark: len=4096: 90 MB/s
   # crc64_nvme_benchmark: len=16384: 90 MB/s

After:

   # crc64_nvme_benchmark: len=1: 32 MB/s
   # crc64_nvme_benchmark: len=16: 76 MB/s
   # crc64_nvme_benchmark: len=64: 71 MB/s
   # crc64_nvme_benchmark: len=127: 88 MB/s
   # crc64_nvme_benchmark: len=128: 618 MB/s
   # crc64_nvme_benchmark: len=200: 542 MB/s
   # crc64_nvme_benchmark: len=256: 920 MB/s
   # crc64_nvme_benchmark: len=511: 836 MB/s
   # crc64_nvme_benchmark: len=512: 1261 MB/s
   # crc64_nvme_benchmark: len=1024: 1531 MB/s
   # crc64_nvme_benchmark: len=3173: 1731 MB/s
   # crc64_nvme_benchmark: len=4096: 1851 MB/s
   # crc64_nvme_benchmark: len=16384: 1858 MB/s

Don't bother with big-endian, as it doesn't work correctly on Clang, and
is barely used these days.

Note that ARM disables preemption and softirq processing when using
kernel mode SIMD, so take care not to hog the CPU for too long.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 lib/crc/Kconfig          |  1 +
 lib/crc/Makefile         |  5 ++-
 lib/crc/arm/crc64-neon.h | 34 ++++++++++++++++++
 lib/crc/arm/crc64.h      | 36 ++++++++++++++++++++
 4 files changed, 75 insertions(+), 1 deletion(-)

diff --git a/lib/crc/Kconfig b/lib/crc/Kconfig
index 31038c8d111a..86a0e4bfec77 100644
--- a/lib/crc/Kconfig
+++ b/lib/crc/Kconfig
@@ -82,6 +82,7 @@ config CRC64
 config CRC64_ARCH
 	bool
 	depends on CRC64 && CRC_OPTIMIZATIONS
+	default y if ARM && KERNEL_MODE_NEON && !CPU_BIG_ENDIAN
 	default y if ARM64
 	default y if RISCV && RISCV_ISA_ZBC && 64BIT
 	default y if X86_64
diff --git a/lib/crc/Makefile b/lib/crc/Makefile
index 193257ae466f..386e9c175263 100644
--- a/lib/crc/Makefile
+++ b/lib/crc/Makefile
@@ -39,8 +39,11 @@ crc64-y := crc64-main.o
 ifeq ($(CONFIG_CRC64_ARCH),y)
 CFLAGS_crc64-main.o += -I$(src)/$(SRCARCH)
 
+crc64-cflags-$(CONFIG_ARM) += -march=armv8-a -mfpu=crypto-neon-fp-armv8
+crc64-cflags-$(CONFIG_ARM64) += -march=armv8-a+crypto
 CFLAGS_REMOVE_crc64-neon.o += $(CC_FLAGS_NO_FPU)
-CFLAGS_crc64-neon.o += $(CC_FLAGS_FPU) -I$(src)/$(SRCARCH) -march=armv8-a+crypto
+CFLAGS_crc64-neon.o += $(CC_FLAGS_FPU) -I$(src)/$(SRCARCH) $(crc64-cflags-y)
+crc64-$(CONFIG_ARM) += crc64-neon.o
 crc64-$(CONFIG_ARM64) += crc64-neon.o
 
 crc64-$(CONFIG_RISCV) += riscv/crc64_lsb.o riscv/crc64_msb.o
diff --git a/lib/crc/arm/crc64-neon.h b/lib/crc/arm/crc64-neon.h
new file mode 100644
index 000000000000..645f553220ff
--- /dev/null
+++ b/lib/crc/arm/crc64-neon.h
@@ -0,0 +1,34 @@
+// SPDX-License-Identifier: GPL-2.0-only
+
+static inline uint64x2_t pmull64(uint64x2_t a, uint64x2_t b)
+{
+	uint64_t l = vgetq_lane_u64(a, 0);
+	uint64_t m = vgetq_lane_u64(b, 0);
+	uint64x2_t result;
+
+	asm("vmull.p64	%q0, %P1, %P2" : "=w"(result) : "w"(l), "w"(m));
+
+	return result;
+}
+
+static inline uint64x2_t pmull64_high(uint64x2_t a, uint64x2_t b)
+{
+	uint64_t l = vgetq_lane_u64(a, 1);
+	uint64_t m = vgetq_lane_u64(b, 1);
+	uint64x2_t result;
+
+	asm("vmull.p64	%q0, %P1, %P2" : "=w"(result) : "w"(l), "w"(m));
+
+	return result;
+}
+
+static inline uint64x2_t pmull64_hi_lo(uint64x2_t a, uint64x2_t b)
+{
+	uint64_t l = vgetq_lane_u64(a, 1);
+	uint64_t m = vgetq_lane_u64(b, 0);
+	uint64x2_t result;
+
+	asm("vmull.p64	%q0, %P1, %P2" : "=w"(result) : "w"(l), "w"(m));
+
+	return result;
+}
diff --git a/lib/crc/arm/crc64.h b/lib/crc/arm/crc64.h
new file mode 100644
index 000000000000..de274288af61
--- /dev/null
+++ b/lib/crc/arm/crc64.h
@@ -0,0 +1,36 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * CRC64 using ARM PMULL instructions
+ */
+
+#include <asm/simd.h>
+
+static __ro_after_init DEFINE_STATIC_KEY_FALSE(have_pmull);
+
+u64 crc64_nvme_neon(u64 crc, const u8 *p, size_t len);
+
+#define crc64_be_arch crc64_be_generic
+
+static inline u64 crc64_nvme_arch(u64 crc, const u8 *p, size_t len)
+{
+	if (len >= 128 && static_branch_likely(&have_pmull) &&
+	    likely(may_use_simd())) {
+		do {
+			size_t chunk = min_t(size_t, len & ~15, SZ_4K);
+
+			scoped_ksimd()
+				crc = crc64_nvme_neon(crc, p, chunk);
+
+			p += chunk;
+			len -= chunk;
+		} while (len >= 128);
+	}
+	return crc64_nvme_generic(crc, p, len);
+}
+
+#define crc64_mod_init_arch crc64_mod_init_arch
+static void crc64_mod_init_arch(void)
+{
+	if (elf_hwcap2 & HWCAP2_PMULL)
+		static_branch_enable(&have_pmull);
+}
-- 
2.54.0.rc1.555.g9c883467ad-goog

