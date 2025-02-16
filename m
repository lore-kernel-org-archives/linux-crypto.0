Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7D711A76DE;
	Sun, 16 Feb 2025 23:00:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739746833; cv=none; b=bqCiCjjHH9cBwvWldclrMdt2Gqr/jLhIYgq9hptqXZCsFkgR9uZYD+DAb5FpTmxNUjjA2DKbfNWm6nO3fB190IRsnA21SueUgTdCaTtKr0pGnl/g2vWhWZAWq8HpVueIPbp40vURJM9bdWpxo9dy/eVcgAO8K1v/hvDH3Ii6KAA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739746833; c=relaxed/simple;
	bh=lEjXKuNQrqFQrs67kbVmsLM6h39EaeFvwXc4cVIAC3M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CCa0221OEaI9TozET8MrviQRS/NJqsJY0CZ3u56scExv+JNmwuikP2bOuPLhKfHitjt9DpLHS2kdlzngKFdFuyk/3bhsdrmQtLc5jsmrLjREz3NzYwNyrjo4N9Sv1yqppGGh2CZSBgV053Fjk1pBugqrWtMqOsE4L8E9kJ+Lohs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tmKYvSzp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tmKYvSzp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1F5EC4CEF1;
	Sun, 16 Feb 2025 23:00:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739746833;
	bh=lEjXKuNQrqFQrs67kbVmsLM6h39EaeFvwXc4cVIAC3M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tmKYvSzpXWbDg2X4OFjHLNu15ZWyE6kFgy4zF95Rw6C6TWaZxtwhqFIk1xNFvPJCv
	 cnBJxxCe6qjr2rLUqqOFmt3CEvsqiTKmrGC+oTjHXKecCYo/K5XNo/uR2XlJ9CVfyW
	 NQj0MSu1yiNDq43Vqm9vCG8VBwUsMXX6YtltduTUF3QOSwvm9N9vhwitoXe7JIn18h
	 BjZaxDeiDniSbKy8MtN9zTdNO5hcjdWIxE9ipMMxfHThoMHcIxuDPXmLr6H9NjZ3V/
	 rJp9yot0IgjLENEQ/EIoiu/FDFPEFWkVsJJVxA2himVPLUd2z60rbKnNJ7rXmXcHNK
	 ih0OuGXW2Cwsg==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: linux-crypto@vger.kernel.org,
	linux-riscv@lists.infradead.org,
	Zhihang Shao <zhihang.shao.iscas@gmail.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Xiao Wang <xiao.w.wang@intel.com>,
	Charlie Jenkins <charlie@rivosinc.com>
Subject: [PATCH 4/4] riscv/crc64: add Zbc optimized CRC64 functions
Date: Sun, 16 Feb 2025 14:55:30 -0800
Message-ID: <20250216225530.306980-5-ebiggers@kernel.org>
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

Wire up crc64_be_arch() and crc64_nvme_arch() for 64-bit RISC-V using
crc-clmul-template.h.  This greatly improves the performance of these
CRCs on Zbc-capable CPUs in 64-bit kernels.

These optimized CRC64 functions are not yet supported in 32-bit kernels,
since crc-clmul-template.h assumes that the CRC fits in an unsigned
long.  That implementation limitation could be addressed, but it would
add a fair bit of complexity, so it has been omitted for now.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 arch/riscv/Kconfig                |  1 +
 arch/riscv/lib/Makefile           |  2 ++
 arch/riscv/lib/crc-clmul-consts.h | 34 ++++++++++++++++++++++++++++++-
 arch/riscv/lib/crc-clmul.h        |  6 ++++++
 arch/riscv/lib/crc64.c            | 34 +++++++++++++++++++++++++++++++
 arch/riscv/lib/crc64_lsb.c        | 18 ++++++++++++++++
 arch/riscv/lib/crc64_msb.c        | 18 ++++++++++++++++
 7 files changed, 112 insertions(+), 1 deletion(-)
 create mode 100644 arch/riscv/lib/crc64.c
 create mode 100644 arch/riscv/lib/crc64_lsb.c
 create mode 100644 arch/riscv/lib/crc64_msb.c

diff --git a/arch/riscv/Kconfig b/arch/riscv/Kconfig
index db1cf9666dfd..e10dda2d0bfe 100644
--- a/arch/riscv/Kconfig
+++ b/arch/riscv/Kconfig
@@ -23,10 +23,11 @@ config RISCV
 	select ARCH_ENABLE_MEMORY_HOTREMOVE if MEMORY_HOTPLUG
 	select ARCH_ENABLE_SPLIT_PMD_PTLOCK if PGTABLE_LEVELS > 2
 	select ARCH_ENABLE_THP_MIGRATION if TRANSPARENT_HUGEPAGE
 	select ARCH_HAS_BINFMT_FLAT
 	select ARCH_HAS_CRC32 if RISCV_ISA_ZBC
+	select ARCH_HAS_CRC64 if 64BIT && RISCV_ISA_ZBC
 	select ARCH_HAS_CRC_T10DIF if RISCV_ISA_ZBC
 	select ARCH_HAS_CURRENT_STACK_POINTER
 	select ARCH_HAS_DEBUG_VIRTUAL if MMU
 	select ARCH_HAS_DEBUG_VM_PGTABLE
 	select ARCH_HAS_DEBUG_WX
diff --git a/arch/riscv/lib/Makefile b/arch/riscv/lib/Makefile
index 06d9552b9c8b..b1c46153606a 100644
--- a/arch/riscv/lib/Makefile
+++ b/arch/riscv/lib/Makefile
@@ -15,10 +15,12 @@ endif
 lib-$(CONFIG_MMU)	+= uaccess.o
 lib-$(CONFIG_64BIT)	+= tishift.o
 lib-$(CONFIG_RISCV_ISA_ZICBOZ)	+= clear_page.o
 obj-$(CONFIG_CRC32_ARCH)	+= crc32-riscv.o
 crc32-riscv-y := crc32.o crc32_msb.o crc32_lsb.o
+obj-$(CONFIG_CRC64_ARCH) += crc64-riscv.o
+crc64-riscv-y := crc64.o crc64_msb.o crc64_lsb.o
 obj-$(CONFIG_CRC_T10DIF_ARCH)	+= crc-t10dif-riscv.o
 crc-t10dif-riscv-y := crc-t10dif.o crc16_msb.o
 obj-$(CONFIG_FUNCTION_ERROR_INJECTION) += error-inject.o
 lib-$(CONFIG_RISCV_ISA_V)	+= xor.o
 lib-$(CONFIG_RISCV_ISA_V)	+= riscv_v_helpers.o
diff --git a/arch/riscv/lib/crc-clmul-consts.h b/arch/riscv/lib/crc-clmul-consts.h
index b3a02b9096cd..8d73449235ef 100644
--- a/arch/riscv/lib/crc-clmul-consts.h
+++ b/arch/riscv/lib/crc-clmul-consts.h
@@ -1,10 +1,10 @@
 /* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * CRC constants generated by:
  *
- *	./scripts/gen-crc-consts.py riscv_clmul crc16_msb_0x8bb7,crc32_msb_0x04c11db7,crc32_lsb_0xedb88320,crc32_lsb_0x82f63b78
+ *	./scripts/gen-crc-consts.py riscv_clmul crc16_msb_0x8bb7,crc32_msb_0x04c11db7,crc32_lsb_0xedb88320,crc32_lsb_0x82f63b78,crc64_msb_0x42f0e1eba9ea3693,crc64_lsb_0x9a6c9329ac4bc9b5
  *
  * Do not edit manually.
  */
 
 struct crc_clmul_consts {
@@ -86,5 +86,37 @@ static const struct crc_clmul_consts crc32_lsb_0x82f63b78_consts __maybe_unused
 	.fold_across_2_longs_const_lo = 0xdd45aab8, /* x^63 mod G */
 	.barrett_reduction_const_1 = 0xdea713f1, /* floor(x^63 / G) */
 	.barrett_reduction_const_2 = 0x82f63b78, /* (G - x^32) * x^0 */
 #endif
 };
+
+/*
+ * Constants generated for most-significant-bit-first CRC-64 using
+ * G(x) = x^64 + x^62 + x^57 + x^55 + x^54 + x^53 + x^52 + x^47 + x^46 + x^45 +
+ *        x^40 + x^39 + x^38 + x^37 + x^35 + x^33 + x^32 + x^31 + x^29 + x^27 +
+ *        x^24 + x^23 + x^22 + x^21 + x^19 + x^17 + x^13 + x^12 + x^10 + x^9 +
+ *        x^7 + x^4 + x^1 + x^0
+ */
+#ifdef CONFIG_64BIT
+static const struct crc_clmul_consts crc64_msb_0x42f0e1eba9ea3693_consts __maybe_unused = {
+	.fold_across_2_longs_const_hi = 0x4eb938a7d257740e, /* x^192 mod G */
+	.fold_across_2_longs_const_lo = 0x05f5c3c7eb52fab6, /* x^128 mod G */
+	.barrett_reduction_const_1 = 0xabc694e836627c39, /* floor(x^127 / G) */
+	.barrett_reduction_const_2 = 0x42f0e1eba9ea3693, /* G - x^64 */
+};
+#endif
+
+/*
+ * Constants generated for least-significant-bit-first CRC-64 using
+ * G(x) = x^64 + x^63 + x^61 + x^59 + x^58 + x^56 + x^55 + x^52 + x^49 + x^48 +
+ *        x^47 + x^46 + x^44 + x^41 + x^37 + x^36 + x^34 + x^32 + x^31 + x^28 +
+ *        x^26 + x^23 + x^22 + x^19 + x^16 + x^13 + x^12 + x^10 + x^9 + x^6 +
+ *        x^4 + x^3 + x^0
+ */
+#ifdef CONFIG_64BIT
+static const struct crc_clmul_consts crc64_lsb_0x9a6c9329ac4bc9b5_consts __maybe_unused = {
+	.fold_across_2_longs_const_hi = 0xeadc41fd2ba3d420, /* x^191 mod G */
+	.fold_across_2_longs_const_lo = 0x21e9761e252621ac, /* x^127 mod G */
+	.barrett_reduction_const_1 = 0x27ecfa329aef9f77, /* floor(x^127 / G) */
+	.barrett_reduction_const_2 = 0x9a6c9329ac4bc9b5, /* (G - x^64) * x^0 */
+};
+#endif
diff --git a/arch/riscv/lib/crc-clmul.h b/arch/riscv/lib/crc-clmul.h
index 162c1b12b219..dd1736245815 100644
--- a/arch/riscv/lib/crc-clmul.h
+++ b/arch/riscv/lib/crc-clmul.h
@@ -11,7 +11,13 @@ u16 crc16_msb_clmul(u16 crc, const void *p, size_t len,
 		    const struct crc_clmul_consts *consts);
 u32 crc32_msb_clmul(u32 crc, const void *p, size_t len,
 		    const struct crc_clmul_consts *consts);
 u32 crc32_lsb_clmul(u32 crc, const void *p, size_t len,
 		    const struct crc_clmul_consts *consts);
+#ifdef CONFIG_64BIT
+u64 crc64_msb_clmul(u64 crc, const void *p, size_t len,
+		    const struct crc_clmul_consts *consts);
+u64 crc64_lsb_clmul(u64 crc, const void *p, size_t len,
+		    const struct crc_clmul_consts *consts);
+#endif
 
 #endif /* _RISCV_CRC_CLMUL_H */
diff --git a/arch/riscv/lib/crc64.c b/arch/riscv/lib/crc64.c
new file mode 100644
index 000000000000..f0015a27836a
--- /dev/null
+++ b/arch/riscv/lib/crc64.c
@@ -0,0 +1,34 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * RISC-V optimized CRC64 functions
+ *
+ * Copyright 2025 Google LLC
+ */
+
+#include <asm/hwcap.h>
+#include <asm/alternative-macros.h>
+#include <linux/crc64.h>
+#include <linux/module.h>
+
+#include "crc-clmul.h"
+
+u64 crc64_be_arch(u64 crc, const u8 *p, size_t len)
+{
+	if (riscv_has_extension_likely(RISCV_ISA_EXT_ZBC))
+		return crc64_msb_clmul(crc, p, len,
+				       &crc64_msb_0x42f0e1eba9ea3693_consts);
+	return crc64_be_generic(crc, p, len);
+}
+EXPORT_SYMBOL(crc64_be_arch);
+
+u64 crc64_nvme_arch(u64 crc, const u8 *p, size_t len)
+{
+	if (riscv_has_extension_likely(RISCV_ISA_EXT_ZBC))
+		return crc64_lsb_clmul(crc, p, len,
+				       &crc64_lsb_0x9a6c9329ac4bc9b5_consts);
+	return crc64_nvme_generic(crc, p, len);
+}
+EXPORT_SYMBOL(crc64_nvme_arch);
+
+MODULE_DESCRIPTION("RISC-V optimized CRC64 functions");
+MODULE_LICENSE("GPL");
diff --git a/arch/riscv/lib/crc64_lsb.c b/arch/riscv/lib/crc64_lsb.c
new file mode 100644
index 000000000000..c5371bb85d90
--- /dev/null
+++ b/arch/riscv/lib/crc64_lsb.c
@@ -0,0 +1,18 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * RISC-V optimized least-significant-bit-first CRC64
+ *
+ * Copyright 2025 Google LLC
+ */
+
+#include "crc-clmul.h"
+
+typedef u64 crc_t;
+#define LSB_CRC 1
+#include "crc-clmul-template.h"
+
+u64 crc64_lsb_clmul(u64 crc, const void *p, size_t len,
+		    const struct crc_clmul_consts *consts)
+{
+	return crc_clmul(crc, p, len, consts);
+}
diff --git a/arch/riscv/lib/crc64_msb.c b/arch/riscv/lib/crc64_msb.c
new file mode 100644
index 000000000000..1925d1dbe225
--- /dev/null
+++ b/arch/riscv/lib/crc64_msb.c
@@ -0,0 +1,18 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * RISC-V optimized most-significant-bit-first CRC64
+ *
+ * Copyright 2025 Google LLC
+ */
+
+#include "crc-clmul.h"
+
+typedef u64 crc_t;
+#define LSB_CRC 0
+#include "crc-clmul-template.h"
+
+u64 crc64_msb_clmul(u64 crc, const void *p, size_t len,
+		    const struct crc_clmul_consts *consts)
+{
+	return crc_clmul(crc, p, len, consts);
+}
-- 
2.48.1

