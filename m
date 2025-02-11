Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 419621EE01F;
	Tue, 11 Feb 2025 08:08:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739261292; cv=none; b=qTKVDW0O0Ts9Dt+idDnWz7FUYRmmqKyIKE8006/LnrHdXQcpwlSvJM1NSmy1uBd8idLpjx3fFy71FbOXR6sLyC4J979fMhjp4Ah3O+BXrj1bO9b+2IQaJHhdwPReX+UrxhUx6pqyNKklxLWju//6bvj2JwWCOdEvJPQqxnm0oVU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739261292; c=relaxed/simple;
	bh=P2QcCz2MyiShDR3PPQl5bATRivNL71mOkc+PGXa+8OI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=aCmXNEVBOfVxjn18W4c5tHS12W8hNH6rKvJZyMkV115OxUd1RNEkNz/2pZg39Hh8CeHX5HxNlCgK6FxJTxf75P4hfQBjeFT6UJkJFyZcyUFegeYkO9cjvSC7ujMDDiVPXsi0m2MC+rYRTWctp2Wc3b6fKMU0gcl+F/5lcb0qe90=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UAMZjGX6; arc=none smtp.client-ip=209.85.216.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UAMZjGX6"
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-2fa1a3c88c5so6730658a91.3;
        Tue, 11 Feb 2025 00:08:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1739261290; x=1739866090; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=KA4jpQ5V3ysCO6YGflqBLf2hPOtMTXa2birIlOr0EAw=;
        b=UAMZjGX6PIMWzS3aj/1+dekOpBSOHM6XC9QV8jdQt82XnPZHWpKEkfx2vQP1C9urWu
         a8hSccGK3TTqbBEmJliPaH8w+uLsRbACra0vJ9qIWqdWsB7h7Xf6K2zJJzOjbkicWWW4
         2xVUMkfdEVrNBW8H8RM9GOHns+eboJ03WEnpEi0Ph4VIkwwzvVRLDS+GsTNpIQfQPwlx
         3hKY8PcRsAcHa1PqK+KyBXOmcevSEQljlgCAX0ZtL4atIpMwrDRbME2AB9/AGIC6xNPC
         NIVsvZt3HQVtHqbu73aCMePxr847rAqQxueoiaRI2s7UOWZAnzqfeHGz+Cjw1GXcpUyQ
         f9aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739261290; x=1739866090;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=KA4jpQ5V3ysCO6YGflqBLf2hPOtMTXa2birIlOr0EAw=;
        b=K1gN1RRYZnMfbHEQfkn2bzvUT+9AaGcIspnF4+ONEEX4k5NEHrDGPJKRQx1SjMJ1s+
         g3G2zW/f/OE6yLXvzYaCvu8id4TBG8hGDgBUPZGbaLpjR3ZULENusgubbIIIJmPIuVsU
         UhFKYg9bk/4XZaWMPBVgL8JNfZ5mhCj+zh8DcTS8ASLMaobTRASuhvqfdDcGfoTLrymW
         omuEFyzQglKYrBfxcYONj78eEcFqRSI1/FGxqMEWAN9wkeFdWgUakNJwNvS2IxMoN5Ah
         f8tNmsGQPzjB8kvw1qD2o121WO0B2JsUreHz1dbBpNknJgdBU2Xdd3vzKyHMtmxl+Txm
         riCw==
X-Forwarded-Encrypted: i=1; AJvYcCX6v0jVPtTvUigRjh2n+9fqtuCqoR8CzHjPgJsCC/A5JYvbGF15edOb3U0v87bpdHTHGK84tss4xeA6C4E=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw6p/PF3v5QeRIl2liMtjyd1URobdz2drsd40zdVk2171fvxJic
	ncxm/EEm+m3LpM1fZgOGfxED3nKprxeGuPEkD0Whefnp5VA56BuL
X-Gm-Gg: ASbGncspQTyqHYtyrwEEKr3N1mJwT9QbfIdIHFxgtkk+68iQC7WxT9qVVRZHZeuGlLW
	bajpogCDxVmm2O0kEi1C5QDf+xaDa2xNKwuOUePydebkLx+17WmANwSSVLfAJPamn6+KEQ+qtgP
	uOsdsa4BRpC8WfYjFjR36va6Kw7VO/5rckQbg7euhRsAtoB6ijaZmWvQDHCv0VmsHQQ4bwUt+z8
	Anebn1XxGOvNMniqHwgzqcT1uFo9dvcD2RUVlkcMTNr9MCXkOfsW43eKNU3QTzoybUlYkd6HbmS
	VWnpmAue66rqWZI4KvzoX647RCqHqNhAtmdTYZP3Frs8Hs7YEaPJ6FahkU2etw==
X-Google-Smtp-Source: AGHT+IE5uSVRXFS1dB2KUSrGTxStqiYVu8rwl/uUt4ZvP6YcriprR65a1RWTFCq4qlSgVSruBDbWag==
X-Received: by 2002:a17:90b:2703:b0:2f7:7680:51a6 with SMTP id 98e67ed59e1d1-2fa9ed5d432mr3284958a91.6.1739261290205;
        Tue, 11 Feb 2025 00:08:10 -0800 (PST)
Received: from stone-arch-VM.localdomain ([103.233.162.226])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2fa274407f5sm8122188a91.15.2025.02.11.00.08.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Feb 2025 00:08:09 -0800 (PST)
From: Zhihang Shao <zhihang.shao.iscas@gmail.com>
To: ebiggers@kernel.org
Cc: linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-riscv@lists.infradead.org,
	ardb@kernel.org,
	Zhihang Shao <zhihang.shao.iscas@gmail.com>,
	Chunyan Zhang <zhangchunyan@iscas.ac.cn>
Subject: [PATCH v4 RESEND] riscv: Optimize crct10dif with zbc extension
Date: Tue, 11 Feb 2025 16:07:29 +0800
Message-ID: <20250211080729.205872-1-zhihang.shao.iscas@gmail.com>
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

Acked-by: Eric Biggers <ebiggers@kernel.org>
Tested-by: Eric Biggers <ebiggers@kernel.org>
Reviewed-by: Chunyan Zhang <zhangchunyan@iscas.ac.cn>
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

