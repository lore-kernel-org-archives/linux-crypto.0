Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C6876BFC0;
	Sat, 19 Apr 2025 16:17:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745079453; cv=none; b=XoilOAsbpVnmac0E8+2xG3BPwmkwCsJZQ/FyID0RPoqKMmUb4ZRykHpUiO2Pj4E2dxgMxJwCN536BLQU73zTz5prFL7qTHVW1RxSKE4ziD6byr8zp1lT8joDwEudIPAuZS27EXipt0d0cUO5zzvf7a4uK/z77Di4YhLRgiXuoqM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745079453; c=relaxed/simple;
	bh=nww4iDqCd5K43fJVUdqt607LG+PEqEZdkJi0yiS6zYI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QEx/CIM4AkfRJ+Zzj1UcaUIt9qoi5SzddI/d3u8nqZBk7ZVDqTsrbqlhz1wRIVvW/LDSEL10Gng9BLQJti12/Le+IhY2z1BPwTyPH2DhF7F0LX7AhoYlTgz8BZCRC3B7GTYCTY0aRFjcemL7L1vGQrKKsRwCtYcg+swaIIcNSe8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PuQLsiP/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PuQLsiP/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9A0EC4CEEC;
	Sat, 19 Apr 2025 16:17:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745079453;
	bh=nww4iDqCd5K43fJVUdqt607LG+PEqEZdkJi0yiS6zYI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PuQLsiP/bt3je2ckVF/UE/oZgcMoakW6hvWjT4a/7hJdhufntVaxqnqxbzd5/zEbU
	 9HIMfr7wHJ2ZnIDpmBNsJxxJyS9l/blM1Z0BsEg7zr0wdzpTw8JEmLMLt9eSquZMzu
	 y5swK+qP34ZQl4adgWqKg0h5ITvuUiPdcga+KpRb/MD/GXEPKky2HaxlhJPXvcXjWo
	 NSOmp65kphCNRb0xc2q7iY6KlltIPtzbCpVFtwOuW18Yz/RaMs7ciVp7lE7iqmNq30
	 yf+K67KbcXVlK4C+XzVmHmilarJymoOiUGRyHS5w9yWgBt1JgquEW+OZGVsOHgxMKr
	 tgwb+xBrek1+A==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 1/9] crypto: tcrypt - remove CRYPTO_TEST from defconfigs
Date: Sat, 19 Apr 2025 09:15:35 -0700
Message-ID: <20250419161543.139344-2-ebiggers@kernel.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250419161543.139344-1-ebiggers@kernel.org>
References: <20250419161543.139344-1-ebiggers@kernel.org>
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
index 7ad48fdda1da..b8e2267f68cc 100644
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
index de0ac8f521d7..821c670dd687 100644
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
index ac5b7a5aaff6..1013c58d27ee 100644
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
index 5bb8f09422a2..72e6cd8b6c81 100644
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
index 31ecb8b7b9f1..2f9770cf6760 100644
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
index 1f57514624d5..91de4c6aecb9 100644
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
index 02db7a48e57e..561613c10744 100644
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
index f0e673cb17eb..ed37e5aa0045 100644
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
index e8ca5a50b86d..0307583dc4a8 100644
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
index b3a270441bb1..83c94360c151 100644
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
index d215dba006ce..2be267f10b92 100644
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
index a888ed93ff82..9828470a9caf 100644
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
index b481782375f6..8cc6811aad14 100644
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
index 6eba743d8eb5..b1bda41516f6 100644
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
index 9bdbb418ffa8..7ec14bcfd626 100644
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
index e1cf20fa5343..e6f943d68959 100644
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
index 12f3eed8a946..ec55b07e572a 100644
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
index 71d6340497c9..af4e53da39f8 100644
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
index 06b7a0b97eca..9ff468d7eba0 100644
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
index 0261969a6e45..5c4befe1d873 100644
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
index f5fffc24c3bc..0d4c4298bcc6 100644
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
index 9215bed53291..6ede430de615 100644
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
index 6b6d7467fecf..258a1ceca006 100644
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
index 5fa154185efa..0474ee4b2f43 100644
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
index 4c05f4e4d505..54d68d0c7bb0 100644
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
index a91a766b71a4..34e78ed557df 100644
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
index 6f2c9ce1b154..0216a6f50801 100644
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
index f18a7d97ac21..c0528f791ecf 100644
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
index 01b2bdfbf9a8..f1f68e43616b 100644
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

