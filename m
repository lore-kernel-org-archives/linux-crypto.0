Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C171D1865EB;
	Sat,  8 Feb 2025 02:49:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738982964; cv=none; b=a8RyIJn784yKYn3eXQ/NCgMDqhnhxgpKvtwDRfKep20dHQQ+vNd/Matqs7yzvfw//GBQ4mSKzbDssJE7Zekkjy8eGo9TZnGBQYwrks90b6dBgcWVzzXnixESrh4ZsQr0G/t/+aw/Xt0MaVQHuqP2rpC56Y6HFjW6e3r5jjue3k0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738982964; c=relaxed/simple;
	bh=TGsjrJN8DMO1soH9ja5q3Xtc4TKdVEGfEvOJVNzUTvQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lXkS7jKpjc2L77/exT4o++wIIziusCf487ffWrHhDiZNB4MC9j9wIiUsAaTAuomEY+JEHj1jgUnMYCrj8PAPfwDguFpb8GZUJkREfMU1ZeS0rDbB0lQ1QAQTD5CpZqLkGaVnLrmcJffQBwnacCniZNBdDnhmOfxGVsfJCIraKBk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CHyike94; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CHyike94"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41632C4CEF1;
	Sat,  8 Feb 2025 02:49:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738982964;
	bh=TGsjrJN8DMO1soH9ja5q3Xtc4TKdVEGfEvOJVNzUTvQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CHyike94/smVr06QN8j7ijQxcB4IIlUFDvL6JImV6H4xLHHZAFiGXi8JpYJXd91fe
	 wAJ09yi/UiMVG3laRhXiH+Ky97yjrMZEoNZir97EBYAznaf7agBH9ddhPfmI5K6jE+
	 paGUWund83585GYOHT6Z/oYg+IiQmczcgVhlxEPZKM0/z4Ho8qZjlr2atFaSr9V0H8
	 RA6BJWXBY2iLOsGddsG/ETUh/qwNjck7yl61dLF3G57wqk5iKRgTicxoGeG59icwLy
	 aTewsB9hOG6t14FaCdiPmrC3GMtGVjwSEuyGq1ey2KBBCFdAlQOnlsFK7R4W0gZiDk
	 tU2HTAYt3kT8w==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: linux-crypto@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH v2 6/6] lib/crc32: remove "_le" from crc32c base and arch functions
Date: Fri,  7 Feb 2025 18:49:11 -0800
Message-ID: <20250208024911.14936-7-ebiggers@kernel.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250208024911.14936-1-ebiggers@kernel.org>
References: <20250208024911.14936-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Eric Biggers <ebiggers@google.com>

Following the standardization on crc32c() as the lib entry point for the
Castagnoli CRC32 instead of the previous mix of crc32c(), crc32c_le(),
and __crc32c_le(), make the same change to the underlying base and arch
functions that implement it.

Reviewed-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 arch/arm/lib/crc32-glue.c            | 12 ++++++------
 arch/arm64/lib/crc32-glue.c          |  6 +++---
 arch/loongarch/lib/crc32-loongarch.c |  6 +++---
 arch/mips/lib/crc32-mips.c           |  6 +++---
 arch/powerpc/lib/crc32-glue.c        | 10 +++++-----
 arch/riscv/lib/crc32-riscv.c         |  6 +++---
 arch/s390/lib/crc32-glue.c           |  2 +-
 arch/sparc/lib/crc32_glue.c          | 10 +++++-----
 arch/x86/lib/crc32-glue.c            |  6 +++---
 crypto/crc32c_generic.c              |  4 ++--
 include/linux/crc32.h                |  8 ++++----
 lib/crc32.c                          |  4 ++--
 12 files changed, 40 insertions(+), 40 deletions(-)

diff --git a/arch/arm/lib/crc32-glue.c b/arch/arm/lib/crc32-glue.c
index 2c30ba3d80e6a..4340351dbde8c 100644
--- a/arch/arm/lib/crc32-glue.c
+++ b/arch/arm/lib/crc32-glue.c
@@ -57,39 +57,39 @@ u32 crc32_le_arch(u32 crc, const u8 *p, size_t len)
 	}
 	return crc32_le_scalar(crc, p, len);
 }
 EXPORT_SYMBOL(crc32_le_arch);
 
-static u32 crc32c_le_scalar(u32 crc, const u8 *p, size_t len)
+static u32 crc32c_scalar(u32 crc, const u8 *p, size_t len)
 {
 	if (static_branch_likely(&have_crc32))
 		return crc32c_armv8_le(crc, p, len);
-	return crc32c_le_base(crc, p, len);
+	return crc32c_base(crc, p, len);
 }
 
-u32 crc32c_le_arch(u32 crc, const u8 *p, size_t len)
+u32 crc32c_arch(u32 crc, const u8 *p, size_t len)
 {
 	if (len >= PMULL_MIN_LEN + 15 &&
 	    static_branch_likely(&have_pmull) && crypto_simd_usable()) {
 		size_t n = -(uintptr_t)p & 15;
 
 		/* align p to 16-byte boundary */
 		if (n) {
-			crc = crc32c_le_scalar(crc, p, n);
+			crc = crc32c_scalar(crc, p, n);
 			p += n;
 			len -= n;
 		}
 		n = round_down(len, 16);
 		kernel_neon_begin();
 		crc = crc32c_pmull_le(p, n, crc);
 		kernel_neon_end();
 		p += n;
 		len -= n;
 	}
-	return crc32c_le_scalar(crc, p, len);
+	return crc32c_scalar(crc, p, len);
 }
-EXPORT_SYMBOL(crc32c_le_arch);
+EXPORT_SYMBOL(crc32c_arch);
 
 u32 crc32_be_arch(u32 crc, const u8 *p, size_t len)
 {
 	return crc32_be_base(crc, p, len);
 }
diff --git a/arch/arm64/lib/crc32-glue.c b/arch/arm64/lib/crc32-glue.c
index 265fbf36914b6..ed3acd71178f8 100644
--- a/arch/arm64/lib/crc32-glue.c
+++ b/arch/arm64/lib/crc32-glue.c
@@ -41,14 +41,14 @@ u32 crc32_le_arch(u32 crc, const u8 *p, size_t len)
 
 	return crc32_le_arm64(crc, p, len);
 }
 EXPORT_SYMBOL(crc32_le_arch);
 
-u32 crc32c_le_arch(u32 crc, const u8 *p, size_t len)
+u32 crc32c_arch(u32 crc, const u8 *p, size_t len)
 {
 	if (!alternative_has_cap_likely(ARM64_HAS_CRC32))
-		return crc32c_le_base(crc, p, len);
+		return crc32c_base(crc, p, len);
 
 	if (len >= min_len && cpu_have_named_feature(PMULL) && crypto_simd_usable()) {
 		kernel_neon_begin();
 		crc = crc32c_le_arm64_4way(crc, p, len);
 		kernel_neon_end();
@@ -60,11 +60,11 @@ u32 crc32c_le_arch(u32 crc, const u8 *p, size_t len)
 			return crc;
 	}
 
 	return crc32c_le_arm64(crc, p, len);
 }
-EXPORT_SYMBOL(crc32c_le_arch);
+EXPORT_SYMBOL(crc32c_arch);
 
 u32 crc32_be_arch(u32 crc, const u8 *p, size_t len)
 {
 	if (!alternative_has_cap_likely(ARM64_HAS_CRC32))
 		return crc32_be_base(crc, p, len);
diff --git a/arch/loongarch/lib/crc32-loongarch.c b/arch/loongarch/lib/crc32-loongarch.c
index 8af8113ecd9d3..c44ee4f325578 100644
--- a/arch/loongarch/lib/crc32-loongarch.c
+++ b/arch/loongarch/lib/crc32-loongarch.c
@@ -63,14 +63,14 @@ u32 crc32_le_arch(u32 crc, const u8 *p, size_t len)
 
 	return crc;
 }
 EXPORT_SYMBOL(crc32_le_arch);
 
-u32 crc32c_le_arch(u32 crc, const u8 *p, size_t len)
+u32 crc32c_arch(u32 crc, const u8 *p, size_t len)
 {
 	if (!static_branch_likely(&have_crc32))
-		return crc32c_le_base(crc, p, len);
+		return crc32c_base(crc, p, len);
 
 	while (len >= sizeof(u64)) {
 		u64 value = get_unaligned_le64(p);
 
 		CRC32C(crc, value, d);
@@ -98,11 +98,11 @@ u32 crc32c_le_arch(u32 crc, const u8 *p, size_t len)
 		CRC32C(crc, value, b);
 	}
 
 	return crc;
 }
-EXPORT_SYMBOL(crc32c_le_arch);
+EXPORT_SYMBOL(crc32c_arch);
 
 u32 crc32_be_arch(u32 crc, const u8 *p, size_t len)
 {
 	return crc32_be_base(crc, p, len);
 }
diff --git a/arch/mips/lib/crc32-mips.c b/arch/mips/lib/crc32-mips.c
index 100ac586aadb2..676a4b3e290b9 100644
--- a/arch/mips/lib/crc32-mips.c
+++ b/arch/mips/lib/crc32-mips.c
@@ -106,14 +106,14 @@ u32 crc32_le_arch(u32 crc, const u8 *p, size_t len)
 
 	return crc;
 }
 EXPORT_SYMBOL(crc32_le_arch);
 
-u32 crc32c_le_arch(u32 crc, const u8 *p, size_t len)
+u32 crc32c_arch(u32 crc, const u8 *p, size_t len)
 {
 	if (!static_branch_likely(&have_crc32))
-		return crc32c_le_base(crc, p, len);
+		return crc32c_base(crc, p, len);
 
 	if (IS_ENABLED(CONFIG_64BIT)) {
 		for (; len >= sizeof(u64); p += sizeof(u64), len -= sizeof(u64)) {
 			u64 value = get_unaligned_le64(p);
 
@@ -147,11 +147,11 @@ u32 crc32c_le_arch(u32 crc, const u8 *p, size_t len)
 
 		CRC32C(crc, value, b);
 	}
 	return crc;
 }
-EXPORT_SYMBOL(crc32c_le_arch);
+EXPORT_SYMBOL(crc32c_arch);
 
 u32 crc32_be_arch(u32 crc, const u8 *p, size_t len)
 {
 	return crc32_be_base(crc, p, len);
 }
diff --git a/arch/powerpc/lib/crc32-glue.c b/arch/powerpc/lib/crc32-glue.c
index 79cc954f499f1..dbd10f339183d 100644
--- a/arch/powerpc/lib/crc32-glue.c
+++ b/arch/powerpc/lib/crc32-glue.c
@@ -21,22 +21,22 @@ u32 crc32_le_arch(u32 crc, const u8 *p, size_t len)
 {
 	return crc32_le_base(crc, p, len);
 }
 EXPORT_SYMBOL(crc32_le_arch);
 
-u32 crc32c_le_arch(u32 crc, const u8 *p, size_t len)
+u32 crc32c_arch(u32 crc, const u8 *p, size_t len)
 {
 	unsigned int prealign;
 	unsigned int tail;
 
 	if (len < (VECTOR_BREAKPOINT + VMX_ALIGN) ||
 	    !static_branch_likely(&have_vec_crypto) || !crypto_simd_usable())
-		return crc32c_le_base(crc, p, len);
+		return crc32c_base(crc, p, len);
 
 	if ((unsigned long)p & VMX_ALIGN_MASK) {
 		prealign = VMX_ALIGN - ((unsigned long)p & VMX_ALIGN_MASK);
-		crc = crc32c_le_base(crc, p, prealign);
+		crc = crc32c_base(crc, p, prealign);
 		len -= prealign;
 		p += prealign;
 	}
 
 	if (len & ~VMX_ALIGN_MASK) {
@@ -50,16 +50,16 @@ u32 crc32c_le_arch(u32 crc, const u8 *p, size_t len)
 	}
 
 	tail = len & VMX_ALIGN_MASK;
 	if (tail) {
 		p += len & ~VMX_ALIGN_MASK;
-		crc = crc32c_le_base(crc, p, tail);
+		crc = crc32c_base(crc, p, tail);
 	}
 
 	return crc;
 }
-EXPORT_SYMBOL(crc32c_le_arch);
+EXPORT_SYMBOL(crc32c_arch);
 
 u32 crc32_be_arch(u32 crc, const u8 *p, size_t len)
 {
 	return crc32_be_base(crc, p, len);
 }
diff --git a/arch/riscv/lib/crc32-riscv.c b/arch/riscv/lib/crc32-riscv.c
index a50f8e010417d..b5cb752847c40 100644
--- a/arch/riscv/lib/crc32-riscv.c
+++ b/arch/riscv/lib/crc32-riscv.c
@@ -222,16 +222,16 @@ u32 crc32_le_arch(u32 crc, const u8 *p, size_t len)
 	return crc32_le_generic(crc, p, len, CRC32_POLY_LE, CRC32_POLY_QT_LE,
 				crc32_le_base);
 }
 EXPORT_SYMBOL(crc32_le_arch);
 
-u32 crc32c_le_arch(u32 crc, const u8 *p, size_t len)
+u32 crc32c_arch(u32 crc, const u8 *p, size_t len)
 {
 	return crc32_le_generic(crc, p, len, CRC32C_POLY_LE,
-				CRC32C_POLY_QT_LE, crc32c_le_base);
+				CRC32C_POLY_QT_LE, crc32c_base);
 }
-EXPORT_SYMBOL(crc32c_le_arch);
+EXPORT_SYMBOL(crc32c_arch);
 
 static inline u32 crc32_be_unaligned(u32 crc, unsigned char const *p,
 				     size_t len)
 {
 	size_t bits = len * 8;
diff --git a/arch/s390/lib/crc32-glue.c b/arch/s390/lib/crc32-glue.c
index 137080e61f901..124214a273401 100644
--- a/arch/s390/lib/crc32-glue.c
+++ b/arch/s390/lib/crc32-glue.c
@@ -60,11 +60,11 @@ static DEFINE_STATIC_KEY_FALSE(have_vxrs);
 	}								    \
 	EXPORT_SYMBOL(___fname);
 
 DEFINE_CRC32_VX(crc32_le_arch, crc32_le_vgfm_16, crc32_le_base)
 DEFINE_CRC32_VX(crc32_be_arch, crc32_be_vgfm_16, crc32_be_base)
-DEFINE_CRC32_VX(crc32c_le_arch, crc32c_le_vgfm_16, crc32c_le_base)
+DEFINE_CRC32_VX(crc32c_arch, crc32c_le_vgfm_16, crc32c_base)
 
 static int __init crc32_s390_init(void)
 {
 	if (cpu_have_feature(S390_CPU_FEATURE_VXRS))
 		static_branch_enable(&have_vxrs);
diff --git a/arch/sparc/lib/crc32_glue.c b/arch/sparc/lib/crc32_glue.c
index 41076d2b1fd2d..a70752c729cf6 100644
--- a/arch/sparc/lib/crc32_glue.c
+++ b/arch/sparc/lib/crc32_glue.c
@@ -25,35 +25,35 @@ u32 crc32_le_arch(u32 crc, const u8 *data, size_t len)
 }
 EXPORT_SYMBOL(crc32_le_arch);
 
 void crc32c_sparc64(u32 *crcp, const u64 *data, size_t len);
 
-u32 crc32c_le_arch(u32 crc, const u8 *data, size_t len)
+u32 crc32c_arch(u32 crc, const u8 *data, size_t len)
 {
 	size_t n = -(uintptr_t)data & 7;
 
 	if (!static_branch_likely(&have_crc32c_opcode))
-		return crc32c_le_base(crc, data, len);
+		return crc32c_base(crc, data, len);
 
 	if (n) {
 		/* Data isn't 8-byte aligned.  Align it. */
 		n = min(n, len);
-		crc = crc32c_le_base(crc, data, n);
+		crc = crc32c_base(crc, data, n);
 		data += n;
 		len -= n;
 	}
 	n = len & ~7U;
 	if (n) {
 		crc32c_sparc64(&crc, (const u64 *)data, n);
 		data += n;
 		len -= n;
 	}
 	if (len)
-		crc = crc32c_le_base(crc, data, len);
+		crc = crc32c_base(crc, data, len);
 	return crc;
 }
-EXPORT_SYMBOL(crc32c_le_arch);
+EXPORT_SYMBOL(crc32c_arch);
 
 u32 crc32_be_arch(u32 crc, const u8 *data, size_t len)
 {
 	return crc32_be_base(crc, data, len);
 }
diff --git a/arch/x86/lib/crc32-glue.c b/arch/x86/lib/crc32-glue.c
index 2dd18a886ded8..131c305e9ea0d 100644
--- a/arch/x86/lib/crc32-glue.c
+++ b/arch/x86/lib/crc32-glue.c
@@ -59,16 +59,16 @@ EXPORT_SYMBOL(crc32_le_arch);
  */
 #define CRC32C_PCLMUL_BREAKEVEN	512
 
 asmlinkage u32 crc32c_x86_3way(u32 crc, const u8 *buffer, size_t len);
 
-u32 crc32c_le_arch(u32 crc, const u8 *p, size_t len)
+u32 crc32c_arch(u32 crc, const u8 *p, size_t len)
 {
 	size_t num_longs;
 
 	if (!static_branch_likely(&have_crc32))
-		return crc32c_le_base(crc, p, len);
+		return crc32c_base(crc, p, len);
 
 	if (IS_ENABLED(CONFIG_X86_64) && len >= CRC32C_PCLMUL_BREAKEVEN &&
 	    static_branch_likely(&have_pclmulqdq) && crypto_simd_usable()) {
 		kernel_fpu_begin();
 		crc = crc32c_x86_3way(crc, p, len);
@@ -83,11 +83,11 @@ u32 crc32c_le_arch(u32 crc, const u8 *p, size_t len)
 	for (len %= sizeof(unsigned long); len; len--, p++)
 		asm("crc32b %1, %0" : "+r" (crc) : "rm" (*p));
 
 	return crc;
 }
-EXPORT_SYMBOL(crc32c_le_arch);
+EXPORT_SYMBOL(crc32c_arch);
 
 u32 crc32_be_arch(u32 crc, const u8 *p, size_t len)
 {
 	return crc32_be_base(crc, p, len);
 }
diff --git a/crypto/crc32c_generic.c b/crypto/crc32c_generic.c
index 770533d19b813..b1a36d32dc50c 100644
--- a/crypto/crc32c_generic.c
+++ b/crypto/crc32c_generic.c
@@ -83,11 +83,11 @@ static int chksum_setkey(struct crypto_shash *tfm, const u8 *key,
 static int chksum_update(struct shash_desc *desc, const u8 *data,
 			 unsigned int length)
 {
 	struct chksum_desc_ctx *ctx = shash_desc_ctx(desc);
 
-	ctx->crc = crc32c_le_base(ctx->crc, data, length);
+	ctx->crc = crc32c_base(ctx->crc, data, length);
 	return 0;
 }
 
 static int chksum_update_arch(struct shash_desc *desc, const u8 *data,
 			      unsigned int length)
@@ -106,11 +106,11 @@ static int chksum_final(struct shash_desc *desc, u8 *out)
 	return 0;
 }
 
 static int __chksum_finup(u32 *crcp, const u8 *data, unsigned int len, u8 *out)
 {
-	put_unaligned_le32(~crc32c_le_base(*crcp, data, len), out);
+	put_unaligned_le32(~crc32c_base(*crcp, data, len), out);
 	return 0;
 }
 
 static int __chksum_finup_arch(u32 *crcp, const u8 *data, unsigned int len,
 			       u8 *out)
diff --git a/include/linux/crc32.h b/include/linux/crc32.h
index 535071964f52f..69c2e8bb37829 100644
--- a/include/linux/crc32.h
+++ b/include/linux/crc32.h
@@ -10,12 +10,12 @@
 
 u32 crc32_le_arch(u32 crc, const u8 *p, size_t len);
 u32 crc32_le_base(u32 crc, const u8 *p, size_t len);
 u32 crc32_be_arch(u32 crc, const u8 *p, size_t len);
 u32 crc32_be_base(u32 crc, const u8 *p, size_t len);
-u32 crc32c_le_arch(u32 crc, const u8 *p, size_t len);
-u32 crc32c_le_base(u32 crc, const u8 *p, size_t len);
+u32 crc32c_arch(u32 crc, const u8 *p, size_t len);
+u32 crc32c_base(u32 crc, const u8 *p, size_t len);
 
 static inline u32 crc32_le(u32 crc, const void *p, size_t len)
 {
 	if (IS_ENABLED(CONFIG_CRC32_ARCH))
 		return crc32_le_arch(crc, p, len);
@@ -30,12 +30,12 @@ static inline u32 crc32_be(u32 crc, const void *p, size_t len)
 }
 
 static inline u32 crc32c(u32 crc, const void *p, size_t len)
 {
 	if (IS_ENABLED(CONFIG_CRC32_ARCH))
-		return crc32c_le_arch(crc, p, len);
-	return crc32c_le_base(crc, p, len);
+		return crc32c_arch(crc, p, len);
+	return crc32c_base(crc, p, len);
 }
 
 /*
  * crc32_optimizations() returns flags that indicate which CRC32 library
  * functions are using architecture-specific optimizations.  Unlike
diff --git a/lib/crc32.c b/lib/crc32.c
index 554ef6827b80d..fddd424ff2245 100644
--- a/lib/crc32.c
+++ b/lib/crc32.c
@@ -43,17 +43,17 @@ u32 crc32_le_base(u32 crc, const u8 *p, size_t len)
 		crc = (crc >> 8) ^ crc32table_le[(crc & 255) ^ *p++];
 	return crc;
 }
 EXPORT_SYMBOL(crc32_le_base);
 
-u32 crc32c_le_base(u32 crc, const u8 *p, size_t len)
+u32 crc32c_base(u32 crc, const u8 *p, size_t len)
 {
 	while (len--)
 		crc = (crc >> 8) ^ crc32ctable_le[(crc & 255) ^ *p++];
 	return crc;
 }
-EXPORT_SYMBOL(crc32c_le_base);
+EXPORT_SYMBOL(crc32c_base);
 
 /*
  * This multiplies the polynomials x and y modulo the given modulus.
  * This follows the "little-endian" CRC convention that the lsbit
  * represents the highest power of x, and the msbit represents x^0.
-- 
2.48.1

