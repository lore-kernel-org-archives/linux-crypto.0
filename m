Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FB9D186E2E;
	Fri, 14 Nov 2025 02:58:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763089118; cv=none; b=MKRGGno9vqJaCtQPeRFf4OlM+p3v97qZB+YNZ1tCAG/Y4HbRNjrj59pucA/NW6yBadf4lWKTXRs5civt5wbmt2aHFPk8s3OqDPNSsVjx094lNK3zRxlWh6gYZntUyWZmaP4992fYgaw1azncIJ0ZoyThjujQBlWtM0Pz0U8XsoI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763089118; c=relaxed/simple;
	bh=5wnDkJLjFPOZ9wJVA2Irn2qBCqpYI/8k1EmMnTser28=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=gkV5vg5KiB6HiqYP0TxBabdenCgfJSdiKIQXln8kXcMIHPPjQJGNJ9fnzVqGI/1upK0EUP26cIYyDN+UA9uti7Y1pOeLpdCwUADxLdhaF5RaP0/FHfdOye9gmhAQn73pRvHmXVasSufItHlYyRlaf/9b5HW622liZHP2fMR+9A4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TZIf+EUW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TZIf+EUW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92ADAC4CEF1;
	Fri, 14 Nov 2025 02:58:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763089117;
	bh=5wnDkJLjFPOZ9wJVA2Irn2qBCqpYI/8k1EmMnTser28=;
	h=From:To:Cc:Subject:Date:From;
	b=TZIf+EUWoEN65azodZBG/P6vTzj1csReKygtBrvtkYnFDZVjzV9nM8xaCRx2y8MQF
	 4i0voVoYNwVoyKFZEFkF/42kvYrY6j+5H3LKx8qpfBW6/3G0rCr5R9997oSj+7FkEq
	 yO/lcCX0N2QqF0SLS7SysjkCt6oxGvEmAwJoe4uaghiN3kcJMEMguBqO0IxGCPYoal
	 sOvXW5YOCX6isjCY6J39VktU9a6h1x76m16owCuqTyc56VSquPIsyBLDSceTJnRQSm
	 NvLVAZnAc7ZpTeGOxwQdyg1UEd1zapyYAbZlMKxTD6hlZgoHf8W2p3B/aRP4bn4vvc
	 /aKjBCC/VV8+w==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>
Cc: "Jason A . Donenfeld" <Jason@zx2c4.com>,
	linux-kernel@vger.kernel.org,
	Eric Biggers <ebiggers@kernel.org>,
	Haotian Zhang <vulab@iscas.ac.cn>,
	Neil Horman <nhorman@tuxdriver.com>
Subject: [PATCH] crypto: ansi_cprng - Remove unused ansi_cprng algorithm
Date: Thu, 13 Nov 2025 18:57:08 -0800
Message-ID: <20251114025708.230616-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.51.2
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Remove ansi_cprng, since it's obsolete and unused, as confirmed at
https://lore.kernel.org/r/aQxpnckYMgAAOLpZ@gondor.apana.org.au/

This was originally added in 2008, apparently as a FIPS approved random
number generator.  Whether this has ever belonged upstream is
questionable.  Either way, ansi_cprng is no longer usable for this
purpose, since it's been superseded by the more modern algorithms in
crypto/drbg.c, and FIPS itself no longer allows it.  (NIST SP 800-131A
Rev 1 (2015) says that RNGs based on ANSI X9.31 will be disallowed after
2015.  NIST SP 800-131A Rev 2 (2019) confirms they are now disallowed.)

Therefore, there is no reason to keep it around.

Suggested-by: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Haotian Zhang <vulab@iscas.ac.cn>
Cc: Neil Horman <nhorman@tuxdriver.com>
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---

This patch is targeting cryptodev/master

 Documentation/crypto/userspace-if.rst       |   7 +-
 MAINTAINERS                                 |   1 -
 arch/arm/configs/axm55xx_defconfig          |   1 -
 arch/arm/configs/clps711x_defconfig         |   1 -
 arch/arm/configs/dove_defconfig             |   1 -
 arch/arm/configs/ep93xx_defconfig           |   1 -
 arch/arm/configs/jornada720_defconfig       |   1 -
 arch/arm/configs/keystone_defconfig         |   1 -
 arch/arm/configs/lpc32xx_defconfig          |   1 -
 arch/arm/configs/mmp2_defconfig             |   1 -
 arch/arm/configs/mv78xx0_defconfig          |   1 -
 arch/arm/configs/omap1_defconfig            |   1 -
 arch/arm/configs/orion5x_defconfig          |   1 -
 arch/arm/configs/pxa168_defconfig           |   1 -
 arch/arm/configs/pxa3xx_defconfig           |   1 -
 arch/arm/configs/pxa910_defconfig           |   1 -
 arch/arm/configs/spitz_defconfig            |   1 -
 arch/arm64/configs/defconfig                |   1 -
 arch/hexagon/configs/comet_defconfig        |   1 -
 arch/m68k/configs/amcore_defconfig          |   1 -
 arch/m68k/configs/amiga_defconfig           |   1 -
 arch/m68k/configs/apollo_defconfig          |   1 -
 arch/m68k/configs/atari_defconfig           |   1 -
 arch/m68k/configs/bvme6000_defconfig        |   1 -
 arch/m68k/configs/hp300_defconfig           |   1 -
 arch/m68k/configs/mac_defconfig             |   1 -
 arch/m68k/configs/multi_defconfig           |   1 -
 arch/m68k/configs/mvme147_defconfig         |   1 -
 arch/m68k/configs/mvme16x_defconfig         |   1 -
 arch/m68k/configs/q40_defconfig             |   1 -
 arch/m68k/configs/stmark2_defconfig         |   1 -
 arch/m68k/configs/sun3_defconfig            |   1 -
 arch/m68k/configs/sun3x_defconfig           |   1 -
 arch/mips/configs/decstation_64_defconfig   |   1 -
 arch/mips/configs/decstation_defconfig      |   1 -
 arch/mips/configs/decstation_r4k_defconfig  |   1 -
 arch/s390/configs/debug_defconfig           |   1 -
 arch/s390/configs/defconfig                 |   1 -
 arch/sh/configs/ap325rxa_defconfig          |   1 -
 arch/sh/configs/apsh4a3a_defconfig          |   1 -
 arch/sh/configs/apsh4ad0a_defconfig         |   1 -
 arch/sh/configs/dreamcast_defconfig         |   1 -
 arch/sh/configs/ecovec24_defconfig          |   1 -
 arch/sh/configs/edosk7760_defconfig         |   1 -
 arch/sh/configs/espt_defconfig              |   1 -
 arch/sh/configs/hp6xx_defconfig             |   1 -
 arch/sh/configs/landisk_defconfig           |   1 -
 arch/sh/configs/lboxre2_defconfig           |   1 -
 arch/sh/configs/migor_defconfig             |   1 -
 arch/sh/configs/r7780mp_defconfig           |   1 -
 arch/sh/configs/r7785rp_defconfig           |   1 -
 arch/sh/configs/rts7751r2d1_defconfig       |   1 -
 arch/sh/configs/rts7751r2dplus_defconfig    |   1 -
 arch/sh/configs/sdk7780_defconfig           |   1 -
 arch/sh/configs/sdk7786_defconfig           |   1 -
 arch/sh/configs/se7206_defconfig            |   1 -
 arch/sh/configs/se7343_defconfig            |   1 -
 arch/sh/configs/se7705_defconfig            |   1 -
 arch/sh/configs/se7712_defconfig            |   1 -
 arch/sh/configs/se7721_defconfig            |   1 -
 arch/sh/configs/se7722_defconfig            |   1 -
 arch/sh/configs/se7724_defconfig            |   1 -
 arch/sh/configs/se7750_defconfig            |   1 -
 arch/sh/configs/se7751_defconfig            |   1 -
 arch/sh/configs/se7780_defconfig            |   1 -
 arch/sh/configs/sh03_defconfig              |   1 -
 arch/sh/configs/sh2007_defconfig            |   1 -
 arch/sh/configs/sh7710voipgw_defconfig      |   1 -
 arch/sh/configs/sh7757lcr_defconfig         |   1 -
 arch/sh/configs/sh7763rdp_defconfig         |   1 -
 arch/sh/configs/sh7785lcr_32bit_defconfig   |   1 -
 arch/sh/configs/sh7785lcr_defconfig         |   1 -
 arch/sh/configs/shmin_defconfig             |   1 -
 arch/sh/configs/shx3_defconfig              |   1 -
 arch/sh/configs/titan_defconfig             |   1 -
 arch/sh/configs/ul2_defconfig               |   1 -
 arch/sh/configs/urquell_defconfig           |   1 -
 arch/sparc/configs/sparc32_defconfig        |   1 -
 arch/sparc/configs/sparc64_defconfig        |   1 -
 arch/xtensa/configs/audio_kc705_defconfig   |   1 -
 arch/xtensa/configs/generic_kc705_defconfig |   1 -
 arch/xtensa/configs/iss_defconfig           |   1 -
 arch/xtensa/configs/nommu_kc705_defconfig   |   1 -
 arch/xtensa/configs/smp_lx200_defconfig     |   1 -
 arch/xtensa/configs/virt_defconfig          |   1 -
 arch/xtensa/configs/xip_kc705_defconfig     |   1 -
 crypto/Kconfig                              |  13 +-
 crypto/Makefile                             |   1 -
 crypto/ansi_cprng.c                         | 474 --------------------
 crypto/tcrypt.c                             |   4 -
 crypto/testmgr.c                            |  97 ----
 crypto/testmgr.h                            | 106 -----
 include/crypto/rng.h                        |  11 +-
 93 files changed, 9 insertions(+), 789 deletions(-)
 delete mode 100644 crypto/ansi_cprng.c

diff --git a/Documentation/crypto/userspace-if.rst b/Documentation/crypto/userspace-if.rst
index f80f243e227e..8158b363cd98 100644
--- a/Documentation/crypto/userspace-if.rst
+++ b/Documentation/crypto/userspace-if.rst
@@ -300,14 +300,13 @@ follows:
         .salg_name = "drbg_nopr_sha256" /* this is the RNG name */
     };
 
 
 Depending on the RNG type, the RNG must be seeded. The seed is provided
-using the setsockopt interface to set the key. For example, the
-ansi_cprng requires a seed. The DRBGs do not require a seed, but may be
-seeded. The seed is also known as a *Personalization String* in NIST SP 800-90A
-standard.
+using the setsockopt interface to set the key. The SP800-90A DRBGs do
+not require a seed, but may be seeded. The seed is also known as a
+*Personalization String* in NIST SP 800-90A standard.
 
 Using the read()/recvmsg() system calls, random numbers can be obtained.
 The kernel generates at most 128 bytes in one call. If user space
 requires more data, multiple calls to read()/recvmsg() must be made.
 
diff --git a/MAINTAINERS b/MAINTAINERS
index 46126ce2f968..5493ee49646f 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6603,11 +6603,10 @@ F:	tools/crypto/tcrypt/tcrypt_speed_compare.py
 
 CRYPTOGRAPHIC RANDOM NUMBER GENERATOR
 M:	Neil Horman <nhorman@tuxdriver.com>
 L:	linux-crypto@vger.kernel.org
 S:	Maintained
-F:	crypto/ansi_cprng.c
 F:	crypto/rng.c
 
 CS3308 MEDIA DRIVER
 M:	Hans Verkuil <hverkuil@kernel.org>
 L:	linux-media@vger.kernel.org
diff --git a/arch/arm/configs/axm55xx_defconfig b/arch/arm/configs/axm55xx_defconfig
index 516689dc6cf1..f35d1e7efc7d 100644
--- a/arch/arm/configs/axm55xx_defconfig
+++ b/arch/arm/configs/axm55xx_defconfig
@@ -231,6 +231,5 @@ CONFIG_MAGIC_SYSRQ=y
 CONFIG_RCU_CPU_STALL_TIMEOUT=60
 # CONFIG_FTRACE is not set
 CONFIG_DEBUG_USER=y
 CONFIG_CRYPTO_GCM=y
 CONFIG_CRYPTO_SHA256=y
-# CONFIG_CRYPTO_ANSI_CPRNG is not set
diff --git a/arch/arm/configs/clps711x_defconfig b/arch/arm/configs/clps711x_defconfig
index 6fa3477e6b02..f66d502ce2ef 100644
--- a/arch/arm/configs/clps711x_defconfig
+++ b/arch/arm/configs/clps711x_defconfig
@@ -73,7 +73,6 @@ CONFIG_MINIX_FS=y
 # CONFIG_NETWORK_FILESYSTEMS is not set
 # CONFIG_FTRACE is not set
 CONFIG_DEBUG_USER=y
 CONFIG_DEBUG_LL=y
 CONFIG_EARLY_PRINTK=y
-# CONFIG_CRYPTO_ANSI_CPRNG is not set
 # CONFIG_CRYPTO_HW is not set
diff --git a/arch/arm/configs/dove_defconfig b/arch/arm/configs/dove_defconfig
index d76eb12d29a7..23d0b61402e4 100644
--- a/arch/arm/configs/dove_defconfig
+++ b/arch/arm/configs/dove_defconfig
@@ -124,11 +124,10 @@ CONFIG_CRYPTO_MD4=y
 CONFIG_CRYPTO_SHA1=y
 CONFIG_CRYPTO_SHA256=y
 CONFIG_CRYPTO_SHA512=y
 CONFIG_CRYPTO_DEFLATE=y
 CONFIG_CRYPTO_LZO=y
-# CONFIG_CRYPTO_ANSI_CPRNG is not set
 CONFIG_CRYPTO_DEV_MARVELL_CESA=y
 CONFIG_PRINTK_TIME=y
 # CONFIG_DEBUG_BUGVERBOSE is not set
 CONFIG_DEBUG_INFO_DWARF_TOOLCHAIN_DEFAULT=y
 CONFIG_MAGIC_SYSRQ=y
diff --git a/arch/arm/configs/ep93xx_defconfig b/arch/arm/configs/ep93xx_defconfig
index 2248afaf35b5..facdd4902470 100644
--- a/arch/arm/configs/ep93xx_defconfig
+++ b/arch/arm/configs/ep93xx_defconfig
@@ -117,6 +117,5 @@ CONFIG_MAGIC_SYSRQ=y
 CONFIG_DEBUG_SLAB=y
 CONFIG_DEBUG_SPINLOCK=y
 CONFIG_DEBUG_MUTEXES=y
 CONFIG_DEBUG_USER=y
 CONFIG_DEBUG_LL=y
-# CONFIG_CRYPTO_ANSI_CPRNG is not set
diff --git a/arch/arm/configs/jornada720_defconfig b/arch/arm/configs/jornada720_defconfig
index e6ec768f42e2..d57285cfefb2 100644
--- a/arch/arm/configs/jornada720_defconfig
+++ b/arch/arm/configs/jornada720_defconfig
@@ -90,6 +90,5 @@ CONFIG_NLS_KOI8_R=m
 CONFIG_NLS_KOI8_U=m
 CONFIG_NLS_UTF8=m
 CONFIG_DEBUG_KERNEL=y
 # CONFIG_FTRACE is not set
 CONFIG_DEBUG_LL=y
-# CONFIG_CRYPTO_ANSI_CPRNG is not set
diff --git a/arch/arm/configs/keystone_defconfig b/arch/arm/configs/keystone_defconfig
index c1291ca290b2..b0cadd878152 100644
--- a/arch/arm/configs/keystone_defconfig
+++ b/arch/arm/configs/keystone_defconfig
@@ -226,11 +226,10 @@ CONFIG_CRYPTO_USER=y
 CONFIG_CRYPTO_AUTHENC=y
 CONFIG_CRYPTO_DES=y
 CONFIG_CRYPTO_CBC=y
 CONFIG_CRYPTO_CTR=y
 CONFIG_CRYPTO_XCBC=y
-CONFIG_CRYPTO_ANSI_CPRNG=y
 CONFIG_CRYPTO_USER_API_HASH=y
 CONFIG_CRYPTO_USER_API_SKCIPHER=y
 CONFIG_DMA_CMA=y
 CONFIG_PRINTK_TIME=y
 CONFIG_DEBUG_INFO_DWARF_TOOLCHAIN_DEFAULT=y
diff --git a/arch/arm/configs/lpc32xx_defconfig b/arch/arm/configs/lpc32xx_defconfig
index 9afccd76446b..2bddb0924a8c 100644
--- a/arch/arm/configs/lpc32xx_defconfig
+++ b/arch/arm/configs/lpc32xx_defconfig
@@ -175,11 +175,10 @@ CONFIG_NFS_V4_2=y
 CONFIG_ROOT_NFS=y
 CONFIG_NLS_CODEPAGE_437=y
 CONFIG_NLS_ASCII=y
 CONFIG_NLS_ISO8859_1=y
 CONFIG_NLS_UTF8=y
-CONFIG_CRYPTO_ANSI_CPRNG=y
 # CONFIG_CRYPTO_HW is not set
 CONFIG_PRINTK_TIME=y
 CONFIG_DYNAMIC_DEBUG=y
 CONFIG_DEBUG_INFO_DWARF_TOOLCHAIN_DEFAULT=y
 CONFIG_GDB_SCRIPTS=y
diff --git a/arch/arm/configs/mmp2_defconfig b/arch/arm/configs/mmp2_defconfig
index 842a989baa27..d38e8d36fef2 100644
--- a/arch/arm/configs/mmp2_defconfig
+++ b/arch/arm/configs/mmp2_defconfig
@@ -76,6 +76,5 @@ CONFIG_DEBUG_FS=y
 # CONFIG_DYNAMIC_DEBUG is not set
 CONFIG_DEBUG_USER=y
 CONFIG_DEBUG_LL=y
 CONFIG_DEBUG_MMP_UART3=y
 CONFIG_EARLY_PRINTK=y
-# CONFIG_CRYPTO_ANSI_CPRNG is not set
diff --git a/arch/arm/configs/mv78xx0_defconfig b/arch/arm/configs/mv78xx0_defconfig
index 3343f72de7ea..e9d6af34c4e1 100644
--- a/arch/arm/configs/mv78xx0_defconfig
+++ b/arch/arm/configs/mv78xx0_defconfig
@@ -119,6 +119,5 @@ CONFIG_DEBUG_FS=y
 CONFIG_DEBUG_KERNEL=y
 # CONFIG_SLUB_DEBUG is not set
 CONFIG_SCHEDSTATS=y
 CONFIG_DEBUG_USER=y
 CONFIG_DEBUG_LL=y
-# CONFIG_CRYPTO_ANSI_CPRNG is not set
diff --git a/arch/arm/configs/omap1_defconfig b/arch/arm/configs/omap1_defconfig
index 661e5d6894bd..c574aa090acb 100644
--- a/arch/arm/configs/omap1_defconfig
+++ b/arch/arm/configs/omap1_defconfig
@@ -218,11 +218,10 @@ CONFIG_DEBUG_KERNEL=y
 CONFIG_SECURITY=y
 CONFIG_CRYPTO_ECB=y
 CONFIG_CRYPTO_PCBC=y
 CONFIG_CRYPTO_DEFLATE=y
 CONFIG_CRYPTO_LZO=y
-# CONFIG_CRYPTO_ANSI_CPRNG is not set
 CONFIG_FONTS=y
 CONFIG_FONT_8x8=y
 CONFIG_FONT_8x16=y
 CONFIG_FONT_6x11=y
 CONFIG_FONT_MINI_4x6=y
diff --git a/arch/arm/configs/orion5x_defconfig b/arch/arm/configs/orion5x_defconfig
index 62b9c6102789..1194ae1458f7 100644
--- a/arch/arm/configs/orion5x_defconfig
+++ b/arch/arm/configs/orion5x_defconfig
@@ -143,6 +143,5 @@ CONFIG_DEBUG_FS=y
 # CONFIG_SLUB_DEBUG is not set
 CONFIG_LATENCYTOP=y
 # CONFIG_FTRACE is not set
 CONFIG_DEBUG_USER=y
 CONFIG_DEBUG_LL=y
-# CONFIG_CRYPTO_ANSI_CPRNG is not set
diff --git a/arch/arm/configs/pxa168_defconfig b/arch/arm/configs/pxa168_defconfig
index 4748c7d33cb8..8cbca84fe33a 100644
--- a/arch/arm/configs/pxa168_defconfig
+++ b/arch/arm/configs/pxa168_defconfig
@@ -46,6 +46,5 @@ CONFIG_DEBUG_KERNEL=y
 CONFIG_DEBUG_INFO_DWARF_TOOLCHAIN_DEFAULT=y
 CONFIG_MAGIC_SYSRQ=y
 # CONFIG_DEBUG_PREEMPT is not set
 CONFIG_DEBUG_USER=y
 CONFIG_DEBUG_LL=y
-# CONFIG_CRYPTO_ANSI_CPRNG is not set
diff --git a/arch/arm/configs/pxa3xx_defconfig b/arch/arm/configs/pxa3xx_defconfig
index 381356faf382..07d422f0ff34 100644
--- a/arch/arm/configs/pxa3xx_defconfig
+++ b/arch/arm/configs/pxa3xx_defconfig
@@ -104,7 +104,6 @@ CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC=y
 # CONFIG_SCHED_DEBUG is not set
 CONFIG_DEBUG_SPINLOCK=y
 CONFIG_DEBUG_SPINLOCK_SLEEP=y
 # CONFIG_FTRACE is not set
 CONFIG_DEBUG_USER=y
-# CONFIG_CRYPTO_ANSI_CPRNG is not set
 # CONFIG_CRYPTO_HW is not set
diff --git a/arch/arm/configs/pxa910_defconfig b/arch/arm/configs/pxa910_defconfig
index 49b59c600ae1..71ed0d73f8a9 100644
--- a/arch/arm/configs/pxa910_defconfig
+++ b/arch/arm/configs/pxa910_defconfig
@@ -57,6 +57,5 @@ CONFIG_MAGIC_SYSRQ=y
 # CONFIG_DEBUG_PREEMPT is not set
 CONFIG_DEBUG_USER=y
 CONFIG_DEBUG_LL=y
 CONFIG_DEBUG_MMP_UART2=y
 CONFIG_EARLY_PRINTK=y
-# CONFIG_CRYPTO_ANSI_CPRNG is not set
diff --git a/arch/arm/configs/spitz_defconfig b/arch/arm/configs/spitz_defconfig
index ac2a0f998c73..cd27bb960436 100644
--- a/arch/arm/configs/spitz_defconfig
+++ b/arch/arm/configs/spitz_defconfig
@@ -226,11 +226,10 @@ CONFIG_CRYPTO_CAST5=m
 CONFIG_CRYPTO_CAST6=m
 CONFIG_CRYPTO_KHAZAD=m
 CONFIG_CRYPTO_SERPENT=m
 CONFIG_CRYPTO_TEA=m
 CONFIG_CRYPTO_TWOFISH=m
-# CONFIG_CRYPTO_ANSI_CPRNG is not set
 CONFIG_CRYPTO_HMAC=y
 CONFIG_CRYPTO_MD4=m
 CONFIG_CRYPTO_MICHAEL_MIC=m
 CONFIG_CRYPTO_SHA512=m
 CONFIG_CRYPTO_WP512=m
diff --git a/arch/arm64/configs/defconfig b/arch/arm64/configs/defconfig
index e3a2d37bd104..41328593e74b 100644
--- a/arch/arm64/configs/defconfig
+++ b/arch/arm64/configs/defconfig
@@ -1781,11 +1781,10 @@ CONFIG_SECURITY=y
 CONFIG_CRYPTO_USER=y
 CONFIG_CRYPTO_CHACHA20=m
 CONFIG_CRYPTO_BENCHMARK=m
 CONFIG_CRYPTO_ECHAINIV=y
 CONFIG_CRYPTO_MICHAEL_MIC=m
-CONFIG_CRYPTO_ANSI_CPRNG=y
 CONFIG_CRYPTO_USER_API_RNG=m
 CONFIG_CRYPTO_GHASH_ARM64_CE=y
 CONFIG_CRYPTO_SHA3_ARM64=m
 CONFIG_CRYPTO_SM3_ARM64_CE=m
 CONFIG_CRYPTO_AES_ARM64_CE_BLK=y
diff --git a/arch/hexagon/configs/comet_defconfig b/arch/hexagon/configs/comet_defconfig
index c6108f000288..f748400ac4c8 100644
--- a/arch/hexagon/configs/comet_defconfig
+++ b/arch/hexagon/configs/comet_defconfig
@@ -68,11 +68,10 @@ CONFIG_INET=y
 # CONFIG_INET_XFRM_MODE_BEET is not set
 # CONFIG_INET_LRO is not set
 # CONFIG_INET_DIAG is not set
 # CONFIG_IPV6 is not set
 CONFIG_CRYPTO_MD5=y
-# CONFIG_CRYPTO_ANSI_CPRNG is not set
 # CONFIG_CRYPTO_HW is not set
 CONFIG_FRAME_WARN=0
 CONFIG_MAGIC_SYSRQ=y
 CONFIG_DEBUG_FS=y
 # CONFIG_SCHED_DEBUG is not set
diff --git a/arch/m68k/configs/amcore_defconfig b/arch/m68k/configs/amcore_defconfig
index 60767811e34a..88832e9cd7cb 100644
--- a/arch/m68k/configs/amcore_defconfig
+++ b/arch/m68k/configs/amcore_defconfig
@@ -84,7 +84,6 @@ CONFIG_PRINTK_TIME=y
 # CONFIG_SECTION_MISMATCH_WARN_ONLY is not set
 CONFIG_PANIC_ON_OOPS=y
 # CONFIG_SCHED_DEBUG is not set
 # CONFIG_DEBUG_BUGVERBOSE is not set
 # CONFIG_CRYPTO_ECHAINIV is not set
-CONFIG_CRYPTO_ANSI_CPRNG=y
 # CONFIG_CRYPTO_HW is not set
diff --git a/arch/m68k/configs/amiga_defconfig b/arch/m68k/configs/amiga_defconfig
index fba8089c9fb3..62fb72988c2c 100644
--- a/arch/m68k/configs/amiga_defconfig
+++ b/arch/m68k/configs/amiga_defconfig
@@ -589,11 +589,10 @@ CONFIG_CRYPTO_XCBC=m
 CONFIG_CRYPTO_LZO=m
 CONFIG_CRYPTO_842=m
 CONFIG_CRYPTO_LZ4=m
 CONFIG_CRYPTO_LZ4HC=m
 CONFIG_CRYPTO_ZSTD=m
-CONFIG_CRYPTO_ANSI_CPRNG=m
 CONFIG_CRYPTO_DRBG_HASH=y
 CONFIG_CRYPTO_DRBG_CTR=y
 CONFIG_CRYPTO_USER_API_HASH=m
 CONFIG_CRYPTO_USER_API_SKCIPHER=m
 CONFIG_CRYPTO_USER_API_RNG=m
diff --git a/arch/m68k/configs/apollo_defconfig b/arch/m68k/configs/apollo_defconfig
index 6af37716384c..1efc03aa034e 100644
--- a/arch/m68k/configs/apollo_defconfig
+++ b/arch/m68k/configs/apollo_defconfig
@@ -546,11 +546,10 @@ CONFIG_CRYPTO_XCBC=m
 CONFIG_CRYPTO_LZO=m
 CONFIG_CRYPTO_842=m
 CONFIG_CRYPTO_LZ4=m
 CONFIG_CRYPTO_LZ4HC=m
 CONFIG_CRYPTO_ZSTD=m
-CONFIG_CRYPTO_ANSI_CPRNG=m
 CONFIG_CRYPTO_DRBG_HASH=y
 CONFIG_CRYPTO_DRBG_CTR=y
 CONFIG_CRYPTO_USER_API_HASH=m
 CONFIG_CRYPTO_USER_API_SKCIPHER=m
 CONFIG_CRYPTO_USER_API_RNG=m
diff --git a/arch/m68k/configs/atari_defconfig b/arch/m68k/configs/atari_defconfig
index 471f4ec3730d..9edcafbe5cd2 100644
--- a/arch/m68k/configs/atari_defconfig
+++ b/arch/m68k/configs/atari_defconfig
@@ -566,11 +566,10 @@ CONFIG_CRYPTO_XCBC=m
 CONFIG_CRYPTO_LZO=m
 CONFIG_CRYPTO_842=m
 CONFIG_CRYPTO_LZ4=m
 CONFIG_CRYPTO_LZ4HC=m
 CONFIG_CRYPTO_ZSTD=m
-CONFIG_CRYPTO_ANSI_CPRNG=m
 CONFIG_CRYPTO_DRBG_HASH=y
 CONFIG_CRYPTO_DRBG_CTR=y
 CONFIG_CRYPTO_USER_API_HASH=m
 CONFIG_CRYPTO_USER_API_SKCIPHER=m
 CONFIG_CRYPTO_USER_API_RNG=m
diff --git a/arch/m68k/configs/bvme6000_defconfig b/arch/m68k/configs/bvme6000_defconfig
index 28492ef51457..516984ec3f93 100644
--- a/arch/m68k/configs/bvme6000_defconfig
+++ b/arch/m68k/configs/bvme6000_defconfig
@@ -538,11 +538,10 @@ CONFIG_CRYPTO_XCBC=m
 CONFIG_CRYPTO_LZO=m
 CONFIG_CRYPTO_842=m
 CONFIG_CRYPTO_LZ4=m
 CONFIG_CRYPTO_LZ4HC=m
 CONFIG_CRYPTO_ZSTD=m
-CONFIG_CRYPTO_ANSI_CPRNG=m
 CONFIG_CRYPTO_DRBG_HASH=y
 CONFIG_CRYPTO_DRBG_CTR=y
 CONFIG_CRYPTO_USER_API_HASH=m
 CONFIG_CRYPTO_USER_API_SKCIPHER=m
 CONFIG_CRYPTO_USER_API_RNG=m
diff --git a/arch/m68k/configs/hp300_defconfig b/arch/m68k/configs/hp300_defconfig
index 2fbefb16b72e..689e0179b763 100644
--- a/arch/m68k/configs/hp300_defconfig
+++ b/arch/m68k/configs/hp300_defconfig
@@ -548,11 +548,10 @@ CONFIG_CRYPTO_XCBC=m
 CONFIG_CRYPTO_LZO=m
 CONFIG_CRYPTO_842=m
 CONFIG_CRYPTO_LZ4=m
 CONFIG_CRYPTO_LZ4HC=m
 CONFIG_CRYPTO_ZSTD=m
-CONFIG_CRYPTO_ANSI_CPRNG=m
 CONFIG_CRYPTO_DRBG_HASH=y
 CONFIG_CRYPTO_DRBG_CTR=y
 CONFIG_CRYPTO_USER_API_HASH=m
 CONFIG_CRYPTO_USER_API_SKCIPHER=m
 CONFIG_CRYPTO_USER_API_RNG=m
diff --git a/arch/m68k/configs/mac_defconfig b/arch/m68k/configs/mac_defconfig
index deec5df3f35a..1ab00a8041f8 100644
--- a/arch/m68k/configs/mac_defconfig
+++ b/arch/m68k/configs/mac_defconfig
@@ -565,11 +565,10 @@ CONFIG_CRYPTO_XCBC=m
 CONFIG_CRYPTO_LZO=m
 CONFIG_CRYPTO_842=m
 CONFIG_CRYPTO_LZ4=m
 CONFIG_CRYPTO_LZ4HC=m
 CONFIG_CRYPTO_ZSTD=m
-CONFIG_CRYPTO_ANSI_CPRNG=m
 CONFIG_CRYPTO_DRBG_HASH=y
 CONFIG_CRYPTO_DRBG_CTR=y
 CONFIG_CRYPTO_USER_API_HASH=m
 CONFIG_CRYPTO_USER_API_SKCIPHER=m
 CONFIG_CRYPTO_USER_API_RNG=m
diff --git a/arch/m68k/configs/multi_defconfig b/arch/m68k/configs/multi_defconfig
index 301a05c12577..2520e9b222c5 100644
--- a/arch/m68k/configs/multi_defconfig
+++ b/arch/m68k/configs/multi_defconfig
@@ -652,11 +652,10 @@ CONFIG_CRYPTO_XCBC=m
 CONFIG_CRYPTO_LZO=m
 CONFIG_CRYPTO_842=m
 CONFIG_CRYPTO_LZ4=m
 CONFIG_CRYPTO_LZ4HC=m
 CONFIG_CRYPTO_ZSTD=m
-CONFIG_CRYPTO_ANSI_CPRNG=m
 CONFIG_CRYPTO_DRBG_HASH=y
 CONFIG_CRYPTO_DRBG_CTR=y
 CONFIG_CRYPTO_USER_API_HASH=m
 CONFIG_CRYPTO_USER_API_SKCIPHER=m
 CONFIG_CRYPTO_USER_API_RNG=m
diff --git a/arch/m68k/configs/mvme147_defconfig b/arch/m68k/configs/mvme147_defconfig
index 0d401db0e8f8..5b28388b13a5 100644
--- a/arch/m68k/configs/mvme147_defconfig
+++ b/arch/m68k/configs/mvme147_defconfig
@@ -538,11 +538,10 @@ CONFIG_CRYPTO_XCBC=m
 CONFIG_CRYPTO_LZO=m
 CONFIG_CRYPTO_842=m
 CONFIG_CRYPTO_LZ4=m
 CONFIG_CRYPTO_LZ4HC=m
 CONFIG_CRYPTO_ZSTD=m
-CONFIG_CRYPTO_ANSI_CPRNG=m
 CONFIG_CRYPTO_DRBG_HASH=y
 CONFIG_CRYPTO_DRBG_CTR=y
 CONFIG_CRYPTO_USER_API_HASH=m
 CONFIG_CRYPTO_USER_API_SKCIPHER=m
 CONFIG_CRYPTO_USER_API_RNG=m
diff --git a/arch/m68k/configs/mvme16x_defconfig b/arch/m68k/configs/mvme16x_defconfig
index 90fb5b6bcf83..ab71f83efef2 100644
--- a/arch/m68k/configs/mvme16x_defconfig
+++ b/arch/m68k/configs/mvme16x_defconfig
@@ -539,11 +539,10 @@ CONFIG_CRYPTO_XCBC=m
 CONFIG_CRYPTO_LZO=m
 CONFIG_CRYPTO_842=m
 CONFIG_CRYPTO_LZ4=m
 CONFIG_CRYPTO_LZ4HC=m
 CONFIG_CRYPTO_ZSTD=m
-CONFIG_CRYPTO_ANSI_CPRNG=m
 CONFIG_CRYPTO_DRBG_HASH=y
 CONFIG_CRYPTO_DRBG_CTR=y
 CONFIG_CRYPTO_USER_API_HASH=m
 CONFIG_CRYPTO_USER_API_SKCIPHER=m
 CONFIG_CRYPTO_USER_API_RNG=m
diff --git a/arch/m68k/configs/q40_defconfig b/arch/m68k/configs/q40_defconfig
index b89b0f7fe2da..25d7f98c76a4 100644
--- a/arch/m68k/configs/q40_defconfig
+++ b/arch/m68k/configs/q40_defconfig
@@ -555,11 +555,10 @@ CONFIG_CRYPTO_XCBC=m
 CONFIG_CRYPTO_LZO=m
 CONFIG_CRYPTO_842=m
 CONFIG_CRYPTO_LZ4=m
 CONFIG_CRYPTO_LZ4HC=m
 CONFIG_CRYPTO_ZSTD=m
-CONFIG_CRYPTO_ANSI_CPRNG=m
 CONFIG_CRYPTO_DRBG_HASH=y
 CONFIG_CRYPTO_DRBG_CTR=y
 CONFIG_CRYPTO_USER_API_HASH=m
 CONFIG_CRYPTO_USER_API_SKCIPHER=m
 CONFIG_CRYPTO_USER_API_RNG=m
diff --git a/arch/m68k/configs/stmark2_defconfig b/arch/m68k/configs/stmark2_defconfig
index 7787a4dd7c3c..70637b6ddbdd 100644
--- a/arch/m68k/configs/stmark2_defconfig
+++ b/arch/m68k/configs/stmark2_defconfig
@@ -82,11 +82,10 @@ CONFIG_OVERLAY_FS=y
 CONFIG_FSCACHE=y
 # CONFIG_PROC_SYSCTL is not set
 CONFIG_CRAMFS=y
 CONFIG_SQUASHFS=y
 CONFIG_ROMFS_FS=y
-CONFIG_CRYPTO_ANSI_CPRNG=y
 # CONFIG_CRYPTO_HW is not set
 CONFIG_PRINTK_TIME=y
 # CONFIG_DEBUG_BUGVERBOSE is not set
 # CONFIG_SECTION_MISMATCH_WARN_ONLY is not set
 CONFIG_SLUB_DEBUG_ON=y
diff --git a/arch/m68k/configs/sun3_defconfig b/arch/m68k/configs/sun3_defconfig
index 8cc372c4df72..7dd129b3e767 100644
--- a/arch/m68k/configs/sun3_defconfig
+++ b/arch/m68k/configs/sun3_defconfig
@@ -536,11 +536,10 @@ CONFIG_CRYPTO_XCBC=m
 CONFIG_CRYPTO_LZO=m
 CONFIG_CRYPTO_842=m
 CONFIG_CRYPTO_LZ4=m
 CONFIG_CRYPTO_LZ4HC=m
 CONFIG_CRYPTO_ZSTD=m
-CONFIG_CRYPTO_ANSI_CPRNG=m
 CONFIG_CRYPTO_DRBG_HASH=y
 CONFIG_CRYPTO_DRBG_CTR=y
 CONFIG_CRYPTO_USER_API_HASH=m
 CONFIG_CRYPTO_USER_API_SKCIPHER=m
 CONFIG_CRYPTO_USER_API_RNG=m
diff --git a/arch/m68k/configs/sun3x_defconfig b/arch/m68k/configs/sun3x_defconfig
index f4569f64c6e4..217cf847051d 100644
--- a/arch/m68k/configs/sun3x_defconfig
+++ b/arch/m68k/configs/sun3x_defconfig
@@ -536,11 +536,10 @@ CONFIG_CRYPTO_XCBC=m
 CONFIG_CRYPTO_LZO=m
 CONFIG_CRYPTO_842=m
 CONFIG_CRYPTO_LZ4=m
 CONFIG_CRYPTO_LZ4HC=m
 CONFIG_CRYPTO_ZSTD=m
-CONFIG_CRYPTO_ANSI_CPRNG=m
 CONFIG_CRYPTO_DRBG_HASH=y
 CONFIG_CRYPTO_DRBG_CTR=y
 CONFIG_CRYPTO_USER_API_HASH=m
 CONFIG_CRYPTO_USER_API_SKCIPHER=m
 CONFIG_CRYPTO_USER_API_RNG=m
diff --git a/arch/mips/configs/decstation_64_defconfig b/arch/mips/configs/decstation_64_defconfig
index 85a4472cb058..b738c4c28c28 100644
--- a/arch/mips/configs/decstation_64_defconfig
+++ b/arch/mips/configs/decstation_64_defconfig
@@ -198,11 +198,10 @@ CONFIG_CRYPTO_TEA=m
 CONFIG_CRYPTO_TWOFISH=m
 CONFIG_CRYPTO_LZO=m
 CONFIG_CRYPTO_842=m
 CONFIG_CRYPTO_LZ4=m
 CONFIG_CRYPTO_LZ4HC=m
-CONFIG_CRYPTO_ANSI_CPRNG=m
 CONFIG_CRYPTO_DRBG_HASH=y
 CONFIG_CRYPTO_DRBG_CTR=y
 # CONFIG_CRYPTO_HW is not set
 CONFIG_MAGIC_SYSRQ=y
 # CONFIG_FTRACE is not set
diff --git a/arch/mips/configs/decstation_defconfig b/arch/mips/configs/decstation_defconfig
index a3b2c8da2dde..60b87cf63df3 100644
--- a/arch/mips/configs/decstation_defconfig
+++ b/arch/mips/configs/decstation_defconfig
@@ -193,11 +193,10 @@ CONFIG_CRYPTO_TEA=m
 CONFIG_CRYPTO_TWOFISH=m
 CONFIG_CRYPTO_LZO=m
 CONFIG_CRYPTO_842=m
 CONFIG_CRYPTO_LZ4=m
 CONFIG_CRYPTO_LZ4HC=m
-CONFIG_CRYPTO_ANSI_CPRNG=m
 CONFIG_CRYPTO_DRBG_HASH=y
 CONFIG_CRYPTO_DRBG_CTR=y
 # CONFIG_CRYPTO_HW is not set
 CONFIG_FRAME_WARN=2048
 CONFIG_MAGIC_SYSRQ=y
diff --git a/arch/mips/configs/decstation_r4k_defconfig b/arch/mips/configs/decstation_r4k_defconfig
index a476717b8a6a..ef2d18bc593a 100644
--- a/arch/mips/configs/decstation_r4k_defconfig
+++ b/arch/mips/configs/decstation_r4k_defconfig
@@ -193,11 +193,10 @@ CONFIG_CRYPTO_TEA=m
 CONFIG_CRYPTO_TWOFISH=m
 CONFIG_CRYPTO_LZO=m
 CONFIG_CRYPTO_842=m
 CONFIG_CRYPTO_LZ4=m
 CONFIG_CRYPTO_LZ4HC=m
-CONFIG_CRYPTO_ANSI_CPRNG=m
 CONFIG_CRYPTO_DRBG_HASH=y
 CONFIG_CRYPTO_DRBG_CTR=y
 # CONFIG_CRYPTO_HW is not set
 CONFIG_FRAME_WARN=2048
 CONFIG_MAGIC_SYSRQ=y
diff --git a/arch/s390/configs/debug_defconfig b/arch/s390/configs/debug_defconfig
index b31c1df90257..38781f69a51b 100644
--- a/arch/s390/configs/debug_defconfig
+++ b/arch/s390/configs/debug_defconfig
@@ -798,11 +798,10 @@ CONFIG_CRYPTO_XCBC=m
 CONFIG_CRYPTO_CRC32=m
 CONFIG_CRYPTO_842=m
 CONFIG_CRYPTO_LZ4=m
 CONFIG_CRYPTO_LZ4HC=m
 CONFIG_CRYPTO_ZSTD=m
-CONFIG_CRYPTO_ANSI_CPRNG=m
 CONFIG_CRYPTO_USER_API_HASH=m
 CONFIG_CRYPTO_USER_API_SKCIPHER=m
 CONFIG_CRYPTO_USER_API_RNG=m
 CONFIG_CRYPTO_USER_API_AEAD=m
 CONFIG_CRYPTO_SHA3_256_S390=m
diff --git a/arch/s390/configs/defconfig b/arch/s390/configs/defconfig
index 161dad7ef211..3fe746c15281 100644
--- a/arch/s390/configs/defconfig
+++ b/arch/s390/configs/defconfig
@@ -782,11 +782,10 @@ CONFIG_CRYPTO_XCBC=m
 CONFIG_CRYPTO_CRC32=m
 CONFIG_CRYPTO_842=m
 CONFIG_CRYPTO_LZ4=m
 CONFIG_CRYPTO_LZ4HC=m
 CONFIG_CRYPTO_ZSTD=m
-CONFIG_CRYPTO_ANSI_CPRNG=m
 CONFIG_CRYPTO_JITTERENTROPY_OSR=1
 CONFIG_CRYPTO_USER_API_HASH=m
 CONFIG_CRYPTO_USER_API_SKCIPHER=m
 CONFIG_CRYPTO_USER_API_RNG=m
 CONFIG_CRYPTO_USER_API_AEAD=m
diff --git a/arch/sh/configs/ap325rxa_defconfig b/arch/sh/configs/ap325rxa_defconfig
index b6f36c938f1d..fe053a0d85d0 100644
--- a/arch/sh/configs/ap325rxa_defconfig
+++ b/arch/sh/configs/ap325rxa_defconfig
@@ -96,6 +96,5 @@ CONFIG_NLS_CODEPAGE_437=y
 CONFIG_NLS_CODEPAGE_932=y
 CONFIG_NLS_ISO8859_1=y
 # CONFIG_ENABLE_MUST_CHECK is not set
 CONFIG_CRYPTO=y
 CONFIG_CRYPTO_CBC=y
-# CONFIG_CRYPTO_ANSI_CPRNG is not set
diff --git a/arch/sh/configs/apsh4a3a_defconfig b/arch/sh/configs/apsh4a3a_defconfig
index 9c2644443c4d..c9e711dac7cb 100644
--- a/arch/sh/configs/apsh4a3a_defconfig
+++ b/arch/sh/configs/apsh4a3a_defconfig
@@ -85,7 +85,6 @@ CONFIG_DEBUG_FS=y
 CONFIG_DEBUG_KERNEL=y
 # CONFIG_DEBUG_PREEMPT is not set
 # CONFIG_DEBUG_BUGVERBOSE is not set
 CONFIG_DEBUG_INFO_DWARF_TOOLCHAIN_DEFAULT=y
 # CONFIG_FTRACE is not set
-# CONFIG_CRYPTO_ANSI_CPRNG is not set
 # CONFIG_CRYPTO_HW is not set
diff --git a/arch/sh/configs/apsh4ad0a_defconfig b/arch/sh/configs/apsh4ad0a_defconfig
index 137573610ec4..e3f524692cff 100644
--- a/arch/sh/configs/apsh4ad0a_defconfig
+++ b/arch/sh/configs/apsh4ad0a_defconfig
@@ -115,6 +115,5 @@ CONFIG_DEBUG_KERNEL=y
 CONFIG_DEBUG_SHIRQ=y
 CONFIG_DETECT_HUNG_TASK=y
 CONFIG_DEBUG_INFO_DWARF_TOOLCHAIN_DEFAULT=y
 CONFIG_DEBUG_VM=y
 CONFIG_DWARF_UNWINDER=y
-# CONFIG_CRYPTO_ANSI_CPRNG is not set
diff --git a/arch/sh/configs/dreamcast_defconfig b/arch/sh/configs/dreamcast_defconfig
index 0c9f2030bb7c..4573d5d64989 100644
--- a/arch/sh/configs/dreamcast_defconfig
+++ b/arch/sh/configs/dreamcast_defconfig
@@ -64,8 +64,7 @@ CONFIG_LOGO=y
 # CONFIG_LOGO_SUPERH_VGA16 is not set
 # CONFIG_DNOTIFY is not set
 CONFIG_PROC_KCORE=y
 CONFIG_TMPFS=y
 CONFIG_HUGETLBFS=y
-# CONFIG_CRYPTO_ANSI_CPRNG is not set
 CONFIG_RTC_CLASS=y
 CONFIG_RTC_DRV_GENERIC=y
diff --git a/arch/sh/configs/ecovec24_defconfig b/arch/sh/configs/ecovec24_defconfig
index e76694aace25..9475c19a3d97 100644
--- a/arch/sh/configs/ecovec24_defconfig
+++ b/arch/sh/configs/ecovec24_defconfig
@@ -125,6 +125,5 @@ CONFIG_NLS_CODEPAGE_932=y
 CONFIG_NLS_ISO8859_1=y
 # CONFIG_ENABLE_MUST_CHECK is not set
 CONFIG_DEBUG_FS=y
 CONFIG_CRYPTO=y
 CONFIG_CRYPTO_CBC=y
-# CONFIG_CRYPTO_ANSI_CPRNG is not set
diff --git a/arch/sh/configs/edosk7760_defconfig b/arch/sh/configs/edosk7760_defconfig
index f427a95bcd21..368cf25e87a4 100644
--- a/arch/sh/configs/edosk7760_defconfig
+++ b/arch/sh/configs/edosk7760_defconfig
@@ -109,6 +109,5 @@ CONFIG_DETECT_HUNG_TASK=y
 CONFIG_TIMER_STATS=y
 CONFIG_DEBUG_INFO_DWARF_TOOLCHAIN_DEFAULT=y
 CONFIG_CRYPTO=y
 CONFIG_CRYPTO_MD5=y
 CONFIG_CRYPTO_DES=y
-# CONFIG_CRYPTO_ANSI_CPRNG is not set
diff --git a/arch/sh/configs/espt_defconfig b/arch/sh/configs/espt_defconfig
index da176f100e00..8c83d20e6f6f 100644
--- a/arch/sh/configs/espt_defconfig
+++ b/arch/sh/configs/espt_defconfig
@@ -107,6 +107,5 @@ CONFIG_NLS_ISO8859_15=y
 CONFIG_NLS_KOI8_R=y
 CONFIG_NLS_KOI8_U=y
 CONFIG_NLS_UTF8=y
 # CONFIG_ENABLE_MUST_CHECK is not set
 CONFIG_DEBUG_FS=y
-# CONFIG_CRYPTO_ANSI_CPRNG is not set
diff --git a/arch/sh/configs/hp6xx_defconfig b/arch/sh/configs/hp6xx_defconfig
index 3582af15ad86..04a9fcb4342a 100644
--- a/arch/sh/configs/hp6xx_defconfig
+++ b/arch/sh/configs/hp6xx_defconfig
@@ -52,7 +52,6 @@ CONFIG_NLS_CODEPAGE_850=y
 CONFIG_CRYPTO=y
 CONFIG_CRYPTO_CBC=y
 CONFIG_CRYPTO_ECB=y
 CONFIG_CRYPTO_PCBC=y
 CONFIG_CRYPTO_MD5=y
-# CONFIG_CRYPTO_ANSI_CPRNG is not set
 # CONFIG_CRYPTO_HW is not set
diff --git a/arch/sh/configs/landisk_defconfig b/arch/sh/configs/landisk_defconfig
index 924bb3233b0b..7899cb92d87d 100644
--- a/arch/sh/configs/landisk_defconfig
+++ b/arch/sh/configs/landisk_defconfig
@@ -108,6 +108,5 @@ CONFIG_NFS_V3=y
 CONFIG_NFSD=m
 CONFIG_SMB_FS=m
 CONFIG_NLS_CODEPAGE_437=y
 CONFIG_NLS_CODEPAGE_932=y
 CONFIG_SH_STANDARD_BIOS=y
-# CONFIG_CRYPTO_ANSI_CPRNG is not set
diff --git a/arch/sh/configs/lboxre2_defconfig b/arch/sh/configs/lboxre2_defconfig
index 0307bb2be79f..f58714ea4b1d 100644
--- a/arch/sh/configs/lboxre2_defconfig
+++ b/arch/sh/configs/lboxre2_defconfig
@@ -55,6 +55,5 @@ CONFIG_MSDOS_FS=y
 CONFIG_VFAT_FS=y
 CONFIG_TMPFS=y
 CONFIG_ROMFS_FS=y
 CONFIG_NLS_CODEPAGE_437=y
 CONFIG_SH_STANDARD_BIOS=y
-# CONFIG_CRYPTO_ANSI_CPRNG is not set
diff --git a/arch/sh/configs/migor_defconfig b/arch/sh/configs/migor_defconfig
index 31dbd8888aaa..7cdaa909ffd6 100644
--- a/arch/sh/configs/migor_defconfig
+++ b/arch/sh/configs/migor_defconfig
@@ -85,7 +85,6 @@ CONFIG_UIO_PDRV_GENIRQ=y
 CONFIG_PROC_KCORE=y
 CONFIG_TMPFS=y
 CONFIG_NFS_FS=y
 CONFIG_ROOT_NFS=y
 CONFIG_DEBUG_FS=y
-# CONFIG_CRYPTO_ANSI_CPRNG is not set
 # CONFIG_CRYPTO_HW is not set
diff --git a/arch/sh/configs/r7780mp_defconfig b/arch/sh/configs/r7780mp_defconfig
index f28b8c4181c2..f268d206a5b1 100644
--- a/arch/sh/configs/r7780mp_defconfig
+++ b/arch/sh/configs/r7780mp_defconfig
@@ -102,6 +102,5 @@ CONFIG_DETECT_HUNG_TASK=y
 # CONFIG_DEBUG_PREEMPT is not set
 CONFIG_DEBUG_INFO_DWARF_TOOLCHAIN_DEFAULT=y
 CONFIG_CRYPTO_ECB=m
 CONFIG_CRYPTO_PCBC=m
 CONFIG_CRYPTO_HMAC=y
-# CONFIG_CRYPTO_ANSI_CPRNG is not set
diff --git a/arch/sh/configs/r7785rp_defconfig b/arch/sh/configs/r7785rp_defconfig
index 3a4239f20ff1..dbbd1661ac0f 100644
--- a/arch/sh/configs/r7785rp_defconfig
+++ b/arch/sh/configs/r7785rp_defconfig
@@ -100,6 +100,5 @@ CONFIG_SH_STANDARD_BIOS=y
 CONFIG_DEBUG_STACK_USAGE=y
 CONFIG_4KSTACKS=y
 CONFIG_CRYPTO_ECB=m
 CONFIG_CRYPTO_PCBC=m
 CONFIG_CRYPTO_HMAC=y
-# CONFIG_CRYPTO_ANSI_CPRNG is not set
diff --git a/arch/sh/configs/rts7751r2d1_defconfig b/arch/sh/configs/rts7751r2d1_defconfig
index 69568cc40396..0c54ab2b06e6 100644
--- a/arch/sh/configs/rts7751r2d1_defconfig
+++ b/arch/sh/configs/rts7751r2d1_defconfig
@@ -84,6 +84,5 @@ CONFIG_VFAT_FS=y
 CONFIG_PROC_KCORE=y
 CONFIG_TMPFS=y
 CONFIG_MINIX_FS=y
 CONFIG_NLS_CODEPAGE_932=y
 CONFIG_DEBUG_FS=y
-# CONFIG_CRYPTO_ANSI_CPRNG is not set
diff --git a/arch/sh/configs/rts7751r2dplus_defconfig b/arch/sh/configs/rts7751r2dplus_defconfig
index ecb4bdb5bb58..3173b616b2cb 100644
--- a/arch/sh/configs/rts7751r2dplus_defconfig
+++ b/arch/sh/configs/rts7751r2dplus_defconfig
@@ -89,6 +89,5 @@ CONFIG_VFAT_FS=y
 CONFIG_PROC_KCORE=y
 CONFIG_TMPFS=y
 CONFIG_MINIX_FS=y
 CONFIG_NLS_CODEPAGE_932=y
 CONFIG_DEBUG_FS=y
-# CONFIG_CRYPTO_ANSI_CPRNG is not set
diff --git a/arch/sh/configs/sdk7780_defconfig b/arch/sh/configs/sdk7780_defconfig
index 9870d16d9711..98cf3e20ddec 100644
--- a/arch/sh/configs/sdk7780_defconfig
+++ b/arch/sh/configs/sdk7780_defconfig
@@ -133,6 +133,5 @@ CONFIG_DETECT_HUNG_TASK=y
 CONFIG_TIMER_STATS=y
 CONFIG_DEBUG_INFO_DWARF_TOOLCHAIN_DEFAULT=y
 CONFIG_SH_STANDARD_BIOS=y
 CONFIG_CRYPTO_MD5=y
 CONFIG_CRYPTO_DES=y
-# CONFIG_CRYPTO_ANSI_CPRNG is not set
diff --git a/arch/sh/configs/sdk7786_defconfig b/arch/sh/configs/sdk7786_defconfig
index 07894f13441e..2803a8e9c3b4 100644
--- a/arch/sh/configs/sdk7786_defconfig
+++ b/arch/sh/configs/sdk7786_defconfig
@@ -210,6 +210,5 @@ CONFIG_LATENCYTOP=y
 CONFIG_FUNCTION_TRACER=y
 # CONFIG_FUNCTION_GRAPH_TRACER is not set
 CONFIG_DMA_API_DEBUG=y
 CONFIG_DEBUG_STACK_USAGE=y
 CONFIG_DWARF_UNWINDER=y
-# CONFIG_CRYPTO_ANSI_CPRNG is not set
diff --git a/arch/sh/configs/se7206_defconfig b/arch/sh/configs/se7206_defconfig
index 64f9308ee586..d67158f69c52 100644
--- a/arch/sh/configs/se7206_defconfig
+++ b/arch/sh/configs/se7206_defconfig
@@ -97,7 +97,6 @@ CONFIG_DEBUG_VM=y
 CONFIG_DEBUG_LIST=y
 CONFIG_FRAME_POINTER=y
 CONFIG_DEBUG_STACK_USAGE=y
 CONFIG_CRYPTO_DEFLATE=y
 CONFIG_CRYPTO_LZO=y
-# CONFIG_CRYPTO_ANSI_CPRNG is not set
 # CONFIG_CRYPTO_HW is not set
diff --git a/arch/sh/configs/se7343_defconfig b/arch/sh/configs/se7343_defconfig
index 75db12fb9ad1..4e7b4364757d 100644
--- a/arch/sh/configs/se7343_defconfig
+++ b/arch/sh/configs/se7343_defconfig
@@ -90,6 +90,5 @@ CONFIG_EXT3_FS=y
 CONFIG_JFFS2_FS=y
 CONFIG_CRAMFS=y
 CONFIG_NFS_FS=y
 CONFIG_NFS_V3=y
 CONFIG_NFSD=y
-# CONFIG_CRYPTO_ANSI_CPRNG is not set
diff --git a/arch/sh/configs/se7705_defconfig b/arch/sh/configs/se7705_defconfig
index 1752ddc2694a..ad55a4d9d57d 100644
--- a/arch/sh/configs/se7705_defconfig
+++ b/arch/sh/configs/se7705_defconfig
@@ -49,6 +49,5 @@ CONFIG_EXT2_FS=y
 CONFIG_PROC_KCORE=y
 # CONFIG_SYSFS is not set
 CONFIG_JFFS2_FS=y
 CONFIG_NFS_FS=y
 CONFIG_ROOT_NFS=y
-# CONFIG_CRYPTO_ANSI_CPRNG is not set
diff --git a/arch/sh/configs/se7712_defconfig b/arch/sh/configs/se7712_defconfig
index 8770a72e6a63..11d390801d5f 100644
--- a/arch/sh/configs/se7712_defconfig
+++ b/arch/sh/configs/se7712_defconfig
@@ -93,6 +93,5 @@ CONFIG_ROOT_NFS=y
 CONFIG_DEBUG_KERNEL=y
 CONFIG_DEBUG_INFO_DWARF_TOOLCHAIN_DEFAULT=y
 CONFIG_FRAME_POINTER=y
 CONFIG_CRYPTO_ECB=m
 CONFIG_CRYPTO_PCBC=m
-# CONFIG_CRYPTO_ANSI_CPRNG is not set
diff --git a/arch/sh/configs/se7721_defconfig b/arch/sh/configs/se7721_defconfig
index b15c6406a0e8..a31008d0d513 100644
--- a/arch/sh/configs/se7721_defconfig
+++ b/arch/sh/configs/se7721_defconfig
@@ -119,6 +119,5 @@ CONFIG_NLS_CODEPAGE_437=y
 CONFIG_NLS_CODEPAGE_932=y
 CONFIG_NLS_ISO8859_1=y
 CONFIG_DEBUG_KERNEL=y
 CONFIG_DEBUG_INFO_DWARF_TOOLCHAIN_DEFAULT=y
 CONFIG_FRAME_POINTER=y
-# CONFIG_CRYPTO_ANSI_CPRNG is not set
diff --git a/arch/sh/configs/se7722_defconfig b/arch/sh/configs/se7722_defconfig
index 5327a2f70980..37239ec2753c 100644
--- a/arch/sh/configs/se7722_defconfig
+++ b/arch/sh/configs/se7722_defconfig
@@ -52,6 +52,5 @@ CONFIG_HUGETLBFS=y
 CONFIG_PRINTK_TIME=y
 # CONFIG_ENABLE_MUST_CHECK is not set
 CONFIG_MAGIC_SYSRQ=y
 CONFIG_DEBUG_FS=y
 CONFIG_SH_STANDARD_BIOS=y
-# CONFIG_CRYPTO_ANSI_CPRNG is not set
diff --git a/arch/sh/configs/se7724_defconfig b/arch/sh/configs/se7724_defconfig
index 9501e69eb886..4b62bb860e67 100644
--- a/arch/sh/configs/se7724_defconfig
+++ b/arch/sh/configs/se7724_defconfig
@@ -125,6 +125,5 @@ CONFIG_NLS_CODEPAGE_437=y
 CONFIG_NLS_CODEPAGE_932=y
 CONFIG_NLS_ISO8859_1=y
 # CONFIG_ENABLE_MUST_CHECK is not set
 CONFIG_CRYPTO=y
 CONFIG_CRYPTO_CBC=y
-# CONFIG_CRYPTO_ANSI_CPRNG is not set
diff --git a/arch/sh/configs/se7750_defconfig b/arch/sh/configs/se7750_defconfig
index a1e25d7de8a6..83ae513e5462 100644
--- a/arch/sh/configs/se7750_defconfig
+++ b/arch/sh/configs/se7750_defconfig
@@ -50,6 +50,5 @@ CONFIG_JFFS2_FS=y
 CONFIG_NFS_FS=y
 CONFIG_ROOT_NFS=y
 CONFIG_PARTITION_ADVANCED=y
 # CONFIG_MSDOS_PARTITION is not set
 # CONFIG_ENABLE_MUST_CHECK is not set
-# CONFIG_CRYPTO_ANSI_CPRNG is not set
diff --git a/arch/sh/configs/se7751_defconfig b/arch/sh/configs/se7751_defconfig
index 8b5fe4ec16bc..8f5ddab3c106 100644
--- a/arch/sh/configs/se7751_defconfig
+++ b/arch/sh/configs/se7751_defconfig
@@ -40,6 +40,5 @@ CONFIG_HW_RANDOM=y
 CONFIG_WATCHDOG=y
 CONFIG_EXT2_FS=y
 CONFIG_PROC_KCORE=y
 CONFIG_TMPFS=y
 CONFIG_JFFS2_FS=y
-# CONFIG_CRYPTO_ANSI_CPRNG is not set
diff --git a/arch/sh/configs/se7780_defconfig b/arch/sh/configs/se7780_defconfig
index 21303304eda2..12463b766120 100644
--- a/arch/sh/configs/se7780_defconfig
+++ b/arch/sh/configs/se7780_defconfig
@@ -100,6 +100,5 @@ CONFIG_TMPFS=y
 CONFIG_CRAMFS=y
 CONFIG_NFS_FS=y
 CONFIG_NFS_V3=y
 CONFIG_ROOT_NFS=y
 CONFIG_DEBUG_FS=y
-# CONFIG_CRYPTO_ANSI_CPRNG is not set
diff --git a/arch/sh/configs/sh03_defconfig b/arch/sh/configs/sh03_defconfig
index 4d75c92cac10..518526dfdfad 100644
--- a/arch/sh/configs/sh03_defconfig
+++ b/arch/sh/configs/sh03_defconfig
@@ -117,8 +117,7 @@ CONFIG_DEBUG_FS=y
 CONFIG_SH_STANDARD_BIOS=y
 CONFIG_CRYPTO_ECB=m
 CONFIG_CRYPTO_HMAC=y
 CONFIG_CRYPTO_SHA1=y
 CONFIG_CRYPTO_DEFLATE=y
-# CONFIG_CRYPTO_ANSI_CPRNG is not set
 CONFIG_RTC_CLASS=y
 CONFIG_RTC_DRV_GENERIC=y
diff --git a/arch/sh/configs/sh2007_defconfig b/arch/sh/configs/sh2007_defconfig
index cc6292b3235a..4e06ea7bcc30 100644
--- a/arch/sh/configs/sh2007_defconfig
+++ b/arch/sh/configs/sh2007_defconfig
@@ -189,7 +189,6 @@ CONFIG_CRYPTO_SEED=y
 CONFIG_CRYPTO_SERPENT=y
 CONFIG_CRYPTO_TEA=y
 CONFIG_CRYPTO_TWOFISH=y
 CONFIG_CRYPTO_DEFLATE=y
 CONFIG_CRYPTO_LZO=y
-# CONFIG_CRYPTO_ANSI_CPRNG is not set
 # CONFIG_CRYPTO_HW is not set
diff --git a/arch/sh/configs/sh7710voipgw_defconfig b/arch/sh/configs/sh7710voipgw_defconfig
index 5b151bb2bc43..c8625ba5be79 100644
--- a/arch/sh/configs/sh7710voipgw_defconfig
+++ b/arch/sh/configs/sh7710voipgw_defconfig
@@ -49,6 +49,5 @@ CONFIG_HW_RANDOM=y
 # CONFIG_HWMON is not set
 CONFIG_THERMAL=y
 # CONFIG_DNOTIFY is not set
 CONFIG_JFFS2_FS=y
 CONFIG_DEBUG_FS=y
-# CONFIG_CRYPTO_ANSI_CPRNG is not set
diff --git a/arch/sh/configs/sh7757lcr_defconfig b/arch/sh/configs/sh7757lcr_defconfig
index 48a0f9beb116..9d2de154765b 100644
--- a/arch/sh/configs/sh7757lcr_defconfig
+++ b/arch/sh/configs/sh7757lcr_defconfig
@@ -79,6 +79,5 @@ CONFIG_NLS_ISO8859_1=y
 CONFIG_DEBUG_KERNEL=y
 # CONFIG_SCHED_DEBUG is not set
 # CONFIG_DEBUG_BUGVERBOSE is not set
 CONFIG_DEBUG_INFO_DWARF_TOOLCHAIN_DEFAULT=y
 # CONFIG_FTRACE is not set
-# CONFIG_CRYPTO_ANSI_CPRNG is not set
diff --git a/arch/sh/configs/sh7763rdp_defconfig b/arch/sh/configs/sh7763rdp_defconfig
index b77b3313157e..394f92bd6416 100644
--- a/arch/sh/configs/sh7763rdp_defconfig
+++ b/arch/sh/configs/sh7763rdp_defconfig
@@ -109,6 +109,5 @@ CONFIG_NLS_ISO8859_15=y
 CONFIG_NLS_KOI8_R=y
 CONFIG_NLS_KOI8_U=y
 CONFIG_NLS_UTF8=y
 # CONFIG_ENABLE_MUST_CHECK is not set
 CONFIG_DEBUG_FS=y
-# CONFIG_CRYPTO_ANSI_CPRNG is not set
diff --git a/arch/sh/configs/sh7785lcr_32bit_defconfig b/arch/sh/configs/sh7785lcr_32bit_defconfig
index 44f9b2317f09..a51f16c079aa 100644
--- a/arch/sh/configs/sh7785lcr_32bit_defconfig
+++ b/arch/sh/configs/sh7785lcr_32bit_defconfig
@@ -143,7 +143,6 @@ CONFIG_DEBUG_MUTEXES=y
 CONFIG_DEBUG_SPINLOCK_SLEEP=y
 CONFIG_DEBUG_INFO_DWARF_TOOLCHAIN_DEFAULT=y
 CONFIG_LATENCYTOP=y
 # CONFIG_FTRACE is not set
 CONFIG_CRYPTO_HMAC=y
-# CONFIG_CRYPTO_ANSI_CPRNG is not set
 # CONFIG_CRYPTO_HW is not set
diff --git a/arch/sh/configs/sh7785lcr_defconfig b/arch/sh/configs/sh7785lcr_defconfig
index aec74b0e7003..389edf8dd99f 100644
--- a/arch/sh/configs/sh7785lcr_defconfig
+++ b/arch/sh/configs/sh7785lcr_defconfig
@@ -111,7 +111,6 @@ CONFIG_NLS_ISO8859_1=y
 # CONFIG_ENABLE_MUST_CHECK is not set
 CONFIG_DEBUG_KERNEL=y
 CONFIG_DETECT_HUNG_TASK=y
 # CONFIG_DEBUG_BUGVERBOSE is not set
 CONFIG_CRYPTO_HMAC=y
-# CONFIG_CRYPTO_ANSI_CPRNG is not set
 # CONFIG_CRYPTO_HW is not set
diff --git a/arch/sh/configs/shmin_defconfig b/arch/sh/configs/shmin_defconfig
index bfeb004f130e..11ac2e66ec7e 100644
--- a/arch/sh/configs/shmin_defconfig
+++ b/arch/sh/configs/shmin_defconfig
@@ -47,6 +47,5 @@ CONFIG_SERIAL_SH_SCI_CONSOLE=y
 CONFIG_CRAMFS=y
 CONFIG_NFS_FS=y
 CONFIG_NFS_V3=y
 CONFIG_ROOT_NFS=y
 CONFIG_SH_STANDARD_BIOS=y
-# CONFIG_CRYPTO_ANSI_CPRNG is not set
diff --git a/arch/sh/configs/shx3_defconfig b/arch/sh/configs/shx3_defconfig
index 9a0df5ea3866..0795ddcc603c 100644
--- a/arch/sh/configs/shx3_defconfig
+++ b/arch/sh/configs/shx3_defconfig
@@ -96,6 +96,5 @@ CONFIG_DEBUG_SHIRQ=y
 CONFIG_DETECT_HUNG_TASK=y
 CONFIG_DEBUG_VM=y
 CONFIG_FRAME_POINTER=y
 CONFIG_SH_STANDARD_BIOS=y
 CONFIG_DEBUG_STACK_USAGE=y
-# CONFIG_CRYPTO_ANSI_CPRNG is not set
diff --git a/arch/sh/configs/titan_defconfig b/arch/sh/configs/titan_defconfig
index 8ef72b8dbcd3..876db502354a 100644
--- a/arch/sh/configs/titan_defconfig
+++ b/arch/sh/configs/titan_defconfig
@@ -260,6 +260,5 @@ CONFIG_CRYPTO_CAST5=m
 CONFIG_CRYPTO_CAST6=m
 CONFIG_CRYPTO_KHAZAD=m
 CONFIG_CRYPTO_SERPENT=m
 CONFIG_CRYPTO_TEA=m
 CONFIG_CRYPTO_TWOFISH=m
-# CONFIG_CRYPTO_ANSI_CPRNG is not set
diff --git a/arch/sh/configs/ul2_defconfig b/arch/sh/configs/ul2_defconfig
index 103b81ec1ffb..8f5235dd96ca 100644
--- a/arch/sh/configs/ul2_defconfig
+++ b/arch/sh/configs/ul2_defconfig
@@ -79,6 +79,5 @@ CONFIG_NFSD=y
 CONFIG_NLS_CODEPAGE_437=y
 CONFIG_NLS_CODEPAGE_932=y
 CONFIG_NLS_ISO8859_1=y
 # CONFIG_ENABLE_MUST_CHECK is not set
 CONFIG_CRYPTO_MICHAEL_MIC=y
-# CONFIG_CRYPTO_ANSI_CPRNG is not set
diff --git a/arch/sh/configs/urquell_defconfig b/arch/sh/configs/urquell_defconfig
index 00ef62133b04..5197ee3167f2 100644
--- a/arch/sh/configs/urquell_defconfig
+++ b/arch/sh/configs/urquell_defconfig
@@ -141,7 +141,6 @@ CONFIG_DETECT_HUNG_TASK=y
 CONFIG_DEBUG_INFO_DWARF_TOOLCHAIN_DEFAULT=y
 CONFIG_FRAME_POINTER=y
 # CONFIG_FTRACE is not set
 # CONFIG_DUMP_CODE is not set
 CONFIG_CRYPTO_HMAC=y
-# CONFIG_CRYPTO_ANSI_CPRNG is not set
 # CONFIG_CRYPTO_HW is not set
diff --git a/arch/sparc/configs/sparc32_defconfig b/arch/sparc/configs/sparc32_defconfig
index f6341b063b01..e021ecfb5a77 100644
--- a/arch/sparc/configs/sparc32_defconfig
+++ b/arch/sparc/configs/sparc32_defconfig
@@ -90,7 +90,6 @@ CONFIG_CRYPTO_ARC4=m
 CONFIG_CRYPTO_BLOWFISH=m
 CONFIG_CRYPTO_CAST5=m
 CONFIG_CRYPTO_CAST6=m
 CONFIG_CRYPTO_SERPENT=m
 CONFIG_CRYPTO_TWOFISH=m
-# CONFIG_CRYPTO_ANSI_CPRNG is not set
 # CONFIG_CRYPTO_HW is not set
diff --git a/arch/sparc/configs/sparc64_defconfig b/arch/sparc/configs/sparc64_defconfig
index 7a7c4dec2925..7e52da881175 100644
--- a/arch/sparc/configs/sparc64_defconfig
+++ b/arch/sparc/configs/sparc64_defconfig
@@ -226,11 +226,10 @@ CONFIG_CRYPTO_FCRYPT=m
 CONFIG_CRYPTO_KHAZAD=m
 CONFIG_CRYPTO_SEED=m
 CONFIG_CRYPTO_SERPENT=m
 CONFIG_CRYPTO_TEA=m
 CONFIG_CRYPTO_TWOFISH=m
-# CONFIG_CRYPTO_ANSI_CPRNG is not set
 CONFIG_VCC=m
 CONFIG_PATA_CMD64X=y
 CONFIG_IP_PNP=y
 CONFIG_IP_PNP_DHCP=y
 CONFIG_DEVTMPFS=y
diff --git a/arch/xtensa/configs/audio_kc705_defconfig b/arch/xtensa/configs/audio_kc705_defconfig
index f2af1a32c9c7..5c14c9fa1fe8 100644
--- a/arch/xtensa/configs/audio_kc705_defconfig
+++ b/arch/xtensa/configs/audio_kc705_defconfig
@@ -131,6 +131,5 @@ CONFIG_DEBUG_MUTEXES=y
 CONFIG_DEBUG_ATOMIC_SLEEP=y
 CONFIG_STACKTRACE=y
 CONFIG_RCU_TRACE=y
 # CONFIG_FTRACE is not set
 # CONFIG_S32C1I_SELFTEST is not set
-CONFIG_CRYPTO_ANSI_CPRNG=y
diff --git a/arch/xtensa/configs/generic_kc705_defconfig b/arch/xtensa/configs/generic_kc705_defconfig
index 4427907becca..836082830c8e 100644
--- a/arch/xtensa/configs/generic_kc705_defconfig
+++ b/arch/xtensa/configs/generic_kc705_defconfig
@@ -119,6 +119,5 @@ CONFIG_DEBUG_ATOMIC_SLEEP=y
 CONFIG_STACKTRACE=y
 CONFIG_RCU_TRACE=y
 # CONFIG_FTRACE is not set
 CONFIG_LD_NO_RELAX=y
 # CONFIG_S32C1I_SELFTEST is not set
-CONFIG_CRYPTO_ANSI_CPRNG=y
diff --git a/arch/xtensa/configs/iss_defconfig b/arch/xtensa/configs/iss_defconfig
index 32ce8fb068f0..324266824fae 100644
--- a/arch/xtensa/configs/iss_defconfig
+++ b/arch/xtensa/configs/iss_defconfig
@@ -26,6 +26,5 @@ CONFIG_SOFT_WATCHDOG=y
 # CONFIG_DNOTIFY is not set
 CONFIG_PROC_KCORE=y
 CONFIG_TMPFS=y
 # CONFIG_FRAME_POINTER is not set
 CONFIG_DETECT_HUNG_TASK=y
-CONFIG_CRYPTO_ANSI_CPRNG=y
diff --git a/arch/xtensa/configs/nommu_kc705_defconfig b/arch/xtensa/configs/nommu_kc705_defconfig
index 5828228522ba..90cf64372518 100644
--- a/arch/xtensa/configs/nommu_kc705_defconfig
+++ b/arch/xtensa/configs/nommu_kc705_defconfig
@@ -120,6 +120,5 @@ CONFIG_DEBUG_ATOMIC_SLEEP=y
 CONFIG_STACKTRACE=y
 CONFIG_RCU_TRACE=y
 # CONFIG_FTRACE is not set
 # CONFIG_LD_NO_RELAX is not set
 # CONFIG_CRYPTO_ECHAINIV is not set
-CONFIG_CRYPTO_ANSI_CPRNG=y
diff --git a/arch/xtensa/configs/smp_lx200_defconfig b/arch/xtensa/configs/smp_lx200_defconfig
index 326966ca7831..9e0112454059 100644
--- a/arch/xtensa/configs/smp_lx200_defconfig
+++ b/arch/xtensa/configs/smp_lx200_defconfig
@@ -123,6 +123,5 @@ CONFIG_DEBUG_ATOMIC_SLEEP=y
 CONFIG_STACKTRACE=y
 CONFIG_RCU_TRACE=y
 # CONFIG_FTRACE is not set
 CONFIG_LD_NO_RELAX=y
 # CONFIG_S32C1I_SELFTEST is not set
-CONFIG_CRYPTO_ANSI_CPRNG=y
diff --git a/arch/xtensa/configs/virt_defconfig b/arch/xtensa/configs/virt_defconfig
index e37048985b47..e2df7db318a2 100644
--- a/arch/xtensa/configs/virt_defconfig
+++ b/arch/xtensa/configs/virt_defconfig
@@ -90,11 +90,10 @@ CONFIG_SUNRPC_DEBUG=y
 CONFIG_NLS_CODEPAGE_437=y
 CONFIG_NLS_ISO8859_1=y
 CONFIG_CRYPTO_ECHAINIV=y
 CONFIG_CRYPTO_DEFLATE=y
 CONFIG_CRYPTO_LZO=y
-CONFIG_CRYPTO_ANSI_CPRNG=y
 CONFIG_CRYPTO_DEV_VIRTIO=y
 CONFIG_FONTS=y
 CONFIG_PRINTK_TIME=y
 CONFIG_DYNAMIC_DEBUG=y
 CONFIG_DEBUG_INFO_DWARF_TOOLCHAIN_DEFAULT=y
diff --git a/arch/xtensa/configs/xip_kc705_defconfig b/arch/xtensa/configs/xip_kc705_defconfig
index ee47438f9b51..9ddb9bf6c5fd 100644
--- a/arch/xtensa/configs/xip_kc705_defconfig
+++ b/arch/xtensa/configs/xip_kc705_defconfig
@@ -96,11 +96,10 @@ CONFIG_SUNRPC_DEBUG=y
 CONFIG_NLS_CODEPAGE_437=y
 CONFIG_NLS_ISO8859_1=y
 CONFIG_CRYPTO_ECHAINIV=y
 CONFIG_CRYPTO_DEFLATE=y
 CONFIG_CRYPTO_LZO=y
-CONFIG_CRYPTO_ANSI_CPRNG=y
 CONFIG_PRINTK_TIME=y
 CONFIG_DYNAMIC_DEBUG=y
 CONFIG_DEBUG_INFO_DWARF_TOOLCHAIN_DEFAULT=y
 CONFIG_MAGIC_SYSRQ=y
 CONFIG_DETECT_HUNG_TASK=y
diff --git a/crypto/Kconfig b/crypto/Kconfig
index b9afd8505b89..a7997759cbd6 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -23,11 +23,11 @@ if CRYPTO
 
 menu "Crypto core or helper"
 
 config CRYPTO_FIPS
 	bool "FIPS 200 compliance"
-	depends on (CRYPTO_ANSI_CPRNG || CRYPTO_DRBG) && CRYPTO_SELFTESTS
+	depends on CRYPTO_DRBG && CRYPTO_SELFTESTS
 	depends on (MODULE_SIG || !MODULES)
 	help
 	  This option enables the fips boot option which is
 	  required if you want the system to operate in a FIPS 200
 	  certification.  You should say no unless you know what
@@ -1167,21 +1167,10 @@ config CRYPTO_ZSTD
 
 endmenu
 
 menu "Random number generation"
 
-config CRYPTO_ANSI_CPRNG
-	tristate "ANSI PRNG (Pseudo Random Number Generator)"
-	select CRYPTO_AES
-	select CRYPTO_RNG
-	help
-	  Pseudo RNG (random number generator) (ANSI X9.31 Appendix A.2.4)
-
-	  This uses the AES cipher algorithm.
-
-	  Note that this option must be enabled if CRYPTO_FIPS is selected
-
 menuconfig CRYPTO_DRBG_MENU
 	tristate "NIST SP800-90A DRBG (Deterministic Random Bit Generator)"
 	help
 	  DRBG (Deterministic Random Bit Generator) (NIST SP800-90A)
 
diff --git a/crypto/Makefile b/crypto/Makefile
index c47f2bf5db61..75e0d9d45795 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -161,11 +161,10 @@ obj-$(CONFIG_CRYPTO_LZO) += lzo.o lzo-rle.o
 obj-$(CONFIG_CRYPTO_LZ4) += lz4.o
 obj-$(CONFIG_CRYPTO_LZ4HC) += lz4hc.o
 obj-$(CONFIG_CRYPTO_XXHASH) += xxhash_generic.o
 obj-$(CONFIG_CRYPTO_842) += 842.o
 obj-$(CONFIG_CRYPTO_RNG2) += rng.o
-obj-$(CONFIG_CRYPTO_ANSI_CPRNG) += ansi_cprng.o
 obj-$(CONFIG_CRYPTO_DRBG) += drbg.o
 obj-$(CONFIG_CRYPTO_JITTERENTROPY) += jitterentropy_rng.o
 CFLAGS_jitterentropy.o = -O0
 KASAN_SANITIZE_jitterentropy.o = n
 UBSAN_SANITIZE_jitterentropy.o = n
diff --git a/crypto/ansi_cprng.c b/crypto/ansi_cprng.c
deleted file mode 100644
index 153523ce6076..000000000000
--- a/crypto/ansi_cprng.c
+++ /dev/null
@@ -1,474 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0-or-later
-/*
- * PRNG: Pseudo Random Number Generator
- *       Based on NIST Recommended PRNG From ANSI X9.31 Appendix A.2.4 using
- *       AES 128 cipher
- *
- *  (C) Neil Horman <nhorman@tuxdriver.com>
- */
-
-#include <crypto/internal/cipher.h>
-#include <crypto/internal/rng.h>
-#include <linux/err.h>
-#include <linux/init.h>
-#include <linux/module.h>
-#include <linux/moduleparam.h>
-#include <linux/string.h>
-
-#define DEFAULT_PRNG_KEY "0123456789abcdef"
-#define DEFAULT_PRNG_KSZ 16
-#define DEFAULT_BLK_SZ 16
-#define DEFAULT_V_SEED "zaybxcwdveuftgsh"
-
-/*
- * Flags for the prng_context flags field
- */
-
-#define PRNG_FIXED_SIZE 0x1
-#define PRNG_NEED_RESET 0x2
-
-/*
- * Note: DT is our counter value
- *	 I is our intermediate value
- *	 V is our seed vector
- * See http://csrc.nist.gov/groups/STM/cavp/documents/rng/931rngext.pdf
- * for implementation details
- */
-
-
-struct prng_context {
-	spinlock_t prng_lock;
-	unsigned char rand_data[DEFAULT_BLK_SZ];
-	unsigned char last_rand_data[DEFAULT_BLK_SZ];
-	unsigned char DT[DEFAULT_BLK_SZ];
-	unsigned char I[DEFAULT_BLK_SZ];
-	unsigned char V[DEFAULT_BLK_SZ];
-	u32 rand_data_valid;
-	struct crypto_cipher *tfm;
-	u32 flags;
-};
-
-static int dbg;
-
-static void hexdump(char *note, unsigned char *buf, unsigned int len)
-{
-	if (dbg) {
-		printk(KERN_CRIT "%s", note);
-		print_hex_dump(KERN_CONT, "", DUMP_PREFIX_OFFSET,
-				16, 1,
-				buf, len, false);
-	}
-}
-
-#define dbgprint(format, args...) do {\
-if (dbg)\
-	printk(format, ##args);\
-} while (0)
-
-static void xor_vectors(unsigned char *in1, unsigned char *in2,
-			unsigned char *out, unsigned int size)
-{
-	int i;
-
-	for (i = 0; i < size; i++)
-		out[i] = in1[i] ^ in2[i];
-
-}
-/*
- * Returns DEFAULT_BLK_SZ bytes of random data per call
- * returns 0 if generation succeeded, <0 if something went wrong
- */
-static int _get_more_prng_bytes(struct prng_context *ctx, int cont_test)
-{
-	int i;
-	unsigned char tmp[DEFAULT_BLK_SZ];
-	unsigned char *output = NULL;
-
-
-	dbgprint(KERN_CRIT "Calling _get_more_prng_bytes for context %p\n",
-		ctx);
-
-	hexdump("Input DT: ", ctx->DT, DEFAULT_BLK_SZ);
-	hexdump("Input I: ", ctx->I, DEFAULT_BLK_SZ);
-	hexdump("Input V: ", ctx->V, DEFAULT_BLK_SZ);
-
-	/*
-	 * This algorithm is a 3 stage state machine
-	 */
-	for (i = 0; i < 3; i++) {
-
-		switch (i) {
-		case 0:
-			/*
-			 * Start by encrypting the counter value
-			 * This gives us an intermediate value I
-			 */
-			memcpy(tmp, ctx->DT, DEFAULT_BLK_SZ);
-			output = ctx->I;
-			hexdump("tmp stage 0: ", tmp, DEFAULT_BLK_SZ);
-			break;
-		case 1:
-
-			/*
-			 * Next xor I with our secret vector V
-			 * encrypt that result to obtain our
-			 * pseudo random data which we output
-			 */
-			xor_vectors(ctx->I, ctx->V, tmp, DEFAULT_BLK_SZ);
-			hexdump("tmp stage 1: ", tmp, DEFAULT_BLK_SZ);
-			output = ctx->rand_data;
-			break;
-		case 2:
-			/*
-			 * First check that we didn't produce the same
-			 * random data that we did last time around through this
-			 */
-			if (!memcmp(ctx->rand_data, ctx->last_rand_data,
-					DEFAULT_BLK_SZ)) {
-				if (cont_test) {
-					panic("cprng %p Failed repetition check!\n",
-						ctx);
-				}
-
-				printk(KERN_ERR
-					"ctx %p Failed repetition check!\n",
-					ctx);
-
-				ctx->flags |= PRNG_NEED_RESET;
-				return -EINVAL;
-			}
-			memcpy(ctx->last_rand_data, ctx->rand_data,
-				DEFAULT_BLK_SZ);
-
-			/*
-			 * Lastly xor the random data with I
-			 * and encrypt that to obtain a new secret vector V
-			 */
-			xor_vectors(ctx->rand_data, ctx->I, tmp,
-				DEFAULT_BLK_SZ);
-			output = ctx->V;
-			hexdump("tmp stage 2: ", tmp, DEFAULT_BLK_SZ);
-			break;
-		}
-
-
-		/* do the encryption */
-		crypto_cipher_encrypt_one(ctx->tfm, output, tmp);
-
-	}
-
-	/*
-	 * Now update our DT value
-	 */
-	for (i = DEFAULT_BLK_SZ - 1; i >= 0; i--) {
-		ctx->DT[i] += 1;
-		if (ctx->DT[i] != 0)
-			break;
-	}
-
-	dbgprint("Returning new block for context %p\n", ctx);
-	ctx->rand_data_valid = 0;
-
-	hexdump("Output DT: ", ctx->DT, DEFAULT_BLK_SZ);
-	hexdump("Output I: ", ctx->I, DEFAULT_BLK_SZ);
-	hexdump("Output V: ", ctx->V, DEFAULT_BLK_SZ);
-	hexdump("New Random Data: ", ctx->rand_data, DEFAULT_BLK_SZ);
-
-	return 0;
-}
-
-/* Our exported functions */
-static int get_prng_bytes(char *buf, size_t nbytes, struct prng_context *ctx,
-				int do_cont_test)
-{
-	unsigned char *ptr = buf;
-	unsigned int byte_count = (unsigned int)nbytes;
-	int err;
-
-
-	spin_lock_bh(&ctx->prng_lock);
-
-	err = -EINVAL;
-	if (ctx->flags & PRNG_NEED_RESET)
-		goto done;
-
-	/*
-	 * If the FIXED_SIZE flag is on, only return whole blocks of
-	 * pseudo random data
-	 */
-	err = -EINVAL;
-	if (ctx->flags & PRNG_FIXED_SIZE) {
-		if (nbytes < DEFAULT_BLK_SZ)
-			goto done;
-		byte_count = DEFAULT_BLK_SZ;
-	}
-
-	/*
-	 * Return 0 in case of success as mandated by the kernel
-	 * crypto API interface definition.
-	 */
-	err = 0;
-
-	dbgprint(KERN_CRIT "getting %d random bytes for context %p\n",
-		byte_count, ctx);
-
-
-remainder:
-	if (ctx->rand_data_valid == DEFAULT_BLK_SZ) {
-		if (_get_more_prng_bytes(ctx, do_cont_test) < 0) {
-			memset(buf, 0, nbytes);
-			err = -EINVAL;
-			goto done;
-		}
-	}
-
-	/*
-	 * Copy any data less than an entire block
-	 */
-	if (byte_count < DEFAULT_BLK_SZ) {
-empty_rbuf:
-		while (ctx->rand_data_valid < DEFAULT_BLK_SZ) {
-			*ptr = ctx->rand_data[ctx->rand_data_valid];
-			ptr++;
-			byte_count--;
-			ctx->rand_data_valid++;
-			if (byte_count == 0)
-				goto done;
-		}
-	}
-
-	/*
-	 * Now copy whole blocks
-	 */
-	for (; byte_count >= DEFAULT_BLK_SZ; byte_count -= DEFAULT_BLK_SZ) {
-		if (ctx->rand_data_valid == DEFAULT_BLK_SZ) {
-			if (_get_more_prng_bytes(ctx, do_cont_test) < 0) {
-				memset(buf, 0, nbytes);
-				err = -EINVAL;
-				goto done;
-			}
-		}
-		if (ctx->rand_data_valid > 0)
-			goto empty_rbuf;
-		memcpy(ptr, ctx->rand_data, DEFAULT_BLK_SZ);
-		ctx->rand_data_valid += DEFAULT_BLK_SZ;
-		ptr += DEFAULT_BLK_SZ;
-	}
-
-	/*
-	 * Now go back and get any remaining partial block
-	 */
-	if (byte_count)
-		goto remainder;
-
-done:
-	spin_unlock_bh(&ctx->prng_lock);
-	dbgprint(KERN_CRIT "returning %d from get_prng_bytes in context %p\n",
-		err, ctx);
-	return err;
-}
-
-static void free_prng_context(struct prng_context *ctx)
-{
-	crypto_free_cipher(ctx->tfm);
-}
-
-static int reset_prng_context(struct prng_context *ctx,
-			      const unsigned char *key, size_t klen,
-			      const unsigned char *V, const unsigned char *DT)
-{
-	int ret;
-	const unsigned char *prng_key;
-
-	spin_lock_bh(&ctx->prng_lock);
-	ctx->flags |= PRNG_NEED_RESET;
-
-	prng_key = (key != NULL) ? key : (unsigned char *)DEFAULT_PRNG_KEY;
-
-	if (!key)
-		klen = DEFAULT_PRNG_KSZ;
-
-	if (V)
-		memcpy(ctx->V, V, DEFAULT_BLK_SZ);
-	else
-		memcpy(ctx->V, DEFAULT_V_SEED, DEFAULT_BLK_SZ);
-
-	if (DT)
-		memcpy(ctx->DT, DT, DEFAULT_BLK_SZ);
-	else
-		memset(ctx->DT, 0, DEFAULT_BLK_SZ);
-
-	memset(ctx->rand_data, 0, DEFAULT_BLK_SZ);
-	memset(ctx->last_rand_data, 0, DEFAULT_BLK_SZ);
-
-	ctx->rand_data_valid = DEFAULT_BLK_SZ;
-
-	ret = crypto_cipher_setkey(ctx->tfm, prng_key, klen);
-	if (ret) {
-		dbgprint(KERN_CRIT "PRNG: setkey() failed flags=%x\n",
-			crypto_cipher_get_flags(ctx->tfm));
-		goto out;
-	}
-
-	ret = 0;
-	ctx->flags &= ~PRNG_NEED_RESET;
-out:
-	spin_unlock_bh(&ctx->prng_lock);
-	return ret;
-}
-
-static int cprng_init(struct crypto_tfm *tfm)
-{
-	struct prng_context *ctx = crypto_tfm_ctx(tfm);
-
-	spin_lock_init(&ctx->prng_lock);
-	ctx->tfm = crypto_alloc_cipher("aes", 0, 0);
-	if (IS_ERR(ctx->tfm)) {
-		dbgprint(KERN_CRIT "Failed to alloc tfm for context %p\n",
-				ctx);
-		return PTR_ERR(ctx->tfm);
-	}
-
-	if (reset_prng_context(ctx, NULL, DEFAULT_PRNG_KSZ, NULL, NULL) < 0)
-		return -EINVAL;
-
-	/*
-	 * after allocation, we should always force the user to reset
-	 * so they don't inadvertently use the insecure default values
-	 * without specifying them intentially
-	 */
-	ctx->flags |= PRNG_NEED_RESET;
-	return 0;
-}
-
-static void cprng_exit(struct crypto_tfm *tfm)
-{
-	free_prng_context(crypto_tfm_ctx(tfm));
-}
-
-static int cprng_get_random(struct crypto_rng *tfm,
-			    const u8 *src, unsigned int slen,
-			    u8 *rdata, unsigned int dlen)
-{
-	struct prng_context *prng = crypto_rng_ctx(tfm);
-
-	return get_prng_bytes(rdata, dlen, prng, 0);
-}
-
-/*
- *  This is the cprng_registered reset method the seed value is
- *  interpreted as the tuple { V KEY DT}
- *  V and KEY are required during reset, and DT is optional, detected
- *  as being present by testing the length of the seed
- */
-static int cprng_reset(struct crypto_rng *tfm,
-		       const u8 *seed, unsigned int slen)
-{
-	struct prng_context *prng = crypto_rng_ctx(tfm);
-	const u8 *key = seed + DEFAULT_BLK_SZ;
-	const u8 *dt = NULL;
-
-	if (slen < DEFAULT_PRNG_KSZ + DEFAULT_BLK_SZ)
-		return -EINVAL;
-
-	if (slen >= (2 * DEFAULT_BLK_SZ + DEFAULT_PRNG_KSZ))
-		dt = key + DEFAULT_PRNG_KSZ;
-
-	reset_prng_context(prng, key, DEFAULT_PRNG_KSZ, seed, dt);
-
-	if (prng->flags & PRNG_NEED_RESET)
-		return -EINVAL;
-	return 0;
-}
-
-#ifdef CONFIG_CRYPTO_FIPS
-static int fips_cprng_get_random(struct crypto_rng *tfm,
-				 const u8 *src, unsigned int slen,
-				 u8 *rdata, unsigned int dlen)
-{
-	struct prng_context *prng = crypto_rng_ctx(tfm);
-
-	return get_prng_bytes(rdata, dlen, prng, 1);
-}
-
-static int fips_cprng_reset(struct crypto_rng *tfm,
-			    const u8 *seed, unsigned int slen)
-{
-	u8 rdata[DEFAULT_BLK_SZ];
-	const u8 *key = seed + DEFAULT_BLK_SZ;
-	int rc;
-
-	struct prng_context *prng = crypto_rng_ctx(tfm);
-
-	if (slen < DEFAULT_PRNG_KSZ + DEFAULT_BLK_SZ)
-		return -EINVAL;
-
-	/* fips strictly requires seed != key */
-	if (!memcmp(seed, key, DEFAULT_PRNG_KSZ))
-		return -EINVAL;
-
-	rc = cprng_reset(tfm, seed, slen);
-
-	if (!rc)
-		goto out;
-
-	/* this primes our continuity test */
-	rc = get_prng_bytes(rdata, DEFAULT_BLK_SZ, prng, 0);
-	prng->rand_data_valid = DEFAULT_BLK_SZ;
-
-out:
-	return rc;
-}
-#endif
-
-static struct rng_alg rng_algs[] = { {
-	.generate		= cprng_get_random,
-	.seed			= cprng_reset,
-	.seedsize		= DEFAULT_PRNG_KSZ + 2 * DEFAULT_BLK_SZ,
-	.base			=	{
-		.cra_name		= "stdrng",
-		.cra_driver_name	= "ansi_cprng",
-		.cra_priority		= 100,
-		.cra_ctxsize		= sizeof(struct prng_context),
-		.cra_module		= THIS_MODULE,
-		.cra_init		= cprng_init,
-		.cra_exit		= cprng_exit,
-	}
-#ifdef CONFIG_CRYPTO_FIPS
-}, {
-	.generate		= fips_cprng_get_random,
-	.seed			= fips_cprng_reset,
-	.seedsize		= DEFAULT_PRNG_KSZ + 2 * DEFAULT_BLK_SZ,
-	.base			=	{
-		.cra_name		= "fips(ansi_cprng)",
-		.cra_driver_name	= "fips_ansi_cprng",
-		.cra_priority		= 300,
-		.cra_ctxsize		= sizeof(struct prng_context),
-		.cra_module		= THIS_MODULE,
-		.cra_init		= cprng_init,
-		.cra_exit		= cprng_exit,
-	}
-#endif
-} };
-
-/* Module initalization */
-static int __init prng_mod_init(void)
-{
-	return crypto_register_rngs(rng_algs, ARRAY_SIZE(rng_algs));
-}
-
-static void __exit prng_mod_fini(void)
-{
-	crypto_unregister_rngs(rng_algs, ARRAY_SIZE(rng_algs));
-}
-
-MODULE_LICENSE("GPL");
-MODULE_DESCRIPTION("Software Pseudo Random Number Generator");
-MODULE_AUTHOR("Neil Horman <nhorman@tuxdriver.com>");
-module_param(dbg, int, 0);
-MODULE_PARM_DESC(dbg, "Boolean to enable debugging (0/1 == off/on)");
-module_init(prng_mod_init);
-module_exit(prng_mod_fini);
-MODULE_ALIAS_CRYPTO("stdrng");
-MODULE_ALIAS_CRYPTO("ansi_cprng");
-MODULE_IMPORT_NS("CRYPTO_INTERNAL");
diff --git a/crypto/tcrypt.c b/crypto/tcrypt.c
index d1d88debbd71..ea58a4f6dd86 100644
--- a/crypto/tcrypt.c
+++ b/crypto/tcrypt.c
@@ -1756,14 +1756,10 @@ static int do_test(const char *alg, u32 type, u32 mask, int m, u32 num_mb)
 
 	case 116:
 		ret = min(ret, tcrypt_test("hmac(streebog512)"));
 		break;
 
-	case 150:
-		ret = min(ret, tcrypt_test("ansi_cprng"));
-		break;
-
 	case 151:
 		ret = min(ret, tcrypt_test("rfc4106(gcm(aes))"));
 		break;
 
 	case 152:
diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index 6a490aaa71b9..dc22b4f28633 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -115,15 +115,10 @@ struct comp_test_suite {
 struct hash_test_suite {
 	const struct hash_testvec *vecs;
 	unsigned int count;
 };
 
-struct cprng_test_suite {
-	const struct cprng_testvec *vecs;
-	unsigned int count;
-};
-
 struct drbg_test_suite {
 	const struct drbg_testvec *vecs;
 	unsigned int count;
 };
 
@@ -152,11 +147,10 @@ struct alg_test_desc {
 	union {
 		struct aead_test_suite aead;
 		struct cipher_test_suite cipher;
 		struct comp_test_suite comp;
 		struct hash_test_suite hash;
-		struct cprng_test_suite cprng;
 		struct drbg_test_suite drbg;
 		struct akcipher_test_suite akcipher;
 		struct sig_test_suite sig;
 		struct kpp_test_suite kpp;
 	} suite;
@@ -3440,72 +3434,10 @@ static int test_acomp(struct crypto_acomp *tfm,
 	kfree(decomp_out);
 	kfree(output);
 	return ret;
 }
 
-static int test_cprng(struct crypto_rng *tfm,
-		      const struct cprng_testvec *template,
-		      unsigned int tcount)
-{
-	const char *algo = crypto_tfm_alg_driver_name(crypto_rng_tfm(tfm));
-	int err = 0, i, j, seedsize;
-	u8 *seed;
-	char result[32];
-
-	seedsize = crypto_rng_seedsize(tfm);
-
-	seed = kmalloc(seedsize, GFP_KERNEL);
-	if (!seed) {
-		printk(KERN_ERR "alg: cprng: Failed to allocate seed space "
-		       "for %s\n", algo);
-		return -ENOMEM;
-	}
-
-	for (i = 0; i < tcount; i++) {
-		memset(result, 0, 32);
-
-		memcpy(seed, template[i].v, template[i].vlen);
-		memcpy(seed + template[i].vlen, template[i].key,
-		       template[i].klen);
-		memcpy(seed + template[i].vlen + template[i].klen,
-		       template[i].dt, template[i].dtlen);
-
-		err = crypto_rng_reset(tfm, seed, seedsize);
-		if (err) {
-			printk(KERN_ERR "alg: cprng: Failed to reset rng "
-			       "for %s\n", algo);
-			goto out;
-		}
-
-		for (j = 0; j < template[i].loops; j++) {
-			err = crypto_rng_get_bytes(tfm, result,
-						   template[i].rlen);
-			if (err < 0) {
-				printk(KERN_ERR "alg: cprng: Failed to obtain "
-				       "the correct amount of random data for "
-				       "%s (requested %d)\n", algo,
-				       template[i].rlen);
-				goto out;
-			}
-		}
-
-		err = memcmp(result, template[i].result,
-			     template[i].rlen);
-		if (err) {
-			printk(KERN_ERR "alg: cprng: Test %d failed for %s\n",
-			       i, algo);
-			hexdump(result, template[i].rlen);
-			err = -EINVAL;
-			goto out;
-		}
-	}
-
-out:
-	kfree(seed);
-	return err;
-}
-
 static int alg_test_cipher(const struct alg_test_desc *desc,
 			   const char *driver, u32 type, u32 mask)
 {
 	const struct cipher_test_suite *suite = &desc->suite.cipher;
 	struct crypto_cipher *tfm;
@@ -3548,33 +3480,10 @@ static int alg_test_comp(const struct alg_test_desc *desc, const char *driver,
 			 desc->suite.comp.decomp.count);
 	crypto_free_acomp(acomp);
 	return err;
 }
 
-static int alg_test_cprng(const struct alg_test_desc *desc, const char *driver,
-			  u32 type, u32 mask)
-{
-	struct crypto_rng *rng;
-	int err;
-
-	rng = crypto_alloc_rng(driver, type, mask);
-	if (IS_ERR(rng)) {
-		if (PTR_ERR(rng) == -ENOENT)
-			return 0;
-		printk(KERN_ERR "alg: cprng: Failed to load transform for %s: "
-		       "%ld\n", driver, PTR_ERR(rng));
-		return PTR_ERR(rng);
-	}
-
-	err = test_cprng(rng, desc->suite.cprng.vecs, desc->suite.cprng.count);
-
-	crypto_free_rng(rng);
-
-	return err;
-}
-
-
 static int drbg_cavs_test(const struct drbg_testvec *test, int pr,
 			  const char *driver, u32 type, u32 mask)
 {
 	int ret = -EAGAIN;
 	struct crypto_rng *drng;
@@ -4168,16 +4077,10 @@ static const struct alg_test_desc alg_test_descs[] = {
 		.alg = "aegis128",
 		.test = alg_test_aead,
 		.suite = {
 			.aead = __VECS(aegis128_tv_template)
 		}
-	}, {
-		.alg = "ansi_cprng",
-		.test = alg_test_cprng,
-		.suite = {
-			.cprng = __VECS(ansi_cprng_aes_tv_template)
-		}
 	}, {
 		.alg = "authenc(hmac(md5),ecb(cipher_null))",
 		.generic_driver = "authenc(hmac-md5-lib,ecb-cipher_null)",
 		.test = alg_test_aead,
 		.suite = {
diff --git a/crypto/testmgr.h b/crypto/testmgr.h
index 268231227282..7a69185b86e8 100644
--- a/crypto/testmgr.h
+++ b/crypto/testmgr.h
@@ -117,22 +117,10 @@ struct aead_testvec {
 	int setkey_error;
 	int setauthsize_error;
 	int crypt_error;
 };
 
-struct cprng_testvec {
-	const char *key;
-	const char *dt;
-	const char *v;
-	const char *result;
-	unsigned char klen;
-	unsigned short dtlen;
-	unsigned short vlen;
-	unsigned short rlen;
-	unsigned short loops;
-};
-
 struct drbg_testvec {
 	const unsigned char *entropy;
 	size_t entropylen;
 	const unsigned char *entpra;
 	const unsigned char *entprb;
@@ -22374,104 +22362,10 @@ static const struct aead_testvec aegis128_tv_template[] = {
 			  "\x78\x93\xec\xfc\xf4\xff\xe1\x2d",
 		.clen	= 24,
 	},
 };
 
-/*
- * ANSI X9.31 Continuous Pseudo-Random Number Generator (AES mode)
- * test vectors, taken from Appendix B.2.9 and B.2.10:
- *     http://csrc.nist.gov/groups/STM/cavp/documents/rng/RNGVS.pdf
- * Only AES-128 is supported at this time.
- */
-static const struct cprng_testvec ansi_cprng_aes_tv_template[] = {
-	{
-		.key	= "\xf3\xb1\x66\x6d\x13\x60\x72\x42"
-			  "\xed\x06\x1c\xab\xb8\xd4\x62\x02",
-		.klen	= 16,
-		.dt	= "\xe6\xb3\xbe\x78\x2a\x23\xfa\x62"
-			  "\xd7\x1d\x4a\xfb\xb0\xe9\x22\xf9",
-		.dtlen	= 16,
-		.v	= "\x80\x00\x00\x00\x00\x00\x00\x00"
-			  "\x00\x00\x00\x00\x00\x00\x00\x00",
-		.vlen	= 16,
-		.result	= "\x59\x53\x1e\xd1\x3b\xb0\xc0\x55"
-			  "\x84\x79\x66\x85\xc1\x2f\x76\x41",
-		.rlen	= 16,
-		.loops	= 1,
-	}, {
-		.key	= "\xf3\xb1\x66\x6d\x13\x60\x72\x42"
-			  "\xed\x06\x1c\xab\xb8\xd4\x62\x02",
-		.klen	= 16,
-		.dt	= "\xe6\xb3\xbe\x78\x2a\x23\xfa\x62"
-			  "\xd7\x1d\x4a\xfb\xb0\xe9\x22\xfa",
-		.dtlen	= 16,
-		.v	= "\xc0\x00\x00\x00\x00\x00\x00\x00"
-			  "\x00\x00\x00\x00\x00\x00\x00\x00",
-		.vlen	= 16,
-		.result	= "\x7c\x22\x2c\xf4\xca\x8f\xa2\x4c"
-			  "\x1c\x9c\xb6\x41\xa9\xf3\x22\x0d",
-		.rlen	= 16,
-		.loops	= 1,
-	}, {
-		.key	= "\xf3\xb1\x66\x6d\x13\x60\x72\x42"
-			  "\xed\x06\x1c\xab\xb8\xd4\x62\x02",
-		.klen	= 16,
-		.dt	= "\xe6\xb3\xbe\x78\x2a\x23\xfa\x62"
-			  "\xd7\x1d\x4a\xfb\xb0\xe9\x22\xfb",
-		.dtlen	= 16,
-		.v	= "\xe0\x00\x00\x00\x00\x00\x00\x00"
-			  "\x00\x00\x00\x00\x00\x00\x00\x00",
-		.vlen	= 16,
-		.result	= "\x8a\xaa\x00\x39\x66\x67\x5b\xe5"
-			  "\x29\x14\x28\x81\xa9\x4d\x4e\xc7",
-		.rlen	= 16,
-		.loops	= 1,
-	}, {
-		.key	= "\xf3\xb1\x66\x6d\x13\x60\x72\x42"
-			  "\xed\x06\x1c\xab\xb8\xd4\x62\x02",
-		.klen	= 16,
-		.dt	= "\xe6\xb3\xbe\x78\x2a\x23\xfa\x62"
-			  "\xd7\x1d\x4a\xfb\xb0\xe9\x22\xfc",
-		.dtlen	= 16,
-		.v	= "\xf0\x00\x00\x00\x00\x00\x00\x00"
-			  "\x00\x00\x00\x00\x00\x00\x00\x00",
-		.vlen	= 16,
-		.result	= "\x88\xdd\xa4\x56\x30\x24\x23\xe5"
-			  "\xf6\x9d\xa5\x7e\x7b\x95\xc7\x3a",
-		.rlen	= 16,
-		.loops	= 1,
-	}, {
-		.key	= "\xf3\xb1\x66\x6d\x13\x60\x72\x42"
-			  "\xed\x06\x1c\xab\xb8\xd4\x62\x02",
-		.klen	= 16,
-		.dt	= "\xe6\xb3\xbe\x78\x2a\x23\xfa\x62"
-			  "\xd7\x1d\x4a\xfb\xb0\xe9\x22\xfd",
-		.dtlen	= 16,
-		.v	= "\xf8\x00\x00\x00\x00\x00\x00\x00"
-			  "\x00\x00\x00\x00\x00\x00\x00\x00",
-		.vlen	= 16,
-		.result	= "\x05\x25\x92\x46\x61\x79\xd2\xcb"
-			  "\x78\xc4\x0b\x14\x0a\x5a\x9a\xc8",
-		.rlen	= 16,
-		.loops	= 1,
-	}, {	/* Monte Carlo Test */
-		.key	= "\x9f\x5b\x51\x20\x0b\xf3\x34\xb5"
-			  "\xd8\x2b\xe8\xc3\x72\x55\xc8\x48",
-		.klen	= 16,
-		.dt	= "\x63\x76\xbb\xe5\x29\x02\xba\x3b"
-			  "\x67\xc9\x25\xfa\x70\x1f\x11\xac",
-		.dtlen	= 16,
-		.v	= "\x57\x2c\x8e\x76\x87\x26\x47\x97"
-			  "\x7e\x74\xfb\xdd\xc4\x95\x01\xd1",
-		.vlen	= 16,
-		.result	= "\x48\xe9\xbd\x0d\x06\xee\x18\xfb"
-			  "\xe4\x57\x90\xd5\xc3\xfc\x9b\x73",
-		.rlen	= 16,
-		.loops	= 10000,
-	},
-};
-
 /*
  * SP800-90A DRBG Test vectors from
  * http://csrc.nist.gov/groups/STM/cavp/documents/drbg/drbgtestvectors.zip
  *
  * Test vectors for DRBG with prediction resistance. All types of DRBGs
diff --git a/include/crypto/rng.h b/include/crypto/rng.h
index f8224cc390f8..d451b54b322a 100644
--- a/include/crypto/rng.h
+++ b/include/crypto/rng.h
@@ -167,16 +167,15 @@ static inline int crypto_rng_get_bytes(struct crypto_rng *tfm,
  * @seed: seed input data
  * @slen: length of the seed input data
  *
  * The reset function completely re-initializes the random number generator
  * referenced by the cipher handle by clearing the current state. The new state
- * is initialized with the caller provided seed or automatically, depending
- * on the random number generator type (the ANSI X9.31 RNG requires
- * caller-provided seed, the SP800-90A DRBGs perform an automatic seeding).
- * The seed is provided as a parameter to this function call. The provided seed
- * should have the length of the seed size defined for the random number
- * generator as defined by crypto_rng_seedsize.
+ * is initialized with the caller provided seed or automatically, depending on
+ * the random number generator type. (The SP800-90A DRBGs perform an automatic
+ * seeding.) The seed is provided as a parameter to this function call. The
+ * provided seed should have the length of the seed size defined for the random
+ * number generator as defined by crypto_rng_seedsize.
  *
  * Return: 0 if the setting of the key was successful; < 0 if an error occurred
  */
 int crypto_rng_reset(struct crypto_rng *tfm, const u8 *seed,
 		     unsigned int slen);

base-commit: d633730bb3873578a00fde4b97f9ac62a1be8d34
-- 
2.51.2

