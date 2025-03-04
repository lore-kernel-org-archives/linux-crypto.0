Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AA8127BF81;
	Tue,  4 Mar 2025 23:08:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741129683; cv=none; b=kTV5I5MsZJK7YjPKyK/Rk9zISgimeCUBEtdWuqehkOsihxUbvE5dSwFHDfpjVn+FR7i4qF9YzcCaJSe+Ed5JG8O18aboYB/2frMOnR7ZLOCZC7TaIS5DhBiR76/Awb+Vx1FHZSfvZFiidLFgVhVMmkBKfp4lREfSdKksgCCvNYU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741129683; c=relaxed/simple;
	bh=7JlhhLZUlG9FLSt0jmIt1f4pDEEPj9rDFVG/k8XGjig=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f9ml5BL7ifawUXQlIZ7Px8hoKde4MPYfMFnkO4dxRt0qGelwXWcNWjrLFRhdesRBpcd+MOSi2GcAZ3pQQzneMzQKYVFm/He7ry67XiImTqDJ62sxaz4Ae/9ti2nyXl0t2Ln3caGHexYNpmTnT3xC0fCFSQoJ5tjxd8UZB95+b3E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=g+/07Sxd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="g+/07Sxd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F919C4CEE5;
	Tue,  4 Mar 2025 23:08:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741129683;
	bh=7JlhhLZUlG9FLSt0jmIt1f4pDEEPj9rDFVG/k8XGjig=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g+/07SxdDC8u6O1IbNJGc6FopXaDx/SX+C6r2uXVU/EJ1j1kamnHbwEWj+Q2sXDSV
	 NdargO9jbJUKUDmCoEy9r+fYoYaM+ZIExGWcLVxV761FZXOsG+Xole4nxzAd4kw5G4
	 WIiYSa6ZLa656elwNJ/u5luHkQXcxsoPpy5LcK154TkroSEiI8/PVEZXawUZYiY6kA
	 Y7WcQaeSO4m/dwCCB1mQApd8lPTYWADDgxHRueVMipmZrx6sB++QN1452369FsTA8M
	 nkqAaQm1ZTs1afRtYmyv+DSwv8CaCPkN1d/LC76bhfNB4EnGgDREaJ+Ty7ziQhpj2d
	 6KkizLl0STyaA==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: linux-crypto@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH 4/5] lib/crc: remove unnecessary prompt for CONFIG_LIBCRC32C
Date: Tue,  4 Mar 2025 15:07:11 -0800
Message-ID: <20250304230712.167600-5-ebiggers@kernel.org>
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

All modules that need CONFIG_LIBCRC32C already select it, so there is no
need to bother users about the option.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 arch/arm/configs/dove_defconfig              | 1 -
 arch/arm/configs/ep93xx_defconfig            | 1 -
 arch/arm/configs/imx_v6_v7_defconfig         | 1 -
 arch/arm/configs/multi_v5_defconfig          | 1 -
 arch/arm/configs/mvebu_v5_defconfig          | 1 -
 arch/arm/configs/omap1_defconfig             | 1 -
 arch/arm/configs/omap2plus_defconfig         | 1 -
 arch/arm/configs/spitz_defconfig             | 1 -
 arch/arm/configs/wpcm450_defconfig           | 1 -
 arch/hexagon/configs/comet_defconfig         | 1 -
 arch/mips/configs/cobalt_defconfig           | 1 -
 arch/mips/configs/ip32_defconfig             | 1 -
 arch/parisc/configs/generic-64bit_defconfig  | 1 -
 arch/powerpc/configs/85xx/ge_imp3a_defconfig | 1 -
 arch/powerpc/configs/skiroot_defconfig       | 1 -
 arch/sh/configs/se7206_defconfig             | 1 -
 arch/sh/configs/sh2007_defconfig             | 1 -
 arch/sh/configs/titan_defconfig              | 1 -
 arch/sparc/configs/sparc32_defconfig         | 1 -
 arch/sparc/configs/sparc64_defconfig         | 1 -
 lib/Kconfig                                  | 2 +-
 21 files changed, 1 insertion(+), 21 deletions(-)

diff --git a/arch/arm/configs/dove_defconfig b/arch/arm/configs/dove_defconfig
index 2849d17f58566..b382a2e175fbc 100644
--- a/arch/arm/configs/dove_defconfig
+++ b/arch/arm/configs/dove_defconfig
@@ -127,11 +127,10 @@ CONFIG_CRYPTO_SHA512=y
 CONFIG_CRYPTO_DEFLATE=y
 CONFIG_CRYPTO_LZO=y
 # CONFIG_CRYPTO_ANSI_CPRNG is not set
 CONFIG_CRYPTO_DEV_MARVELL_CESA=y
 CONFIG_CRC_CCITT=y
-CONFIG_LIBCRC32C=y
 CONFIG_PRINTK_TIME=y
 # CONFIG_DEBUG_BUGVERBOSE is not set
 CONFIG_DEBUG_INFO_DWARF_TOOLCHAIN_DEFAULT=y
 CONFIG_MAGIC_SYSRQ=y
 CONFIG_DEBUG_FS=y
diff --git a/arch/arm/configs/ep93xx_defconfig b/arch/arm/configs/ep93xx_defconfig
index 7dece9d988288..2248afaf35b50 100644
--- a/arch/arm/configs/ep93xx_defconfig
+++ b/arch/arm/configs/ep93xx_defconfig
@@ -111,11 +111,10 @@ CONFIG_TMPFS=y
 CONFIG_JFFS2_FS=y
 CONFIG_NFS_FS=y
 CONFIG_ROOT_NFS=y
 CONFIG_NLS_CODEPAGE_437=y
 CONFIG_NLS_ISO8859_1=y
-CONFIG_LIBCRC32C=y
 CONFIG_MAGIC_SYSRQ=y
 CONFIG_DEBUG_SLAB=y
 CONFIG_DEBUG_SPINLOCK=y
 CONFIG_DEBUG_MUTEXES=y
 CONFIG_DEBUG_USER=y
diff --git a/arch/arm/configs/imx_v6_v7_defconfig b/arch/arm/configs/imx_v6_v7_defconfig
index eace4475fa9d2..297c6a7b978a6 100644
--- a/arch/arm/configs/imx_v6_v7_defconfig
+++ b/arch/arm/configs/imx_v6_v7_defconfig
@@ -481,11 +481,10 @@ CONFIG_SECURITYFS=y
 CONFIG_CRYPTO_DEV_FSL_CAAM=y
 CONFIG_CRYPTO_DEV_SAHARA=y
 CONFIG_CRYPTO_DEV_MXS_DCP=y
 CONFIG_CRC_CCITT=m
 CONFIG_CRC_T10DIF=y
-CONFIG_LIBCRC32C=m
 CONFIG_CMA_SIZE_MBYTES=64
 CONFIG_FONTS=y
 CONFIG_FONT_8x8=y
 CONFIG_FONT_8x16=y
 CONFIG_PRINTK_TIME=y
diff --git a/arch/arm/configs/multi_v5_defconfig b/arch/arm/configs/multi_v5_defconfig
index 3f4ddcf49ec75..db81862bdb937 100644
--- a/arch/arm/configs/multi_v5_defconfig
+++ b/arch/arm/configs/multi_v5_defconfig
@@ -288,11 +288,10 @@ CONFIG_NLS_ISO8859_2=y
 CONFIG_NLS_UTF8=y
 CONFIG_CRYPTO_CBC=m
 CONFIG_CRYPTO_PCBC=m
 CONFIG_CRYPTO_DEV_MARVELL_CESA=y
 CONFIG_CRC_CCITT=y
-CONFIG_LIBCRC32C=y
 CONFIG_DEBUG_KERNEL=y
 CONFIG_DEBUG_INFO_DWARF_TOOLCHAIN_DEFAULT=y
 CONFIG_MAGIC_SYSRQ=y
 CONFIG_DEBUG_FS=y
 # CONFIG_SCHED_DEBUG is not set
diff --git a/arch/arm/configs/mvebu_v5_defconfig b/arch/arm/configs/mvebu_v5_defconfig
index 2467afd32146b..a518d4a2581e0 100644
--- a/arch/arm/configs/mvebu_v5_defconfig
+++ b/arch/arm/configs/mvebu_v5_defconfig
@@ -186,11 +186,10 @@ CONFIG_NLS_ISO8859_2=y
 CONFIG_NLS_UTF8=y
 CONFIG_CRYPTO_CBC=m
 CONFIG_CRYPTO_PCBC=m
 CONFIG_CRYPTO_DEV_MARVELL_CESA=y
 CONFIG_CRC_CCITT=y
-CONFIG_LIBCRC32C=y
 CONFIG_DEBUG_KERNEL=y
 CONFIG_DEBUG_INFO_DWARF_TOOLCHAIN_DEFAULT=y
 CONFIG_MAGIC_SYSRQ=y
 CONFIG_DEBUG_FS=y
 # CONFIG_SCHED_DEBUG is not set
diff --git a/arch/arm/configs/omap1_defconfig b/arch/arm/configs/omap1_defconfig
index 025b595dd8375..661e5d6894bd3 100644
--- a/arch/arm/configs/omap1_defconfig
+++ b/arch/arm/configs/omap1_defconfig
@@ -219,11 +219,10 @@ CONFIG_SECURITY=y
 CONFIG_CRYPTO_ECB=y
 CONFIG_CRYPTO_PCBC=y
 CONFIG_CRYPTO_DEFLATE=y
 CONFIG_CRYPTO_LZO=y
 # CONFIG_CRYPTO_ANSI_CPRNG is not set
-CONFIG_LIBCRC32C=y
 CONFIG_FONTS=y
 CONFIG_FONT_8x8=y
 CONFIG_FONT_8x16=y
 CONFIG_FONT_6x11=y
 CONFIG_FONT_MINI_4x6=y
diff --git a/arch/arm/configs/omap2plus_defconfig b/arch/arm/configs/omap2plus_defconfig
index 99636c9dced1a..d62b17f14d541 100644
--- a/arch/arm/configs/omap2plus_defconfig
+++ b/arch/arm/configs/omap2plus_defconfig
@@ -708,11 +708,10 @@ CONFIG_CRYPTO_DEV_OMAP_SHAM=m
 CONFIG_CRYPTO_DEV_OMAP_AES=m
 CONFIG_CRYPTO_DEV_OMAP_DES=m
 CONFIG_CRC_CCITT=y
 CONFIG_CRC_T10DIF=y
 CONFIG_CRC_ITU_T=y
-CONFIG_LIBCRC32C=y
 CONFIG_DMA_CMA=y
 CONFIG_FONTS=y
 CONFIG_FONT_8x8=y
 CONFIG_FONT_8x16=y
 CONFIG_PRINTK_TIME=y
diff --git a/arch/arm/configs/spitz_defconfig b/arch/arm/configs/spitz_defconfig
index 294d16ddeb18a..ac5b7a5aaff68 100644
--- a/arch/arm/configs/spitz_defconfig
+++ b/arch/arm/configs/spitz_defconfig
@@ -233,11 +233,10 @@ CONFIG_CRYPTO_HMAC=y
 CONFIG_CRYPTO_MD4=m
 CONFIG_CRYPTO_MICHAEL_MIC=m
 CONFIG_CRYPTO_SHA512=m
 CONFIG_CRYPTO_WP512=m
 CONFIG_CRC_CCITT=y
-CONFIG_LIBCRC32C=m
 CONFIG_FONTS=y
 CONFIG_FONT_8x8=y
 CONFIG_FONT_8x16=y
 CONFIG_MAGIC_SYSRQ=y
 # CONFIG_DEBUG_PREEMPT is not set
diff --git a/arch/arm/configs/wpcm450_defconfig b/arch/arm/configs/wpcm450_defconfig
index 45483deab034f..5e4397f7f828c 100644
--- a/arch/arm/configs/wpcm450_defconfig
+++ b/arch/arm/configs/wpcm450_defconfig
@@ -191,11 +191,10 @@ CONFIG_ASYMMETRIC_PUBLIC_KEY_SUBTYPE=y
 CONFIG_X509_CERTIFICATE_PARSER=y
 CONFIG_PKCS7_MESSAGE_PARSER=y
 CONFIG_SYSTEM_TRUSTED_KEYRING=y
 CONFIG_CRC_CCITT=y
 CONFIG_CRC_ITU_T=m
-CONFIG_LIBCRC32C=y
 CONFIG_PRINTK_TIME=y
 CONFIG_DEBUG_KERNEL=y
 CONFIG_MAGIC_SYSRQ=y
 CONFIG_DEBUG_FS=y
 # CONFIG_SCHED_DEBUG is not set
diff --git a/arch/hexagon/configs/comet_defconfig b/arch/hexagon/configs/comet_defconfig
index 6cb7649475964..469c025297c69 100644
--- a/arch/hexagon/configs/comet_defconfig
+++ b/arch/hexagon/configs/comet_defconfig
@@ -73,10 +73,9 @@ CONFIG_CRYPTO_MD5=y
 # CONFIG_CRYPTO_ANSI_CPRNG is not set
 # CONFIG_CRYPTO_HW is not set
 CONFIG_CRC_CCITT=y
 CONFIG_CRC16=y
 CONFIG_CRC_T10DIF=y
-CONFIG_LIBCRC32C=y
 CONFIG_FRAME_WARN=0
 CONFIG_MAGIC_SYSRQ=y
 CONFIG_DEBUG_FS=y
 # CONFIG_SCHED_DEBUG is not set
diff --git a/arch/mips/configs/cobalt_defconfig b/arch/mips/configs/cobalt_defconfig
index e835730ea7fa4..b0b551efac7c4 100644
--- a/arch/mips/configs/cobalt_defconfig
+++ b/arch/mips/configs/cobalt_defconfig
@@ -68,6 +68,5 @@ CONFIG_TMPFS_POSIX_ACL=y
 CONFIG_CONFIGFS_FS=y
 CONFIG_NFS_FS=y
 CONFIG_NFS_V3_ACL=y
 CONFIG_NFSD=y
 CONFIG_NFSD_V3_ACL=y
-CONFIG_LIBCRC32C=y
diff --git a/arch/mips/configs/ip32_defconfig b/arch/mips/configs/ip32_defconfig
index 930c5f6ed1828..121e7e48fa771 100644
--- a/arch/mips/configs/ip32_defconfig
+++ b/arch/mips/configs/ip32_defconfig
@@ -176,10 +176,9 @@ CONFIG_CRYPTO_KHAZAD=y
 CONFIG_CRYPTO_SERPENT=y
 CONFIG_CRYPTO_TEA=y
 CONFIG_CRYPTO_TWOFISH=y
 CONFIG_CRYPTO_DEFLATE=y
 CONFIG_CRC_T10DIF=y
-CONFIG_LIBCRC32C=y
 CONFIG_FONTS=y
 CONFIG_FONT_8x8=y
 CONFIG_FONT_8x16=y
 CONFIG_MAGIC_SYSRQ=y
diff --git a/arch/parisc/configs/generic-64bit_defconfig b/arch/parisc/configs/generic-64bit_defconfig
index 19a804860ed5b..3f96c02ecaf64 100644
--- a/arch/parisc/configs/generic-64bit_defconfig
+++ b/arch/parisc/configs/generic-64bit_defconfig
@@ -292,11 +292,10 @@ CONFIG_CRYPTO_MD4=m
 CONFIG_CRYPTO_MD5=y
 CONFIG_CRYPTO_MICHAEL_MIC=m
 CONFIG_CRYPTO_DEFLATE=m
 # CONFIG_CRYPTO_HW is not set
 CONFIG_CRC_CCITT=m
-CONFIG_LIBCRC32C=y
 CONFIG_PRINTK_TIME=y
 CONFIG_DEBUG_KERNEL=y
 CONFIG_STRIP_ASM_SYMS=y
 CONFIG_MAGIC_SYSRQ=y
 CONFIG_DEBUG_FS=y
diff --git a/arch/powerpc/configs/85xx/ge_imp3a_defconfig b/arch/powerpc/configs/85xx/ge_imp3a_defconfig
index da6fc203e2dc6..6f58ee1edf1fc 100644
--- a/arch/powerpc/configs/85xx/ge_imp3a_defconfig
+++ b/arch/powerpc/configs/85xx/ge_imp3a_defconfig
@@ -221,11 +221,10 @@ CONFIG_NLS_ISO8859_15=y
 CONFIG_NLS_KOI8_R=m
 CONFIG_NLS_KOI8_U=m
 CONFIG_NLS_UTF8=y
 CONFIG_CRC_CCITT=y
 CONFIG_CRC_T10DIF=y
-CONFIG_LIBCRC32C=y
 CONFIG_MAGIC_SYSRQ=y
 CONFIG_CRYPTO_CBC=y
 CONFIG_CRYPTO_MD5=y
 CONFIG_CRYPTO_SHA512=m
 CONFIG_CRYPTO_DES=y
diff --git a/arch/powerpc/configs/skiroot_defconfig b/arch/powerpc/configs/skiroot_defconfig
index 9d44e6630908d..1eb446452fc04 100644
--- a/arch/powerpc/configs/skiroot_defconfig
+++ b/arch/powerpc/configs/skiroot_defconfig
@@ -279,11 +279,10 @@ CONFIG_LOCK_DOWN_KERNEL_FORCE_INTEGRITY=y
 # CONFIG_INTEGRITY is not set
 CONFIG_LSM="yama,loadpin,safesetid,integrity"
 # CONFIG_CRYPTO_HW is not set
 CONFIG_CRC16=y
 CONFIG_CRC_ITU_T=y
-CONFIG_LIBCRC32C=y
 # CONFIG_XZ_DEC_X86 is not set
 # CONFIG_XZ_DEC_IA64 is not set
 # CONFIG_XZ_DEC_ARM is not set
 # CONFIG_XZ_DEC_ARMTHUMB is not set
 # CONFIG_XZ_DEC_SPARC is not set
diff --git a/arch/sh/configs/se7206_defconfig b/arch/sh/configs/se7206_defconfig
index f104c3b9a1770..472fdf365cad0 100644
--- a/arch/sh/configs/se7206_defconfig
+++ b/arch/sh/configs/se7206_defconfig
@@ -102,6 +102,5 @@ CONFIG_CRYPTO_LZO=y
 # CONFIG_CRYPTO_ANSI_CPRNG is not set
 # CONFIG_CRYPTO_HW is not set
 CONFIG_CRC_CCITT=y
 CONFIG_CRC16=y
 CONFIG_CRC_ITU_T=y
-CONFIG_LIBCRC32C=y
diff --git a/arch/sh/configs/sh2007_defconfig b/arch/sh/configs/sh2007_defconfig
index 977ae405a75e7..1b1174a07e361 100644
--- a/arch/sh/configs/sh2007_defconfig
+++ b/arch/sh/configs/sh2007_defconfig
@@ -193,6 +193,5 @@ CONFIG_CRYPTO_DEFLATE=y
 CONFIG_CRYPTO_LZO=y
 # CONFIG_CRYPTO_ANSI_CPRNG is not set
 # CONFIG_CRYPTO_HW is not set
 CONFIG_CRC_CCITT=y
 CONFIG_CRC16=y
-CONFIG_LIBCRC32C=y
diff --git a/arch/sh/configs/titan_defconfig b/arch/sh/configs/titan_defconfig
index 99bc0e889287a..11ff5fd510de1 100644
--- a/arch/sh/configs/titan_defconfig
+++ b/arch/sh/configs/titan_defconfig
@@ -264,6 +264,5 @@ CONFIG_CRYPTO_KHAZAD=m
 CONFIG_CRYPTO_SERPENT=m
 CONFIG_CRYPTO_TEA=m
 CONFIG_CRYPTO_TWOFISH=m
 # CONFIG_CRYPTO_ANSI_CPRNG is not set
 CONFIG_CRC16=m
-CONFIG_LIBCRC32C=m
diff --git a/arch/sparc/configs/sparc32_defconfig b/arch/sparc/configs/sparc32_defconfig
index 5010164de3e45..f6341b063b01b 100644
--- a/arch/sparc/configs/sparc32_defconfig
+++ b/arch/sparc/configs/sparc32_defconfig
@@ -92,6 +92,5 @@ CONFIG_CRYPTO_CAST5=m
 CONFIG_CRYPTO_CAST6=m
 CONFIG_CRYPTO_SERPENT=m
 CONFIG_CRYPTO_TWOFISH=m
 # CONFIG_CRYPTO_ANSI_CPRNG is not set
 # CONFIG_CRYPTO_HW is not set
-CONFIG_LIBCRC32C=m
diff --git a/arch/sparc/configs/sparc64_defconfig b/arch/sparc/configs/sparc64_defconfig
index 0bb0d4da52277..01b2bdfbf9a89 100644
--- a/arch/sparc/configs/sparc64_defconfig
+++ b/arch/sparc/configs/sparc64_defconfig
@@ -228,11 +228,10 @@ CONFIG_CRYPTO_SEED=m
 CONFIG_CRYPTO_SERPENT=m
 CONFIG_CRYPTO_TEA=m
 CONFIG_CRYPTO_TWOFISH=m
 # CONFIG_CRYPTO_ANSI_CPRNG is not set
 CONFIG_CRC16=m
-CONFIG_LIBCRC32C=m
 CONFIG_VCC=m
 CONFIG_PATA_CMD64X=y
 CONFIG_IP_PNP=y
 CONFIG_IP_PNP_DHCP=y
 CONFIG_DEVTMPFS=y
diff --git a/lib/Kconfig b/lib/Kconfig
index 31add0dc42925..4bf2dd9f49a80 100644
--- a/lib/Kconfig
+++ b/lib/Kconfig
@@ -213,11 +213,11 @@ config CRC4
 
 config CRC7
 	tristate
 
 config LIBCRC32C
-	tristate "CRC32c (Castagnoli, et al) Cyclic Redundancy-Check"
+	tristate
 	select CRC32
 	help
 	  This option just selects CRC32 and is provided for compatibility
 	  purposes until the users are updated to select CRC32 directly.
 
-- 
2.48.1

