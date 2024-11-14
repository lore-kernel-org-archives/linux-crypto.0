Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 416A81D540;
	Thu, 14 Nov 2024 14:45:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731595512; cv=none; b=ohbulq19ZTm3SKHaWYg/Dh45UoJp5VaFj45CewGpnseontJk2d/xSIcLtnlh97Kq8iW3qVHijbp91QqqzJQHM3c6/DpCKxSs9ZwAVEJtucZHURAaftwuXlOdcFgfM2XxSBej/iLvhFgGPCGhR6hd6lYcbdSevVdjYnuo1/7LsZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731595512; c=relaxed/simple;
	bh=c+QClJAidKaBzTN7uRmphTzeL9WoMavoidhuG/L8OwY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Uv78uL0wW6MbDQ4YZt95wO/Zd82bBu3MF8mdBvAXjK4RxZ+1JdcLo1ztG0ikuE8kxjHln/RLdBzfQMvhdmw/n6/yg3zFkerQiNGo1nHfjQBRJvoHs0KSGgr+hi2lVC1JFWPAQtRBxJJGtsBKnISfBP2DzbjRfV9ARHKyXRYcaks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DpgPP2MS; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DpgPP2MS"
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-2110a622d76so6294345ad.3;
        Thu, 14 Nov 2024 06:45:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1731595510; x=1732200310; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=P4N/miMj+TGmWS0ohyBPlFx+ca8H6wpyxHTxDzJvgeM=;
        b=DpgPP2MSTrDKLuMOpybrolIZwrKeOD3Df9C9AeTxsiKRr8piCn7XScEoAZYGWgAYB1
         bZ8oBhF/NAXVqYvuSuLcQNNBPQ2BToLVWe/jou2X/lDyX9H8pGrI355BbxM8V6XJGX3s
         S9vEAIPcI9PzBhtFTVtPHTF2WQV85mwOJnMW5e63Ljflcs9v7QSPdhXVzRxeG5zGub2x
         G1tlDCaZ7MXOuQBKf1cqGk1mKjLIBEOijVLFbPDtLvqH9oH0J/12sTvxpe4lh6z3ZAP6
         LFTUhHnfeHMeh/rB496NVrORYj1TuWbhInBXKG8/qq7/eWuZXdsuTMUeaA5yxbN3KSqm
         eqgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731595510; x=1732200310;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=P4N/miMj+TGmWS0ohyBPlFx+ca8H6wpyxHTxDzJvgeM=;
        b=qj/iY+7YN2SHk0EMOXa2c842ZYaDVnKWbqBOrStVfkzf16SLOmbYfIsvr/MpspK53J
         tQCDYPYjKCx5bj7d5ceimsxv6V1hXXeTMoyKh2W9sVJkaHJUYqoLuicGte+kk2QPFeZm
         1IJsN2fP3ywa3UiF3F/J+Lhfg79Gqdai54264Vwsmerj4SyhSTMk3HqoZVE7bvOv6TGU
         8zc9+0ROi26YjFXpvQ7s9462PrCQzHJuwZrd0SHsOwFYLPi1utRIawKb/PC2/+qBaBho
         7e7DLdvFEVC5WyIBRI5XK7DZ4LB8oGJU35WcQrXG4OVplpv3T609z8wDZNsy3JREE7vN
         5VJg==
X-Forwarded-Encrypted: i=1; AJvYcCUGN8d6czyau8Uv6qD5GOp9C/db+a/9BFeeZ0AukHs0ZAqxsPXJI3xG9OuCouHBP616/jvAGQVNizmR/qQ=@vger.kernel.org, AJvYcCWLKdqfQYtZLkkYshy6FVfbREPoav3ZKDRa+mi8dvddD1ANoxYmMbUSXVmmymeminosNbkjAbqnOIVLoE6r@vger.kernel.org
X-Gm-Message-State: AOJu0YwOFqGER9uxf4MfZ8B3Wm5hHcKnHruNjuzYoxib0ebDHuQPCZi8
	GyBmnE0q3+nRQMq9tOFuRDb4Xb6/4cjbXScU4M+biLMU1WjdVpFp
X-Google-Smtp-Source: AGHT+IE0999Q/8nTfXBkwDEyF3u/q1q6CgeFE9IcqTQLQIHnJWjElF7feqrBmFwff1OpG8xeosJmrg==
X-Received: by 2002:a17:902:e945:b0:20c:a175:1943 with SMTP id d9443c01a7336-21183d67aa0mr353917955ad.40.1731595510408;
        Thu, 14 Nov 2024 06:45:10 -0800 (PST)
Received: from localhost.localdomain ([45.137.180.202])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-211c7c2d38bsm11588055ad.41.2024.11.14.06.45.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Nov 2024 06:45:10 -0800 (PST)
From: Zhihang Shao <zhihang.shao.iscas@gmail.com>
To: zhangchunyan@iscas.ac.cn,
	ebiggers@kernel.org
Cc: akpm@linux-foundation.org,
	aou@eecs.berkeley.edu,
	davem@davemloft.net,
	herbert@gondor.apana.org.au,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-riscv@lists.infradead.org,
	palmer@dabbelt.com,
	paul.walmsley@sifive.com,
	zhihang.shao.iscas@gmail.com
Subject: [PATCH v2] riscv: Optimize crct10dif with zbc extension
Date: Thu, 14 Nov 2024 14:42:04 +0000
Message-Id: <20241114144204.427915-1-zhihang.shao.iscas@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20241113134655.GA794@quark.localdomain>
References: <20241113134655.GA794@quark.localdomain>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The current CRC-T10DIF algorithm is based on table-lookup optimization.
Given the previous work on optimizing crc32 calculations with zbc
extension, it is believed that this will be equally effective for
accelerating crc-t10dif.
Therefore, this patch offers an implementation of crc-t10dif using zbc
extension. This can detect whether the current runtime environment
supports zbc feature and, if so, uses it to accelerate crc-t10dif
calculations.

This patch is tested on QEMU VM with the crypto self-tests both rv64 and
rv32.

Signed-off-by: Zhihang Shao <zhihang.shao.iscas@gmail.com>

---
v2:
- Use crypto self-tests instead. (Eric)
- Fix some format errors in arch/riscv/crypto/Kconfig. (Chunyan)
---
 arch/riscv/crypto/Kconfig               |  13 ++
 arch/riscv/crypto/Makefile              |   4 +
 arch/riscv/crypto/crct10dif-riscv-zbc.c | 182 ++++++++++++++++++++++++
 3 files changed, 199 insertions(+)
 create mode 100644 arch/riscv/crypto/crct10dif-riscv-zbc.c

diff --git a/arch/riscv/crypto/Kconfig b/arch/riscv/crypto/Kconfig
index ad58dad9a580..12107bc50bb1 100644
--- a/arch/riscv/crypto/Kconfig
+++ b/arch/riscv/crypto/Kconfig
@@ -29,6 +29,19 @@ config CRYPTO_CHACHA_RISCV64
 	  Architecture: riscv64 using:
 	  - Zvkb vector crypto extension
 
+config CRYPTO_CRCT10DIF_RISCV
+	tristate "Checksum: CRCT10DIF"
+	depends on TOOLCHAIN_HAS_ZBC
+	depends on MMU
+	depends on RISCV_ALTERNATIVE
+	default y
+	help
+	  CRCT10DIF checksum with Zbc extension optimized
+	  To accelerate CRCT10DIF checksum, choose Y here.
+
+	  Architecture: riscv using:
+	  - Zbc extension
+
 config CRYPTO_GHASH_RISCV64
 	tristate "Hash functions: GHASH"
 	depends on 64BIT && RISCV_ISA_V && TOOLCHAIN_HAS_VECTOR_CRYPTO
diff --git a/arch/riscv/crypto/Makefile b/arch/riscv/crypto/Makefile
index 247c7bc7288c..6f849f4dc4cc 100644
--- a/arch/riscv/crypto/Makefile
+++ b/arch/riscv/crypto/Makefile
@@ -7,6 +7,9 @@ aes-riscv64-y := aes-riscv64-glue.o aes-riscv64-zvkned.o \
 obj-$(CONFIG_CRYPTO_CHACHA_RISCV64) += chacha-riscv64.o
 chacha-riscv64-y := chacha-riscv64-glue.o chacha-riscv64-zvkb.o
 
+obj-$(CONFIG_CRYPTO_CRCT10DIF_RISCV) += crct10dif-riscv.o
+crct10dif-riscv-y := crct10dif-riscv-zbc.o
+
 obj-$(CONFIG_CRYPTO_GHASH_RISCV64) += ghash-riscv64.o
 ghash-riscv64-y := ghash-riscv64-glue.o ghash-riscv64-zvkg.o
 
@@ -21,3 +24,4 @@ sm3-riscv64-y := sm3-riscv64-glue.o sm3-riscv64-zvksh-zvkb.o
 
 obj-$(CONFIG_CRYPTO_SM4_RISCV64) += sm4-riscv64.o
 sm4-riscv64-y := sm4-riscv64-glue.o sm4-riscv64-zvksed-zvkb.o
+
diff --git a/arch/riscv/crypto/crct10dif-riscv-zbc.c b/arch/riscv/crypto/crct10dif-riscv-zbc.c
new file mode 100644
index 000000000000..01571b4286f1
--- /dev/null
+++ b/arch/riscv/crypto/crct10dif-riscv-zbc.c
@@ -0,0 +1,182 @@
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
+#include <crypto/internal/hash.h>
+
+#include <linux/byteorder/generic.h>
+#include <linux/crc-t10dif.h>
+#include <linux/minmax.h>
+#include <linux/module.h>
+#include <linux/types.h>
+
+static u16 crc_t10dif_generic_zbc(u16 crc, unsigned char const *p, size_t len);
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
+static inline u16 crct10dif_unaligned(u16 crc, unsigned char const *p, size_t len)
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
+static u16 crc_t10dif_generic_zbc(u16 crc, unsigned char const *p, size_t len)
+{
+	size_t offset, head_len, tail_len;
+	unsigned long const *p_ul;
+	unsigned long s;
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
+}
+
+static int crc_t10dif_init(struct shash_desc *desc)
+{
+	u16 *crc = shash_desc_ctx(desc);
+
+	*crc = 0;
+
+	return 0;
+}
+
+static int crc_t10dif_final(struct shash_desc *desc, u8 *out)
+{
+	u16 *crc = shash_desc_ctx(desc);
+
+	*(u16 *)out = *crc;
+
+	return 0;
+}
+
+static int crc_t10dif_update_zbc(struct shash_desc *desc, const u8 *data,
+				unsigned int length)
+{
+	u16 *crc = shash_desc_ctx(desc);
+
+	*crc = crc_t10dif_generic_zbc(*crc, data, length);
+
+	return 0;
+}
+
+static struct shash_alg crc_t10dif_alg = {
+	.digestsize		= CRC_T10DIF_DIGEST_SIZE,
+	.init			= crc_t10dif_init,
+	.update			= crc_t10dif_update_zbc,
+	.final			= crc_t10dif_final,
+	.descsize		= CRC_T10DIF_DIGEST_SIZE,
+
+	.base.cra_name		= "crct10dif",
+	.base.cra_driver_name	= "crct10dif-riscv-zbc",
+	.base.cra_priority	= 150,
+	.base.cra_blocksize	= CRC_T10DIF_BLOCK_SIZE,
+	.base.cra_module	= THIS_MODULE,
+};
+
+static int __init crc_t10dif_mod_init(void)
+{
+	if (riscv_isa_extension_available(NULL, ZBC))
+		return crypto_register_shash(&crc_t10dif_alg);
+
+	return -ENODEV;
+}
+
+static void __exit crc_t10dif_mod_exit(void)
+{
+	crypto_unregister_shash(&crc_t10dif_alg);
+}
+
+module_init(crc_t10dif_mod_init);
+module_exit(crc_t10dif_mod_exit);
+
+MODULE_DESCRIPTION("CRC-T10DIF using RISC-V ZBC Extension");
+MODULE_ALIAS_CRYPTO("crct10dif");
+MODULE_LICENSE("GPL");
-- 
2.34.1

