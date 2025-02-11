Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CB5E26BDB6;
	Tue, 11 Feb 2025 07:11:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739257872; cv=none; b=I+Rv+TQjzq2XDyVL9zynaoHEPyGD6PEZTHAq2xOM4w4arXAykhe52OHvLYq1GyEZ2G/ZQJllgGJnirqPDYueEyqxVcycU/dGcCx8G7x/OweN7jywK/Z8nX4IrGAxbIsKSUEeVQa4r7AIcXFkSIPrsvI4MYnNpV52cptrmx4ai5w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739257872; c=relaxed/simple;
	bh=dpoWblb82toSXucNRm95Epw6peSpv8AO6eqefwprsKk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=OASDs1aVaqR/Y4iFZ9SS8zacEzlypLUS5bqMpLqfdYceo2rVkQBpanIbNo8vk2AwPtoGqt+HFPWvwd1V0fBQYVpGlFdjGRSyxhpvOKmQnRCpKAcGrT0199ICMnWGsXCL3XZzNgwMskQPymf7dXsn0wRptX3OnvSEJOSgWPm67mA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=X396/K/i; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="X396/K/i"
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-21f49bd087cso68876835ad.0;
        Mon, 10 Feb 2025 23:11:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1739257870; x=1739862670; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Dy+jKC2tlxNEcxoYxjCRSJtpvH8bNZPV6Hp8xEJuD6U=;
        b=X396/K/idnTE/03RpflMqUYuSp0aJAlMRtR0yU1RxgVzMM1uZy8wP91vaPvffqrWQw
         j+B300ltQqUavQMlPRgrf/ZXf+NNCAZjewfWgz8vXNLl100MSn3XsQevbDUU/Me+26mN
         BQVON72MG0+96zP8HNz19YwQZdGG4Yd7A59nSaeqXz6/AIQG5ky9uqOxZzEOgAEeJxwN
         YLKPL4g3lD9p83DaeJXFWNRKDT5bbofdF4Tk3xY/io1hJIv2cu7bZfDfX3aYWnUspk7e
         cEbotvtVIKid5Cd1qkbMG2SK0rQl5zAhUcp3oAViWYJvdF0WdA2ukC7BR6L2E9mHgqG/
         v+eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739257870; x=1739862670;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Dy+jKC2tlxNEcxoYxjCRSJtpvH8bNZPV6Hp8xEJuD6U=;
        b=Y1fCw2hzPxZAljLC26bSYpW08N84sVbu5kzgY9aDhPsbS2HI7SeEe+6VxbOCaorERr
         sklsZaQucpebwmi47d/QYA/vcOSLrD2zcYGutrVs6Vdj9Csk1QOwVIthbZRm/Qomr7fX
         xE2BShcSC+Il+2sms2u+CRDIcZ1TIdWjCcgzEkQFyQjYgTrRaxhmVToEBH4kxsjsdc5w
         ss5ONUbX3NMIYA0NdqB4wJsMiX+vlpGl9/y7LZrffmxIaSwj7IYGsSNnIsQeZ+kyGw/V
         PdJ8CeQVB/abkz1xfktQ0zFnlO9fnPWkG8wcJlUMolcOVLZcmP++92MzDIiR1/g/c/5f
         M50Q==
X-Forwarded-Encrypted: i=1; AJvYcCVIZ05hXhzoq7zx68euj5U8hwres/whEhfDxKRWODfIjWKHtGxq+WY6fQqwKf52v1lgK4/A7Z9I5frQvuM=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy/SoYJDYpADujl9tHa/UwIVSdCPuJF1IW7SOSdwG0LRXoc0kP9
	tocWzaM0TOYnANvhNKMCm3oWouUtOLbvfXG0/7TrpvlpJsDKUit9SyKU2D8O
X-Gm-Gg: ASbGncvf+jyD8bFohU0Gv2YdpbV2W0jXB4QQdoSgC3yF8O3+rIllQnEhLdj062j80l6
	UGXP4W8O7O7iP/yDrYHISx8rDYcaqB9SslPSBXduZziSuazsehDcAwWnUB1HM5TiNsOF561aiUv
	8cqyK2g1cqBQ8ph50nu4NqXkKLZtD5dG/wolk0GdnFGV7iwTdvHcYF1ArPVAD6YT7wijmjDk9FJ
	+QR4k/ur5M97bs3ktDL2prlutni8mwxu5hySaXq4Imxq675crFLjSnjJUsKFaLx4zdqDM7HIsk9
	CI0bIxR4dFpag+5mWO7pcwyC8L3j4kZBhZRVdVAPcPgYsmQtT54JIer9VvurLA==
X-Google-Smtp-Source: AGHT+IEgrVFOdypoOBVAMxwlOnLPkbYHeoHYasqV83pZ+UnCn0yDJEUQeCHcUM3a8aVsJoIDGwdHoA==
X-Received: by 2002:a17:903:22c9:b0:215:9bc2:42ec with SMTP id d9443c01a7336-21f4e763b64mr259520485ad.47.1739257870313;
        Mon, 10 Feb 2025 23:11:10 -0800 (PST)
Received: from stone-arch-VM.localdomain ([103.233.162.226])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-21f368cee57sm88429055ad.245.2025.02.10.23.11.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Feb 2025 23:11:09 -0800 (PST)
From: Zhihang Shao <zhihang.shao.iscas@gmail.com>
To: ebiggers@kernel.org
Cc: linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-riscv@lists.infradead.org,
	ardb@kernel.org,
	Zhihang Shao <zhihang.shao.iscas@gmail.com>
Subject: [PATCH v4] riscv: Optimize crct10dif with zbc extension
Date: Tue, 11 Feb 2025 15:11:01 +0800
Message-ID: <20250211071101.181652-1-zhihang.shao.iscas@gmail.com>
X-Mailer: git-send-email 2.47.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The current CRC-T10DIF algorithm on RISC-V platform is based on
table-lookup optimization.
Given the previous work on optimizing crc32 calculations with zbc
extension, it is believed that this will be equally effective for
accelerating crc-t10dif.

Therefore this patch offers an implementation of crc-t10dif using zbc
extension. This can detect whether the current runtime environment
supports zbc feature and, if so, uses it to accelerate crc-t10dif
calculations.

This patch is updated due to the patchset of updating kernel's
CRC-T10DIF library in 6.14, which is finished by Eric Biggers.
Also, I used crc_kunit.c to test the performance of crc-t10dif 
optimized by crc extension.

Signed-off-by: Zhihang Shao <zhihang.shao.iscas@gmail.com>

---
v4:
- Use proper data types and remove #defines according
to Eric's comments. (Eric)
---
v3:
- Rebase for Eric's crc tree. (Eric)
---
v2:
- Use crypto self-tests instead. (Eric)
- Fix some format errors in arch/riscv/crypto/Kconfig. (Chunyan)
---
 arch/riscv/Kconfig                |   1 +
 arch/riscv/lib/Makefile           |   1 +
 arch/riscv/lib/crc-t10dif-riscv.c | 120 ++++++++++++++++++++++++++++++
 3 files changed, 122 insertions(+)
 create mode 100644 arch/riscv/lib/crc-t10dif-riscv.c

diff --git a/arch/riscv/Kconfig b/arch/riscv/Kconfig
index 7612c52e9b1e..db1cf9666dfd 100644
--- a/arch/riscv/Kconfig
+++ b/arch/riscv/Kconfig
@@ -25,6 +25,7 @@ config RISCV
 	select ARCH_ENABLE_THP_MIGRATION if TRANSPARENT_HUGEPAGE
 	select ARCH_HAS_BINFMT_FLAT
 	select ARCH_HAS_CRC32 if RISCV_ISA_ZBC
+	select ARCH_HAS_CRC_T10DIF if RISCV_ISA_ZBC
 	select ARCH_HAS_CURRENT_STACK_POINTER
 	select ARCH_HAS_DEBUG_VIRTUAL if MMU
 	select ARCH_HAS_DEBUG_VM_PGTABLE
diff --git a/arch/riscv/lib/Makefile b/arch/riscv/lib/Makefile
index 79368a895fee..689895b271bd 100644
--- a/arch/riscv/lib/Makefile
+++ b/arch/riscv/lib/Makefile
@@ -16,6 +16,7 @@ lib-$(CONFIG_MMU)	+= uaccess.o
 lib-$(CONFIG_64BIT)	+= tishift.o
 lib-$(CONFIG_RISCV_ISA_ZICBOZ)	+= clear_page.o
 obj-$(CONFIG_CRC32_ARCH)	+= crc32-riscv.o
+obj-$(CONFIG_CRC_T10DIF_ARCH) += crc-t10dif-riscv.o
 obj-$(CONFIG_FUNCTION_ERROR_INJECTION) += error-inject.o
 lib-$(CONFIG_RISCV_ISA_V)	+= xor.o
 lib-$(CONFIG_RISCV_ISA_V)	+= riscv_v_helpers.o
diff --git a/arch/riscv/lib/crc-t10dif-riscv.c b/arch/riscv/lib/crc-t10dif-riscv.c
new file mode 100644
index 000000000000..da90e2900ca7
--- /dev/null
+++ b/arch/riscv/lib/crc-t10dif-riscv.c
@@ -0,0 +1,120 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Accelerated CRC-T10DIF implementation with RISC-V Zbc extension.
+ *
+ * Copyright (C) 2024 Institute of Software, CAS.
+ */
+
+#include <asm/alternative-macros.h>
+#include <asm/byteorder.h>
+#include <asm/hwcap.h>
+
+#include <linux/byteorder/generic.h>
+#include <linux/crc-t10dif.h>
+#include <linux/minmax.h>
+#include <linux/module.h>
+#include <linux/types.h>
+
+#define CRCT10DIF_POLY 0x8bb7
+
+#if __riscv_xlen == 64
+#define CRCT10DIF_POLY_QT_BE 0xf65a57f81d33a48a
+
+static inline u64 crct10dif_prep(u16 crc, const __be64 *ptr)
+{
+	return ((u64)crc << 48) ^ __be64_to_cpu(*ptr);
+}
+
+#elif __riscv_xlen == 32
+#define CRCT10DIF_POLY_QT_BE 0xf65a57f8
+
+static inline u32 crct10dif_prep(u16 crc, const __be32 *ptr)
+{
+	return ((u32)crc << 16) ^ __be32_to_cpu(*ptr);
+}
+
+#else
+#error "Unexpected __riscv_xlen"
+#endif
+
+static inline u16 crct10dif_zbc(unsigned long s)
+{
+	u16 crc;
+
+	asm volatile   (".option push\n"
+			".option arch,+zbc\n"
+			"clmulh %0, %1, %2\n"
+			"xor    %0, %0, %1\n"
+			"clmul  %0, %0, %3\n"
+			".option pop\n"
+			: "=&r" (crc)
+			: "r"(s),
+			  "r"(CRCT10DIF_POLY_QT_BE),
+			  "r"(CRCT10DIF_POLY)
+			:);
+
+	return crc;
+}
+
+static inline u16 crct10dif_unaligned(u16 crc, const u8 *p, size_t len)
+{
+	size_t bits = len * 8;
+	unsigned long s = 0;
+	u16 crc_low = 0;
+
+	for (int i = 0; i < len; i++)
+		s = *p++ | (s << 8);
+
+	if (len < sizeof(u16)) {
+		s ^= crc >> (16 - bits);
+		crc_low = crc << bits;
+	} else {
+		s ^= (unsigned long)crc << (bits - 16);
+	}
+
+	crc = crct10dif_zbc(s);
+	crc ^= crc_low;
+
+	return crc;
+}
+
+u16 crc_t10dif_arch(u16 crc, const u8 *p, size_t len)
+{
+	size_t offset, head_len, tail_len;
+	const __be64 *p_ul;
+	unsigned long s;
+
+	asm goto(ALTERNATIVE("j %l[legacy]", "nop", 0,
+			     RISCV_ISA_EXT_ZBC, 1)
+		 : : : : legacy);
+
+	offset = (unsigned long)p & (sizeof(unsigned long) - 1);
+	if (offset && len) {
+		head_len = min(sizeof(unsigned long) - offset, len);
+		crc = crct10dif_unaligned(crc, p, head_len);
+		p += head_len;
+		len -= head_len;
+	}
+
+	tail_len = len & (sizeof(unsigned long) - 1);
+	len = len >> ilog2(sizeof(unsigned long));
+	p_ul = (const __be64 *)p;
+
+	for (int i = 0; i < len; i++) {
+		s = crct10dif_prep(crc, p_ul);
+		crc = crct10dif_zbc(s);
+		p_ul++;
+	}
+
+	p = (const u8 *)p_ul;
+	if (tail_len)
+		crc = crct10dif_unaligned(crc, p, tail_len);
+
+	return crc;
+legacy:
+	return crc_t10dif_generic(crc, p, len);
+}
+EXPORT_SYMBOL(crc_t10dif_arch);
+
+MODULE_DESCRIPTION("CRC-T10DIF using RISC-V ZBC Extension");
+MODULE_LICENSE("GPL");
-- 
2.47.0

