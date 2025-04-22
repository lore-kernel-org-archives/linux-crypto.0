Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3AD928FFC9;
	Tue, 22 Apr 2025 15:22:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745335336; cv=none; b=KayjllTCcufu9VeVtX6JLC7seD5rNztLMpXLWkijJ4qxzpJM4EiVJbxNiZ9aMzdsdT32LCog5qrZR0tkvASQY+dMrc3cGvT6D+7rSaz+a7tIKPfSD4b+uXVIW74MSrsWA35mWzxPEtMx3Rv4+guByFHxzdyS2QWW7WWkEENQof8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745335336; c=relaxed/simple;
	bh=ftG3d/GhEipalYeGsaxKYyy2uEs18NPHF363Hz446Ns=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=udiB7xDAomM4BDfDcJZ97sMwcS3F59UVkOqDjLKy1DhtP4f0TPOzcSL53jaXzAx/dF7lHhY3WtUralVJoiaImMbT2giExykXoTDSwEyYJ16Vo17vCI5jNSVa9yZrJMDh8cbSkm78sdYyQAmND6aMVVMouGcqA/cVWF/ppmOAwKY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Pmye+4NG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Pmye+4NG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E0CBC4CEEC;
	Tue, 22 Apr 2025 15:22:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745335335;
	bh=ftG3d/GhEipalYeGsaxKYyy2uEs18NPHF363Hz446Ns=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Pmye+4NGXWuzdiSJvLs1E7uq9Ap/HkPUO+1j5N+6KDiQOi7WyPMAUN4kZSBVNTysd
	 BTS1uw9o+GNMfZnVe/Qa7wSXOvpou3BzmRgdeDVNEW2utv/aI7PFH6BqtuLbeJWtGf
	 LvS+ipOL+wQbkHwJ7JX617s81bP/NP7iKXU+K3KfkRyO+H9ZSzSZsd2LNvbVsgByp0
	 A3Cmvx6/PJjNExvUBcWaF8HitWHmorMsbjujgJfH2H80QML/G7oRSUmRPmeQJY840u
	 N1M5qE10Ueun5FrnammuiOhthVwYg0CaTOwrJU/qe6wArXPQClaPl5Y1veQjJP+34M
	 I/kzc5R1KFi7w==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/9] crypto: tcrypt - remove CRYPTO_TEST from defconfigs
Date: Tue, 22 Apr 2025 08:21:43 -0700
Message-ID: <20250422152151.3691-2-ebiggers@kernel.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250422152151.3691-1-ebiggers@kernel.org>
References: <20250422152151.3691-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Eric Biggers <ebiggers@google.com>

CONFIG_CRYPTO_TEST enables a benchmarking module that is only really
useful for developers working on the crypto subsystem.  It is in a bunch
of defconfigs.  But as with most of the other crypto options that tend
to be randomly set in defconfigs, it is unlikely that much thought was
put into these, especially when placed in "production" defconfigs.
Clear it out of the defconfigs for now.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 arch/arm/configs/exynos_defconfig           | 1 -
 arch/arm/configs/pxa_defconfig              | 1 -
 arch/arm/configs/spitz_defconfig            | 1 -
 arch/arm64/configs/defconfig                | 1 -
 arch/m68k/configs/amiga_defconfig           | 1 -
 arch/m68k/configs/apollo_defconfig          | 1 -
 arch/m68k/configs/atari_defconfig           | 1 -
 arch/m68k/configs/bvme6000_defconfig        | 1 -
 arch/m68k/configs/hp300_defconfig           | 1 -
 arch/m68k/configs/mac_defconfig             | 1 -
 arch/m68k/configs/multi_defconfig           | 1 -
 arch/m68k/configs/mvme147_defconfig         | 1 -
 arch/m68k/configs/mvme16x_defconfig         | 1 -
 arch/m68k/configs/q40_defconfig             | 1 -
 arch/m68k/configs/sun3_defconfig            | 1 -
 arch/m68k/configs/sun3x_defconfig           | 1 -
 arch/mips/configs/gpr_defconfig             | 1 -
 arch/mips/configs/lemote2f_defconfig        | 1 -
 arch/mips/configs/mtx1_defconfig            | 1 -
 arch/mips/configs/rb532_defconfig           | 1 -
 arch/parisc/configs/generic-32bit_defconfig | 1 -
 arch/powerpc/configs/g5_defconfig           | 1 -
 arch/powerpc/configs/powernv_defconfig      | 1 -
 arch/powerpc/configs/ppc64_defconfig        | 1 -
 arch/powerpc/configs/ppc64e_defconfig       | 1 -
 arch/powerpc/configs/ppc6xx_defconfig       | 1 -
 arch/s390/configs/debug_defconfig           | 1 -
 arch/s390/configs/defconfig                 | 1 -
 arch/sparc/configs/sparc64_defconfig        | 1 -
 29 files changed, 29 deletions(-)

diff --git a/arch/arm/configs/exynos_defconfig b/arch/arm/configs/exynos_defconfig
index 7ad48fdda1dac..b8e2267f68cc8 100644
--- a/arch/arm/configs/exynos_defconfig
+++ b/arch/arm/configs/exynos_defconfig
@@ -347,11 +347,10 @@ CONFIG_ROOT_NFS=y
 CONFIG_NLS_CODEPAGE_437=y
 CONFIG_NLS_ASCII=y
 CONFIG_NLS_ISO8859_1=y
 CONFIG_NLS_UTF8=y
 CONFIG_CRYPTO_USER=m
-CONFIG_CRYPTO_TEST=m
 CONFIG_CRYPTO_DH=m
 CONFIG_CRYPTO_LRW=m
 CONFIG_CRYPTO_XTS=m
 CONFIG_CRYPTO_MD5=m
 CONFIG_CRYPTO_SHA512=m
diff --git a/arch/arm/configs/pxa_defconfig b/arch/arm/configs/pxa_defconfig
index de0ac8f521d76..821c670dd6877 100644
--- a/arch/arm/configs/pxa_defconfig
+++ b/arch/arm/configs/pxa_defconfig
@@ -637,11 +637,10 @@ CONFIG_NLS_UTF8=m
 CONFIG_TIMER_STATS=y
 CONFIG_SECURITY=y
 CONFIG_CRYPTO_MANAGER=y
 CONFIG_CRYPTO_CRYPTD=m
 CONFIG_CRYPTO_AUTHENC=m
-CONFIG_CRYPTO_TEST=m
 CONFIG_CRYPTO_BLOWFISH=m
 CONFIG_CRYPTO_CAST5=m
 CONFIG_CRYPTO_CAST6=m
 CONFIG_CRYPTO_FCRYPT=m
 CONFIG_CRYPTO_KHAZAD=m
diff --git a/arch/arm/configs/spitz_defconfig b/arch/arm/configs/spitz_defconfig
index ac5b7a5aaff68..1013c58d27ee5 100644
--- a/arch/arm/configs/spitz_defconfig
+++ b/arch/arm/configs/spitz_defconfig
@@ -213,11 +213,10 @@ CONFIG_NLS_DEFAULT="cp437"
 CONFIG_NLS_CODEPAGE_437=y
 CONFIG_NLS_ISO8859_1=y
 CONFIG_NLS_UTF8=y
 CONFIG_DEBUG_KERNEL=y
 CONFIG_CRYPTO_NULL=m
-CONFIG_CRYPTO_TEST=m
 CONFIG_CRYPTO_ECB=m
 CONFIG_CRYPTO_SHA256=m
 CONFIG_CRYPTO_AES=m
 CONFIG_CRYPTO_ANUBIS=m
 CONFIG_CRYPTO_ARC4=m
diff --git a/arch/arm64/configs/defconfig b/arch/arm64/configs/defconfig
index 5bb8f09422a22..72e6cd8b6c81a 100644
--- a/arch/arm64/configs/defconfig
+++ b/arch/arm64/configs/defconfig
@@ -1727,11 +1727,10 @@ CONFIG_ROOT_NFS=y
 CONFIG_9P_FS=y
 CONFIG_NLS_CODEPAGE_437=y
 CONFIG_NLS_ISO8859_1=y
 CONFIG_SECURITY=y
 CONFIG_CRYPTO_USER=y
-CONFIG_CRYPTO_TEST=m
 CONFIG_CRYPTO_ECHAINIV=y
 CONFIG_CRYPTO_MICHAEL_MIC=m
 CONFIG_CRYPTO_ANSI_CPRNG=y
 CONFIG_CRYPTO_USER_API_RNG=m
 CONFIG_CRYPTO_CHACHA20_NEON=m
diff --git a/arch/m68k/configs/amiga_defconfig b/arch/m68k/configs/amiga_defconfig
index 31ecb8b7b9f1e..2f9770cf6760d 100644
--- a/arch/m68k/configs/amiga_defconfig
+++ b/arch/m68k/configs/amiga_defconfig
@@ -549,11 +549,10 @@ CONFIG_NLS_MAC_TURKISH=m
 CONFIG_DLM=m
 CONFIG_ENCRYPTED_KEYS=m
 CONFIG_HARDENED_USERCOPY=y
 CONFIG_CRYPTO_USER=m
 CONFIG_CRYPTO_CRYPTD=m
-CONFIG_CRYPTO_TEST=m
 CONFIG_CRYPTO_RSA=m
 CONFIG_CRYPTO_DH=m
 CONFIG_CRYPTO_ECDH=m
 CONFIG_CRYPTO_ECDSA=m
 CONFIG_CRYPTO_ECRDSA=m
diff --git a/arch/m68k/configs/apollo_defconfig b/arch/m68k/configs/apollo_defconfig
index 1f57514624d51..91de4c6aecb99 100644
--- a/arch/m68k/configs/apollo_defconfig
+++ b/arch/m68k/configs/apollo_defconfig
@@ -506,11 +506,10 @@ CONFIG_NLS_MAC_TURKISH=m
 CONFIG_DLM=m
 CONFIG_ENCRYPTED_KEYS=m
 CONFIG_HARDENED_USERCOPY=y
 CONFIG_CRYPTO_USER=m
 CONFIG_CRYPTO_CRYPTD=m
-CONFIG_CRYPTO_TEST=m
 CONFIG_CRYPTO_RSA=m
 CONFIG_CRYPTO_DH=m
 CONFIG_CRYPTO_ECDH=m
 CONFIG_CRYPTO_ECDSA=m
 CONFIG_CRYPTO_ECRDSA=m
diff --git a/arch/m68k/configs/atari_defconfig b/arch/m68k/configs/atari_defconfig
index 02db7a48e57e7..561613c107447 100644
--- a/arch/m68k/configs/atari_defconfig
+++ b/arch/m68k/configs/atari_defconfig
@@ -526,11 +526,10 @@ CONFIG_NLS_MAC_TURKISH=m
 CONFIG_DLM=m
 CONFIG_ENCRYPTED_KEYS=m
 CONFIG_HARDENED_USERCOPY=y
 CONFIG_CRYPTO_USER=m
 CONFIG_CRYPTO_CRYPTD=m
-CONFIG_CRYPTO_TEST=m
 CONFIG_CRYPTO_RSA=m
 CONFIG_CRYPTO_DH=m
 CONFIG_CRYPTO_ECDH=m
 CONFIG_CRYPTO_ECDSA=m
 CONFIG_CRYPTO_ECRDSA=m
diff --git a/arch/m68k/configs/bvme6000_defconfig b/arch/m68k/configs/bvme6000_defconfig
index f0e673cb17eb7..ed37e5aa00456 100644
--- a/arch/m68k/configs/bvme6000_defconfig
+++ b/arch/m68k/configs/bvme6000_defconfig
@@ -498,11 +498,10 @@ CONFIG_NLS_MAC_TURKISH=m
 CONFIG_DLM=m
 CONFIG_ENCRYPTED_KEYS=m
 CONFIG_HARDENED_USERCOPY=y
 CONFIG_CRYPTO_USER=m
 CONFIG_CRYPTO_CRYPTD=m
-CONFIG_CRYPTO_TEST=m
 CONFIG_CRYPTO_RSA=m
 CONFIG_CRYPTO_DH=m
 CONFIG_CRYPTO_ECDH=m
 CONFIG_CRYPTO_ECDSA=m
 CONFIG_CRYPTO_ECRDSA=m
diff --git a/arch/m68k/configs/hp300_defconfig b/arch/m68k/configs/hp300_defconfig
index e8ca5a50b86da..0307583dc4a86 100644
--- a/arch/m68k/configs/hp300_defconfig
+++ b/arch/m68k/configs/hp300_defconfig
@@ -508,11 +508,10 @@ CONFIG_NLS_MAC_TURKISH=m
 CONFIG_DLM=m
 CONFIG_ENCRYPTED_KEYS=m
 CONFIG_HARDENED_USERCOPY=y
 CONFIG_CRYPTO_USER=m
 CONFIG_CRYPTO_CRYPTD=m
-CONFIG_CRYPTO_TEST=m
 CONFIG_CRYPTO_RSA=m
 CONFIG_CRYPTO_DH=m
 CONFIG_CRYPTO_ECDH=m
 CONFIG_CRYPTO_ECDSA=m
 CONFIG_CRYPTO_ECRDSA=m
diff --git a/arch/m68k/configs/mac_defconfig b/arch/m68k/configs/mac_defconfig
index b3a270441bb17..83c94360c1515 100644
--- a/arch/m68k/configs/mac_defconfig
+++ b/arch/m68k/configs/mac_defconfig
@@ -525,11 +525,10 @@ CONFIG_NLS_MAC_TURKISH=m
 CONFIG_DLM=m
 CONFIG_ENCRYPTED_KEYS=m
 CONFIG_HARDENED_USERCOPY=y
 CONFIG_CRYPTO_USER=m
 CONFIG_CRYPTO_CRYPTD=m
-CONFIG_CRYPTO_TEST=m
 CONFIG_CRYPTO_RSA=m
 CONFIG_CRYPTO_DH=m
 CONFIG_CRYPTO_ECDH=m
 CONFIG_CRYPTO_ECDSA=m
 CONFIG_CRYPTO_ECRDSA=m
diff --git a/arch/m68k/configs/multi_defconfig b/arch/m68k/configs/multi_defconfig
index d215dba006ced..2be267f10b927 100644
--- a/arch/m68k/configs/multi_defconfig
+++ b/arch/m68k/configs/multi_defconfig
@@ -612,11 +612,10 @@ CONFIG_NLS_MAC_TURKISH=m
 CONFIG_DLM=m
 CONFIG_ENCRYPTED_KEYS=m
 CONFIG_HARDENED_USERCOPY=y
 CONFIG_CRYPTO_USER=m
 CONFIG_CRYPTO_CRYPTD=m
-CONFIG_CRYPTO_TEST=m
 CONFIG_CRYPTO_RSA=m
 CONFIG_CRYPTO_DH=m
 CONFIG_CRYPTO_ECDH=m
 CONFIG_CRYPTO_ECDSA=m
 CONFIG_CRYPTO_ECRDSA=m
diff --git a/arch/m68k/configs/mvme147_defconfig b/arch/m68k/configs/mvme147_defconfig
index a888ed93ff829..9828470a9caf9 100644
--- a/arch/m68k/configs/mvme147_defconfig
+++ b/arch/m68k/configs/mvme147_defconfig
@@ -498,11 +498,10 @@ CONFIG_NLS_MAC_TURKISH=m
 CONFIG_DLM=m
 CONFIG_ENCRYPTED_KEYS=m
 CONFIG_HARDENED_USERCOPY=y
 CONFIG_CRYPTO_USER=m
 CONFIG_CRYPTO_CRYPTD=m
-CONFIG_CRYPTO_TEST=m
 CONFIG_CRYPTO_RSA=m
 CONFIG_CRYPTO_DH=m
 CONFIG_CRYPTO_ECDH=m
 CONFIG_CRYPTO_ECDSA=m
 CONFIG_CRYPTO_ECRDSA=m
diff --git a/arch/m68k/configs/mvme16x_defconfig b/arch/m68k/configs/mvme16x_defconfig
index b481782375f68..8cc6811aad14a 100644
--- a/arch/m68k/configs/mvme16x_defconfig
+++ b/arch/m68k/configs/mvme16x_defconfig
@@ -499,11 +499,10 @@ CONFIG_NLS_MAC_TURKISH=m
 CONFIG_DLM=m
 CONFIG_ENCRYPTED_KEYS=m
 CONFIG_HARDENED_USERCOPY=y
 CONFIG_CRYPTO_USER=m
 CONFIG_CRYPTO_CRYPTD=m
-CONFIG_CRYPTO_TEST=m
 CONFIG_CRYPTO_RSA=m
 CONFIG_CRYPTO_DH=m
 CONFIG_CRYPTO_ECDH=m
 CONFIG_CRYPTO_ECDSA=m
 CONFIG_CRYPTO_ECRDSA=m
diff --git a/arch/m68k/configs/q40_defconfig b/arch/m68k/configs/q40_defconfig
index 6eba743d8eb5c..b1bda41516f6c 100644
--- a/arch/m68k/configs/q40_defconfig
+++ b/arch/m68k/configs/q40_defconfig
@@ -515,11 +515,10 @@ CONFIG_NLS_MAC_TURKISH=m
 CONFIG_DLM=m
 CONFIG_ENCRYPTED_KEYS=m
 CONFIG_HARDENED_USERCOPY=y
 CONFIG_CRYPTO_USER=m
 CONFIG_CRYPTO_CRYPTD=m
-CONFIG_CRYPTO_TEST=m
 CONFIG_CRYPTO_RSA=m
 CONFIG_CRYPTO_DH=m
 CONFIG_CRYPTO_ECDH=m
 CONFIG_CRYPTO_ECDSA=m
 CONFIG_CRYPTO_ECRDSA=m
diff --git a/arch/m68k/configs/sun3_defconfig b/arch/m68k/configs/sun3_defconfig
index 9bdbb418ffa88..7ec14bcfd626e 100644
--- a/arch/m68k/configs/sun3_defconfig
+++ b/arch/m68k/configs/sun3_defconfig
@@ -496,11 +496,10 @@ CONFIG_NLS_MAC_TURKISH=m
 CONFIG_DLM=m
 CONFIG_ENCRYPTED_KEYS=m
 CONFIG_HARDENED_USERCOPY=y
 CONFIG_CRYPTO_USER=m
 CONFIG_CRYPTO_CRYPTD=m
-CONFIG_CRYPTO_TEST=m
 CONFIG_CRYPTO_RSA=m
 CONFIG_CRYPTO_DH=m
 CONFIG_CRYPTO_ECDH=m
 CONFIG_CRYPTO_ECDSA=m
 CONFIG_CRYPTO_ECRDSA=m
diff --git a/arch/m68k/configs/sun3x_defconfig b/arch/m68k/configs/sun3x_defconfig
index e1cf20fa53431..e6f943d68959e 100644
--- a/arch/m68k/configs/sun3x_defconfig
+++ b/arch/m68k/configs/sun3x_defconfig
@@ -496,11 +496,10 @@ CONFIG_NLS_MAC_TURKISH=m
 CONFIG_DLM=m
 CONFIG_ENCRYPTED_KEYS=m
 CONFIG_HARDENED_USERCOPY=y
 CONFIG_CRYPTO_USER=m
 CONFIG_CRYPTO_CRYPTD=m
-CONFIG_CRYPTO_TEST=m
 CONFIG_CRYPTO_RSA=m
 CONFIG_CRYPTO_DH=m
 CONFIG_CRYPTO_ECDH=m
 CONFIG_CRYPTO_ECDSA=m
 CONFIG_CRYPTO_ECRDSA=m
diff --git a/arch/mips/configs/gpr_defconfig b/arch/mips/configs/gpr_defconfig
index 12f3eed8a9468..ec55b07e572a8 100644
--- a/arch/mips/configs/gpr_defconfig
+++ b/arch/mips/configs/gpr_defconfig
@@ -271,11 +271,10 @@ CONFIG_NFS_V4=y
 CONFIG_ROOT_NFS=y
 CONFIG_NLS_CODEPAGE_437=y
 CONFIG_NLS_CODEPAGE_850=y
 CONFIG_NLS_ISO8859_1=y
 CONFIG_CRYPTO_AUTHENC=m
-CONFIG_CRYPTO_TEST=m
 CONFIG_CRYPTO_PCBC=m
 CONFIG_CRYPTO_MD4=m
 CONFIG_CRYPTO_MICHAEL_MIC=m
 CONFIG_CRYPTO_SHA512=m
 CONFIG_CRYPTO_WP512=m
diff --git a/arch/mips/configs/lemote2f_defconfig b/arch/mips/configs/lemote2f_defconfig
index 71d6340497c96..af4e53da39f8a 100644
--- a/arch/mips/configs/lemote2f_defconfig
+++ b/arch/mips/configs/lemote2f_defconfig
@@ -295,11 +295,10 @@ CONFIG_NLS_ISO8859_14=m
 CONFIG_NLS_ISO8859_15=m
 CONFIG_NLS_KOI8_R=m
 CONFIG_NLS_KOI8_U=m
 CONFIG_NLS_UTF8=y
 CONFIG_CRYPTO_CRYPTD=m
-CONFIG_CRYPTO_TEST=m
 CONFIG_CRYPTO_BLOWFISH=m
 CONFIG_CRYPTO_CAMELLIA=m
 CONFIG_CRYPTO_CAST5=m
 CONFIG_CRYPTO_CAST6=m
 CONFIG_CRYPTO_FCRYPT=m
diff --git a/arch/mips/configs/mtx1_defconfig b/arch/mips/configs/mtx1_defconfig
index 06b7a0b97ecae..9ff468d7eba0d 100644
--- a/arch/mips/configs/mtx1_defconfig
+++ b/arch/mips/configs/mtx1_defconfig
@@ -660,11 +660,10 @@ CONFIG_NLS_ISO8859_13=m
 CONFIG_NLS_ISO8859_14=m
 CONFIG_NLS_ISO8859_15=m
 CONFIG_NLS_KOI8_R=m
 CONFIG_NLS_KOI8_U=m
 CONFIG_NLS_UTF8=m
-CONFIG_CRYPTO_TEST=m
 CONFIG_CRYPTO_PCBC=m
 CONFIG_CRYPTO_HMAC=y
 CONFIG_CRYPTO_MD5=y
 CONFIG_CRYPTO_MICHAEL_MIC=m
 CONFIG_CRYPTO_WP512=m
diff --git a/arch/mips/configs/rb532_defconfig b/arch/mips/configs/rb532_defconfig
index 0261969a6e45e..5c4befe1d8732 100644
--- a/arch/mips/configs/rb532_defconfig
+++ b/arch/mips/configs/rb532_defconfig
@@ -151,9 +151,8 @@ CONFIG_TMPFS=y
 CONFIG_CONFIGFS_FS=y
 CONFIG_JFFS2_FS=y
 CONFIG_JFFS2_SUMMARY=y
 CONFIG_JFFS2_COMPRESSION_OPTIONS=y
 CONFIG_SQUASHFS=y
-CONFIG_CRYPTO_TEST=m
 # CONFIG_CRYPTO_HW is not set
 CONFIG_CRC16=m
 CONFIG_STRIP_ASM_SYMS=y
diff --git a/arch/parisc/configs/generic-32bit_defconfig b/arch/parisc/configs/generic-32bit_defconfig
index f5fffc24c3bc5..0d4c4298bcc66 100644
--- a/arch/parisc/configs/generic-32bit_defconfig
+++ b/arch/parisc/configs/generic-32bit_defconfig
@@ -249,11 +249,10 @@ CONFIG_NFS_FS=m
 CONFIG_NFSD=m
 CONFIG_CIFS=m
 CONFIG_CIFS_XATTR=y
 CONFIG_CIFS_POSIX=y
 # CONFIG_CIFS_DEBUG is not set
-CONFIG_CRYPTO_TEST=m
 CONFIG_CRYPTO_BLOWFISH=m
 CONFIG_CRYPTO_CAST5=m
 CONFIG_CRYPTO_CAST6=m
 CONFIG_CRYPTO_DES=y
 CONFIG_CRYPTO_SERPENT=m
diff --git a/arch/powerpc/configs/g5_defconfig b/arch/powerpc/configs/g5_defconfig
index 9215bed532919..6ede430de615b 100644
--- a/arch/powerpc/configs/g5_defconfig
+++ b/arch/powerpc/configs/g5_defconfig
@@ -234,11 +234,10 @@ CONFIG_NLS_UTF8=y
 CONFIG_CRC_T10DIF=y
 CONFIG_MAGIC_SYSRQ=y
 CONFIG_DEBUG_KERNEL=y
 CONFIG_DEBUG_MUTEXES=y
 CONFIG_BOOTX_TEXT=y
-CONFIG_CRYPTO_TEST=m
 CONFIG_CRYPTO_PCBC=m
 CONFIG_CRYPTO_HMAC=y
 CONFIG_CRYPTO_MICHAEL_MIC=m
 CONFIG_CRYPTO_SHA512=m
 CONFIG_CRYPTO_WP512=m
diff --git a/arch/powerpc/configs/powernv_defconfig b/arch/powerpc/configs/powernv_defconfig
index 6b6d7467fecfd..258a1ceca006b 100644
--- a/arch/powerpc/configs/powernv_defconfig
+++ b/arch/powerpc/configs/powernv_defconfig
@@ -315,11 +315,10 @@ CONFIG_BLK_DEV_IO_TRACE=y
 CONFIG_PPC_EMULATED_STATS=y
 CONFIG_CODE_PATCHING_SELFTEST=y
 CONFIG_FTR_FIXUP_SELFTEST=y
 CONFIG_MSI_BITMAP_SELFTEST=y
 CONFIG_XMON=y
-CONFIG_CRYPTO_TEST=m
 CONFIG_CRYPTO_PCBC=m
 CONFIG_CRYPTO_HMAC=y
 CONFIG_CRYPTO_MD5_PPC=m
 CONFIG_CRYPTO_MICHAEL_MIC=m
 CONFIG_CRYPTO_SHA1_PPC=m
diff --git a/arch/powerpc/configs/ppc64_defconfig b/arch/powerpc/configs/ppc64_defconfig
index 5fa154185efa9..0474ee4b2f435 100644
--- a/arch/powerpc/configs/ppc64_defconfig
+++ b/arch/powerpc/configs/ppc64_defconfig
@@ -375,11 +375,10 @@ CONFIG_IMA_KEXEC=y
 CONFIG_IMA_DEFAULT_HASH_SHA256=y
 CONFIG_IMA_WRITE_POLICY=y
 CONFIG_IMA_APPRAISE=y
 CONFIG_IMA_ARCH_POLICY=y
 CONFIG_IMA_APPRAISE_MODSIG=y
-CONFIG_CRYPTO_TEST=m
 CONFIG_CRYPTO_BLOWFISH=m
 CONFIG_CRYPTO_CAST6=m
 CONFIG_CRYPTO_SERPENT=m
 CONFIG_CRYPTO_TWOFISH=m
 CONFIG_CRYPTO_PCBC=m
diff --git a/arch/powerpc/configs/ppc64e_defconfig b/arch/powerpc/configs/ppc64e_defconfig
index 4c05f4e4d5056..54d68d0c7bb03 100644
--- a/arch/powerpc/configs/ppc64e_defconfig
+++ b/arch/powerpc/configs/ppc64e_defconfig
@@ -219,11 +219,10 @@ CONFIG_SCHED_TRACER=y
 CONFIG_BLK_DEV_IO_TRACE=y
 CONFIG_CODE_PATCHING_SELFTEST=y
 CONFIG_FTR_FIXUP_SELFTEST=y
 CONFIG_MSI_BITMAP_SELFTEST=y
 CONFIG_XMON=y
-CONFIG_CRYPTO_TEST=m
 CONFIG_CRYPTO_CCM=m
 CONFIG_CRYPTO_GCM=m
 CONFIG_CRYPTO_PCBC=m
 CONFIG_CRYPTO_HMAC=y
 CONFIG_CRYPTO_MICHAEL_MIC=m
diff --git a/arch/powerpc/configs/ppc6xx_defconfig b/arch/powerpc/configs/ppc6xx_defconfig
index a91a766b71a44..34e78ed557dfa 100644
--- a/arch/powerpc/configs/ppc6xx_defconfig
+++ b/arch/powerpc/configs/ppc6xx_defconfig
@@ -1071,11 +1071,10 @@ CONFIG_SECURITY=y
 CONFIG_SECURITY_NETWORK=y
 CONFIG_SECURITY_NETWORK_XFRM=y
 CONFIG_SECURITY_SELINUX=y
 CONFIG_SECURITY_SELINUX_BOOTPARAM=y
 CONFIG_SECURITY_SELINUX_DISABLE=y
-CONFIG_CRYPTO_TEST=m
 CONFIG_CRYPTO_CTS=m
 CONFIG_CRYPTO_LRW=m
 CONFIG_CRYPTO_PCBC=m
 CONFIG_CRYPTO_XTS=m
 CONFIG_CRYPTO_HMAC=y
diff --git a/arch/s390/configs/debug_defconfig b/arch/s390/configs/debug_defconfig
index 6f2c9ce1b1548..0216a6f508016 100644
--- a/arch/s390/configs/debug_defconfig
+++ b/arch/s390/configs/debug_defconfig
@@ -744,11 +744,10 @@ CONFIG_IMA_APPRAISE=y
 CONFIG_BUG_ON_DATA_CORRUPTION=y
 CONFIG_CRYPTO_USER=m
 # CONFIG_CRYPTO_MANAGER_DISABLE_TESTS is not set
 CONFIG_CRYPTO_PCRYPT=m
 CONFIG_CRYPTO_CRYPTD=m
-CONFIG_CRYPTO_TEST=m
 CONFIG_CRYPTO_DH=m
 CONFIG_CRYPTO_ECDH=m
 CONFIG_CRYPTO_ECDSA=m
 CONFIG_CRYPTO_ECRDSA=m
 CONFIG_CRYPTO_CURVE25519=m
diff --git a/arch/s390/configs/defconfig b/arch/s390/configs/defconfig
index f18a7d97ac216..c0528f791ecf9 100644
--- a/arch/s390/configs/defconfig
+++ b/arch/s390/configs/defconfig
@@ -730,11 +730,10 @@ CONFIG_BUG_ON_DATA_CORRUPTION=y
 CONFIG_CRYPTO_FIPS=y
 CONFIG_CRYPTO_USER=m
 # CONFIG_CRYPTO_MANAGER_DISABLE_TESTS is not set
 CONFIG_CRYPTO_PCRYPT=m
 CONFIG_CRYPTO_CRYPTD=m
-CONFIG_CRYPTO_TEST=m
 CONFIG_CRYPTO_DH=m
 CONFIG_CRYPTO_ECDH=m
 CONFIG_CRYPTO_ECDSA=m
 CONFIG_CRYPTO_ECRDSA=m
 CONFIG_CRYPTO_CURVE25519=m
diff --git a/arch/sparc/configs/sparc64_defconfig b/arch/sparc/configs/sparc64_defconfig
index 01b2bdfbf9a89..f1f68e43616b3 100644
--- a/arch/sparc/configs/sparc64_defconfig
+++ b/arch/sparc/configs/sparc64_defconfig
@@ -203,11 +203,10 @@ CONFIG_DETECT_HUNG_TASK=y
 CONFIG_SCHEDSTATS=y
 CONFIG_BLK_DEV_IO_TRACE=y
 CONFIG_UPROBE_EVENTS=y
 CONFIG_KEYS=y
 CONFIG_CRYPTO_NULL=m
-CONFIG_CRYPTO_TEST=m
 CONFIG_CRYPTO_LRW=m
 CONFIG_CRYPTO_PCBC=m
 CONFIG_CRYPTO_XTS=m
 CONFIG_CRYPTO_XCBC=y
 CONFIG_CRYPTO_MD4=y
-- 
2.49.0

