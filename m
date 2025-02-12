Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67010208A7;
	Wed, 12 Feb 2025 04:49:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739335751; cv=none; b=bPq67FqzHtJkE50NCBFsS+OH3Vthff4JGcFbGfzEwmfm/6DXAPcG3jPJLJWXpx645D4HzIVHvU4nINg2dm6NyYlVSvUOFCHtI0nvcIsVP0t+SSZ30qblVENKO0SJjMdGsLKHbLIcNqfZ/VJKNnTikjAUzGcpkgOByWC6aR78kRU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739335751; c=relaxed/simple;
	bh=SZHbFT5hPcDSmpSzZXIPq92JgekFc7wyIuw+QzgaAJo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=a5aY15b/csWpEsumEMTzeHaOuv0Zdnedq5Sa1C88sXQ7a8+hK8l+a1mkvM56bGAO5ik8f/7NuSIV209gXr1FndaU5GK50NZ3dZc9nlXnOYjjWyurFTRhOpLv1Le3UH6hhIaxuLy0gTcrjPIwBWWwZy77sqTBcebtOIPjYVeNJuk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=jesQSFU5; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="jesQSFU5"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=q5G5BQZ/AdEoSNHs040ekLzH6kmkOaqYgMRUB269QUg=; b=jesQSFU5EzbhRAfZ5zYF7YSu6J
	QvsxSvRBdX8rjqU6mWBN3O8kQ8o/ExqO11DXK79XfntUUrV0COcMZJ5m5IwH6I3lMLytckw9pDhsy
	2gWRFdoZHTRYPpRhDPufZvSiDRv/+bkgSZB2WAAWs0ssBTNwCxEKjd92JdyFv5TwbpLEvQ4A78M40
	DK5UvKTRarZOQjmoa8zRipwrxyWrOWGY2FoBQaFeNIrbyP/TboQ/uMPQb0C96dqMNwTr7MjHDJ2Ko
	vLVOJJ+yVX9W2i+4JHBQO0K9jwtis8o+rJ+xoGaFTJX9e1hv6wr1eehvNblDmvIs3J7H/aUnVjzPQ
	XRZ/2jfw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1ti4TG-00HDt4-35;
	Wed, 12 Feb 2025 12:48:56 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 12 Feb 2025 12:48:55 +0800
Date: Wed, 12 Feb 2025 12:48:55 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: kernel test robot <lkp@intel.com>
Cc: Danny Tsen <dtsen@linux.ibm.com>, oe-kbuild-all@lists.linux.dev,
	linux-kernel@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: [PATCH] crypto: lib/Kconfig - Fix lib built-in failure when arch is
 modular
Message-ID: <Z6woN4vgdaywOZxm@gondor.apana.org.au>
References: <202501230223.ikroNDr1-lkp@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202501230223.ikroNDr1-lkp@intel.com>

On Thu, Jan 23, 2025 at 02:18:27AM +0800, kernel test robot wrote:
> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master
> head:   c4b9570cfb63501638db720f3bee9f6dfd044b82
> commit: b42519dbba838c928e82b55f32712fbe3eed2c45 crypto: ppc/curve25519 - Update Kconfig and Makefile for ppc64le
> date:   8 months ago
> config: powerpc64-randconfig-r111-20250122 (https://download.01.org/0day-ci/archive/20250123/202501230223.ikroNDr1-lkp@intel.com/config)
> compiler: clang version 15.0.7 (https://github.com/llvm/llvm-project 8dfdcc7b7bf66834a761bd8de445840ef68e4d1a)
> reproduce: (https://download.01.org/0day-ci/archive/20250123/202501230223.ikroNDr1-lkp@intel.com/reproduce)

Thanks for the report.  This is the old built-in vs. modular Kconfig
problem.  This patch should fix it:

---8<---
The HAVE_ARCH Kconfig options in lib/crypto try to solve the
modular versus built-in problem, but it still fails when the
the LIB option (e.g., CRYPTO_LIB_CURVE25519) is selected externally.

Fix this by introducing a level of indirection with ARCH_MAY_HAVE
Kconfig options, these then go on to select the ARCH_HAVE options
if the ARCH Kconfig options matches that of the LIB option.

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202501230223.ikroNDr1-lkp@intel.com/
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/arch/arm/crypto/Kconfig b/arch/arm/crypto/Kconfig
index 32650c8431d9..47d9cc59f254 100644
--- a/arch/arm/crypto/Kconfig
+++ b/arch/arm/crypto/Kconfig
@@ -6,7 +6,7 @@ config CRYPTO_CURVE25519_NEON
 	tristate "Public key crypto: Curve25519 (NEON)"
 	depends on KERNEL_MODE_NEON
 	select CRYPTO_LIB_CURVE25519_GENERIC
-	select CRYPTO_ARCH_HAVE_LIB_CURVE25519
+	select CRYPTO_ARCH_MAY_HAVE_LIB_CURVE25519
 	help
 	  Curve25519 algorithm
 
@@ -47,7 +47,7 @@ config CRYPTO_NHPOLY1305_NEON
 config CRYPTO_POLY1305_ARM
 	tristate "Hash functions: Poly1305 (NEON)"
 	select CRYPTO_HASH
-	select CRYPTO_ARCH_HAVE_LIB_POLY1305
+	select CRYPTO_ARCH_MAY_HAVE_LIB_POLY1305
 	help
 	  Poly1305 authenticator algorithm (RFC7539)
 
@@ -214,7 +214,7 @@ config CRYPTO_AES_ARM_CE
 config CRYPTO_CHACHA20_NEON
 	tristate "Ciphers: ChaCha20, XChaCha20, XChaCha12 (NEON)"
 	select CRYPTO_SKCIPHER
-	select CRYPTO_ARCH_HAVE_LIB_CHACHA
+	select CRYPTO_ARCH_MAY_HAVE_LIB_CHACHA
 	help
 	  Length-preserving ciphers: ChaCha20, XChaCha20, and XChaCha12
 	  stream cipher algorithms
diff --git a/arch/powerpc/crypto/Kconfig b/arch/powerpc/crypto/Kconfig
index 5b315e9756b3..e453cb0c82d2 100644
--- a/arch/powerpc/crypto/Kconfig
+++ b/arch/powerpc/crypto/Kconfig
@@ -6,7 +6,7 @@ config CRYPTO_CURVE25519_PPC64
 	tristate "Public key crypto: Curve25519 (PowerPC64)"
 	depends on PPC64 && CPU_LITTLE_ENDIAN
 	select CRYPTO_LIB_CURVE25519_GENERIC
-	select CRYPTO_ARCH_HAVE_LIB_CURVE25519
+	select CRYPTO_ARCH_MAY_HAVE_LIB_CURVE25519
 	help
 	  Curve25519 algorithm
 
@@ -95,7 +95,7 @@ config CRYPTO_CHACHA20_P10
 	depends on PPC64 && CPU_LITTLE_ENDIAN && VSX
 	select CRYPTO_SKCIPHER
 	select CRYPTO_LIB_CHACHA_GENERIC
-	select CRYPTO_ARCH_HAVE_LIB_CHACHA
+	select CRYPTO_ARCH_MAY_HAVE_LIB_CHACHA
 	help
 	  Length-preserving ciphers: ChaCha20, XChaCha20, and XChaCha12
 	  stream cipher algorithms
diff --git a/arch/x86/crypto/Kconfig b/arch/x86/crypto/Kconfig
index 4757bf922075..c189dad0969b 100644
--- a/arch/x86/crypto/Kconfig
+++ b/arch/x86/crypto/Kconfig
@@ -6,7 +6,7 @@ config CRYPTO_CURVE25519_X86
 	tristate "Public key crypto: Curve25519 (ADX)"
 	depends on X86 && 64BIT
 	select CRYPTO_LIB_CURVE25519_GENERIC
-	select CRYPTO_ARCH_HAVE_LIB_CURVE25519
+	select CRYPTO_ARCH_MAY_HAVE_LIB_CURVE25519
 	help
 	  Curve25519 algorithm
 
@@ -352,7 +352,7 @@ config CRYPTO_CHACHA20_X86_64
 	depends on X86 && 64BIT
 	select CRYPTO_SKCIPHER
 	select CRYPTO_LIB_CHACHA_GENERIC
-	select CRYPTO_ARCH_HAVE_LIB_CHACHA
+	select CRYPTO_ARCH_MAY_HAVE_LIB_CHACHA
 	help
 	  Length-preserving ciphers: ChaCha20, XChaCha20, and XChaCha12
 	  stream cipher algorithms
@@ -420,7 +420,7 @@ config CRYPTO_POLY1305_X86_64
 	tristate "Hash functions: Poly1305 (SSE2/AVX2)"
 	depends on X86 && 64BIT
 	select CRYPTO_LIB_POLY1305_GENERIC
-	select CRYPTO_ARCH_HAVE_LIB_POLY1305
+	select CRYPTO_ARCH_MAY_HAVE_LIB_POLY1305
 	help
 	  Poly1305 authenticator algorithm (RFC7539)
 
diff --git a/lib/crypto/Kconfig b/lib/crypto/Kconfig
index b01253cac70a..c542ef1d64d0 100644
--- a/lib/crypto/Kconfig
+++ b/lib/crypto/Kconfig
@@ -42,12 +42,17 @@ config CRYPTO_LIB_BLAKE2S_GENERIC
 	  of CRYPTO_LIB_BLAKE2S.
 
 config CRYPTO_ARCH_HAVE_LIB_CHACHA
-	tristate
+	bool
 	help
 	  Declares whether the architecture provides an arch-specific
 	  accelerated implementation of the ChaCha library interface,
 	  either builtin or as a module.
 
+config CRYPTO_ARCH_MAY_HAVE_LIB_CHACHA
+	tristate
+	select CRYPTO_ARCH_HAVE_LIB_CHACHA if CRYPTO_LIB_CHACHA=m
+	select CRYPTO_ARCH_HAVE_LIB_CHACHA if CRYPTO_ARCH_MAY_HAVE_LIB_CHACHA=y
+
 config CRYPTO_LIB_CHACHA_GENERIC
 	tristate
 	select CRYPTO_LIB_UTILS
@@ -60,7 +65,6 @@ config CRYPTO_LIB_CHACHA_GENERIC
 
 config CRYPTO_LIB_CHACHA
 	tristate "ChaCha library interface"
-	depends on CRYPTO_ARCH_HAVE_LIB_CHACHA || !CRYPTO_ARCH_HAVE_LIB_CHACHA
 	select CRYPTO_LIB_CHACHA_GENERIC if CRYPTO_ARCH_HAVE_LIB_CHACHA=n
 	help
 	  Enable the ChaCha library interface. This interface may be fulfilled
@@ -68,12 +72,17 @@ config CRYPTO_LIB_CHACHA
 	  is available and enabled.
 
 config CRYPTO_ARCH_HAVE_LIB_CURVE25519
-	tristate
+	bool
 	help
 	  Declares whether the architecture provides an arch-specific
 	  accelerated implementation of the Curve25519 library interface,
 	  either builtin or as a module.
 
+config CRYPTO_ARCH_MAY_HAVE_LIB_CURVE25519
+	tristate
+	select CRYPTO_ARCH_HAVE_LIB_CURVE25519 if CRYPTO_LIB_CURVE25519=m
+	select CRYPTO_ARCH_HAVE_LIB_CURVE25519 if CRYPTO_ARCH_MAY_HAVE_LIB_CURVE25519=y
+
 config CRYPTO_LIB_CURVE25519_GENERIC
 	tristate
 	help
@@ -85,7 +94,6 @@ config CRYPTO_LIB_CURVE25519_GENERIC
 
 config CRYPTO_LIB_CURVE25519
 	tristate "Curve25519 scalar multiplication library"
-	depends on CRYPTO_ARCH_HAVE_LIB_CURVE25519 || !CRYPTO_ARCH_HAVE_LIB_CURVE25519
 	select CRYPTO_LIB_CURVE25519_GENERIC if CRYPTO_ARCH_HAVE_LIB_CURVE25519=n
 	select CRYPTO_LIB_UTILS
 	help
@@ -104,12 +112,17 @@ config CRYPTO_LIB_POLY1305_RSIZE
 	default 1
 
 config CRYPTO_ARCH_HAVE_LIB_POLY1305
-	tristate
+	bool
 	help
 	  Declares whether the architecture provides an arch-specific
 	  accelerated implementation of the Poly1305 library interface,
 	  either builtin or as a module.
 
+config CRYPTO_ARCH_MAY_HAVE_LIB_POLY1305
+	tristate
+	select CRYPTO_ARCH_HAVE_LIB_POLY1305 if CRYPTO_LIB_POLY1305=m
+	select CRYPTO_ARCH_HAVE_LIB_POLY1305 if CRYPTO_ARCH_MAY_HAVE_LIB_POLY1305=y
+
 config CRYPTO_LIB_POLY1305_GENERIC
 	tristate
 	help
@@ -121,7 +134,6 @@ config CRYPTO_LIB_POLY1305_GENERIC
 
 config CRYPTO_LIB_POLY1305
 	tristate "Poly1305 library interface"
-	depends on CRYPTO_ARCH_HAVE_LIB_POLY1305 || !CRYPTO_ARCH_HAVE_LIB_POLY1305
 	select CRYPTO_LIB_POLY1305_GENERIC if CRYPTO_ARCH_HAVE_LIB_POLY1305=n
 	help
 	  Enable the Poly1305 library interface. This interface may be fulfilled
@@ -130,8 +142,6 @@ config CRYPTO_LIB_POLY1305
 
 config CRYPTO_LIB_CHACHA20POLY1305
 	tristate "ChaCha20-Poly1305 AEAD support (8-byte nonce library version)"
-	depends on CRYPTO_ARCH_HAVE_LIB_CHACHA || !CRYPTO_ARCH_HAVE_LIB_CHACHA
-	depends on CRYPTO_ARCH_HAVE_LIB_POLY1305 || !CRYPTO_ARCH_HAVE_LIB_POLY1305
 	depends on CRYPTO
 	select CRYPTO_LIB_CHACHA
 	select CRYPTO_LIB_POLY1305
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
