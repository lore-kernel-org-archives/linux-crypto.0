Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99A2F1CAA92;
	Thu, 17 Apr 2025 06:49:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744872588; cv=none; b=K3OvcPE09mZNtgfIQ6hJceFMqFONS9eDiFQ+nZaXvJeoAbzdrjMpCQ85B9dXzT3B/baqBQspwJPruFNGnEJz6f9sR1JWvKad6knW/GcNTlpPCoJlbbVjIaRk5/D3Dbm+7xIDXD06JTGfOCXkUMgMHI2JUYLcXv4XhJlZDbOuGf0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744872588; c=relaxed/simple;
	bh=KAmtj40+mb5153rX4LnofGPDdYa1AOTgOJ9c8iLLZZg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=SdsW7621oBBl2pYHceRfuAl9QPhNDb5iXWbVlsT2xxyN5B1fDt1tT6u+Kw0Yocz8Fiv0bZ0JScQjGZZ9HL28utISZOHMxO4/RduJnGUvcdGH60C/MvzqhdV71wKKU78VBq653coQmZzmUq/IwykwmWHetcx+DmyURC309ojkc6s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ML+jS5jL; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ML+jS5jL"
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-225df540edcso17021625ad.0;
        Wed, 16 Apr 2025 23:49:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1744872586; x=1745477386; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=9YMfDtiPIBm1mjpyWsSE2L94WCWtJEZ4yISF+jitXmY=;
        b=ML+jS5jLCQkPaSGt5iNbyBZqQFI4ssRJJNAmtw8SLseQ4YVdsakvlyqzdVPkjVAM5t
         enI7avhN797F13LoarawIzRdNjppOAUCMt/RXlsIvzcXW6YELxYh16bWqJ1NwP4523NK
         DfWg3u86EaKsDOzKk4HGvCizxV9eibkxiUWZOEfU/mT1Vf40Sx6DwplIURZWOKuTgBcB
         DMJpGfz8FyeZQE0Jw19cwCVjeJZkfy87obxSo4PQw7moTY04qaCpQ2+n3wAeus5Qj3CK
         W7K0eUjdlErufzLFricnU/fP/nLUJcFz5OIi9eLd5mdc4J6yZcMp8vMO4F2+UuHh6h/M
         +nZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744872586; x=1745477386;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9YMfDtiPIBm1mjpyWsSE2L94WCWtJEZ4yISF+jitXmY=;
        b=vk9vUu24B11GM6yYvjoor+x+4BF6BasjQUfrXGKLC0mEXkAAwZUo4DvFP5idhw6L+w
         bC+nEmDTnG2/gzp1hYw8WNYQe8n7JZqQtJOQnSq8egE6OnpagwQOR50oEN17YPUmu5LI
         Z3DPV7EmOpr8j5ecIbHdaKU1Nfc09QxtICbd9Qpb5AW1Zcnca7iFhi/83U2K6ySp9M+Z
         ybpr0rAA7Ha/a2Jjci76b2B8TtU3fyX7k+mPm92Blr3MocfzKZbc2AYh3Q09xONKxmha
         t12TWjXMz96Yk6KV5DxR2z4gIya3ozFABmjkWMH8CJx8StkZqrAuAkyTOI+lPR4S+37T
         u4/A==
X-Forwarded-Encrypted: i=1; AJvYcCV4ckiZOGn6UpNg6aJWmC9TK3xK1XPINaV+QIZpELKjm2hMbnHVl/bQKjbQhAoE7nigIy+Q3skl0I92nXP5@vger.kernel.org, AJvYcCVTCWlTIKk/Zz1v4jGX0LRhiGT7J4PQYkgpJeFIHRIgzL1QLDNUZZCPP4HZA9eqq1pjcIy0ygh+YbIlcpk=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzofi9GNMMTRI3ZZGAYIaWJgs5dDvAqGoFHEoNoSW22rPAlpbiO
	3jmKJXAXrsvxhs1LEIHT4bg82mWxeAwI4MCHn6elSr8LKxJHoXkL
X-Gm-Gg: ASbGncvAxefo9iENSDlSB5MlnmWNV0xt1987+/4m0SfSgYzhGg12ERlpvwnLdFWwAhB
	UedX+YeZCjQyW7j435d/+D2Ngvtq+Dj2AvvNqshVLKs8arKypPOU4kBr0HZCzWBQo+VJNUMF4Do
	mIptPTn5XFYQWWubyHb3XnSaSVQEIAVb3tqbeob/nfJ9lKiqwFL5hfNPp0/fYEuB6WDunRxgyU5
	iP+3ca0pZUKVUCBRyPT2TUI+bwumaULpBw6O+nRaGm2E0Dn8h2/z43ee+zD2jw/nS3g4D5XmPrs
	QLMUAkIRxvD89YOQ7xqERRjSUVq+yRtaTYa9/Ux6oSAA
X-Google-Smtp-Source: AGHT+IH06tnUkG6buwymrXxr/yQbpbdQ3t87juqs5171jY1Q6arc8q1JJROlVIT02INqgtBqb707oA==
X-Received: by 2002:a17:902:e5c3:b0:215:44fe:163d with SMTP id d9443c01a7336-22c41d6836dmr24028295ad.17.1744872585488;
        Wed, 16 Apr 2025 23:49:45 -0700 (PDT)
Received: from gmail.com ([116.237.135.88])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22c33ef0f41sm25978565ad.41.2025.04.16.23.49.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Apr 2025 23:49:44 -0700 (PDT)
From: Qingfang Deng <dqfext@gmail.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Alexandre Ghiti <alex@ghiti.fr>,
	linux-crypto@vger.kernel.org,
	linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org
Cc: =?UTF-8?q?Christoph=20M=C3=BCllner?= <christoph.muellner@vrull.eu>,
	Heiko Stuebner <heiko.stuebner@vrull.eu>,
	Qingfang Deng <qingfang.deng@siflower.com.cn>
Subject: [RFC PATCH] crypto: riscv: scalar accelerated GHASH
Date: Thu, 17 Apr 2025 14:49:38 +0800
Message-ID: <20250417064940.68469-1-dqfext@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Qingfang Deng <qingfang.deng@siflower.com.cn>

Add a scalar implementation of GHASH for RISC-V using the Zbc (carry-less
multiplication) and Zbb (bit-manipulation) extensions. This implementation
is adapted from OpenSSL but rewritten in plain C for clarity.

Unlike the OpenSSL one that rely on bit-reflection of the data, this
version uses a pre-computed (reflected and multiplied) key, inspired by
the approach used in Intel's CLMUL driver, to avoid reflections during
runtime.

Signed-off-by: Qingfang Deng <qingfang.deng@siflower.com.cn>
---
 arch/riscv/crypto/Kconfig               |  16 +-
 arch/riscv/crypto/Makefile              |   2 +
 arch/riscv/crypto/ghash-riscv64-clmul.c | 270 ++++++++++++++++++++++++
 3 files changed, 287 insertions(+), 1 deletion(-)
 create mode 100644 arch/riscv/crypto/ghash-riscv64-clmul.c

diff --git a/arch/riscv/crypto/Kconfig b/arch/riscv/crypto/Kconfig
index 6392e1e11bc9..03b74d4116cb 100644
--- a/arch/riscv/crypto/Kconfig
+++ b/arch/riscv/crypto/Kconfig
@@ -26,7 +26,7 @@ config CRYPTO_CHACHA_RISCV64
 	default CRYPTO_LIB_CHACHA_INTERNAL
 
 config CRYPTO_GHASH_RISCV64
-	tristate "Hash functions: GHASH"
+	tristate "Hash functions: GHASH (vector accelarated)"
 	depends on 64BIT && RISCV_ISA_V && TOOLCHAIN_HAS_VECTOR_CRYPTO
 	select CRYPTO_GCM
 	help
@@ -35,6 +35,20 @@ config CRYPTO_GHASH_RISCV64
 	  Architecture: riscv64 using:
 	  - Zvkg vector crypto extension
 
+config CRYPTO_GHASH_RISCV64_CLMUL
+	tristate "Hash functions: GHASH (CLMUL scalar accelerated)"
+	depends on 64BIT && TOOLCHAIN_HAS_ZBB && TOOLCHAIN_HAS_ZBC
+	select CRYPTO_GCM
+	help
+	  GCM GHASH function (NIST SP 800-38D)
+
+	  Architecture: riscv64 using:
+	  - Zbb Bitmanipulation extension
+	  - Zbc Carry-less multiplication
+	    OR
+	  - Zbkb Bit-manipulation for Cryptography
+	  - Zbkc Carry-less multiplication for Cryptography
+
 config CRYPTO_SHA256_RISCV64
 	tristate "Hash functions: SHA-224 and SHA-256"
 	depends on 64BIT && RISCV_ISA_V && TOOLCHAIN_HAS_VECTOR_CRYPTO
diff --git a/arch/riscv/crypto/Makefile b/arch/riscv/crypto/Makefile
index 247c7bc7288c..b5dc497d398c 100644
--- a/arch/riscv/crypto/Makefile
+++ b/arch/riscv/crypto/Makefile
@@ -10,6 +10,8 @@ chacha-riscv64-y := chacha-riscv64-glue.o chacha-riscv64-zvkb.o
 obj-$(CONFIG_CRYPTO_GHASH_RISCV64) += ghash-riscv64.o
 ghash-riscv64-y := ghash-riscv64-glue.o ghash-riscv64-zvkg.o
 
+obj-$(CONFIG_CRYPTO_GHASH_RISCV64_CLMUL) += ghash-riscv64-clmul.o
+
 obj-$(CONFIG_CRYPTO_SHA256_RISCV64) += sha256-riscv64.o
 sha256-riscv64-y := sha256-riscv64-glue.o sha256-riscv64-zvknha_or_zvknhb-zvkb.o
 
diff --git a/arch/riscv/crypto/ghash-riscv64-clmul.c b/arch/riscv/crypto/ghash-riscv64-clmul.c
new file mode 100644
index 000000000000..4777aa8e94cb
--- /dev/null
+++ b/arch/riscv/crypto/ghash-riscv64-clmul.c
@@ -0,0 +1,270 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * GHASH using the RISC-V Zbc/Zbkc (CLMUL) extension
+ *
+ * Copyright (C) 2023 VRULL GmbH
+ * Author: Christoph Müllner <christoph.muellner@vrull.eu>
+ *
+ * Copyright (C) 2025 Siflower Communications Ltd
+ * Author: Qingfang Deng <qingfang.deng@siflower.com.cn>
+ */
+
+#include <linux/crypto.h>
+#include <linux/err.h>
+#include <linux/module.h>
+#include <linux/types.h>
+#include <crypto/ghash.h>
+#include <crypto/internal/hash.h>
+
+#define GHASH_MOD_POLY	0xc200000000000000
+
+struct riscv64_clmul_ghash_ctx {
+	__uint128_t key;
+};
+
+struct riscv64_clmul_ghash_desc_ctx {
+	__uint128_t shash;
+	u8 buffer[GHASH_DIGEST_SIZE];
+	int bytes;
+};
+
+static __always_inline u64 riscv_zbb_swab64(u64 val)
+{
+	asm (".option push\n"
+	     ".option arch,+zbb\n"
+	     "rev8 %0, %1\n"
+	     ".option pop\n"
+	     : "=r" (val) : "r" (val));
+	return val;
+}
+
+static __always_inline __uint128_t get_unaligned_be128(const u8 *p)
+{
+	__uint128_t val;
+#ifdef CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS
+	val = *(__uint128_t *)p;
+	val = riscv_zbb_swab64(val >> 64) | (__uint128_t)riscv_zbb_swab64(val) << 64;
+#else
+	val = (__uint128_t)p[0] << 120;
+	val |= (__uint128_t)p[1] << 112;
+	val |= (__uint128_t)p[2] << 104;
+	val |= (__uint128_t)p[3] << 96;
+	val |= (__uint128_t)p[4] << 88;
+	val |= (__uint128_t)p[5] << 80;
+	val |= (__uint128_t)p[6] << 72;
+	val |= (__uint128_t)p[7] << 64;
+	val |= (__uint128_t)p[8] << 56;
+	val |= (__uint128_t)p[9] << 48;
+	val |= (__uint128_t)p[10] << 40;
+	val |= (__uint128_t)p[11] << 32;
+	val |= (__uint128_t)p[12] << 24;
+	val |= (__uint128_t)p[13] << 16;
+	val |= (__uint128_t)p[14] << 8;
+	val |= (__uint128_t)p[15];
+#endif
+	return val;
+}
+
+static __always_inline void put_unaligned_be128(__uint128_t val, u8 *p)
+{
+#ifdef CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS
+	*(__uint128_t *)p = riscv_zbb_swab64(val >> 64) | (__uint128_t)riscv_zbb_swab64(val) << 64;
+#else
+	p[0] = val >> 120;
+	p[1] = val >> 112;
+	p[2] = val >> 104;
+	p[3] = val >> 96;
+	p[4] = val >> 88;
+	p[5] = val >> 80;
+	p[6] = val >> 72;
+	p[7] = val >> 64;
+	p[8] = val >> 56;
+	p[9] = val >> 48;
+	p[10] = val >> 40;
+	p[11] = val >> 32;
+	p[12] = val >> 24;
+	p[13] = val >> 16;
+	p[14] = val >> 8;
+	p[15] = val;
+#endif
+}
+
+static __always_inline __attribute_const__
+__uint128_t clmul128(u64 a, u64 b)
+{
+	u64 hi, lo;
+
+	asm(".option push\n"
+	    ".option arch,+zbc\n"
+	    "clmul	%0, %2, %3\n"
+	    "clmulh	%1, %2, %3\n"
+	    ".option pop\n"
+	    : "=&r" (lo), "=&r" (hi) : "r" (a), "r" (b));
+	return (__uint128_t)hi << 64 | lo;
+}
+
+static int riscv64_clmul_ghash_init(struct shash_desc *desc)
+{
+	struct riscv64_clmul_ghash_desc_ctx *dctx = shash_desc_ctx(desc);
+
+	dctx->bytes = 0;
+	dctx->shash = 0;
+	return 0;
+}
+
+/* Compute GMULT (Xi*H mod f) using the Zbc (clmul) extensions.
+ * Using the no-Karatsuba approach and clmul for the final reduction.
+ * This results in an implementation with minimized number of instructions.
+ * HW with clmul latencies higher than 2 cycles might observe a performance
+ * improvement with Karatsuba. HW with clmul latencies higher than 6 cycles
+ * might observe a performance improvement with additionally converting the
+ * reduction to shift&xor. For a full discussion of this estimates see
+ * https://github.com/riscv/riscv-crypto/blob/master/doc/supp/gcm-mode-cmul.adoc
+ */
+static void gcm_ghash_rv64i_zbc(__uint128_t *Xi, __uint128_t k, const u8 *inp, size_t len)
+{
+	u64 k_hi = k >> 64, k_lo = k, p_hi, p_lo;
+	__uint128_t hash = *Xi, p;
+
+	do {
+		__uint128_t t0, t1, t2, t3, lo, mid, hi;
+
+		/* Load the input data, byte-reverse them, and XOR them with Xi */
+		p = get_unaligned_be128(inp);
+
+		inp += GHASH_BLOCK_SIZE;
+		len -= GHASH_BLOCK_SIZE;
+
+		p ^= hash;
+		p_hi = p >> 64;
+		p_lo = p;
+
+		/* Multiplication (without Karatsuba) */
+		t0 = clmul128(p_lo, k_lo);
+		t1 = clmul128(p_lo, k_hi);
+		t2 = clmul128(p_hi, k_lo);
+		t3 = clmul128(p_hi, k_hi);
+		mid = t1 ^ t2;
+		lo = t0 ^ (mid << 64);
+		hi = t3 ^ (mid >> 64);
+
+		/* Reduction with clmul */
+		mid = clmul128(lo, GHASH_MOD_POLY);
+		lo ^= mid << 64;
+		hi ^= lo ^ (mid >> 64);
+		hi ^= clmul128(lo >> 64, GHASH_MOD_POLY);
+		hash = hi;
+	} while (len);
+
+	*Xi = hash;
+}
+
+static int riscv64_clmul_ghash_setkey(struct crypto_shash *tfm, const u8 *key, unsigned int keylen)
+{
+	struct riscv64_clmul_ghash_ctx *ctx = crypto_shash_ctx(tfm);
+	__uint128_t k;
+
+	if (keylen != GHASH_BLOCK_SIZE)
+		return -EINVAL;
+
+	k = get_unaligned_be128(key);
+	k = (k << 1 | k >> 127) ^ (k >> 127 ? (__uint128_t)GHASH_MOD_POLY << 64 : 0);
+	ctx->key = k;
+
+	return 0;
+}
+
+static int riscv64_clmul_ghash_update(struct shash_desc *desc, const u8 *src, unsigned int srclen)
+{
+	struct riscv64_clmul_ghash_ctx *ctx = crypto_shash_ctx(desc->tfm);
+	struct riscv64_clmul_ghash_desc_ctx *dctx = shash_desc_ctx(desc);
+	unsigned int len;
+
+	if (dctx->bytes) {
+		if (dctx->bytes + srclen < GHASH_DIGEST_SIZE) {
+			memcpy(dctx->buffer + dctx->bytes, src, srclen);
+			dctx->bytes += srclen;
+			return 0;
+		}
+		memcpy(dctx->buffer + dctx->bytes, src, GHASH_DIGEST_SIZE - dctx->bytes);
+
+		gcm_ghash_rv64i_zbc(&dctx->shash, ctx->key, dctx->buffer, GHASH_DIGEST_SIZE);
+
+		src += GHASH_DIGEST_SIZE - dctx->bytes;
+		srclen -= GHASH_DIGEST_SIZE - dctx->bytes;
+		dctx->bytes = 0;
+	}
+
+	len = round_down(srclen, GHASH_BLOCK_SIZE);
+	if (len) {
+		gcm_ghash_rv64i_zbc(&dctx->shash, ctx->key, src, len);
+		src += len;
+		srclen -= len;
+	}
+
+	if (srclen) {
+		memcpy(dctx->buffer, src, srclen);
+		dctx->bytes = srclen;
+	}
+	return 0;
+}
+
+static int riscv64_clmul_ghash_final(struct shash_desc *desc, u8 out[GHASH_DIGEST_SIZE])
+{
+	struct riscv64_clmul_ghash_ctx *ctx = crypto_shash_ctx(desc->tfm);
+	struct riscv64_clmul_ghash_desc_ctx *dctx = shash_desc_ctx(desc);
+	int i;
+
+	if (dctx->bytes) {
+		for (i = dctx->bytes; i < GHASH_DIGEST_SIZE; i++)
+			dctx->buffer[i] = 0;
+		gcm_ghash_rv64i_zbc(&dctx->shash, ctx->key, dctx->buffer, GHASH_DIGEST_SIZE);
+		dctx->bytes = 0;
+	}
+	put_unaligned_be128(dctx->shash, out);
+	return 0;
+}
+
+struct shash_alg riscv64_clmul_ghash_alg = {
+	.init = riscv64_clmul_ghash_init,
+	.update = riscv64_clmul_ghash_update,
+	.final = riscv64_clmul_ghash_final,
+	.setkey = riscv64_clmul_ghash_setkey,
+	.descsize = sizeof(struct riscv64_clmul_ghash_desc_ctx),
+	.digestsize = GHASH_DIGEST_SIZE,
+	.base = {
+		 .cra_blocksize = GHASH_BLOCK_SIZE,
+		 .cra_ctxsize = sizeof(struct riscv64_clmul_ghash_ctx),
+		 .cra_priority = 250,
+		 .cra_name = "ghash",
+		 .cra_driver_name = "ghash-riscv64-clmul",
+		 .cra_module = THIS_MODULE,
+	},
+};
+
+static int __init riscv64_clmul_ghash_mod_init(void)
+{
+	bool has_clmul, has_rev8;
+
+	has_clmul = riscv_isa_extension_available(NULL, ZBC) ||
+		    riscv_isa_extension_available(NULL, ZBKC);
+	has_rev8 = riscv_isa_extension_available(NULL, ZBB) ||
+		   riscv_isa_extension_available(NULL, ZBKB);
+	if (has_clmul && has_rev8)
+		return crypto_register_shash(&riscv64_clmul_ghash_alg);
+
+	return -ENODEV;
+}
+
+static void __exit riscv64_clmul_ghash_mod_fini(void)
+{
+	crypto_unregister_shash(&riscv64_clmul_ghash_alg);
+}
+
+module_init(riscv64_clmul_ghash_mod_init);
+module_exit(riscv64_clmul_ghash_mod_fini);
+
+MODULE_DESCRIPTION("GHASH (RISC-V CLMUL accelerated)");
+MODULE_AUTHOR("Qingfang Deng <dqfext@gmail.com>");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS_CRYPTO("ghash");
-- 
2.43.0

