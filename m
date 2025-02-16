Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A1251A5BB3;
	Sun, 16 Feb 2025 23:00:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739746833; cv=none; b=uOUshjFn6NmqfqHl9COLy/QtYC9vQHIW3eKEGSXLXST04pINpwl8n0q3o8ngUqsAMl15L7qfS9MTgJC6bLYElhId8lVk6qYIG/5EhckSqVr9ELUZP9/juadKjMRSANHs1GvZuYGw+ecs6j7RPOrlPkpcaIW3VeOpoNO+TIjeITk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739746833; c=relaxed/simple;
	bh=qkiWzedE1M/317VJo+WP89ap6BCHBj0FmuJve7sxChA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tKzjaxCMwcoDKkwc6qIZdLcbu0V8WjHERct+00qyqHDlsLXU9YdsWZZb/nhgjXyuSDf46xRDBCXzmbpdo1USZBPsIaKnKQuFXUGv1Cv2vuLxaT5+il94klLgF5NCQYl+3lcl0tW8JQwjkXhS5Ozq2F5wB7sCuC3WenA8LEn5ZZs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pfWNwLRF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pfWNwLRF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 863A9C4CEEC;
	Sun, 16 Feb 2025 23:00:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739746832;
	bh=qkiWzedE1M/317VJo+WP89ap6BCHBj0FmuJve7sxChA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pfWNwLRF7Bm77ieywUngO9aZbBSN/ZBAE7Y6TJcW8VrHHe6b07T/ZgrziLZfdA8Bo
	 KS67qYm2LaPe1lgEghWRDcTS12V/wwwvHgiycLHDCYnvdJrs9OdP8dHSg3V4RgLJIP
	 ov5/FXeltVlN3KBP1++nZ0AWthFBtjGxVb7nXJnaq6izLCq/GY5NTFYKy/Fvl/gW/W
	 kOhWsY9J0ZE2p/gT79KVo9dLyF+66knl0YgAm3HzcBtnWwl8VxGJBz97RX5CEB6NTK
	 M5XwltMtfEHeuttmEDD2afZgDe66Z0k4qN2SM6KytQYcC4gXLb10G3of7OF8pkLKDr
	 f0hn6Xr8WQx0A==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: linux-crypto@vger.kernel.org,
	linux-riscv@lists.infradead.org,
	Zhihang Shao <zhihang.shao.iscas@gmail.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Xiao Wang <xiao.w.wang@intel.com>,
	Charlie Jenkins <charlie@rivosinc.com>
Subject: [PATCH 3/4] riscv/crc-t10dif: add Zbc optimized CRC-T10DIF function
Date: Sun, 16 Feb 2025 14:55:29 -0800
Message-ID: <20250216225530.306980-4-ebiggers@kernel.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250216225530.306980-1-ebiggers@kernel.org>
References: <20250216225530.306980-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Eric Biggers <ebiggers@google.com>

Wire up crc_t10dif_arch() for RISC-V using crc-clmul-template.h.  This
greatly improves CRC-T10DIF performance on Zbc-capable CPUs.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 arch/riscv/Kconfig                |  1 +
 arch/riscv/lib/Makefile           |  2 ++
 arch/riscv/lib/crc-clmul-consts.h | 20 +++++++++++++++++++-
 arch/riscv/lib/crc-clmul.h        |  2 ++
 arch/riscv/lib/crc-t10dif.c       | 24 ++++++++++++++++++++++++
 arch/riscv/lib/crc16_msb.c        | 18 ++++++++++++++++++
 6 files changed, 66 insertions(+), 1 deletion(-)
 create mode 100644 arch/riscv/lib/crc-t10dif.c
 create mode 100644 arch/riscv/lib/crc16_msb.c

diff --git a/arch/riscv/Kconfig b/arch/riscv/Kconfig
index 7612c52e9b1e..db1cf9666dfd 100644
--- a/arch/riscv/Kconfig
+++ b/arch/riscv/Kconfig
@@ -23,10 +23,11 @@ config RISCV
 	select ARCH_ENABLE_MEMORY_HOTREMOVE if MEMORY_HOTPLUG
 	select ARCH_ENABLE_SPLIT_PMD_PTLOCK if PGTABLE_LEVELS > 2
 	select ARCH_ENABLE_THP_MIGRATION if TRANSPARENT_HUGEPAGE
 	select ARCH_HAS_BINFMT_FLAT
 	select ARCH_HAS_CRC32 if RISCV_ISA_ZBC
+	select ARCH_HAS_CRC_T10DIF if RISCV_ISA_ZBC
 	select ARCH_HAS_CURRENT_STACK_POINTER
 	select ARCH_HAS_DEBUG_VIRTUAL if MMU
 	select ARCH_HAS_DEBUG_VM_PGTABLE
 	select ARCH_HAS_DEBUG_WX
 	select ARCH_HAS_FAST_MULTIPLIER
diff --git a/arch/riscv/lib/Makefile b/arch/riscv/lib/Makefile
index 7b32d3e88337..06d9552b9c8b 100644
--- a/arch/riscv/lib/Makefile
+++ b/arch/riscv/lib/Makefile
@@ -15,8 +15,10 @@ endif
 lib-$(CONFIG_MMU)	+= uaccess.o
 lib-$(CONFIG_64BIT)	+= tishift.o
 lib-$(CONFIG_RISCV_ISA_ZICBOZ)	+= clear_page.o
 obj-$(CONFIG_CRC32_ARCH)	+= crc32-riscv.o
 crc32-riscv-y := crc32.o crc32_msb.o crc32_lsb.o
+obj-$(CONFIG_CRC_T10DIF_ARCH)	+= crc-t10dif-riscv.o
+crc-t10dif-riscv-y := crc-t10dif.o crc16_msb.o
 obj-$(CONFIG_FUNCTION_ERROR_INJECTION) += error-inject.o
 lib-$(CONFIG_RISCV_ISA_V)	+= xor.o
 lib-$(CONFIG_RISCV_ISA_V)	+= riscv_v_helpers.o
diff --git a/arch/riscv/lib/crc-clmul-consts.h b/arch/riscv/lib/crc-clmul-consts.h
index 6fdf10648a20..b3a02b9096cd 100644
--- a/arch/riscv/lib/crc-clmul-consts.h
+++ b/arch/riscv/lib/crc-clmul-consts.h
@@ -1,10 +1,10 @@
 /* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * CRC constants generated by:
  *
- *	./scripts/gen-crc-consts.py riscv_clmul crc32_msb_0x04c11db7,crc32_lsb_0xedb88320,crc32_lsb_0x82f63b78
+ *	./scripts/gen-crc-consts.py riscv_clmul crc16_msb_0x8bb7,crc32_msb_0x04c11db7,crc32_lsb_0xedb88320,crc32_lsb_0x82f63b78
  *
  * Do not edit manually.
  */
 
 struct crc_clmul_consts {
@@ -12,10 +12,28 @@ struct crc_clmul_consts {
 	unsigned long fold_across_2_longs_const_lo;
 	unsigned long barrett_reduction_const_1;
 	unsigned long barrett_reduction_const_2;
 };
 
+/*
+ * Constants generated for most-significant-bit-first CRC-16 using
+ * G(x) = x^16 + x^15 + x^11 + x^9 + x^8 + x^7 + x^5 + x^4 + x^2 + x^1 + x^0
+ */
+static const struct crc_clmul_consts crc16_msb_0x8bb7_consts __maybe_unused = {
+#ifdef CONFIG_64BIT
+	.fold_across_2_longs_const_hi = 0x0000000000001faa, /* x^192 mod G */
+	.fold_across_2_longs_const_lo = 0x000000000000a010, /* x^128 mod G */
+	.barrett_reduction_const_1 = 0xfb2d2bfc0e99d245, /* floor(x^79 / G) */
+	.barrett_reduction_const_2 = 0x0000000000008bb7, /* G - x^16 */
+#else
+	.fold_across_2_longs_const_hi = 0x00005890, /* x^96 mod G */
+	.fold_across_2_longs_const_lo = 0x0000f249, /* x^64 mod G */
+	.barrett_reduction_const_1 = 0xfb2d2bfc, /* floor(x^47 / G) */
+	.barrett_reduction_const_2 = 0x00008bb7, /* G - x^16 */
+#endif
+};
+
 /*
  * Constants generated for most-significant-bit-first CRC-32 using
  * G(x) = x^32 + x^26 + x^23 + x^22 + x^16 + x^12 + x^11 + x^10 + x^8 + x^7 +
  *        x^5 + x^4 + x^2 + x^1 + x^0
  */
diff --git a/arch/riscv/lib/crc-clmul.h b/arch/riscv/lib/crc-clmul.h
index 62bd41080785..162c1b12b219 100644
--- a/arch/riscv/lib/crc-clmul.h
+++ b/arch/riscv/lib/crc-clmul.h
@@ -5,10 +5,12 @@
 #define _RISCV_CRC_CLMUL_H
 
 #include <linux/types.h>
 #include "crc-clmul-consts.h"
 
+u16 crc16_msb_clmul(u16 crc, const void *p, size_t len,
+		    const struct crc_clmul_consts *consts);
 u32 crc32_msb_clmul(u32 crc, const void *p, size_t len,
 		    const struct crc_clmul_consts *consts);
 u32 crc32_lsb_clmul(u32 crc, const void *p, size_t len,
 		    const struct crc_clmul_consts *consts);
 
diff --git a/arch/riscv/lib/crc-t10dif.c b/arch/riscv/lib/crc-t10dif.c
new file mode 100644
index 000000000000..e6b0051ccd86
--- /dev/null
+++ b/arch/riscv/lib/crc-t10dif.c
@@ -0,0 +1,24 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * RISC-V optimized CRC-T10DIF function
+ *
+ * Copyright 2025 Google LLC
+ */
+
+#include <asm/hwcap.h>
+#include <asm/alternative-macros.h>
+#include <linux/crc-t10dif.h>
+#include <linux/module.h>
+
+#include "crc-clmul.h"
+
+u16 crc_t10dif_arch(u16 crc, const u8 *p, size_t len)
+{
+	if (riscv_has_extension_likely(RISCV_ISA_EXT_ZBC))
+		return crc16_msb_clmul(crc, p, len, &crc16_msb_0x8bb7_consts);
+	return crc_t10dif_generic(crc, p, len);
+}
+EXPORT_SYMBOL(crc_t10dif_arch);
+
+MODULE_DESCRIPTION("RISC-V optimized CRC-T10DIF function");
+MODULE_LICENSE("GPL");
diff --git a/arch/riscv/lib/crc16_msb.c b/arch/riscv/lib/crc16_msb.c
new file mode 100644
index 000000000000..554d295e95f5
--- /dev/null
+++ b/arch/riscv/lib/crc16_msb.c
@@ -0,0 +1,18 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * RISC-V optimized most-significant-bit-first CRC16
+ *
+ * Copyright 2025 Google LLC
+ */
+
+#include "crc-clmul.h"
+
+typedef u16 crc_t;
+#define LSB_CRC 0
+#include "crc-clmul-template.h"
+
+u16 crc16_msb_clmul(u16 crc, const void *p, size_t len,
+		    const struct crc_clmul_consts *consts)
+{
+	return crc_clmul(crc, p, len, consts);
+}
-- 
2.48.1

