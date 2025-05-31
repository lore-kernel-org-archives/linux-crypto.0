Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F1D417A2EA;
	Sat, 31 May 2025 21:15:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748726118; cv=none; b=Sk0ky1Z5C+qNqRA/69OAthWDbioD70diamZ5vfR19sO1Y0N3km36HFRdUgnFfx5yNbdIP7M6NI2LhoFfz3AjigijrIpC5hVIx/WSfygiEXkWTlWJZZSfFFE+9Q7IHovR4aaXUQXhv+2bcmS3HVvohj5CZEQcBgB77tfMOhx+4OY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748726118; c=relaxed/simple;
	bh=Q5rcVhuBpXJo7qkt9JOzXELMMD/AGfv8ZVfFEfjj/dw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=oQB3M4XDwFi2nCi86fIqLi1Qw4mUhbFL7tKVHzz67J7Ya96s5S7Q8YMWRH8wiZ8V4xV6DwFvOVGVZ/580CKVVABsCJATMTMHrsADP0rp0mVQZD7mkIjNVOGDB8gOV3XJPMzWHKyGK9pGXvbY/66X8qIBmlA47mGAhJJAdi3K0j8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KRKKc+Lk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KRKKc+Lk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D41BC4CEE3;
	Sat, 31 May 2025 21:15:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1748726117;
	bh=Q5rcVhuBpXJo7qkt9JOzXELMMD/AGfv8ZVfFEfjj/dw=;
	h=From:To:Cc:Subject:Date:From;
	b=KRKKc+Lkol+aT2oXR7Fz98BrBIORKBjN3a7S4t1c1WoCYLHM1MkRpR7RJs8IeZDWM
	 82GWCH3tfJdUp/Hje3LepR07DX8OQEQ77h1G7EKyL/UcAk+0laG/Z8EqoOjSoZPaJb
	 AtIbHCUHpi4I6YIfeXzSxfM6LCt+aNq07CnfIAWCZE4K0Pq6uG1T22E2q1y3n8Ssmf
	 B2VqhEwGucD5fuo8+OR7Ru+KhF9YzU4UE1FDio773eRg//np2Y1sjmjwTh/JoqG7rK
	 GCAIDAJOcWPz+61KSsPFof4GYkqbu4leMyZDGRTQq+vqIeF+eW/QrDYwzgdQ+v/rMp
	 XU3AbQImQjbOQ==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: linux-crypto@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	Arnd Bergmann <arnd@arndb.de>,
	x86@kernel.org
Subject: [PATCH] x86/crc: drop checks of CONFIG_AS_VPCLMULQDQ
Date: Sat, 31 May 2025 14:13:18 -0700
Message-ID: <20250531211318.83677-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Eric Biggers <ebiggers@google.com>

Now that the minimum binutils version supports VPCLMULQDQ (and the
minimum clang version does too), there is no need to check for assembler
support before compiling code that uses these instructions.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---

I'd be glad to apply this to the crc tree.  Arnd, let me know if you'd
like to instead go with a patch that handles all of arch/x86/ at the
same time.  That would be fine with me too.

 arch/x86/lib/crc-pclmul-template.S | 7 -------
 arch/x86/lib/crc-pclmul-template.h | 3 +--
 2 files changed, 1 insertion(+), 9 deletions(-)

diff --git a/arch/x86/lib/crc-pclmul-template.S b/arch/x86/lib/crc-pclmul-template.S
index ae0b6144c503c..a02f7dc8053e0 100644
--- a/arch/x86/lib/crc-pclmul-template.S
+++ b/arch/x86/lib/crc-pclmul-template.S
@@ -559,11 +559,10 @@
 	pop		CONSTS_PTR
 #endif
 	RET
 .endm
 
-#ifdef CONFIG_AS_VPCLMULQDQ
 #define DEFINE_CRC_PCLMUL_FUNCS(prefix, bits, lsb)			\
 SYM_FUNC_START(prefix##_pclmul_sse);					\
 	_crc_pclmul	n=bits, lsb_crc=lsb, vl=16, avx_level=0;	\
 SYM_FUNC_END(prefix##_pclmul_sse);					\
 									\
@@ -572,11 +571,5 @@ SYM_FUNC_START(prefix##_vpclmul_avx2);					\
 SYM_FUNC_END(prefix##_vpclmul_avx2);					\
 									\
 SYM_FUNC_START(prefix##_vpclmul_avx512);				\
 	_crc_pclmul	n=bits, lsb_crc=lsb, vl=64, avx_level=512;	\
 SYM_FUNC_END(prefix##_vpclmul_avx512);
-#else
-#define DEFINE_CRC_PCLMUL_FUNCS(prefix, bits, lsb)			\
-SYM_FUNC_START(prefix##_pclmul_sse);					\
-	_crc_pclmul	n=bits, lsb_crc=lsb, vl=16, avx_level=0;	\
-SYM_FUNC_END(prefix##_pclmul_sse);
-#endif // !CONFIG_AS_VPCLMULQDQ
diff --git a/arch/x86/lib/crc-pclmul-template.h b/arch/x86/lib/crc-pclmul-template.h
index c5b3bfe11d8da..51cba520a7dbd 100644
--- a/arch/x86/lib/crc-pclmul-template.h
+++ b/arch/x86/lib/crc-pclmul-template.h
@@ -25,12 +25,11 @@ crc_t prefix##_vpclmul_avx512(crc_t crc, const u8 *p, size_t len,	\
 			      const void *consts_ptr);			\
 DEFINE_STATIC_CALL(prefix##_pclmul, prefix##_pclmul_sse)
 
 #define INIT_CRC_PCLMUL(prefix)						\
 do {									\
-	if (IS_ENABLED(CONFIG_AS_VPCLMULQDQ) &&				\
-	    boot_cpu_has(X86_FEATURE_VPCLMULQDQ) &&			\
+	if (boot_cpu_has(X86_FEATURE_VPCLMULQDQ) &&			\
 	    boot_cpu_has(X86_FEATURE_AVX2) &&				\
 	    cpu_has_xfeatures(XFEATURE_MASK_YMM, NULL)) {		\
 		if (boot_cpu_has(X86_FEATURE_AVX512BW) &&		\
 		    boot_cpu_has(X86_FEATURE_AVX512VL) &&		\
 		    !boot_cpu_has(X86_FEATURE_PREFER_YMM) &&		\
-- 
2.49.0

