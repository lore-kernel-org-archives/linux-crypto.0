Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 338B3192B84;
	Mon, 20 Oct 2025 00:53:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760921618; cv=none; b=O4db8zTTn7QR3tJTo525jHfyJSjx+3pmFDXq1HNfTQr1g5b8d0Ch8jz/szIxirkHYgl5Iif8JwjVVdpJ0GH40Amhw1BK0bv0U32ti49AHfYNtbhRa2apSUwjvtOrr67A0c5rlIwm0YmSSabGYcUU2ddhPhxdU5LS1h9sNHoi2Ao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760921618; c=relaxed/simple;
	bh=zXkMPjNQfeAh7+9lKU8XzQRbjmrE7OEmEaBqTzm61Ic=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eLjFYeWSBaJxydCzy0l0JsnLu84Cc5N5ZVIB4k1ORdtmk50FT1eFWQp9R2uWipHrjZF/xdLP+iloTEGx/Fjy1jdICy7U6TBkhSYtXtfLAObVFIY5CAPqyfVw5gD2+JAxZUHKo6mcDUn5sQwZHyp7nCrUSP9DfKefiCCCS0ta/3o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FMf79vK7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FMf79vK7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8F10C4CEE7;
	Mon, 20 Oct 2025 00:53:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760921618;
	bh=zXkMPjNQfeAh7+9lKU8XzQRbjmrE7OEmEaBqTzm61Ic=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FMf79vK7BhWJm1/j27q2jylG8NJxDE0tTvhYvkg10FR/aKnoQXZeozp2NIjtGhN48
	 +kbPHC1uBrhheosAw//vmKyuK4mtPd4xvgEL6uDuAb53kHrx3n/10VTRBBEKkDjPYh
	 fXRdUq03JkHqnurwJSgnfHVhBXL5+4fa9/MlkrUIUos+XGnKYV6RlrtpmNhEsrT7uD
	 KPQEhXivMQyqvRQ2cqvIgG9u5yJXhwisAlWSHILCiBHKfY5kEY3vOg/VN4gINiP6nc
	 W2uO8dERfy9RmHT7NfC86n82QMdMEWdOLDLXSunHUUWQypTcn0FcVsEEDWZv+zSbvx
	 g4/Bky0kB6Eyg==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: David Howells <dhowells@redhat.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-s390@vger.kernel.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 15/17] lib/crypto: s390/sha3: Migrate optimized code into library
Date: Sun, 19 Oct 2025 17:50:36 -0700
Message-ID: <20251020005038.661542-16-ebiggers@kernel.org>
X-Mailer: git-send-email 2.51.1.dirty
In-Reply-To: <20251020005038.661542-1-ebiggers@kernel.org>
References: <20251020005038.661542-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Instead of exposing the s390-optimized SHA-3 code via s390-specific
crypto_shash algorithms, instead just implement the sha3_absorb_blocks()
and sha3_keccakf() library functions.  This is much simpler, it makes
the SHA-3 library functions be s390-optimized, and it fixes the
longstanding issue where the s390-optimized SHA-3 code was disabled by
default.  SHA-3 still remains available through crypto_shash, but
individual architectures no longer need to handle it.

Note that the existing code used both CPACF_KIMD_SHA3_224 and
CPACF_KIMD_SHA3_256 after checking for just CPACF_KIMD_SHA3_256, and
similarly for 384 and 512.  I've preserved that behavior.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 arch/s390/configs/debug_defconfig |   3 +-
 arch/s390/configs/defconfig       |   3 +-
 arch/s390/crypto/Kconfig          |  20 ----
 arch/s390/crypto/Makefile         |   2 -
 arch/s390/crypto/sha.h            |  51 ----------
 arch/s390/crypto/sha3_256_s390.c  | 157 ------------------------------
 arch/s390/crypto/sha3_512_s390.c  | 157 ------------------------------
 arch/s390/crypto/sha_common.c     | 117 ----------------------
 lib/crypto/Kconfig                |   1 +
 lib/crypto/s390/sha3.h            |  76 +++++++++++++++
 10 files changed, 79 insertions(+), 508 deletions(-)
 delete mode 100644 arch/s390/crypto/sha.h
 delete mode 100644 arch/s390/crypto/sha3_256_s390.c
 delete mode 100644 arch/s390/crypto/sha3_512_s390.c
 delete mode 100644 arch/s390/crypto/sha_common.c
 create mode 100644 lib/crypto/s390/sha3.h

diff --git a/arch/s390/configs/debug_defconfig b/arch/s390/configs/debug_defconfig
index b31c1df902577..5fdfebcfd50f2 100644
--- a/arch/s390/configs/debug_defconfig
+++ b/arch/s390/configs/debug_defconfig
@@ -790,10 +790,11 @@ CONFIG_CRYPTO_GCM=y
 CONFIG_CRYPTO_SEQIV=y
 CONFIG_CRYPTO_MD4=m
 CONFIG_CRYPTO_MD5=y
 CONFIG_CRYPTO_MICHAEL_MIC=m
 CONFIG_CRYPTO_RMD160=m
+CONFIG_CRYPTO_SHA3=m
 CONFIG_CRYPTO_SM3_GENERIC=m
 CONFIG_CRYPTO_WP512=m
 CONFIG_CRYPTO_XCBC=m
 CONFIG_CRYPTO_CRC32=m
 CONFIG_CRYPTO_842=m
@@ -803,12 +804,10 @@ CONFIG_CRYPTO_ZSTD=m
 CONFIG_CRYPTO_ANSI_CPRNG=m
 CONFIG_CRYPTO_USER_API_HASH=m
 CONFIG_CRYPTO_USER_API_SKCIPHER=m
 CONFIG_CRYPTO_USER_API_RNG=m
 CONFIG_CRYPTO_USER_API_AEAD=m
-CONFIG_CRYPTO_SHA3_256_S390=m
-CONFIG_CRYPTO_SHA3_512_S390=m
 CONFIG_CRYPTO_GHASH_S390=m
 CONFIG_CRYPTO_AES_S390=m
 CONFIG_CRYPTO_DES_S390=m
 CONFIG_CRYPTO_HMAC_S390=m
 CONFIG_ZCRYPT=m
diff --git a/arch/s390/configs/defconfig b/arch/s390/configs/defconfig
index 161dad7ef211a..7bac3f53a95b0 100644
--- a/arch/s390/configs/defconfig
+++ b/arch/s390/configs/defconfig
@@ -774,10 +774,11 @@ CONFIG_CRYPTO_GCM=y
 CONFIG_CRYPTO_SEQIV=y
 CONFIG_CRYPTO_MD4=m
 CONFIG_CRYPTO_MD5=y
 CONFIG_CRYPTO_MICHAEL_MIC=m
 CONFIG_CRYPTO_RMD160=m
+CONFIG_CRYPTO_SHA3=m
 CONFIG_CRYPTO_SM3_GENERIC=m
 CONFIG_CRYPTO_WP512=m
 CONFIG_CRYPTO_XCBC=m
 CONFIG_CRYPTO_CRC32=m
 CONFIG_CRYPTO_842=m
@@ -788,12 +789,10 @@ CONFIG_CRYPTO_ANSI_CPRNG=m
 CONFIG_CRYPTO_JITTERENTROPY_OSR=1
 CONFIG_CRYPTO_USER_API_HASH=m
 CONFIG_CRYPTO_USER_API_SKCIPHER=m
 CONFIG_CRYPTO_USER_API_RNG=m
 CONFIG_CRYPTO_USER_API_AEAD=m
-CONFIG_CRYPTO_SHA3_256_S390=m
-CONFIG_CRYPTO_SHA3_512_S390=m
 CONFIG_CRYPTO_GHASH_S390=m
 CONFIG_CRYPTO_AES_S390=m
 CONFIG_CRYPTO_DES_S390=m
 CONFIG_CRYPTO_HMAC_S390=m
 CONFIG_ZCRYPT=m
diff --git a/arch/s390/crypto/Kconfig b/arch/s390/crypto/Kconfig
index 03f73fbd38b62..f838ca055f6d7 100644
--- a/arch/s390/crypto/Kconfig
+++ b/arch/s390/crypto/Kconfig
@@ -1,29 +1,9 @@
 # SPDX-License-Identifier: GPL-2.0
 
 menu "Accelerated Cryptographic Algorithms for CPU (s390)"
 
-config CRYPTO_SHA3_256_S390
-	tristate "Hash functions: SHA3-224 and SHA3-256"
-	select CRYPTO_HASH
-	help
-	  SHA3-224 and SHA3-256 secure hash algorithms (FIPS 202)
-
-	  Architecture: s390
-
-	  It is available as of z14.
-
-config CRYPTO_SHA3_512_S390
-	tristate "Hash functions: SHA3-384 and SHA3-512"
-	select CRYPTO_HASH
-	help
-	  SHA3-384 and SHA3-512 secure hash algorithms (FIPS 202)
-
-	  Architecture: s390
-
-	  It is available as of z14.
-
 config CRYPTO_GHASH_S390
 	tristate "Hash functions: GHASH"
 	select CRYPTO_HASH
 	help
 	  GCM GHASH hash function (NIST SP800-38D)
diff --git a/arch/s390/crypto/Makefile b/arch/s390/crypto/Makefile
index 998f4b656b18e..387a229e10381 100644
--- a/arch/s390/crypto/Makefile
+++ b/arch/s390/crypto/Makefile
@@ -1,12 +1,10 @@
 # SPDX-License-Identifier: GPL-2.0
 #
 # Cryptographic API
 #
 
-obj-$(CONFIG_CRYPTO_SHA3_256_S390) += sha3_256_s390.o sha_common.o
-obj-$(CONFIG_CRYPTO_SHA3_512_S390) += sha3_512_s390.o sha_common.o
 obj-$(CONFIG_CRYPTO_DES_S390) += des_s390.o
 obj-$(CONFIG_CRYPTO_AES_S390) += aes_s390.o
 obj-$(CONFIG_CRYPTO_PAES_S390) += paes_s390.o
 obj-$(CONFIG_S390_PRNG) += prng.o
 obj-$(CONFIG_CRYPTO_GHASH_S390) += ghash_s390.o
diff --git a/arch/s390/crypto/sha.h b/arch/s390/crypto/sha.h
deleted file mode 100644
index b9cd9572dd35c..0000000000000
--- a/arch/s390/crypto/sha.h
+++ /dev/null
@@ -1,51 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0+ */
-/*
- * Cryptographic API.
- *
- * s390 generic implementation of the SHA Secure Hash Algorithms.
- *
- * Copyright IBM Corp. 2007
- * Author(s): Jan Glauber (jang@de.ibm.com)
- */
-#ifndef _CRYPTO_ARCH_S390_SHA_H
-#define _CRYPTO_ARCH_S390_SHA_H
-
-#include <crypto/hash.h>
-#include <crypto/sha2.h>
-#include <crypto/sha3.h>
-#include <linux/build_bug.h>
-#include <linux/types.h>
-
-/* must be big enough for the largest SHA variant */
-#define CPACF_MAX_PARMBLOCK_SIZE	SHA3_STATE_SIZE
-#define SHA_MAX_BLOCK_SIZE		SHA3_224_BLOCK_SIZE
-
-struct s390_sha_ctx {
-	u64 count;		/* message length in bytes */
-	union {
-		u32 state[CPACF_MAX_PARMBLOCK_SIZE / sizeof(u32)];
-		struct {
-			u64 state[SHA512_DIGEST_SIZE / sizeof(u64)];
-			u64 count_hi;
-		} sha512;
-		struct {
-			__le64 state[SHA3_STATE_SIZE / sizeof(u64)];
-		} sha3;
-	};
-	int func;		/* KIMD function to use */
-	bool first_message_part;
-};
-
-struct shash_desc;
-
-int s390_sha_update_blocks(struct shash_desc *desc, const u8 *data,
-			   unsigned int len);
-int s390_sha_finup(struct shash_desc *desc, const u8 *src, unsigned int len,
-		   u8 *out);
-
-static inline void __check_s390_sha_ctx_size(void)
-{
-	BUILD_BUG_ON(S390_SHA_CTX_SIZE != sizeof(struct s390_sha_ctx));
-}
-
-#endif
diff --git a/arch/s390/crypto/sha3_256_s390.c b/arch/s390/crypto/sha3_256_s390.c
deleted file mode 100644
index fd5ecae60a572..0000000000000
--- a/arch/s390/crypto/sha3_256_s390.c
+++ /dev/null
@@ -1,157 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0+
-/*
- * Cryptographic API.
- *
- * s390 implementation of the SHA256 and SHA224 Secure Hash Algorithm.
- *
- * s390 Version:
- *   Copyright IBM Corp. 2019
- *   Author(s): Joerg Schmidbauer (jschmidb@de.ibm.com)
- */
-#include <asm/cpacf.h>
-#include <crypto/internal/hash.h>
-#include <crypto/sha3.h>
-#include <linux/cpufeature.h>
-#include <linux/errno.h>
-#include <linux/kernel.h>
-#include <linux/module.h>
-#include <linux/string.h>
-
-#include "sha.h"
-
-static int s390_sha3_256_init(struct shash_desc *desc)
-{
-	struct s390_sha_ctx *sctx = shash_desc_ctx(desc);
-
-	sctx->first_message_part = test_facility(86);
-	if (!sctx->first_message_part)
-		memset(sctx->state, 0, sizeof(sctx->state));
-	sctx->count = 0;
-	sctx->func = CPACF_KIMD_SHA3_256;
-
-	return 0;
-}
-
-static int s390_sha3_256_export(struct shash_desc *desc, void *out)
-{
-	struct s390_sha_ctx *sctx = shash_desc_ctx(desc);
-	union {
-		u8 *u8;
-		u64 *u64;
-	} p = { .u8 = out };
-	int i;
-
-	if (sctx->first_message_part) {
-		memset(out, 0, SHA3_STATE_SIZE);
-		return 0;
-	}
-	for (i = 0; i < SHA3_STATE_SIZE / 8; i++)
-		put_unaligned(le64_to_cpu(sctx->sha3.state[i]), p.u64++);
-	return 0;
-}
-
-static int s390_sha3_256_import(struct shash_desc *desc, const void *in)
-{
-	struct s390_sha_ctx *sctx = shash_desc_ctx(desc);
-	union {
-		const u8 *u8;
-		const u64 *u64;
-	} p = { .u8 = in };
-	int i;
-
-	for (i = 0; i < SHA3_STATE_SIZE / 8; i++)
-		sctx->sha3.state[i] = cpu_to_le64(get_unaligned(p.u64++));
-	sctx->count = 0;
-	sctx->first_message_part = 0;
-	sctx->func = CPACF_KIMD_SHA3_256;
-
-	return 0;
-}
-
-static int s390_sha3_224_import(struct shash_desc *desc, const void *in)
-{
-	struct s390_sha_ctx *sctx = shash_desc_ctx(desc);
-
-	s390_sha3_256_import(desc, in);
-	sctx->func = CPACF_KIMD_SHA3_224;
-	return 0;
-}
-
-static struct shash_alg sha3_256_alg = {
-	.digestsize	=	SHA3_256_DIGEST_SIZE,	   /* = 32 */
-	.init		=	s390_sha3_256_init,
-	.update		=	s390_sha_update_blocks,
-	.finup		=	s390_sha_finup,
-	.export		=	s390_sha3_256_export,
-	.import		=	s390_sha3_256_import,
-	.descsize	=	S390_SHA_CTX_SIZE,
-	.statesize	=	SHA3_STATE_SIZE,
-	.base		=	{
-		.cra_name	 =	"sha3-256",
-		.cra_driver_name =	"sha3-256-s390",
-		.cra_priority	 =	300,
-		.cra_flags	 =	CRYPTO_AHASH_ALG_BLOCK_ONLY,
-		.cra_blocksize	 =	SHA3_256_BLOCK_SIZE,
-		.cra_module	 =	THIS_MODULE,
-	}
-};
-
-static int s390_sha3_224_init(struct shash_desc *desc)
-{
-	struct s390_sha_ctx *sctx = shash_desc_ctx(desc);
-
-	s390_sha3_256_init(desc);
-	sctx->func = CPACF_KIMD_SHA3_224;
-	return 0;
-}
-
-static struct shash_alg sha3_224_alg = {
-	.digestsize	=	SHA3_224_DIGEST_SIZE,
-	.init		=	s390_sha3_224_init,
-	.update		=	s390_sha_update_blocks,
-	.finup		=	s390_sha_finup,
-	.export		=	s390_sha3_256_export, /* same as for 256 */
-	.import		=	s390_sha3_224_import, /* function code different! */
-	.descsize	=	S390_SHA_CTX_SIZE,
-	.statesize	=	SHA3_STATE_SIZE,
-	.base		=	{
-		.cra_name	 =	"sha3-224",
-		.cra_driver_name =	"sha3-224-s390",
-		.cra_priority	 =	300,
-		.cra_flags	 =	CRYPTO_AHASH_ALG_BLOCK_ONLY,
-		.cra_blocksize	 =	SHA3_224_BLOCK_SIZE,
-		.cra_module	 =	THIS_MODULE,
-	}
-};
-
-static int __init sha3_256_s390_init(void)
-{
-	int ret;
-
-	if (!cpacf_query_func(CPACF_KIMD, CPACF_KIMD_SHA3_256))
-		return -ENODEV;
-
-	ret = crypto_register_shash(&sha3_256_alg);
-	if (ret < 0)
-		goto out;
-
-	ret = crypto_register_shash(&sha3_224_alg);
-	if (ret < 0)
-		crypto_unregister_shash(&sha3_256_alg);
-out:
-	return ret;
-}
-
-static void __exit sha3_256_s390_fini(void)
-{
-	crypto_unregister_shash(&sha3_224_alg);
-	crypto_unregister_shash(&sha3_256_alg);
-}
-
-module_cpu_feature_match(S390_CPU_FEATURE_MSA, sha3_256_s390_init);
-module_exit(sha3_256_s390_fini);
-
-MODULE_ALIAS_CRYPTO("sha3-256");
-MODULE_ALIAS_CRYPTO("sha3-224");
-MODULE_LICENSE("GPL");
-MODULE_DESCRIPTION("SHA3-256 and SHA3-224 Secure Hash Algorithm");
diff --git a/arch/s390/crypto/sha3_512_s390.c b/arch/s390/crypto/sha3_512_s390.c
deleted file mode 100644
index f4b52a3a04339..0000000000000
--- a/arch/s390/crypto/sha3_512_s390.c
+++ /dev/null
@@ -1,157 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0+
-/*
- * Cryptographic API.
- *
- * s390 implementation of the SHA512 and SHA384 Secure Hash Algorithm.
- *
- * Copyright IBM Corp. 2019
- * Author(s): Joerg Schmidbauer (jschmidb@de.ibm.com)
- */
-#include <asm/cpacf.h>
-#include <crypto/internal/hash.h>
-#include <crypto/sha3.h>
-#include <linux/cpufeature.h>
-#include <linux/errno.h>
-#include <linux/kernel.h>
-#include <linux/module.h>
-#include <linux/string.h>
-
-#include "sha.h"
-
-static int s390_sha3_512_init(struct shash_desc *desc)
-{
-	struct s390_sha_ctx *sctx = shash_desc_ctx(desc);
-
-	sctx->first_message_part = test_facility(86);
-	if (!sctx->first_message_part)
-		memset(sctx->state, 0, sizeof(sctx->state));
-	sctx->count = 0;
-	sctx->func = CPACF_KIMD_SHA3_512;
-
-	return 0;
-}
-
-static int s390_sha3_512_export(struct shash_desc *desc, void *out)
-{
-	struct s390_sha_ctx *sctx = shash_desc_ctx(desc);
-	union {
-		u8 *u8;
-		u64 *u64;
-	} p = { .u8 = out };
-	int i;
-
-	if (sctx->first_message_part) {
-		memset(out, 0, SHA3_STATE_SIZE);
-		return 0;
-	}
-	for (i = 0; i < SHA3_STATE_SIZE / 8; i++)
-		put_unaligned(le64_to_cpu(sctx->sha3.state[i]), p.u64++);
-	return 0;
-}
-
-static int s390_sha3_512_import(struct shash_desc *desc, const void *in)
-{
-	struct s390_sha_ctx *sctx = shash_desc_ctx(desc);
-	union {
-		const u8 *u8;
-		const u64 *u64;
-	} p = { .u8 = in };
-	int i;
-
-	for (i = 0; i < SHA3_STATE_SIZE / 8; i++)
-		sctx->sha3.state[i] = cpu_to_le64(get_unaligned(p.u64++));
-	sctx->count = 0;
-	sctx->first_message_part = 0;
-	sctx->func = CPACF_KIMD_SHA3_512;
-
-	return 0;
-}
-
-static int s390_sha3_384_import(struct shash_desc *desc, const void *in)
-{
-	struct s390_sha_ctx *sctx = shash_desc_ctx(desc);
-
-	s390_sha3_512_import(desc, in);
-	sctx->func = CPACF_KIMD_SHA3_384;
-	return 0;
-}
-
-static struct shash_alg sha3_512_alg = {
-	.digestsize	=	SHA3_512_DIGEST_SIZE,
-	.init		=	s390_sha3_512_init,
-	.update		=	s390_sha_update_blocks,
-	.finup		=	s390_sha_finup,
-	.export		=	s390_sha3_512_export,
-	.import		=	s390_sha3_512_import,
-	.descsize	=	S390_SHA_CTX_SIZE,
-	.statesize	=	SHA3_STATE_SIZE,
-	.base		=	{
-		.cra_name	 =	"sha3-512",
-		.cra_driver_name =	"sha3-512-s390",
-		.cra_priority	 =	300,
-		.cra_flags	 =	CRYPTO_AHASH_ALG_BLOCK_ONLY,
-		.cra_blocksize	 =	SHA3_512_BLOCK_SIZE,
-		.cra_module	 =	THIS_MODULE,
-	}
-};
-
-MODULE_ALIAS_CRYPTO("sha3-512");
-
-static int s390_sha3_384_init(struct shash_desc *desc)
-{
-	struct s390_sha_ctx *sctx = shash_desc_ctx(desc);
-
-	s390_sha3_512_init(desc);
-	sctx->func = CPACF_KIMD_SHA3_384;
-	return 0;
-}
-
-static struct shash_alg sha3_384_alg = {
-	.digestsize	=	SHA3_384_DIGEST_SIZE,
-	.init		=	s390_sha3_384_init,
-	.update		=	s390_sha_update_blocks,
-	.finup		=	s390_sha_finup,
-	.export		=	s390_sha3_512_export, /* same as for 512 */
-	.import		=	s390_sha3_384_import, /* function code different! */
-	.descsize	=	S390_SHA_CTX_SIZE,
-	.statesize	=	SHA3_STATE_SIZE,
-	.base		=	{
-		.cra_name	 =	"sha3-384",
-		.cra_driver_name =	"sha3-384-s390",
-		.cra_priority	 =	300,
-		.cra_flags	 =	CRYPTO_AHASH_ALG_BLOCK_ONLY,
-		.cra_blocksize	 =	SHA3_384_BLOCK_SIZE,
-		.cra_ctxsize	 =	sizeof(struct s390_sha_ctx),
-		.cra_module	 =	THIS_MODULE,
-	}
-};
-
-MODULE_ALIAS_CRYPTO("sha3-384");
-
-static int __init init(void)
-{
-	int ret;
-
-	if (!cpacf_query_func(CPACF_KIMD, CPACF_KIMD_SHA3_512))
-		return -ENODEV;
-	ret = crypto_register_shash(&sha3_512_alg);
-	if (ret < 0)
-		goto out;
-	ret = crypto_register_shash(&sha3_384_alg);
-	if (ret < 0)
-		crypto_unregister_shash(&sha3_512_alg);
-out:
-	return ret;
-}
-
-static void __exit fini(void)
-{
-	crypto_unregister_shash(&sha3_512_alg);
-	crypto_unregister_shash(&sha3_384_alg);
-}
-
-module_cpu_feature_match(S390_CPU_FEATURE_MSA, init);
-module_exit(fini);
-
-MODULE_LICENSE("GPL");
-MODULE_DESCRIPTION("SHA3-512 and SHA3-384 Secure Hash Algorithm");
diff --git a/arch/s390/crypto/sha_common.c b/arch/s390/crypto/sha_common.c
deleted file mode 100644
index d6f8396187946..0000000000000
--- a/arch/s390/crypto/sha_common.c
+++ /dev/null
@@ -1,117 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0+
-/*
- * Cryptographic API.
- *
- * s390 generic implementation of the SHA Secure Hash Algorithms.
- *
- * Copyright IBM Corp. 2007
- * Author(s): Jan Glauber (jang@de.ibm.com)
- */
-
-#include <crypto/internal/hash.h>
-#include <linux/export.h>
-#include <linux/module.h>
-#include <asm/cpacf.h>
-#include "sha.h"
-
-int s390_sha_update_blocks(struct shash_desc *desc, const u8 *data,
-			   unsigned int len)
-{
-	unsigned int bsize = crypto_shash_blocksize(desc->tfm);
-	struct s390_sha_ctx *ctx = shash_desc_ctx(desc);
-	unsigned int n;
-	int fc;
-
-	fc = ctx->func;
-	if (ctx->first_message_part)
-		fc |= CPACF_KIMD_NIP;
-
-	/* process as many blocks as possible */
-	n = (len / bsize) * bsize;
-	ctx->count += n;
-	switch (ctx->func) {
-	case CPACF_KLMD_SHA_512:
-	case CPACF_KLMD_SHA3_384:
-		if (ctx->count < n)
-			ctx->sha512.count_hi++;
-		break;
-	}
-	cpacf_kimd(fc, ctx->state, data, n);
-	ctx->first_message_part = 0;
-	return len - n;
-}
-EXPORT_SYMBOL_GPL(s390_sha_update_blocks);
-
-static int s390_crypto_shash_parmsize(int func)
-{
-	switch (func) {
-	case CPACF_KLMD_SHA_1:
-		return 20;
-	case CPACF_KLMD_SHA_256:
-		return 32;
-	case CPACF_KLMD_SHA_512:
-		return 64;
-	case CPACF_KLMD_SHA3_224:
-	case CPACF_KLMD_SHA3_256:
-	case CPACF_KLMD_SHA3_384:
-	case CPACF_KLMD_SHA3_512:
-		return 200;
-	default:
-		return -EINVAL;
-	}
-}
-
-int s390_sha_finup(struct shash_desc *desc, const u8 *src, unsigned int len,
-		   u8 *out)
-{
-	struct s390_sha_ctx *ctx = shash_desc_ctx(desc);
-	int mbl_offset, fc;
-	u64 bits;
-
-	ctx->count += len;
-
-	bits = ctx->count * 8;
-	mbl_offset = s390_crypto_shash_parmsize(ctx->func);
-	if (mbl_offset < 0)
-		return -EINVAL;
-
-	mbl_offset = mbl_offset / sizeof(u32);
-
-	/* set total msg bit length (mbl) in CPACF parmblock */
-	switch (ctx->func) {
-	case CPACF_KLMD_SHA_512:
-		/* The SHA512 parmblock has a 128-bit mbl field. */
-		if (ctx->count < len)
-			ctx->sha512.count_hi++;
-		ctx->sha512.count_hi <<= 3;
-		ctx->sha512.count_hi |= ctx->count >> 61;
-		mbl_offset += sizeof(u64) / sizeof(u32);
-		fallthrough;
-	case CPACF_KLMD_SHA_1:
-	case CPACF_KLMD_SHA_256:
-		memcpy(ctx->state + mbl_offset, &bits, sizeof(bits));
-		break;
-	case CPACF_KLMD_SHA3_224:
-	case CPACF_KLMD_SHA3_256:
-	case CPACF_KLMD_SHA3_384:
-	case CPACF_KLMD_SHA3_512:
-		break;
-	default:
-		return -EINVAL;
-	}
-
-	fc = ctx->func;
-	fc |= test_facility(86) ? CPACF_KLMD_DUFOP : 0;
-	if (ctx->first_message_part)
-		fc |= CPACF_KLMD_NIP;
-	cpacf_klmd(fc, ctx->state, src, len);
-
-	/* copy digest to out */
-	memcpy(out, ctx->state, crypto_shash_digestsize(desc->tfm));
-
-	return 0;
-}
-EXPORT_SYMBOL_GPL(s390_sha_finup);
-
-MODULE_LICENSE("GPL");
-MODULE_DESCRIPTION("s390 SHA cipher common functions");
diff --git a/lib/crypto/Kconfig b/lib/crypto/Kconfig
index 544eb67fe70f4..36bb4b94d0123 100644
--- a/lib/crypto/Kconfig
+++ b/lib/crypto/Kconfig
@@ -193,10 +193,11 @@ config CRYPTO_LIB_SHA3
 
 config CRYPTO_LIB_SHA3_ARCH
 	bool
 	depends on CRYPTO_LIB_SHA3 && !UML
 	default y if ARM64 && KERNEL_MODE_NEON
+	default y if S390
 
 config CRYPTO_LIB_SM3
 	tristate
 
 source "lib/crypto/tests/Kconfig"
diff --git a/lib/crypto/s390/sha3.h b/lib/crypto/s390/sha3.h
new file mode 100644
index 0000000000000..c08a192cc01a0
--- /dev/null
+++ b/lib/crypto/s390/sha3.h
@@ -0,0 +1,76 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/*
+ * SHA-3 optimized using the CP Assist for Cryptographic Functions (CPACF)
+ *
+ * Copyright 2025 Google LLC
+ */
+#include <asm/cpacf.h>
+#include <linux/cpufeature.h>
+
+static __ro_after_init DEFINE_STATIC_KEY_FALSE(have_cpacf_sha3_256);
+static __ro_after_init DEFINE_STATIC_KEY_FALSE(have_cpacf_sha3_512);
+
+static void sha3_absorb_blocks(struct __sha3_ctx *ctx,
+			       const u8 *data, size_t nblocks)
+{
+	/*
+	 * Note that since the library functions keep the sha3_state in little
+	 * endian order, there is no need to convert it to little endian before
+	 * invoking CPACF_KIMD_SHA3_*, which also assume little endian order.
+	 */
+	if (static_branch_likely(&have_cpacf_sha3_256)) {
+		if (ctx->block_size == SHA3_224_BLOCK_SIZE) {
+			cpacf_kimd(CPACF_KIMD_SHA3_224, &ctx->state, data,
+				   nblocks * SHA3_224_BLOCK_SIZE);
+			return;
+		}
+		if (ctx->block_size == SHA3_256_BLOCK_SIZE) {
+			cpacf_kimd(CPACF_KIMD_SHA3_256, &ctx->state, data,
+				   nblocks * SHA3_256_BLOCK_SIZE);
+			return;
+		}
+	}
+	if (static_branch_likely(&have_cpacf_sha3_512)) {
+		if (ctx->block_size == SHA3_384_BLOCK_SIZE) {
+			cpacf_kimd(CPACF_KIMD_SHA3_384, &ctx->state, data,
+				   nblocks * SHA3_384_BLOCK_SIZE);
+			return;
+		}
+		if (ctx->block_size == SHA3_512_BLOCK_SIZE) {
+			cpacf_kimd(CPACF_KIMD_SHA3_512, &ctx->state, data,
+				   nblocks * SHA3_512_BLOCK_SIZE);
+			return;
+		}
+	}
+	sha3_absorb_blocks_generic(ctx, data, nblocks);
+}
+
+static void sha3_keccakf(struct sha3_state *state)
+{
+	if (static_branch_likely(&have_cpacf_sha3_512)) {
+		/*
+		 * Passing zeroes into any of CPACF_KIMD_SHA3_* gives the plain
+		 * Keccak-f permutation, which is what we want here.  Use
+		 * SHA3-512 since it has the smallest block size.
+		 *
+		 * Also, as in sha3_absorb_blocks(), the state needn't be
+		 * converted to little endian.  It already is little endian.
+		 */
+		static const u8 zeroes[SHA3_512_BLOCK_SIZE];
+
+		cpacf_kimd(CPACF_KIMD_SHA3_512, state, zeroes, sizeof(zeroes));
+	} else {
+		sha3_keccakf_generic(state);
+	}
+}
+
+#define sha3_mod_init_arch sha3_mod_init_arch
+static void sha3_mod_init_arch(void)
+{
+	if (cpu_have_feature(S390_CPU_FEATURE_MSA)) {
+		if (cpacf_query_func(CPACF_KIMD, CPACF_KIMD_SHA3_256))
+			static_branch_enable(&have_cpacf_sha3_256);
+		if (cpacf_query_func(CPACF_KIMD, CPACF_KIMD_SHA3_512))
+			static_branch_enable(&have_cpacf_sha3_512);
+	}
+}
-- 
2.51.1.dirty

