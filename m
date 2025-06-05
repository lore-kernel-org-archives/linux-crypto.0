Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 623384683
	for <linux-crypto@vger.kernel.org>; Thu,  5 Jun 2025 14:57:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749135457; cv=none; b=Fdr1h/POWugbZwA4zgbMuJNcHG4Sdb0x9cXQ/M7UefoCCK39ECXkM8E7iCmG8MR42CZKBUCX80r78gIZP3qptzWg/ZwmSCFwL6/OdSHPhr8OVZGsHJgh9Hh0shh6iNAG2ce1+Ns+eif94XxEgp+Tbc5thR/l2Bradhwsen7me9c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749135457; c=relaxed/simple;
	bh=jFs/DVTOh5vW9JspKcDBx4Vph22c5IqT9sHs7XxPybc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=m6r2bDD2Q48ACscmiU9UyOfLJ4twAinGMkz4+ZCJBinDKDpVAQJXZZN2yVssC//757SJwU7jFbTt84MKQmA9MbyOJB70adS1AGvRCjfk50V/QD/H6FAIsznjEWdUpovUNVsXAxo/kOfW2bTqHZedu/cOm3eHBKyYzbkcbyW2vok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Zmj3khIU; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Zmj3khIU"
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-235e1d4cba0so8521705ad.2
        for <linux-crypto@vger.kernel.org>; Thu, 05 Jun 2025 07:57:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1749135454; x=1749740254; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ty3hssekYdDZ3XoUnAxgyIYp/FiJgR8YkKT1FFyzNck=;
        b=Zmj3khIULCfysQfdFFZXDDTwzqtLzWaO3g4rEh2k0tQR6nxK2wxx2r0GPhDza3L/5B
         Ya+jo8ohBUNP2BbriTRpePZB2KYQplhBc8EHQ4+EGVguJwPvnuqFQCA9mEqD2exjQQTp
         bNMPnd3pbyIhkCtHaI8YdCHj0m6/rV6LxbkhjRRav6tJ66c56eE7lppIYZEUCretdquJ
         cshemQPJ4dTArzAAB/OVO+rGL3xAoQbCFkrSK/GK0tDRqANG6Xcpp85AuZLCTyYot0DR
         g5xS5dmzyAlmNUtQ6Wr8BgGZH1UVr+gzRoolBlxplpVPQl6HghEGvo7xQ8243jodKcJS
         vseQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749135454; x=1749740254;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ty3hssekYdDZ3XoUnAxgyIYp/FiJgR8YkKT1FFyzNck=;
        b=Jsw/VYRW3G8ocQWN7GVxAjank2Ta58oVah6nZjQRO7F7DoNiu1vWWOP4+T8VWe80PQ
         vSFKFNiksCuv/d7w028cVb2jzV1279F8MbU0YShgC66c01tNbw3apiJOGhDRiPkANAjY
         0E+wpov+4Sf063KzED/sG9+2wC3UqgLVwMAhrDmiRq8KVbpdjAYILrux77L+/aVAVIz+
         Bj08yLor7U593zVCdBr3jt8CrvW8UvZ9EGm5YL4XnKdTW86DTWEQHhW5Obb8QiEAvXcS
         9qdPc/rZeB/us+XroaNeIP4E5tEmjfuHFBrW/pdHb97u1ZjSvtKv7vGe7FK6njYYX3D/
         +abg==
X-Gm-Message-State: AOJu0Yxv4wkDHDw/vena9yVklfj0MmEwO7JQ7J+/LmFwN1NHHVr6cd34
	wZT6xORRD1ewthYi1RSed3MGRFmiteJD0dg1H9iuOFBqU4243Nh4jCBjxN2TlA==
X-Gm-Gg: ASbGncsOixqLoGtACOt6dxkKazZWMT5/+pPzHIKyflvEIDgjNlPXJxSEfzJvqTyhc4t
	7fZSy4RpO7wKBFMV/35vBy2+QiIjUenNYDNaFgOvf0icWA0ycrdn1Y98aGcJqkZQThv5kIcx0e5
	OMI+mOcN8bDRStvelmfaFgvYQTQwevAB9P29Jo5kWdSHPvPiMx6aeWYEvy33WjFhr8XFkdX3x3L
	l1m5AX7NCXvTwW51WfvhN0zByzKRL3zD9Nvf/3UNoQ1UQuDt17fD5zLCTd3CzLcoz4sH5ZEZmle
	rQdA9hmcsdc7wOPdmBvBwyM1Inzqv5vrdNkCh45LH7ddWsV2fh9BZSFrsIkj5TD0MvPKAIvF
X-Google-Smtp-Source: AGHT+IEs7UMpBkpzSjl27Y7VY05ctLYI1AvzwgRN9vGnZVzfNDj4a/pWfSptuUQ5x51wfWkOMp716Q==
X-Received: by 2002:a17:903:40d2:b0:234:d399:f948 with SMTP id d9443c01a7336-235e11e2373mr98567185ad.33.1749135453494;
        Thu, 05 Jun 2025 07:57:33 -0700 (PDT)
Received: from localhost ([103.233.162.254])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-23506bc8657sm120774035ad.30.2025.06.05.07.57.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Jun 2025 07:57:33 -0700 (PDT)
From: zhihang.shao.iscas@gmail.com
To: linux-crypto@vger.kernel.org
Cc: linux-riscv@lists.infradead.org,
	herbert@gondor.apana.org.au,
	paul.walmsley@sifive.com,
	ou@eecs.berkeley.edu,
	alex@ghiti.fr,
	appro@cryptogams.org
Subject: [PATCH] crypto: riscv/poly1305 - import OpenSSL/CRYPTOGAMS implementation
Date: Thu,  5 Jun 2025 22:56:34 +0800
Message-ID: <20250605145634.1075-1-zhihang.shao.iscas@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Zhihang Shao <zhihang.shao.iscas@gmail.com>

This is a straight import of the OpenSSL/CRYPTOGAMS Poly1305
implementation for riscv authored by Andy Polyakov.
The file 'poly1305-riscv.pl' is taken straight from this upstream
GitHub repository [0] at commit 33fe84bc21219a16825459b37c825bf4580a0a7b,
and this commit fixed a bug in riscv 64bit implementation.
Also, this patch passed extra run-time self tests.

[0] https://github.com/dot-asm/cryptogams

Signed-off-by: Zhihang Shao <zhihang.shao.iscas@gmail.com>
---
 arch/riscv/crypto/Kconfig           |  10 +
 arch/riscv/crypto/Makefile          |  17 +
 arch/riscv/crypto/poly1305-glue.c   | 202 +++++++
 arch/riscv/crypto/poly1305-riscv.pl | 797 ++++++++++++++++++++++++++++
 drivers/net/Kconfig                 |   1 +
 lib/crypto/Kconfig                  |   2 +-
 6 files changed, 1028 insertions(+), 1 deletion(-)
 create mode 100644 arch/riscv/crypto/poly1305-glue.c
 create mode 100644 arch/riscv/crypto/poly1305-riscv.pl

diff --git a/arch/riscv/crypto/Kconfig b/arch/riscv/crypto/Kconfig
index c67095a3d669..228bb3c6940d 100644
--- a/arch/riscv/crypto/Kconfig
+++ b/arch/riscv/crypto/Kconfig
@@ -38,6 +38,16 @@ config CRYPTO_GHASH_RISCV64
 	  Architecture: riscv64 using:
 	  - Zvkg vector crypto extension
 
+config CRYPTO_POLY1305_RISCV
+	tristate "Hash functions: Poly1305"
+	select CRYPTO_HASH
+	select CRYPTO_ARCH_HAVE_LIB_POLY1305
+	help
+	  Poly1305 authenticator algorithm (RFC7539)
+
+	  Architecture: riscv using:
+	  - V vector extension
+
 config CRYPTO_SHA256_RISCV64
 	tristate "Hash functions: SHA-224 and SHA-256"
 	depends on 64BIT && RISCV_ISA_V && TOOLCHAIN_HAS_VECTOR_CRYPTO
diff --git a/arch/riscv/crypto/Makefile b/arch/riscv/crypto/Makefile
index 247c7bc7288c..0c96bd9a61b3 100644
--- a/arch/riscv/crypto/Makefile
+++ b/arch/riscv/crypto/Makefile
@@ -10,6 +10,10 @@ chacha-riscv64-y := chacha-riscv64-glue.o chacha-riscv64-zvkb.o
 obj-$(CONFIG_CRYPTO_GHASH_RISCV64) += ghash-riscv64.o
 ghash-riscv64-y := ghash-riscv64-glue.o ghash-riscv64-zvkg.o
 
+obj-$(CONFIG_CRYPTO_POLY1305_RISCV) += poly1305-riscv.o
+poly1305-riscv-y := poly1305-core.o poly1305-glue.o
+AFLAGS_poly1305-core.o += -Dpoly1305_init=poly1305_init_riscv
+
 obj-$(CONFIG_CRYPTO_SHA256_RISCV64) += sha256-riscv64.o
 sha256-riscv64-y := sha256-riscv64-glue.o sha256-riscv64-zvknha_or_zvknhb-zvkb.o
 
@@ -21,3 +25,15 @@ sm3-riscv64-y := sm3-riscv64-glue.o sm3-riscv64-zvksh-zvkb.o
 
 obj-$(CONFIG_CRYPTO_SM4_RISCV64) += sm4-riscv64.o
 sm4-riscv64-y := sm4-riscv64-glue.o sm4-riscv64-zvksed-zvkb.o
+
+ifeq ($(CONFIG_64BIT),y)
+PERLASM_ARCH := 64
+else
+PERLASM_ARCH := void
+endif
+
+quiet_cmd_perlasm = PERLASM $@
+      cmd_perlasm = $(PERL) $(<) $(PERLASM_ARCH) $(@)
+
+$(obj)/%-core.S: $(src)/%-riscv.pl
+	$(call cmd,perlasm)
diff --git a/arch/riscv/crypto/poly1305-glue.c b/arch/riscv/crypto/poly1305-glue.c
new file mode 100644
index 000000000000..b8e038a50c13
--- /dev/null
+++ b/arch/riscv/crypto/poly1305-glue.c
@@ -0,0 +1,202 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * OpenSSL/Cryptogams accelerated Poly1305 transform for riscv
+ *
+ * Copyright (C) 2025 Institute of Software, CAS.
+ */
+
+#include <asm/hwcap.h>
+#include <asm/simd.h>
+#include <linux/unaligned.h>
+#include <crypto/algapi.h>
+#include <crypto/internal/hash.h>
+#include <crypto/internal/poly1305.h>
+#include <crypto/internal/simd.h>
+#include <linux/cpufeature.h>
+#include <linux/crypto.h>
+#include <linux/jump_label.h>
+#include <linux/module.h>
+
+asmlinkage void poly1305_init_riscv(void *state, const u8 *key);
+asmlinkage void poly1305_blocks(void *state, const u8 *src, u32 len, u32 hibit);
+asmlinkage void poly1305_emit(void *state, u8 *digest, const u32 *nonce);
+
+void poly1305_init_arch(struct poly1305_desc_ctx *dctx, const u8 key[POLY1305_KEY_SIZE])
+{
+	poly1305_init_riscv(&dctx->h, key);
+	dctx->s[0] = get_unaligned_le32(key + 16);
+	dctx->s[1] = get_unaligned_le32(key + 20);
+	dctx->s[2] = get_unaligned_le32(key + 24);
+	dctx->s[3] = get_unaligned_le32(key + 28);
+	dctx->buflen = 0;
+}
+EXPORT_SYMBOL(poly1305_init_arch);
+
+static int riscv64_poly1305_init(struct shash_desc *desc)
+{
+	struct poly1305_desc_ctx *dctx = shash_desc_ctx(desc);
+
+	dctx->buflen = 0;
+	dctx->rset = 0;
+	dctx->sset = false;
+
+	return 0;
+}
+
+static void riscv64_poly1305_blocks(struct poly1305_desc_ctx *dctx, const u8 *src,
+				 u32 len, u32 hibit)
+{
+	if (unlikely(!dctx->sset)) {
+		if (!dctx->rset) {
+			poly1305_init_riscv(&dctx->h, src);
+			src += POLY1305_BLOCK_SIZE;
+			len -= POLY1305_BLOCK_SIZE;
+			dctx->rset = 1;
+		}
+		if (len >= POLY1305_BLOCK_SIZE) {
+			dctx->s[0] = get_unaligned_le32(src +  0);
+			dctx->s[1] = get_unaligned_le32(src +  4);
+			dctx->s[2] = get_unaligned_le32(src +  8);
+			dctx->s[3] = get_unaligned_le32(src + 12);
+			src += POLY1305_BLOCK_SIZE;
+			len -= POLY1305_BLOCK_SIZE;
+			dctx->sset = true;
+		}
+		if (len < POLY1305_BLOCK_SIZE)
+			return;
+	}
+
+	len &= ~(POLY1305_BLOCK_SIZE - 1);
+
+	poly1305_blocks(&dctx->h, src, len, hibit);
+}
+
+static void riscv64_poly1305_do_update(struct poly1305_desc_ctx *dctx,
+				    const u8 *src, u32 len)
+{
+	if (unlikely(dctx->buflen)) {
+		u32 bytes = min(len, POLY1305_BLOCK_SIZE - dctx->buflen);
+
+		memcpy(dctx->buf + dctx->buflen, src, bytes);
+		src += bytes;
+		len -= bytes;
+		dctx->buflen += bytes;
+
+		if (dctx->buflen == POLY1305_BLOCK_SIZE) {
+			riscv64_poly1305_blocks(dctx, dctx->buf,
+					     POLY1305_BLOCK_SIZE, 1);
+			dctx->buflen = 0;
+		}
+	}
+
+	if (likely(len >= POLY1305_BLOCK_SIZE)) {
+		riscv64_poly1305_blocks(dctx, src, len, 1);
+		src += round_down(len, POLY1305_BLOCK_SIZE);
+		len %= POLY1305_BLOCK_SIZE;
+	}
+
+	if (unlikely(len)) {
+		dctx->buflen = len;
+		memcpy(dctx->buf, src, len);
+	}
+}
+
+static int riscv64_poly1305_update(struct shash_desc *desc,
+				const u8 *src, unsigned int srclen)
+{
+	struct poly1305_desc_ctx *dctx = shash_desc_ctx(desc);
+
+	riscv64_poly1305_do_update(dctx, src, srclen);
+	return 0;
+}
+
+void poly1305_update_arch(struct poly1305_desc_ctx *dctx, const u8 *src,
+			  unsigned int nbytes)
+{
+	if (unlikely(dctx->buflen)) {
+		u32 bytes = min(nbytes, POLY1305_BLOCK_SIZE - dctx->buflen);
+
+		memcpy(dctx->buf + dctx->buflen, src, bytes);
+		src += bytes;
+		nbytes -= bytes;
+		dctx->buflen += bytes;
+
+		if (dctx->buflen == POLY1305_BLOCK_SIZE) {
+			poly1305_blocks(&dctx->h, dctx->buf, POLY1305_BLOCK_SIZE, 1);
+			dctx->buflen = 0;
+		}
+	}
+
+	if (likely(nbytes >= POLY1305_BLOCK_SIZE)) {
+		unsigned int len = round_down(nbytes, POLY1305_BLOCK_SIZE);
+
+		poly1305_blocks(&dctx->h, src, len, 1);
+		src += len;
+		nbytes %= POLY1305_BLOCK_SIZE;
+	}
+
+	if (unlikely(nbytes)) {
+		dctx->buflen = nbytes;
+		memcpy(dctx->buf, src, nbytes);
+	}
+}
+EXPORT_SYMBOL(poly1305_update_arch);
+
+void poly1305_final_arch(struct poly1305_desc_ctx *dctx, u8 *dst)
+{
+	if (unlikely(dctx->buflen)) {
+		dctx->buf[dctx->buflen++] = 1;
+		memset(dctx->buf + dctx->buflen, 0,
+		       POLY1305_BLOCK_SIZE - dctx->buflen);
+		poly1305_blocks(&dctx->h, dctx->buf, POLY1305_BLOCK_SIZE, 0);
+	}
+
+	poly1305_emit(&dctx->h, dst, dctx->s);
+	memzero_explicit(dctx, sizeof(*dctx));
+}
+EXPORT_SYMBOL(poly1305_final_arch);
+
+static int riscv64_poly1305_final(struct shash_desc *desc, u8 *dst)
+{
+	struct poly1305_desc_ctx *dctx = shash_desc_ctx(desc);
+
+	if (unlikely(!dctx->sset))
+		return -ENOKEY;
+
+	poly1305_final_arch(dctx, dst);
+	return 0;
+}
+
+static struct shash_alg riscv64_poly1305_alg = {
+	.init			= riscv64_poly1305_init,
+	.update			= riscv64_poly1305_update,
+	.final			= riscv64_poly1305_final,
+	.digestsize		= POLY1305_DIGEST_SIZE,
+	.descsize		= sizeof(struct poly1305_desc_ctx),
+
+	.base.cra_name		= "poly1305",
+	.base.cra_driver_name	= "poly1305-riscv64",
+	.base.cra_priority	= 200,
+	.base.cra_blocksize	= POLY1305_BLOCK_SIZE,
+	.base.cra_module	= THIS_MODULE,
+};
+
+static int __init riscv64_poly1305_mod_init(void)
+{
+	return IS_REACHABLE(CONFIG_CRYPTO_HASH) ?
+		crypto_register_shash(&riscv64_poly1305_alg) : 0;
+}
+
+static void __exit riscv64_poly1305_mod_exit(void)
+{
+	if (IS_REACHABLE(CONFIG_CRYPTO_HASH))
+		crypto_unregister_shash(&riscv64_poly1305_alg);
+}
+
+module_init(riscv64_poly1305_mod_init);
+module_exit(riscv64_poly1305_mod_exit);
+
+MODULE_DESCRIPTION("Poly1305 (RISC-V accelerated)");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS_CRYPTO("poly1305");
+MODULE_ALIAS_CRYPTO("poly1305-riscv64");
diff --git a/arch/riscv/crypto/poly1305-riscv.pl b/arch/riscv/crypto/poly1305-riscv.pl
new file mode 100644
index 000000000000..315ccc328fd9
--- /dev/null
+++ b/arch/riscv/crypto/poly1305-riscv.pl
@@ -0,0 +1,797 @@
+#!/usr/bin/env perl
+# SPDX-License-Identifier: GPL-1.0+ OR BSD-3-Clause
+#
+# ====================================================================
+# Written by Andy Polyakov, @dot-asm, initially for use with OpenSSL.
+# ====================================================================
+#
+# Poly1305 hash for RISC-V.
+#
+# February 2019
+#
+# In the essence it's pretty straightforward transliteration of MIPS
+# module [without big-endian option].
+#
+# 3.9 cycles per byte on U74, ~60% faster than compiler-generated code.
+# 1.9 cpb on C910, ~75% improvement. 2.3 cpb on JH7110 (U74 with
+# apparently better multiplier), ~69% faster, 3.3 on Spacemit X60,
+# ~69% improvement.
+#
+# June 2024.
+#
+# Add CHERI support.
+#
+######################################################################
+#
+($zero,$ra,$sp,$gp,$tp)=map("x$_",(0..4));
+($t0,$t1,$t2,$t3,$t4,$t5,$t6)=map("x$_",(5..7,28..31));
+($a0,$a1,$a2,$a3,$a4,$a5,$a6,$a7)=map("x$_",(10..17));
+($s0,$s1,$s2,$s3,$s4,$s5,$s6,$s7,$s8,$s9,$s10,$s11)=map("x$_",(8,9,18..27));
+#
+######################################################################
+
+$flavour = shift || "64";
+
+for (@ARGV) {   $output=$_ if (/\w[\w\-]*\.\w+$/);   }
+open STDOUT,">$output";
+
+if ($flavour =~ /64/) {{{
+######################################################################
+# 64-bit code path...
+#
+my ($ctx,$inp,$len,$padbit) = ($a0,$a1,$a2,$a3);
+my ($in0,$in1,$tmp0,$tmp1,$tmp2,$tmp3,$tmp4) = ($a4,$a5,$a6,$a7,$t0,$t1,$t2);
+
+$code.=<<___;
+#if __riscv_xlen == 64
+# if __SIZEOF_POINTER__ == 16
+#  define PUSH	csc
+#  define POP	clc
+# else
+#  define PUSH	sd
+#  define POP	ld
+# endif
+#else
+# error "unsupported __riscv_xlen"
+#endif
+
+.option	pic
+.text
+
+.globl	poly1305_init
+.type	poly1305_init,\@function
+poly1305_init:
+	sd	$zero,0($ctx)
+	sd	$zero,8($ctx)
+	sd	$zero,16($ctx)
+
+	beqz	$inp,.Lno_key
+
+#ifndef	__CHERI_PURE_CAPABILITY__
+	andi	$tmp0,$inp,7		# $inp % 8
+	andi	$inp,$inp,-8		# align $inp
+	slli	$tmp0,$tmp0,3		# byte to bit offset
+#endif
+	ld	$in0,0($inp)
+	ld	$in1,8($inp)
+#ifndef	__CHERI_PURE_CAPABILITY__
+	beqz	$tmp0,.Laligned_key
+
+	ld	$tmp2,16($inp)
+	neg	$tmp1,$tmp0		# implicit &63 in sll
+	srl	$in0,$in0,$tmp0
+	sll	$tmp3,$in1,$tmp1
+	srl	$in1,$in1,$tmp0
+	sll	$tmp2,$tmp2,$tmp1
+	or	$in0,$in0,$tmp3
+	or	$in1,$in1,$tmp2
+
+.Laligned_key:
+#endif
+	li	$tmp0,1
+	slli	$tmp0,$tmp0,32		# 0x0000000100000000
+	addi	$tmp0,$tmp0,-63		# 0x00000000ffffffc1
+	slli	$tmp0,$tmp0,28		# 0x0ffffffc10000000
+	addi	$tmp0,$tmp0,-1		# 0x0ffffffc0fffffff
+
+	and	$in0,$in0,$tmp0
+	addi	$tmp0,$tmp0,-3		# 0x0ffffffc0ffffffc
+	and	$in1,$in1,$tmp0
+
+	sd	$in0,24($ctx)
+	srli	$tmp0,$in1,2
+	sd	$in1,32($ctx)
+	add	$tmp0,$tmp0,$in1	# s1 = r1 + (r1 >> 2)
+	sd	$tmp0,40($ctx)
+
+.Lno_key:
+	li	$a0,0			# return 0
+	ret
+.size	poly1305_init,.-poly1305_init
+___
+{
+my ($h0,$h1,$h2,$r0,$r1,$rs1,$d0,$d1,$d2) =
+   ($s0,$s1,$s2,$s3,$t3,$t4,$in0,$in1,$t2);
+my ($shr,$shl) = ($t5,$t6);		# used on R6
+
+$code.=<<___;
+.globl	poly1305_blocks
+.type	poly1305_blocks,\@function
+poly1305_blocks:
+	andi	$len,$len,-16		# complete blocks only
+	beqz	$len,.Lno_data
+
+	caddi	$sp,$sp,-4*__SIZEOF_POINTER__
+	PUSH	$s0,3*__SIZEOF_POINTER__($sp)
+	PUSH	$s1,2*__SIZEOF_POINTER__($sp)
+	PUSH	$s2,1*__SIZEOF_POINTER__($sp)
+	PUSH	$s3,0*__SIZEOF_POINTER__($sp)
+
+#ifndef	__CHERI_PURE_CAPABILITY__
+	andi	$shr,$inp,7
+	andi	$inp,$inp,-8		# align $inp
+	slli	$shr,$shr,3		# byte to bit offset
+	neg	$shl,$shr		# implicit &63 in sll
+#endif
+
+	ld	$h0,0($ctx)		# load hash value
+	ld	$h1,8($ctx)
+	ld	$h2,16($ctx)
+
+	ld	$r0,24($ctx)		# load key
+	ld	$r1,32($ctx)
+	ld	$rs1,40($ctx)
+
+	add	$len,$len,$inp		# end of buffer
+
+.Loop:
+	ld	$in0,0($inp)		# load input
+	ld	$in1,8($inp)
+#ifndef	__CHERI_PURE_CAPABILITY__
+	beqz	$shr,.Laligned_inp
+
+	ld	$tmp2,16($inp)
+	srl	$in0,$in0,$shr
+	sll	$tmp3,$in1,$shl
+	srl	$in1,$in1,$shr
+	sll	$tmp2,$tmp2,$shl
+	or	$in0,$in0,$tmp3
+	or	$in1,$in1,$tmp2
+
+.Laligned_inp:
+#endif
+	caddi	$inp,$inp,16
+
+	andi	$tmp0,$h2,-4		# modulo-scheduled reduction
+	srli	$tmp1,$h2,2
+	andi	$h2,$h2,3
+
+	add	$d0,$h0,$in0		# accumulate input
+	 add	$tmp1,$tmp1,$tmp0
+	sltu	$tmp0,$d0,$h0
+	add	$d0,$d0,$tmp1		# ... and residue
+	sltu	$tmp1,$d0,$tmp1
+	add	$d1,$h1,$in1
+	add	$tmp0,$tmp0,$tmp1
+	sltu	$tmp1,$d1,$h1
+	add	$d1,$d1,$tmp0
+
+	 add	$d2,$h2,$padbit
+	 sltu	$tmp0,$d1,$tmp0
+	mulhu	$h1,$r0,$d0		# h0*r0
+	mul	$h0,$r0,$d0
+
+	 add	$d2,$d2,$tmp1
+	 add	$d2,$d2,$tmp0
+	mulhu	$tmp1,$rs1,$d1		# h1*5*r1
+	mul	$tmp0,$rs1,$d1
+
+	mulhu	$h2,$r1,$d0		# h0*r1
+	mul	$tmp2,$r1,$d0
+	 add	$h0,$h0,$tmp0
+	 add	$h1,$h1,$tmp1
+	 sltu	$tmp0,$h0,$tmp0
+
+	 add	$h1,$h1,$tmp0
+	 add	$h1,$h1,$tmp2
+	mulhu	$tmp1,$r0,$d1		# h1*r0
+	mul	$tmp0,$r0,$d1
+
+	 sltu	$tmp2,$h1,$tmp2
+	 add	$h2,$h2,$tmp2
+	mul	$tmp2,$rs1,$d2		# h2*5*r1
+
+	 add	$h1,$h1,$tmp0
+	 add	$h2,$h2,$tmp1
+	mul	$tmp3,$r0,$d2		# h2*r0
+	 sltu	$tmp0,$h1,$tmp0
+	 add	$h2,$h2,$tmp0
+
+	add	$h1,$h1,$tmp2
+	sltu	$tmp2,$h1,$tmp2
+	add	$h2,$h2,$tmp2
+	add	$h2,$h2,$tmp3
+
+	bne	$inp,$len,.Loop
+
+	sd	$h0,0($ctx)		# store hash value
+	sd	$h1,8($ctx)
+	sd	$h2,16($ctx)
+
+	POP	$s0,3*__SIZEOF_POINTER__($sp)		# epilogue
+	POP	$s1,2*__SIZEOF_POINTER__($sp)
+	POP	$s2,1*__SIZEOF_POINTER__($sp)
+	POP	$s3,0*__SIZEOF_POINTER__($sp)
+	caddi	$sp,$sp,4*__SIZEOF_POINTER__
+
+.Lno_data:
+	ret
+.size	poly1305_blocks,.-poly1305_blocks
+___
+}
+{
+my ($ctx,$mac,$nonce) = ($a0,$a1,$a2);
+
+$code.=<<___;
+.globl	poly1305_emit
+.type	poly1305_emit,\@function
+poly1305_emit:
+	ld	$tmp2,16($ctx)
+	ld	$tmp0,0($ctx)
+	ld	$tmp1,8($ctx)
+
+	andi	$in0,$tmp2,-4		# final reduction
+	srl	$in1,$tmp2,2
+	andi	$tmp2,$tmp2,3
+	add	$in0,$in0,$in1
+
+	add	$tmp0,$tmp0,$in0
+	sltu	$in1,$tmp0,$in0
+	 addi	$in0,$tmp0,5		# compare to modulus
+	add	$tmp1,$tmp1,$in1
+	 sltiu	$tmp3,$in0,5
+	sltu	$tmp4,$tmp1,$in1
+	 add	$in1,$tmp1,$tmp3
+	add	$tmp2,$tmp2,$tmp4
+	 sltu	$tmp3,$in1,$tmp3
+	 add	$tmp2,$tmp2,$tmp3
+
+	srli	$tmp2,$tmp2,2		# see if it carried/borrowed
+	neg	$tmp2,$tmp2
+
+	xor	$in0,$in0,$tmp0
+	xor	$in1,$in1,$tmp1
+	and	$in0,$in0,$tmp2
+	and	$in1,$in1,$tmp2
+	xor	$in0,$in0,$tmp0
+	xor	$in1,$in1,$tmp1
+
+	lwu	$tmp0,0($nonce)		# load nonce
+	lwu	$tmp1,4($nonce)
+	lwu	$tmp2,8($nonce)
+	lwu	$tmp3,12($nonce)
+	slli	$tmp1,$tmp1,32
+	slli	$tmp3,$tmp3,32
+	or	$tmp0,$tmp0,$tmp1
+	or	$tmp2,$tmp2,$tmp3
+
+	add	$in0,$in0,$tmp0		# accumulate nonce
+	add	$in1,$in1,$tmp2
+	sltu	$tmp0,$in0,$tmp0
+	add	$in1,$in1,$tmp0
+
+	srli	$tmp0,$in0,8		# write mac value
+	srli	$tmp1,$in0,16
+	srli	$tmp2,$in0,24
+	sb	$in0,0($mac)
+	srli	$tmp3,$in0,32
+	sb	$tmp0,1($mac)
+	srli	$tmp0,$in0,40
+	sb	$tmp1,2($mac)
+	srli	$tmp1,$in0,48
+	sb	$tmp2,3($mac)
+	srli	$tmp2,$in0,56
+	sb	$tmp3,4($mac)
+	srli	$tmp3,$in1,8
+	sb	$tmp0,5($mac)
+	srli	$tmp0,$in1,16
+	sb	$tmp1,6($mac)
+	srli	$tmp1,$in1,24
+	sb	$tmp2,7($mac)
+
+	sb	$in1,8($mac)
+	srli	$tmp2,$in1,32
+	sb	$tmp3,9($mac)
+	srli	$tmp3,$in1,40
+	sb	$tmp0,10($mac)
+	srli	$tmp0,$in1,48
+	sb	$tmp1,11($mac)
+	srli	$tmp1,$in1,56
+	sb	$tmp2,12($mac)
+	sb	$tmp3,13($mac)
+	sb	$tmp0,14($mac)
+	sb	$tmp1,15($mac)
+
+	ret
+.size	poly1305_emit,.-poly1305_emit
+.string	"Poly1305 for RISC-V, CRYPTOGAMS by \@dot-asm"
+___
+}
+}}} else {{{
+######################################################################
+# 32-bit code path
+#
+
+my ($ctx,$inp,$len,$padbit) = ($a0,$a1,$a2,$a3);
+my ($in0,$in1,$in2,$in3,$tmp0,$tmp1,$tmp2,$tmp3) =
+   ($a4,$a5,$a6,$a7,$t0,$t1,$t2,$t3);
+
+$code.=<<___;
+#if __riscv_xlen == 32
+# if __SIZEOF_POINTER__ == 8
+#  define PUSH	csc
+#  define POP	clc
+# else
+#  define PUSH	sw
+#  define POP	lw
+# endif
+# define MULX(hi,lo,a,b)	mulhu hi,a,b; mul lo,a,b
+# define srlw	srl
+# define sllw	sll
+# define addw	add
+# define addiw	addi
+# define mulw	mul
+#elif __riscv_xlen == 64
+# if __SIZEOF_POINTER__ == 16
+#  define PUSH	csc
+#  define POP	clc
+# else
+#  define PUSH	sd
+#  define POP	ld
+# endif
+# define MULX(hi,lo,a,b)	slli b,b,32; srli b,b,32; mul hi,a,b; addiw lo,hi,0; srai hi,hi,32
+#else
+# error "unsupported __riscv_xlen"
+#endif
+
+.option	pic
+.text
+
+.globl	poly1305_init
+.type	poly1305_init,\@function
+poly1305_init:
+	sw	$zero,0($ctx)
+	sw	$zero,4($ctx)
+	sw	$zero,8($ctx)
+	sw	$zero,12($ctx)
+	sw	$zero,16($ctx)
+
+	beqz	$inp,.Lno_key
+
+#ifndef	__CHERI_PURE_CAPABILITY__
+	andi	$tmp0,$inp,3		# $inp % 4
+	sub	$inp,$inp,$tmp0		# align $inp
+	sll	$tmp0,$tmp0,3		# byte to bit offset
+#endif
+	lw	$in0,0($inp)
+	lw	$in1,4($inp)
+	lw	$in2,8($inp)
+	lw	$in3,12($inp)
+#ifndef	__CHERI_PURE_CAPABILITY__
+	beqz	$tmp0,.Laligned_key
+
+	lw	$tmp2,16($inp)
+	sub	$tmp1,$zero,$tmp0
+	srlw	$in0,$in0,$tmp0
+	sllw	$tmp3,$in1,$tmp1
+	srlw	$in1,$in1,$tmp0
+	or	$in0,$in0,$tmp3
+	sllw	$tmp3,$in2,$tmp1
+	srlw	$in2,$in2,$tmp0
+	or	$in1,$in1,$tmp3
+	sllw	$tmp3,$in3,$tmp1
+	srlw	$in3,$in3,$tmp0
+	or	$in2,$in2,$tmp3
+	sllw	$tmp2,$tmp2,$tmp1
+	or	$in3,$in3,$tmp2
+.Laligned_key:
+#endif
+
+	lui	$tmp0,0x10000
+	addi	$tmp0,$tmp0,-1		# 0x0fffffff
+	and	$in0,$in0,$tmp0
+	addi	$tmp0,$tmp0,-3		# 0x0ffffffc
+	and	$in1,$in1,$tmp0
+	and	$in2,$in2,$tmp0
+	and	$in3,$in3,$tmp0
+
+	sw	$in0,20($ctx)
+	sw	$in1,24($ctx)
+	sw	$in2,28($ctx)
+	sw	$in3,32($ctx)
+
+	srlw	$tmp1,$in1,2
+	srlw	$tmp2,$in2,2
+	srlw	$tmp3,$in3,2
+	addw	$in1,$in1,$tmp1		# s1 = r1 + (r1 >> 2)
+	addw	$in2,$in2,$tmp2
+	addw	$in3,$in3,$tmp3
+	sw	$in1,36($ctx)
+	sw	$in2,40($ctx)
+	sw	$in3,44($ctx)
+.Lno_key:
+	li	$a0,0
+	ret
+.size	poly1305_init,.-poly1305_init
+___
+{
+my ($h0,$h1,$h2,$h3,$h4, $r0,$r1,$r2,$r3, $rs1,$rs2,$rs3) =
+   ($s0,$s1,$s2,$s3,$s4, $s5,$s6,$s7,$s8, $t0,$t1,$t2);
+my ($d0,$d1,$d2,$d3) =
+   ($a4,$a5,$a6,$a7);
+my $shr = $ra;		# used on R6
+
+$code.=<<___;
+.globl	poly1305_blocks
+.type	poly1305_blocks,\@function
+poly1305_blocks:
+	andi	$len,$len,-16		# complete blocks only
+	beqz	$len,.Labort
+
+	caddi	$sp,$sp,-__SIZEOF_POINTER__*12
+	PUSH	$ra, __SIZEOF_POINTER__*11($sp)
+	PUSH	$s0, __SIZEOF_POINTER__*10($sp)
+	PUSH	$s1, __SIZEOF_POINTER__*9($sp)
+	PUSH	$s2, __SIZEOF_POINTER__*8($sp)
+	PUSH	$s3, __SIZEOF_POINTER__*7($sp)
+	PUSH	$s4, __SIZEOF_POINTER__*6($sp)
+	PUSH	$s5, __SIZEOF_POINTER__*5($sp)
+	PUSH	$s6, __SIZEOF_POINTER__*4($sp)
+	PUSH	$s7, __SIZEOF_POINTER__*3($sp)
+	PUSH	$s8, __SIZEOF_POINTER__*2($sp)
+
+#ifndef	__CHERI_PURE_CAPABILITY__
+	andi	$shr,$inp,3
+	andi	$inp,$inp,-4		# align $inp
+	slli	$shr,$shr,3		# byte to bit offset
+#endif
+
+	lw	$h0,0($ctx)		# load hash value
+	lw	$h1,4($ctx)
+	lw	$h2,8($ctx)
+	lw	$h3,12($ctx)
+	lw	$h4,16($ctx)
+
+	lw	$r0,20($ctx)		# load key
+	lw	$r1,24($ctx)
+	lw	$r2,28($ctx)
+	lw	$r3,32($ctx)
+	lw	$rs1,36($ctx)
+	lw	$rs2,40($ctx)
+	lw	$rs3,44($ctx)
+
+	add	$len,$len,$inp		# end of buffer
+
+.Loop:
+	lw	$d0,0($inp)		# load input
+	lw	$d1,4($inp)
+	lw	$d2,8($inp)
+	lw	$d3,12($inp)
+#ifndef	__CHERI_PURE_CAPABILITY__
+	beqz	$shr,.Laligned_inp
+
+	lw	$t4,16($inp)
+	sub	$t5,$zero,$shr
+	srlw	$d0,$d0,$shr
+	sllw	$t3,$d1,$t5
+	srlw	$d1,$d1,$shr
+	or	$d0,$d0,$t3
+	sllw	$t3,$d2,$t5
+	srlw	$d2,$d2,$shr
+	or	$d1,$d1,$t3
+	sllw	$t3,$d3,$t5
+	srlw	$d3,$d3,$shr
+	or	$d2,$d2,$t3
+	sllw	$t4,$t4,$t5
+	or	$d3,$d3,$t4
+
+.Laligned_inp:
+#endif
+	srli	$t3,$h4,2		# modulo-scheduled reduction
+	andi	$t4,$h4,-4
+	andi	$h4,$h4,3
+
+	addw	$d0,$d0,$h0		# accumulate input
+	 addw	$t4,$t4,$t3
+	sltu	$h0,$d0,$h0
+	addw	$d0,$d0,$t4		# ... and residue
+	sltu	$t4,$d0,$t4
+
+	addw	$d1,$d1,$h1
+	 addw	$h0,$h0,$t4		# carry
+	sltu	$h1,$d1,$h1
+	addw	$d1,$d1,$h0
+	sltu	$h0,$d1,$h0
+
+	addw	$d2,$d2,$h2
+	 addw	$h1,$h1,$h0		# carry
+	sltu	$h2,$d2,$h2
+	addw	$d2,$d2,$h1
+	sltu	$h1,$d2,$h1
+
+	addw	$d3,$d3,$h3
+	 addw	$h2,$h2,$h1		# carry
+	sltu	$h3,$d3,$h3
+	addw	$d3,$d3,$h2
+
+	MULX	($h1,$h0,$r0,$d0)	# d0*r0
+
+	 sltu	$h2,$d3,$h2
+	 addw	$h3,$h3,$h2		# carry
+
+	MULX	($t4,$t3,$rs3,$d1)	# d1*s3
+
+	 addw	$h4,$h4,$padbit
+	 caddi	$inp,$inp,16
+	 addw	$h4,$h4,$h3
+
+	MULX	($t6,$a3,$rs2,$d2)	# d2*s2
+	 addw	$h0,$h0,$t3
+	 addw	$h1,$h1,$t4
+	 sltu	$t3,$h0,$t3
+	 addw	$h1,$h1,$t3
+
+	MULX	($t4,$t3,$rs1,$d3)	# d3*s1
+	 addw	$h0,$h0,$a3
+	 addw	$h1,$h1,$t6
+	 sltu	$a3,$h0,$a3
+	 addw	$h1,$h1,$a3
+
+
+	MULX	($h2,$a3,$r1,$d0)	# d0*r1
+	 addw	$h0,$h0,$t3
+	 addw	$h1,$h1,$t4
+	 sltu	$t3,$h0,$t3
+	 addw	$h1,$h1,$t3
+
+	MULX	($t4,$t3,$r0,$d1)	# d1*r0
+	 addw	$h1,$h1,$a3
+	 sltu	$a3,$h1,$a3
+	 addw	$h2,$h2,$a3
+
+	MULX	($t6,$a3,$rs3,$d2)	# d2*s3
+	 addw	$h1,$h1,$t3
+	 addw	$h2,$h2,$t4
+	 sltu	$t3,$h1,$t3
+	 addw	$h2,$h2,$t3
+
+	MULX	($t4,$t3,$rs2,$d3)	# d3*s2
+	 addw	$h1,$h1,$a3
+	 addw	$h2,$h2,$t6
+	 sltu	$a3,$h1,$a3
+	 addw	$h2,$h2,$a3
+
+	mulw	$a3,$rs1,$h4		# h4*s1
+	 addw	$h1,$h1,$t3
+	 addw	$h2,$h2,$t4
+	 sltu	$t3,$h1,$t3
+	 addw	$h2,$h2,$t3
+
+
+	MULX	($h3,$t3,$r2,$d0)	# d0*r2
+	 addw	$h1,$h1,$a3
+	 sltu	$a3,$h1,$a3
+	 addw	$h2,$h2,$a3
+
+	MULX	($t6,$a3,$r1,$d1)	# d1*r1
+	 addw	$h2,$h2,$t3
+	 sltu	$t3,$h2,$t3
+	 addw	$h3,$h3,$t3
+
+	MULX	($t4,$t3,$r0,$d2)	# d2*r0
+	 addw	$h2,$h2,$a3
+	 addw	$h3,$h3,$t6
+	 sltu	$a3,$h2,$a3
+	 addw	$h3,$h3,$a3
+
+	MULX	($t6,$a3,$rs3,$d3)	# d3*s3
+	 addw	$h2,$h2,$t3
+	 addw	$h3,$h3,$t4
+	 sltu	$t3,$h2,$t3
+	 addw	$h3,$h3,$t3
+
+	mulw	$t3,$rs2,$h4		# h4*s2
+	 addw	$h2,$h2,$a3
+	 addw	$h3,$h3,$t6
+	 sltu	$a3,$h2,$a3
+	 addw	$h3,$h3,$a3
+
+
+	MULX	($t6,$a3,$r3,$d0)	# d0*r3
+	 addw	$h2,$h2,$t3
+	 sltu	$t3,$h2,$t3
+	 addw	$h3,$h3,$t3
+
+	MULX	($t4,$t3,$r2,$d1)	# d1*r2
+	 addw	$h3,$h3,$a3
+	 sltu	$a3,$h3,$a3
+	 addw	$t6,$t6,$a3
+
+	MULX	($a3,$d3,$r0,$d3)	# d3*r0
+	 addw	$h3,$h3,$t3
+	 addw	$t6,$t6,$t4
+	 sltu	$t3,$h3,$t3
+	 addw	$t6,$t6,$t3
+
+	MULX	($t4,$t3,$r1,$d2)	# d2*r1
+	 addw	$h3,$h3,$d3
+	 addw	$t6,$t6,$a3
+	 sltu	$d3,$h3,$d3
+	 addw	$t6,$t6,$d3
+
+	mulw	$a3,$rs3,$h4		# h4*s3
+	 addw	$h3,$h3,$t3
+	 addw	$t6,$t6,$t4
+	 sltu	$t3,$h3,$t3
+	 addw	$t6,$t6,$t3
+
+
+	mulw	$h4,$r0,$h4		# h4*r0
+	 addw	$h3,$h3,$a3
+	 sltu	$a3,$h3,$a3
+	 addw	$t6,$t6,$a3
+	addw	$h4,$t6,$h4
+
+	li	$padbit,1		# if we loop, padbit is 1
+
+	bne	$inp,$len,.Loop
+
+	sw	$h0,0($ctx)		# store hash value
+	sw	$h1,4($ctx)
+	sw	$h2,8($ctx)
+	sw	$h3,12($ctx)
+	sw	$h4,16($ctx)
+
+	POP	$ra, __SIZEOF_POINTER__*11($sp)
+	POP	$s0, __SIZEOF_POINTER__*10($sp)
+	POP	$s1, __SIZEOF_POINTER__*9($sp)
+	POP	$s2, __SIZEOF_POINTER__*8($sp)
+	POP	$s3, __SIZEOF_POINTER__*7($sp)
+	POP	$s4, __SIZEOF_POINTER__*6($sp)
+	POP	$s5, __SIZEOF_POINTER__*5($sp)
+	POP	$s6, __SIZEOF_POINTER__*4($sp)
+	POP	$s7, __SIZEOF_POINTER__*3($sp)
+	POP	$s8, __SIZEOF_POINTER__*2($sp)
+	caddi	$sp,$sp,__SIZEOF_POINTER__*12
+.Labort:
+	ret
+.size	poly1305_blocks,.-poly1305_blocks
+___
+}
+{
+my ($ctx,$mac,$nonce,$tmp4) = ($a0,$a1,$a2,$a3);
+
+$code.=<<___;
+.globl	poly1305_emit
+.type	poly1305_emit,\@function
+poly1305_emit:
+	lw	$tmp4,16($ctx)
+	lw	$tmp0,0($ctx)
+	lw	$tmp1,4($ctx)
+	lw	$tmp2,8($ctx)
+	lw	$tmp3,12($ctx)
+
+	srli	$ctx,$tmp4,2		# final reduction
+	andi	$in0,$tmp4,-4
+	andi	$tmp4,$tmp4,3
+	addw	$ctx,$ctx,$in0
+
+	addw	$tmp0,$tmp0,$ctx
+	sltu	$ctx,$tmp0,$ctx
+	 addiw	$in0,$tmp0,5		# compare to modulus
+	addw	$tmp1,$tmp1,$ctx
+	 sltiu	$in1,$in0,5
+	sltu	$ctx,$tmp1,$ctx
+	 addw	$in1,$in1,$tmp1
+	addw	$tmp2,$tmp2,$ctx
+	 sltu	$in2,$in1,$tmp1
+	sltu	$ctx,$tmp2,$ctx
+	 addw	$in2,$in2,$tmp2
+	addw	$tmp3,$tmp3,$ctx
+	 sltu	$in3,$in2,$tmp2
+	sltu	$ctx,$tmp3,$ctx
+	 addw	$in3,$in3,$tmp3
+	addw	$tmp4,$tmp4,$ctx
+	 sltu	$ctx,$in3,$tmp3
+	 addw	$ctx,$ctx,$tmp4
+
+	srl	$ctx,$ctx,2		# see if it carried/borrowed
+	sub	$ctx,$zero,$ctx
+
+	xor	$in0,$in0,$tmp0
+	xor	$in1,$in1,$tmp1
+	xor	$in2,$in2,$tmp2
+	xor	$in3,$in3,$tmp3
+	and	$in0,$in0,$ctx
+	and	$in1,$in1,$ctx
+	and	$in2,$in2,$ctx
+	and	$in3,$in3,$ctx
+	xor	$in0,$in0,$tmp0
+	xor	$in1,$in1,$tmp1
+	xor	$in2,$in2,$tmp2
+	xor	$in3,$in3,$tmp3
+
+	lw	$tmp0,0($nonce)		# load nonce
+	lw	$tmp1,4($nonce)
+	lw	$tmp2,8($nonce)
+	lw	$tmp3,12($nonce)
+
+	addw	$in0,$in0,$tmp0		# accumulate nonce
+	sltu	$ctx,$in0,$tmp0
+
+	addw	$in1,$in1,$tmp1
+	sltu	$tmp1,$in1,$tmp1
+	addw	$in1,$in1,$ctx
+	sltu	$ctx,$in1,$ctx
+	addw	$ctx,$ctx,$tmp1
+
+	addw	$in2,$in2,$tmp2
+	sltu	$tmp2,$in2,$tmp2
+	addw	$in2,$in2,$ctx
+	sltu	$ctx,$in2,$ctx
+	addw	$ctx,$ctx,$tmp2
+
+	addw	$in3,$in3,$tmp3
+	addw	$in3,$in3,$ctx
+
+	srl	$tmp0,$in0,8		# write mac value
+	srl	$tmp1,$in0,16
+	srl	$tmp2,$in0,24
+	sb	$in0, 0($mac)
+	sb	$tmp0,1($mac)
+	srl	$tmp0,$in1,8
+	sb	$tmp1,2($mac)
+	srl	$tmp1,$in1,16
+	sb	$tmp2,3($mac)
+	srl	$tmp2,$in1,24
+	sb	$in1, 4($mac)
+	sb	$tmp0,5($mac)
+	srl	$tmp0,$in2,8
+	sb	$tmp1,6($mac)
+	srl	$tmp1,$in2,16
+	sb	$tmp2,7($mac)
+	srl	$tmp2,$in2,24
+	sb	$in2, 8($mac)
+	sb	$tmp0,9($mac)
+	srl	$tmp0,$in3,8
+	sb	$tmp1,10($mac)
+	srl	$tmp1,$in3,16
+	sb	$tmp2,11($mac)
+	srl	$tmp2,$in3,24
+	sb	$in3, 12($mac)
+	sb	$tmp0,13($mac)
+	sb	$tmp1,14($mac)
+	sb	$tmp2,15($mac)
+
+	ret
+.size	poly1305_emit,.-poly1305_emit
+.string	"Poly1305 for RISC-V, CRYPTOGAMS by \@dot-asm"
+___
+}
+}}}
+
+foreach (split("\n", $code)) {
+    if ($flavour =~ /^cheri/) {
+	s/\(x([0-9]+)\)/(c$1)/ and s/\b([ls][bhwd]u?)\b/c$1/;
+	s/\b(PUSH|POP)(\s+)x([0-9]+)/$1$2c$3/ or
+	s/\b(ret|jal)\b/c$1/;
+	s/\bcaddi?\b/cincoffset/ and s/\bx([0-9]+,)/c$1/g or
+	m/\bcmove\b/ and s/\bx([0-9]+)/c$1/g;
+    } else {
+	s/\bcaddi?\b/add/ or
+	s/\bcmove\b/mv/;
+    }
+    print $_, "\n";
+}
+
+close STDOUT;
\ No newline at end of file
diff --git a/drivers/net/Kconfig b/drivers/net/Kconfig
index 271520510b5f..f303ac05a380 100644
--- a/drivers/net/Kconfig
+++ b/drivers/net/Kconfig
@@ -94,6 +94,7 @@ config WIREGUARD
 	select CRYPTO_CHACHA_MIPS if CPU_MIPS32_R2
 	select CRYPTO_POLY1305_MIPS if MIPS
 	select CRYPTO_CHACHA_S390 if S390
+    select CRYPTO_POLY1305_RISCV if RISCV
 	help
 	  WireGuard is a secure, fast, and easy to use replacement for IPSec
 	  that uses modern cryptography and clever networking tricks. It's
diff --git a/lib/crypto/Kconfig b/lib/crypto/Kconfig
index 798972b29b68..d9a13519bf6b 100644
--- a/lib/crypto/Kconfig
+++ b/lib/crypto/Kconfig
@@ -106,7 +106,7 @@ config CRYPTO_LIB_DES
 
 config CRYPTO_LIB_POLY1305_RSIZE
 	int
-	default 2 if MIPS
+	default 2 if MIPS || RISCV
 	default 11 if X86_64
 	default 9 if ARM || ARM64
 	default 1
-- 
2.43.0

