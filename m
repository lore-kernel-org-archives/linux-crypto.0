Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 130B31487E1;
	Mon,  5 May 2025 20:37:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746477436; cv=none; b=KU0e/OexOX1gj8NJCzzlE/EM0D3dulzEFfFPHi1Ux0Sy5n6pTiwZYaaverbGRpqpzwN6Ev4DY/zdUzXm81g0Fq61XqqTlFUTwq2hfHnZ+BmrSEoBGikm0IF3uT+CFYz5SvXFmANZGqnWPBwYwJot4jNd4aN9ZxbdZAe3bFkyrCI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746477436; c=relaxed/simple;
	bh=RrlI2FX8ROpsE/Bz0ki1ZZnvibt9T/Hyiu2R7J6Oz9E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NNjoCru+wlK75Lkfrd+bHr+Mttcs71h+xnocmJiHKD9Zb3AT75H9LCVqfYEMH7LSEOSS8ScYhndL/dLGioXPJTiGH7NFRoNYvruE2dzzybpotFykVF2dRLEE0e6WjUxFkd1fTVv1Qt6WkfUJxHaZw2kiy3apXRZuCT+BLiL4OWc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DaY262NG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DaY262NG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73CB2C4CEEE;
	Mon,  5 May 2025 20:37:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746477435;
	bh=RrlI2FX8ROpsE/Bz0ki1ZZnvibt9T/Hyiu2R7J6Oz9E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DaY262NGIAhjH4MplBu3BILMeqTysaMAX5m4w/o6xOb1X0EVv99QPd2Ggu7ezcMWZ
	 m9VbYpQRLRsX/9Apg1gAZCzz3ztOgFGBg5VjC159ZKp5x222qoHVyNjrvtr2nARrTB
	 cNHBUeurY5kEZACTJAvdHul+2/KCuPV6m2/fAKbAk6cq1tOIh8mTWjZd658qMwQrBP
	 8lWIRvnMmviisx/JDef7eXUpAjY2S9m0wVU/fOqtEbCjU7oaio0xxPrvZO33pa6U4e
	 2LbIH7/ctH+vBHnzjJPP2+PgusopLblYmoImLerRC2t0GQVktAQYzBwJw2NLn854zl
	 IPiAJDmCP+WOA==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH v3 1/7] crypto: tcrypt - rename CRYPTO_TEST to CRYPTO_BENCHMARK
Date: Mon,  5 May 2025 13:33:39 -0700
Message-ID: <20250505203345.802740-2-ebiggers@kernel.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250505203345.802740-1-ebiggers@kernel.org>
References: <20250505203345.802740-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Eric Biggers <ebiggers@google.com>

tcrypt is actually a benchmarking module and not the actual tests.  This
regularly causes confusion.  Update the kconfig option name and help
text accordingly.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 arch/arm/configs/exynos_defconfig           |  2 +-
 arch/arm/configs/pxa_defconfig              |  2 +-
 arch/arm/configs/spitz_defconfig            |  2 +-
 arch/arm64/configs/defconfig                |  2 +-
 arch/m68k/configs/amiga_defconfig           |  2 +-
 arch/m68k/configs/apollo_defconfig          |  2 +-
 arch/m68k/configs/atari_defconfig           |  2 +-
 arch/m68k/configs/bvme6000_defconfig        |  2 +-
 arch/m68k/configs/hp300_defconfig           |  2 +-
 arch/m68k/configs/mac_defconfig             |  2 +-
 arch/m68k/configs/multi_defconfig           |  2 +-
 arch/m68k/configs/mvme147_defconfig         |  2 +-
 arch/m68k/configs/mvme16x_defconfig         |  2 +-
 arch/m68k/configs/q40_defconfig             |  2 +-
 arch/m68k/configs/sun3_defconfig            |  2 +-
 arch/m68k/configs/sun3x_defconfig           |  2 +-
 arch/mips/configs/gpr_defconfig             |  2 +-
 arch/mips/configs/lemote2f_defconfig        |  2 +-
 arch/mips/configs/mtx1_defconfig            |  2 +-
 arch/mips/configs/rb532_defconfig           |  2 +-
 arch/parisc/configs/generic-32bit_defconfig |  2 +-
 arch/powerpc/configs/g5_defconfig           |  2 +-
 arch/powerpc/configs/powernv_defconfig      |  2 +-
 arch/powerpc/configs/ppc64_defconfig        |  2 +-
 arch/powerpc/configs/ppc64e_defconfig       |  2 +-
 arch/powerpc/configs/ppc6xx_defconfig       |  2 +-
 arch/s390/configs/debug_defconfig           |  2 +-
 arch/s390/configs/defconfig                 |  2 +-
 arch/sparc/configs/sparc64_defconfig        |  2 +-
 crypto/Kconfig                              | 10 +++++++---
 crypto/Makefile                             |  2 +-
 crypto/tcrypt.c                             |  8 ++++----
 crypto/tcrypt.h                             |  4 ++--
 33 files changed, 43 insertions(+), 39 deletions(-)

diff --git a/arch/arm/configs/exynos_defconfig b/arch/arm/configs/exynos_defconfig
index c6792c0256a6..e81964cce516 100644
--- a/arch/arm/configs/exynos_defconfig
+++ b/arch/arm/configs/exynos_defconfig
@@ -347,11 +347,11 @@ CONFIG_ROOT_NFS=y
 CONFIG_NLS_CODEPAGE_437=y
 CONFIG_NLS_ASCII=y
 CONFIG_NLS_ISO8859_1=y
 CONFIG_NLS_UTF8=y
 CONFIG_CRYPTO_USER=m
-CONFIG_CRYPTO_TEST=m
+CONFIG_CRYPTO_BENCHMARK=m
 CONFIG_CRYPTO_DH=m
 CONFIG_CRYPTO_LRW=m
 CONFIG_CRYPTO_XTS=m
 CONFIG_CRYPTO_MD5=m
 CONFIG_CRYPTO_SHA512=m
diff --git a/arch/arm/configs/pxa_defconfig b/arch/arm/configs/pxa_defconfig
index 56be85752909..edc5b4d17f77 100644
--- a/arch/arm/configs/pxa_defconfig
+++ b/arch/arm/configs/pxa_defconfig
@@ -637,11 +637,11 @@ CONFIG_NLS_UTF8=m
 CONFIG_TIMER_STATS=y
 CONFIG_SECURITY=y
 CONFIG_CRYPTO_MANAGER=y
 CONFIG_CRYPTO_CRYPTD=m
 CONFIG_CRYPTO_AUTHENC=m
-CONFIG_CRYPTO_TEST=m
+CONFIG_CRYPTO_BENCHMARK=m
 CONFIG_CRYPTO_BLOWFISH=m
 CONFIG_CRYPTO_CAST5=m
 CONFIG_CRYPTO_CAST6=m
 CONFIG_CRYPTO_FCRYPT=m
 CONFIG_CRYPTO_KHAZAD=m
diff --git a/arch/arm/configs/spitz_defconfig b/arch/arm/configs/spitz_defconfig
index ffec59e3f49c..ac2a0f998c73 100644
--- a/arch/arm/configs/spitz_defconfig
+++ b/arch/arm/configs/spitz_defconfig
@@ -213,11 +213,11 @@ CONFIG_NLS_DEFAULT="cp437"
 CONFIG_NLS_CODEPAGE_437=y
 CONFIG_NLS_ISO8859_1=y
 CONFIG_NLS_UTF8=y
 CONFIG_DEBUG_KERNEL=y
 CONFIG_CRYPTO_NULL=m
-CONFIG_CRYPTO_TEST=m
+CONFIG_CRYPTO_BENCHMARK=m
 CONFIG_CRYPTO_ECB=m
 CONFIG_CRYPTO_SHA256=m
 CONFIG_CRYPTO_AES=m
 CONFIG_CRYPTO_ANUBIS=m
 CONFIG_CRYPTO_ARC4=m
diff --git a/arch/arm64/configs/defconfig b/arch/arm64/configs/defconfig
index b0d4c7d173ea..4166bc4d3cec 100644
--- a/arch/arm64/configs/defconfig
+++ b/arch/arm64/configs/defconfig
@@ -1727,11 +1727,11 @@ CONFIG_ROOT_NFS=y
 CONFIG_9P_FS=y
 CONFIG_NLS_CODEPAGE_437=y
 CONFIG_NLS_ISO8859_1=y
 CONFIG_SECURITY=y
 CONFIG_CRYPTO_USER=y
-CONFIG_CRYPTO_TEST=m
+CONFIG_CRYPTO_BENCHMARK=m
 CONFIG_CRYPTO_ECHAINIV=y
 CONFIG_CRYPTO_MICHAEL_MIC=m
 CONFIG_CRYPTO_ANSI_CPRNG=y
 CONFIG_CRYPTO_USER_API_RNG=m
 CONFIG_CRYPTO_CHACHA20_NEON=m
diff --git a/arch/m68k/configs/amiga_defconfig b/arch/m68k/configs/amiga_defconfig
index 31ecb8b7b9f1..77f78d326a32 100644
--- a/arch/m68k/configs/amiga_defconfig
+++ b/arch/m68k/configs/amiga_defconfig
@@ -549,11 +549,11 @@ CONFIG_NLS_MAC_TURKISH=m
 CONFIG_DLM=m
 CONFIG_ENCRYPTED_KEYS=m
 CONFIG_HARDENED_USERCOPY=y
 CONFIG_CRYPTO_USER=m
 CONFIG_CRYPTO_CRYPTD=m
-CONFIG_CRYPTO_TEST=m
+CONFIG_CRYPTO_BENCHMARK=m
 CONFIG_CRYPTO_RSA=m
 CONFIG_CRYPTO_DH=m
 CONFIG_CRYPTO_ECDH=m
 CONFIG_CRYPTO_ECDSA=m
 CONFIG_CRYPTO_ECRDSA=m
diff --git a/arch/m68k/configs/apollo_defconfig b/arch/m68k/configs/apollo_defconfig
index 1f57514624d5..f4031aa5d37f 100644
--- a/arch/m68k/configs/apollo_defconfig
+++ b/arch/m68k/configs/apollo_defconfig
@@ -506,11 +506,11 @@ CONFIG_NLS_MAC_TURKISH=m
 CONFIG_DLM=m
 CONFIG_ENCRYPTED_KEYS=m
 CONFIG_HARDENED_USERCOPY=y
 CONFIG_CRYPTO_USER=m
 CONFIG_CRYPTO_CRYPTD=m
-CONFIG_CRYPTO_TEST=m
+CONFIG_CRYPTO_BENCHMARK=m
 CONFIG_CRYPTO_RSA=m
 CONFIG_CRYPTO_DH=m
 CONFIG_CRYPTO_ECDH=m
 CONFIG_CRYPTO_ECDSA=m
 CONFIG_CRYPTO_ECRDSA=m
diff --git a/arch/m68k/configs/atari_defconfig b/arch/m68k/configs/atari_defconfig
index 02db7a48e57e..fa92131cf4b3 100644
--- a/arch/m68k/configs/atari_defconfig
+++ b/arch/m68k/configs/atari_defconfig
@@ -526,11 +526,11 @@ CONFIG_NLS_MAC_TURKISH=m
 CONFIG_DLM=m
 CONFIG_ENCRYPTED_KEYS=m
 CONFIG_HARDENED_USERCOPY=y
 CONFIG_CRYPTO_USER=m
 CONFIG_CRYPTO_CRYPTD=m
-CONFIG_CRYPTO_TEST=m
+CONFIG_CRYPTO_BENCHMARK=m
 CONFIG_CRYPTO_RSA=m
 CONFIG_CRYPTO_DH=m
 CONFIG_CRYPTO_ECDH=m
 CONFIG_CRYPTO_ECDSA=m
 CONFIG_CRYPTO_ECRDSA=m
diff --git a/arch/m68k/configs/bvme6000_defconfig b/arch/m68k/configs/bvme6000_defconfig
index f0e673cb17eb..9c2afc477061 100644
--- a/arch/m68k/configs/bvme6000_defconfig
+++ b/arch/m68k/configs/bvme6000_defconfig
@@ -498,11 +498,11 @@ CONFIG_NLS_MAC_TURKISH=m
 CONFIG_DLM=m
 CONFIG_ENCRYPTED_KEYS=m
 CONFIG_HARDENED_USERCOPY=y
 CONFIG_CRYPTO_USER=m
 CONFIG_CRYPTO_CRYPTD=m
-CONFIG_CRYPTO_TEST=m
+CONFIG_CRYPTO_BENCHMARK=m
 CONFIG_CRYPTO_RSA=m
 CONFIG_CRYPTO_DH=m
 CONFIG_CRYPTO_ECDH=m
 CONFIG_CRYPTO_ECDSA=m
 CONFIG_CRYPTO_ECRDSA=m
diff --git a/arch/m68k/configs/hp300_defconfig b/arch/m68k/configs/hp300_defconfig
index e8ca5a50b86d..e7cdab059d96 100644
--- a/arch/m68k/configs/hp300_defconfig
+++ b/arch/m68k/configs/hp300_defconfig
@@ -508,11 +508,11 @@ CONFIG_NLS_MAC_TURKISH=m
 CONFIG_DLM=m
 CONFIG_ENCRYPTED_KEYS=m
 CONFIG_HARDENED_USERCOPY=y
 CONFIG_CRYPTO_USER=m
 CONFIG_CRYPTO_CRYPTD=m
-CONFIG_CRYPTO_TEST=m
+CONFIG_CRYPTO_BENCHMARK=m
 CONFIG_CRYPTO_RSA=m
 CONFIG_CRYPTO_DH=m
 CONFIG_CRYPTO_ECDH=m
 CONFIG_CRYPTO_ECDSA=m
 CONFIG_CRYPTO_ECRDSA=m
diff --git a/arch/m68k/configs/mac_defconfig b/arch/m68k/configs/mac_defconfig
index b3a270441bb1..0a79751c20a5 100644
--- a/arch/m68k/configs/mac_defconfig
+++ b/arch/m68k/configs/mac_defconfig
@@ -525,11 +525,11 @@ CONFIG_NLS_MAC_TURKISH=m
 CONFIG_DLM=m
 CONFIG_ENCRYPTED_KEYS=m
 CONFIG_HARDENED_USERCOPY=y
 CONFIG_CRYPTO_USER=m
 CONFIG_CRYPTO_CRYPTD=m
-CONFIG_CRYPTO_TEST=m
+CONFIG_CRYPTO_BENCHMARK=m
 CONFIG_CRYPTO_RSA=m
 CONFIG_CRYPTO_DH=m
 CONFIG_CRYPTO_ECDH=m
 CONFIG_CRYPTO_ECDSA=m
 CONFIG_CRYPTO_ECRDSA=m
diff --git a/arch/m68k/configs/multi_defconfig b/arch/m68k/configs/multi_defconfig
index d215dba006ce..f8ca490ee65a 100644
--- a/arch/m68k/configs/multi_defconfig
+++ b/arch/m68k/configs/multi_defconfig
@@ -612,11 +612,11 @@ CONFIG_NLS_MAC_TURKISH=m
 CONFIG_DLM=m
 CONFIG_ENCRYPTED_KEYS=m
 CONFIG_HARDENED_USERCOPY=y
 CONFIG_CRYPTO_USER=m
 CONFIG_CRYPTO_CRYPTD=m
-CONFIG_CRYPTO_TEST=m
+CONFIG_CRYPTO_BENCHMARK=m
 CONFIG_CRYPTO_RSA=m
 CONFIG_CRYPTO_DH=m
 CONFIG_CRYPTO_ECDH=m
 CONFIG_CRYPTO_ECDSA=m
 CONFIG_CRYPTO_ECRDSA=m
diff --git a/arch/m68k/configs/mvme147_defconfig b/arch/m68k/configs/mvme147_defconfig
index a888ed93ff82..88fdcea906f3 100644
--- a/arch/m68k/configs/mvme147_defconfig
+++ b/arch/m68k/configs/mvme147_defconfig
@@ -498,11 +498,11 @@ CONFIG_NLS_MAC_TURKISH=m
 CONFIG_DLM=m
 CONFIG_ENCRYPTED_KEYS=m
 CONFIG_HARDENED_USERCOPY=y
 CONFIG_CRYPTO_USER=m
 CONFIG_CRYPTO_CRYPTD=m
-CONFIG_CRYPTO_TEST=m
+CONFIG_CRYPTO_BENCHMARK=m
 CONFIG_CRYPTO_RSA=m
 CONFIG_CRYPTO_DH=m
 CONFIG_CRYPTO_ECDH=m
 CONFIG_CRYPTO_ECDSA=m
 CONFIG_CRYPTO_ECRDSA=m
diff --git a/arch/m68k/configs/mvme16x_defconfig b/arch/m68k/configs/mvme16x_defconfig
index b481782375f6..8acbe83dac72 100644
--- a/arch/m68k/configs/mvme16x_defconfig
+++ b/arch/m68k/configs/mvme16x_defconfig
@@ -499,11 +499,11 @@ CONFIG_NLS_MAC_TURKISH=m
 CONFIG_DLM=m
 CONFIG_ENCRYPTED_KEYS=m
 CONFIG_HARDENED_USERCOPY=y
 CONFIG_CRYPTO_USER=m
 CONFIG_CRYPTO_CRYPTD=m
-CONFIG_CRYPTO_TEST=m
+CONFIG_CRYPTO_BENCHMARK=m
 CONFIG_CRYPTO_RSA=m
 CONFIG_CRYPTO_DH=m
 CONFIG_CRYPTO_ECDH=m
 CONFIG_CRYPTO_ECDSA=m
 CONFIG_CRYPTO_ECRDSA=m
diff --git a/arch/m68k/configs/q40_defconfig b/arch/m68k/configs/q40_defconfig
index 6eba743d8eb5..e3095301f3c5 100644
--- a/arch/m68k/configs/q40_defconfig
+++ b/arch/m68k/configs/q40_defconfig
@@ -515,11 +515,11 @@ CONFIG_NLS_MAC_TURKISH=m
 CONFIG_DLM=m
 CONFIG_ENCRYPTED_KEYS=m
 CONFIG_HARDENED_USERCOPY=y
 CONFIG_CRYPTO_USER=m
 CONFIG_CRYPTO_CRYPTD=m
-CONFIG_CRYPTO_TEST=m
+CONFIG_CRYPTO_BENCHMARK=m
 CONFIG_CRYPTO_RSA=m
 CONFIG_CRYPTO_DH=m
 CONFIG_CRYPTO_ECDH=m
 CONFIG_CRYPTO_ECDSA=m
 CONFIG_CRYPTO_ECRDSA=m
diff --git a/arch/m68k/configs/sun3_defconfig b/arch/m68k/configs/sun3_defconfig
index 9bdbb418ffa8..948e48ddd128 100644
--- a/arch/m68k/configs/sun3_defconfig
+++ b/arch/m68k/configs/sun3_defconfig
@@ -496,11 +496,11 @@ CONFIG_NLS_MAC_TURKISH=m
 CONFIG_DLM=m
 CONFIG_ENCRYPTED_KEYS=m
 CONFIG_HARDENED_USERCOPY=y
 CONFIG_CRYPTO_USER=m
 CONFIG_CRYPTO_CRYPTD=m
-CONFIG_CRYPTO_TEST=m
+CONFIG_CRYPTO_BENCHMARK=m
 CONFIG_CRYPTO_RSA=m
 CONFIG_CRYPTO_DH=m
 CONFIG_CRYPTO_ECDH=m
 CONFIG_CRYPTO_ECDSA=m
 CONFIG_CRYPTO_ECRDSA=m
diff --git a/arch/m68k/configs/sun3x_defconfig b/arch/m68k/configs/sun3x_defconfig
index e1cf20fa5343..5bcf9181c37c 100644
--- a/arch/m68k/configs/sun3x_defconfig
+++ b/arch/m68k/configs/sun3x_defconfig
@@ -496,11 +496,11 @@ CONFIG_NLS_MAC_TURKISH=m
 CONFIG_DLM=m
 CONFIG_ENCRYPTED_KEYS=m
 CONFIG_HARDENED_USERCOPY=y
 CONFIG_CRYPTO_USER=m
 CONFIG_CRYPTO_CRYPTD=m
-CONFIG_CRYPTO_TEST=m
+CONFIG_CRYPTO_BENCHMARK=m
 CONFIG_CRYPTO_RSA=m
 CONFIG_CRYPTO_DH=m
 CONFIG_CRYPTO_ECDH=m
 CONFIG_CRYPTO_ECDSA=m
 CONFIG_CRYPTO_ECRDSA=m
diff --git a/arch/mips/configs/gpr_defconfig b/arch/mips/configs/gpr_defconfig
index 12f3eed8a946..48c8feec958f 100644
--- a/arch/mips/configs/gpr_defconfig
+++ b/arch/mips/configs/gpr_defconfig
@@ -271,11 +271,11 @@ CONFIG_NFS_V4=y
 CONFIG_ROOT_NFS=y
 CONFIG_NLS_CODEPAGE_437=y
 CONFIG_NLS_CODEPAGE_850=y
 CONFIG_NLS_ISO8859_1=y
 CONFIG_CRYPTO_AUTHENC=m
-CONFIG_CRYPTO_TEST=m
+CONFIG_CRYPTO_BENCHMARK=m
 CONFIG_CRYPTO_PCBC=m
 CONFIG_CRYPTO_MD4=m
 CONFIG_CRYPTO_MICHAEL_MIC=m
 CONFIG_CRYPTO_SHA512=m
 CONFIG_CRYPTO_WP512=m
diff --git a/arch/mips/configs/lemote2f_defconfig b/arch/mips/configs/lemote2f_defconfig
index 71d6340497c9..5038a27d035f 100644
--- a/arch/mips/configs/lemote2f_defconfig
+++ b/arch/mips/configs/lemote2f_defconfig
@@ -295,11 +295,11 @@ CONFIG_NLS_ISO8859_14=m
 CONFIG_NLS_ISO8859_15=m
 CONFIG_NLS_KOI8_R=m
 CONFIG_NLS_KOI8_U=m
 CONFIG_NLS_UTF8=y
 CONFIG_CRYPTO_CRYPTD=m
-CONFIG_CRYPTO_TEST=m
+CONFIG_CRYPTO_BENCHMARK=m
 CONFIG_CRYPTO_BLOWFISH=m
 CONFIG_CRYPTO_CAMELLIA=m
 CONFIG_CRYPTO_CAST5=m
 CONFIG_CRYPTO_CAST6=m
 CONFIG_CRYPTO_FCRYPT=m
diff --git a/arch/mips/configs/mtx1_defconfig b/arch/mips/configs/mtx1_defconfig
index 06b7a0b97eca..cbf9c35a6177 100644
--- a/arch/mips/configs/mtx1_defconfig
+++ b/arch/mips/configs/mtx1_defconfig
@@ -660,11 +660,11 @@ CONFIG_NLS_ISO8859_13=m
 CONFIG_NLS_ISO8859_14=m
 CONFIG_NLS_ISO8859_15=m
 CONFIG_NLS_KOI8_R=m
 CONFIG_NLS_KOI8_U=m
 CONFIG_NLS_UTF8=m
-CONFIG_CRYPTO_TEST=m
+CONFIG_CRYPTO_BENCHMARK=m
 CONFIG_CRYPTO_PCBC=m
 CONFIG_CRYPTO_HMAC=y
 CONFIG_CRYPTO_MD5=y
 CONFIG_CRYPTO_MICHAEL_MIC=m
 CONFIG_CRYPTO_WP512=m
diff --git a/arch/mips/configs/rb532_defconfig b/arch/mips/configs/rb532_defconfig
index 42b161d587c7..9fb114ef5e2d 100644
--- a/arch/mips/configs/rb532_defconfig
+++ b/arch/mips/configs/rb532_defconfig
@@ -151,8 +151,8 @@ CONFIG_TMPFS=y
 CONFIG_CONFIGFS_FS=y
 CONFIG_JFFS2_FS=y
 CONFIG_JFFS2_SUMMARY=y
 CONFIG_JFFS2_COMPRESSION_OPTIONS=y
 CONFIG_SQUASHFS=y
-CONFIG_CRYPTO_TEST=m
+CONFIG_CRYPTO_BENCHMARK=m
 # CONFIG_CRYPTO_HW is not set
 CONFIG_STRIP_ASM_SYMS=y
diff --git a/arch/parisc/configs/generic-32bit_defconfig b/arch/parisc/configs/generic-32bit_defconfig
index 5b65c9859613..94928d114d4c 100644
--- a/arch/parisc/configs/generic-32bit_defconfig
+++ b/arch/parisc/configs/generic-32bit_defconfig
@@ -249,11 +249,11 @@ CONFIG_NFS_FS=m
 CONFIG_NFSD=m
 CONFIG_CIFS=m
 CONFIG_CIFS_XATTR=y
 CONFIG_CIFS_POSIX=y
 # CONFIG_CIFS_DEBUG is not set
-CONFIG_CRYPTO_TEST=m
+CONFIG_CRYPTO_BENCHMARK=m
 CONFIG_CRYPTO_BLOWFISH=m
 CONFIG_CRYPTO_CAST5=m
 CONFIG_CRYPTO_CAST6=m
 CONFIG_CRYPTO_DES=y
 CONFIG_CRYPTO_SERPENT=m
diff --git a/arch/powerpc/configs/g5_defconfig b/arch/powerpc/configs/g5_defconfig
index 7e58f3e6c987..428f17b45513 100644
--- a/arch/powerpc/configs/g5_defconfig
+++ b/arch/powerpc/configs/g5_defconfig
@@ -233,11 +233,11 @@ CONFIG_NLS_ISO8859_15=y
 CONFIG_NLS_UTF8=y
 CONFIG_MAGIC_SYSRQ=y
 CONFIG_DEBUG_KERNEL=y
 CONFIG_DEBUG_MUTEXES=y
 CONFIG_BOOTX_TEXT=y
-CONFIG_CRYPTO_TEST=m
+CONFIG_CRYPTO_BENCHMARK=m
 CONFIG_CRYPTO_PCBC=m
 CONFIG_CRYPTO_HMAC=y
 CONFIG_CRYPTO_MICHAEL_MIC=m
 CONFIG_CRYPTO_SHA512=m
 CONFIG_CRYPTO_WP512=m
diff --git a/arch/powerpc/configs/powernv_defconfig b/arch/powerpc/configs/powernv_defconfig
index 6b6d7467fecf..379229c982a4 100644
--- a/arch/powerpc/configs/powernv_defconfig
+++ b/arch/powerpc/configs/powernv_defconfig
@@ -315,11 +315,11 @@ CONFIG_BLK_DEV_IO_TRACE=y
 CONFIG_PPC_EMULATED_STATS=y
 CONFIG_CODE_PATCHING_SELFTEST=y
 CONFIG_FTR_FIXUP_SELFTEST=y
 CONFIG_MSI_BITMAP_SELFTEST=y
 CONFIG_XMON=y
-CONFIG_CRYPTO_TEST=m
+CONFIG_CRYPTO_BENCHMARK=m
 CONFIG_CRYPTO_PCBC=m
 CONFIG_CRYPTO_HMAC=y
 CONFIG_CRYPTO_MD5_PPC=m
 CONFIG_CRYPTO_MICHAEL_MIC=m
 CONFIG_CRYPTO_SHA1_PPC=m
diff --git a/arch/powerpc/configs/ppc64_defconfig b/arch/powerpc/configs/ppc64_defconfig
index 5fa154185efa..3423c405cad4 100644
--- a/arch/powerpc/configs/ppc64_defconfig
+++ b/arch/powerpc/configs/ppc64_defconfig
@@ -375,11 +375,11 @@ CONFIG_IMA_KEXEC=y
 CONFIG_IMA_DEFAULT_HASH_SHA256=y
 CONFIG_IMA_WRITE_POLICY=y
 CONFIG_IMA_APPRAISE=y
 CONFIG_IMA_ARCH_POLICY=y
 CONFIG_IMA_APPRAISE_MODSIG=y
-CONFIG_CRYPTO_TEST=m
+CONFIG_CRYPTO_BENCHMARK=m
 CONFIG_CRYPTO_BLOWFISH=m
 CONFIG_CRYPTO_CAST6=m
 CONFIG_CRYPTO_SERPENT=m
 CONFIG_CRYPTO_TWOFISH=m
 CONFIG_CRYPTO_PCBC=m
diff --git a/arch/powerpc/configs/ppc64e_defconfig b/arch/powerpc/configs/ppc64e_defconfig
index d2e659a2d8cb..90247b2a0ab0 100644
--- a/arch/powerpc/configs/ppc64e_defconfig
+++ b/arch/powerpc/configs/ppc64e_defconfig
@@ -218,11 +218,11 @@ CONFIG_SCHED_TRACER=y
 CONFIG_BLK_DEV_IO_TRACE=y
 CONFIG_CODE_PATCHING_SELFTEST=y
 CONFIG_FTR_FIXUP_SELFTEST=y
 CONFIG_MSI_BITMAP_SELFTEST=y
 CONFIG_XMON=y
-CONFIG_CRYPTO_TEST=m
+CONFIG_CRYPTO_BENCHMARK=m
 CONFIG_CRYPTO_CCM=m
 CONFIG_CRYPTO_GCM=m
 CONFIG_CRYPTO_PCBC=m
 CONFIG_CRYPTO_HMAC=y
 CONFIG_CRYPTO_MICHAEL_MIC=m
diff --git a/arch/powerpc/configs/ppc6xx_defconfig b/arch/powerpc/configs/ppc6xx_defconfig
index a91a766b71a4..242c1fab9d46 100644
--- a/arch/powerpc/configs/ppc6xx_defconfig
+++ b/arch/powerpc/configs/ppc6xx_defconfig
@@ -1071,11 +1071,11 @@ CONFIG_SECURITY=y
 CONFIG_SECURITY_NETWORK=y
 CONFIG_SECURITY_NETWORK_XFRM=y
 CONFIG_SECURITY_SELINUX=y
 CONFIG_SECURITY_SELINUX_BOOTPARAM=y
 CONFIG_SECURITY_SELINUX_DISABLE=y
-CONFIG_CRYPTO_TEST=m
+CONFIG_CRYPTO_BENCHMARK=m
 CONFIG_CRYPTO_CTS=m
 CONFIG_CRYPTO_LRW=m
 CONFIG_CRYPTO_PCBC=m
 CONFIG_CRYPTO_XTS=m
 CONFIG_CRYPTO_HMAC=y
diff --git a/arch/s390/configs/debug_defconfig b/arch/s390/configs/debug_defconfig
index de69faa4d94f..e6f7c8f4ee8b 100644
--- a/arch/s390/configs/debug_defconfig
+++ b/arch/s390/configs/debug_defconfig
@@ -744,11 +744,11 @@ CONFIG_IMA_APPRAISE=y
 CONFIG_BUG_ON_DATA_CORRUPTION=y
 CONFIG_CRYPTO_USER=m
 # CONFIG_CRYPTO_MANAGER_DISABLE_TESTS is not set
 CONFIG_CRYPTO_PCRYPT=m
 CONFIG_CRYPTO_CRYPTD=m
-CONFIG_CRYPTO_TEST=m
+CONFIG_CRYPTO_BENCHMARK=m
 CONFIG_CRYPTO_DH=m
 CONFIG_CRYPTO_ECDH=m
 CONFIG_CRYPTO_ECDSA=m
 CONFIG_CRYPTO_ECRDSA=m
 CONFIG_CRYPTO_CURVE25519=m
diff --git a/arch/s390/configs/defconfig b/arch/s390/configs/defconfig
index f12679448e97..7495bf8e483c 100644
--- a/arch/s390/configs/defconfig
+++ b/arch/s390/configs/defconfig
@@ -730,11 +730,11 @@ CONFIG_BUG_ON_DATA_CORRUPTION=y
 CONFIG_CRYPTO_FIPS=y
 CONFIG_CRYPTO_USER=m
 # CONFIG_CRYPTO_MANAGER_DISABLE_TESTS is not set
 CONFIG_CRYPTO_PCRYPT=m
 CONFIG_CRYPTO_CRYPTD=m
-CONFIG_CRYPTO_TEST=m
+CONFIG_CRYPTO_BENCHMARK=m
 CONFIG_CRYPTO_DH=m
 CONFIG_CRYPTO_ECDH=m
 CONFIG_CRYPTO_ECDSA=m
 CONFIG_CRYPTO_ECRDSA=m
 CONFIG_CRYPTO_CURVE25519=m
diff --git a/arch/sparc/configs/sparc64_defconfig b/arch/sparc/configs/sparc64_defconfig
index f1ba0fefe1f9..7a7c4dec2925 100644
--- a/arch/sparc/configs/sparc64_defconfig
+++ b/arch/sparc/configs/sparc64_defconfig
@@ -203,11 +203,11 @@ CONFIG_DETECT_HUNG_TASK=y
 CONFIG_SCHEDSTATS=y
 CONFIG_BLK_DEV_IO_TRACE=y
 CONFIG_UPROBE_EVENTS=y
 CONFIG_KEYS=y
 CONFIG_CRYPTO_NULL=m
-CONFIG_CRYPTO_TEST=m
+CONFIG_CRYPTO_BENCHMARK=m
 CONFIG_CRYPTO_LRW=m
 CONFIG_CRYPTO_PCBC=m
 CONFIG_CRYPTO_XTS=m
 CONFIG_CRYPTO_XCBC=y
 CONFIG_CRYPTO_MD4=y
diff --git a/crypto/Kconfig b/crypto/Kconfig
index 7bfad077f308..da352f1984ea 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -244,16 +244,20 @@ config CRYPTO_KRB5ENC
 	help
 	  Combined hash and cipher support for Kerberos 5 RFC3961 simplified
 	  profile.  This is required for Kerberos 5-style encryption, used by
 	  sunrpc/NFS and rxrpc/AFS.
 
-config CRYPTO_TEST
-	tristate "Testing module"
+config CRYPTO_BENCHMARK
+	tristate "Crypto benchmarking module"
 	depends on m || EXPERT
 	select CRYPTO_MANAGER
 	help
-	  Quick & dirty crypto test module.
+	  Quick & dirty crypto benchmarking module.
+
+	  This is mainly intended for use by people developing cryptographic
+	  algorithms in the kernel.  It should not be enabled in production
+	  kernels.
 
 config CRYPTO_SIMD
 	tristate
 	select CRYPTO_CRYPTD
 
diff --git a/crypto/Makefile b/crypto/Makefile
index 84f6911dc9ba..e2223265b91a 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -170,11 +170,11 @@ obj-$(CONFIG_CRYPTO_JITTERENTROPY) += jitterentropy_rng.o
 CFLAGS_jitterentropy.o = -O0
 KASAN_SANITIZE_jitterentropy.o = n
 UBSAN_SANITIZE_jitterentropy.o = n
 jitterentropy_rng-y := jitterentropy.o jitterentropy-kcapi.o
 obj-$(CONFIG_CRYPTO_JITTERENTROPY_TESTINTERFACE) += jitterentropy-testing.o
-obj-$(CONFIG_CRYPTO_TEST) += tcrypt.o
+obj-$(CONFIG_CRYPTO_BENCHMARK) += tcrypt.o
 obj-$(CONFIG_CRYPTO_GHASH) += ghash-generic.o
 obj-$(CONFIG_CRYPTO_POLYVAL) += polyval-generic.o
 obj-$(CONFIG_CRYPTO_USER_API) += af_alg.o
 obj-$(CONFIG_CRYPTO_USER_API_HASH) += algif_hash.o
 obj-$(CONFIG_CRYPTO_USER_API_SKCIPHER) += algif_skcipher.o
diff --git a/crypto/tcrypt.c b/crypto/tcrypt.c
index 879fc21dcc16..d1d88debbd71 100644
--- a/crypto/tcrypt.c
+++ b/crypto/tcrypt.c
@@ -1,10 +1,10 @@
 // SPDX-License-Identifier: GPL-2.0-or-later
 /*
- * Quick & dirty crypto testing module.
+ * Quick & dirty crypto benchmarking module.
  *
- * This will only exist until we have a better testing mechanism
+ * This will only exist until we have a better benchmarking mechanism
  * (e.g. a char device).
  *
  * Copyright (c) 2002 James Morris <jmorris@intercode.com.au>
  * Copyright (c) 2002 Jean-Francois Dive <jef@linuxbe.org>
  * Copyright (c) 2007 Nokia Siemens Networks
@@ -37,11 +37,11 @@
 
 #include "internal.h"
 #include "tcrypt.h"
 
 /*
- * Need slab memory for testing (size in number of pages).
+ * Need slab memory for benchmarking (size in number of pages).
  */
 #define TVMEMSIZE	4
 
 /*
 * Used by test_cipher_speed()
@@ -2866,7 +2866,7 @@ module_param(num_mb, uint, 0000);
 MODULE_PARM_DESC(num_mb, "Number of concurrent requests to be used in mb speed tests (defaults to 8)");
 module_param(klen, uint, 0);
 MODULE_PARM_DESC(klen, "Key length (defaults to 0)");
 
 MODULE_LICENSE("GPL");
-MODULE_DESCRIPTION("Quick & dirty crypto testing module");
+MODULE_DESCRIPTION("Quick & dirty crypto benchmarking module");
 MODULE_AUTHOR("James Morris <jmorris@intercode.com.au>");
diff --git a/crypto/tcrypt.h b/crypto/tcrypt.h
index 96c843a24607..7f938ac93e58 100644
--- a/crypto/tcrypt.h
+++ b/crypto/tcrypt.h
@@ -1,10 +1,10 @@
 /* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
- * Quick & dirty crypto testing module.
+ * Quick & dirty crypto benchmarking module.
  *
- * This will only exist until we have a better testing mechanism
+ * This will only exist until we have a better benchmarking mechanism
  * (e.g. a char device).
  *
  * Copyright (c) 2002 James Morris <jmorris@intercode.com.au>
  * Copyright (c) 2002 Jean-Francois Dive <jef@linuxbe.org>
  * Copyright (c) 2007 Nokia Siemens Networks
-- 
2.49.0

