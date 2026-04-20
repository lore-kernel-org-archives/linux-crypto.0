Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DE3D38553E;
	Mon, 20 Apr 2026 06:37:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776667023; cv=none; b=KvgxJISIRJv/NrMoP0Zm3gxP3uoIBprsyPnIakXw7vGPdu63/kxHCwYn8wi4orgIsSQ6nLH+YT9/3G3lh3F0eMoHxIlrbe8Xa6ASa1pjWsBZSbDoEfsaWqEQ6wxjZuRtRWa30PUUYt29ru/ZAOxAJhd3vRAjsZajhvGxMLDG0bA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776667023; c=relaxed/simple;
	bh=rJwhXf+263Z442Q3saCLefuT7LruOUvLOPQMHMvIlCk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uPVD4tEAtpgk0Qt8THB3SP0UpuyUwVXg1k+iJuat+Ot3vHtZlFz0ZYc4a6OZG8/waHQnahmj/UmQAiShXJ2KBmi500c5Waou3lNIInzDXTh70t81pLUGxM3ReSoQJBXu9wF1n3UPaBLyUyZgO8ZHNftwD7/qv56RXg84zciLomk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XPoPwwwH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XPoPwwwH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5835CC2BCB9;
	Mon, 20 Apr 2026 06:37:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776667023;
	bh=rJwhXf+263Z442Q3saCLefuT7LruOUvLOPQMHMvIlCk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XPoPwwwHBxep5D+O9xmTigjDHY34Df1/hVRMwhjnkZQDTyKqGFh1tRp/sd1jOT1xu
	 V2pUiMCTxp4mGepojT/XC+aZsbBEYrnW7Q0pL8h3R3xeeKtr6x/f/lUNW3tPaQH9rK
	 WMbBb0FZS7F/lAEvZ9l06ynBYTIZqlEOYmoDodUGTDiZnvO6DZKxXZc/SEc6X0euuR
	 fpbG0WIrfB/3AIQLhgDYv7SXS1uyjNiaUzUvpMdo0DIyEaF9XBxKTQXEdGpFZmKYCv
	 lNawscXs/f/rLb87vdZceFlGL9rQdLLS1UfFoBNFGE3uXTPw+vc4iFVtv1UqZflqLm
	 +ybhVcFX015qw==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-kernel@vger.kernel.org,
	Stephan Mueller <smueller@chronox.de>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 13/38] crypto: drbg - Remove support for HASH_DRBG
Date: Sun, 19 Apr 2026 23:33:57 -0700
Message-ID: <20260420063422.324906-14-ebiggers@kernel.org>
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

Remove the support for HASH_DRBG.  It's likely unused code, seeing as
HMAC_DRBG is always enabled and prioritized over it unless
NETLINK_CRYPTO is used to change the algorithm priorities.

There's also no compelling reason to support more than one of
[HMAC_DRBG, HASH_DRBG, CTR_DRBG].  By definition, callers cannot tell
any difference in their outputs.  And all are FIPS-certifiable, which is
the only point of the kernel's NIST DRBGs anyway.

Switching to HASH_DRBG doesn't seem all that compelling, either.  For
one, it's more complex than HMAC_DRBG.

Thus, let's just drop HASH_DRBG support and focus on HMAC_DRBG.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 Documentation/crypto/api-samples.rst       |   2 +-
 Documentation/crypto/userspace-if.rst      |   2 +-
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
 crypto/drbg.c                              | 348 +--------------------
 crypto/testmgr.c                           |  32 --
 crypto/testmgr.h                           | 296 ------------------
 21 files changed, 8 insertions(+), 695 deletions(-)

diff --git a/Documentation/crypto/api-samples.rst b/Documentation/crypto/api-samples.rst
index e923f17bc2bd..388bb7d7a460 100644
--- a/Documentation/crypto/api-samples.rst
+++ b/Documentation/crypto/api-samples.rst
@@ -157,11 +157,11 @@ Code Example For Random Number Generator Usage
 
 
     static int get_random_numbers(u8 *buf, unsigned int len)
     {
         struct crypto_rng *rng = NULL;
-        char *drbg = "drbg_nopr_sha256"; /* Hash DRBG with SHA-256, no PR */
+        char *drbg = "stdrng";
         int ret;
 
         if (!buf || !len) {
             pr_debug("No output buffer provided\n");
             return -EINVAL;
diff --git a/Documentation/crypto/userspace-if.rst b/Documentation/crypto/userspace-if.rst
index 021759198fe7..a3b13ff83cb3 100644
--- a/Documentation/crypto/userspace-if.rst
+++ b/Documentation/crypto/userspace-if.rst
@@ -295,11 +295,11 @@ follows:
 ::
 
     struct sockaddr_alg sa = {
         .salg_family = AF_ALG,
         .salg_type = "rng", /* this selects the random number generator */
-        .salg_name = "drbg_nopr_sha256" /* this is the RNG name */
+        .salg_name = "stdrng" /* this is the RNG name */
     };
 
 
 Depending on the RNG type, the RNG must be seeded. The seed is provided
 using the setsockopt interface to set the key. The SP800-90A DRBGs do
diff --git a/arch/m68k/configs/amiga_defconfig b/arch/m68k/configs/amiga_defconfig
index a8ca9023caf3..a886494c5a30 100644
--- a/arch/m68k/configs/amiga_defconfig
+++ b/arch/m68k/configs/amiga_defconfig
@@ -548,11 +548,10 @@ CONFIG_CRYPTO_XCBC=m
 CONFIG_CRYPTO_LZO=m
 CONFIG_CRYPTO_842=m
 CONFIG_CRYPTO_LZ4=m
 CONFIG_CRYPTO_LZ4HC=m
 CONFIG_CRYPTO_ZSTD=m
-CONFIG_CRYPTO_DRBG_HASH=y
 CONFIG_CRYPTO_USER_API_HASH=m
 CONFIG_CRYPTO_USER_API_SKCIPHER=m
 CONFIG_CRYPTO_USER_API_RNG=m
 CONFIG_CRYPTO_USER_API_AEAD=m
 # CONFIG_CRYPTO_HW is not set
diff --git a/arch/m68k/configs/apollo_defconfig b/arch/m68k/configs/apollo_defconfig
index 5c6610d9e80a..14c6298b1175 100644
--- a/arch/m68k/configs/apollo_defconfig
+++ b/arch/m68k/configs/apollo_defconfig
@@ -503,11 +503,10 @@ CONFIG_CRYPTO_XCBC=m
 CONFIG_CRYPTO_LZO=m
 CONFIG_CRYPTO_842=m
 CONFIG_CRYPTO_LZ4=m
 CONFIG_CRYPTO_LZ4HC=m
 CONFIG_CRYPTO_ZSTD=m
-CONFIG_CRYPTO_DRBG_HASH=y
 CONFIG_CRYPTO_USER_API_HASH=m
 CONFIG_CRYPTO_USER_API_SKCIPHER=m
 CONFIG_CRYPTO_USER_API_RNG=m
 CONFIG_CRYPTO_USER_API_AEAD=m
 # CONFIG_CRYPTO_HW is not set
diff --git a/arch/m68k/configs/atari_defconfig b/arch/m68k/configs/atari_defconfig
index 4d080f6f3ddf..86a5c69b3655 100644
--- a/arch/m68k/configs/atari_defconfig
+++ b/arch/m68k/configs/atari_defconfig
@@ -525,11 +525,10 @@ CONFIG_CRYPTO_XCBC=m
 CONFIG_CRYPTO_LZO=m
 CONFIG_CRYPTO_842=m
 CONFIG_CRYPTO_LZ4=m
 CONFIG_CRYPTO_LZ4HC=m
 CONFIG_CRYPTO_ZSTD=m
-CONFIG_CRYPTO_DRBG_HASH=y
 CONFIG_CRYPTO_USER_API_HASH=m
 CONFIG_CRYPTO_USER_API_SKCIPHER=m
 CONFIG_CRYPTO_USER_API_RNG=m
 CONFIG_CRYPTO_USER_API_AEAD=m
 # CONFIG_CRYPTO_HW is not set
diff --git a/arch/m68k/configs/bvme6000_defconfig b/arch/m68k/configs/bvme6000_defconfig
index c61fc9d13d30..b3828dc6ee25 100644
--- a/arch/m68k/configs/bvme6000_defconfig
+++ b/arch/m68k/configs/bvme6000_defconfig
@@ -495,11 +495,10 @@ CONFIG_CRYPTO_XCBC=m
 CONFIG_CRYPTO_LZO=m
 CONFIG_CRYPTO_842=m
 CONFIG_CRYPTO_LZ4=m
 CONFIG_CRYPTO_LZ4HC=m
 CONFIG_CRYPTO_ZSTD=m
-CONFIG_CRYPTO_DRBG_HASH=y
 CONFIG_CRYPTO_USER_API_HASH=m
 CONFIG_CRYPTO_USER_API_SKCIPHER=m
 CONFIG_CRYPTO_USER_API_RNG=m
 CONFIG_CRYPTO_USER_API_AEAD=m
 # CONFIG_CRYPTO_HW is not set
diff --git a/arch/m68k/configs/hp300_defconfig b/arch/m68k/configs/hp300_defconfig
index 2bc20cfdfcf6..6b890c6bcf35 100644
--- a/arch/m68k/configs/hp300_defconfig
+++ b/arch/m68k/configs/hp300_defconfig
@@ -505,11 +505,10 @@ CONFIG_CRYPTO_XCBC=m
 CONFIG_CRYPTO_LZO=m
 CONFIG_CRYPTO_842=m
 CONFIG_CRYPTO_LZ4=m
 CONFIG_CRYPTO_LZ4HC=m
 CONFIG_CRYPTO_ZSTD=m
-CONFIG_CRYPTO_DRBG_HASH=y
 CONFIG_CRYPTO_USER_API_HASH=m
 CONFIG_CRYPTO_USER_API_SKCIPHER=m
 CONFIG_CRYPTO_USER_API_RNG=m
 CONFIG_CRYPTO_USER_API_AEAD=m
 # CONFIG_CRYPTO_HW is not set
diff --git a/arch/m68k/configs/mac_defconfig b/arch/m68k/configs/mac_defconfig
index e03877efc7e6..1a7694486c08 100644
--- a/arch/m68k/configs/mac_defconfig
+++ b/arch/m68k/configs/mac_defconfig
@@ -524,11 +524,10 @@ CONFIG_CRYPTO_XCBC=m
 CONFIG_CRYPTO_LZO=m
 CONFIG_CRYPTO_842=m
 CONFIG_CRYPTO_LZ4=m
 CONFIG_CRYPTO_LZ4HC=m
 CONFIG_CRYPTO_ZSTD=m
-CONFIG_CRYPTO_DRBG_HASH=y
 CONFIG_CRYPTO_USER_API_HASH=m
 CONFIG_CRYPTO_USER_API_SKCIPHER=m
 CONFIG_CRYPTO_USER_API_RNG=m
 CONFIG_CRYPTO_USER_API_AEAD=m
 # CONFIG_CRYPTO_HW is not set
diff --git a/arch/m68k/configs/multi_defconfig b/arch/m68k/configs/multi_defconfig
index d613bfedee8a..468f0dab58ad 100644
--- a/arch/m68k/configs/multi_defconfig
+++ b/arch/m68k/configs/multi_defconfig
@@ -611,11 +611,10 @@ CONFIG_CRYPTO_XCBC=m
 CONFIG_CRYPTO_LZO=m
 CONFIG_CRYPTO_842=m
 CONFIG_CRYPTO_LZ4=m
 CONFIG_CRYPTO_LZ4HC=m
 CONFIG_CRYPTO_ZSTD=m
-CONFIG_CRYPTO_DRBG_HASH=y
 CONFIG_CRYPTO_USER_API_HASH=m
 CONFIG_CRYPTO_USER_API_SKCIPHER=m
 CONFIG_CRYPTO_USER_API_RNG=m
 CONFIG_CRYPTO_USER_API_AEAD=m
 # CONFIG_CRYPTO_HW is not set
diff --git a/arch/m68k/configs/mvme147_defconfig b/arch/m68k/configs/mvme147_defconfig
index fe343a8f69f5..ef6e94e5abcd 100644
--- a/arch/m68k/configs/mvme147_defconfig
+++ b/arch/m68k/configs/mvme147_defconfig
@@ -495,11 +495,10 @@ CONFIG_CRYPTO_XCBC=m
 CONFIG_CRYPTO_LZO=m
 CONFIG_CRYPTO_842=m
 CONFIG_CRYPTO_LZ4=m
 CONFIG_CRYPTO_LZ4HC=m
 CONFIG_CRYPTO_ZSTD=m
-CONFIG_CRYPTO_DRBG_HASH=y
 CONFIG_CRYPTO_USER_API_HASH=m
 CONFIG_CRYPTO_USER_API_SKCIPHER=m
 CONFIG_CRYPTO_USER_API_RNG=m
 CONFIG_CRYPTO_USER_API_AEAD=m
 # CONFIG_CRYPTO_HW is not set
diff --git a/arch/m68k/configs/mvme16x_defconfig b/arch/m68k/configs/mvme16x_defconfig
index c5803f67f30b..cdb8cb030c33 100644
--- a/arch/m68k/configs/mvme16x_defconfig
+++ b/arch/m68k/configs/mvme16x_defconfig
@@ -496,11 +496,10 @@ CONFIG_CRYPTO_XCBC=m
 CONFIG_CRYPTO_LZO=m
 CONFIG_CRYPTO_842=m
 CONFIG_CRYPTO_LZ4=m
 CONFIG_CRYPTO_LZ4HC=m
 CONFIG_CRYPTO_ZSTD=m
-CONFIG_CRYPTO_DRBG_HASH=y
 CONFIG_CRYPTO_USER_API_HASH=m
 CONFIG_CRYPTO_USER_API_SKCIPHER=m
 CONFIG_CRYPTO_USER_API_RNG=m
 CONFIG_CRYPTO_USER_API_AEAD=m
 # CONFIG_CRYPTO_HW is not set
diff --git a/arch/m68k/configs/q40_defconfig b/arch/m68k/configs/q40_defconfig
index 619518c30e0b..a6af67707e9e 100644
--- a/arch/m68k/configs/q40_defconfig
+++ b/arch/m68k/configs/q40_defconfig
@@ -514,11 +514,10 @@ CONFIG_CRYPTO_XCBC=m
 CONFIG_CRYPTO_LZO=m
 CONFIG_CRYPTO_842=m
 CONFIG_CRYPTO_LZ4=m
 CONFIG_CRYPTO_LZ4HC=m
 CONFIG_CRYPTO_ZSTD=m
-CONFIG_CRYPTO_DRBG_HASH=y
 CONFIG_CRYPTO_USER_API_HASH=m
 CONFIG_CRYPTO_USER_API_SKCIPHER=m
 CONFIG_CRYPTO_USER_API_RNG=m
 CONFIG_CRYPTO_USER_API_AEAD=m
 # CONFIG_CRYPTO_HW is not set
diff --git a/arch/m68k/configs/sun3_defconfig b/arch/m68k/configs/sun3_defconfig
index 530fa722e3b2..1d8233ebb454 100644
--- a/arch/m68k/configs/sun3_defconfig
+++ b/arch/m68k/configs/sun3_defconfig
@@ -493,11 +493,10 @@ CONFIG_CRYPTO_XCBC=m
 CONFIG_CRYPTO_LZO=m
 CONFIG_CRYPTO_842=m
 CONFIG_CRYPTO_LZ4=m
 CONFIG_CRYPTO_LZ4HC=m
 CONFIG_CRYPTO_ZSTD=m
-CONFIG_CRYPTO_DRBG_HASH=y
 CONFIG_CRYPTO_USER_API_HASH=m
 CONFIG_CRYPTO_USER_API_SKCIPHER=m
 CONFIG_CRYPTO_USER_API_RNG=m
 CONFIG_CRYPTO_USER_API_AEAD=m
 # CONFIG_CRYPTO_HW is not set
diff --git a/arch/m68k/configs/sun3x_defconfig b/arch/m68k/configs/sun3x_defconfig
index f282e05bc8f9..8366a1d850b0 100644
--- a/arch/m68k/configs/sun3x_defconfig
+++ b/arch/m68k/configs/sun3x_defconfig
@@ -493,11 +493,10 @@ CONFIG_CRYPTO_XCBC=m
 CONFIG_CRYPTO_LZO=m
 CONFIG_CRYPTO_842=m
 CONFIG_CRYPTO_LZ4=m
 CONFIG_CRYPTO_LZ4HC=m
 CONFIG_CRYPTO_ZSTD=m
-CONFIG_CRYPTO_DRBG_HASH=y
 CONFIG_CRYPTO_USER_API_HASH=m
 CONFIG_CRYPTO_USER_API_SKCIPHER=m
 CONFIG_CRYPTO_USER_API_RNG=m
 CONFIG_CRYPTO_USER_API_AEAD=m
 # CONFIG_CRYPTO_HW is not set
diff --git a/arch/mips/configs/decstation_64_defconfig b/arch/mips/configs/decstation_64_defconfig
index 6712143a2842..509515cf4751 100644
--- a/arch/mips/configs/decstation_64_defconfig
+++ b/arch/mips/configs/decstation_64_defconfig
@@ -197,9 +197,8 @@ CONFIG_CRYPTO_TEA=m
 CONFIG_CRYPTO_TWOFISH=m
 CONFIG_CRYPTO_LZO=m
 CONFIG_CRYPTO_842=m
 CONFIG_CRYPTO_LZ4=m
 CONFIG_CRYPTO_LZ4HC=m
-CONFIG_CRYPTO_DRBG_HASH=y
 # CONFIG_CRYPTO_HW is not set
 CONFIG_MAGIC_SYSRQ=y
 # CONFIG_FTRACE is not set
diff --git a/arch/mips/configs/decstation_defconfig b/arch/mips/configs/decstation_defconfig
index 1a31bbb99839..3a17c080292f 100644
--- a/arch/mips/configs/decstation_defconfig
+++ b/arch/mips/configs/decstation_defconfig
@@ -192,10 +192,9 @@ CONFIG_CRYPTO_TEA=m
 CONFIG_CRYPTO_TWOFISH=m
 CONFIG_CRYPTO_LZO=m
 CONFIG_CRYPTO_842=m
 CONFIG_CRYPTO_LZ4=m
 CONFIG_CRYPTO_LZ4HC=m
-CONFIG_CRYPTO_DRBG_HASH=y
 # CONFIG_CRYPTO_HW is not set
 CONFIG_FRAME_WARN=2048
 CONFIG_MAGIC_SYSRQ=y
 # CONFIG_FTRACE is not set
diff --git a/arch/mips/configs/decstation_r4k_defconfig b/arch/mips/configs/decstation_r4k_defconfig
index 8ff71ca43bfb..7f5823663702 100644
--- a/arch/mips/configs/decstation_r4k_defconfig
+++ b/arch/mips/configs/decstation_r4k_defconfig
@@ -192,10 +192,9 @@ CONFIG_CRYPTO_TEA=m
 CONFIG_CRYPTO_TWOFISH=m
 CONFIG_CRYPTO_LZO=m
 CONFIG_CRYPTO_842=m
 CONFIG_CRYPTO_LZ4=m
 CONFIG_CRYPTO_LZ4HC=m
-CONFIG_CRYPTO_DRBG_HASH=y
 # CONFIG_CRYPTO_HW is not set
 CONFIG_FRAME_WARN=2048
 CONFIG_MAGIC_SYSRQ=y
 # CONFIG_FTRACE is not set
diff --git a/crypto/Kconfig b/crypto/Kconfig
index b16a1aa95c46..14519474a67b 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -1120,18 +1120,10 @@ menuconfig CRYPTO_DRBG_MENU
 
 	  In the following submenu, one or more of the DRBG types must be selected.
 
 if CRYPTO_DRBG_MENU
 
-config CRYPTO_DRBG_HASH
-	bool "Hash_DRBG"
-	select CRYPTO_SHA256
-	help
-	  Hash_DRBG variant as defined in NIST SP800-90A.
-
-	  This uses the SHA-1, SHA-256, SHA-384, or SHA-512 hash algorithms.
-
 config CRYPTO_DRBG
 	tristate
 	default CRYPTO_DRBG_MENU
 	select CRYPTO_HMAC
 	select CRYPTO_JITTERENTROPY
diff --git a/crypto/drbg.c b/crypto/drbg.c
index b29090bb59bc..6301eb2e304c 100644
--- a/crypto/drbg.c
+++ b/crypto/drbg.c
@@ -1,10 +1,9 @@
 /*
  * DRBG: Deterministic Random Bits Generator
  *       Based on NIST Recommended DRBG from NIST SP800-90A with the following
  *       properties:
- *		* Hash DRBG with DF with SHA-1, SHA-256, SHA-384, SHA-512 cores
  *		* HMAC DRBG with DF with SHA-1, SHA-256, SHA-384, SHA-512 cores
  *		* with and without prediction resistance
  *
  * Copyright Stephan Mueller <smueller@chronox.de>, 2014
  *
@@ -131,21 +130,17 @@ enum drbg_seed_state {
 	DRBG_SEED_STATE_FULL,
 };
 
 struct drbg_state {
 	struct mutex drbg_mutex;	/* lock around DRBG */
-	unsigned char *V;	/* internal state 10.1.1.1 1a) */
+	unsigned char *V;	/* internal state -- 10.1.2.1 1a */
 	unsigned char *Vbuf;
-	/* hash: static value 10.1.1.1 1b) hmac: key */
-	unsigned char *C;
+	unsigned char *C;	/* current key -- 10.1.2.1 1b */
 	unsigned char *Cbuf;
-	/* Number of RNG requests since last reseed -- 10.1.1.1 1c) */
+	/* Number of RNG requests since last reseed -- 10.1.2.1 1c */
 	size_t reseed_ctr;
 	size_t reseed_threshold;
-	 /* some memory the DRBG can use for its operation */
-	unsigned char *scratchpad;
-	unsigned char *scratchpadbuf;
 	void *priv_data;	/* Cipher handle */
 
 	enum drbg_seed_state seeded;		/* DRBG fully seeded? */
 	unsigned long last_seed_time;
 	bool pr;		/* Prediction resistance enabled? */
@@ -192,24 +187,21 @@ static inline size_t drbg_max_requests(struct drbg_state *drbg)
 	return (1<<20);
 }
 
 /* DRBG type flags */
 #define DRBG_HMAC	((drbg_flag_t)1<<1)
-#define DRBG_HASH	((drbg_flag_t)1<<2)
-#define DRBG_TYPE_MASK	(DRBG_HMAC | DRBG_HASH)
+#define DRBG_TYPE_MASK	DRBG_HMAC
 /* DRBG strength flags */
 #define DRBG_STRENGTH128	((drbg_flag_t)1<<3)
 #define DRBG_STRENGTH192	((drbg_flag_t)1<<4)
 #define DRBG_STRENGTH256	((drbg_flag_t)1<<5)
 #define DRBG_STRENGTH_MASK	(DRBG_STRENGTH128 | DRBG_STRENGTH192 | \
 				 DRBG_STRENGTH256)
 
 enum drbg_prefixes {
 	DRBG_PREFIX0 = 0x00,
 	DRBG_PREFIX1,
-	DRBG_PREFIX2,
-	DRBG_PREFIX3
 };
 
 /***************************************************************
  * Backend cipher definitions available to DRBG
  ***************************************************************/
@@ -220,31 +212,10 @@ enum drbg_prefixes {
  * they are defined in this array (see drbg_fill_array).
  *
  * Thus, the favored DRBGs are the latest entries in this array.
  */
 static const struct drbg_core drbg_cores[] = {
-#ifdef CONFIG_CRYPTO_DRBG_HASH
-	{
-		.flags = DRBG_HASH | DRBG_STRENGTH256,
-		.statelen = 111, /* 888 bits */
-		.blocklen_bytes = 48,
-		.cra_name = "sha384",
-		.backend_cra_name = "sha384",
-	}, {
-		.flags = DRBG_HASH | DRBG_STRENGTH256,
-		.statelen = 111, /* 888 bits */
-		.blocklen_bytes = 64,
-		.cra_name = "sha512",
-		.backend_cra_name = "sha512",
-	}, {
-		.flags = DRBG_HASH | DRBG_STRENGTH256,
-		.statelen = 55, /* 440 bits */
-		.blocklen_bytes = 32,
-		.cra_name = "sha256",
-		.backend_cra_name = "sha256",
-	},
-#endif /* CONFIG_CRYPTO_DRBG_HASH */
 	{
 		.flags = DRBG_HMAC | DRBG_STRENGTH256,
 		.statelen = 48, /* block length of cipher */
 		.blocklen_bytes = 48,
 		.cra_name = "hmac_sha384",
@@ -301,11 +272,10 @@ static int drbg_kcapi_hash(struct drbg_state *drbg, unsigned char *outval,
 static void drbg_kcapi_hmacsetkey(struct drbg_state *drbg,
 				  const unsigned char *key);
 static int drbg_init_hash_kernel(struct drbg_state *drbg);
 static int drbg_fini_hash_kernel(struct drbg_state *drbg);
 
-#define CRYPTO_DRBG_HMAC_STRING "HMAC "
 MODULE_ALIAS_CRYPTO("drbg_pr_hmac_sha512");
 MODULE_ALIAS_CRYPTO("drbg_nopr_hmac_sha512");
 MODULE_ALIAS_CRYPTO("drbg_pr_hmac_sha384");
 MODULE_ALIAS_CRYPTO("drbg_nopr_hmac_sha384");
 MODULE_ALIAS_CRYPTO("drbg_pr_hmac_sha256");
@@ -413,284 +383,10 @@ static const struct drbg_state_ops drbg_hmac_ops = {
 	.generate	= drbg_hmac_generate,
 	.crypto_init	= drbg_init_hash_kernel,
 	.crypto_fini	= drbg_fini_hash_kernel,
 };
 
-/******************************************************************
- * Hash DRBG callback functions
- ******************************************************************/
-
-#ifdef CONFIG_CRYPTO_DRBG_HASH
-#define CRYPTO_DRBG_HASH_STRING "HASH "
-MODULE_ALIAS_CRYPTO("drbg_pr_sha512");
-MODULE_ALIAS_CRYPTO("drbg_nopr_sha512");
-MODULE_ALIAS_CRYPTO("drbg_pr_sha384");
-MODULE_ALIAS_CRYPTO("drbg_nopr_sha384");
-MODULE_ALIAS_CRYPTO("drbg_pr_sha256");
-MODULE_ALIAS_CRYPTO("drbg_nopr_sha256");
-
-/*
- * Increment buffer
- *
- * @dst buffer to increment
- * @add value to add
- */
-static inline void drbg_add_buf(unsigned char *dst, size_t dstlen,
-				const unsigned char *add, size_t addlen)
-{
-	/* implied: dstlen > addlen */
-	unsigned char *dstptr;
-	const unsigned char *addptr;
-	unsigned int remainder = 0;
-	size_t len = addlen;
-
-	dstptr = dst + (dstlen-1);
-	addptr = add + (addlen-1);
-	while (len) {
-		remainder += *dstptr + *addptr;
-		*dstptr = remainder & 0xff;
-		remainder >>= 8;
-		len--; dstptr--; addptr--;
-	}
-	len = dstlen - addlen;
-	while (len && remainder > 0) {
-		remainder = *dstptr + 1;
-		*dstptr = remainder & 0xff;
-		remainder >>= 8;
-		len--; dstptr--;
-	}
-}
-
-/*
- * scratchpad usage: as drbg_hash_update and drbg_hash_df are used
- * interlinked, the scratchpad is used as follows:
- * drbg_hash_update
- *	start: drbg->scratchpad
- *	length: drbg_statelen(drbg)
- * drbg_hash_df:
- *	start: drbg->scratchpad + drbg_statelen(drbg)
- *	length: drbg_blocklen(drbg)
- *
- * drbg_hash_process_addtl uses the scratchpad, but fully completes
- * before either of the functions mentioned before are invoked. Therefore,
- * drbg_hash_process_addtl does not need to be specifically considered.
- */
-
-/* Derivation Function for Hash DRBG as defined in 10.4.1 */
-static int drbg_hash_df(struct drbg_state *drbg,
-			unsigned char *outval, size_t outlen,
-			struct list_head *entropylist)
-{
-	int ret = 0;
-	size_t len = 0;
-	unsigned char input[5];
-	unsigned char *tmp = drbg->scratchpad + drbg_statelen(drbg);
-	struct drbg_string data;
-
-	/* 10.4.1 step 3 */
-	input[0] = 1;
-	put_unaligned_be32(outlen * 8, &input[1]);
-
-	/* 10.4.1 step 4.1 -- concatenation of data for input into hash */
-	drbg_string_fill(&data, input, 5);
-	list_add(&data.list, entropylist);
-
-	/* 10.4.1 step 4 */
-	while (len < outlen) {
-		short blocklen = 0;
-		/* 10.4.1 step 4.1 */
-		ret = drbg_kcapi_hash(drbg, tmp, entropylist);
-		if (ret)
-			goto out;
-		/* 10.4.1 step 4.2 */
-		input[0]++;
-		blocklen = (drbg_blocklen(drbg) < (outlen - len)) ?
-			    drbg_blocklen(drbg) : (outlen - len);
-		memcpy(outval + len, tmp, blocklen);
-		len += blocklen;
-	}
-
-out:
-	memset(tmp, 0, drbg_blocklen(drbg));
-	return ret;
-}
-
-/* update function for Hash DRBG as defined in 10.1.1.2 / 10.1.1.3 */
-static int drbg_hash_update(struct drbg_state *drbg, struct list_head *seed,
-			    int reseed)
-{
-	int ret = 0;
-	struct drbg_string data1, data2;
-	LIST_HEAD(datalist);
-	LIST_HEAD(datalist2);
-	unsigned char *V = drbg->scratchpad;
-	unsigned char prefix = DRBG_PREFIX1;
-
-	if (!seed)
-		return -EINVAL;
-
-	if (reseed) {
-		/* 10.1.1.3 step 1 */
-		memcpy(V, drbg->V, drbg_statelen(drbg));
-		drbg_string_fill(&data1, &prefix, 1);
-		list_add_tail(&data1.list, &datalist);
-		drbg_string_fill(&data2, V, drbg_statelen(drbg));
-		list_add_tail(&data2.list, &datalist);
-	}
-	list_splice_tail(seed, &datalist);
-
-	/* 10.1.1.2 / 10.1.1.3 step 2 and 3 */
-	ret = drbg_hash_df(drbg, drbg->V, drbg_statelen(drbg), &datalist);
-	if (ret)
-		goto out;
-
-	/* 10.1.1.2 / 10.1.1.3 step 4  */
-	prefix = DRBG_PREFIX0;
-	drbg_string_fill(&data1, &prefix, 1);
-	list_add_tail(&data1.list, &datalist2);
-	drbg_string_fill(&data2, drbg->V, drbg_statelen(drbg));
-	list_add_tail(&data2.list, &datalist2);
-	/* 10.1.1.2 / 10.1.1.3 step 4 */
-	ret = drbg_hash_df(drbg, drbg->C, drbg_statelen(drbg), &datalist2);
-
-out:
-	memset(drbg->scratchpad, 0, drbg_statelen(drbg));
-	return ret;
-}
-
-/* processing of additional information string for Hash DRBG */
-static int drbg_hash_process_addtl(struct drbg_state *drbg,
-				   struct list_head *addtl)
-{
-	int ret = 0;
-	struct drbg_string data1, data2;
-	LIST_HEAD(datalist);
-	unsigned char prefix = DRBG_PREFIX2;
-
-	/* 10.1.1.4 step 2 */
-	if (!addtl || list_empty(addtl))
-		return 0;
-
-	/* 10.1.1.4 step 2a */
-	drbg_string_fill(&data1, &prefix, 1);
-	drbg_string_fill(&data2, drbg->V, drbg_statelen(drbg));
-	list_add_tail(&data1.list, &datalist);
-	list_add_tail(&data2.list, &datalist);
-	list_splice_tail(addtl, &datalist);
-	ret = drbg_kcapi_hash(drbg, drbg->scratchpad, &datalist);
-	if (ret)
-		goto out;
-
-	/* 10.1.1.4 step 2b */
-	drbg_add_buf(drbg->V, drbg_statelen(drbg),
-		     drbg->scratchpad, drbg_blocklen(drbg));
-
-out:
-	memset(drbg->scratchpad, 0, drbg_blocklen(drbg));
-	return ret;
-}
-
-/* Hashgen defined in 10.1.1.4 */
-static int drbg_hash_hashgen(struct drbg_state *drbg,
-			     unsigned char *buf,
-			     unsigned int buflen)
-{
-	int len = 0;
-	int ret = 0;
-	unsigned char *src = drbg->scratchpad;
-	unsigned char *dst = drbg->scratchpad + drbg_statelen(drbg);
-	struct drbg_string data;
-	LIST_HEAD(datalist);
-
-	/* 10.1.1.4 step hashgen 2 */
-	memcpy(src, drbg->V, drbg_statelen(drbg));
-
-	drbg_string_fill(&data, src, drbg_statelen(drbg));
-	list_add_tail(&data.list, &datalist);
-	while (len < buflen) {
-		unsigned int outlen = 0;
-		/* 10.1.1.4 step hashgen 4.1 */
-		ret = drbg_kcapi_hash(drbg, dst, &datalist);
-		if (ret) {
-			len = ret;
-			goto out;
-		}
-		outlen = (drbg_blocklen(drbg) < (buflen - len)) ?
-			  drbg_blocklen(drbg) : (buflen - len);
-		/* 10.1.1.4 step hashgen 4.2 */
-		memcpy(buf + len, dst, outlen);
-		len += outlen;
-		/* 10.1.1.4 hashgen step 4.3 */
-		if (len < buflen)
-			crypto_inc(src, drbg_statelen(drbg));
-	}
-
-out:
-	memset(drbg->scratchpad, 0,
-	       (drbg_statelen(drbg) + drbg_blocklen(drbg)));
-	return len;
-}
-
-/* generate function for Hash DRBG as defined in  10.1.1.4 */
-static int drbg_hash_generate(struct drbg_state *drbg,
-			      unsigned char *buf, unsigned int buflen,
-			      struct list_head *addtl)
-{
-	int len = 0;
-	int ret = 0;
-	union {
-		unsigned char req[8];
-		__be64 req_int;
-	} u;
-	unsigned char prefix = DRBG_PREFIX3;
-	struct drbg_string data1, data2;
-	LIST_HEAD(datalist);
-
-	/* 10.1.1.4 step 2 */
-	ret = drbg_hash_process_addtl(drbg, addtl);
-	if (ret)
-		return ret;
-	/* 10.1.1.4 step 3 */
-	len = drbg_hash_hashgen(drbg, buf, buflen);
-
-	/* this is the value H as documented in 10.1.1.4 */
-	/* 10.1.1.4 step 4 */
-	drbg_string_fill(&data1, &prefix, 1);
-	list_add_tail(&data1.list, &datalist);
-	drbg_string_fill(&data2, drbg->V, drbg_statelen(drbg));
-	list_add_tail(&data2.list, &datalist);
-	ret = drbg_kcapi_hash(drbg, drbg->scratchpad, &datalist);
-	if (ret) {
-		len = ret;
-		goto out;
-	}
-
-	/* 10.1.1.4 step 5 */
-	drbg_add_buf(drbg->V, drbg_statelen(drbg),
-		     drbg->scratchpad, drbg_blocklen(drbg));
-	drbg_add_buf(drbg->V, drbg_statelen(drbg),
-		     drbg->C, drbg_statelen(drbg));
-	u.req_int = cpu_to_be64(drbg->reseed_ctr);
-	drbg_add_buf(drbg->V, drbg_statelen(drbg), u.req, 8);
-
-out:
-	memset(drbg->scratchpad, 0, drbg_blocklen(drbg));
-	return len;
-}
-
-/*
- * scratchpad usage: as update and generate are used isolated, both
- * can use the scratchpad
- */
-static const struct drbg_state_ops drbg_hash_ops = {
-	.update		= drbg_hash_update,
-	.generate	= drbg_hash_generate,
-	.crypto_init	= drbg_init_hash_kernel,
-	.crypto_fini	= drbg_fini_hash_kernel,
-};
-#endif /* CONFIG_CRYPTO_DRBG_HASH */
-
 /******************************************************************
  * Functions common for DRBG implementations
  ******************************************************************/
 
 static inline int __drbg_seed(struct drbg_state *drbg, struct list_head *seed,
@@ -701,11 +397,10 @@ static inline int __drbg_seed(struct drbg_state *drbg, struct list_head *seed,
 	if (ret)
 		return ret;
 
 	drbg->seeded = new_seed_state;
 	drbg->last_seed_time = jiffies;
-	/* 10.1.1.2 / 10.1.1.3 step 5 */
 	drbg->reseed_ctr = 1;
 
 	switch (drbg->seeded) {
 	case DRBG_SEED_STATE_UNSEEDED:
 		/* Impossible, but handle it to silence compiler warnings. */
@@ -898,12 +593,10 @@ static inline void drbg_dealloc_state(struct drbg_state *drbg)
 	drbg->Vbuf = NULL;
 	drbg->V = NULL;
 	kfree_sensitive(drbg->Cbuf);
 	drbg->Cbuf = NULL;
 	drbg->C = NULL;
-	kfree_sensitive(drbg->scratchpadbuf);
-	drbg->scratchpadbuf = NULL;
 	drbg->reseed_ctr = 0;
 	drbg->d_ops = NULL;
 	drbg->core = NULL;
 }
 
@@ -912,21 +605,15 @@ static inline void drbg_dealloc_state(struct drbg_state *drbg)
  * The DRBG state structure must already be allocated.
  */
 static inline int drbg_alloc_state(struct drbg_state *drbg)
 {
 	int ret = -ENOMEM;
-	unsigned int sb_size = 0;
 
 	switch (drbg->core->flags & DRBG_TYPE_MASK) {
 	case DRBG_HMAC:
 		drbg->d_ops = &drbg_hmac_ops;
 		break;
-#ifdef CONFIG_CRYPTO_DRBG_HASH
-	case DRBG_HASH:
-		drbg->d_ops = &drbg_hash_ops;
-		break;
-#endif /* CONFIG_CRYPTO_DRBG_HASH */
 	default:
 		ret = -EOPNOTSUPP;
 		goto err;
 	}
 
@@ -944,24 +631,10 @@ static inline int drbg_alloc_state(struct drbg_state *drbg)
 	if (!drbg->Cbuf) {
 		ret = -ENOMEM;
 		goto fini;
 	}
 	drbg->C = PTR_ALIGN(drbg->Cbuf, ret + 1);
-	/* scratchpad is only generated for Hash */
-	if (drbg->core->flags & DRBG_HMAC)
-		sb_size = 0;
-	else
-		sb_size = drbg_statelen(drbg) + drbg_blocklen(drbg);
-
-	if (0 < sb_size) {
-		drbg->scratchpadbuf = kzalloc(sb_size + ret, GFP_KERNEL);
-		if (!drbg->scratchpadbuf) {
-			ret = -ENOMEM;
-			goto fini;
-		}
-		drbg->scratchpad = PTR_ALIGN(drbg->scratchpadbuf, ret + 1);
-	}
 
 	return 0;
 
 fini:
 	drbg->d_ops->crypto_fini(drbg);
@@ -1059,11 +732,11 @@ static int drbg_generate(struct drbg_state *drbg,
 	if (addtl && 0 < addtl->len)
 		list_add_tail(&addtl->list, &addtllist);
 	/* 9.3.1 step 8 and 10 */
 	len = drbg->d_ops->generate(drbg, buf, buflen, &addtllist);
 
-	/* 10.1.1.4 step 6, 10.1.2.5 step 7 */
+	/* 10.1.2.5 step 7 */
 	drbg->reseed_ctr++;
 	if (0 >= len)
 		goto err;
 
 	/*
@@ -1447,13 +1120,10 @@ static inline int __init drbg_healthcheck_sanity(void)
 
 	/* only perform test in FIPS mode */
 	if (!fips_enabled)
 		return 0;
 
-#ifdef CONFIG_CRYPTO_DRBG_HASH
-	drbg_convert_tfm_core("drbg_nopr_sha256", &coreref, &pr);
-#endif
 	drbg_convert_tfm_core("drbg_nopr_hmac_sha512", &coreref, &pr);
 
 	drbg = kzalloc_obj(struct drbg_state);
 	if (!drbg)
 		return -ENOMEM;
@@ -1575,15 +1245,9 @@ static void __exit drbg_exit(void)
 	crypto_unregister_rngs(drbg_algs, (ARRAY_SIZE(drbg_cores) * 2));
 }
 
 module_init(drbg_init);
 module_exit(drbg_exit);
-#ifndef CRYPTO_DRBG_HASH_STRING
-#define CRYPTO_DRBG_HASH_STRING ""
-#endif
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Stephan Mueller <smueller@chronox.de>");
-MODULE_DESCRIPTION("NIST SP800-90A Deterministic Random Bit Generator (DRBG) "
-		   "using following cores: "
-		   CRYPTO_DRBG_HASH_STRING
-		   CRYPTO_DRBG_HMAC_STRING);
+MODULE_DESCRIPTION("NIST SP800-90A Deterministic Random Bit Generator (DRBG)");
 MODULE_ALIAS_CRYPTO("stdrng");
diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index dbc1e1fb4bd0..fdc5051b73c5 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -4658,26 +4658,10 @@ static const struct alg_test_desc alg_test_descs[] = {
 		.test = alg_test_drbg,
 		.fips_allowed = 1,
 		.suite = {
 			.drbg = __VECS(drbg_nopr_hmac_sha512_tv_template)
 		}
-	}, {
-		.alg = "drbg_nopr_sha256",
-		.test = alg_test_drbg,
-		.fips_allowed = 1,
-		.suite = {
-			.drbg = __VECS(drbg_nopr_sha256_tv_template)
-		}
-	}, {
-		/* covered by drbg_nopr_sha256 test */
-		.alg = "drbg_nopr_sha384",
-		.test = alg_test_null,
-		.fips_allowed = 1
-	}, {
-		.alg = "drbg_nopr_sha512",
-		.fips_allowed = 1,
-		.test = alg_test_null,
 	}, {
 		.alg = "drbg_pr_hmac_sha256",
 		.test = alg_test_drbg,
 		.fips_allowed = 1,
 		.suite = {
@@ -4690,26 +4674,10 @@ static const struct alg_test_desc alg_test_descs[] = {
 		.fips_allowed = 1
 	}, {
 		.alg = "drbg_pr_hmac_sha512",
 		.test = alg_test_null,
 		.fips_allowed = 1,
-	}, {
-		.alg = "drbg_pr_sha256",
-		.test = alg_test_drbg,
-		.fips_allowed = 1,
-		.suite = {
-			.drbg = __VECS(drbg_pr_sha256_tv_template)
-		}
-	}, {
-		/* covered by drbg_pr_sha256 test */
-		.alg = "drbg_pr_sha384",
-		.test = alg_test_null,
-		.fips_allowed = 1
-	}, {
-		.alg = "drbg_pr_sha512",
-		.fips_allowed = 1,
-		.test = alg_test_null,
 	}, {
 		.alg = "ecb(aes)",
 		.generic_driver = "ecb(aes-lib)",
 		.test = alg_test_skcipher,
 		.fips_allowed = 1,
diff --git a/crypto/testmgr.h b/crypto/testmgr.h
index a86275b61b6a..d44a4c1e7313 100644
--- a/crypto/testmgr.h
+++ b/crypto/testmgr.h
@@ -23420,176 +23420,10 @@ static const struct aead_testvec aegis128_tv_template[] = {
 			  "\x78\x93\xec\xfc\xf4\xff\xe1\x2d",
 		.clen	= 24,
 	},
 };
 
-/*
- * SP800-90A DRBG Test vectors from
- * http://csrc.nist.gov/groups/STM/cavp/documents/drbg/drbgtestvectors.zip
- *
- * Test vectors for DRBG with prediction resistance. All types of DRBGs
- * (Hash, HMAC, CTR) are tested with all permutations of use cases (w/ and
- * w/o personalization string, w/ and w/o additional input string).
- */
-static const struct drbg_testvec drbg_pr_sha256_tv_template[] = {
-	{
-		.entropy = (unsigned char *)
-			"\x72\x88\x4c\xcd\x6c\x85\x57\x70\xf7\x0b\x8b\x86"
-			"\xc1\xeb\xd2\x4e\x36\x14\xab\x18\xc4\x9c\xc9\xcf"
-			"\x1a\xe8\xf7\x7b\x02\x49\x73\xd7\xf1\x42\x7d\xc6"
-			"\x3f\x29\x2d\xec\xd3\x66\x51\x3f\x1d\x8d\x5b\x4e",
-		.entropylen = 48,
-		.entpra = (unsigned char *)
-			"\x38\x9c\x91\xfa\xc2\xa3\x46\x89\x56\x08\x3f\x62"
-			"\x73\xd5\x22\xa9\x29\x63\x3a\x1d\xe5\x5d\x5e\x4f"
-			"\x67\xb0\x67\x7a\x5e\x9e\x0c\x62",
-		.entprb = (unsigned char *)
-			"\xb2\x8f\x36\xb2\xf6\x8d\x39\x13\xfa\x6c\x66\xcf"
-			"\x62\x8a\x7e\x8c\x12\x33\x71\x9c\x69\xe4\xa5\xf0"
-			"\x8c\xee\xeb\x9c\xf5\x31\x98\x31",
-		.entprlen = 32,
-		.expected = (unsigned char *)
-			"\x52\x7b\xa3\xad\x71\x77\xa4\x49\x42\x04\x61\xc7"
-			"\xf0\xaf\xa5\xfd\xd3\xb3\x0d\x6a\x61\xba\x35\x49"
-			"\xbb\xaa\xaf\xe4\x25\x7d\xb5\x48\xaf\x5c\x18\x3d"
-			"\x33\x8d\x9d\x45\xdf\x98\xd5\x94\xa8\xda\x92\xfe"
-			"\xc4\x3c\x94\x2a\xcf\x7f\x7b\xf2\xeb\x28\xa9\xf1"
-			"\xe0\x86\x30\xa8\xfe\xf2\x48\x90\x91\x0c\x75\xb5"
-			"\x3c\x00\xf0\x4d\x09\x4f\x40\xa7\xa2\x8c\x52\xdf"
-			"\x52\xef\x17\xbf\x3d\xd1\xa2\x31\xb4\xb8\xdc\xe6"
-			"\x5b\x0d\x1f\x78\x36\xb4\xe6\x4b\xa7\x11\x25\xd5"
-			"\x94\xc6\x97\x36\xab\xf0\xe5\x31\x28\x6a\xbb\xce"
-			"\x30\x81\xa6\x8f\x27\x14\xf8\x1c",
-		.expectedlen = 128,
-		.addtla = NULL,
-		.addtlb = NULL,
-		.addtllen = 0,
-		.pers = NULL,
-		.perslen = 0,
-	}, {
-		.entropy = (unsigned char *)
-			"\x5d\xf2\x14\xbc\xf6\xb5\x4e\x0b\xf0\x0d\x6f\x2d"
-			"\xe2\x01\x66\x7b\xd0\xa4\x73\xa4\x21\xdd\xb0\xc0"
-			"\x51\x79\x09\xf4\xea\xa9\x08\xfa\xa6\x67\xe0\xe1"
-			"\xd1\x88\xa8\xad\xee\x69\x74\xb3\x55\x06\x9b\xf6",
-		.entropylen = 48,
-		.entpra = (unsigned char *)
-			"\xef\x48\x06\xa2\xc2\x45\xf1\x44\xfa\x34\x2c\xeb"
-			"\x8d\x78\x3c\x09\x8f\x34\x72\x20\xf2\xe7\xfd\x13"
-			"\x76\x0a\xf6\xdc\x3c\xf5\xc0\x15",
-		.entprb = (unsigned char *)
-			"\x4b\xbe\xe5\x24\xed\x6a\x2d\x0c\xdb\x73\x5e\x09"
-			"\xf9\xad\x67\x7c\x51\x47\x8b\x6b\x30\x2a\xc6\xde"
-			"\x76\xaa\x55\x04\x8b\x0a\x72\x95",
-		.entprlen = 32,
-		.expected = (unsigned char *)
-			"\x3b\x14\x71\x99\xa1\xda\xa0\x42\xe6\xc8\x85\x32"
-			"\x70\x20\x32\x53\x9a\xbe\xd1\x1e\x15\xef\xfb\x4c"
-			"\x25\x6e\x19\x3a\xf0\xb9\xcb\xde\xf0\x3b\xc6\x18"
-			"\x4d\x85\x5a\x9b\xf1\xe3\xc2\x23\x03\x93\x08\xdb"
-			"\xa7\x07\x4b\x33\x78\x40\x4d\xeb\x24\xf5\x6e\x81"
-			"\x4a\x1b\x6e\xa3\x94\x52\x43\xb0\xaf\x2e\x21\xf4"
-			"\x42\x46\x8e\x90\xed\x34\x21\x75\xea\xda\x67\xb6"
-			"\xe4\xf6\xff\xc6\x31\x6c\x9a\x5a\xdb\xb3\x97\x13"
-			"\x09\xd3\x20\x98\x33\x2d\x6d\xd7\xb5\x6a\xa8\xa9"
-			"\x9a\x5b\xd6\x87\x52\xa1\x89\x2b\x4b\x9c\x64\x60"
-			"\x50\x47\xa3\x63\x81\x16\xaf\x19",
-		.expectedlen = 128,
-		.addtla = (unsigned char *)
-			"\xbe\x13\xdb\x2a\xe9\xa8\xfe\x09\x97\xe1\xce\x5d"
-			"\xe8\xbb\xc0\x7c\x4f\xcb\x62\x19\x3f\x0f\xd2\xad"
-			"\xa9\xd0\x1d\x59\x02\xc4\xff\x70",
-		.addtlb = (unsigned char *)
-			"\x6f\x96\x13\xe2\xa7\xf5\x6c\xfe\xdf\x66\xe3\x31"
-			"\x63\x76\xbf\x20\x27\x06\x49\xf1\xf3\x01\x77\x41"
-			"\x9f\xeb\xe4\x38\xfe\x67\x00\xcd",
-		.addtllen = 32,
-		.pers = NULL,
-		.perslen = 0,
-	}, {
-		.entropy = (unsigned char *)
-			"\xc6\x1c\xaf\x83\xa2\x56\x38\xf9\xb0\xbc\xd9\x85"
-			"\xf5\x2e\xc4\x46\x9c\xe1\xb9\x40\x98\x70\x10\x72"
-			"\xd7\x7d\x15\x85\xa1\x83\x5a\x97\xdf\xc8\xa8\xe8"
-			"\x03\x4c\xcb\x70\x35\x8b\x90\x94\x46\x8a\x6e\xa1",
-		.entropylen = 48,
-		.entpra = (unsigned char *)
-			"\xc9\x05\xa4\xcf\x28\x80\x4b\x93\x0f\x8b\xc6\xf9"
-			"\x09\x41\x58\x74\xe9\xec\x28\xc7\x53\x0a\x73\x60"
-			"\xba\x0a\xde\x57\x5b\x4b\x9f\x29",
-		.entprb = (unsigned char *)
-			"\x4f\x31\xd2\xeb\xac\xfa\xa8\xe2\x01\x7d\xf3\xbd"
-			"\x42\xbd\x20\xa0\x30\x65\x74\xd5\x5d\xd2\xad\xa4"
-			"\xa9\xeb\x1f\x4d\xf6\xfd\xb8\x26",
-		.entprlen = 32,
-		.expected = (unsigned char *)
-			"\xf6\x13\x05\xcb\x83\x60\x16\x42\x49\x1d\xc6\x25"
-			"\x3b\x8c\x31\xa3\xbe\x8b\xbd\x1c\xe2\xec\x1d\xde"
-			"\xbb\xbf\xa1\xac\xa8\x9f\x50\xce\x69\xce\xef\xd5"
-			"\xd6\xf2\xef\x6a\xf7\x81\x38\xdf\xbc\xa7\x5a\xb9"
-			"\xb2\x42\x65\xab\xe4\x86\x8d\x2d\x9d\x59\x99\x2c"
-			"\x5a\x0d\x71\x55\x98\xa4\x45\xc2\x8d\xdb\x05\x5e"
-			"\x50\x21\xf7\xcd\xe8\x98\x43\xce\x57\x74\x63\x4c"
-			"\xf3\xb1\xa5\x14\x1e\x9e\x01\xeb\x54\xd9\x56\xae"
-			"\xbd\xb6\x6f\x1a\x47\x6b\x3b\x44\xe4\xa2\xe9\x3c"
-			"\x6c\x83\x12\x30\xb8\x78\x7f\x8e\x54\x82\xd4\xfe"
-			"\x90\x35\x0d\x4c\x4d\x85\xe7\x13",
-		.expectedlen = 128,
-		.addtla = NULL,
-		.addtlb = NULL,
-		.addtllen = 0,
-		.pers = (unsigned char *)
-			"\xa5\xbf\xac\x4f\x71\xa1\xbb\x67\x94\xc6\x50\xc7"
-			"\x2a\x45\x9e\x10\xa8\xed\xf7\x52\x4f\xfe\x21\x90"
-			"\xa4\x1b\xe1\xe2\x53\xcc\x61\x47",
-		.perslen = 32,
-	}, {
-		.entropy = (unsigned char *)
-			"\xb6\xc1\x8d\xdf\x99\x54\xbe\x95\x10\x48\xd9\xf6"
-			"\xd7\x48\xa8\x73\x2d\x74\xde\x1e\xde\x57\x7e\xf4"
-			"\x7b\x7b\x64\xef\x88\x7a\xa8\x10\x4b\xe1\xc1\x87"
-			"\xbb\x0b\xe1\x39\x39\x50\xaf\x68\x9c\xa2\xbf\x5e",
-		.entropylen = 48,
-		.entpra = (unsigned char *)
-			"\xdc\x81\x0a\x01\x58\xa7\x2e\xce\xee\x48\x8c\x7c"
-			"\x77\x9e\x3c\xf1\x17\x24\x7a\xbb\xab\x9f\xca\x12"
-			"\x19\xaf\x97\x2d\x5f\xf9\xff\xfc",
-		.entprb = (unsigned char *)
-			"\xaf\xfc\x4f\x98\x8b\x93\x95\xc1\xb5\x8b\x7f\x73"
-			"\x6d\xa6\xbe\x6d\x33\xeb\x2c\x82\xb1\xaf\xc1\xb6"
-			"\xb6\x05\xe2\x44\xaa\xfd\xe7\xdb",
-		.entprlen = 32,
-		.expected = (unsigned char *)
-			"\x51\x79\xde\x1c\x0f\x58\xf3\xf4\xc9\x57\x2e\x31"
-			"\xa7\x09\xa1\x53\x64\x63\xa2\xc5\x1d\x84\x88\x65"
-			"\x01\x1b\xc6\x16\x3c\x49\x5b\x42\x8e\x53\xf5\x18"
-			"\xad\x94\x12\x0d\x4f\x55\xcc\x45\x5c\x98\x0f\x42"
-			"\x28\x2f\x47\x11\xf9\xc4\x01\x97\x6b\xa0\x94\x50"
-			"\xa9\xd1\x5e\x06\x54\x3f\xdf\xbb\xc4\x98\xee\x8b"
-			"\xba\xa9\xfa\x49\xee\x1d\xdc\xfb\x50\xf6\x51\x9f"
-			"\x6c\x4a\x9a\x6f\x63\xa2\x7d\xad\xaf\x3a\x24\xa0"
-			"\xd9\x9f\x07\xeb\x15\xee\x26\xe0\xd5\x63\x39\xda"
-			"\x3c\x59\xd6\x33\x6c\x02\xe8\x05\x71\x46\x68\x44"
-			"\x63\x4a\x68\x72\xe9\xf5\x55\xfe",
-		.expectedlen = 128,
-		.addtla = (unsigned char *)
-			"\x15\x20\x2f\xf6\x98\x28\x63\xa2\xc4\x4e\xbb\x6c"
-			"\xb2\x25\x92\x61\x79\xc9\x22\xc4\x61\x54\x96\xff"
-			"\x4a\x85\xca\x80\xfe\x0d\x1c\xd0",
-		.addtlb = (unsigned char *)
-			"\xde\x29\x8e\x03\x42\x61\xa3\x28\x5e\xc8\x80\xc2"
-			"\x6d\xbf\xad\x13\xe1\x8d\x2a\xc7\xe8\xc7\x18\x89"
-			"\x42\x58\x9e\xd6\xcc\xad\x7b\x1e",
-		.addtllen = 32,
-		.pers = (unsigned char *)
-			"\x84\xc3\x73\x9e\xce\xb3\xbc\x89\xf7\x62\xb3\xe1"
-			"\xd7\x48\x45\x8a\xa9\xcc\xe9\xed\xd5\x81\x84\x52"
-			"\x82\x4c\xdc\x19\xb8\xf8\x92\x5c",
-		.perslen = 32,
-	},
-};
-
 static const struct drbg_testvec drbg_pr_hmac_sha256_tv_template[] = {
 	{
 		.entropy = (unsigned char *)
 			"\x99\x69\xe5\x4b\x47\x03\xff\x31\x78\x5b\x87\x9a"
 			"\x7e\x5c\x0e\xae\x0d\x3e\x30\x95\x59\xe9\xfe\x96"
@@ -23744,140 +23578,10 @@ static const struct drbg_testvec drbg_pr_hmac_sha256_tv_template[] = {
 			"\xd1\x81\xe9\xf8\xeb\x30\x8f\x6f",
 		.perslen = 32,
 	},
 };
 
-/*
- * SP800-90A DRBG Test vectors from
- * http://csrc.nist.gov/groups/STM/cavp/documents/drbg/drbgtestvectors.zip
- *
- * Test vectors for DRBG without prediction resistance. All types of DRBGs
- * (Hash, HMAC, CTR) are tested with all permutations of use cases (w/ and
- * w/o personalization string, w/ and w/o additional input string).
- */
-static const struct drbg_testvec drbg_nopr_sha256_tv_template[] = {
-	{
-		.entropy = (unsigned char *)
-			"\xa6\x5a\xd0\xf3\x45\xdb\x4e\x0e\xff\xe8\x75\xc3"
-			"\xa2\xe7\x1f\x42\xc7\x12\x9d\x62\x0f\xf5\xc1\x19"
-			"\xa9\xef\x55\xf0\x51\x85\xe0\xfb\x85\x81\xf9\x31"
-			"\x75\x17\x27\x6e\x06\xe9\x60\x7d\xdb\xcb\xcc\x2e",
-		.entropylen = 48,
-		.expected = (unsigned char *)
-			"\xd3\xe1\x60\xc3\x5b\x99\xf3\x40\xb2\x62\x82\x64"
-			"\xd1\x75\x10\x60\xe0\x04\x5d\xa3\x83\xff\x57\xa5"
-			"\x7d\x73\xa6\x73\xd2\xb8\xd8\x0d\xaa\xf6\xa6\xc3"
-			"\x5a\x91\xbb\x45\x79\xd7\x3f\xd0\xc8\xfe\xd1\x11"
-			"\xb0\x39\x13\x06\x82\x8a\xdf\xed\x52\x8f\x01\x81"
-			"\x21\xb3\xfe\xbd\xc3\x43\xe7\x97\xb8\x7d\xbb\x63"
-			"\xdb\x13\x33\xde\xd9\xd1\xec\xe1\x77\xcf\xa6\xb7"
-			"\x1f\xe8\xab\x1d\xa4\x66\x24\xed\x64\x15\xe5\x1c"
-			"\xcd\xe2\xc7\xca\x86\xe2\x83\x99\x0e\xea\xeb\x91"
-			"\x12\x04\x15\x52\x8b\x22\x95\x91\x02\x81\xb0\x2d"
-			"\xd4\x31\xf4\xc9\xf7\x04\x27\xdf",
-		.expectedlen = 128,
-		.addtla = NULL,
-		.addtlb = NULL,
-		.addtllen = 0,
-		.pers = NULL,
-		.perslen = 0,
-	}, {
-		.entropy = (unsigned char *)
-			"\x73\xd3\xfb\xa3\x94\x5f\x2b\x5f\xb9\x8f\xf6\x9c"
-			"\x8a\x93\x17\xae\x19\xc3\x4c\xc3\xd6\xca\xa3\x2d"
-			"\x16\xfc\x42\xd2\x2d\xd5\x6f\x56\xcc\x1d\x30\xff"
-			"\x9e\x06\x3e\x09\xce\x58\xe6\x9a\x35\xb3\xa6\x56",
-		.entropylen = 48,
-		.expected = (unsigned char *)
-			"\x71\x7b\x93\x46\x1a\x40\xaa\x35\xa4\xaa\xc5\xe7"
-			"\x6d\x5b\x5b\x8a\xa0\xdf\x39\x7d\xae\x71\x58\x5b"
-			"\x3c\x7c\xb4\xf0\x89\xfa\x4a\x8c\xa9\x5c\x54\xc0"
-			"\x40\xdf\xbc\xce\x26\x81\x34\xf8\xba\x7d\x1c\xe8"
-			"\xad\x21\xe0\x74\xcf\x48\x84\x30\x1f\xa1\xd5\x4f"
-			"\x81\x42\x2f\xf4\xdb\x0b\x23\xf8\x73\x27\xb8\x1d"
-			"\x42\xf8\x44\x58\xd8\x5b\x29\x27\x0a\xf8\x69\x59"
-			"\xb5\x78\x44\xeb\x9e\xe0\x68\x6f\x42\x9a\xb0\x5b"
-			"\xe0\x4e\xcb\x6a\xaa\xe2\xd2\xd5\x33\x25\x3e\xe0"
-			"\x6c\xc7\x6a\x07\xa5\x03\x83\x9f\xe2\x8b\xd1\x1c"
-			"\x70\xa8\x07\x59\x97\xeb\xf6\xbe",
-		.expectedlen = 128,
-		.addtla = (unsigned char *)
-			"\xf4\xd5\x98\x3d\xa8\xfc\xfa\x37\xb7\x54\x67\x73"
-			"\xc7\xc3\xdd\x47\x34\x71\x02\x5d\xc1\xa0\xd3\x10"
-			"\xc1\x8b\xbd\xf5\x66\x34\x6f\xdd",
-		.addtlb = (unsigned char *)
-			"\xf7\x9e\x6a\x56\x0e\x73\xe9\xd9\x7a\xd1\x69\xe0"
-			"\x6f\x8c\x55\x1c\x44\xd1\xce\x6f\x28\xcc\xa4\x4d"
-			"\xa8\xc0\x85\xd1\x5a\x0c\x59\x40",
-		.addtllen = 32,
-		.pers = NULL,
-		.perslen = 0,
-	}, {
-		.entropy = (unsigned char *)
-			"\x2a\x85\xa9\x8b\xd0\xda\x83\xd6\xad\xab\x9f\xbb"
-			"\x54\x31\x15\x95\x1c\x4d\x49\x9f\x6a\x15\xf6\xe4"
-			"\x15\x50\x88\x06\x29\x0d\xed\x8d\xb9\x6f\x96\xe1"
-			"\x83\x9f\xf7\x88\xda\x84\xbf\x44\x28\xd9\x1d\xaa",
-		.entropylen = 48,
-		.expected = (unsigned char *)
-			"\x2d\x55\xde\xc9\xed\x05\x47\x07\x3d\x04\xfc\x28"
-			"\x0f\x92\xf0\x4d\xd8\x00\x32\x47\x0a\x1b\x1c\x4b"
-			"\xef\xd9\x97\xa1\x17\x67\xda\x26\x6c\xfe\x76\x46"
-			"\x6f\xbc\x6d\x82\x4e\x83\x8a\x98\x66\x6c\x01\xb6"
-			"\xe6\x64\xe0\x08\x10\x6f\xd3\x5d\x90\xe7\x0d\x72"
-			"\xa6\xa7\xe3\xbb\x98\x11\x12\x56\x23\xc2\x6d\xd1"
-			"\xc8\xa8\x7a\x39\xf3\x34\xe3\xb8\xf8\x66\x00\x77"
-			"\x7d\xcf\x3c\x3e\xfa\xc9\x0f\xaf\xe0\x24\xfa\xe9"
-			"\x84\xf9\x6a\x01\xf6\x35\xdb\x5c\xab\x2a\xef\x4e"
-			"\xac\xab\x55\xb8\x9b\xef\x98\x68\xaf\x51\xd8\x16"
-			"\xa5\x5e\xae\xf9\x1e\xd2\xdb\xe6",
-		.expectedlen = 128,
-		.addtla = NULL,
-		.addtlb = NULL,
-		.addtllen = 0,
-		.pers = (unsigned char *)
-			"\xa8\x80\xec\x98\x30\x98\x15\xd2\xc6\xc4\x68\xf1"
-			"\x3a\x1c\xbf\xce\x6a\x40\x14\xeb\x36\x99\x53\xda"
-			"\x57\x6b\xce\xa4\x1c\x66\x3d\xbc",
-		.perslen = 32,
-	}, {
-		.entropy = (unsigned char *)
-			"\x69\xed\x82\xa9\xc5\x7b\xbf\xe5\x1d\x2f\xcb\x7a"
-			"\xd3\x50\x7d\x96\xb4\xb9\x2b\x50\x77\x51\x27\x74"
-			"\x33\x74\xba\xf1\x30\xdf\x8e\xdf\x87\x1d\x87\xbc"
-			"\x96\xb2\xc3\xa7\xed\x60\x5e\x61\x4e\x51\x29\x1a",
-		.entropylen = 48,
-		.expected = (unsigned char *)
-			"\xa5\x71\x24\x31\x11\xfe\x13\xe1\xa8\x24\x12\xfb"
-			"\x37\xa1\x27\xa5\xab\x77\xa1\x9f\xae\x8f\xaf\x13"
-			"\x93\xf7\x53\x85\x91\xb6\x1b\xab\xd4\x6b\xea\xb6"
-			"\xef\xda\x4c\x90\x6e\xef\x5f\xde\xe1\xc7\x10\x36"
-			"\xd5\x67\xbd\x14\xb6\x89\x21\x0c\xc9\x92\x65\x64"
-			"\xd0\xf3\x23\xe0\x7f\xd1\xe8\x75\xc2\x85\x06\xea"
-			"\xca\xc0\xcb\x79\x2d\x29\x82\xfc\xaa\x9a\xc6\x95"
-			"\x7e\xdc\x88\x65\xba\xec\x0e\x16\x87\xec\xa3\x9e"
-			"\xd8\x8c\x80\xab\x3a\x64\xe0\xcb\x0e\x45\x98\xdd"
-			"\x7c\x6c\x6c\x26\x11\x13\xc8\xce\xa9\x47\xa6\x06"
-			"\x57\xa2\x66\xbb\x2d\x7f\xf3\xc1",
-		.expectedlen = 128,
-		.addtla = (unsigned char *)
-			"\x74\xd3\x6d\xda\xe8\xd6\x86\x5f\x63\x01\xfd\xf2"
-			"\x7d\x06\x29\x6d\x94\xd1\x66\xf0\xd2\x72\x67\x4e"
-			"\x77\xc5\x3d\x9e\x03\xe3\xa5\x78",
-		.addtlb = (unsigned char *)
-			"\xf6\xb6\x3d\xf0\x7c\x26\x04\xc5\x8b\xcd\x3e\x6a"
-			"\x9f\x9c\x3a\x2e\xdb\x47\x87\xe5\x8e\x00\x5e\x2b"
-			"\x74\x7f\xa6\xf6\x80\xcd\x9b\x21",
-		.addtllen = 32,
-		.pers = (unsigned char *)
-			"\x74\xa6\xe0\x08\xf9\x27\xee\x1d\x6e\x3c\x28\x20"
-			"\x87\xdd\xd7\x54\x31\x47\x78\x4b\xe5\x6d\xa3\x73"
-			"\xa9\x65\xb1\x10\xc1\xdc\x77\x7c",
-		.perslen = 32,
-	},
-};
-
 static const struct drbg_testvec drbg_nopr_hmac_sha256_tv_template[] = {
 	{
 		.entropy = (unsigned char *)
 			"\xca\x85\x19\x11\x34\x93\x84\xbf\xfe\x89\xde\x1c"
 			"\xbd\xc4\x6e\x68\x31\xe4\x4d\x34\xa4\xfb\x93\x5e"
-- 
2.53.0

