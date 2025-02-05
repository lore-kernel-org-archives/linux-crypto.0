Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17B9D163;
	Wed,  5 Feb 2025 00:05:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738713925; cv=none; b=eWS7Jg/RVMMeyMkI//QCIus/qAZVyvfLITWZWvj2Aq11wGTBkMXqMDdG2pRuZea7PVgIVt07ORKIztYcxEAmTecFlwo+0ZSYpiLWeeRpKVqpprTEZfXX4+IdzAMuWjFSDhs1/No/KWfGIomzYWV2EhZnVWU1MMCoq59YTn0xG28=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738713925; c=relaxed/simple;
	bh=TpT8m4eW9ShlTWllgAg6QDuHnGnaxHICKxhgAArSePc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=qv5Xu/EToAyPr8kTMSWlsAnYMYM0hc1oeN0XVN4KxJt+y7IYO6GkEua18FmQl9S2aIBg8wLYH4iTyQcoL1vRZ21+FX/BFEAODUhsZDFoQTnkG7WE9VZrhmQEGmDTb5BBhzQhgdU+tw/1Z8V9DqkwkPMaNXKqwlOCoDY2pkdQwSg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dlFtdDJq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dlFtdDJq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CE83C4CEE4;
	Wed,  5 Feb 2025 00:05:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738713924;
	bh=TpT8m4eW9ShlTWllgAg6QDuHnGnaxHICKxhgAArSePc=;
	h=From:To:Cc:Subject:Date:From;
	b=dlFtdDJqRBxkT5x98vpvjXYWhV3jBJwnCAdK9G8UAZjLd8ccBLdDoKrJXmKWRkSQU
	 IIqYMHT2WLp1rTwd9x4OzNhI9+VURCO6V8k14kWVUGofeJEYIy8LzuSpQLwoQ/iiWf
	 Dh4GODqaIiv5TuWJqQRBhCRjffw8hdDW+a1uLKFgN0K1ICE1FOJsMq0F1nIxqKn9D7
	 7QEfSdAzlc4futgaxWTpqCtFGLM/rn8JIbZTLnjhgiEqBZ/FIQy4GubJ5iLCcSwY/H
	 chKDIeiJj2tY9GfgpRqVtbQCO+mrmqUPoVswCbTXLRB9p2JLQF0BKlGYQPCi3Q6VdA
	 h2mhfl/RlkdEQ==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: linux-crypto@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH] lib/crc32: remove obsolete CRC32 options from defconfig files
Date: Tue,  4 Feb 2025 16:04:24 -0800
Message-ID: <20250205000424.75149-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Eric Biggers <ebiggers@google.com>

Remove all remaining references to CONFIG_CRC32_BIT,
CONFIG_CRC32_SARWATE, CONFIG_CRC32_SLICEBY4, and CONFIG_CRC32_SLICEBY8.
These options no longer exist, now that we've standardized on a single
generic CRC32 implementation.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 arch/arm/configs/moxart_defconfig         | 1 -
 arch/mips/configs/bcm47xx_defconfig       | 1 -
 arch/mips/configs/db1xxx_defconfig        | 1 -
 arch/mips/configs/rt305x_defconfig        | 1 -
 arch/mips/configs/xway_defconfig          | 1 -
 arch/powerpc/configs/adder875_defconfig   | 1 -
 arch/powerpc/configs/ep88xc_defconfig     | 1 -
 arch/powerpc/configs/mpc866_ads_defconfig | 1 -
 arch/powerpc/configs/mpc885_ads_defconfig | 1 -
 arch/powerpc/configs/tqm8xx_defconfig     | 1 -
 10 files changed, 10 deletions(-)

diff --git a/arch/arm/configs/moxart_defconfig b/arch/arm/configs/moxart_defconfig
index 34d079e03b3c5..fa06d98e43fcd 100644
--- a/arch/arm/configs/moxart_defconfig
+++ b/arch/arm/configs/moxart_defconfig
@@ -116,11 +116,10 @@ CONFIG_MOXART_DMA=y
 CONFIG_EXT3_FS=y
 CONFIG_TMPFS=y
 CONFIG_CONFIGFS_FS=y
 CONFIG_JFFS2_FS=y
 CONFIG_KEYS=y
-CONFIG_CRC32_BIT=y
 CONFIG_DMA_API_DEBUG=y
 CONFIG_PRINTK_TIME=y
 CONFIG_DEBUG_INFO_DWARF_TOOLCHAIN_DEFAULT=y
 # CONFIG_ENABLE_MUST_CHECK is not set
 CONFIG_KGDB=y
diff --git a/arch/mips/configs/bcm47xx_defconfig b/arch/mips/configs/bcm47xx_defconfig
index 6a68a96d13f80..f56e8db5da951 100644
--- a/arch/mips/configs/bcm47xx_defconfig
+++ b/arch/mips/configs/bcm47xx_defconfig
@@ -67,11 +67,10 @@ CONFIG_BCMA_DRIVER_GMAC_CMN=y
 CONFIG_USB=y
 CONFIG_USB_HCD_BCMA=y
 CONFIG_USB_HCD_SSB=y
 CONFIG_LEDS_TRIGGER_TIMER=y
 CONFIG_LEDS_TRIGGER_DEFAULT_ON=y
-CONFIG_CRC32_SARWATE=y
 CONFIG_PRINTK_TIME=y
 CONFIG_DEBUG_INFO_DWARF_TOOLCHAIN_DEFAULT=y
 CONFIG_DEBUG_INFO_REDUCED=y
 CONFIG_STRIP_ASM_SYMS=y
 CONFIG_DEBUG_FS=y
diff --git a/arch/mips/configs/db1xxx_defconfig b/arch/mips/configs/db1xxx_defconfig
index 6eff21ff15d54..281dd7d0f8059 100644
--- a/arch/mips/configs/db1xxx_defconfig
+++ b/arch/mips/configs/db1xxx_defconfig
@@ -214,9 +214,8 @@ CONFIG_NLS_UTF8=y
 CONFIG_SECURITYFS=y
 CONFIG_CRYPTO_USER=y
 CONFIG_CRYPTO_CRYPTD=y
 CONFIG_CRYPTO_USER_API_HASH=y
 CONFIG_CRYPTO_USER_API_SKCIPHER=y
-CONFIG_CRC32_SLICEBY4=y
 CONFIG_FONTS=y
 CONFIG_FONT_8x8=y
 CONFIG_MAGIC_SYSRQ=y
diff --git a/arch/mips/configs/rt305x_defconfig b/arch/mips/configs/rt305x_defconfig
index 332f9094e8479..8404e0a9d8b22 100644
--- a/arch/mips/configs/rt305x_defconfig
+++ b/arch/mips/configs/rt305x_defconfig
@@ -127,11 +127,10 @@ CONFIG_JFFS2_COMPRESSION_OPTIONS=y
 CONFIG_SQUASHFS=y
 # CONFIG_SQUASHFS_ZLIB is not set
 CONFIG_SQUASHFS_XZ=y
 CONFIG_CRYPTO_ARC4=m
 CONFIG_CRC_ITU_T=m
-CONFIG_CRC32_SARWATE=y
 # CONFIG_XZ_DEC_X86 is not set
 # CONFIG_XZ_DEC_POWERPC is not set
 # CONFIG_XZ_DEC_IA64 is not set
 # CONFIG_XZ_DEC_ARM is not set
 # CONFIG_XZ_DEC_ARMTHUMB is not set
diff --git a/arch/mips/configs/xway_defconfig b/arch/mips/configs/xway_defconfig
index 08c0aa03fd564..7b91edfe3e075 100644
--- a/arch/mips/configs/xway_defconfig
+++ b/arch/mips/configs/xway_defconfig
@@ -139,11 +139,10 @@ CONFIG_JFFS2_COMPRESSION_OPTIONS=y
 CONFIG_SQUASHFS=y
 # CONFIG_SQUASHFS_ZLIB is not set
 CONFIG_SQUASHFS_XZ=y
 CONFIG_CRYPTO_ARC4=m
 CONFIG_CRC_ITU_T=m
-CONFIG_CRC32_SARWATE=y
 CONFIG_PRINTK_TIME=y
 CONFIG_STRIP_ASM_SYMS=y
 CONFIG_DEBUG_FS=y
 CONFIG_MAGIC_SYSRQ=y
 # CONFIG_SCHED_DEBUG is not set
diff --git a/arch/powerpc/configs/adder875_defconfig b/arch/powerpc/configs/adder875_defconfig
index 97f4d48517356..3c6445c98a85f 100644
--- a/arch/powerpc/configs/adder875_defconfig
+++ b/arch/powerpc/configs/adder875_defconfig
@@ -42,10 +42,9 @@ CONFIG_THERMAL=y
 # CONFIG_DNOTIFY is not set
 CONFIG_TMPFS=y
 CONFIG_CRAMFS=y
 CONFIG_NFS_FS=y
 CONFIG_ROOT_NFS=y
-CONFIG_CRC32_SLICEBY4=y
 CONFIG_DEBUG_INFO_DWARF_TOOLCHAIN_DEFAULT=y
 CONFIG_DEBUG_FS=y
 CONFIG_MAGIC_SYSRQ=y
 CONFIG_DETECT_HUNG_TASK=y
diff --git a/arch/powerpc/configs/ep88xc_defconfig b/arch/powerpc/configs/ep88xc_defconfig
index 50cc59eb36cf1..354180ab94bcc 100644
--- a/arch/powerpc/configs/ep88xc_defconfig
+++ b/arch/powerpc/configs/ep88xc_defconfig
@@ -45,9 +45,8 @@ CONFIG_SERIAL_CPM_CONSOLE=y
 # CONFIG_DNOTIFY is not set
 CONFIG_TMPFS=y
 CONFIG_CRAMFS=y
 CONFIG_NFS_FS=y
 CONFIG_ROOT_NFS=y
-CONFIG_CRC32_SLICEBY4=y
 CONFIG_DEBUG_INFO_DWARF_TOOLCHAIN_DEFAULT=y
 CONFIG_MAGIC_SYSRQ=y
 CONFIG_DETECT_HUNG_TASK=y
diff --git a/arch/powerpc/configs/mpc866_ads_defconfig b/arch/powerpc/configs/mpc866_ads_defconfig
index 6f449411abf7b..a0d27c59ea788 100644
--- a/arch/powerpc/configs/mpc866_ads_defconfig
+++ b/arch/powerpc/configs/mpc866_ads_defconfig
@@ -37,6 +37,5 @@ CONFIG_EXT4_FS=y
 CONFIG_TMPFS=y
 CONFIG_CRAMFS=y
 CONFIG_NFS_FS=y
 CONFIG_ROOT_NFS=y
 CONFIG_CRC_CCITT=y
-CONFIG_CRC32_SLICEBY4=y
diff --git a/arch/powerpc/configs/mpc885_ads_defconfig b/arch/powerpc/configs/mpc885_ads_defconfig
index 77306be62e9ee..89da51d724fb1 100644
--- a/arch/powerpc/configs/mpc885_ads_defconfig
+++ b/arch/powerpc/configs/mpc885_ads_defconfig
@@ -68,11 +68,10 @@ CONFIG_TMPFS=y
 CONFIG_CRAMFS=y
 CONFIG_NFS_FS=y
 CONFIG_ROOT_NFS=y
 CONFIG_CRYPTO=y
 CONFIG_CRYPTO_DEV_TALITOS=y
-CONFIG_CRC32_SLICEBY4=y
 CONFIG_DEBUG_INFO_DWARF_TOOLCHAIN_DEFAULT=y
 CONFIG_MAGIC_SYSRQ=y
 CONFIG_DEBUG_FS=y
 CONFIG_DEBUG_VM_PGTABLE=y
 CONFIG_DETECT_HUNG_TASK=y
diff --git a/arch/powerpc/configs/tqm8xx_defconfig b/arch/powerpc/configs/tqm8xx_defconfig
index 383c0966e92fd..425f10837a185 100644
--- a/arch/powerpc/configs/tqm8xx_defconfig
+++ b/arch/powerpc/configs/tqm8xx_defconfig
@@ -52,9 +52,8 @@ CONFIG_HW_RANDOM=y
 # CONFIG_DNOTIFY is not set
 CONFIG_TMPFS=y
 CONFIG_CRAMFS=y
 CONFIG_NFS_FS=y
 CONFIG_ROOT_NFS=y
-CONFIG_CRC32_SLICEBY4=y
 CONFIG_DEBUG_INFO_DWARF_TOOLCHAIN_DEFAULT=y
 CONFIG_MAGIC_SYSRQ=y
 CONFIG_DETECT_HUNG_TASK=y

base-commit: 2014c95afecee3e76ca4a56956a936e23283f05b
-- 
2.48.1

