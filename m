Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F28227932E;
	Tue,  4 Mar 2025 23:08:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741129683; cv=none; b=u9j8UE2DQl/t7ljO4gUZ7dU6nmwN6qw6NGqR9hBbQY8879dQ8fY/WPAWoeK1/TBM4SpHOFKwNnD7l4WJuqDpSQf6Mgn2GhsB2PrGndqFzCAIUshiWtgIKZUPPTHkvzAzR8R+1b5lJ5GheJogwZXKEX8PBhsCw8GAX1RzUyc7l30=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741129683; c=relaxed/simple;
	bh=XT1nxD2wrMYtCLCyWJNa2GsScTW7lrPpSp0wNXEjwAQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d0dJIEW2MoodM+JQzcuSqEwIePhMtiAnnPQEB8IIGcoCaWjPdvfdCm1sYA+xgwbgc+McLI8SVSJNzJ4E2uk9OGf9OpEn28rZUf1jiJ0zq9xYf/W4O4qXU1zRoBd/1f82VSz2nFfr8zfyJ49/Kw7IBtI0/sHXNzZMyp6GLp0NA9g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iR8Vwy85; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iR8Vwy85"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91D8BC4CEEC;
	Tue,  4 Mar 2025 23:08:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741129682;
	bh=XT1nxD2wrMYtCLCyWJNa2GsScTW7lrPpSp0wNXEjwAQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iR8Vwy85qgPhAlHTlAK5Sr8jJAH/1srdZ1wF0GWoq/PCeMeGEqaKQX8TpHysLm5mw
	 7hLdW9q8US1E+ueYbpJZMH1xmzFXeAT9skRPTvj1edRsfM4f2eTYEvpth7ZJtObaPn
	 DyWGcpO5gtjw2BMeM/TXq4FKsMNdCrB3ksLbeNwo3STHcPOzdkXe4X0SQvxEtacSm2
	 8rzN1nKgnAfwFde8pjWtYb+xSz8GnRPY32t91A5fbHHgz3N6gn4Y9qSy7+KlgIV0R0
	 fW5MFZnRKMToOlYFJS2HR8wRAJvqbloml9uG40jkJM/DTEbAO70EaJ9Fb6xldv9Ieu
	 aX8LXp0Amd1mw==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: linux-crypto@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH 2/5] lib/crc: remove unnecessary prompt for CONFIG_CRC7
Date: Tue,  4 Mar 2025 15:07:09 -0800
Message-ID: <20250304230712.167600-3-ebiggers@kernel.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250304230712.167600-1-ebiggers@kernel.org>
References: <20250304230712.167600-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Eric Biggers <ebiggers@google.com>

All modules that need CONFIG_CRC7 already select it, so there is no need
to bother users about the option.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 arch/arm/configs/imx_v6_v7_defconfig  | 1 -
 arch/arm/configs/lpc18xx_defconfig    | 1 -
 arch/arm/configs/mxs_defconfig        | 1 -
 arch/arm/configs/omap2plus_defconfig  | 1 -
 arch/arm/configs/stm32_defconfig      | 1 -
 arch/mips/configs/bigsur_defconfig    | 1 -
 arch/mips/configs/fuloong2e_defconfig | 1 -
 arch/s390/configs/debug_defconfig     | 1 -
 arch/s390/configs/defconfig           | 1 -
 arch/sh/configs/se7206_defconfig      | 1 -
 lib/Kconfig                           | 7 +------
 11 files changed, 1 insertion(+), 16 deletions(-)

diff --git a/arch/arm/configs/imx_v6_v7_defconfig b/arch/arm/configs/imx_v6_v7_defconfig
index 87841e5cafe21..eace4475fa9d2 100644
--- a/arch/arm/configs/imx_v6_v7_defconfig
+++ b/arch/arm/configs/imx_v6_v7_defconfig
@@ -481,11 +481,10 @@ CONFIG_SECURITYFS=y
 CONFIG_CRYPTO_DEV_FSL_CAAM=y
 CONFIG_CRYPTO_DEV_SAHARA=y
 CONFIG_CRYPTO_DEV_MXS_DCP=y
 CONFIG_CRC_CCITT=m
 CONFIG_CRC_T10DIF=y
-CONFIG_CRC7=m
 CONFIG_LIBCRC32C=m
 CONFIG_CMA_SIZE_MBYTES=64
 CONFIG_FONTS=y
 CONFIG_FONT_8x8=y
 CONFIG_FONT_8x16=y
diff --git a/arch/arm/configs/lpc18xx_defconfig b/arch/arm/configs/lpc18xx_defconfig
index f55c231e08708..2aa2ac8c6507d 100644
--- a/arch/arm/configs/lpc18xx_defconfig
+++ b/arch/arm/configs/lpc18xx_defconfig
@@ -146,11 +146,10 @@ CONFIG_EXT2_FS=y
 # CONFIG_DNOTIFY is not set
 # CONFIG_INOTIFY_USER is not set
 CONFIG_JFFS2_FS=y
 # CONFIG_NETWORK_FILESYSTEMS is not set
 CONFIG_CRC_ITU_T=y
-CONFIG_CRC7=y
 CONFIG_PRINTK_TIME=y
 # CONFIG_ENABLE_MUST_CHECK is not set
 # CONFIG_DEBUG_BUGVERBOSE is not set
 CONFIG_DEBUG_INFO_DWARF_TOOLCHAIN_DEFAULT=y
 CONFIG_MAGIC_SYSRQ=y
diff --git a/arch/arm/configs/mxs_defconfig b/arch/arm/configs/mxs_defconfig
index 43bc1255a5db9..d8a6e43c401ef 100644
--- a/arch/arm/configs/mxs_defconfig
+++ b/arch/arm/configs/mxs_defconfig
@@ -159,11 +159,10 @@ CONFIG_NLS_CODEPAGE_437=y
 CONFIG_NLS_CODEPAGE_850=y
 CONFIG_NLS_ISO8859_1=y
 CONFIG_NLS_ISO8859_15=y
 CONFIG_CRYPTO_DEV_MXS_DCP=y
 CONFIG_CRC_ITU_T=m
-CONFIG_CRC7=m
 CONFIG_FONTS=y
 CONFIG_PRINTK_TIME=y
 CONFIG_DEBUG_KERNEL=y
 CONFIG_DEBUG_INFO_DWARF_TOOLCHAIN_DEFAULT=y
 CONFIG_FRAME_WARN=2048
diff --git a/arch/arm/configs/omap2plus_defconfig b/arch/arm/configs/omap2plus_defconfig
index 6de45d7f60781..99636c9dced1a 100644
--- a/arch/arm/configs/omap2plus_defconfig
+++ b/arch/arm/configs/omap2plus_defconfig
@@ -708,11 +708,10 @@ CONFIG_CRYPTO_DEV_OMAP_SHAM=m
 CONFIG_CRYPTO_DEV_OMAP_AES=m
 CONFIG_CRYPTO_DEV_OMAP_DES=m
 CONFIG_CRC_CCITT=y
 CONFIG_CRC_T10DIF=y
 CONFIG_CRC_ITU_T=y
-CONFIG_CRC7=y
 CONFIG_LIBCRC32C=y
 CONFIG_DMA_CMA=y
 CONFIG_FONTS=y
 CONFIG_FONT_8x8=y
 CONFIG_FONT_8x16=y
diff --git a/arch/arm/configs/stm32_defconfig b/arch/arm/configs/stm32_defconfig
index 77048b5e1ec49..423bb41c4225f 100644
--- a/arch/arm/configs/stm32_defconfig
+++ b/arch/arm/configs/stm32_defconfig
@@ -73,11 +73,10 @@ CONFIG_EXT3_FS=y
 # CONFIG_FILE_LOCKING is not set
 # CONFIG_DNOTIFY is not set
 # CONFIG_INOTIFY_USER is not set
 CONFIG_NLS=y
 CONFIG_CRC_ITU_T=y
-CONFIG_CRC7=y
 CONFIG_PRINTK_TIME=y
 # CONFIG_DEBUG_BUGVERBOSE is not set
 CONFIG_DEBUG_INFO_DWARF_TOOLCHAIN_DEFAULT=y
 CONFIG_MAGIC_SYSRQ=y
 # CONFIG_SLUB_DEBUG is not set
diff --git a/arch/mips/configs/bigsur_defconfig b/arch/mips/configs/bigsur_defconfig
index f7c4b3529a2ca..fe282630b51cb 100644
--- a/arch/mips/configs/bigsur_defconfig
+++ b/arch/mips/configs/bigsur_defconfig
@@ -237,10 +237,9 @@ CONFIG_CRYPTO_SEED=m
 CONFIG_CRYPTO_SERPENT=m
 CONFIG_CRYPTO_TEA=m
 CONFIG_CRYPTO_TWOFISH=m
 CONFIG_CRYPTO_LZO=m
 CONFIG_CRC_T10DIF=m
-CONFIG_CRC7=m
 CONFIG_MAGIC_SYSRQ=y
 CONFIG_DEBUG_MEMORY_INIT=y
 CONFIG_DETECT_HUNG_TASK=y
 CONFIG_DEBUG_LIST=y
diff --git a/arch/mips/configs/fuloong2e_defconfig b/arch/mips/configs/fuloong2e_defconfig
index 00329bb5de5ab..5ab149cd3178e 100644
--- a/arch/mips/configs/fuloong2e_defconfig
+++ b/arch/mips/configs/fuloong2e_defconfig
@@ -217,6 +217,5 @@ CONFIG_CRYPTO_RMD160=m
 CONFIG_CRYPTO_SEED=m
 CONFIG_CRYPTO_DEFLATE=m
 CONFIG_CRYPTO_LZO=m
 # CONFIG_CRYPTO_HW is not set
 CONFIG_CRC_CCITT=y
-CONFIG_CRC7=m
diff --git a/arch/s390/configs/debug_defconfig b/arch/s390/configs/debug_defconfig
index c46781f8570c1..ea9c3a944e37c 100644
--- a/arch/s390/configs/debug_defconfig
+++ b/arch/s390/configs/debug_defconfig
@@ -813,11 +813,10 @@ CONFIG_CRYPTO_PAES_S390=m
 CONFIG_CRYPTO_DEV_VIRTIO=m
 CONFIG_SYSTEM_BLACKLIST_KEYRING=y
 CONFIG_CORDIC=m
 CONFIG_CRYPTO_LIB_CURVE25519=m
 CONFIG_CRYPTO_LIB_CHACHA20POLY1305=m
-CONFIG_CRC7=m
 CONFIG_CRC8=m
 CONFIG_RANDOM32_SELFTEST=y
 CONFIG_XZ_DEC_MICROLZMA=y
 CONFIG_DMA_CMA=y
 CONFIG_CMA_SIZE_MBYTES=0
diff --git a/arch/s390/configs/defconfig b/arch/s390/configs/defconfig
index 23d8bce642aa4..c929fa5131f1e 100644
--- a/arch/s390/configs/defconfig
+++ b/arch/s390/configs/defconfig
@@ -801,11 +801,10 @@ CONFIG_CRYPTO_DEV_VIRTIO=m
 CONFIG_SYSTEM_BLACKLIST_KEYRING=y
 CONFIG_CORDIC=m
 CONFIG_PRIME_NUMBERS=m
 CONFIG_CRYPTO_LIB_CURVE25519=m
 CONFIG_CRYPTO_LIB_CHACHA20POLY1305=m
-CONFIG_CRC7=m
 CONFIG_CRC8=m
 CONFIG_XZ_DEC_MICROLZMA=y
 CONFIG_DMA_CMA=y
 CONFIG_CMA_SIZE_MBYTES=0
 CONFIG_PRINTK_TIME=y
diff --git a/arch/sh/configs/se7206_defconfig b/arch/sh/configs/se7206_defconfig
index 78e0e7be57ee1..f104c3b9a1770 100644
--- a/arch/sh/configs/se7206_defconfig
+++ b/arch/sh/configs/se7206_defconfig
@@ -102,7 +102,6 @@ CONFIG_CRYPTO_LZO=y
 # CONFIG_CRYPTO_ANSI_CPRNG is not set
 # CONFIG_CRYPTO_HW is not set
 CONFIG_CRC_CCITT=y
 CONFIG_CRC16=y
 CONFIG_CRC_ITU_T=y
-CONFIG_CRC7=y
 CONFIG_LIBCRC32C=y
diff --git a/lib/Kconfig b/lib/Kconfig
index e867971c97669..9b668c4b60e9e 100644
--- a/lib/Kconfig
+++ b/lib/Kconfig
@@ -210,16 +210,11 @@ config CRC64_ARCH
 
 config CRC4
 	tristate
 
 config CRC7
-	tristate "CRC7 functions"
-	help
-	  This option is provided for the case where no in-kernel-tree
-	  modules require CRC7 functions, but a module built outside
-	  the kernel tree does. Such modules that use library CRC7
-	  functions require M here.
+	tristate
 
 config LIBCRC32C
 	tristate "CRC32c (Castagnoli, et al) Cyclic Redundancy-Check"
 	select CRC32
 	help
-- 
2.48.1

