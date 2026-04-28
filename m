Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD6123B3C07;
	Tue, 28 Apr 2026 02:47:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777344431; cv=none; b=D2ehBqA3Dy7EpqFxjjsJhNh8BG7jVO05LxoXkoPjXORIpAq9yhB2jMeN4OkNnjm8hbDCfeJXutRubbYcImGsmUQBgAEDCbfUC1d/I9gSaInrtfrOlXwPNeyp+E14x/Xz/y+wUCpH3oQRR4drYEH70HXTUl3JW5Hll+mytPkYyP0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777344431; c=relaxed/simple;
	bh=Sx/tX6cA4rC2N8FBrENAKOiYumhtUZK/EEtiua1n8GY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n8St7LkT6hsY//IS5Vxmm2v/mLzLqC0NfvG1nfl+LACDA7RnpClMsqbZBqKSWqo5yxf2KdjGTTkOq1+SIHdcV1io380qFwNpA8JqCauMLbbCJKwUnTLlCXbcDtVQR/WhgGzZihxtrPYqDdkd1S1CSSI2SPZ6w+/abN4e3+y4doI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pRvlf58i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pRvlf58i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34A14C2BCB9;
	Tue, 28 Apr 2026 02:47:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777344431;
	bh=Sx/tX6cA4rC2N8FBrENAKOiYumhtUZK/EEtiua1n8GY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pRvlf58igeGEojcw1Q0QM2hkyCU5dPBE9NKT0xPpOs+ghIvibkEyw+kbO5hcBLQLY
	 +4de1XvXVwaepiMxR5J75fUmTbIZpifgXVz+JJk6rx8zYzqz3IjNOEWJgTp35U1QZY
	 YmEYqeZuk8HoKoFTj5nj/iwU+V3TnGRvq7GMqJzJB+FuTJQkGN/sioi6zUUBotTYKn
	 Fv2KqEqu7QKqIg0JtN3zEgsczhLOdjRw/MVUZXteFHefr2WxYFaRRKVVt0S9BaXDDR
	 84dh2+aob0A1vrYH8tC3FoofuKXPRC+HL44YVD1HEeof0EVyTx5h/geVdB9qhZ5AFr
	 GJ1hu0ywJbOzQ==
From: Eric Biggers <ebiggers@kernel.org>
To: netdev@vger.kernel.org,
	linux-afs@lists.infradead.org
Cc: David Howells <dhowells@redhat.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH net-next 5/5] crypto: pcbc - Remove support for PCBC mode
Date: Mon, 27 Apr 2026 19:43:58 -0700
Message-ID: <20260428024400.123337-6-ebiggers@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260428024400.123337-1-ebiggers@kernel.org>
References: <20260428024400.123337-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The only user of PCBC mode (Propagating Cipher Block Chaining mode) was
net/rxrpc/rxkad.c, which now uses local code instead.

While PCBC was an interesting cryptographic experiment, it has largely
been relegated to the history books and academic exercises.  It is
non-parallelizable (i.e., very slow) and doesn't actually achieve the
integrity properties it was apparently intended to achieve.

Remove support for it from the crypto API.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 arch/arm/configs/am200epdkit_defconfig        |   1 -
 arch/arm/configs/dove_defconfig               |   1 -
 arch/arm/configs/multi_v5_defconfig           |   1 -
 arch/arm/configs/mv78xx0_defconfig            |   1 -
 arch/arm/configs/mvebu_v5_defconfig           |   1 -
 arch/arm/configs/omap1_defconfig              |   1 -
 arch/arm/configs/orion5x_defconfig            |   1 -
 arch/arm/configs/pxa_defconfig                |   1 -
 arch/arm/configs/wpcm450_defconfig            |   1 -
 arch/m68k/configs/amiga_defconfig             |   1 -
 arch/m68k/configs/apollo_defconfig            |   1 -
 arch/m68k/configs/atari_defconfig             |   1 -
 arch/m68k/configs/bvme6000_defconfig          |   1 -
 arch/m68k/configs/hp300_defconfig             |   1 -
 arch/m68k/configs/mac_defconfig               |   1 -
 arch/m68k/configs/multi_defconfig             |   1 -
 arch/m68k/configs/mvme147_defconfig           |   1 -
 arch/m68k/configs/mvme16x_defconfig           |   1 -
 arch/m68k/configs/q40_defconfig               |   1 -
 arch/m68k/configs/sun3_defconfig              |   1 -
 arch/m68k/configs/sun3x_defconfig             |   1 -
 arch/mips/configs/bigsur_defconfig            |   1 -
 arch/mips/configs/decstation_64_defconfig     |   1 -
 arch/mips/configs/decstation_defconfig        |   1 -
 arch/mips/configs/decstation_r4k_defconfig    |   1 -
 arch/mips/configs/fuloong2e_defconfig         |   1 -
 arch/mips/configs/gpr_defconfig               |   1 -
 arch/mips/configs/ip22_defconfig              |   1 -
 arch/mips/configs/ip27_defconfig              |   1 -
 arch/mips/configs/ip30_defconfig              |   1 -
 arch/mips/configs/ip32_defconfig              |   1 -
 arch/mips/configs/lemote2f_defconfig          |   1 -
 arch/mips/configs/malta_defconfig             |   1 -
 arch/mips/configs/malta_kvm_defconfig         |   1 -
 arch/mips/configs/malta_qemu_32r6_defconfig   |   1 -
 arch/mips/configs/maltaaprp_defconfig         |   1 -
 arch/mips/configs/maltasmvp_defconfig         |   1 -
 arch/mips/configs/maltasmvp_eva_defconfig     |   1 -
 arch/mips/configs/maltaup_defconfig           |   1 -
 arch/mips/configs/maltaup_xpa_defconfig       |   1 -
 arch/mips/configs/mtx1_defconfig              |   1 -
 arch/mips/configs/rm200_defconfig             |   1 -
 arch/mips/configs/sb1250_swarm_defconfig      |   1 -
 arch/parisc/configs/generic-64bit_defconfig   |   1 -
 arch/powerpc/configs/44x/akebono_defconfig    |   1 -
 arch/powerpc/configs/44x/bamboo_defconfig     |   1 -
 arch/powerpc/configs/44x/currituck_defconfig  |   1 -
 arch/powerpc/configs/44x/ebony_defconfig      |   1 -
 arch/powerpc/configs/44x/eiger_defconfig      |   1 -
 arch/powerpc/configs/44x/fsp2_defconfig       |   1 -
 arch/powerpc/configs/44x/icon_defconfig       |   1 -
 arch/powerpc/configs/44x/iss476-smp_defconfig |   1 -
 arch/powerpc/configs/44x/katmai_defconfig     |   1 -
 arch/powerpc/configs/44x/rainier_defconfig    |   1 -
 arch/powerpc/configs/44x/redwood_defconfig    |   1 -
 arch/powerpc/configs/44x/sequoia_defconfig    |   1 -
 arch/powerpc/configs/44x/taishan_defconfig    |   1 -
 arch/powerpc/configs/52xx/cm5200_defconfig    |   1 -
 arch/powerpc/configs/52xx/motionpro_defconfig |   1 -
 arch/powerpc/configs/52xx/tqm5200_defconfig   |   1 -
 arch/powerpc/configs/83xx/asp8347_defconfig   |   1 -
 .../configs/83xx/mpc8313_rdb_defconfig        |   1 -
 .../configs/83xx/mpc8315_rdb_defconfig        |   1 -
 .../configs/83xx/mpc832x_rdb_defconfig        |   1 -
 .../configs/83xx/mpc834x_itx_defconfig        |   1 -
 .../configs/83xx/mpc834x_itxgp_defconfig      |   1 -
 .../configs/83xx/mpc837x_rdb_defconfig        |   1 -
 arch/powerpc/configs/amigaone_defconfig       |   1 -
 arch/powerpc/configs/cell_defconfig           |   1 -
 arch/powerpc/configs/chrp32_defconfig         |   1 -
 arch/powerpc/configs/ep8248e_defconfig        |   1 -
 arch/powerpc/configs/fsl-emb-nonhw.config     |   1 -
 arch/powerpc/configs/g5_defconfig             |   1 -
 arch/powerpc/configs/linkstation_defconfig    |   1 -
 arch/powerpc/configs/mgcoge_defconfig         |   1 -
 arch/powerpc/configs/mpc83xx_defconfig        |   1 -
 arch/powerpc/configs/mvme5100_defconfig       |   1 -
 arch/powerpc/configs/pmac32_defconfig         |   1 -
 arch/powerpc/configs/powernv_defconfig        |   1 -
 arch/powerpc/configs/ppc44x_defconfig         |   1 -
 arch/powerpc/configs/ppc64_defconfig          |   1 -
 arch/powerpc/configs/ppc64e_defconfig         |   1 -
 arch/powerpc/configs/ppc6xx_defconfig         |   1 -
 arch/powerpc/configs/ps3_defconfig            |   1 -
 arch/s390/configs/debug_defconfig             |   1 -
 arch/s390/configs/defconfig                   |   1 -
 arch/sh/configs/hp6xx_defconfig               |   1 -
 arch/sh/configs/r7780mp_defconfig             |   1 -
 arch/sh/configs/r7785rp_defconfig             |   1 -
 arch/sh/configs/se7712_defconfig              |   1 -
 arch/sh/configs/sh2007_defconfig              |   1 -
 arch/sparc/configs/sparc32_defconfig          |   1 -
 arch/sparc/configs/sparc64_defconfig          |   1 -
 crypto/Kconfig                                |   9 -
 crypto/Makefile                               |   1 -
 crypto/pcbc.c                                 | 195 ------------------
 96 files changed, 298 deletions(-)
 delete mode 100644 crypto/pcbc.c

diff --git a/arch/arm/configs/am200epdkit_defconfig b/arch/arm/configs/am200epdkit_defconfig
index 2367b1685c1c..d8198592fe1b 100644
--- a/arch/arm/configs/am200epdkit_defconfig
+++ b/arch/arm/configs/am200epdkit_defconfig
@@ -84,10 +84,9 @@ CONFIG_NLS_ISO8859_1=y
 CONFIG_DEBUG_KERNEL=y
 # CONFIG_DETECT_SOFTLOCKUP is not set
 CONFIG_CRYPTO=y
 CONFIG_CRYPTO_CBC=m
 CONFIG_CRYPTO_ECB=m
-CONFIG_CRYPTO_PCBC=m
 CONFIG_CRYPTO_ARC4=m
 # CONFIG_DEBUG_BUGVERBOSE is not set
 # CONFIG_DEBUG_PREEMPT is not set
 CONFIG_DEBUG_USER=y
diff --git a/arch/arm/configs/dove_defconfig b/arch/arm/configs/dove_defconfig
index e98c35df675e..9743b0b7ec61 100644
--- a/arch/arm/configs/dove_defconfig
+++ b/arch/arm/configs/dove_defconfig
@@ -116,11 +116,10 @@ CONFIG_TIMER_STATS=y
 CONFIG_CRYPTO_NULL=y
 CONFIG_CRYPTO_BLOWFISH=y
 CONFIG_CRYPTO_TEA=y
 CONFIG_CRYPTO_TWOFISH=y
 CONFIG_CRYPTO_ECB=m
-CONFIG_CRYPTO_PCBC=m
 CONFIG_CRYPTO_HMAC=y
 CONFIG_CRYPTO_MD4=y
 CONFIG_CRYPTO_SHA1=y
 CONFIG_CRYPTO_SHA256=y
 CONFIG_CRYPTO_SHA512=y
diff --git a/arch/arm/configs/multi_v5_defconfig b/arch/arm/configs/multi_v5_defconfig
index 59b020e66a0b..95afc972047e 100644
--- a/arch/arm/configs/multi_v5_defconfig
+++ b/arch/arm/configs/multi_v5_defconfig
@@ -284,11 +284,10 @@ CONFIG_NLS_CODEPAGE_437=y
 CONFIG_NLS_CODEPAGE_850=y
 CONFIG_NLS_ISO8859_1=y
 CONFIG_NLS_ISO8859_2=y
 CONFIG_NLS_UTF8=y
 CONFIG_CRYPTO_CBC=m
-CONFIG_CRYPTO_PCBC=m
 CONFIG_CRYPTO_DEV_MARVELL_CESA=y
 CONFIG_DEBUG_KERNEL=y
 CONFIG_DEBUG_INFO_DWARF_TOOLCHAIN_DEFAULT=y
 CONFIG_MAGIC_SYSRQ=y
 CONFIG_DEBUG_FS=y
diff --git a/arch/arm/configs/mv78xx0_defconfig b/arch/arm/configs/mv78xx0_defconfig
index d3a26efe766c..a652ccd1358b 100644
--- a/arch/arm/configs/mv78xx0_defconfig
+++ b/arch/arm/configs/mv78xx0_defconfig
@@ -109,11 +109,10 @@ CONFIG_NLS_CODEPAGE_437=y
 CONFIG_NLS_CODEPAGE_850=y
 CONFIG_NLS_ISO8859_1=y
 CONFIG_NLS_ISO8859_2=y
 CONFIG_CRYPTO_CBC=m
 CONFIG_CRYPTO_ECB=m
-CONFIG_CRYPTO_PCBC=m
 # CONFIG_DEBUG_BUGVERBOSE is not set
 CONFIG_DEBUG_INFO_DWARF_TOOLCHAIN_DEFAULT=y
 CONFIG_MAGIC_SYSRQ=y
 CONFIG_DEBUG_FS=y
 CONFIG_DEBUG_KERNEL=y
diff --git a/arch/arm/configs/mvebu_v5_defconfig b/arch/arm/configs/mvebu_v5_defconfig
index d1742a7cae6a..4cf77df183b3 100644
--- a/arch/arm/configs/mvebu_v5_defconfig
+++ b/arch/arm/configs/mvebu_v5_defconfig
@@ -183,11 +183,10 @@ CONFIG_NLS_CODEPAGE_437=y
 CONFIG_NLS_CODEPAGE_850=y
 CONFIG_NLS_ISO8859_1=y
 CONFIG_NLS_ISO8859_2=y
 CONFIG_NLS_UTF8=y
 CONFIG_CRYPTO_CBC=m
-CONFIG_CRYPTO_PCBC=m
 CONFIG_CRYPTO_DEV_MARVELL_CESA=y
 CONFIG_DEBUG_KERNEL=y
 CONFIG_DEBUG_INFO_DWARF_TOOLCHAIN_DEFAULT=y
 CONFIG_MAGIC_SYSRQ=y
 CONFIG_DEBUG_FS=y
diff --git a/arch/arm/configs/omap1_defconfig b/arch/arm/configs/omap1_defconfig
index c6155f101fc9..7bf58e8a5ab5 100644
--- a/arch/arm/configs/omap1_defconfig
+++ b/arch/arm/configs/omap1_defconfig
@@ -213,11 +213,10 @@ CONFIG_NLS_KOI8_R=y
 CONFIG_NLS_UTF8=y
 # CONFIG_ENABLE_MUST_CHECK is not set
 CONFIG_DEBUG_KERNEL=y
 CONFIG_SECURITY=y
 CONFIG_CRYPTO_ECB=y
-CONFIG_CRYPTO_PCBC=y
 CONFIG_CRYPTO_DEFLATE=y
 CONFIG_CRYPTO_LZO=y
 CONFIG_FONTS=y
 CONFIG_FONT_8x8=y
 CONFIG_FONT_8x16=y
diff --git a/arch/arm/configs/orion5x_defconfig b/arch/arm/configs/orion5x_defconfig
index 002c9145026b..f5be2e26d9ae 100644
--- a/arch/arm/configs/orion5x_defconfig
+++ b/arch/arm/configs/orion5x_defconfig
@@ -132,11 +132,10 @@ CONFIG_NLS_CODEPAGE_437=y
 CONFIG_NLS_CODEPAGE_850=y
 CONFIG_NLS_ISO8859_1=y
 CONFIG_NLS_ISO8859_2=y
 CONFIG_CRYPTO_CBC=m
 CONFIG_CRYPTO_ECB=m
-CONFIG_CRYPTO_PCBC=m
 CONFIG_CRYPTO_DEV_MARVELL_CESA=y
 # CONFIG_DEBUG_BUGVERBOSE is not set
 CONFIG_DEBUG_INFO_DWARF_TOOLCHAIN_DEFAULT=y
 CONFIG_MAGIC_SYSRQ=y
 CONFIG_DEBUG_FS=y
diff --git a/arch/arm/configs/pxa_defconfig b/arch/arm/configs/pxa_defconfig
index 53f1e5820c49..83d1ed3a37f5 100644
--- a/arch/arm/configs/pxa_defconfig
+++ b/arch/arm/configs/pxa_defconfig
@@ -644,11 +644,10 @@ CONFIG_CRYPTO_KHAZAD=m
 CONFIG_CRYPTO_SEED=m
 CONFIG_CRYPTO_SERPENT=m
 CONFIG_CRYPTO_TEA=m
 CONFIG_CRYPTO_TWOFISH=m
 CONFIG_CRYPTO_LRW=m
-CONFIG_CRYPTO_PCBC=m
 CONFIG_CRYPTO_XTS=m
 CONFIG_CRYPTO_SHA512=m
 CONFIG_CRYPTO_TGR192=m
 CONFIG_CRYPTO_WP512=m
 CONFIG_CRYPTO_ANUBIS=m
diff --git a/arch/arm/configs/wpcm450_defconfig b/arch/arm/configs/wpcm450_defconfig
index cd4b3e70ff68..67b64a378166 100644
--- a/arch/arm/configs/wpcm450_defconfig
+++ b/arch/arm/configs/wpcm450_defconfig
@@ -179,11 +179,10 @@ CONFIG_KEYS=y
 CONFIG_HARDENED_USERCOPY=y
 CONFIG_FORTIFY_SOURCE=y
 CONFIG_CRYPTO_RSA=y
 CONFIG_CRYPTO_AES=y
 CONFIG_CRYPTO_CBC=m
-CONFIG_CRYPTO_PCBC=m
 CONFIG_CRYPTO_CCM=y
 CONFIG_CRYPTO_GCM=y
 CONFIG_CRYPTO_CMAC=y
 CONFIG_CRYPTO_SHA256=y
 CONFIG_ASYMMETRIC_KEY_TYPE=y
diff --git a/arch/m68k/configs/amiga_defconfig b/arch/m68k/configs/amiga_defconfig
index ca45670a6af4..aadff466830f 100644
--- a/arch/m68k/configs/amiga_defconfig
+++ b/arch/m68k/configs/amiga_defconfig
@@ -533,11 +533,10 @@ CONFIG_CRYPTO_TWOFISH=m
 CONFIG_CRYPTO_ADIANTUM=m
 CONFIG_CRYPTO_ARC4=m
 CONFIG_CRYPTO_CTS=m
 CONFIG_CRYPTO_HCTR2=m
 CONFIG_CRYPTO_LRW=m
-CONFIG_CRYPTO_PCBC=m
 CONFIG_CRYPTO_XTS=m
 CONFIG_CRYPTO_AEGIS128=m
 CONFIG_CRYPTO_MD4=m
 CONFIG_CRYPTO_RMD160=m
 CONFIG_CRYPTO_SHA1=m
diff --git a/arch/m68k/configs/apollo_defconfig b/arch/m68k/configs/apollo_defconfig
index 2732a5b8b694..ea9487a39884 100644
--- a/arch/m68k/configs/apollo_defconfig
+++ b/arch/m68k/configs/apollo_defconfig
@@ -488,11 +488,10 @@ CONFIG_CRYPTO_TWOFISH=m
 CONFIG_CRYPTO_ADIANTUM=m
 CONFIG_CRYPTO_ARC4=m
 CONFIG_CRYPTO_CTS=m
 CONFIG_CRYPTO_HCTR2=m
 CONFIG_CRYPTO_LRW=m
-CONFIG_CRYPTO_PCBC=m
 CONFIG_CRYPTO_XTS=m
 CONFIG_CRYPTO_AEGIS128=m
 CONFIG_CRYPTO_MD4=m
 CONFIG_CRYPTO_RMD160=m
 CONFIG_CRYPTO_SHA1=m
diff --git a/arch/m68k/configs/atari_defconfig b/arch/m68k/configs/atari_defconfig
index 242882b05fa4..a70127ac7a2d 100644
--- a/arch/m68k/configs/atari_defconfig
+++ b/arch/m68k/configs/atari_defconfig
@@ -510,11 +510,10 @@ CONFIG_CRYPTO_TWOFISH=m
 CONFIG_CRYPTO_ADIANTUM=m
 CONFIG_CRYPTO_ARC4=m
 CONFIG_CRYPTO_CTS=m
 CONFIG_CRYPTO_HCTR2=m
 CONFIG_CRYPTO_LRW=m
-CONFIG_CRYPTO_PCBC=m
 CONFIG_CRYPTO_XTS=m
 CONFIG_CRYPTO_AEGIS128=m
 CONFIG_CRYPTO_MD4=m
 CONFIG_CRYPTO_RMD160=m
 CONFIG_CRYPTO_SHA1=m
diff --git a/arch/m68k/configs/bvme6000_defconfig b/arch/m68k/configs/bvme6000_defconfig
index 07e73c78a9e2..83da79382538 100644
--- a/arch/m68k/configs/bvme6000_defconfig
+++ b/arch/m68k/configs/bvme6000_defconfig
@@ -480,11 +480,10 @@ CONFIG_CRYPTO_TWOFISH=m
 CONFIG_CRYPTO_ADIANTUM=m
 CONFIG_CRYPTO_ARC4=m
 CONFIG_CRYPTO_CTS=m
 CONFIG_CRYPTO_HCTR2=m
 CONFIG_CRYPTO_LRW=m
-CONFIG_CRYPTO_PCBC=m
 CONFIG_CRYPTO_XTS=m
 CONFIG_CRYPTO_AEGIS128=m
 CONFIG_CRYPTO_MD4=m
 CONFIG_CRYPTO_RMD160=m
 CONFIG_CRYPTO_SHA1=m
diff --git a/arch/m68k/configs/hp300_defconfig b/arch/m68k/configs/hp300_defconfig
index 7188948da864..cea5ab74b3b1 100644
--- a/arch/m68k/configs/hp300_defconfig
+++ b/arch/m68k/configs/hp300_defconfig
@@ -490,11 +490,10 @@ CONFIG_CRYPTO_TWOFISH=m
 CONFIG_CRYPTO_ADIANTUM=m
 CONFIG_CRYPTO_ARC4=m
 CONFIG_CRYPTO_CTS=m
 CONFIG_CRYPTO_HCTR2=m
 CONFIG_CRYPTO_LRW=m
-CONFIG_CRYPTO_PCBC=m
 CONFIG_CRYPTO_XTS=m
 CONFIG_CRYPTO_AEGIS128=m
 CONFIG_CRYPTO_MD4=m
 CONFIG_CRYPTO_RMD160=m
 CONFIG_CRYPTO_SHA1=m
diff --git a/arch/m68k/configs/mac_defconfig b/arch/m68k/configs/mac_defconfig
index fa5b04d59aa6..26406777376d 100644
--- a/arch/m68k/configs/mac_defconfig
+++ b/arch/m68k/configs/mac_defconfig
@@ -509,11 +509,10 @@ CONFIG_CRYPTO_TWOFISH=m
 CONFIG_CRYPTO_ADIANTUM=m
 CONFIG_CRYPTO_ARC4=m
 CONFIG_CRYPTO_CTS=m
 CONFIG_CRYPTO_HCTR2=m
 CONFIG_CRYPTO_LRW=m
-CONFIG_CRYPTO_PCBC=m
 CONFIG_CRYPTO_XTS=m
 CONFIG_CRYPTO_AEGIS128=m
 CONFIG_CRYPTO_MD4=m
 CONFIG_CRYPTO_RMD160=m
 CONFIG_CRYPTO_SHA1=m
diff --git a/arch/m68k/configs/multi_defconfig b/arch/m68k/configs/multi_defconfig
index 3bc9911549c0..8357491645ad 100644
--- a/arch/m68k/configs/multi_defconfig
+++ b/arch/m68k/configs/multi_defconfig
@@ -596,11 +596,10 @@ CONFIG_CRYPTO_TWOFISH=m
 CONFIG_CRYPTO_ADIANTUM=m
 CONFIG_CRYPTO_ARC4=m
 CONFIG_CRYPTO_CTS=m
 CONFIG_CRYPTO_HCTR2=m
 CONFIG_CRYPTO_LRW=m
-CONFIG_CRYPTO_PCBC=m
 CONFIG_CRYPTO_XTS=m
 CONFIG_CRYPTO_AEGIS128=m
 CONFIG_CRYPTO_MD4=m
 CONFIG_CRYPTO_RMD160=m
 CONFIG_CRYPTO_SHA1=m
diff --git a/arch/m68k/configs/mvme147_defconfig b/arch/m68k/configs/mvme147_defconfig
index 9f5c8e0a07f3..fe94f95862e7 100644
--- a/arch/m68k/configs/mvme147_defconfig
+++ b/arch/m68k/configs/mvme147_defconfig
@@ -480,11 +480,10 @@ CONFIG_CRYPTO_TWOFISH=m
 CONFIG_CRYPTO_ADIANTUM=m
 CONFIG_CRYPTO_ARC4=m
 CONFIG_CRYPTO_CTS=m
 CONFIG_CRYPTO_HCTR2=m
 CONFIG_CRYPTO_LRW=m
-CONFIG_CRYPTO_PCBC=m
 CONFIG_CRYPTO_XTS=m
 CONFIG_CRYPTO_AEGIS128=m
 CONFIG_CRYPTO_MD4=m
 CONFIG_CRYPTO_RMD160=m
 CONFIG_CRYPTO_SHA1=m
diff --git a/arch/m68k/configs/mvme16x_defconfig b/arch/m68k/configs/mvme16x_defconfig
index e5a6299aeae0..ba67cacc079e 100644
--- a/arch/m68k/configs/mvme16x_defconfig
+++ b/arch/m68k/configs/mvme16x_defconfig
@@ -481,11 +481,10 @@ CONFIG_CRYPTO_TWOFISH=m
 CONFIG_CRYPTO_ADIANTUM=m
 CONFIG_CRYPTO_ARC4=m
 CONFIG_CRYPTO_CTS=m
 CONFIG_CRYPTO_HCTR2=m
 CONFIG_CRYPTO_LRW=m
-CONFIG_CRYPTO_PCBC=m
 CONFIG_CRYPTO_XTS=m
 CONFIG_CRYPTO_AEGIS128=m
 CONFIG_CRYPTO_MD4=m
 CONFIG_CRYPTO_RMD160=m
 CONFIG_CRYPTO_SHA1=m
diff --git a/arch/m68k/configs/q40_defconfig b/arch/m68k/configs/q40_defconfig
index e79bbb397261..552399979e4b 100644
--- a/arch/m68k/configs/q40_defconfig
+++ b/arch/m68k/configs/q40_defconfig
@@ -499,11 +499,10 @@ CONFIG_CRYPTO_TWOFISH=m
 CONFIG_CRYPTO_ADIANTUM=m
 CONFIG_CRYPTO_ARC4=m
 CONFIG_CRYPTO_CTS=m
 CONFIG_CRYPTO_HCTR2=m
 CONFIG_CRYPTO_LRW=m
-CONFIG_CRYPTO_PCBC=m
 CONFIG_CRYPTO_XTS=m
 CONFIG_CRYPTO_AEGIS128=m
 CONFIG_CRYPTO_MD4=m
 CONFIG_CRYPTO_RMD160=m
 CONFIG_CRYPTO_SHA1=m
diff --git a/arch/m68k/configs/sun3_defconfig b/arch/m68k/configs/sun3_defconfig
index 7aa76de5c472..b4f3935d3d18 100644
--- a/arch/m68k/configs/sun3_defconfig
+++ b/arch/m68k/configs/sun3_defconfig
@@ -478,11 +478,10 @@ CONFIG_CRYPTO_TWOFISH=m
 CONFIG_CRYPTO_ADIANTUM=m
 CONFIG_CRYPTO_ARC4=m
 CONFIG_CRYPTO_CTS=m
 CONFIG_CRYPTO_HCTR2=m
 CONFIG_CRYPTO_LRW=m
-CONFIG_CRYPTO_PCBC=m
 CONFIG_CRYPTO_XTS=m
 CONFIG_CRYPTO_AEGIS128=m
 CONFIG_CRYPTO_MD4=m
 CONFIG_CRYPTO_RMD160=m
 CONFIG_CRYPTO_SHA1=m
diff --git a/arch/m68k/configs/sun3x_defconfig b/arch/m68k/configs/sun3x_defconfig
index 2ecd8bd097ea..bb519520ae6e 100644
--- a/arch/m68k/configs/sun3x_defconfig
+++ b/arch/m68k/configs/sun3x_defconfig
@@ -478,11 +478,10 @@ CONFIG_CRYPTO_TWOFISH=m
 CONFIG_CRYPTO_ADIANTUM=m
 CONFIG_CRYPTO_ARC4=m
 CONFIG_CRYPTO_CTS=m
 CONFIG_CRYPTO_HCTR2=m
 CONFIG_CRYPTO_LRW=m
-CONFIG_CRYPTO_PCBC=m
 CONFIG_CRYPTO_XTS=m
 CONFIG_CRYPTO_AEGIS128=m
 CONFIG_CRYPTO_MD4=m
 CONFIG_CRYPTO_RMD160=m
 CONFIG_CRYPTO_SHA1=m
diff --git a/arch/mips/configs/bigsur_defconfig b/arch/mips/configs/bigsur_defconfig
index 74c6821e4c37..611dc0dd392d 100644
--- a/arch/mips/configs/bigsur_defconfig
+++ b/arch/mips/configs/bigsur_defconfig
@@ -205,11 +205,10 @@ CONFIG_DEFAULT_SECURITY_DAC=y
 CONFIG_CRYPTO_NULL=y
 CONFIG_CRYPTO_CCM=m
 CONFIG_CRYPTO_GCM=m
 CONFIG_CRYPTO_CTS=m
 CONFIG_CRYPTO_LRW=m
-CONFIG_CRYPTO_PCBC=m
 CONFIG_CRYPTO_XTS=m
 CONFIG_CRYPTO_HMAC=y
 CONFIG_CRYPTO_XCBC=m
 CONFIG_CRYPTO_MD4=m
 CONFIG_CRYPTO_RMD160=m
diff --git a/arch/mips/configs/decstation_64_defconfig b/arch/mips/configs/decstation_64_defconfig
index e98d218ed4c1..0e8e4e827515 100644
--- a/arch/mips/configs/decstation_64_defconfig
+++ b/arch/mips/configs/decstation_64_defconfig
@@ -172,11 +172,10 @@ CONFIG_CRYPTO_CCM=m
 CONFIG_CRYPTO_GCM=m
 CONFIG_CRYPTO_CHACHA20POLY1305=m
 CONFIG_CRYPTO_CTS=m
 CONFIG_CRYPTO_LRW=m
 CONFIG_CRYPTO_OFB=m
-CONFIG_CRYPTO_PCBC=m
 CONFIG_CRYPTO_XTS=m
 CONFIG_CRYPTO_CMAC=m
 CONFIG_CRYPTO_XCBC=m
 CONFIG_CRYPTO_CRC32=m
 CONFIG_CRYPTO_MD4=m
diff --git a/arch/mips/configs/decstation_defconfig b/arch/mips/configs/decstation_defconfig
index 2b4e06cc238b..c664928efb9f 100644
--- a/arch/mips/configs/decstation_defconfig
+++ b/arch/mips/configs/decstation_defconfig
@@ -167,11 +167,10 @@ CONFIG_CRYPTO_CCM=m
 CONFIG_CRYPTO_GCM=m
 CONFIG_CRYPTO_CHACHA20POLY1305=m
 CONFIG_CRYPTO_CTS=m
 CONFIG_CRYPTO_LRW=m
 CONFIG_CRYPTO_OFB=m
-CONFIG_CRYPTO_PCBC=m
 CONFIG_CRYPTO_XTS=m
 CONFIG_CRYPTO_CMAC=m
 CONFIG_CRYPTO_XCBC=m
 CONFIG_CRYPTO_CRC32=m
 CONFIG_CRYPTO_MD4=m
diff --git a/arch/mips/configs/decstation_r4k_defconfig b/arch/mips/configs/decstation_r4k_defconfig
index 280553269156..402255ae09ec 100644
--- a/arch/mips/configs/decstation_r4k_defconfig
+++ b/arch/mips/configs/decstation_r4k_defconfig
@@ -167,11 +167,10 @@ CONFIG_CRYPTO_CCM=m
 CONFIG_CRYPTO_GCM=m
 CONFIG_CRYPTO_CHACHA20POLY1305=m
 CONFIG_CRYPTO_CTS=m
 CONFIG_CRYPTO_LRW=m
 CONFIG_CRYPTO_OFB=m
-CONFIG_CRYPTO_PCBC=m
 CONFIG_CRYPTO_XTS=m
 CONFIG_CRYPTO_CMAC=m
 CONFIG_CRYPTO_XCBC=m
 CONFIG_CRYPTO_CRC32=m
 CONFIG_CRYPTO_MD4=m
diff --git a/arch/mips/configs/fuloong2e_defconfig b/arch/mips/configs/fuloong2e_defconfig
index b6fe3c962464..405799a9ed2a 100644
--- a/arch/mips/configs/fuloong2e_defconfig
+++ b/arch/mips/configs/fuloong2e_defconfig
@@ -207,11 +207,10 @@ CONFIG_NLS_CODEPAGE_936=y
 CONFIG_NLS_ISO8859_1=y
 CONFIG_NLS_UTF8=y
 CONFIG_CRYPTO_AUTHENC=m
 CONFIG_CRYPTO_GCM=m
 CONFIG_CRYPTO_CTS=m
-CONFIG_CRYPTO_PCBC=m
 CONFIG_CRYPTO_XTS=m
 CONFIG_CRYPTO_HMAC=y
 CONFIG_CRYPTO_RMD160=m
 CONFIG_CRYPTO_SEED=m
 CONFIG_CRYPTO_DEFLATE=m
diff --git a/arch/mips/configs/gpr_defconfig b/arch/mips/configs/gpr_defconfig
index ed1a8f80f96e..47016655a089 100644
--- a/arch/mips/configs/gpr_defconfig
+++ b/arch/mips/configs/gpr_defconfig
@@ -247,11 +247,10 @@ CONFIG_ROOT_NFS=y
 CONFIG_NLS_CODEPAGE_437=y
 CONFIG_NLS_CODEPAGE_850=y
 CONFIG_NLS_ISO8859_1=y
 CONFIG_CRYPTO_AUTHENC=m
 CONFIG_CRYPTO_BENCHMARK=m
-CONFIG_CRYPTO_PCBC=m
 CONFIG_CRYPTO_MD4=m
 CONFIG_CRYPTO_SHA512=m
 CONFIG_CRYPTO_WP512=m
 CONFIG_CRYPTO_ANUBIS=m
 CONFIG_CRYPTO_BLOWFISH=m
diff --git a/arch/mips/configs/ip22_defconfig b/arch/mips/configs/ip22_defconfig
index 50895ed06592..822cc1ed64c2 100644
--- a/arch/mips/configs/ip22_defconfig
+++ b/arch/mips/configs/ip22_defconfig
@@ -304,11 +304,10 @@ CONFIG_NLS_UTF8=m
 CONFIG_KEYS=y
 CONFIG_CRYPTO_CRYPTD=m
 CONFIG_CRYPTO_GCM=m
 CONFIG_CRYPTO_CTS=m
 CONFIG_CRYPTO_LRW=m
-CONFIG_CRYPTO_PCBC=m
 CONFIG_CRYPTO_XTS=m
 CONFIG_CRYPTO_HMAC=y
 CONFIG_CRYPTO_XCBC=m
 CONFIG_CRYPTO_RMD160=m
 CONFIG_CRYPTO_WP512=m
diff --git a/arch/mips/configs/ip27_defconfig b/arch/mips/configs/ip27_defconfig
index ff7e06b92f58..d108fd7b752b 100644
--- a/arch/mips/configs/ip27_defconfig
+++ b/arch/mips/configs/ip27_defconfig
@@ -294,11 +294,10 @@ CONFIG_OMFS_FS=m
 CONFIG_NFS_FS=y
 CONFIG_SECURITYFS=y
 CONFIG_CRYPTO_CRYPTD=m
 CONFIG_CRYPTO_CTS=m
 CONFIG_CRYPTO_LRW=m
-CONFIG_CRYPTO_PCBC=m
 CONFIG_CRYPTO_XTS=m
 CONFIG_CRYPTO_HMAC=y
 CONFIG_CRYPTO_XCBC=m
 CONFIG_CRYPTO_MD4=m
 CONFIG_CRYPTO_RMD160=m
diff --git a/arch/mips/configs/ip30_defconfig b/arch/mips/configs/ip30_defconfig
index d9f748f8cfaa..028286029877 100644
--- a/arch/mips/configs/ip30_defconfig
+++ b/arch/mips/configs/ip30_defconfig
@@ -168,11 +168,10 @@ CONFIG_CRYPTO_CAST5=m
 CONFIG_CRYPTO_CAST6=m
 CONFIG_CRYPTO_SERPENT=m
 CONFIG_CRYPTO_TWOFISH=m
 CONFIG_CRYPTO_CTS=m
 CONFIG_CRYPTO_LRW=m
-CONFIG_CRYPTO_PCBC=m
 CONFIG_CRYPTO_XTS=m
 CONFIG_CRYPTO_HMAC=y
 CONFIG_CRYPTO_MD4=m
 CONFIG_CRYPTO_RMD160=m
 CONFIG_CRYPTO_WP512=m
diff --git a/arch/mips/configs/ip32_defconfig b/arch/mips/configs/ip32_defconfig
index 4b15f895be63..5ddbaa0aafaf 100644
--- a/arch/mips/configs/ip32_defconfig
+++ b/arch/mips/configs/ip32_defconfig
@@ -152,11 +152,10 @@ CONFIG_NLS_UTF8=m
 CONFIG_KEYS=y
 CONFIG_CRYPTO_NULL=y
 CONFIG_CRYPTO_CBC=y
 CONFIG_CRYPTO_ECB=y
 CONFIG_CRYPTO_LRW=y
-CONFIG_CRYPTO_PCBC=y
 CONFIG_CRYPTO_HMAC=y
 CONFIG_CRYPTO_XCBC=y
 CONFIG_CRYPTO_MD4=y
 CONFIG_CRYPTO_SHA1=y
 CONFIG_CRYPTO_SHA256=y
diff --git a/arch/mips/configs/lemote2f_defconfig b/arch/mips/configs/lemote2f_defconfig
index bbcdfc8134cb..326f30748030 100644
--- a/arch/mips/configs/lemote2f_defconfig
+++ b/arch/mips/configs/lemote2f_defconfig
@@ -302,11 +302,10 @@ CONFIG_CRYPTO_CAMELLIA=m
 CONFIG_CRYPTO_CAST5=m
 CONFIG_CRYPTO_CAST6=m
 CONFIG_CRYPTO_SERPENT=m
 CONFIG_CRYPTO_TWOFISH=m
 CONFIG_CRYPTO_LRW=m
-CONFIG_CRYPTO_PCBC=m
 CONFIG_CRYPTO_XTS=m
 CONFIG_CRYPTO_RMD160=m
 CONFIG_CRYPTO_SHA1=m
 CONFIG_CRYPTO_WP512=m
 CONFIG_CRYPTO_XCBC=m
diff --git a/arch/mips/configs/malta_defconfig b/arch/mips/configs/malta_defconfig
index 85e781607299..61c9d5cd1a75 100644
--- a/arch/mips/configs/malta_defconfig
+++ b/arch/mips/configs/malta_defconfig
@@ -386,11 +386,10 @@ CONFIG_NLS_ISO8859_14=m
 CONFIG_NLS_ISO8859_15=m
 CONFIG_NLS_KOI8_R=m
 CONFIG_NLS_KOI8_U=m
 CONFIG_CRYPTO_CRYPTD=m
 CONFIG_CRYPTO_LRW=m
-CONFIG_CRYPTO_PCBC=m
 CONFIG_CRYPTO_HMAC=y
 CONFIG_CRYPTO_XCBC=m
 CONFIG_CRYPTO_MD4=m
 CONFIG_CRYPTO_SHA512=m
 CONFIG_CRYPTO_WP512=m
diff --git a/arch/mips/configs/malta_kvm_defconfig b/arch/mips/configs/malta_kvm_defconfig
index 2db5f50fed3b..f862fbc7fbb7 100644
--- a/arch/mips/configs/malta_kvm_defconfig
+++ b/arch/mips/configs/malta_kvm_defconfig
@@ -393,11 +393,10 @@ CONFIG_NLS_ISO8859_14=m
 CONFIG_NLS_ISO8859_15=m
 CONFIG_NLS_KOI8_R=m
 CONFIG_NLS_KOI8_U=m
 CONFIG_CRYPTO_CRYPTD=m
 CONFIG_CRYPTO_LRW=m
-CONFIG_CRYPTO_PCBC=m
 CONFIG_CRYPTO_HMAC=y
 CONFIG_CRYPTO_XCBC=m
 CONFIG_CRYPTO_MD4=m
 CONFIG_CRYPTO_SHA512=m
 CONFIG_CRYPTO_WP512=m
diff --git a/arch/mips/configs/malta_qemu_32r6_defconfig b/arch/mips/configs/malta_qemu_32r6_defconfig
index 5687e10c1bc8..14cdd23f1acb 100644
--- a/arch/mips/configs/malta_qemu_32r6_defconfig
+++ b/arch/mips/configs/malta_qemu_32r6_defconfig
@@ -161,11 +161,10 @@ CONFIG_ROOT_NFS=y
 CONFIG_CIFS=m
 CONFIG_CIFS_XATTR=y
 CONFIG_CIFS_POSIX=y
 CONFIG_NLS_CODEPAGE_437=m
 CONFIG_NLS_ISO8859_1=m
-CONFIG_CRYPTO_PCBC=m
 CONFIG_CRYPTO_HMAC=y
 CONFIG_CRYPTO_WP512=m
 CONFIG_CRYPTO_ANUBIS=m
 CONFIG_CRYPTO_BLOWFISH=m
 CONFIG_CRYPTO_CAST5=m
diff --git a/arch/mips/configs/maltaaprp_defconfig b/arch/mips/configs/maltaaprp_defconfig
index abd22bff517b..2943593264b9 100644
--- a/arch/mips/configs/maltaaprp_defconfig
+++ b/arch/mips/configs/maltaaprp_defconfig
@@ -162,11 +162,10 @@ CONFIG_ROOT_NFS=y
 CONFIG_CIFS=m
 CONFIG_CIFS_XATTR=y
 CONFIG_CIFS_POSIX=y
 CONFIG_NLS_CODEPAGE_437=m
 CONFIG_NLS_ISO8859_1=m
-CONFIG_CRYPTO_PCBC=m
 CONFIG_CRYPTO_HMAC=y
 CONFIG_CRYPTO_WP512=m
 CONFIG_CRYPTO_ANUBIS=m
 CONFIG_CRYPTO_BLOWFISH=m
 CONFIG_CRYPTO_CAST5=m
diff --git a/arch/mips/configs/maltasmvp_defconfig b/arch/mips/configs/maltasmvp_defconfig
index 3fb3def8112d..47226fca0548 100644
--- a/arch/mips/configs/maltasmvp_defconfig
+++ b/arch/mips/configs/maltasmvp_defconfig
@@ -163,11 +163,10 @@ CONFIG_ROOT_NFS=y
 CONFIG_CIFS=m
 CONFIG_CIFS_XATTR=y
 CONFIG_CIFS_POSIX=y
 CONFIG_NLS_CODEPAGE_437=m
 CONFIG_NLS_ISO8859_1=m
-CONFIG_CRYPTO_PCBC=m
 CONFIG_CRYPTO_HMAC=y
 CONFIG_CRYPTO_WP512=m
 CONFIG_CRYPTO_ANUBIS=m
 CONFIG_CRYPTO_BLOWFISH=m
 CONFIG_CRYPTO_CAST5=m
diff --git a/arch/mips/configs/maltasmvp_eva_defconfig b/arch/mips/configs/maltasmvp_eva_defconfig
index 92e026912f68..09187a78409f 100644
--- a/arch/mips/configs/maltasmvp_eva_defconfig
+++ b/arch/mips/configs/maltasmvp_eva_defconfig
@@ -165,11 +165,10 @@ CONFIG_ROOT_NFS=y
 CONFIG_CIFS=m
 CONFIG_CIFS_XATTR=y
 CONFIG_CIFS_POSIX=y
 CONFIG_NLS_CODEPAGE_437=m
 CONFIG_NLS_ISO8859_1=m
-CONFIG_CRYPTO_PCBC=m
 CONFIG_CRYPTO_HMAC=y
 CONFIG_CRYPTO_WP512=m
 CONFIG_CRYPTO_ANUBIS=m
 CONFIG_CRYPTO_BLOWFISH=m
 CONFIG_CRYPTO_CAST5=m
diff --git a/arch/mips/configs/maltaup_defconfig b/arch/mips/configs/maltaup_defconfig
index 7a675fd3321f..a80783097c1e 100644
--- a/arch/mips/configs/maltaup_defconfig
+++ b/arch/mips/configs/maltaup_defconfig
@@ -161,11 +161,10 @@ CONFIG_ROOT_NFS=y
 CONFIG_CIFS=m
 CONFIG_CIFS_XATTR=y
 CONFIG_CIFS_POSIX=y
 CONFIG_NLS_CODEPAGE_437=m
 CONFIG_NLS_ISO8859_1=m
-CONFIG_CRYPTO_PCBC=m
 CONFIG_CRYPTO_HMAC=y
 CONFIG_CRYPTO_WP512=m
 CONFIG_CRYPTO_ANUBIS=m
 CONFIG_CRYPTO_BLOWFISH=m
 CONFIG_CRYPTO_CAST5=m
diff --git a/arch/mips/configs/maltaup_xpa_defconfig b/arch/mips/configs/maltaup_xpa_defconfig
index 865ae23bf11d..e660c503654e 100644
--- a/arch/mips/configs/maltaup_xpa_defconfig
+++ b/arch/mips/configs/maltaup_xpa_defconfig
@@ -392,11 +392,10 @@ CONFIG_NLS_ISO8859_14=m
 CONFIG_NLS_ISO8859_15=m
 CONFIG_NLS_KOI8_R=m
 CONFIG_NLS_KOI8_U=m
 CONFIG_CRYPTO_CRYPTD=m
 CONFIG_CRYPTO_LRW=m
-CONFIG_CRYPTO_PCBC=m
 CONFIG_CRYPTO_HMAC=y
 CONFIG_CRYPTO_XCBC=m
 CONFIG_CRYPTO_MD4=m
 CONFIG_CRYPTO_SHA512=m
 CONFIG_CRYPTO_WP512=m
diff --git a/arch/mips/configs/mtx1_defconfig b/arch/mips/configs/mtx1_defconfig
index 3629afbe5d75..42a0f4f70437 100644
--- a/arch/mips/configs/mtx1_defconfig
+++ b/arch/mips/configs/mtx1_defconfig
@@ -624,11 +624,10 @@ CONFIG_NLS_ISO8859_14=m
 CONFIG_NLS_ISO8859_15=m
 CONFIG_NLS_KOI8_R=m
 CONFIG_NLS_KOI8_U=m
 CONFIG_NLS_UTF8=m
 CONFIG_CRYPTO_BENCHMARK=m
-CONFIG_CRYPTO_PCBC=m
 CONFIG_CRYPTO_HMAC=y
 CONFIG_CRYPTO_MD5=y
 CONFIG_CRYPTO_WP512=m
 CONFIG_CRYPTO_ANUBIS=m
 CONFIG_CRYPTO_BLOWFISH=m
diff --git a/arch/mips/configs/rm200_defconfig b/arch/mips/configs/rm200_defconfig
index 7e04a6b1b4eb..291c6644035d 100644
--- a/arch/mips/configs/rm200_defconfig
+++ b/arch/mips/configs/rm200_defconfig
@@ -370,11 +370,10 @@ CONFIG_NLS_ISO8859_14=m
 CONFIG_NLS_ISO8859_15=m
 CONFIG_NLS_KOI8_R=m
 CONFIG_NLS_KOI8_U=m
 CONFIG_NLS_UTF8=m
 CONFIG_CRYPTO_LRW=m
-CONFIG_CRYPTO_PCBC=m
 CONFIG_CRYPTO_HMAC=y
 CONFIG_CRYPTO_XCBC=m
 CONFIG_CRYPTO_WP512=m
 CONFIG_CRYPTO_ANUBIS=m
 CONFIG_CRYPTO_BLOWFISH=m
diff --git a/arch/mips/configs/sb1250_swarm_defconfig b/arch/mips/configs/sb1250_swarm_defconfig
index fe8a5a3ff328..a5b66b9f6d39 100644
--- a/arch/mips/configs/sb1250_swarm_defconfig
+++ b/arch/mips/configs/sb1250_swarm_defconfig
@@ -78,11 +78,10 @@ CONFIG_NFS_FS=y
 CONFIG_ROOT_NFS=y
 CONFIG_CRYPTO_CRYPTD=m
 CONFIG_CRYPTO_AUTHENC=m
 CONFIG_CRYPTO_CBC=m
 CONFIG_CRYPTO_LRW=m
-CONFIG_CRYPTO_PCBC=m
 CONFIG_CRYPTO_XTS=m
 CONFIG_CRYPTO_HMAC=y
 CONFIG_CRYPTO_XCBC=m
 CONFIG_CRYPTO_MD4=m
 CONFIG_CRYPTO_SHA512=m
diff --git a/arch/parisc/configs/generic-64bit_defconfig b/arch/parisc/configs/generic-64bit_defconfig
index 0503b4ef4c7a..406f8174a1d2 100644
--- a/arch/parisc/configs/generic-64bit_defconfig
+++ b/arch/parisc/configs/generic-64bit_defconfig
@@ -280,11 +280,10 @@ CONFIG_NLS_CODEPAGE_1251=m
 CONFIG_NLS_ASCII=m
 CONFIG_NLS_ISO8859_1=m
 CONFIG_NLS_ISO8859_2=m
 CONFIG_NLS_UTF8=m
 CONFIG_CRYPTO_ECB=m
-CONFIG_CRYPTO_PCBC=m
 CONFIG_CRYPTO_MD4=m
 CONFIG_CRYPTO_MD5=y
 CONFIG_CRYPTO_DEFLATE=m
 # CONFIG_CRYPTO_HW is not set
 CONFIG_PRINTK_TIME=y
diff --git a/arch/powerpc/configs/44x/akebono_defconfig b/arch/powerpc/configs/44x/akebono_defconfig
index 11ad5ed3cc90..bdb0e6ece6ec 100644
--- a/arch/powerpc/configs/44x/akebono_defconfig
+++ b/arch/powerpc/configs/44x/akebono_defconfig
@@ -122,9 +122,8 @@ CONFIG_DETECT_HUNG_TASK=y
 CONFIG_XMON=y
 CONFIG_XMON_DEFAULT=y
 CONFIG_PPC_EARLY_DEBUG=y
 CONFIG_PPC_EARLY_DEBUG_44x_PHYSLOW=0x00010000
 CONFIG_PPC_EARLY_DEBUG_44x_PHYSHIGH=0x33f
-CONFIG_CRYPTO_PCBC=y
 CONFIG_CRYPTO_MD5=y
 CONFIG_CRYPTO_DES=y
 # CONFIG_CRYPTO_HW is not set
diff --git a/arch/powerpc/configs/44x/bamboo_defconfig b/arch/powerpc/configs/44x/bamboo_defconfig
index acbce718eaa8..bfffea3a54b2 100644
--- a/arch/powerpc/configs/44x/bamboo_defconfig
+++ b/arch/powerpc/configs/44x/bamboo_defconfig
@@ -44,8 +44,7 @@ CONFIG_DEBUG_FS=y
 CONFIG_MAGIC_SYSRQ=y
 CONFIG_DETECT_HUNG_TASK=y
 # CONFIG_DEBUG_BUGVERBOSE is not set
 CONFIG_CRYPTO_CBC=y
 CONFIG_CRYPTO_ECB=y
-CONFIG_CRYPTO_PCBC=y
 CONFIG_CRYPTO_MD5=y
 CONFIG_CRYPTO_DES=y
diff --git a/arch/powerpc/configs/44x/currituck_defconfig b/arch/powerpc/configs/44x/currituck_defconfig
index 7283b7d4a1a5..6d6ec5d569b1 100644
--- a/arch/powerpc/configs/44x/currituck_defconfig
+++ b/arch/powerpc/configs/44x/currituck_defconfig
@@ -81,9 +81,8 @@ CONFIG_XMON_DEFAULT=y
 CONFIG_PPC_EARLY_DEBUG=y
 CONFIG_PPC_EARLY_DEBUG_44x_PHYSLOW=0x10000000
 CONFIG_PPC_EARLY_DEBUG_44x_PHYSHIGH=0x200
 CONFIG_CRYPTO_CBC=y
 CONFIG_CRYPTO_ECB=y
-CONFIG_CRYPTO_PCBC=y
 CONFIG_CRYPTO_MD5=y
 CONFIG_CRYPTO_DES=y
 # CONFIG_CRYPTO_HW is not set
diff --git a/arch/powerpc/configs/44x/ebony_defconfig b/arch/powerpc/configs/44x/ebony_defconfig
index 93d2a4e64af9..0d6f9bdf8ad3 100644
--- a/arch/powerpc/configs/44x/ebony_defconfig
+++ b/arch/powerpc/configs/44x/ebony_defconfig
@@ -50,9 +50,8 @@ CONFIG_ROOT_NFS=y
 CONFIG_DEBUG_FS=y
 CONFIG_MAGIC_SYSRQ=y
 CONFIG_DETECT_HUNG_TASK=y
 CONFIG_CRYPTO_CBC=y
 CONFIG_CRYPTO_ECB=y
-CONFIG_CRYPTO_PCBC=y
 CONFIG_CRYPTO_MD5=y
 CONFIG_CRYPTO_DES=y
 # CONFIG_CRYPTO_HW is not set
diff --git a/arch/powerpc/configs/44x/eiger_defconfig b/arch/powerpc/configs/44x/eiger_defconfig
index 509300f400e2..48ab405ab80b 100644
--- a/arch/powerpc/configs/44x/eiger_defconfig
+++ b/arch/powerpc/configs/44x/eiger_defconfig
@@ -77,11 +77,10 @@ CONFIG_CRYPTO_AUTHENC=y
 CONFIG_CRYPTO_CCM=y
 CONFIG_CRYPTO_GCM=y
 CONFIG_CRYPTO_CBC=y
 CONFIG_CRYPTO_CTS=y
 CONFIG_CRYPTO_LRW=y
-CONFIG_CRYPTO_PCBC=y
 CONFIG_CRYPTO_XTS=y
 CONFIG_CRYPTO_XCBC=y
 CONFIG_CRYPTO_MD4=y
 CONFIG_CRYPTO_MD5=y
 CONFIG_CRYPTO_SHA1=y
diff --git a/arch/powerpc/configs/44x/fsp2_defconfig b/arch/powerpc/configs/44x/fsp2_defconfig
index 5492537f4c6c..b8b21fa15a07 100644
--- a/arch/powerpc/configs/44x/fsp2_defconfig
+++ b/arch/powerpc/configs/44x/fsp2_defconfig
@@ -113,9 +113,8 @@ CONFIG_DYNAMIC_DEBUG=y
 CONFIG_DEBUG_INFO_DWARF_TOOLCHAIN_DEFAULT=y
 CONFIG_MAGIC_SYSRQ=y
 CONFIG_DETECT_HUNG_TASK=y
 CONFIG_CRYPTO_CBC=y
 CONFIG_CRYPTO_ECB=y
-CONFIG_CRYPTO_PCBC=y
 CONFIG_CRYPTO_MD5=y
 CONFIG_CRYPTO_DES=y
 # CONFIG_CRYPTO_HW is not set
diff --git a/arch/powerpc/configs/44x/icon_defconfig b/arch/powerpc/configs/44x/icon_defconfig
index fb9a15573546..4f7cd127dc77 100644
--- a/arch/powerpc/configs/44x/icon_defconfig
+++ b/arch/powerpc/configs/44x/icon_defconfig
@@ -80,8 +80,7 @@ CONFIG_NLS_ISO8859_15=y
 CONFIG_MAGIC_SYSRQ=y
 CONFIG_DETECT_HUNG_TASK=y
 # CONFIG_DEBUG_BUGVERBOSE is not set
 CONFIG_CRYPTO_CBC=y
 CONFIG_CRYPTO_ECB=y
-CONFIG_CRYPTO_PCBC=y
 CONFIG_CRYPTO_MD5=y
 CONFIG_CRYPTO_DES=y
diff --git a/arch/powerpc/configs/44x/iss476-smp_defconfig b/arch/powerpc/configs/44x/iss476-smp_defconfig
index 0f6380e1e612..5188ec5406fd 100644
--- a/arch/powerpc/configs/44x/iss476-smp_defconfig
+++ b/arch/powerpc/configs/44x/iss476-smp_defconfig
@@ -60,9 +60,8 @@ CONFIG_DEBUG_INFO_DWARF_TOOLCHAIN_DEFAULT=y
 CONFIG_MAGIC_SYSRQ=y
 CONFIG_DETECT_HUNG_TASK=y
 CONFIG_PPC_EARLY_DEBUG=y
 CONFIG_CRYPTO_CBC=y
 CONFIG_CRYPTO_ECB=y
-CONFIG_CRYPTO_PCBC=y
 CONFIG_CRYPTO_MD5=y
 CONFIG_CRYPTO_DES=y
 # CONFIG_CRYPTO_HW is not set
diff --git a/arch/powerpc/configs/44x/katmai_defconfig b/arch/powerpc/configs/44x/katmai_defconfig
index 1a0f1c3e0ee9..59622bd1327d 100644
--- a/arch/powerpc/configs/44x/katmai_defconfig
+++ b/arch/powerpc/configs/44x/katmai_defconfig
@@ -49,8 +49,7 @@ CONFIG_ROOT_NFS=y
 CONFIG_MAGIC_SYSRQ=y
 CONFIG_DETECT_HUNG_TASK=y
 # CONFIG_DEBUG_BUGVERBOSE is not set
 CONFIG_CRYPTO_CBC=y
 CONFIG_CRYPTO_ECB=y
-CONFIG_CRYPTO_PCBC=y
 CONFIG_CRYPTO_MD5=y
 CONFIG_CRYPTO_DES=y
diff --git a/arch/powerpc/configs/44x/rainier_defconfig b/arch/powerpc/configs/44x/rainier_defconfig
index 6dd67de06a0b..22d10c33f374 100644
--- a/arch/powerpc/configs/44x/rainier_defconfig
+++ b/arch/powerpc/configs/44x/rainier_defconfig
@@ -55,8 +55,7 @@ CONFIG_DETECT_HUNG_TASK=y
 # CONFIG_DEBUG_BUGVERBOSE is not set
 CONFIG_PPC_EARLY_DEBUG=y
 CONFIG_PPC_EARLY_DEBUG_44x_PHYSLOW=0xef600300
 CONFIG_CRYPTO_CBC=y
 CONFIG_CRYPTO_ECB=y
-CONFIG_CRYPTO_PCBC=y
 CONFIG_CRYPTO_MD5=y
 CONFIG_CRYPTO_DES=y
diff --git a/arch/powerpc/configs/44x/redwood_defconfig b/arch/powerpc/configs/44x/redwood_defconfig
index e28d76416537..1e883938ca11 100644
--- a/arch/powerpc/configs/44x/redwood_defconfig
+++ b/arch/powerpc/configs/44x/redwood_defconfig
@@ -76,11 +76,10 @@ CONFIG_CRYPTO_AUTHENC=y
 CONFIG_CRYPTO_CCM=y
 CONFIG_CRYPTO_GCM=y
 CONFIG_CRYPTO_CBC=y
 CONFIG_CRYPTO_CTS=y
 CONFIG_CRYPTO_LRW=y
-CONFIG_CRYPTO_PCBC=y
 CONFIG_CRYPTO_XTS=y
 CONFIG_CRYPTO_XCBC=y
 CONFIG_CRYPTO_MD4=y
 CONFIG_CRYPTO_MD5=y
 CONFIG_CRYPTO_SHA1=y
diff --git a/arch/powerpc/configs/44x/sequoia_defconfig b/arch/powerpc/configs/44x/sequoia_defconfig
index b4984eab43eb..ce8912b406eb 100644
--- a/arch/powerpc/configs/44x/sequoia_defconfig
+++ b/arch/powerpc/configs/44x/sequoia_defconfig
@@ -56,8 +56,7 @@ CONFIG_DEBUG_FS=y
 CONFIG_MAGIC_SYSRQ=y
 CONFIG_DETECT_HUNG_TASK=y
 # CONFIG_DEBUG_BUGVERBOSE is not set
 CONFIG_CRYPTO_CBC=y
 CONFIG_CRYPTO_ECB=y
-CONFIG_CRYPTO_PCBC=y
 CONFIG_CRYPTO_MD5=y
 CONFIG_CRYPTO_DES=y
diff --git a/arch/powerpc/configs/44x/taishan_defconfig b/arch/powerpc/configs/44x/taishan_defconfig
index 3ea5932ab852..8263b3b7d0a1 100644
--- a/arch/powerpc/configs/44x/taishan_defconfig
+++ b/arch/powerpc/configs/44x/taishan_defconfig
@@ -50,8 +50,7 @@ CONFIG_DEBUG_FS=y
 CONFIG_MAGIC_SYSRQ=y
 CONFIG_DETECT_HUNG_TASK=y
 # CONFIG_DEBUG_BUGVERBOSE is not set
 CONFIG_CRYPTO_CBC=y
 CONFIG_CRYPTO_ECB=y
-CONFIG_CRYPTO_PCBC=y
 CONFIG_CRYPTO_MD5=y
 CONFIG_CRYPTO_DES=y
diff --git a/arch/powerpc/configs/52xx/cm5200_defconfig b/arch/powerpc/configs/52xx/cm5200_defconfig
index 2412a6bf7ee6..ddf1280fe295 100644
--- a/arch/powerpc/configs/52xx/cm5200_defconfig
+++ b/arch/powerpc/configs/52xx/cm5200_defconfig
@@ -73,6 +73,5 @@ CONFIG_NLS_CODEPAGE_437=y
 CONFIG_NLS_ISO8859_1=y
 CONFIG_PRINTK_TIME=y
 CONFIG_DETECT_HUNG_TASK=y
 # CONFIG_DEBUG_BUGVERBOSE is not set
 CONFIG_CRYPTO_ECB=y
-CONFIG_CRYPTO_PCBC=y
diff --git a/arch/powerpc/configs/52xx/motionpro_defconfig b/arch/powerpc/configs/52xx/motionpro_defconfig
index 6186ead1e105..d7165dbed529 100644
--- a/arch/powerpc/configs/52xx/motionpro_defconfig
+++ b/arch/powerpc/configs/52xx/motionpro_defconfig
@@ -86,6 +86,5 @@ CONFIG_NLS_ISO8859_1=y
 CONFIG_PRINTK_TIME=y
 CONFIG_DEBUG_INFO_DWARF_TOOLCHAIN_DEFAULT=y
 CONFIG_DETECT_HUNG_TASK=y
 # CONFIG_DEBUG_BUGVERBOSE is not set
 CONFIG_CRYPTO_ECB=y
-CONFIG_CRYPTO_PCBC=y
diff --git a/arch/powerpc/configs/52xx/tqm5200_defconfig b/arch/powerpc/configs/52xx/tqm5200_defconfig
index 688f703d8e22..1d2d68b0f137 100644
--- a/arch/powerpc/configs/52xx/tqm5200_defconfig
+++ b/arch/powerpc/configs/52xx/tqm5200_defconfig
@@ -87,6 +87,5 @@ CONFIG_NLS_ISO8859_1=y
 CONFIG_PRINTK_TIME=y
 CONFIG_DEBUG_INFO_DWARF_TOOLCHAIN_DEFAULT=y
 CONFIG_DETECT_HUNG_TASK=y
 # CONFIG_DEBUG_BUGVERBOSE is not set
 CONFIG_CRYPTO_ECB=y
-CONFIG_CRYPTO_PCBC=y
diff --git a/arch/powerpc/configs/83xx/asp8347_defconfig b/arch/powerpc/configs/83xx/asp8347_defconfig
index 10192410b33c..07e00c8d6023 100644
--- a/arch/powerpc/configs/83xx/asp8347_defconfig
+++ b/arch/powerpc/configs/83xx/asp8347_defconfig
@@ -66,6 +66,5 @@ CONFIG_TMPFS=y
 CONFIG_JFFS2_FS=y
 CONFIG_NFS_FS=y
 CONFIG_NFS_V4=y
 CONFIG_ROOT_NFS=y
 CONFIG_CRYPTO_ECB=m
-CONFIG_CRYPTO_PCBC=m
diff --git a/arch/powerpc/configs/83xx/mpc8313_rdb_defconfig b/arch/powerpc/configs/83xx/mpc8313_rdb_defconfig
index 16a42e2267fb..140dd429278e 100644
--- a/arch/powerpc/configs/83xx/mpc8313_rdb_defconfig
+++ b/arch/powerpc/configs/83xx/mpc8313_rdb_defconfig
@@ -81,6 +81,5 @@ CONFIG_TMPFS=y
 CONFIG_JFFS2_FS=y
 CONFIG_NFS_FS=y
 CONFIG_NFS_V4=y
 CONFIG_ROOT_NFS=y
 CONFIG_DETECT_HUNG_TASK=y
-CONFIG_CRYPTO_PCBC=m
diff --git a/arch/powerpc/configs/83xx/mpc8315_rdb_defconfig b/arch/powerpc/configs/83xx/mpc8315_rdb_defconfig
index 80d40ae668eb..7616771f072c 100644
--- a/arch/powerpc/configs/83xx/mpc8315_rdb_defconfig
+++ b/arch/powerpc/configs/83xx/mpc8315_rdb_defconfig
@@ -80,6 +80,5 @@ CONFIG_TMPFS=y
 CONFIG_JFFS2_FS=y
 CONFIG_NFS_FS=y
 CONFIG_NFS_V4=y
 CONFIG_ROOT_NFS=y
 CONFIG_DETECT_HUNG_TASK=y
-CONFIG_CRYPTO_PCBC=m
diff --git a/arch/powerpc/configs/83xx/mpc832x_rdb_defconfig b/arch/powerpc/configs/83xx/mpc832x_rdb_defconfig
index b99caba8724a..e670d16e6fd7 100644
--- a/arch/powerpc/configs/83xx/mpc832x_rdb_defconfig
+++ b/arch/powerpc/configs/83xx/mpc832x_rdb_defconfig
@@ -72,6 +72,5 @@ CONFIG_ROOT_NFS=y
 CONFIG_NLS_CODEPAGE_437=y
 CONFIG_NLS_CODEPAGE_932=y
 CONFIG_NLS_ISO8859_8=y
 CONFIG_NLS_ISO8859_1=y
 CONFIG_CRYPTO_ECB=m
-CONFIG_CRYPTO_PCBC=m
diff --git a/arch/powerpc/configs/83xx/mpc834x_itx_defconfig b/arch/powerpc/configs/83xx/mpc834x_itx_defconfig
index 11163052fdba..fcf91b52af2d 100644
--- a/arch/powerpc/configs/83xx/mpc834x_itx_defconfig
+++ b/arch/powerpc/configs/83xx/mpc834x_itx_defconfig
@@ -78,6 +78,5 @@ CONFIG_VFAT_FS=y
 CONFIG_PROC_KCORE=y
 CONFIG_TMPFS=y
 CONFIG_NFS_FS=y
 CONFIG_NFS_V4=y
 CONFIG_ROOT_NFS=y
-CONFIG_CRYPTO_PCBC=m
diff --git a/arch/powerpc/configs/83xx/mpc834x_itxgp_defconfig b/arch/powerpc/configs/83xx/mpc834x_itxgp_defconfig
index 312d39e4242c..7d060b6f49ca 100644
--- a/arch/powerpc/configs/83xx/mpc834x_itxgp_defconfig
+++ b/arch/powerpc/configs/83xx/mpc834x_itxgp_defconfig
@@ -70,6 +70,5 @@ CONFIG_VFAT_FS=y
 CONFIG_PROC_KCORE=y
 CONFIG_TMPFS=y
 CONFIG_NFS_FS=y
 CONFIG_NFS_V4=y
 CONFIG_ROOT_NFS=y
-CONFIG_CRYPTO_PCBC=m
diff --git a/arch/powerpc/configs/83xx/mpc837x_rdb_defconfig b/arch/powerpc/configs/83xx/mpc837x_rdb_defconfig
index ac27f99faab8..4567345aea9a 100644
--- a/arch/powerpc/configs/83xx/mpc837x_rdb_defconfig
+++ b/arch/powerpc/configs/83xx/mpc837x_rdb_defconfig
@@ -74,6 +74,5 @@ CONFIG_PROC_KCORE=y
 CONFIG_TMPFS=y
 CONFIG_NFS_FS=y
 CONFIG_NFS_V4=y
 CONFIG_ROOT_NFS=y
 CONFIG_CRYPTO_ECB=m
-CONFIG_CRYPTO_PCBC=m
diff --git a/arch/powerpc/configs/amigaone_defconfig b/arch/powerpc/configs/amigaone_defconfig
index 69ef3dc31c4b..45d693f70371 100644
--- a/arch/powerpc/configs/amigaone_defconfig
+++ b/arch/powerpc/configs/amigaone_defconfig
@@ -110,7 +110,6 @@ CONFIG_MAGIC_SYSRQ=y
 CONFIG_DEBUG_KERNEL=y
 CONFIG_DEBUG_MUTEXES=y
 CONFIG_XMON=y
 CONFIG_XMON_DEFAULT=y
 CONFIG_CRYPTO_CBC=m
-CONFIG_CRYPTO_PCBC=m
 # CONFIG_CRYPTO_HW is not set
diff --git a/arch/powerpc/configs/cell_defconfig b/arch/powerpc/configs/cell_defconfig
index 7a31b52e92e1..b5ed8945ec33 100644
--- a/arch/powerpc/configs/cell_defconfig
+++ b/arch/powerpc/configs/cell_defconfig
@@ -195,7 +195,6 @@ CONFIG_MAGIC_SYSRQ=y
 CONFIG_DEBUG_KERNEL=y
 CONFIG_DEBUG_MUTEXES=y
 CONFIG_XMON=y
 CONFIG_XMON_DEFAULT=y
 CONFIG_CRYPTO_ECB=m
-CONFIG_CRYPTO_PCBC=m
 CONFIG_CRYPTO_HMAC=y
diff --git a/arch/powerpc/configs/chrp32_defconfig b/arch/powerpc/configs/chrp32_defconfig
index b799c95480ae..71032b82f8a8 100644
--- a/arch/powerpc/configs/chrp32_defconfig
+++ b/arch/powerpc/configs/chrp32_defconfig
@@ -114,7 +114,6 @@ CONFIG_MAGIC_SYSRQ=y
 CONFIG_DEBUG_KERNEL=y
 CONFIG_DEBUG_MUTEXES=y
 CONFIG_XMON=y
 CONFIG_XMON_DEFAULT=y
 CONFIG_CRYPTO_CBC=m
-CONFIG_CRYPTO_PCBC=m
 # CONFIG_CRYPTO_HW is not set
diff --git a/arch/powerpc/configs/ep8248e_defconfig b/arch/powerpc/configs/ep8248e_defconfig
index 0d8d3f41f194..c3167726706d 100644
--- a/arch/powerpc/configs/ep8248e_defconfig
+++ b/arch/powerpc/configs/ep8248e_defconfig
@@ -62,9 +62,8 @@ CONFIG_DEBUG_INFO_DWARF_TOOLCHAIN_DEFAULT=y
 CONFIG_MAGIC_SYSRQ=y
 # CONFIG_SCHED_DEBUG is not set
 CONFIG_BDI_SWITCH=y
 CONFIG_CRYPTO_CBC=y
 CONFIG_CRYPTO_ECB=y
-CONFIG_CRYPTO_PCBC=y
 CONFIG_CRYPTO_MD5=y
 CONFIG_CRYPTO_DES=y
 # CONFIG_CRYPTO_HW is not set
diff --git a/arch/powerpc/configs/fsl-emb-nonhw.config b/arch/powerpc/configs/fsl-emb-nonhw.config
index 2f81bc2d819e..391c99117ee0 100644
--- a/arch/powerpc/configs/fsl-emb-nonhw.config
+++ b/arch/powerpc/configs/fsl-emb-nonhw.config
@@ -17,11 +17,10 @@ CONFIG_CGROUPS=y
 # CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS is not set
 CONFIG_CPUSETS=y
 CONFIG_CRAMFS=y
 CONFIG_CRYPTO_MD4=y
 CONFIG_CRYPTO_NULL=y
-CONFIG_CRYPTO_PCBC=m
 CONFIG_CRYPTO_SHA256=y
 CONFIG_CRYPTO_SHA512=y
 CONFIG_DEBUG_FS=y
 CONFIG_DEBUG_INFO_DWARF_TOOLCHAIN_DEFAULT=y
 CONFIG_DEBUG_KERNEL=y
diff --git a/arch/powerpc/configs/g5_defconfig b/arch/powerpc/configs/g5_defconfig
index 04bbb37f5978..50182b357973 100644
--- a/arch/powerpc/configs/g5_defconfig
+++ b/arch/powerpc/configs/g5_defconfig
@@ -232,11 +232,10 @@ CONFIG_NLS_UTF8=y
 CONFIG_MAGIC_SYSRQ=y
 CONFIG_DEBUG_KERNEL=y
 CONFIG_DEBUG_MUTEXES=y
 CONFIG_BOOTX_TEXT=y
 CONFIG_CRYPTO_BENCHMARK=m
-CONFIG_CRYPTO_PCBC=m
 CONFIG_CRYPTO_HMAC=y
 CONFIG_CRYPTO_SHA512=m
 CONFIG_CRYPTO_WP512=m
 CONFIG_CRYPTO_ANUBIS=m
 CONFIG_CRYPTO_BLOWFISH=m
diff --git a/arch/powerpc/configs/linkstation_defconfig b/arch/powerpc/configs/linkstation_defconfig
index 31f84d08b6ef..e1c1b00b0c81 100644
--- a/arch/powerpc/configs/linkstation_defconfig
+++ b/arch/powerpc/configs/linkstation_defconfig
@@ -126,11 +126,10 @@ CONFIG_NLS_CODEPAGE_932=m
 CONFIG_NLS_ISO8859_1=m
 CONFIG_NLS_UTF8=m
 CONFIG_MAGIC_SYSRQ=y
 CONFIG_DEBUG_KERNEL=y
 CONFIG_DETECT_HUNG_TASK=y
-CONFIG_CRYPTO_PCBC=m
 CONFIG_CRYPTO_SHA1=m
 CONFIG_CRYPTO_BLOWFISH=m
 CONFIG_CRYPTO_SERPENT=m
 CONFIG_CRYPTO_TWOFISH=m
 CONFIG_CRYPTO_DEFLATE=m
diff --git a/arch/powerpc/configs/mgcoge_defconfig b/arch/powerpc/configs/mgcoge_defconfig
index f65001e7877f..a31e1184f912 100644
--- a/arch/powerpc/configs/mgcoge_defconfig
+++ b/arch/powerpc/configs/mgcoge_defconfig
@@ -76,7 +76,6 @@ CONFIG_DEBUG_INFO_DWARF_TOOLCHAIN_DEFAULT=y
 CONFIG_DEBUG_FS=y
 CONFIG_MAGIC_SYSRQ=y
 # CONFIG_SCHED_DEBUG is not set
 CONFIG_BDI_SWITCH=y
 CONFIG_CRYPTO_ECB=y
-CONFIG_CRYPTO_PCBC=y
 # CONFIG_CRYPTO_HW is not set
diff --git a/arch/powerpc/configs/mpc83xx_defconfig b/arch/powerpc/configs/mpc83xx_defconfig
index a815d9e5e3e8..d603d8e93958 100644
--- a/arch/powerpc/configs/mpc83xx_defconfig
+++ b/arch/powerpc/configs/mpc83xx_defconfig
@@ -96,8 +96,7 @@ CONFIG_PROC_KCORE=y
 CONFIG_TMPFS=y
 CONFIG_NFS_FS=y
 CONFIG_NFS_V4=y
 CONFIG_ROOT_NFS=y
 CONFIG_CRYPTO_ECB=m
-CONFIG_CRYPTO_PCBC=m
 CONFIG_CRYPTO_SHA512=y
 CONFIG_CRYPTO_DEV_TALITOS=y
diff --git a/arch/powerpc/configs/mvme5100_defconfig b/arch/powerpc/configs/mvme5100_defconfig
index c82754c14e15..3918768d7cd2 100644
--- a/arch/powerpc/configs/mvme5100_defconfig
+++ b/arch/powerpc/configs/mvme5100_defconfig
@@ -111,11 +111,10 @@ CONFIG_XZ_DEC=y
 CONFIG_MAGIC_SYSRQ=y
 CONFIG_DEBUG_KERNEL=y
 CONFIG_DETECT_HUNG_TASK=y
 CONFIG_DEFAULT_HUNG_TASK_TIMEOUT=20
 CONFIG_CRYPTO_CBC=y
-CONFIG_CRYPTO_PCBC=m
 CONFIG_CRYPTO_MD5=y
 CONFIG_CRYPTO_SHA1=m
 CONFIG_CRYPTO_BLOWFISH=m
 CONFIG_CRYPTO_DES=y
 CONFIG_CRYPTO_SERPENT=m
diff --git a/arch/powerpc/configs/pmac32_defconfig b/arch/powerpc/configs/pmac32_defconfig
index ae45f70b29f0..728c8cabfb83 100644
--- a/arch/powerpc/configs/pmac32_defconfig
+++ b/arch/powerpc/configs/pmac32_defconfig
@@ -279,11 +279,10 @@ CONFIG_MAGIC_SYSRQ=y
 CONFIG_DEBUG_KERNEL=y
 CONFIG_DETECT_HUNG_TASK=y
 CONFIG_XMON=y
 CONFIG_XMON_DEFAULT=y
 CONFIG_BOOTX_TEXT=y
-CONFIG_CRYPTO_PCBC=m
 CONFIG_CRYPTO_MD4=m
 CONFIG_CRYPTO_SHA512=m
 CONFIG_CRYPTO_WP512=m
 CONFIG_CRYPTO_ANUBIS=m
 CONFIG_CRYPTO_BLOWFISH=m
diff --git a/arch/powerpc/configs/powernv_defconfig b/arch/powerpc/configs/powernv_defconfig
index cc9802420237..400ebb1d6da5 100644
--- a/arch/powerpc/configs/powernv_defconfig
+++ b/arch/powerpc/configs/powernv_defconfig
@@ -313,11 +313,10 @@ CONFIG_PPC_EMULATED_STATS=y
 CONFIG_CODE_PATCHING_SELFTEST=y
 CONFIG_FTR_FIXUP_SELFTEST=y
 CONFIG_MSI_BITMAP_SELFTEST=y
 CONFIG_XMON=y
 CONFIG_CRYPTO_BENCHMARK=m
-CONFIG_CRYPTO_PCBC=m
 CONFIG_CRYPTO_HMAC=y
 CONFIG_CRYPTO_SHA256=y
 CONFIG_CRYPTO_WP512=m
 CONFIG_CRYPTO_ANUBIS=m
 CONFIG_CRYPTO_BLOWFISH=m
diff --git a/arch/powerpc/configs/ppc44x_defconfig b/arch/powerpc/configs/ppc44x_defconfig
index 41c930f74ed4..0dc537f6aff3 100644
--- a/arch/powerpc/configs/ppc44x_defconfig
+++ b/arch/powerpc/configs/ppc44x_defconfig
@@ -91,8 +91,7 @@ CONFIG_ROOT_NFS=y
 CONFIG_NLS_CODEPAGE_437=m
 CONFIG_NLS_ISO8859_1=m
 CONFIG_MAGIC_SYSRQ=y
 CONFIG_DETECT_HUNG_TASK=y
 CONFIG_CRYPTO_ECB=y
-CONFIG_CRYPTO_PCBC=y
 # CONFIG_CRYPTO_HW is not set
 CONFIG_VIRTUALIZATION=y
diff --git a/arch/powerpc/configs/ppc64_defconfig b/arch/powerpc/configs/ppc64_defconfig
index 3bf518e3a573..56acedf390e7 100644
--- a/arch/powerpc/configs/ppc64_defconfig
+++ b/arch/powerpc/configs/ppc64_defconfig
@@ -377,11 +377,10 @@ CONFIG_IMA_APPRAISE_MODSIG=y
 CONFIG_CRYPTO_BENCHMARK=m
 CONFIG_CRYPTO_BLOWFISH=m
 CONFIG_CRYPTO_CAST6=m
 CONFIG_CRYPTO_SERPENT=m
 CONFIG_CRYPTO_TWOFISH=m
-CONFIG_CRYPTO_PCBC=m
 CONFIG_CRYPTO_SHA256=y
 CONFIG_CRYPTO_WP512=m
 CONFIG_CRYPTO_LZO=m
 CONFIG_CRYPTO_AES_GCM_P10=m
 CONFIG_CRYPTO_DEV_NX=y
diff --git a/arch/powerpc/configs/ppc64e_defconfig b/arch/powerpc/configs/ppc64e_defconfig
index 0fd49f67331f..efd9b76c90bd 100644
--- a/arch/powerpc/configs/ppc64e_defconfig
+++ b/arch/powerpc/configs/ppc64e_defconfig
@@ -219,11 +219,10 @@ CONFIG_FTR_FIXUP_SELFTEST=y
 CONFIG_MSI_BITMAP_SELFTEST=y
 CONFIG_XMON=y
 CONFIG_CRYPTO_BENCHMARK=m
 CONFIG_CRYPTO_CCM=m
 CONFIG_CRYPTO_GCM=m
-CONFIG_CRYPTO_PCBC=m
 CONFIG_CRYPTO_HMAC=y
 CONFIG_CRYPTO_SHA512=m
 CONFIG_CRYPTO_WP512=m
 CONFIG_CRYPTO_ANUBIS=m
 CONFIG_CRYPTO_BLOWFISH=m
diff --git a/arch/powerpc/configs/ppc6xx_defconfig b/arch/powerpc/configs/ppc6xx_defconfig
index 7258ad903774..65f310bf7bc5 100644
--- a/arch/powerpc/configs/ppc6xx_defconfig
+++ b/arch/powerpc/configs/ppc6xx_defconfig
@@ -1049,11 +1049,10 @@ CONFIG_SECURITY_SELINUX=y
 CONFIG_SECURITY_SELINUX_BOOTPARAM=y
 CONFIG_SECURITY_SELINUX_DISABLE=y
 CONFIG_CRYPTO_BENCHMARK=m
 CONFIG_CRYPTO_CTS=m
 CONFIG_CRYPTO_LRW=m
-CONFIG_CRYPTO_PCBC=m
 CONFIG_CRYPTO_XTS=m
 CONFIG_CRYPTO_HMAC=y
 CONFIG_CRYPTO_XCBC=m
 CONFIG_CRYPTO_RMD160=m
 CONFIG_CRYPTO_SHA1=y
diff --git a/arch/powerpc/configs/ps3_defconfig b/arch/powerpc/configs/ps3_defconfig
index 7cfae0b7b2f3..22cfe85b7db7 100644
--- a/arch/powerpc/configs/ps3_defconfig
+++ b/arch/powerpc/configs/ps3_defconfig
@@ -143,11 +143,10 @@ CONFIG_NFS_SWAP=y
 CONFIG_ROOT_NFS=y
 CONFIG_CIFS=m
 CONFIG_NLS=y
 CONFIG_NLS_CODEPAGE_437=y
 CONFIG_NLS_ISO8859_1=y
-CONFIG_CRYPTO_PCBC=m
 CONFIG_CRYPTO_LZO=m
 CONFIG_PRINTK_TIME=y
 CONFIG_DEBUG_INFO_DWARF_TOOLCHAIN_DEFAULT=y
 CONFIG_MAGIC_SYSRQ=y
 CONFIG_DEBUG_MEMORY_INIT=y
diff --git a/arch/s390/configs/debug_defconfig b/arch/s390/configs/debug_defconfig
index b69f626b7cce..12511bdb9579 100644
--- a/arch/s390/configs/debug_defconfig
+++ b/arch/s390/configs/debug_defconfig
@@ -784,11 +784,10 @@ CONFIG_CRYPTO_TEA=m
 CONFIG_CRYPTO_TWOFISH=m
 CONFIG_CRYPTO_ADIANTUM=m
 CONFIG_CRYPTO_ARC4=m
 CONFIG_CRYPTO_HCTR2=m
 CONFIG_CRYPTO_LRW=m
-CONFIG_CRYPTO_PCBC=m
 CONFIG_CRYPTO_AEGIS128=m
 CONFIG_CRYPTO_GCM=y
 CONFIG_CRYPTO_SEQIV=y
 CONFIG_CRYPTO_MD4=m
 CONFIG_CRYPTO_MD5=y
diff --git a/arch/s390/configs/defconfig b/arch/s390/configs/defconfig
index 9ea820882fdf..9d44dd968ecc 100644
--- a/arch/s390/configs/defconfig
+++ b/arch/s390/configs/defconfig
@@ -768,11 +768,10 @@ CONFIG_CRYPTO_TEA=m
 CONFIG_CRYPTO_TWOFISH=m
 CONFIG_CRYPTO_ADIANTUM=m
 CONFIG_CRYPTO_ARC4=m
 CONFIG_CRYPTO_HCTR2=m
 CONFIG_CRYPTO_LRW=m
-CONFIG_CRYPTO_PCBC=m
 CONFIG_CRYPTO_AEGIS128=m
 CONFIG_CRYPTO_GCM=y
 CONFIG_CRYPTO_SEQIV=y
 CONFIG_CRYPTO_MD4=m
 CONFIG_CRYPTO_MD5=y
diff --git a/arch/sh/configs/hp6xx_defconfig b/arch/sh/configs/hp6xx_defconfig
index b6116a203a27..bdc476dcfa43 100644
--- a/arch/sh/configs/hp6xx_defconfig
+++ b/arch/sh/configs/hp6xx_defconfig
@@ -49,8 +49,7 @@ CONFIG_VFAT_FS=y
 CONFIG_PROC_KCORE=y
 CONFIG_NLS_CODEPAGE_850=y
 CONFIG_CRYPTO=y
 CONFIG_CRYPTO_CBC=y
 CONFIG_CRYPTO_ECB=y
-CONFIG_CRYPTO_PCBC=y
 CONFIG_CRYPTO_MD5=y
 # CONFIG_CRYPTO_HW is not set
diff --git a/arch/sh/configs/r7780mp_defconfig b/arch/sh/configs/r7780mp_defconfig
index af954f75444b..7b46f62fe7db 100644
--- a/arch/sh/configs/r7780mp_defconfig
+++ b/arch/sh/configs/r7780mp_defconfig
@@ -99,7 +99,6 @@ CONFIG_DEBUG_FS=y
 CONFIG_DEBUG_KERNEL=y
 CONFIG_DETECT_HUNG_TASK=y
 # CONFIG_DEBUG_PREEMPT is not set
 CONFIG_DEBUG_INFO_DWARF_TOOLCHAIN_DEFAULT=y
 CONFIG_CRYPTO_ECB=m
-CONFIG_CRYPTO_PCBC=m
 CONFIG_CRYPTO_HMAC=y
diff --git a/arch/sh/configs/r7785rp_defconfig b/arch/sh/configs/r7785rp_defconfig
index a66dd6d74cf1..6d2461a85f19 100644
--- a/arch/sh/configs/r7785rp_defconfig
+++ b/arch/sh/configs/r7785rp_defconfig
@@ -97,7 +97,6 @@ CONFIG_DEBUG_LOCKING_API_SELFTESTS=y
 CONFIG_DEBUG_INFO_DWARF_TOOLCHAIN_DEFAULT=y
 CONFIG_SH_STANDARD_BIOS=y
 CONFIG_DEBUG_STACK_USAGE=y
 CONFIG_4KSTACKS=y
 CONFIG_CRYPTO_ECB=m
-CONFIG_CRYPTO_PCBC=m
 CONFIG_CRYPTO_HMAC=y
diff --git a/arch/sh/configs/se7712_defconfig b/arch/sh/configs/se7712_defconfig
index dee1d88f6a7d..8d8a311c60b1 100644
--- a/arch/sh/configs/se7712_defconfig
+++ b/arch/sh/configs/se7712_defconfig
@@ -91,6 +91,5 @@ CONFIG_NFS_FS=y
 CONFIG_ROOT_NFS=y
 CONFIG_DEBUG_KERNEL=y
 CONFIG_DEBUG_INFO_DWARF_TOOLCHAIN_DEFAULT=y
 CONFIG_FRAME_POINTER=y
 CONFIG_CRYPTO_ECB=m
-CONFIG_CRYPTO_PCBC=m
diff --git a/arch/sh/configs/sh2007_defconfig b/arch/sh/configs/sh2007_defconfig
index 4a67f9c85806..3060bcd9cc5f 100644
--- a/arch/sh/configs/sh2007_defconfig
+++ b/arch/sh/configs/sh2007_defconfig
@@ -163,11 +163,10 @@ CONFIG_FRAME_POINTER=y
 CONFIG_SH_STANDARD_BIOS=y
 CONFIG_CRYPTO_NULL=y
 CONFIG_CRYPTO_AUTHENC=y
 CONFIG_CRYPTO_ECB=y
 CONFIG_CRYPTO_LRW=y
-CONFIG_CRYPTO_PCBC=y
 CONFIG_CRYPTO_XTS=y
 CONFIG_CRYPTO_HMAC=y
 CONFIG_CRYPTO_XCBC=y
 CONFIG_CRYPTO_MD4=y
 CONFIG_CRYPTO_SHA1=y
diff --git a/arch/sparc/configs/sparc32_defconfig b/arch/sparc/configs/sparc32_defconfig
index 48d834acafb4..d5579217fb4c 100644
--- a/arch/sparc/configs/sparc32_defconfig
+++ b/arch/sparc/configs/sparc32_defconfig
@@ -78,11 +78,10 @@ CONFIG_DETECT_HUNG_TASK=y
 # CONFIG_SCHED_DEBUG is not set
 CONFIG_KGDB=y
 CONFIG_KGDB_TESTS=y
 CONFIG_CRYPTO_NULL=m
 CONFIG_CRYPTO_ECB=m
-CONFIG_CRYPTO_PCBC=m
 CONFIG_CRYPTO_MD4=y
 CONFIG_CRYPTO_SHA256=m
 CONFIG_CRYPTO_SHA512=m
 CONFIG_CRYPTO_AES=m
 CONFIG_CRYPTO_ARC4=m
diff --git a/arch/sparc/configs/sparc64_defconfig b/arch/sparc/configs/sparc64_defconfig
index c6009ebc806d..3763108c3bd4 100644
--- a/arch/sparc/configs/sparc64_defconfig
+++ b/arch/sparc/configs/sparc64_defconfig
@@ -204,11 +204,10 @@ CONFIG_BLK_DEV_IO_TRACE=y
 CONFIG_UPROBE_EVENTS=y
 CONFIG_KEYS=y
 CONFIG_CRYPTO_NULL=m
 CONFIG_CRYPTO_BENCHMARK=m
 CONFIG_CRYPTO_LRW=m
-CONFIG_CRYPTO_PCBC=m
 CONFIG_CRYPTO_XTS=m
 CONFIG_CRYPTO_XCBC=y
 CONFIG_CRYPTO_MD4=y
 CONFIG_CRYPTO_SHA256=m
 CONFIG_CRYPTO_SHA512=m
diff --git a/crypto/Kconfig b/crypto/Kconfig
index 0727cd5877da..f8d5801a4d5e 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -701,19 +701,10 @@ config CRYPTO_LRW
 	  The first 128, 192 or 256 bits in the key are used for AES and the
 	  rest is used to tie each cipher block to its logical position.
 
 	  See https://people.csail.mit.edu/rivest/pubs/LRW02.pdf
 
-config CRYPTO_PCBC
-	tristate "PCBC (Propagating Cipher Block Chaining)"
-	select CRYPTO_SKCIPHER
-	select CRYPTO_MANAGER
-	help
-	  PCBC (Propagating Cipher Block Chaining) mode
-
-	  This block cipher mode is required for RxRPC.
-
 config CRYPTO_XCTR
 	tristate
 	select CRYPTO_SKCIPHER
 	select CRYPTO_MANAGER
 	help
diff --git a/crypto/Makefile b/crypto/Makefile
index 1827f84192e6..9081ed10ce61 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -87,11 +87,10 @@ obj-$(CONFIG_CRYPTO_STREEBOG) += streebog_generic.o
 obj-$(CONFIG_CRYPTO_WP512) += wp512.o
 CFLAGS_wp512.o := $(call cc-option,-fno-schedule-insns)  # https://gcc.gnu.org/bugzilla/show_bug.cgi?id=79149
 obj-$(CONFIG_CRYPTO_BLAKE2B) += blake2b.o
 obj-$(CONFIG_CRYPTO_ECB) += ecb.o
 obj-$(CONFIG_CRYPTO_CBC) += cbc.o
-obj-$(CONFIG_CRYPTO_PCBC) += pcbc.o
 obj-$(CONFIG_CRYPTO_CTS) += cts.o
 obj-$(CONFIG_CRYPTO_LRW) += lrw.o
 obj-$(CONFIG_CRYPTO_XTS) += xts.o
 obj-$(CONFIG_CRYPTO_CTR) += ctr.o
 obj-$(CONFIG_CRYPTO_XCTR) += xctr.o
diff --git a/crypto/pcbc.c b/crypto/pcbc.c
deleted file mode 100644
index d092717ea4fc..000000000000
--- a/crypto/pcbc.c
+++ /dev/null
@@ -1,195 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0-or-later
-/*
- * PCBC: Propagating Cipher Block Chaining mode
- *
- * Copyright (C) 2006 Red Hat, Inc. All Rights Reserved.
- * Written by David Howells (dhowells@redhat.com)
- *
- * Derived from cbc.c
- * - Copyright (c) 2006 Herbert Xu <herbert@gondor.apana.org.au>
- */
-
-#include <crypto/algapi.h>
-#include <crypto/internal/cipher.h>
-#include <crypto/internal/skcipher.h>
-#include <linux/err.h>
-#include <linux/init.h>
-#include <linux/kernel.h>
-#include <linux/module.h>
-
-static int crypto_pcbc_encrypt_segment(struct skcipher_request *req,
-				       struct skcipher_walk *walk,
-				       struct crypto_cipher *tfm)
-{
-	int bsize = crypto_cipher_blocksize(tfm);
-	const u8 *src = walk->src.virt.addr;
-	unsigned int nbytes = walk->nbytes;
-	u8 *dst = walk->dst.virt.addr;
-	u8 * const iv = walk->iv;
-
-	do {
-		crypto_xor(iv, src, bsize);
-		crypto_cipher_encrypt_one(tfm, dst, iv);
-		crypto_xor_cpy(iv, dst, src, bsize);
-
-		src += bsize;
-		dst += bsize;
-	} while ((nbytes -= bsize) >= bsize);
-
-	return nbytes;
-}
-
-static int crypto_pcbc_encrypt_inplace(struct skcipher_request *req,
-				       struct skcipher_walk *walk,
-				       struct crypto_cipher *tfm)
-{
-	int bsize = crypto_cipher_blocksize(tfm);
-	unsigned int nbytes = walk->nbytes;
-	u8 *dst = walk->dst.virt.addr;
-	u8 * const iv = walk->iv;
-	u8 tmpbuf[MAX_CIPHER_BLOCKSIZE];
-
-	do {
-		memcpy(tmpbuf, dst, bsize);
-		crypto_xor(iv, dst, bsize);
-		crypto_cipher_encrypt_one(tfm, dst, iv);
-		crypto_xor_cpy(iv, tmpbuf, dst, bsize);
-
-		dst += bsize;
-	} while ((nbytes -= bsize) >= bsize);
-
-	return nbytes;
-}
-
-static int crypto_pcbc_encrypt(struct skcipher_request *req)
-{
-	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
-	struct crypto_cipher *cipher = skcipher_cipher_simple(tfm);
-	struct skcipher_walk walk;
-	unsigned int nbytes;
-	int err;
-
-	err = skcipher_walk_virt(&walk, req, false);
-
-	while (walk.nbytes) {
-		if (walk.src.virt.addr == walk.dst.virt.addr)
-			nbytes = crypto_pcbc_encrypt_inplace(req, &walk,
-							     cipher);
-		else
-			nbytes = crypto_pcbc_encrypt_segment(req, &walk,
-							     cipher);
-		err = skcipher_walk_done(&walk, nbytes);
-	}
-
-	return err;
-}
-
-static int crypto_pcbc_decrypt_segment(struct skcipher_request *req,
-				       struct skcipher_walk *walk,
-				       struct crypto_cipher *tfm)
-{
-	int bsize = crypto_cipher_blocksize(tfm);
-	const u8 *src = walk->src.virt.addr;
-	unsigned int nbytes = walk->nbytes;
-	u8 *dst = walk->dst.virt.addr;
-	u8 * const iv = walk->iv;
-
-	do {
-		crypto_cipher_decrypt_one(tfm, dst, src);
-		crypto_xor(dst, iv, bsize);
-		crypto_xor_cpy(iv, dst, src, bsize);
-
-		src += bsize;
-		dst += bsize;
-	} while ((nbytes -= bsize) >= bsize);
-
-	return nbytes;
-}
-
-static int crypto_pcbc_decrypt_inplace(struct skcipher_request *req,
-				       struct skcipher_walk *walk,
-				       struct crypto_cipher *tfm)
-{
-	int bsize = crypto_cipher_blocksize(tfm);
-	unsigned int nbytes = walk->nbytes;
-	u8 *dst = walk->dst.virt.addr;
-	u8 * const iv = walk->iv;
-	u8 tmpbuf[MAX_CIPHER_BLOCKSIZE] __aligned(__alignof__(u32));
-
-	do {
-		memcpy(tmpbuf, dst, bsize);
-		crypto_cipher_decrypt_one(tfm, dst, dst);
-		crypto_xor(dst, iv, bsize);
-		crypto_xor_cpy(iv, dst, tmpbuf, bsize);
-
-		dst += bsize;
-	} while ((nbytes -= bsize) >= bsize);
-
-	return nbytes;
-}
-
-static int crypto_pcbc_decrypt(struct skcipher_request *req)
-{
-	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
-	struct crypto_cipher *cipher = skcipher_cipher_simple(tfm);
-	struct skcipher_walk walk;
-	unsigned int nbytes;
-	int err;
-
-	err = skcipher_walk_virt(&walk, req, false);
-
-	while (walk.nbytes) {
-		if (walk.src.virt.addr == walk.dst.virt.addr)
-			nbytes = crypto_pcbc_decrypt_inplace(req, &walk,
-							     cipher);
-		else
-			nbytes = crypto_pcbc_decrypt_segment(req, &walk,
-							     cipher);
-		err = skcipher_walk_done(&walk, nbytes);
-	}
-
-	return err;
-}
-
-static int crypto_pcbc_create(struct crypto_template *tmpl, struct rtattr **tb)
-{
-	struct skcipher_instance *inst;
-	int err;
-
-	inst = skcipher_alloc_instance_simple(tmpl, tb);
-	if (IS_ERR(inst))
-		return PTR_ERR(inst);
-
-	inst->alg.encrypt = crypto_pcbc_encrypt;
-	inst->alg.decrypt = crypto_pcbc_decrypt;
-
-	err = skcipher_register_instance(tmpl, inst);
-	if (err)
-		inst->free(inst);
-
-	return err;
-}
-
-static struct crypto_template crypto_pcbc_tmpl = {
-	.name = "pcbc",
-	.create = crypto_pcbc_create,
-	.module = THIS_MODULE,
-};
-
-static int __init crypto_pcbc_module_init(void)
-{
-	return crypto_register_template(&crypto_pcbc_tmpl);
-}
-
-static void __exit crypto_pcbc_module_exit(void)
-{
-	crypto_unregister_template(&crypto_pcbc_tmpl);
-}
-
-module_init(crypto_pcbc_module_init);
-module_exit(crypto_pcbc_module_exit);
-
-MODULE_LICENSE("GPL");
-MODULE_DESCRIPTION("PCBC block cipher mode of operation");
-MODULE_ALIAS_CRYPTO("pcbc");
-MODULE_IMPORT_NS("CRYPTO_INTERNAL");
-- 
2.54.0

