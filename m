Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DB3233FE10;
	Sat, 21 Mar 2026 04:11:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774066319; cv=none; b=hQCmr5y3yky9WPgOFW/23Rv0BHJdiqVfmh0J1sgPz1pjhs4SuINMhwe1kIafibA6foHmNTYKudAoFP4e6MkTJsb1YVNvsjCO1+9vGOsgAUIbQlo4+4YCbCQa25pG29/zmQonFToFTVE0TRl7JLRhp6hWqxnw/k4esA2PTI2x0bE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774066319; c=relaxed/simple;
	bh=ipRy61QkII6mmLQ3AcgziVnasyTR9cLbB+H7Xuzzsf8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q7G9ta3b7Jg2vHHiIL4BbPGgU5Jox8F7xYXK0trG2UROzo+n+sWOny+IRLpus3gxjQCUt2YqEPt5HKlw5us6m6JaNFhUY60qcnVRgmd0NwBZ0PgkMa58K+9TVU6zo4NyBI+AE7gX4nncPwEKErlYsiqq6okdL3Hs+Ti66C8iZOI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lFF2gtLr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lFF2gtLr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E73E3C2BCAF;
	Sat, 21 Mar 2026 04:11:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774066319;
	bh=ipRy61QkII6mmLQ3AcgziVnasyTR9cLbB+H7Xuzzsf8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lFF2gtLrU7QkE2C3FHSOeTD3PlaAtNGWnNQ1fD9IhBbB/w20IyVZG4xBXpl33PqoQ
	 v+AWxz8a+etWbDzWLYaXfbI9g1J7s0SxPnNWn1SQo0UsDSM2udCwuLdEmlSBpA1z8y
	 fbRjQdzqGIvKEchylCaIF29ZMKSV+CyXL0om3T3tcu9+uz22l4RlsgFH6jzQ1SX3sl
	 iVZh3l5886ENZuvCnsFuK5rzwmFAT0UIC4ubFss4JEDwcSUcAL+0MPBHV3GMWXN55f
	 SwJnq8aQlAkHYm2+KW9HbBjSuDFtWScL/qWtqMnNoPAmzVhfISJLguN4Rkfljfx7NK
	 7GsF60j/6OknA==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Tianjia Zhang <tianjia.zhang@linux.alibaba.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-riscv@lists.infradead.org,
	x86@kernel.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 03/12] crypto: sm3 - Rename CRYPTO_SM3_GENERIC to CRYPTO_SM3
Date: Fri, 20 Mar 2026 21:09:26 -0700
Message-ID: <20260321040935.410034-4-ebiggers@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260321040935.410034-1-ebiggers@kernel.org>
References: <20260321040935.410034-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The kconfig options for generic crypto API modules have traditionally
*not* had a "_GENERIC" suffix.  Also, the "_GENERIC" suffix will make
even less sense once the architecture-optimized SM3 code is moved into
lib/crypto/ and the "sm3" crypto_shash is reimplemented on top of that.

Thus, rename CRYPTO_SM3_GENERIC to CRYPTO_SM3.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 arch/loongarch/configs/loongson32_defconfig | 2 +-
 arch/loongarch/configs/loongson64_defconfig | 2 +-
 arch/m68k/configs/amiga_defconfig           | 2 +-
 arch/m68k/configs/apollo_defconfig          | 2 +-
 arch/m68k/configs/atari_defconfig           | 2 +-
 arch/m68k/configs/bvme6000_defconfig        | 2 +-
 arch/m68k/configs/hp300_defconfig           | 2 +-
 arch/m68k/configs/mac_defconfig             | 2 +-
 arch/m68k/configs/multi_defconfig           | 2 +-
 arch/m68k/configs/mvme147_defconfig         | 2 +-
 arch/m68k/configs/mvme16x_defconfig         | 2 +-
 arch/m68k/configs/q40_defconfig             | 2 +-
 arch/m68k/configs/sun3_defconfig            | 2 +-
 arch/m68k/configs/sun3x_defconfig           | 2 +-
 arch/s390/configs/debug_defconfig           | 2 +-
 arch/s390/configs/defconfig                 | 2 +-
 crypto/Kconfig                              | 2 +-
 crypto/Makefile                             | 2 +-
 drivers/crypto/Kconfig                      | 2 +-
 drivers/crypto/starfive/Kconfig             | 2 +-
 security/integrity/ima/Kconfig              | 2 +-
 21 files changed, 21 insertions(+), 21 deletions(-)

diff --git a/arch/loongarch/configs/loongson32_defconfig b/arch/loongarch/configs/loongson32_defconfig
index 276b1577e0be..7abbb21f4f8f 100644
--- a/arch/loongarch/configs/loongson32_defconfig
+++ b/arch/loongarch/configs/loongson32_defconfig
@@ -1078,11 +1078,11 @@ CONFIG_CRYPTO_SEED=m
 CONFIG_CRYPTO_SERPENT=m
 CONFIG_CRYPTO_SM4_GENERIC=m
 CONFIG_CRYPTO_TEA=m
 CONFIG_CRYPTO_TWOFISH=m
 CONFIG_CRYPTO_CHACHA20POLY1305=m
-CONFIG_CRYPTO_SM3_GENERIC=m
+CONFIG_CRYPTO_SM3=m
 CONFIG_CRYPTO_WP512=m
 CONFIG_CRYPTO_DEFLATE=m
 CONFIG_CRYPTO_LZO=m
 CONFIG_CRYPTO_842=m
 CONFIG_CRYPTO_LZ4=m
diff --git a/arch/loongarch/configs/loongson64_defconfig b/arch/loongarch/configs/loongson64_defconfig
index a14db1a95e7e..51ccd18ecdae 100644
--- a/arch/loongarch/configs/loongson64_defconfig
+++ b/arch/loongarch/configs/loongson64_defconfig
@@ -1111,11 +1111,11 @@ CONFIG_CRYPTO_SEED=m
 CONFIG_CRYPTO_SERPENT=m
 CONFIG_CRYPTO_SM4_GENERIC=m
 CONFIG_CRYPTO_TEA=m
 CONFIG_CRYPTO_TWOFISH=m
 CONFIG_CRYPTO_CHACHA20POLY1305=m
-CONFIG_CRYPTO_SM3_GENERIC=m
+CONFIG_CRYPTO_SM3=m
 CONFIG_CRYPTO_WP512=m
 CONFIG_CRYPTO_DEFLATE=m
 CONFIG_CRYPTO_LZO=m
 CONFIG_CRYPTO_842=m
 CONFIG_CRYPTO_LZ4=m
diff --git a/arch/m68k/configs/amiga_defconfig b/arch/m68k/configs/amiga_defconfig
index 31d16cba9879..03a8c192a7a3 100644
--- a/arch/m68k/configs/amiga_defconfig
+++ b/arch/m68k/configs/amiga_defconfig
@@ -579,11 +579,11 @@ CONFIG_CRYPTO_XTS=m
 CONFIG_CRYPTO_AEGIS128=m
 CONFIG_CRYPTO_MD4=m
 CONFIG_CRYPTO_MICHAEL_MIC=m
 CONFIG_CRYPTO_RMD160=m
 CONFIG_CRYPTO_SHA1=m
-CONFIG_CRYPTO_SM3_GENERIC=m
+CONFIG_CRYPTO_SM3=m
 CONFIG_CRYPTO_WP512=m
 CONFIG_CRYPTO_XCBC=m
 CONFIG_CRYPTO_LZO=m
 CONFIG_CRYPTO_842=m
 CONFIG_CRYPTO_LZ4=m
diff --git a/arch/m68k/configs/apollo_defconfig b/arch/m68k/configs/apollo_defconfig
index c0c419ec9a9e..0aee1939ac7a 100644
--- a/arch/m68k/configs/apollo_defconfig
+++ b/arch/m68k/configs/apollo_defconfig
@@ -536,11 +536,11 @@ CONFIG_CRYPTO_XTS=m
 CONFIG_CRYPTO_AEGIS128=m
 CONFIG_CRYPTO_MD4=m
 CONFIG_CRYPTO_MICHAEL_MIC=m
 CONFIG_CRYPTO_RMD160=m
 CONFIG_CRYPTO_SHA1=m
-CONFIG_CRYPTO_SM3_GENERIC=m
+CONFIG_CRYPTO_SM3=m
 CONFIG_CRYPTO_WP512=m
 CONFIG_CRYPTO_XCBC=m
 CONFIG_CRYPTO_LZO=m
 CONFIG_CRYPTO_842=m
 CONFIG_CRYPTO_LZ4=m
diff --git a/arch/m68k/configs/atari_defconfig b/arch/m68k/configs/atari_defconfig
index 2b7547ecc4c4..756256770afc 100644
--- a/arch/m68k/configs/atari_defconfig
+++ b/arch/m68k/configs/atari_defconfig
@@ -556,11 +556,11 @@ CONFIG_CRYPTO_XTS=m
 CONFIG_CRYPTO_AEGIS128=m
 CONFIG_CRYPTO_MD4=m
 CONFIG_CRYPTO_MICHAEL_MIC=m
 CONFIG_CRYPTO_RMD160=m
 CONFIG_CRYPTO_SHA1=m
-CONFIG_CRYPTO_SM3_GENERIC=m
+CONFIG_CRYPTO_SM3=m
 CONFIG_CRYPTO_WP512=m
 CONFIG_CRYPTO_XCBC=m
 CONFIG_CRYPTO_LZO=m
 CONFIG_CRYPTO_842=m
 CONFIG_CRYPTO_LZ4=m
diff --git a/arch/m68k/configs/bvme6000_defconfig b/arch/m68k/configs/bvme6000_defconfig
index 0b63787cff0d..8cfb75bb0add 100644
--- a/arch/m68k/configs/bvme6000_defconfig
+++ b/arch/m68k/configs/bvme6000_defconfig
@@ -528,11 +528,11 @@ CONFIG_CRYPTO_XTS=m
 CONFIG_CRYPTO_AEGIS128=m
 CONFIG_CRYPTO_MD4=m
 CONFIG_CRYPTO_MICHAEL_MIC=m
 CONFIG_CRYPTO_RMD160=m
 CONFIG_CRYPTO_SHA1=m
-CONFIG_CRYPTO_SM3_GENERIC=m
+CONFIG_CRYPTO_SM3=m
 CONFIG_CRYPTO_WP512=m
 CONFIG_CRYPTO_XCBC=m
 CONFIG_CRYPTO_LZO=m
 CONFIG_CRYPTO_842=m
 CONFIG_CRYPTO_LZ4=m
diff --git a/arch/m68k/configs/hp300_defconfig b/arch/m68k/configs/hp300_defconfig
index 308836b60bba..b2f5c9749e9b 100644
--- a/arch/m68k/configs/hp300_defconfig
+++ b/arch/m68k/configs/hp300_defconfig
@@ -538,11 +538,11 @@ CONFIG_CRYPTO_XTS=m
 CONFIG_CRYPTO_AEGIS128=m
 CONFIG_CRYPTO_MD4=m
 CONFIG_CRYPTO_MICHAEL_MIC=m
 CONFIG_CRYPTO_RMD160=m
 CONFIG_CRYPTO_SHA1=m
-CONFIG_CRYPTO_SM3_GENERIC=m
+CONFIG_CRYPTO_SM3=m
 CONFIG_CRYPTO_WP512=m
 CONFIG_CRYPTO_XCBC=m
 CONFIG_CRYPTO_LZO=m
 CONFIG_CRYPTO_842=m
 CONFIG_CRYPTO_LZ4=m
diff --git a/arch/m68k/configs/mac_defconfig b/arch/m68k/configs/mac_defconfig
index 97e108c0d24f..c4fddaaa6a86 100644
--- a/arch/m68k/configs/mac_defconfig
+++ b/arch/m68k/configs/mac_defconfig
@@ -555,11 +555,11 @@ CONFIG_CRYPTO_XTS=m
 CONFIG_CRYPTO_AEGIS128=m
 CONFIG_CRYPTO_MD4=m
 CONFIG_CRYPTO_MICHAEL_MIC=m
 CONFIG_CRYPTO_RMD160=m
 CONFIG_CRYPTO_SHA1=m
-CONFIG_CRYPTO_SM3_GENERIC=m
+CONFIG_CRYPTO_SM3=m
 CONFIG_CRYPTO_WP512=m
 CONFIG_CRYPTO_XCBC=m
 CONFIG_CRYPTO_LZO=m
 CONFIG_CRYPTO_842=m
 CONFIG_CRYPTO_LZ4=m
diff --git a/arch/m68k/configs/multi_defconfig b/arch/m68k/configs/multi_defconfig
index 7e9f83af9af4..926f12bc3d1d 100644
--- a/arch/m68k/configs/multi_defconfig
+++ b/arch/m68k/configs/multi_defconfig
@@ -642,11 +642,11 @@ CONFIG_CRYPTO_XTS=m
 CONFIG_CRYPTO_AEGIS128=m
 CONFIG_CRYPTO_MD4=m
 CONFIG_CRYPTO_MICHAEL_MIC=m
 CONFIG_CRYPTO_RMD160=m
 CONFIG_CRYPTO_SHA1=m
-CONFIG_CRYPTO_SM3_GENERIC=m
+CONFIG_CRYPTO_SM3=m
 CONFIG_CRYPTO_WP512=m
 CONFIG_CRYPTO_XCBC=m
 CONFIG_CRYPTO_LZO=m
 CONFIG_CRYPTO_842=m
 CONFIG_CRYPTO_LZ4=m
diff --git a/arch/m68k/configs/mvme147_defconfig b/arch/m68k/configs/mvme147_defconfig
index 2fe33271d249..e507012dbbc1 100644
--- a/arch/m68k/configs/mvme147_defconfig
+++ b/arch/m68k/configs/mvme147_defconfig
@@ -528,11 +528,11 @@ CONFIG_CRYPTO_XTS=m
 CONFIG_CRYPTO_AEGIS128=m
 CONFIG_CRYPTO_MD4=m
 CONFIG_CRYPTO_MICHAEL_MIC=m
 CONFIG_CRYPTO_RMD160=m
 CONFIG_CRYPTO_SHA1=m
-CONFIG_CRYPTO_SM3_GENERIC=m
+CONFIG_CRYPTO_SM3=m
 CONFIG_CRYPTO_WP512=m
 CONFIG_CRYPTO_XCBC=m
 CONFIG_CRYPTO_LZO=m
 CONFIG_CRYPTO_842=m
 CONFIG_CRYPTO_LZ4=m
diff --git a/arch/m68k/configs/mvme16x_defconfig b/arch/m68k/configs/mvme16x_defconfig
index 4308daaa7f74..6195cedd914b 100644
--- a/arch/m68k/configs/mvme16x_defconfig
+++ b/arch/m68k/configs/mvme16x_defconfig
@@ -529,11 +529,11 @@ CONFIG_CRYPTO_XTS=m
 CONFIG_CRYPTO_AEGIS128=m
 CONFIG_CRYPTO_MD4=m
 CONFIG_CRYPTO_MICHAEL_MIC=m
 CONFIG_CRYPTO_RMD160=m
 CONFIG_CRYPTO_SHA1=m
-CONFIG_CRYPTO_SM3_GENERIC=m
+CONFIG_CRYPTO_SM3=m
 CONFIG_CRYPTO_WP512=m
 CONFIG_CRYPTO_XCBC=m
 CONFIG_CRYPTO_LZO=m
 CONFIG_CRYPTO_842=m
 CONFIG_CRYPTO_LZ4=m
diff --git a/arch/m68k/configs/q40_defconfig b/arch/m68k/configs/q40_defconfig
index 36eb29ec54ee..9087bd9e3c35 100644
--- a/arch/m68k/configs/q40_defconfig
+++ b/arch/m68k/configs/q40_defconfig
@@ -545,11 +545,11 @@ CONFIG_CRYPTO_XTS=m
 CONFIG_CRYPTO_AEGIS128=m
 CONFIG_CRYPTO_MD4=m
 CONFIG_CRYPTO_MICHAEL_MIC=m
 CONFIG_CRYPTO_RMD160=m
 CONFIG_CRYPTO_SHA1=m
-CONFIG_CRYPTO_SM3_GENERIC=m
+CONFIG_CRYPTO_SM3=m
 CONFIG_CRYPTO_WP512=m
 CONFIG_CRYPTO_XCBC=m
 CONFIG_CRYPTO_LZO=m
 CONFIG_CRYPTO_842=m
 CONFIG_CRYPTO_LZ4=m
diff --git a/arch/m68k/configs/sun3_defconfig b/arch/m68k/configs/sun3_defconfig
index 524a89fa6953..25115bda7c8a 100644
--- a/arch/m68k/configs/sun3_defconfig
+++ b/arch/m68k/configs/sun3_defconfig
@@ -526,11 +526,11 @@ CONFIG_CRYPTO_XTS=m
 CONFIG_CRYPTO_AEGIS128=m
 CONFIG_CRYPTO_MD4=m
 CONFIG_CRYPTO_MICHAEL_MIC=m
 CONFIG_CRYPTO_RMD160=m
 CONFIG_CRYPTO_SHA1=m
-CONFIG_CRYPTO_SM3_GENERIC=m
+CONFIG_CRYPTO_SM3=m
 CONFIG_CRYPTO_WP512=m
 CONFIG_CRYPTO_XCBC=m
 CONFIG_CRYPTO_LZO=m
 CONFIG_CRYPTO_842=m
 CONFIG_CRYPTO_LZ4=m
diff --git a/arch/m68k/configs/sun3x_defconfig b/arch/m68k/configs/sun3x_defconfig
index f4fbc65c52d9..15a086634ba5 100644
--- a/arch/m68k/configs/sun3x_defconfig
+++ b/arch/m68k/configs/sun3x_defconfig
@@ -526,11 +526,11 @@ CONFIG_CRYPTO_XTS=m
 CONFIG_CRYPTO_AEGIS128=m
 CONFIG_CRYPTO_MD4=m
 CONFIG_CRYPTO_MICHAEL_MIC=m
 CONFIG_CRYPTO_RMD160=m
 CONFIG_CRYPTO_SHA1=m
-CONFIG_CRYPTO_SM3_GENERIC=m
+CONFIG_CRYPTO_SM3=m
 CONFIG_CRYPTO_WP512=m
 CONFIG_CRYPTO_XCBC=m
 CONFIG_CRYPTO_LZO=m
 CONFIG_CRYPTO_842=m
 CONFIG_CRYPTO_LZ4=m
diff --git a/arch/s390/configs/debug_defconfig b/arch/s390/configs/debug_defconfig
index 98fd0a2f51c6..271d683e7959 100644
--- a/arch/s390/configs/debug_defconfig
+++ b/arch/s390/configs/debug_defconfig
@@ -795,11 +795,11 @@ CONFIG_CRYPTO_SEQIV=y
 CONFIG_CRYPTO_MD4=m
 CONFIG_CRYPTO_MD5=y
 CONFIG_CRYPTO_MICHAEL_MIC=m
 CONFIG_CRYPTO_RMD160=m
 CONFIG_CRYPTO_SHA3=m
-CONFIG_CRYPTO_SM3_GENERIC=m
+CONFIG_CRYPTO_SM3=m
 CONFIG_CRYPTO_WP512=m
 CONFIG_CRYPTO_XCBC=m
 CONFIG_CRYPTO_CRC32=m
 CONFIG_CRYPTO_842=m
 CONFIG_CRYPTO_LZ4=m
diff --git a/arch/s390/configs/defconfig b/arch/s390/configs/defconfig
index 0f4cedcab3ce..e9b64c0d4bcc 100644
--- a/arch/s390/configs/defconfig
+++ b/arch/s390/configs/defconfig
@@ -779,11 +779,11 @@ CONFIG_CRYPTO_SEQIV=y
 CONFIG_CRYPTO_MD4=m
 CONFIG_CRYPTO_MD5=y
 CONFIG_CRYPTO_MICHAEL_MIC=m
 CONFIG_CRYPTO_RMD160=m
 CONFIG_CRYPTO_SHA3=m
-CONFIG_CRYPTO_SM3_GENERIC=m
+CONFIG_CRYPTO_SM3=m
 CONFIG_CRYPTO_WP512=m
 CONFIG_CRYPTO_XCBC=m
 CONFIG_CRYPTO_CRC32=m
 CONFIG_CRYPTO_842=m
 CONFIG_CRYPTO_LZ4=m
diff --git a/crypto/Kconfig b/crypto/Kconfig
index b8608ef6823b..79234fd42eb4 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -979,11 +979,11 @@ config CRYPTO_SHA3
 	select CRYPTO_HASH
 	select CRYPTO_LIB_SHA3
 	help
 	  SHA-3 secure hash algorithms (FIPS 202, ISO/IEC 10118-3)
 
-config CRYPTO_SM3_GENERIC
+config CRYPTO_SM3
 	tristate "SM3 (ShangMi 3)"
 	select CRYPTO_HASH
 	select CRYPTO_LIB_SM3
 	help
 	  SM3 (ShangMi 3) secure hash function (OSCCA GM/T 0004-2012, ISO/IEC 10118-3)
diff --git a/crypto/Makefile b/crypto/Makefile
index 04e269117589..28467f900c9a 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -81,11 +81,11 @@ obj-$(CONFIG_CRYPTO_MD5) += md5.o
 obj-$(CONFIG_CRYPTO_RMD160) += rmd160.o
 obj-$(CONFIG_CRYPTO_SHA1) += sha1.o
 obj-$(CONFIG_CRYPTO_SHA256) += sha256.o
 obj-$(CONFIG_CRYPTO_SHA512) += sha512.o
 obj-$(CONFIG_CRYPTO_SHA3) += sha3.o
-obj-$(CONFIG_CRYPTO_SM3_GENERIC) += sm3_generic.o
+obj-$(CONFIG_CRYPTO_SM3) += sm3_generic.o
 obj-$(CONFIG_CRYPTO_STREEBOG) += streebog_generic.o
 obj-$(CONFIG_CRYPTO_WP512) += wp512.o
 CFLAGS_wp512.o := $(call cc-option,-fno-schedule-insns)  # https://gcc.gnu.org/bugzilla/show_bug.cgi?id=79149
 obj-$(CONFIG_CRYPTO_BLAKE2B) += blake2b.o
 obj-$(CONFIG_CRYPTO_ECB) += ecb.o
diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
index 8d3b5d2890f8..9960100e6066 100644
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -841,11 +841,11 @@ config CRYPTO_DEV_CCREE
 	select CRYPTO_CBC
 	select CRYPTO_ECB
 	select CRYPTO_CTR
 	select CRYPTO_XTS
 	select CRYPTO_SM4_GENERIC
-	select CRYPTO_SM3_GENERIC
+	select CRYPTO_SM3
 	help
 	  Say 'Y' to enable a driver for the REE interface of the Arm
 	  TrustZone CryptoCell family of processors. Currently the
 	  CryptoCell 713, 703, 712, 710 and 630 are supported.
 	  Choose this if you wish to use hardware acceleration of
diff --git a/drivers/crypto/starfive/Kconfig b/drivers/crypto/starfive/Kconfig
index 0fe389e9f932..11518ca3eea1 100644
--- a/drivers/crypto/starfive/Kconfig
+++ b/drivers/crypto/starfive/Kconfig
@@ -8,11 +8,11 @@ config CRYPTO_DEV_JH7110
 	depends on HAS_DMA
 	select CRYPTO_ENGINE
 	select CRYPTO_HMAC
 	select CRYPTO_SHA256
 	select CRYPTO_SHA512
-	select CRYPTO_SM3_GENERIC
+	select CRYPTO_SM3
 	select CRYPTO_RSA
 	select CRYPTO_AES
 	select CRYPTO_CCM
 	select CRYPTO_GCM
 	select CRYPTO_ECB
diff --git a/security/integrity/ima/Kconfig b/security/integrity/ima/Kconfig
index 976e75f9b9ba..862fbee2b174 100644
--- a/security/integrity/ima/Kconfig
+++ b/security/integrity/ima/Kconfig
@@ -109,11 +109,11 @@ choice
 		bool "WP512"
 		depends on CRYPTO_WP512=y
 
 	config IMA_DEFAULT_HASH_SM3
 		bool "SM3"
-		depends on CRYPTO_SM3_GENERIC=y
+		depends on CRYPTO_SM3=y
 endchoice
 
 config IMA_DEFAULT_HASH
 	string
 	default "sha1" if IMA_DEFAULT_HASH_SHA1
-- 
2.53.0

