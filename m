Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C83A361974;
	Mon, 21 Sep 2026 05:16:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789967771; cv=none; b=eMbrUSip1oC+dD5y0ZayXVKAYn45LTSjLUr0hCFKpiHelE3wpvdwR+nNpQGb5guLDJ/fW0Sk6f5/w7XAxIYrJjQZjT9j2Bx1kKwJqZZLava339cmEEcUATU2J/XvgHLpyKjGozuiw5fRdvTHBMVakglEV2BHnWXflJbmkm3DLio=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789967771; c=relaxed/simple;
	bh=WdbOpTBnvX7IHZKY62+X8zA8hprUTgiUDovCozc88kc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A+hyTrBlxN+emXyiCB7rAyKwEk7bMO7hzOq7ygvecw+Bjnt3sTf54zGmzVrj2JkTYTYpd44OXUwNU7YsO750ED0VRPsXLZgS01ErCaC48tH2j4uxbWg+nV/xHcqkeHoarMIP+NWfibk2pHGNHQCQAl6harXsWL3kqw2TUPAVrV8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fjHkWEA4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fjHkWEA4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F3E41F0089A;
	Mon, 21 Sep 2026 05:16:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789967768;
	bh=ShajkHyOS9HMwDyE76SdTvTXI8joKtZkz+CVThGSWQU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fjHkWEA4BZBbPqGzXi1TJZSClKpl6a65mrBbJTmF+VOnXn5aEGgQKQ/HW2uJHhpmG
	 BtiIA96RqU4///rnVGYJafW6DLvTLH7zPcLA4BDb+zYe0Mwveu6rsMlXkhDdQfCPXN
	 FoVZYdChexVqEBAZKHiW6W9BCO7OmFKknPcrEc6akWD79BDPR8YLkWtKGG9PGSnJ0r
	 Q8ZpsgXs0sXi9sG+o+odO1i1p1oUA6/QVVTy//PbnBg+V7h+m5MnzrbTfmBArgpEgk
	 0slDqZ6sXwddif5zidaU2gRLhX2SYDH1uliZgVdREfZFSz8rVRZyOajTECs2hps348
	 1RYpFF85sWxPg==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	x86@kernel.org,
	linux-riscv@lists.infradead.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 14/20] crypto: x86/aes - Drop superseded 32-bit build support
Date: Sun, 20 Sep 2026 22:09:00 -0700
Message-ID: <20260921050910.296144-15-ebiggers@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260921050910.296144-1-ebiggers@kernel.org>
References: <20260921050910.296144-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Now that the AES-NI and/or VAES accelerated implementations of AES-ECB,
AES-CBC, AES-CBC-CTS, AES-CTR, AES-XCTR, and AES-XTS have been migrated
into the "libaes" module in lib/crypto/ and enabled by default when the
corresponding non-arch-specific options (e.g. CRYPTO_XTS) are enabled,
the traditional "aesni-intel" module only has AES-GCM left.

That functionality is 64-bit only.  Therefore, aesni-intel no longer has
any functionality on 32-bit.  Stop building it on 32-bit.

Also update the help text to mention the generic options.

To be clear: AES-NI accelerated AES-ECB, AES-CBC, AES-CBC-CTS, and
AES-XTS remain fully supported in 32-bit x86 kernels via libaes.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 arch/x86/crypto/Kconfig            |  7 ++++---
 arch/x86/crypto/Makefile           |  6 ++----
 arch/x86/crypto/aesni-intel_glue.c | 14 --------------
 3 files changed, 6 insertions(+), 21 deletions(-)

diff --git a/arch/x86/crypto/Kconfig b/arch/x86/crypto/Kconfig
index d68b31fad508..9cb5176931aa 100644
--- a/arch/x86/crypto/Kconfig
+++ b/arch/x86/crypto/Kconfig
@@ -4,18 +4,19 @@ menu "Accelerated Cryptographic Algorithms for CPU (x86)"
 
 config CRYPTO_AES_NI_INTEL
 	tristate "Ciphers: AES, modes: GCM (AES-NI/VAES)"
+	depends on 64BIT
 	select CRYPTO_AEAD
 	select CRYPTO_LIB_AES
 	select CRYPTO_LIB_GF128MUL
 	help
 	  AEAD cipher: AES with GCM
 
-	  Architecture: x86 (32-bit and 64-bit) using:
+	  Architecture: x86_64 using:
 	  - AES-NI (AES new instructions)
 	  - VAES (Vector AES)
 
-	  Some algorithm implementations are supported only in 64-bit builds,
-	  and some have additional prerequisites such as AVX2 or AVX512.
+	  Note: this option no longer provides the accelerated XTS, CBC, CTR,
+	  and ECB code.  For those just use CRYPTO_XTS, CRYPTO_CBC, etc.
 
 config CRYPTO_BLOWFISH_X86_64
 	tristate "Ciphers: Blowfish, modes: ECB, CBC"
diff --git a/arch/x86/crypto/Makefile b/arch/x86/crypto/Makefile
index e05d6e2257d4..aba817fe64f5 100644
--- a/arch/x86/crypto/Makefile
+++ b/arch/x86/crypto/Makefile
@@ -40,10 +40,8 @@ obj-$(CONFIG_CRYPTO_AEGIS128_AESNI_SSE2) += aegis128-aesni.o
 aegis128-aesni-y := aegis128-aesni-asm.o aegis128-aesni-glue.o
 
 obj-$(CONFIG_CRYPTO_AES_NI_INTEL) += aesni-intel.o
-aesni-intel-y := aesni-intel_glue.o
-aesni-intel-$(CONFIG_64BIT) += aes-gcm-aesni-x86_64.o \
-			       aes-gcm-vaes-avx2.o \
-			       aes-gcm-vaes-avx512.o
+aesni-intel-y := aesni-intel_glue.o aes-gcm-aesni-x86_64.o \
+		 aes-gcm-vaes-avx2.o aes-gcm-vaes-avx512.o
 
 obj-$(CONFIG_CRYPTO_SM4_AESNI_AVX_X86_64) += sm4-aesni-avx-x86_64.o
 sm4-aesni-avx-x86_64-y := sm4-aesni-avx-asm_64.o sm4_aesni_avx_glue.o
diff --git a/arch/x86/crypto/aesni-intel_glue.c b/arch/x86/crypto/aesni-intel_glue.c
index 3f86c8997d7d..af52c442361f 100644
--- a/arch/x86/crypto/aesni-intel_glue.c
+++ b/arch/x86/crypto/aesni-intel_glue.c
@@ -37,8 +37,6 @@
 #include <linux/spinlock.h>
 #include <linux/static_call.h>
 
-#ifdef CONFIG_X86_64
-
 /* The common part of the x86_64 AES-GCM key struct */
 struct aes_gcm_key {
 	/* Expanded AES key and the AES key length in bytes */
@@ -845,18 +843,6 @@ static void unregister_avx_algs(void)
 	unregister_aeads(aes_gcm_algs_vaes_avx2);
 	unregister_aeads(aes_gcm_algs_vaes_avx512);
 }
-#else /* CONFIG_X86_64 */
-static struct aead_alg aes_gcm_algs_aesni[0];
-
-static int __init register_avx_algs(void)
-{
-	return 0;
-}
-
-static void unregister_avx_algs(void)
-{
-}
-#endif /* !CONFIG_X86_64 */
 
 static const struct x86_cpu_id aesni_cpu_id[] = {
 	X86_MATCH_FEATURE(X86_FEATURE_AES, NULL),
-- 
2.55.0

