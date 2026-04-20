Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E5E138552A;
	Mon, 20 Apr 2026 06:37:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776667023; cv=none; b=AhNu/Sy9QfJnE57SOwTEKlr0oVmaKTeCzibacYEKj46BIC02YfmueIITBFPVEdD/5HSLvKFjLtc4y4z/3WedDdXY9EsVCWONdfEIuWBEilbxtL8MqRn10HlYFtBv/o2ewIXCGRlzq7qAxtWxrLzQRj55kMaUIQA5RI4Vh87vgro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776667023; c=relaxed/simple;
	bh=3c1n0dsylwDFTo1RXTTpXVmAJ16yALP9LYtnR0iqMJ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DAaf/UM8XUUQAZMPNlNl8VSpu9/WBEn+81ais1tJA3cwzLyuLPJn8mUu4Eqh4MvLTQ3M+ha+aF+9qz+9LaJdyyryrmx7Tv3/n1+i+IQ8dHur0UZuduwrwE3PvS/ouP47vskT377uwNl2hrIAfkmzBWHz4Ook660mg0EBEyfY/qU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=T48yebaY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="T48yebaY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 066D4C2BCB6;
	Mon, 20 Apr 2026 06:37:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776667023;
	bh=3c1n0dsylwDFTo1RXTTpXVmAJ16yALP9LYtnR0iqMJ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T48yebaYiHgtYGk3YvGou8op926YV69wiB6HGcjRQ/Htt3F//pGArUTEQKAiiklY6
	 rEdzCb22uCRI2eZiXoSYmHri1DWk8IE/7jyMPsr6r+ZCCkTmOndm13saNlFaFz/2Tu
	 Gq+sPjYWkJIfvwz8YY7WP3krgEB5lap+AerkqCBeHUBzKJCV6LbXnr7qFFZnYsLVK1
	 enqlMqI4QwuGFL+KjMj1sJp3FwhImKpOz0PcRX1+mIS3ftvm0knVmP4weSVJorxjc1
	 bGJpi676tsosu5NtG2qAimCW8jMtZLsvFj1m6ZPagjGlkU1SEhEuK59bOy6jh+DVpK
	 t2/36gR3N2L2w==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-kernel@vger.kernel.org,
	Stephan Mueller <smueller@chronox.de>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 12/38] crypto: drbg - Remove support for CTR_DRBG
Date: Sun, 19 Apr 2026 23:33:56 -0700
Message-ID: <20260420063422.324906-13-ebiggers@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420063422.324906-1-ebiggers@kernel.org>
References: <20260420063422.324906-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Remove the support for CTR_DRBG.  It's likely unused code, seeing as
HMAC_DRBG is always enabled and prioritized over it unless
NETLINK_CRYPTO is used to change the algorithm priorities.

There's also no compelling reason to support more than one of
[HMAC_DRBG, HASH_DRBG, CTR_DRBG].  By definition, callers cannot tell
any difference in their outputs.  And all are FIPS-certifiable, which is
the only point of the kernel's NIST DRBGs anyway.

Switching to CTR_DRBG doesn't seem all that compelling, either.  While
it's often the fastest NIST DRBG, it has several disadvantages:

- CTR_DRBG uses AES.  Some platforms don't have AES acceleration at all,
  causing a fallback to the table-based AES code which is very slow and
  can be vulnerable to cache-timing attacks.  In contrast, HMAC_DRBG
  uses primitives that are consistently constant-time.

- CTR_DRBG is usually considered to be somewhat less cryptographically
  robust than HMAC_DRBG.  Granted, HMAC_DRBG isn't all that great
  either, e.g. given the negative result from Woodage & Shumow (2018)
  (https://eprint.iacr.org/2018/349.pdf), but that can be worked around.

- CTR_DRBG is more complex than HMAC_DRBG, risking bugs.  Indeed, while
  reviewing the CTR_DRBG code, I found two bugs, including one where it
  can return success while leaving the output buffer uninitialized.

- The kernel's implementation of CTR_DRBG uses an "ctr(aes)"
  crypto_skcipher and relies on it returning the next counter value.
  That's fragile, and indeed historically many "ctr(aes)"
  crypto_skcipher implementations haven't done that.  E.g. see
  commit 511306b2d075 ("crypto: arm/aes-ce - update IV after partial final CTR block"),
  commit fa5fd3afc7e6 ("crypto: arm64/aes-blk - update IV after partial final CTR block"),
  commit 371731ec2179 ("crypto: atmel-aes - Fix saving of IV for CTR mode"),
  commit 25baaf8e2c93 ("crypto: crypto4xx - fix ctr-aes missing output IV"),
  commit 334d37c9e263 ("crypto: caam - update IV using HW support"),
  commit 0a4491d3febe ("crypto: chelsio - count incomplete block in IV"),
  commit e8e3c1ca57d4 ("crypto: s5p - update iv after AES-CBC op end").

  I.e., there were many years where the kernel's CTR_DRBG code (if it
  were to have actually been used) repeated outputs on some platforms.

  AES-CTR also uses a 128-bit counter, which creates overflow edge cases
  that are sometimes gotten wrong.  E.g. see commit 009b30ac7444
  ("crypto: vmx - CTR: always increment IV as quadword").

So, while switching to CTR_DRBG for performance reasons isn't completely
out of the question (notably BoringSSL uses it), it would take quite a
bit more work to create a solid implementation of it in the kernel,
including a more solid implementation of AES-CTR itself (in lib/crypto/,
with a scalar bit-sliced fallback, etc).  Since HMAC_DRBG has always
been the default NIST DRBG variant in the kernel and is in a better
state, let's just standardize on it for now.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 arch/m68k/configs/amiga_defconfig          |   1 -
 arch/m68k/configs/apollo_defconfig         |   1 -
 arch/m68k/configs/atari_defconfig          |   1 -
 arch/m68k/configs/bvme6000_defconfig       |   1 -
 arch/m68k/configs/hp300_defconfig          |   1 -
 arch/m68k/configs/mac_defconfig            |   1 -
 arch/m68k/configs/multi_defconfig          |   1 -
 arch/m68k/configs/mvme147_defconfig        |   1 -
 arch/m68k/configs/mvme16x_defconfig        |   1 -
 arch/m68k/configs/q40_defconfig            |   1 -
 arch/m68k/configs/sun3_defconfig           |   1 -
 arch/m68k/configs/sun3x_defconfig          |   1 -
 arch/mips/configs/decstation_64_defconfig  |   1 -
 arch/mips/configs/decstation_defconfig     |   1 -
 arch/mips/configs/decstation_r4k_defconfig |   1 -
 crypto/Kconfig                             |   8 -
 crypto/drbg.c                              | 332 +--------------------
 crypto/testmgr.c                           |  37 ---
 crypto/testmgr.h                           | 252 ----------------
 include/crypto/internal/drbg.h             |   3 +
 20 files changed, 9 insertions(+), 638 deletions(-)

diff --git a/arch/m68k/configs/amiga_defconfig b/arch/m68k/configs/amiga_defconfig
index 47e48c18e55c..a8ca9023caf3 100644
--- a/arch/m68k/configs/amiga_defconfig
+++ b/arch/m68k/configs/amiga_defconfig
@@ -549,11 +549,10 @@ CONFIG_CRYPTO_LZO=m
 CONFIG_CRYPTO_842=m
 CONFIG_CRYPTO_LZ4=m
 CONFIG_CRYPTO_LZ4HC=m
 CONFIG_CRYPTO_ZSTD=m
 CONFIG_CRYPTO_DRBG_HASH=y
-CONFIG_CRYPTO_DRBG_CTR=y
 CONFIG_CRYPTO_USER_API_HASH=m
 CONFIG_CRYPTO_USER_API_SKCIPHER=m
 CONFIG_CRYPTO_USER_API_RNG=m
 CONFIG_CRYPTO_USER_API_AEAD=m
 # CONFIG_CRYPTO_HW is not set
diff --git a/arch/m68k/configs/apollo_defconfig b/arch/m68k/configs/apollo_defconfig
index 161586d611ab..5c6610d9e80a 100644
--- a/arch/m68k/configs/apollo_defconfig
+++ b/arch/m68k/configs/apollo_defconfig
@@ -504,11 +504,10 @@ CONFIG_CRYPTO_LZO=m
 CONFIG_CRYPTO_842=m
 CONFIG_CRYPTO_LZ4=m
 CONFIG_CRYPTO_LZ4HC=m
 CONFIG_CRYPTO_ZSTD=m
 CONFIG_CRYPTO_DRBG_HASH=y
-CONFIG_CRYPTO_DRBG_CTR=y
 CONFIG_CRYPTO_USER_API_HASH=m
 CONFIG_CRYPTO_USER_API_SKCIPHER=m
 CONFIG_CRYPTO_USER_API_RNG=m
 CONFIG_CRYPTO_USER_API_AEAD=m
 # CONFIG_CRYPTO_HW is not set
diff --git a/arch/m68k/configs/atari_defconfig b/arch/m68k/configs/atari_defconfig
index c13c6deeac22..4d080f6f3ddf 100644
--- a/arch/m68k/configs/atari_defconfig
+++ b/arch/m68k/configs/atari_defconfig
@@ -526,11 +526,10 @@ CONFIG_CRYPTO_LZO=m
 CONFIG_CRYPTO_842=m
 CONFIG_CRYPTO_LZ4=m
 CONFIG_CRYPTO_LZ4HC=m
 CONFIG_CRYPTO_ZSTD=m
 CONFIG_CRYPTO_DRBG_HASH=y
-CONFIG_CRYPTO_DRBG_CTR=y
 CONFIG_CRYPTO_USER_API_HASH=m
 CONFIG_CRYPTO_USER_API_SKCIPHER=m
 CONFIG_CRYPTO_USER_API_RNG=m
 CONFIG_CRYPTO_USER_API_AEAD=m
 # CONFIG_CRYPTO_HW is not set
diff --git a/arch/m68k/configs/bvme6000_defconfig b/arch/m68k/configs/bvme6000_defconfig
index d4f3f94b61ff..c61fc9d13d30 100644
--- a/arch/m68k/configs/bvme6000_defconfig
+++ b/arch/m68k/configs/bvme6000_defconfig
@@ -496,11 +496,10 @@ CONFIG_CRYPTO_LZO=m
 CONFIG_CRYPTO_842=m
 CONFIG_CRYPTO_LZ4=m
 CONFIG_CRYPTO_LZ4HC=m
 CONFIG_CRYPTO_ZSTD=m
 CONFIG_CRYPTO_DRBG_HASH=y
-CONFIG_CRYPTO_DRBG_CTR=y
 CONFIG_CRYPTO_USER_API_HASH=m
 CONFIG_CRYPTO_USER_API_SKCIPHER=m
 CONFIG_CRYPTO_USER_API_RNG=m
 CONFIG_CRYPTO_USER_API_AEAD=m
 # CONFIG_CRYPTO_HW is not set
diff --git a/arch/m68k/configs/hp300_defconfig b/arch/m68k/configs/hp300_defconfig
index 58288f83349d..2bc20cfdfcf6 100644
--- a/arch/m68k/configs/hp300_defconfig
+++ b/arch/m68k/configs/hp300_defconfig
@@ -506,11 +506,10 @@ CONFIG_CRYPTO_LZO=m
 CONFIG_CRYPTO_842=m
 CONFIG_CRYPTO_LZ4=m
 CONFIG_CRYPTO_LZ4HC=m
 CONFIG_CRYPTO_ZSTD=m
 CONFIG_CRYPTO_DRBG_HASH=y
-CONFIG_CRYPTO_DRBG_CTR=y
 CONFIG_CRYPTO_USER_API_HASH=m
 CONFIG_CRYPTO_USER_API_SKCIPHER=m
 CONFIG_CRYPTO_USER_API_RNG=m
 CONFIG_CRYPTO_USER_API_AEAD=m
 # CONFIG_CRYPTO_HW is not set
diff --git a/arch/m68k/configs/mac_defconfig b/arch/m68k/configs/mac_defconfig
index abb369fd1f55..e03877efc7e6 100644
--- a/arch/m68k/configs/mac_defconfig
+++ b/arch/m68k/configs/mac_defconfig
@@ -525,11 +525,10 @@ CONFIG_CRYPTO_LZO=m
 CONFIG_CRYPTO_842=m
 CONFIG_CRYPTO_LZ4=m
 CONFIG_CRYPTO_LZ4HC=m
 CONFIG_CRYPTO_ZSTD=m
 CONFIG_CRYPTO_DRBG_HASH=y
-CONFIG_CRYPTO_DRBG_CTR=y
 CONFIG_CRYPTO_USER_API_HASH=m
 CONFIG_CRYPTO_USER_API_SKCIPHER=m
 CONFIG_CRYPTO_USER_API_RNG=m
 CONFIG_CRYPTO_USER_API_AEAD=m
 # CONFIG_CRYPTO_HW is not set
diff --git a/arch/m68k/configs/multi_defconfig b/arch/m68k/configs/multi_defconfig
index cb8de979700f..d613bfedee8a 100644
--- a/arch/m68k/configs/multi_defconfig
+++ b/arch/m68k/configs/multi_defconfig
@@ -612,11 +612,10 @@ CONFIG_CRYPTO_LZO=m
 CONFIG_CRYPTO_842=m
 CONFIG_CRYPTO_LZ4=m
 CONFIG_CRYPTO_LZ4HC=m
 CONFIG_CRYPTO_ZSTD=m
 CONFIG_CRYPTO_DRBG_HASH=y
-CONFIG_CRYPTO_DRBG_CTR=y
 CONFIG_CRYPTO_USER_API_HASH=m
 CONFIG_CRYPTO_USER_API_SKCIPHER=m
 CONFIG_CRYPTO_USER_API_RNG=m
 CONFIG_CRYPTO_USER_API_AEAD=m
 # CONFIG_CRYPTO_HW is not set
diff --git a/arch/m68k/configs/mvme147_defconfig b/arch/m68k/configs/mvme147_defconfig
index 176540bd5074..fe343a8f69f5 100644
--- a/arch/m68k/configs/mvme147_defconfig
+++ b/arch/m68k/configs/mvme147_defconfig
@@ -496,11 +496,10 @@ CONFIG_CRYPTO_LZO=m
 CONFIG_CRYPTO_842=m
 CONFIG_CRYPTO_LZ4=m
 CONFIG_CRYPTO_LZ4HC=m
 CONFIG_CRYPTO_ZSTD=m
 CONFIG_CRYPTO_DRBG_HASH=y
-CONFIG_CRYPTO_DRBG_CTR=y
 CONFIG_CRYPTO_USER_API_HASH=m
 CONFIG_CRYPTO_USER_API_SKCIPHER=m
 CONFIG_CRYPTO_USER_API_RNG=m
 CONFIG_CRYPTO_USER_API_AEAD=m
 # CONFIG_CRYPTO_HW is not set
diff --git a/arch/m68k/configs/mvme16x_defconfig b/arch/m68k/configs/mvme16x_defconfig
index 8b2e5cf4d2f2..c5803f67f30b 100644
--- a/arch/m68k/configs/mvme16x_defconfig
+++ b/arch/m68k/configs/mvme16x_defconfig
@@ -497,11 +497,10 @@ CONFIG_CRYPTO_LZO=m
 CONFIG_CRYPTO_842=m
 CONFIG_CRYPTO_LZ4=m
 CONFIG_CRYPTO_LZ4HC=m
 CONFIG_CRYPTO_ZSTD=m
 CONFIG_CRYPTO_DRBG_HASH=y
-CONFIG_CRYPTO_DRBG_CTR=y
 CONFIG_CRYPTO_USER_API_HASH=m
 CONFIG_CRYPTO_USER_API_SKCIPHER=m
 CONFIG_CRYPTO_USER_API_RNG=m
 CONFIG_CRYPTO_USER_API_AEAD=m
 # CONFIG_CRYPTO_HW is not set
diff --git a/arch/m68k/configs/q40_defconfig b/arch/m68k/configs/q40_defconfig
index d48f3cf5285b..619518c30e0b 100644
--- a/arch/m68k/configs/q40_defconfig
+++ b/arch/m68k/configs/q40_defconfig
@@ -515,11 +515,10 @@ CONFIG_CRYPTO_LZO=m
 CONFIG_CRYPTO_842=m
 CONFIG_CRYPTO_LZ4=m
 CONFIG_CRYPTO_LZ4HC=m
 CONFIG_CRYPTO_ZSTD=m
 CONFIG_CRYPTO_DRBG_HASH=y
-CONFIG_CRYPTO_DRBG_CTR=y
 CONFIG_CRYPTO_USER_API_HASH=m
 CONFIG_CRYPTO_USER_API_SKCIPHER=m
 CONFIG_CRYPTO_USER_API_RNG=m
 CONFIG_CRYPTO_USER_API_AEAD=m
 # CONFIG_CRYPTO_HW is not set
diff --git a/arch/m68k/configs/sun3_defconfig b/arch/m68k/configs/sun3_defconfig
index 0b96428f25d4..530fa722e3b2 100644
--- a/arch/m68k/configs/sun3_defconfig
+++ b/arch/m68k/configs/sun3_defconfig
@@ -494,11 +494,10 @@ CONFIG_CRYPTO_LZO=m
 CONFIG_CRYPTO_842=m
 CONFIG_CRYPTO_LZ4=m
 CONFIG_CRYPTO_LZ4HC=m
 CONFIG_CRYPTO_ZSTD=m
 CONFIG_CRYPTO_DRBG_HASH=y
-CONFIG_CRYPTO_DRBG_CTR=y
 CONFIG_CRYPTO_USER_API_HASH=m
 CONFIG_CRYPTO_USER_API_SKCIPHER=m
 CONFIG_CRYPTO_USER_API_RNG=m
 CONFIG_CRYPTO_USER_API_AEAD=m
 # CONFIG_CRYPTO_HW is not set
diff --git a/arch/m68k/configs/sun3x_defconfig b/arch/m68k/configs/sun3x_defconfig
index 6140e18244a1..f282e05bc8f9 100644
--- a/arch/m68k/configs/sun3x_defconfig
+++ b/arch/m68k/configs/sun3x_defconfig
@@ -494,11 +494,10 @@ CONFIG_CRYPTO_LZO=m
 CONFIG_CRYPTO_842=m
 CONFIG_CRYPTO_LZ4=m
 CONFIG_CRYPTO_LZ4HC=m
 CONFIG_CRYPTO_ZSTD=m
 CONFIG_CRYPTO_DRBG_HASH=y
-CONFIG_CRYPTO_DRBG_CTR=y
 CONFIG_CRYPTO_USER_API_HASH=m
 CONFIG_CRYPTO_USER_API_SKCIPHER=m
 CONFIG_CRYPTO_USER_API_RNG=m
 CONFIG_CRYPTO_USER_API_AEAD=m
 # CONFIG_CRYPTO_HW is not set
diff --git a/arch/mips/configs/decstation_64_defconfig b/arch/mips/configs/decstation_64_defconfig
index 7c43352fac6b..6712143a2842 100644
--- a/arch/mips/configs/decstation_64_defconfig
+++ b/arch/mips/configs/decstation_64_defconfig
@@ -198,9 +198,8 @@ CONFIG_CRYPTO_TWOFISH=m
 CONFIG_CRYPTO_LZO=m
 CONFIG_CRYPTO_842=m
 CONFIG_CRYPTO_LZ4=m
 CONFIG_CRYPTO_LZ4HC=m
 CONFIG_CRYPTO_DRBG_HASH=y
-CONFIG_CRYPTO_DRBG_CTR=y
 # CONFIG_CRYPTO_HW is not set
 CONFIG_MAGIC_SYSRQ=y
 # CONFIG_FTRACE is not set
diff --git a/arch/mips/configs/decstation_defconfig b/arch/mips/configs/decstation_defconfig
index aee10274f048..1a31bbb99839 100644
--- a/arch/mips/configs/decstation_defconfig
+++ b/arch/mips/configs/decstation_defconfig
@@ -193,10 +193,9 @@ CONFIG_CRYPTO_TWOFISH=m
 CONFIG_CRYPTO_LZO=m
 CONFIG_CRYPTO_842=m
 CONFIG_CRYPTO_LZ4=m
 CONFIG_CRYPTO_LZ4HC=m
 CONFIG_CRYPTO_DRBG_HASH=y
-CONFIG_CRYPTO_DRBG_CTR=y
 # CONFIG_CRYPTO_HW is not set
 CONFIG_FRAME_WARN=2048
 CONFIG_MAGIC_SYSRQ=y
 # CONFIG_FTRACE is not set
diff --git a/arch/mips/configs/decstation_r4k_defconfig b/arch/mips/configs/decstation_r4k_defconfig
index a1698049aa7a..8ff71ca43bfb 100644
--- a/arch/mips/configs/decstation_r4k_defconfig
+++ b/arch/mips/configs/decstation_r4k_defconfig
@@ -193,10 +193,9 @@ CONFIG_CRYPTO_TWOFISH=m
 CONFIG_CRYPTO_LZO=m
 CONFIG_CRYPTO_842=m
 CONFIG_CRYPTO_LZ4=m
 CONFIG_CRYPTO_LZ4HC=m
 CONFIG_CRYPTO_DRBG_HASH=y
-CONFIG_CRYPTO_DRBG_CTR=y
 # CONFIG_CRYPTO_HW is not set
 CONFIG_FRAME_WARN=2048
 CONFIG_MAGIC_SYSRQ=y
 # CONFIG_FTRACE is not set
diff --git a/crypto/Kconfig b/crypto/Kconfig
index 34da01c153d6..b16a1aa95c46 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -1128,18 +1128,10 @@ config CRYPTO_DRBG_HASH
 	help
 	  Hash_DRBG variant as defined in NIST SP800-90A.
 
 	  This uses the SHA-1, SHA-256, SHA-384, or SHA-512 hash algorithms.
 
-config CRYPTO_DRBG_CTR
-	bool "CTR_DRBG"
-	select CRYPTO_DF80090A
-	help
-	  CTR_DRBG variant as defined in NIST SP800-90A.
-
-	  This uses the AES cipher algorithm with the counter block mode.
-
 config CRYPTO_DRBG
 	tristate
 	default CRYPTO_DRBG_MENU
 	select CRYPTO_HMAC
 	select CRYPTO_JITTERENTROPY
diff --git a/crypto/drbg.c b/crypto/drbg.c
index 9dedc6186b42..b29090bb59bc 100644
--- a/crypto/drbg.c
+++ b/crypto/drbg.c
@@ -1,10 +1,9 @@
 /*
  * DRBG: Deterministic Random Bits Generator
  *       Based on NIST Recommended DRBG from NIST SP800-90A with the following
  *       properties:
- *		* CTR DRBG with DF with AES-128, AES-192, AES-256 cores
  *		* Hash DRBG with DF with SHA-1, SHA-256, SHA-384, SHA-512 cores
  *		* HMAC DRBG with DF with SHA-1, SHA-256, SHA-384, SHA-512 cores
  *		* with and without prediction resistance
  *
  * Copyright Stephan Mueller <smueller@chronox.de>, 2014
@@ -90,21 +89,18 @@
  * Usage with personalization and additional information strings
  * -------------------------------------------------------------
  * Just mix both scenarios above.
  */
 
-#include <crypto/df_sp80090a.h>
 #include <crypto/internal/drbg.h>
 #include <crypto/internal/rng.h>
 #include <crypto/hash.h>
-#include <crypto/skcipher.h>
 #include <linux/fips.h>
 #include <linux/kernel.h>
 #include <linux/jiffies.h>
 #include <linux/module.h>
 #include <linux/mutex.h>
-#include <linux/scatterlist.h>
 #include <linux/string_choices.h>
 #include <linux/unaligned.h>
 
 struct drbg_state;
 typedef uint32_t drbg_flag_t;
@@ -137,28 +133,21 @@ enum drbg_seed_state {
 
 struct drbg_state {
 	struct mutex drbg_mutex;	/* lock around DRBG */
 	unsigned char *V;	/* internal state 10.1.1.1 1a) */
 	unsigned char *Vbuf;
-	/* hash: static value 10.1.1.1 1b) hmac / ctr: key */
+	/* hash: static value 10.1.1.1 1b) hmac: key */
 	unsigned char *C;
 	unsigned char *Cbuf;
 	/* Number of RNG requests since last reseed -- 10.1.1.1 1c) */
 	size_t reseed_ctr;
 	size_t reseed_threshold;
 	 /* some memory the DRBG can use for its operation */
 	unsigned char *scratchpad;
 	unsigned char *scratchpadbuf;
 	void *priv_data;	/* Cipher handle */
 
-	struct crypto_skcipher *ctr_handle;	/* CTR mode cipher handle */
-	struct skcipher_request *ctr_req;	/* CTR mode request handle */
-	__u8 *outscratchpadbuf;			/* CTR mode output scratchpad */
-        __u8 *outscratchpad;			/* CTR mode aligned outbuf */
-	struct crypto_wait ctr_wait;		/* CTR mode async wait obj */
-	struct scatterlist sg_in, sg_out;	/* CTR mode SGLs */
-
 	enum drbg_seed_state seeded;		/* DRBG fully seeded? */
 	unsigned long last_seed_time;
 	bool pr;		/* Prediction resistance enabled? */
 	struct crypto_rng *jent;
 	const struct drbg_state_ops *d_ops;
@@ -178,17 +167,10 @@ static inline __u8 drbg_blocklen(struct drbg_state *drbg)
 	if (drbg && drbg->core)
 		return drbg->core->blocklen_bytes;
 	return 0;
 }
 
-static inline __u8 drbg_keylen(struct drbg_state *drbg)
-{
-	if (drbg && drbg->core)
-		return (drbg->core->statelen - drbg->core->blocklen_bytes);
-	return 0;
-}
-
 static inline size_t drbg_max_request_bytes(struct drbg_state *drbg)
 {
 	/* SP800-90A requires the limit 2**19 bits, but we return bytes */
 	return (1 << 16);
 }
@@ -209,14 +191,13 @@ static inline size_t drbg_max_requests(struct drbg_state *drbg)
 	/* SP800-90A requires 2**48 maximum requests before reseeding */
 	return (1<<20);
 }
 
 /* DRBG type flags */
-#define DRBG_CTR	((drbg_flag_t)1<<0)
 #define DRBG_HMAC	((drbg_flag_t)1<<1)
 #define DRBG_HASH	((drbg_flag_t)1<<2)
-#define DRBG_TYPE_MASK	(DRBG_CTR | DRBG_HMAC | DRBG_HASH)
+#define DRBG_TYPE_MASK	(DRBG_HMAC | DRBG_HASH)
 /* DRBG strength flags */
 #define DRBG_STRENGTH128	((drbg_flag_t)1<<3)
 #define DRBG_STRENGTH192	((drbg_flag_t)1<<4)
 #define DRBG_STRENGTH256	((drbg_flag_t)1<<5)
 #define DRBG_STRENGTH_MASK	(DRBG_STRENGTH128 | DRBG_STRENGTH192 | \
@@ -236,36 +217,13 @@ enum drbg_prefixes {
 /*
  * The order of the DRBG definitions here matter: every DRBG is registered
  * as stdrng. Each DRBG receives an increasing cra_priority values the later
  * they are defined in this array (see drbg_fill_array).
  *
- * HMAC DRBGs are favored over Hash DRBGs over CTR DRBGs, and the
- * HMAC-SHA512 / SHA256 / AES 256 over other ciphers. Thus, the
- * favored DRBGs are the latest entries in this array.
+ * Thus, the favored DRBGs are the latest entries in this array.
  */
 static const struct drbg_core drbg_cores[] = {
-#ifdef CONFIG_CRYPTO_DRBG_CTR
-	{
-		.flags = DRBG_CTR | DRBG_STRENGTH128,
-		.statelen = 32, /* 256 bits as defined in 10.2.1 */
-		.blocklen_bytes = 16,
-		.cra_name = "ctr_aes128",
-		.backend_cra_name = "aes",
-	}, {
-		.flags = DRBG_CTR | DRBG_STRENGTH192,
-		.statelen = 40, /* 320 bits as defined in 10.2.1 */
-		.blocklen_bytes = 16,
-		.cra_name = "ctr_aes192",
-		.backend_cra_name = "aes",
-	}, {
-		.flags = DRBG_CTR | DRBG_STRENGTH256,
-		.statelen = 48, /* 384 bits as defined in 10.2.1 */
-		.blocklen_bytes = 16,
-		.cra_name = "ctr_aes256",
-		.backend_cra_name = "aes",
-	},
-#endif /* CONFIG_CRYPTO_DRBG_CTR */
 #ifdef CONFIG_CRYPTO_DRBG_HASH
 	{
 		.flags = DRBG_HASH | DRBG_STRENGTH256,
 		.statelen = 111, /* 888 bits */
 		.blocklen_bytes = 48,
@@ -332,151 +290,10 @@ static inline unsigned short drbg_sec_strength(drbg_flag_t flags)
 	default:
 		return 32;
 	}
 }
 
-/******************************************************************
- * CTR DRBG callback functions
- ******************************************************************/
-
-#ifdef CONFIG_CRYPTO_DRBG_CTR
-#define CRYPTO_DRBG_CTR_STRING "CTR "
-MODULE_ALIAS_CRYPTO("drbg_pr_ctr_aes256");
-MODULE_ALIAS_CRYPTO("drbg_nopr_ctr_aes256");
-MODULE_ALIAS_CRYPTO("drbg_pr_ctr_aes192");
-MODULE_ALIAS_CRYPTO("drbg_nopr_ctr_aes192");
-MODULE_ALIAS_CRYPTO("drbg_pr_ctr_aes128");
-MODULE_ALIAS_CRYPTO("drbg_nopr_ctr_aes128");
-
-static int drbg_init_sym_kernel(struct drbg_state *drbg);
-static int drbg_fini_sym_kernel(struct drbg_state *drbg);
-static int drbg_kcapi_sym_ctr(struct drbg_state *drbg,
-			      u8 *inbuf, u32 inbuflen,
-			      u8 *outbuf, u32 outlen);
-#define DRBG_OUTSCRATCHLEN 256
-
-static int drbg_ctr_df(struct drbg_state *drbg,
-		       unsigned char *df_data, size_t bytes_to_return,
-		       struct list_head *seedlist)
-{
-	return crypto_drbg_ctr_df(drbg->priv_data, df_data, drbg_statelen(drbg),
-				  seedlist, drbg_blocklen(drbg), drbg_statelen(drbg));
-}
-
-/*
- * update function of CTR DRBG as defined in 10.2.1.2
- *
- * The reseed variable has an enhanced meaning compared to the update
- * functions of the other DRBGs as follows:
- * 0 => initial seed from initialization
- * 1 => reseed via drbg_seed
- * 2 => first invocation from drbg_ctr_update when addtl is present. In
- *      this case, the df_data scratchpad is not deleted so that it is
- *      available for another calls to prevent calling the DF function
- *      again.
- * 3 => second invocation from drbg_ctr_update. When the update function
- *      was called with addtl, the df_data memory already contains the
- *      DFed addtl information and we do not need to call DF again.
- */
-static int drbg_ctr_update(struct drbg_state *drbg, struct list_head *seed,
-			   int reseed)
-{
-	int ret = -EFAULT;
-	/* 10.2.1.2 step 1 */
-	unsigned char *temp = drbg->scratchpad;
-	unsigned char *df_data = drbg->scratchpad + drbg_statelen(drbg) +
-				 drbg_blocklen(drbg);
-
-	if (3 > reseed)
-		memset(df_data, 0, drbg_statelen(drbg));
-
-	if (!reseed) {
-		/*
-		 * The DRBG uses the CTR mode of the underlying AES cipher. The
-		 * CTR mode increments the counter value after the AES operation
-		 * but SP800-90A requires that the counter is incremented before
-		 * the AES operation. Hence, we increment it at the time we set
-		 * it by one.
-		 */
-		crypto_inc(drbg->V, drbg_blocklen(drbg));
-
-		ret = crypto_skcipher_setkey(drbg->ctr_handle, drbg->C,
-					     drbg_keylen(drbg));
-		if (ret)
-			goto out;
-	}
-
-	/* 10.2.1.3.2 step 2 and 10.2.1.4.2 step 2 */
-	if (seed) {
-		ret = drbg_ctr_df(drbg, df_data, drbg_statelen(drbg), seed);
-		if (ret)
-			goto out;
-	}
-
-	ret = drbg_kcapi_sym_ctr(drbg, df_data, drbg_statelen(drbg),
-				 temp, drbg_statelen(drbg));
-	if (ret)
-		return ret;
-
-	/* 10.2.1.2 step 5 */
-	ret = crypto_skcipher_setkey(drbg->ctr_handle, temp,
-				     drbg_keylen(drbg));
-	if (ret)
-		goto out;
-	/* 10.2.1.2 step 6 */
-	memcpy(drbg->V, temp + drbg_keylen(drbg), drbg_blocklen(drbg));
-	/* See above: increment counter by one to compensate timing of CTR op */
-	crypto_inc(drbg->V, drbg_blocklen(drbg));
-	ret = 0;
-
-out:
-	memset(temp, 0, drbg_statelen(drbg) + drbg_blocklen(drbg));
-	if (2 != reseed)
-		memset(df_data, 0, drbg_statelen(drbg));
-	return ret;
-}
-
-/*
- * scratchpad use: drbg_ctr_update is called independently from
- * drbg_ctr_extract_bytes. Therefore, the scratchpad is reused
- */
-/* Generate function of CTR DRBG as defined in 10.2.1.5.2 */
-static int drbg_ctr_generate(struct drbg_state *drbg,
-			     unsigned char *buf, unsigned int buflen,
-			     struct list_head *addtl)
-{
-	int ret;
-	int len = min_t(int, buflen, INT_MAX);
-
-	/* 10.2.1.5.2 step 2 */
-	if (addtl && !list_empty(addtl)) {
-		ret = drbg_ctr_update(drbg, addtl, 2);
-		if (ret)
-			return ret;
-	}
-
-	/* 10.2.1.5.2 step 4.1 */
-	ret = drbg_kcapi_sym_ctr(drbg, NULL, 0, buf, len);
-	if (ret)
-		return ret;
-
-	/* 10.2.1.5.2 step 6 */
-	ret = drbg_ctr_update(drbg, NULL, 3);
-	if (ret)
-		len = ret;
-
-	return len;
-}
-
-static const struct drbg_state_ops drbg_ctr_ops = {
-	.update		= drbg_ctr_update,
-	.generate	= drbg_ctr_generate,
-	.crypto_init	= drbg_init_sym_kernel,
-	.crypto_fini	= drbg_fini_sym_kernel,
-};
-#endif /* CONFIG_CRYPTO_DRBG_CTR */
-
 /******************************************************************
  * HMAC DRBG callback functions
  ******************************************************************/
 
 static int drbg_kcapi_hash(struct drbg_state *drbg, unsigned char *outval,
@@ -1106,15 +923,10 @@ static inline int drbg_alloc_state(struct drbg_state *drbg)
 #ifdef CONFIG_CRYPTO_DRBG_HASH
 	case DRBG_HASH:
 		drbg->d_ops = &drbg_hash_ops;
 		break;
 #endif /* CONFIG_CRYPTO_DRBG_HASH */
-#ifdef CONFIG_CRYPTO_DRBG_CTR
-	case DRBG_CTR:
-		drbg->d_ops = &drbg_ctr_ops;
-		break;
-#endif /* CONFIG_CRYPTO_DRBG_CTR */
 	default:
 		ret = -EOPNOTSUPP;
 		goto err;
 	}
 
@@ -1132,17 +944,13 @@ static inline int drbg_alloc_state(struct drbg_state *drbg)
 	if (!drbg->Cbuf) {
 		ret = -ENOMEM;
 		goto fini;
 	}
 	drbg->C = PTR_ALIGN(drbg->Cbuf, ret + 1);
-	/* scratchpad is only generated for CTR and Hash */
+	/* scratchpad is only generated for Hash */
 	if (drbg->core->flags & DRBG_HMAC)
 		sb_size = 0;
-	else if (drbg->core->flags & DRBG_CTR)
-		sb_size = drbg_statelen(drbg) + drbg_blocklen(drbg) + /* temp */
-			  crypto_drbg_ctr_df_datalen(drbg_statelen(drbg),
-						     drbg_blocklen(drbg));
 	else
 		sb_size = drbg_statelen(drbg) + drbg_blocklen(drbg);
 
 	if (0 < sb_size) {
 		drbg->scratchpadbuf = kzalloc(sb_size + ret, GFP_KERNEL);
@@ -1251,11 +1059,11 @@ static int drbg_generate(struct drbg_state *drbg,
 	if (addtl && 0 < addtl->len)
 		list_add_tail(&addtl->list, &addtllist);
 	/* 9.3.1 step 8 and 10 */
 	len = drbg->d_ops->generate(drbg, buf, buflen, &addtllist);
 
-	/* 10.1.1.4 step 6, 10.1.2.5 step 7, 10.2.1.5.2 step 7 */
+	/* 10.1.1.4 step 6, 10.1.2.5 step 7 */
 	drbg->reseed_ctr++;
 	if (0 >= len)
 		goto err;
 
 	/*
@@ -1502,131 +1310,10 @@ static int drbg_kcapi_hash(struct drbg_state *drbg, unsigned char *outval,
 	list_for_each_entry(input, in, list)
 		crypto_shash_update(&sdesc->shash, input->buf, input->len);
 	return crypto_shash_final(&sdesc->shash, outval);
 }
 
-#ifdef CONFIG_CRYPTO_DRBG_CTR
-static int drbg_fini_sym_kernel(struct drbg_state *drbg)
-{
-	struct aes_enckey *aeskey = drbg->priv_data;
-
-	kfree(aeskey);
-	drbg->priv_data = NULL;
-
-	if (drbg->ctr_handle)
-		crypto_free_skcipher(drbg->ctr_handle);
-	drbg->ctr_handle = NULL;
-
-	if (drbg->ctr_req)
-		skcipher_request_free(drbg->ctr_req);
-	drbg->ctr_req = NULL;
-
-	kfree(drbg->outscratchpadbuf);
-	drbg->outscratchpadbuf = NULL;
-
-	return 0;
-}
-
-static int drbg_init_sym_kernel(struct drbg_state *drbg)
-{
-	struct aes_enckey *aeskey;
-	struct crypto_skcipher *sk_tfm;
-	struct skcipher_request *req;
-	unsigned int alignmask;
-	char ctr_name[CRYPTO_MAX_ALG_NAME];
-
-	aeskey = kzalloc_obj(*aeskey);
-	if (!aeskey)
-		return -ENOMEM;
-	drbg->priv_data = aeskey;
-
-	if (snprintf(ctr_name, CRYPTO_MAX_ALG_NAME, "ctr(%s)",
-	    drbg->core->backend_cra_name) >= CRYPTO_MAX_ALG_NAME) {
-		drbg_fini_sym_kernel(drbg);
-		return -EINVAL;
-	}
-	sk_tfm = crypto_alloc_skcipher(ctr_name, 0, 0);
-	if (IS_ERR(sk_tfm)) {
-		pr_info("DRBG: could not allocate CTR cipher TFM handle: %s\n",
-				ctr_name);
-		drbg_fini_sym_kernel(drbg);
-		return PTR_ERR(sk_tfm);
-	}
-	drbg->ctr_handle = sk_tfm;
-	crypto_init_wait(&drbg->ctr_wait);
-
-	req = skcipher_request_alloc(sk_tfm, GFP_KERNEL);
-	if (!req) {
-		pr_info("DRBG: could not allocate request queue\n");
-		drbg_fini_sym_kernel(drbg);
-		return -ENOMEM;
-	}
-	drbg->ctr_req = req;
-	skcipher_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG |
-						CRYPTO_TFM_REQ_MAY_SLEEP,
-					crypto_req_done, &drbg->ctr_wait);
-
-	alignmask = crypto_skcipher_alignmask(sk_tfm);
-	drbg->outscratchpadbuf = kmalloc(DRBG_OUTSCRATCHLEN + alignmask,
-					 GFP_KERNEL);
-	if (!drbg->outscratchpadbuf) {
-		drbg_fini_sym_kernel(drbg);
-		return -ENOMEM;
-	}
-	drbg->outscratchpad = (u8 *)PTR_ALIGN(drbg->outscratchpadbuf,
-					      alignmask + 1);
-
-	sg_init_table(&drbg->sg_in, 1);
-	sg_init_one(&drbg->sg_out, drbg->outscratchpad, DRBG_OUTSCRATCHLEN);
-
-	return alignmask;
-}
-
-static int drbg_kcapi_sym_ctr(struct drbg_state *drbg,
-			      u8 *inbuf, u32 inlen,
-			      u8 *outbuf, u32 outlen)
-{
-	struct scatterlist *sg_in = &drbg->sg_in, *sg_out = &drbg->sg_out;
-	u32 scratchpad_use = min_t(u32, outlen, DRBG_OUTSCRATCHLEN);
-	int ret;
-
-	if (inbuf) {
-		/* Use caller-provided input buffer */
-		sg_set_buf(sg_in, inbuf, inlen);
-	} else {
-		/* Use scratchpad for in-place operation */
-		inlen = scratchpad_use;
-		memset(drbg->outscratchpad, 0, scratchpad_use);
-		sg_set_buf(sg_in, drbg->outscratchpad, scratchpad_use);
-	}
-
-	while (outlen) {
-		u32 cryptlen = min3(inlen, outlen, (u32)DRBG_OUTSCRATCHLEN);
-
-		/* Output buffer may not be valid for SGL, use scratchpad */
-		skcipher_request_set_crypt(drbg->ctr_req, sg_in, sg_out,
-					   cryptlen, drbg->V);
-		ret = crypto_wait_req(crypto_skcipher_encrypt(drbg->ctr_req),
-					&drbg->ctr_wait);
-		if (ret)
-			goto out;
-
-		crypto_init_wait(&drbg->ctr_wait);
-
-		memcpy(outbuf, drbg->outscratchpad, cryptlen);
-		memzero_explicit(drbg->outscratchpad, cryptlen);
-
-		outlen -= cryptlen;
-		outbuf += cryptlen;
-	}
-	ret = 0;
-
-out:
-	return ret;
-}
-#endif /* CONFIG_CRYPTO_DRBG_CTR */
-
 /***************************************************************
  * Kernel crypto API interface to register DRBG
  ***************************************************************/
 
 /*
@@ -1760,13 +1447,10 @@ static inline int __init drbg_healthcheck_sanity(void)
 
 	/* only perform test in FIPS mode */
 	if (!fips_enabled)
 		return 0;
 
-#ifdef CONFIG_CRYPTO_DRBG_CTR
-	drbg_convert_tfm_core("drbg_nopr_ctr_aes256", &coreref, &pr);
-#endif
 #ifdef CONFIG_CRYPTO_DRBG_HASH
 	drbg_convert_tfm_core("drbg_nopr_sha256", &coreref, &pr);
 #endif
 	drbg_convert_tfm_core("drbg_nopr_hmac_sha512", &coreref, &pr);
 
@@ -1894,16 +1578,12 @@ static void __exit drbg_exit(void)
 module_init(drbg_init);
 module_exit(drbg_exit);
 #ifndef CRYPTO_DRBG_HASH_STRING
 #define CRYPTO_DRBG_HASH_STRING ""
 #endif
-#ifndef CRYPTO_DRBG_CTR_STRING
-#define CRYPTO_DRBG_CTR_STRING ""
-#endif
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Stephan Mueller <smueller@chronox.de>");
 MODULE_DESCRIPTION("NIST SP800-90A Deterministic Random Bit Generator (DRBG) "
 		   "using following cores: "
 		   CRYPTO_DRBG_HASH_STRING
-		   CRYPTO_DRBG_HMAC_STRING
-		   CRYPTO_DRBG_CTR_STRING);
+		   CRYPTO_DRBG_HMAC_STRING);
 MODULE_ALIAS_CRYPTO("stdrng");
diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index 480368a41cc0..dbc1e1fb4bd0 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -4636,31 +4636,10 @@ static const struct alg_test_desc alg_test_descs[] = {
 			.kpp = __VECS(dh_tv_template)
 		}
 	}, {
 		.alg = "digest_null",
 		.test = alg_test_null,
-	}, {
-		.alg = "drbg_nopr_ctr_aes128",
-		.test = alg_test_drbg,
-		.fips_allowed = 1,
-		.suite = {
-			.drbg = __VECS(drbg_nopr_ctr_aes128_tv_template)
-		}
-	}, {
-		.alg = "drbg_nopr_ctr_aes192",
-		.test = alg_test_drbg,
-		.fips_allowed = 1,
-		.suite = {
-			.drbg = __VECS(drbg_nopr_ctr_aes192_tv_template)
-		}
-	}, {
-		.alg = "drbg_nopr_ctr_aes256",
-		.test = alg_test_drbg,
-		.fips_allowed = 1,
-		.suite = {
-			.drbg = __VECS(drbg_nopr_ctr_aes256_tv_template)
-		}
 	}, {
 		.alg = "drbg_nopr_hmac_sha256",
 		.test = alg_test_drbg,
 		.fips_allowed = 1,
 		.suite = {
@@ -4695,26 +4674,10 @@ static const struct alg_test_desc alg_test_descs[] = {
 		.fips_allowed = 1
 	}, {
 		.alg = "drbg_nopr_sha512",
 		.fips_allowed = 1,
 		.test = alg_test_null,
-	}, {
-		.alg = "drbg_pr_ctr_aes128",
-		.test = alg_test_drbg,
-		.fips_allowed = 1,
-		.suite = {
-			.drbg = __VECS(drbg_pr_ctr_aes128_tv_template)
-		}
-	}, {
-		/* covered by drbg_pr_ctr_aes128 test */
-		.alg = "drbg_pr_ctr_aes192",
-		.fips_allowed = 1,
-		.test = alg_test_null,
-	}, {
-		.alg = "drbg_pr_ctr_aes256",
-		.fips_allowed = 1,
-		.test = alg_test_null,
 	}, {
 		.alg = "drbg_pr_hmac_sha256",
 		.test = alg_test_drbg,
 		.fips_allowed = 1,
 		.suite = {
diff --git a/crypto/testmgr.h b/crypto/testmgr.h
index 9b4d7e11c9fd..a86275b61b6a 100644
--- a/crypto/testmgr.h
+++ b/crypto/testmgr.h
@@ -23744,126 +23744,10 @@ static const struct drbg_testvec drbg_pr_hmac_sha256_tv_template[] = {
 			"\xd1\x81\xe9\xf8\xeb\x30\x8f\x6f",
 		.perslen = 32,
 	},
 };
 
-static const struct drbg_testvec drbg_pr_ctr_aes128_tv_template[] = {
-	{
-		.entropy = (unsigned char *)
-			"\xd1\x44\xc6\x61\x81\x6d\xca\x9d\x15\x28\x8a\x42"
-			"\x94\xd7\x28\x9c\x43\x77\x19\x29\x1a\x6d\xc3\xa2",
-		.entropylen = 24,
-		.entpra = (unsigned char *)
-			"\x96\xd8\x9e\x45\x32\xc9\xd2\x08\x7a\x6d\x97\x15"
-			"\xb4\xec\x80\xb1",
-		.entprb = (unsigned char *)
-			"\x8b\xb6\x72\xb5\x24\x0b\x98\x65\x95\x95\xe9\xc9"
-			"\x28\x07\xeb\xc2",
-		.entprlen = 16,
-		.expected = (unsigned char *)
-			"\x70\x19\xd0\x4c\x45\x78\xd6\x68\xa9\x9a\xaa\xfe"
-			"\xc1\xdf\x27\x9a\x1c\x0d\x0d\xf7\x24\x75\x46\xcc"
-			"\x77\x6b\xdf\x89\xc6\x94\xdc\x74\x50\x10\x70\x18"
-			"\x9b\xdc\x96\xb4\x89\x23\x40\x1a\xce\x09\x87\xce"
-			"\xd2\xf3\xd5\xe4\x51\x67\x74\x11\x5a\xcc\x8b\x3b"
-			"\x8a\xf1\x23\xa8",
-		.expectedlen = 64,
-		.addtla = NULL,
-		.addtlb = NULL,
-		.addtllen = 0,
-		.pers = NULL,
-		.perslen = 0,
-	}, {
-		.entropy = (unsigned char *)
-			"\x8e\x83\xe0\xeb\x37\xea\x3e\x53\x5e\x17\x6e\x77"
-			"\xbd\xb1\x53\x90\xfc\xdc\xc1\x3c\x9a\x88\x22\x94",
-		.entropylen = 24,
-		.entpra = (unsigned char *)
-			"\x6a\x85\xe7\x37\xc8\xf1\x04\x31\x98\x4f\xc8\x73"
-			"\x67\xd1\x08\xf8",
-		.entprb = (unsigned char *)
-			"\xd7\xa4\x68\xe2\x12\x74\xc3\xd9\xf1\xb7\x05\xbc"
-			"\xd4\xba\x04\x58",
-		.entprlen = 16,
-		.expected = (unsigned char *)
-			"\x78\xd6\xa6\x70\xff\xd1\x82\xf5\xa2\x88\x7f\x6d"
-			"\x3d\x8c\x39\xb1\xa8\xcb\x2c\x91\xab\x14\x7e\xbc"
-			"\x95\x45\x9f\x24\xb8\x20\xac\x21\x23\xdb\x72\xd7"
-			"\x12\x8d\x48\x95\xf3\x19\x0c\x43\xc6\x19\x45\xfc"
-			"\x8b\xac\x40\x29\x73\x00\x03\x45\x5e\x12\xff\x0c"
-			"\xc1\x02\x41\x82",
-		.expectedlen = 64,
-		.addtla = (unsigned char *)
-			"\xa2\xd9\x38\xcf\x8b\x29\x67\x5b\x65\x62\x6f\xe8"
-			"\xeb\xb3\x01\x76",
-		.addtlb = (unsigned char *)
-			"\x59\x63\x1e\x81\x8a\x14\xa8\xbb\xa1\xb8\x41\x25"
-			"\xd0\x7f\xcc\x43",
-		.addtllen = 16,
-		.pers = NULL,
-		.perslen = 0,
-	}, {
-		.entropy = (unsigned char *)
-			"\x04\xd9\x49\xa6\xdc\xe8\x6e\xbb\xf1\x08\x77\x2b"
-			"\x9e\x08\xca\x92\x65\x16\xda\x99\xa2\x59\xf3\xe8",
-		.entropylen = 24,
-		.entpra = (unsigned char *)
-			"\x38\x7e\x3f\x6b\x51\x70\x7b\x20\xec\x53\xd0\x66"
-			"\xc3\x0f\xe3\xb0",
-		.entprb = (unsigned char *)
-			"\xe0\x86\xa6\xaa\x5f\x72\x2f\xad\xf7\xef\x06\xb8"
-			"\xd6\x9c\x9d\xe8",
-		.entprlen = 16,
-		.expected = (unsigned char *)
-			"\xc9\x0a\xaf\x85\x89\x71\x44\x66\x4f\x25\x0b\x2b"
-			"\xde\xd8\xfa\xff\x52\x5a\x1b\x32\x5e\x41\x7a\x10"
-			"\x1f\xef\x1e\x62\x23\xe9\x20\x30\xc9\x0d\xad\x69"
-			"\xb4\x9c\x5b\xf4\x87\x42\xd5\xae\x5e\x5e\x43\xcc"
-			"\xd9\xfd\x0b\x93\x4a\xe3\xd4\x06\x37\x36\x0f\x3f"
-			"\x72\x82\x0c\xcf",
-		.expectedlen = 64,
-		.addtla = NULL,
-		.addtlb = NULL,
-		.addtllen = 0,
-		.pers = (unsigned char *)
-			"\xbf\xa4\x9a\x8f\x7b\xd8\xb1\x7a\x9d\xfa\x45\xed"
-			"\x21\x52\xb3\xad",
-		.perslen = 16,
-	}, {
-		.entropy = (unsigned char *)
-			"\x92\x89\x8f\x31\xfa\x1c\xff\x6d\x18\x2f\x26\x06"
-			"\x43\xdf\xf8\x18\xc2\xa4\xd9\x72\xc3\xb9\xb6\x97",
-		.entropylen = 24,
-		.entpra = (unsigned char *)
-			"\x20\x72\x8a\x06\xf8\x6f\x8d\xd4\x41\xe2\x72\xb7"
-			"\xc4\x2c\xe8\x10",
-		.entprb = (unsigned char *)
-			"\x3d\xb0\xf0\x94\xf3\x05\x50\x33\x17\x86\x3e\x22"
-			"\x08\xf7\xa5\x01",
-		.entprlen = 16,
-		.expected = (unsigned char *)
-			"\x5a\x35\x39\x87\x0f\x4d\x22\xa4\x09\x24\xee\x71"
-			"\xc9\x6f\xac\x72\x0a\xd6\xf0\x88\x82\xd0\x83\x28"
-			"\x73\xec\x3f\x93\xd8\xab\x45\x23\xf0\x7e\xac\x45"
-			"\x14\x5e\x93\x9f\xb1\xd6\x76\x43\x3d\xb6\xe8\x08"
-			"\x88\xf6\xda\x89\x08\x77\x42\xfe\x1a\xf4\x3f\xc4"
-			"\x23\xc5\x1f\x68",
-		.expectedlen = 64,
-		.addtla = (unsigned char *)
-			"\x1a\x40\xfa\xe3\xcc\x6c\x7c\xa0\xf8\xda\xba\x59"
-			"\x23\x6d\xad\x1d",
-		.addtlb = (unsigned char *)
-			"\x9f\x72\x76\x6c\xc7\x46\xe5\xed\x2e\x53\x20\x12"
-			"\xbc\x59\x31\x8c",
-		.addtllen = 16,
-		.pers = (unsigned char *)
-			"\xea\x65\xee\x60\x26\x4e\x7e\xb6\x0e\x82\x68\xc4"
-			"\x37\x3c\x5c\x0b",
-		.perslen = 16,
-	},
-};
-
 /*
  * SP800-90A DRBG Test vectors from
  * http://csrc.nist.gov/groups/STM/cavp/documents/drbg/drbgtestvectors.zip
  *
  * Test vectors for DRBG without prediction resistance. All types of DRBGs
@@ -24161,146 +24045,10 @@ static const struct drbg_testvec drbg_nopr_hmac_sha512_tv_template[] = {
 		.pers = NULL,
 		.perslen = 0,
 	}
 };
 
-static const struct drbg_testvec drbg_nopr_ctr_aes192_tv_template[] = {
-	{
-		.entropy = (unsigned char *)
-			"\xc3\x5c\x2f\xa2\xa8\x9d\x52\xa1\x1f\xa3\x2a\xa9"
-			"\x6c\x95\xb8\xf1\xc9\xa8\xf9\xcb\x24\x5a\x8b\x40"
-			"\xf3\xa6\xe5\xa7\xfb\xd9\xd3\xc6\x8e\x27\x7b\xa9"
-			"\xac\x9b\xbb\x00",
-		.entropylen = 40,
-		.expected = (unsigned char *)
-			"\x8c\x2e\x72\xab\xfd\x9b\xb8\x28\x4d\xb7\x9e\x17"
-			"\xa4\x3a\x31\x46\xcd\x76\x94\xe3\x52\x49\xfc\x33"
-			"\x83\x91\x4a\x71\x17\xf4\x13\x68\xe6\xd4\xf1\x48"
-			"\xff\x49\xbf\x29\x07\x6b\x50\x15\xc5\x9f\x45\x79"
-			"\x45\x66\x2e\x3d\x35\x03\x84\x3f\x4a\xa5\xa3\xdf"
-			"\x9a\x9d\xf1\x0d",
-		.expectedlen = 64,
-		.addtla = NULL,
-		.addtlb = NULL,
-		.addtllen = 0,
-		.pers = NULL,
-		.perslen = 0,
-	},
-};
-
-static const struct drbg_testvec drbg_nopr_ctr_aes256_tv_template[] = {
-	{
-		.entropy = (unsigned char *)
-			"\x36\x40\x19\x40\xfa\x8b\x1f\xba\x91\xa1\x66\x1f"
-			"\x21\x1d\x78\xa0\xb9\x38\x9a\x74\xe5\xbc\xcf\xec"
-			"\xe8\xd7\x66\xaf\x1a\x6d\x3b\x14\x49\x6f\x25\xb0"
-			"\xf1\x30\x1b\x4f\x50\x1b\xe3\x03\x80\xa1\x37\xeb",
-		.entropylen = 48,
-		.expected = (unsigned char *)
-			"\x58\x62\xeb\x38\xbd\x55\x8d\xd9\x78\xa6\x96\xe6"
-			"\xdf\x16\x47\x82\xdd\xd8\x87\xe7\xe9\xa6\xc9\xf3"
-			"\xf1\xfb\xaf\xb7\x89\x41\xb5\x35\xa6\x49\x12\xdf"
-			"\xd2\x24\xc6\xdc\x74\x54\xe5\x25\x0b\x3d\x97\x16"
-			"\x5e\x16\x26\x0c\x2f\xaf\x1c\xc7\x73\x5c\xb7\x5f"
-			"\xb4\xf0\x7e\x1d",
-		.expectedlen = 64,
-		.addtla = NULL,
-		.addtlb = NULL,
-		.addtllen = 0,
-		.pers = NULL,
-		.perslen = 0,
-	},
-};
-
-static const struct drbg_testvec drbg_nopr_ctr_aes128_tv_template[] = {
-	{
-		.entropy = (unsigned char *)
-			"\x87\xe1\xc5\x32\x99\x7f\x57\xa3\x5c\x28\x6d\xe8"
-			"\x64\xbf\xf2\x64\xa3\x9e\x98\xdb\x6c\x10\x78\x7f",
-		.entropylen = 24,
-		.expected = (unsigned char *)
-			"\x2c\x14\x7e\x24\x11\x9a\xd8\xd4\xb2\xed\x61\xc1"
-			"\x53\xd0\x50\xc9\x24\xff\x59\x75\x15\xf1\x17\x3a"
-			"\x3d\xf4\x4b\x2c\x84\x28\xef\x89\x0e\xb9\xde\xf3"
-			"\xe4\x78\x04\xb2\xfd\x9b\x35\x7f\xe1\x3f\x8a\x3e"
-			"\x10\xc8\x67\x0a\xf9\xdf\x2d\x6c\x96\xfb\xb2\xb8"
-			"\xcb\x2d\xd6\xb0",
-		.expectedlen = 64,
-		.addtla = NULL,
-		.addtlb = NULL,
-		.addtllen = 0,
-		.pers = NULL,
-		.perslen = 0,
-	}, {
-		.entropy = (unsigned char *)
-			"\x71\xbd\xce\x35\x42\x7d\x20\xbf\x58\xcf\x17\x74"
-			"\xce\x72\xd8\x33\x34\x50\x2d\x8f\x5b\x14\xc4\xdd",
-		.entropylen = 24,
-		.expected = (unsigned char *)
-			"\x97\x33\xe8\x20\x12\xe2\x7b\xa1\x46\x8f\xf2\x34"
-			"\xb3\xc9\xb6\x6b\x20\xb2\x4f\xee\x27\xd8\x0b\x21"
-			"\x8c\xff\x63\x73\x69\x29\xfb\xf3\x85\xcd\x88\x8e"
-			"\x43\x2c\x71\x8b\xa2\x55\xd2\x0f\x1d\x7f\xe3\xe1"
-			"\x2a\xa3\xe9\x2c\x25\x89\xc7\x14\x52\x99\x56\xcc"
-			"\xc3\xdf\xb3\x81",
-		.expectedlen = 64,
-		.addtla = (unsigned char *)
-			"\x66\xef\x42\xd6\x9a\x8c\x3d\x6d\x4a\x9e\x95\xa6"
-			"\x91\x4d\x81\x56",
-		.addtlb = (unsigned char *)
-			"\xe3\x18\x83\xd9\x4b\x5e\xc4\xcc\xaa\x61\x2f\xbb"
-			"\x4a\x55\xd1\xc6",
-		.addtllen = 16,
-		.pers = NULL,
-		.perslen = 0,
-	}, {
-		.entropy = (unsigned char *)
-			"\xca\x4b\x1e\xfa\x75\xbd\x69\x36\x38\x73\xb8\xf9"
-			"\xdb\x4d\x35\x0e\x47\xbf\x6c\x37\x72\xfd\xf7\xa9",
-		.entropylen = 24,
-		.expected = (unsigned char *)
-			"\x59\xc3\x19\x79\x1b\xb1\xf3\x0e\xe9\x34\xae\x6e"
-			"\x8b\x1f\xad\x1f\x74\xca\x25\x45\x68\xb8\x7f\x75"
-			"\x12\xf8\xf2\xab\x4c\x23\x01\x03\x05\xe1\x70\xee"
-			"\x75\xd8\xcb\xeb\x23\x4c\x7a\x23\x6e\x12\x27\xdb"
-			"\x6f\x7a\xac\x3c\x44\xb7\x87\x4b\x65\x56\x74\x45"
-			"\x34\x30\x0c\x3d",
-		.expectedlen = 64,
-		.addtla = NULL,
-		.addtlb = NULL,
-		.addtllen = 0,
-		.pers = (unsigned char *)
-			"\xeb\xaa\x60\x2c\x4d\xbe\x33\xff\x1b\xef\xbf\x0a"
-			"\x0b\xc6\x97\x54",
-		.perslen = 16,
-	}, {
-		.entropy = (unsigned char *)
-			"\xc0\x70\x1f\x92\x50\x75\x8f\xcd\xf2\xbe\x73\x98"
-			"\x80\xdb\x66\xeb\x14\x68\xb4\xa5\x87\x9c\x2d\xa6",
-		.entropylen = 24,
-		.expected = (unsigned char *)
-			"\x97\xc0\xc0\xe5\xa0\xcc\xf2\x4f\x33\x63\x48\x8a"
-			"\xdb\x13\x0a\x35\x89\xbf\x80\x65\x62\xee\x13\x95"
-			"\x7c\x33\xd3\x7d\xf4\x07\x77\x7a\x2b\x65\x0b\x5f"
-			"\x45\x5c\x13\xf1\x90\x77\x7f\xc5\x04\x3f\xcc\x1a"
-			"\x38\xf8\xcd\x1b\xbb\xd5\x57\xd1\x4a\x4c\x2e\x8a"
-			"\x2b\x49\x1e\x5c",
-		.expectedlen = 64,
-		.addtla = (unsigned char *)
-			"\xf9\x01\xf8\x16\x7a\x1d\xff\xde\x8e\x3c\x83\xe2"
-			"\x44\x85\xe7\xfe",
-		.addtlb = (unsigned char *)
-			"\x17\x1c\x09\x38\xc2\x38\x9f\x97\x87\x60\x55\xb4"
-			"\x82\x16\x62\x7f",
-		.addtllen = 16,
-		.pers = (unsigned char *)
-			"\x80\x08\xae\xe8\xe9\x69\x40\xc5\x08\x73\xc7\x9f"
-			"\x8e\xcf\xe0\x02",
-		.perslen = 16,
-	},
-};
-
 /* Cast5 test vectors from RFC 2144 */
 static const struct cipher_testvec cast5_tv_template[] = {
 	{
 		.key	= "\x01\x23\x45\x67\x12\x34\x56\x78"
 			  "\x23\x45\x67\x89\x34\x56\x78\x9a",
diff --git a/include/crypto/internal/drbg.h b/include/crypto/internal/drbg.h
index b4e5ef0be602..5d4174cc6a53 100644
--- a/include/crypto/internal/drbg.h
+++ b/include/crypto/internal/drbg.h
@@ -7,10 +7,13 @@
  */
 
 #ifndef _INTERNAL_DRBG_H
 #define _INTERNAL_DRBG_H
 
+#include <linux/list.h>
+#include <linux/types.h>
+
 /*
  * Concatenation Helper and string operation helper
  *
  * SP800-90A requires the concatenation of different data. To avoid copying
  * buffers around or allocate additional memory, the following data structure
-- 
2.53.0

