Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D3A538F82;
	Wed,  5 Feb 2025 06:58:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738738718; cv=none; b=cVX4iMjUo7ShzZxY4U7q8M/N0Xtpt658eIpjS64tOQWZjtdzV10T77ZjMwrJMW3F/AifAkME/yZxJ5+XCyz2QgSdvHOkjiWEZJHnEcWLitVttat0vk5JQGTTI34Q+PXisiThEVHdokHjRLBFNd0q2/F1fWAWZvP9FQi+D+qIBSA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738738718; c=relaxed/simple;
	bh=c6txvKKgQyXCCdt1FDoh6GYOjKGvsG2esP9LYdJogSQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=mwcu4djbjNsWBzE6OeQT8pIrY1KpUZe0dz2OQw0K8Zs4wR73rfMB7ExpCB67bxU3VGZvJgD7kasImFsxwyAp78X6+vLU0BeqgK9a989x1o8dfMd4Ynvs6+du9lQ0FAdNEtQj09KO7sBZQxZmgW8jeOQX2XRccapzmrcx+zgnkds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZhKsal26; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZhKsal26"
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-2165448243fso32177685ad.1;
        Tue, 04 Feb 2025 22:58:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1738738716; x=1739343516; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=8kd7vO1mBpQG2GAzZAeXH5DIUcIHEuC0PONU4wK72z0=;
        b=ZhKsal261zDeoavhdhjF03Wb9E6bDbP2dHPELE5YlJadbTLk7JpuGdGF/eRv2O3fVK
         8MUvglE0n2YHuflfVAyARVPUwKsjYdZYyeFLzsI0BiCJyvRUMYnziT2M4LhWRBDhxTsP
         /sJ+z+jtKooz/HlYwhomztSc4/K3HdW0vfan/pKiSsB5E5DCIk01NMoLLhWlnk/gV6JY
         9TIY8NF29dtxhvBQVvJJAkylVq97yhjrqB9bWPSqANn5uESP5zdixu41m40WnuY1iWPD
         UUwvkukLUyK62yoBPFwcBl8HxxHoRkMZfukJhgrfEIhTf6ZPq08SdUdS6Kw5kUdHHRJt
         3P0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738738716; x=1739343516;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8kd7vO1mBpQG2GAzZAeXH5DIUcIHEuC0PONU4wK72z0=;
        b=Ng+6wD4sPKcvF6KaA1iDkPqoJLhi1SQHuxop9LPWrO0lZEl6EziQJbk4uJP3cbrd3I
         Te7xwWfpOSo6DDjS9c69CiIEGvzVwJ8PQfSNzM1nLeVPxe8kTVlaQfauMbM+iFjqXZ9I
         F45Pmf/iG1rGtmBGd1br7Ha3iYJZ9Fl9FD7BRs7Ohjht8wtFgWctJKqHPLGyMbqHH2Y7
         2RI4J++2juY5Wka9w44qwOaz9p+g3RKX0H6LLxmhCw40DsD7ywk6kgJpE6RwRrJA4i53
         5JJuG2wCAnfg4xE3fKVqSaMaf/99dfktefAtku3OcFMgqcUjp/Dskkd90a7xRb79wMjn
         s1CQ==
X-Forwarded-Encrypted: i=1; AJvYcCWhM5+jCS+T5bl8NJj50EX4gKzYRyqWRzUknWZ2F+b0PincQT5E9QPDnjujIek7RzWcKo03CBagiPKrGRE=@vger.kernel.org
X-Gm-Message-State: AOJu0YxhC3ryOlQUW2g0cVHMbaZGIH72hocbcQoO0gryXyaitIBmkvbx
	Xy0wQUDISS1ZiB2A8/TnE1L/ciD/u2ZjLCkHtzc0x4sIK/quitHk
X-Gm-Gg: ASbGncta750Mh5PaiHNcufjTfuFBYAVPH9zz6RuH9PdOH1464yB9uLL+m71JcBZ/f5J
	CofHkXkTm7mYqDJamA8bdr0MUcUIkQtQpOn/MJJNXNyEC3Se7zcXAoiVmBWLG7kylBG7virIC6i
	ScL2DrmIVCtxjkHBWIc7R6g8p/rYPkMLyjQSPnlJXk4XMBH8GT2Zh8Lr51If75fQrWynHnSqTlO
	97k4HdhFl4RHEhqrwT94BW4WaBF+66tMe5QbnNk3wHqjGYzWguyQPNloHCk3QTrMBmJjG4tHaSE
	ghO8sTW2kcZoRfk6cD2i/aOibYLRrGL+0qCs7k5msAfJSRE7uNoriUkpFU10nA==
X-Google-Smtp-Source: AGHT+IHfHQKhkBH6SnAi3ELRcLWQHwUP67+tCkKUBnDupDjD7giii5QzmxoANqH3MWy9/toD2fNc4Q==
X-Received: by 2002:a05:6a20:6f07:b0:1ed:9abe:c663 with SMTP id adf61e73a8af0-1ede88306c8mr2956025637.10.1738738716391;
        Tue, 04 Feb 2025 22:58:36 -0800 (PST)
Received: from stone-arch-VM.localdomain ([103.233.162.226])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-acec04794b1sm11174436a12.53.2025.02.04.22.58.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Feb 2025 22:58:35 -0800 (PST)
From: Zhihang Shao <zhihang.shao.iscas@gmail.com>
To: ebiggers@kernel.org
Cc: linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-riscv@lists.infradead.org,
	ardb@kernel.org,
	Zhihang Shao <zhihang.shao.iscas@gmail.com>
Subject: [PATCH v3] riscv: Optimize crct10dif with zbc extension
Date: Wed,  5 Feb 2025 14:58:15 +0800
Message-ID: <20250205065815.91132-1-zhihang.shao.iscas@gmail.com>
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
Also, I used crc_kunit.c to test the performance of crc-t10dif optimized
by crc extension.

Signed-off-by: Zhihang Shao <zhihang.shao.iscas@gmail.com>
---
 arch/riscv/Kconfig                |   1 +
 arch/riscv/lib/Makefile           |   1 +
 arch/riscv/lib/crc-t10dif-riscv.c | 132 ++++++++++++++++++++++++++++++
 3 files changed, 134 insertions(+)
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
index 000000000000..b1ff7309f0f5
--- /dev/null
+++ b/arch/riscv/lib/crc-t10dif-riscv.c
@@ -0,0 +1,132 @@
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
+#define STEP_ORDER 3
+
+#define CRCT10DIF_POLY_QT_BE 0xf65a57f81d33a48a
+
+static inline u64 crct10dif_prep(u16 crc, unsigned long const *ptr)
+{
+	return ((u64)crc << 48) ^ (__force u64)__cpu_to_be64(*ptr);
+}
+
+#elif __riscv_xlen == 32
+#define STEP_ORDER 2
+#define CRCT10DIF_POLY_QT_BE 0xf65a57f8
+
+static inline u32 crct10dif_prep(u16 crc, unsigned long const *ptr)
+{
+	return ((u32)crc << 16) ^ (__force u32)__cpu_to_be32(*ptr);
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
+#define STEP (1 << STEP_ORDER)
+#define OFFSET_MASK (STEP - 1)
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
+	unsigned long const *p_ul;
+	unsigned long s;
+
+	asm goto(ALTERNATIVE("j %l[legacy]", "nop", 0,
+			     RISCV_ISA_EXT_ZBC, 1)
+		 : : : : legacy);
+
+	offset = (unsigned long)p & OFFSET_MASK;
+	if (offset && len) {
+		head_len = min(STEP - offset, len);
+		crc = crct10dif_unaligned(crc, p, head_len);
+		p += head_len;
+		len -= head_len;
+	}
+
+	tail_len = len & OFFSET_MASK;
+	len = len >> STEP_ORDER;
+	p_ul = (unsigned long const *)p;
+
+	for (int i = 0; i < len; i++) {
+		s = crct10dif_prep(crc, p_ul);
+		crc = crct10dif_zbc(s);
+		p_ul++;
+	}
+
+	p = (unsigned char const *)p_ul;
+	if (tail_len)
+		crc = crct10dif_unaligned(crc, p, tail_len);
+
+	return crc;
+legacy:
+	return crc_t10dif_generic(crc, p, len);
+}
+EXPORT_SYMBOL(crc_t10dif_arch);
+
+bool crc_t10dif_is_optimized(void)
+{
+	return riscv_has_extension_likely(RISCV_ISA_EXT_ZBC);
+}
+EXPORT_SYMBOL(crc_t10dif_is_optimized);
+
+MODULE_DESCRIPTION("CRC-T10DIF using RISC-V ZBC Extension");
+MODULE_LICENSE("GPL");
-- 
2.47.0

