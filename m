Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFA7014EC59;
	Wed, 13 Nov 2024 10:43:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731494585; cv=none; b=CpDOhB65l8bgU/tqG7Rx9IzfjxgXAzoYk7c6frrPMDi4YsLlJ5ZLI+D8g/yl/KsdXGSyCBHx6pW265P2mLEcowrZMOmI4oznDtwYW0XpR4SGUPh7I+mAjViY10HKBgjVZsOr9Xiyrg3dk+CiKvdU0I8d8D9Pi70aSxDgy0j4KYI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731494585; c=relaxed/simple;
	bh=1OrX01GVseGRZn1KMzlAwaT1VjcQ0Ey6J2rhxa2RPnQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=A/mBCp8Rgi3iokehL9LcYWLioMfpFZ8bPeutf/qkrPYUx/auJoj6LcTfh5bRbKMpfRfxZugfDsIhWaFyuvDDoYdYxV3cDvmzybK+P6MRHsyU+zo9EQ1Q3oSx3CBRS+evyTKvvDVzNexeFuTmCI2ADKj6f1yg+Fut4fFkl1Rl8LM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TfAjwv8a; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TfAjwv8a"
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-20c767a9c50so66536935ad.1;
        Wed, 13 Nov 2024 02:43:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1731494583; x=1732099383; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5jlFYl+F/SXidKxj2SQXgSrqD6j03dI4yP5H+XqCGaQ=;
        b=TfAjwv8ajsnTkXgHIsdcezdIhgR6mGEkUck/P7Th9lAuMo45xNXegM7kuACQB0W18D
         gATuTlLL/ai2UGwYl+Jem2sNMMwYG6Y/KS03ZviTPY58jCTqFAfILFp84+zuR7nFzN7S
         OAXqXn094Id+lfaZUc2AIkiB4K0nTBw9hQcM4fh7Tu6hvncBDu2i7zP27ufbvY9zYvJy
         1Hs/K+MrAYSNyi6xNrvWwEs/oNQJa4fa4ZmQbJB6JXDX3r4zxg2CGO4L6a/V5VzBw6OS
         Y+OoKx+AL19Ttal1qg8sNQsl48v2tOny+vaDT0tgAMWWqKjiU/Z9TWnkoCGPDo4K86t5
         qGwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731494583; x=1732099383;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5jlFYl+F/SXidKxj2SQXgSrqD6j03dI4yP5H+XqCGaQ=;
        b=WU8vTgB3+jq/cdQr1cb3n/5X9e11Q9OTkMsUuAM8MtxhQVIajFOjtUzb0vBqCqeYNg
         afdRY69IdoPQrVN4AleuR2U4mk80JMznWVgTBqntoxu69+iQAHxsIz1IRf2Ppv/RwLsa
         dg+mTtt9SxgmbEn6b/x/Vp1woqbZEtq7vwFcpnBaqGaC+LlYBmf5gY/dR45tvSs50efJ
         lYhPTmLx/zkxdxTu2XSX67JxvxnZQtIIQkUnkLZjT9+K8Z2jklSHY4SCtg+idDhyfPl/
         zjv3SdTGFqOQ+jtn3iVXPAQzdpDh4NnDkrEB7+q07X6Hkzp164h8Pd8zfsxIMzEJ8Bnx
         dDCw==
X-Forwarded-Encrypted: i=1; AJvYcCUVAKWpojIdKe2VdepDFbbqTV+h1nzZetpXmmdU6tzmbtC6VtGHgGneJb8UNwOyTf0/ZtPBh4yHnIAFmUI=@vger.kernel.org, AJvYcCUk+XWQFmgi/8aBcBbVVanJjYbDUmyeNMRMh/+EJhm53RBclwq9KMD5Inv20RQhdTGdjmMjIZYwPirupGGc@vger.kernel.org
X-Gm-Message-State: AOJu0YxRvznrD909dtbUE77puwCYBY41cRFLgnTiurc36Iyc4hN+ZUMB
	k9W5ScAyVt0LNN1tuA73dBAsbwDp3LcZV5QnWynExtRJDCJVoarf
X-Google-Smtp-Source: AGHT+IFAzPvsm4MOUGF/CkevnLPD5N1Wc/o0wr9hTH0ob5+B/WVQm5z04bNdJg3/qr7zImOjGCqrMA==
X-Received: by 2002:a17:90b:3847:b0:2e2:e136:a931 with SMTP id 98e67ed59e1d1-2e9b16ea3e7mr26146379a91.6.1731494583051;
        Wed, 13 Nov 2024 02:43:03 -0800 (PST)
Received: from localhost.localdomain ([45.137.180.202])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-21177e5a9ebsm108031105ad.198.2024.11.13.02.43.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Nov 2024 02:43:02 -0800 (PST)
From: Zhihang Shao <zhihang.shao.iscas@gmail.com>
To: herbert@gondor.apana.org.au
Cc: davem@davemloft.net,
	palmer@dabbelt.com,
	paul.walmsley@sifive.com,
	aou@eecs.berkeley.edu,
	akpm@linux-foundation.org,
	linux-crypto@vger.kernel.org,
	linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] riscv: Optimize crct10dif with zbc extension
Date: Wed, 13 Nov 2024 10:40:36 +0000
Message-Id: <20241113104036.254491-3-zhihang.shao.iscas@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20241113104036.254491-1-zhihang.shao.iscas@gmail.com>
References: <20241113104036.254491-1-zhihang.shao.iscas@gmail.com>
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
Therefore, this patch offers a implementation of crc-t10dif using zbc
extension. This can detect whether the current runtime environment
supports zbc feature and, if so, uses it to accelerate crc-t10dif
calculations.

This patch is tested on QEMU VM with the kernel CRC-T10DIF selftests.

Signed-off-by: Zhihang Shao <zhihang.shao.iscas@gmail.com>
---
 arch/riscv/crypto/Kconfig               |  14 ++
 arch/riscv/crypto/Makefile              |   4 +
 arch/riscv/crypto/crct10dif-riscv-zbc.c | 182 ++++++++++++++++++++++++
 lib/crct10diftest.c                     |   4 +-
 4 files changed, 202 insertions(+), 2 deletions(-)
 create mode 100644 arch/riscv/crypto/crct10dif-riscv-zbc.c

diff --git a/arch/riscv/crypto/Kconfig b/arch/riscv/crypto/Kconfig
index ad58dad9a580..69751ff5573e 100644
--- a/arch/riscv/crypto/Kconfig
+++ b/arch/riscv/crypto/Kconfig
@@ -29,6 +29,20 @@ config CRYPTO_CHACHA_RISCV64
 	  Architecture: riscv64 using:
 	  - Zvkb vector crypto extension
 
+config CRYPTO_CRCT10DIF_RISCV
+       tristate "Checksum: CRCT10DIF"
+       depends on TOOLCHAIN_HAS_ZBC
+       depends on MMU
+       depends on RISCV_ALTERNATIVE
+       default y
+       help
+         CRCT10DIF checksum with Zbc extension optimized
+	 To accelerate CRCT10DIF checksum, choose Y here.
+
+         Architecture: riscv using:
+          - Zbc extension
+
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
diff --git a/lib/crct10diftest.c b/lib/crct10diftest.c
index 9541892eb12c..ac642191e6e8 100644
--- a/lib/crct10diftest.c
+++ b/lib/crct10diftest.c
@@ -666,9 +666,9 @@ static int __init crct10dif_test_init(void)
 
 	local_irq_restore(flags);
 
-	if (errors) 
+	if (errors)
 		pr_warn("crct10dif: %d self tests failed\n", errors);
-	else 
+	else
 		pr_info("crct10dif: self tests passed, processed %d bytes in %lld nsec\n",
 		bytes, nsec);
 
-- 
2.34.1

