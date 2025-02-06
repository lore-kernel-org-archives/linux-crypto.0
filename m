Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EACB18B495;
	Thu,  6 Feb 2025 17:40:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738863646; cv=none; b=MKiAr/vq01fRGZSU7nMKh4tFEUDS79p7k0PeI7kNpDKSQntZeaPNg4vwPhwZJJss786PIib3eTfFmsETm9LdOiF/VCPFmj+N/xJp19fmMzSM1+hNIuEizDV0Pkhj10/3fO/wtyWUYOd0j0tixmrRN6NZONYp+NbgfkXVq/+UMS4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738863646; c=relaxed/simple;
	bh=9XEHIuq06+lxj6J1+JcZdq0CfIy1Luj2cwPq5GtuyCc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=nvq3SmwVl1st4eg/MrQaMQ2AZ38GgQkmf1FJfnli/dDYz0doBDYycji45dfQnJfPjaVHnWa1UPQMRbDwOwvOKZrhcTIH5nopT7lSQz9O/Wtyxg+PlvFNF3wzwr9iGor00J+rKR+RrV1OHLjuhxTJ0tYUt54HM7+A/EMJ/Q2VHjM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cVV2dRSx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cVV2dRSx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D286C4CEE2;
	Thu,  6 Feb 2025 17:40:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738863646;
	bh=9XEHIuq06+lxj6J1+JcZdq0CfIy1Luj2cwPq5GtuyCc=;
	h=From:To:Cc:Subject:Date:From;
	b=cVV2dRSxQ23R1eGlathlcidC3I4bwfS1rB6Ygt/Sh4sPDqDpvRHy5sdglTz+Lgv7S
	 zbmeQfx5SeU70d1q1nrbv1WNQVAmKDJgX/cEPV0Cwy1TU54XEIV/jBPyS+V9u6uAON
	 EYxD8t3g+TCzG6JULEA48mfe5qzUNZhuq1Ws0d2hzo1EUpX5YkDLNlEvoxXrM1t2r0
	 mrOTlcNiqjjTXvZMgUD3C6ztxyKKmCjERvVYSq7g2RvUHkgzwEcvDrwdNunKsSQyAy
	 IzGsIpiryvO2re/EPFW7lKp2LLv3l+wOuwxWtzVyZnsGVP8NzCBOCoo4TcBQt0dZFp
	 2avfFvEf9oAYg==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: linux-crypto@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	dm-devel@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH] crypto: crct10dif - remove from crypto API
Date: Thu,  6 Feb 2025 09:38:57 -0800
Message-ID: <20250206173857.39794-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Eric Biggers <ebiggers@google.com>

Remove the "crct10dif" shash algorithm from the crypto API.  It has no
known user now that the lib is no longer built on top of it.  It has no
remaining references in kernel code.  The only other potential users
would be the usual components that allow specifying arbitrary hash
algorithms by name, namely AF_ALG and dm-integrity.   However there are
no indications that "crct10dif" is being used with these components.
Debian Code Search and web searches don't find anything relevant, and
explicitly grepping the source code of the usual suspects (cryptsetup,
libell, iwd) finds no matches either.  "crc32" and "crc32c" are used in
a few more places, but that doesn't seem to be the case for "crct10dif".

crc_t10dif_update() is also tested by crc_kunit now, so the test
coverage provided via the crypto self-tests is no longer needed.

Also note that the "crct10dif" shash algorithm was inconsistent with the
rest of the shash API in that it wrote the digest in CPU endianness,
making the resulting byte array differ on little endian vs. big endian
platforms.  This means it was effectively just built for use by the lib
functions, and it was not actually correct to treat it as "just another
hash function" that could be dropped in via the shash API.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---

I'm planning to take this via the crc tree.

 arch/mips/configs/decstation_64_defconfig     |   1 -
 arch/mips/configs/decstation_defconfig        |   1 -
 arch/mips/configs/decstation_r4k_defconfig    |   1 -
 crypto/Kconfig                                |   9 -
 crypto/Makefile                               |   2 -
 crypto/crct10dif_generic.c                    | 168 ----------
 crypto/tcrypt.c                               |   8 -
 crypto/testmgr.c                              |   7 -
 crypto/testmgr.h                              | 288 ------------------
 include/linux/crc-t10dif.h                    |   3 -
 .../testing/selftests/arm64/fp/kernel-test.c  |   1 -
 11 files changed, 489 deletions(-)
 delete mode 100644 crypto/crct10dif_generic.c

diff --git a/arch/mips/configs/decstation_64_defconfig b/arch/mips/configs/decstation_64_defconfig
index da51b9731db0e..9655567614aa2 100644
--- a/arch/mips/configs/decstation_64_defconfig
+++ b/arch/mips/configs/decstation_64_defconfig
@@ -178,11 +178,10 @@ CONFIG_CRYPTO_OFB=m
 CONFIG_CRYPTO_PCBC=m
 CONFIG_CRYPTO_XTS=m
 CONFIG_CRYPTO_CMAC=m
 CONFIG_CRYPTO_XCBC=m
 CONFIG_CRYPTO_CRC32=m
-CONFIG_CRYPTO_CRCT10DIF=m
 CONFIG_CRYPTO_MD4=m
 CONFIG_CRYPTO_MICHAEL_MIC=m
 CONFIG_CRYPTO_RMD160=m
 CONFIG_CRYPTO_SHA512=m
 CONFIG_CRYPTO_WP512=m
diff --git a/arch/mips/configs/decstation_defconfig b/arch/mips/configs/decstation_defconfig
index 424e3f011fc2a..1539fe8eb34d0 100644
--- a/arch/mips/configs/decstation_defconfig
+++ b/arch/mips/configs/decstation_defconfig
@@ -173,11 +173,10 @@ CONFIG_CRYPTO_OFB=m
 CONFIG_CRYPTO_PCBC=m
 CONFIG_CRYPTO_XTS=m
 CONFIG_CRYPTO_CMAC=m
 CONFIG_CRYPTO_XCBC=m
 CONFIG_CRYPTO_CRC32=m
-CONFIG_CRYPTO_CRCT10DIF=m
 CONFIG_CRYPTO_MD4=m
 CONFIG_CRYPTO_MICHAEL_MIC=m
 CONFIG_CRYPTO_RMD160=m
 CONFIG_CRYPTO_SHA512=m
 CONFIG_CRYPTO_WP512=m
diff --git a/arch/mips/configs/decstation_r4k_defconfig b/arch/mips/configs/decstation_r4k_defconfig
index cfc8bf7917924..58c36720c94a4 100644
--- a/arch/mips/configs/decstation_r4k_defconfig
+++ b/arch/mips/configs/decstation_r4k_defconfig
@@ -173,11 +173,10 @@ CONFIG_CRYPTO_OFB=m
 CONFIG_CRYPTO_PCBC=m
 CONFIG_CRYPTO_XTS=m
 CONFIG_CRYPTO_CMAC=m
 CONFIG_CRYPTO_XCBC=m
 CONFIG_CRYPTO_CRC32=m
-CONFIG_CRYPTO_CRCT10DIF=m
 CONFIG_CRYPTO_MD4=m
 CONFIG_CRYPTO_MICHAEL_MIC=m
 CONFIG_CRYPTO_RMD160=m
 CONFIG_CRYPTO_SHA512=m
 CONFIG_CRYPTO_WP512=m
diff --git a/crypto/Kconfig b/crypto/Kconfig
index 9ffb59b1aac3b..b8a436edf4c3c 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -1079,19 +1079,10 @@ config CRYPTO_CRC32
 	help
 	  CRC32 CRC algorithm (IEEE 802.3)
 
 	  Used by RoCEv2 and f2fs.
 
-config CRYPTO_CRCT10DIF
-	tristate "CRCT10DIF"
-	select CRYPTO_HASH
-	select CRC_T10DIF
-	help
-	  CRC16 CRC algorithm used for the T10 (SCSI) Data Integrity Field (DIF)
-
-	  CRC algorithm used by the SCSI Block Commands standard.
-
 endmenu
 
 menu "Compression"
 
 config CRYPTO_DEFLATE
diff --git a/crypto/Makefile b/crypto/Makefile
index d3b79b8c90222..2f7d64eeb0080 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -153,12 +153,10 @@ obj-$(CONFIG_CRYPTO_DEFLATE) += deflate.o
 obj-$(CONFIG_CRYPTO_MICHAEL_MIC) += michael_mic.o
 obj-$(CONFIG_CRYPTO_CRC32C) += crc32c_generic.o
 obj-$(CONFIG_CRYPTO_CRC32) += crc32_generic.o
 CFLAGS_crc32c_generic.o += -DARCH=$(ARCH)
 CFLAGS_crc32_generic.o += -DARCH=$(ARCH)
-obj-$(CONFIG_CRYPTO_CRCT10DIF) += crct10dif_generic.o
-CFLAGS_crct10dif_generic.o += -DARCH=$(ARCH)
 obj-$(CONFIG_CRYPTO_AUTHENC) += authenc.o authencesn.o
 obj-$(CONFIG_CRYPTO_LZO) += lzo.o lzo-rle.o
 obj-$(CONFIG_CRYPTO_LZ4) += lz4.o
 obj-$(CONFIG_CRYPTO_LZ4HC) += lz4hc.o
 obj-$(CONFIG_CRYPTO_XXHASH) += xxhash_generic.o
diff --git a/crypto/crct10dif_generic.c b/crypto/crct10dif_generic.c
deleted file mode 100644
index 259cb01932cb5..0000000000000
--- a/crypto/crct10dif_generic.c
+++ /dev/null
@@ -1,168 +0,0 @@
-/*
- * Cryptographic API.
- *
- * T10 Data Integrity Field CRC16 Crypto Transform
- *
- * Copyright (c) 2007 Oracle Corporation.  All rights reserved.
- * Written by Martin K. Petersen <martin.petersen@oracle.com>
- * Copyright (C) 2013 Intel Corporation
- * Author: Tim Chen <tim.c.chen@linux.intel.com>
- *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of the GNU General Public License as published by the Free
- * Software Foundation; either version 2 of the License, or (at your option)
- * any later version.
- *
- * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
- * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
- * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
- * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
- * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
- * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
- * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
- * SOFTWARE.
- *
- */
-
-#include <linux/module.h>
-#include <linux/crc-t10dif.h>
-#include <crypto/internal/hash.h>
-#include <linux/init.h>
-#include <linux/kernel.h>
-
-struct chksum_desc_ctx {
-	__u16 crc;
-};
-
-/*
- * Steps through buffer one byte at a time, calculates reflected
- * crc using table.
- */
-
-static int chksum_init(struct shash_desc *desc)
-{
-	struct chksum_desc_ctx *ctx = shash_desc_ctx(desc);
-
-	ctx->crc = 0;
-
-	return 0;
-}
-
-static int chksum_update(struct shash_desc *desc, const u8 *data,
-			 unsigned int length)
-{
-	struct chksum_desc_ctx *ctx = shash_desc_ctx(desc);
-
-	ctx->crc = crc_t10dif_generic(ctx->crc, data, length);
-	return 0;
-}
-
-static int chksum_update_arch(struct shash_desc *desc, const u8 *data,
-			      unsigned int length)
-{
-	struct chksum_desc_ctx *ctx = shash_desc_ctx(desc);
-
-	ctx->crc = crc_t10dif_update(ctx->crc, data, length);
-	return 0;
-}
-
-static int chksum_final(struct shash_desc *desc, u8 *out)
-{
-	struct chksum_desc_ctx *ctx = shash_desc_ctx(desc);
-
-	*(__u16 *)out = ctx->crc;
-	return 0;
-}
-
-static int __chksum_finup(__u16 crc, const u8 *data, unsigned int len, u8 *out)
-{
-	*(__u16 *)out = crc_t10dif_generic(crc, data, len);
-	return 0;
-}
-
-static int __chksum_finup_arch(__u16 crc, const u8 *data, unsigned int len,
-			       u8 *out)
-{
-	*(__u16 *)out = crc_t10dif_update(crc, data, len);
-	return 0;
-}
-
-static int chksum_finup(struct shash_desc *desc, const u8 *data,
-			unsigned int len, u8 *out)
-{
-	struct chksum_desc_ctx *ctx = shash_desc_ctx(desc);
-
-	return __chksum_finup(ctx->crc, data, len, out);
-}
-
-static int chksum_finup_arch(struct shash_desc *desc, const u8 *data,
-			     unsigned int len, u8 *out)
-{
-	struct chksum_desc_ctx *ctx = shash_desc_ctx(desc);
-
-	return __chksum_finup_arch(ctx->crc, data, len, out);
-}
-
-static int chksum_digest(struct shash_desc *desc, const u8 *data,
-			 unsigned int length, u8 *out)
-{
-	return __chksum_finup(0, data, length, out);
-}
-
-static int chksum_digest_arch(struct shash_desc *desc, const u8 *data,
-			      unsigned int length, u8 *out)
-{
-	return __chksum_finup_arch(0, data, length, out);
-}
-
-static struct shash_alg algs[] = {{
-	.digestsize		= CRC_T10DIF_DIGEST_SIZE,
-	.init			= chksum_init,
-	.update			= chksum_update,
-	.final			= chksum_final,
-	.finup			= chksum_finup,
-	.digest			= chksum_digest,
-	.descsize		= sizeof(struct chksum_desc_ctx),
-	.base.cra_name		= "crct10dif",
-	.base.cra_driver_name	= "crct10dif-generic",
-	.base.cra_priority	= 100,
-	.base.cra_blocksize	= CRC_T10DIF_BLOCK_SIZE,
-	.base.cra_module	= THIS_MODULE,
-}, {
-	.digestsize		= CRC_T10DIF_DIGEST_SIZE,
-	.init			= chksum_init,
-	.update			= chksum_update_arch,
-	.final			= chksum_final,
-	.finup			= chksum_finup_arch,
-	.digest			= chksum_digest_arch,
-	.descsize		= sizeof(struct chksum_desc_ctx),
-	.base.cra_name		= "crct10dif",
-	.base.cra_driver_name	= "crct10dif-" __stringify(ARCH),
-	.base.cra_priority	= 150,
-	.base.cra_blocksize	= CRC_T10DIF_BLOCK_SIZE,
-	.base.cra_module	= THIS_MODULE,
-}};
-
-static int num_algs;
-
-static int __init crct10dif_mod_init(void)
-{
-	/* register the arch flavor only if it differs from the generic one */
-	num_algs = 1 + crc_t10dif_is_optimized();
-
-	return crypto_register_shashes(algs, num_algs);
-}
-
-static void __exit crct10dif_mod_fini(void)
-{
-	crypto_unregister_shashes(algs, num_algs);
-}
-
-subsys_initcall(crct10dif_mod_init);
-module_exit(crct10dif_mod_fini);
-
-MODULE_AUTHOR("Tim Chen <tim.c.chen@linux.intel.com>");
-MODULE_DESCRIPTION("T10 DIF CRC calculation.");
-MODULE_LICENSE("GPL");
-MODULE_ALIAS_CRYPTO("crct10dif");
-MODULE_ALIAS_CRYPTO("crct10dif-generic");
diff --git a/crypto/tcrypt.c b/crypto/tcrypt.c
index e1a74cb2cfbe4..879fc21dcc166 100644
--- a/crypto/tcrypt.c
+++ b/crypto/tcrypt.c
@@ -1652,14 +1652,10 @@ static int do_test(const char *alg, u32 type, u32 mask, int m, u32 num_mb)
 
 	case 46:
 		ret = min(ret, tcrypt_test("ghash"));
 		break;
 
-	case 47:
-		ret = min(ret, tcrypt_test("crct10dif"));
-		break;
-
 	case 48:
 		ret = min(ret, tcrypt_test("sha3-224"));
 		break;
 
 	case 49:
@@ -2270,14 +2266,10 @@ static int do_test(const char *alg, u32 type, u32 mask, int m, u32 num_mb)
 		fallthrough;
 	case 319:
 		test_hash_speed("crc32c", sec, generic_hash_speed_template);
 		if (mode > 300 && mode < 400) break;
 		fallthrough;
-	case 320:
-		test_hash_speed("crct10dif", sec, generic_hash_speed_template);
-		if (mode > 300 && mode < 400) break;
-		fallthrough;
 	case 321:
 		test_hash_speed("poly1305", sec, poly1305_speed_template);
 		if (mode > 300 && mode < 400) break;
 		fallthrough;
 	case 322:
diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index 0c1c3a6453b6a..1e42582bc7f11 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -4757,17 +4757,10 @@ static const struct alg_test_desc alg_test_descs[] = {
 		.test = alg_test_crc32c,
 		.fips_allowed = 1,
 		.suite = {
 			.hash = __VECS(crc32c_tv_template)
 		}
-	}, {
-		.alg = "crct10dif",
-		.test = alg_test_hash,
-		.fips_allowed = 1,
-		.suite = {
-			.hash = __VECS(crct10dif_tv_template)
-		}
 	}, {
 		.alg = "ctr(aes)",
 		.test = alg_test_skcipher,
 		.fips_allowed = 1,
 		.suite = {
diff --git a/crypto/testmgr.h b/crypto/testmgr.h
index 61c7ae7310528..d3a99d15a3e57 100644
--- a/crypto/testmgr.h
+++ b/crypto/testmgr.h
@@ -6015,298 +6015,10 @@ static const struct hash_testvec rmd160_tv_template[] = {
 		.digest	= "\x94\xc2\x64\x11\x54\x04\xe6\x33\x79\x0d"
 			  "\xfc\xc8\x7b\x58\x7d\x36\x77\x06\x7d\x9f",
 	}
 };
 
-static const struct hash_testvec crct10dif_tv_template[] = {
-	{
-		.plaintext	= "abc",
-		.psize		= 3,
-		.digest		= (u8 *)(u16 []){ 0x443b },
-	}, {
-		.plaintext 	= "1234567890123456789012345678901234567890"
-				  "123456789012345678901234567890123456789",
-		.psize		= 79,
-		.digest 	= (u8 *)(u16 []){ 0x4b70 },
-	}, {
-		.plaintext	= "abcdddddddddddddddddddddddddddddddddddddddd"
-				  "ddddddddddddd",
-		.psize		= 56,
-		.digest		= (u8 *)(u16 []){ 0x9ce3 },
-	}, {
-		.plaintext 	= "1234567890123456789012345678901234567890"
-				  "1234567890123456789012345678901234567890"
-				  "1234567890123456789012345678901234567890"
-				  "1234567890123456789012345678901234567890"
-				  "1234567890123456789012345678901234567890"
-				  "1234567890123456789012345678901234567890"
-				  "1234567890123456789012345678901234567890"
-				  "123456789012345678901234567890123456789",
-		.psize		= 319,
-		.digest		= (u8 *)(u16 []){ 0x44c6 },
-	}, {
-		.plaintext =	"\x6e\x05\x79\x10\xa7\x1b\xb2\x49"
-				"\xe0\x54\xeb\x82\x19\x8d\x24\xbb"
-				"\x2f\xc6\x5d\xf4\x68\xff\x96\x0a"
-				"\xa1\x38\xcf\x43\xda\x71\x08\x7c"
-				"\x13\xaa\x1e\xb5\x4c\xe3\x57\xee"
-				"\x85\x1c\x90\x27\xbe\x32\xc9\x60"
-				"\xf7\x6b\x02\x99\x0d\xa4\x3b\xd2"
-				"\x46\xdd\x74\x0b\x7f\x16\xad\x21"
-				"\xb8\x4f\xe6\x5a\xf1\x88\x1f\x93"
-				"\x2a\xc1\x35\xcc\x63\xfa\x6e\x05"
-				"\x9c\x10\xa7\x3e\xd5\x49\xe0\x77"
-				"\x0e\x82\x19\xb0\x24\xbb\x52\xe9"
-				"\x5d\xf4\x8b\x22\x96\x2d\xc4\x38"
-				"\xcf\x66\xfd\x71\x08\x9f\x13\xaa"
-				"\x41\xd8\x4c\xe3\x7a\x11\x85\x1c"
-				"\xb3\x27\xbe\x55\xec\x60\xf7\x8e"
-				"\x02\x99\x30\xc7\x3b\xd2\x69\x00"
-				"\x74\x0b\xa2\x16\xad\x44\xdb\x4f"
-				"\xe6\x7d\x14\x88\x1f\xb6\x2a\xc1"
-				"\x58\xef\x63\xfa\x91\x05\x9c\x33"
-				"\xca\x3e\xd5\x6c\x03\x77\x0e\xa5"
-				"\x19\xb0\x47\xde\x52\xe9\x80\x17"
-				"\x8b\x22\xb9\x2d\xc4\x5b\xf2\x66"
-				"\xfd\x94\x08\x9f\x36\xcd\x41\xd8"
-				"\x6f\x06\x7a\x11\xa8\x1c\xb3\x4a"
-				"\xe1\x55\xec\x83\x1a\x8e\x25\xbc"
-				"\x30\xc7\x5e\xf5\x69\x00\x97\x0b"
-				"\xa2\x39\xd0\x44\xdb\x72\x09\x7d"
-				"\x14\xab\x1f\xb6\x4d\xe4\x58\xef"
-				"\x86\x1d\x91\x28\xbf\x33\xca\x61"
-				"\xf8\x6c\x03\x9a\x0e\xa5\x3c\xd3"
-				"\x47\xde\x75\x0c\x80\x17\xae\x22"
-				"\xb9\x50\xe7\x5b\xf2\x89\x20\x94"
-				"\x2b\xc2\x36\xcd\x64\xfb\x6f\x06"
-				"\x9d\x11\xa8\x3f\xd6\x4a\xe1\x78"
-				"\x0f\x83\x1a\xb1\x25\xbc\x53\xea"
-				"\x5e\xf5\x8c\x00\x97\x2e\xc5\x39"
-				"\xd0\x67\xfe\x72\x09\xa0\x14\xab"
-				"\x42\xd9\x4d\xe4\x7b\x12\x86\x1d"
-				"\xb4\x28\xbf\x56\xed\x61\xf8\x8f"
-				"\x03\x9a\x31\xc8\x3c\xd3\x6a\x01"
-				"\x75\x0c\xa3\x17\xae\x45\xdc\x50"
-				"\xe7\x7e\x15\x89\x20\xb7\x2b\xc2"
-				"\x59\xf0\x64\xfb\x92\x06\x9d\x34"
-				"\xcb\x3f\xd6\x6d\x04\x78\x0f\xa6"
-				"\x1a\xb1\x48\xdf\x53\xea\x81\x18"
-				"\x8c\x23\xba\x2e\xc5\x5c\xf3\x67"
-				"\xfe\x95\x09\xa0\x37\xce\x42\xd9"
-				"\x70\x07\x7b\x12\xa9\x1d\xb4\x4b"
-				"\xe2\x56\xed\x84\x1b\x8f\x26\xbd"
-				"\x31\xc8\x5f\xf6\x6a\x01\x98\x0c"
-				"\xa3\x3a\xd1\x45\xdc\x73\x0a\x7e"
-				"\x15\xac\x20\xb7\x4e\xe5\x59\xf0"
-				"\x87\x1e\x92\x29\xc0\x34\xcb\x62"
-				"\xf9\x6d\x04\x9b\x0f\xa6\x3d\xd4"
-				"\x48\xdf\x76\x0d\x81\x18\xaf\x23"
-				"\xba\x51\xe8\x5c\xf3\x8a\x21\x95"
-				"\x2c\xc3\x37\xce\x65\xfc\x70\x07"
-				"\x9e\x12\xa9\x40\xd7\x4b\xe2\x79"
-				"\x10\x84\x1b\xb2\x26\xbd\x54\xeb"
-				"\x5f\xf6\x8d\x01\x98\x2f\xc6\x3a"
-				"\xd1\x68\xff\x73\x0a\xa1\x15\xac"
-				"\x43\xda\x4e\xe5\x7c\x13\x87\x1e"
-				"\xb5\x29\xc0\x57\xee\x62\xf9\x90"
-				"\x04\x9b\x32\xc9\x3d\xd4\x6b\x02"
-				"\x76\x0d\xa4\x18\xaf\x46\xdd\x51"
-				"\xe8\x7f\x16\x8a\x21\xb8\x2c\xc3"
-				"\x5a\xf1\x65\xfc\x93\x07\x9e\x35"
-				"\xcc\x40\xd7\x6e\x05\x79\x10\xa7"
-				"\x1b\xb2\x49\xe0\x54\xeb\x82\x19"
-				"\x8d\x24\xbb\x2f\xc6\x5d\xf4\x68"
-				"\xff\x96\x0a\xa1\x38\xcf\x43\xda"
-				"\x71\x08\x7c\x13\xaa\x1e\xb5\x4c"
-				"\xe3\x57\xee\x85\x1c\x90\x27\xbe"
-				"\x32\xc9\x60\xf7\x6b\x02\x99\x0d"
-				"\xa4\x3b\xd2\x46\xdd\x74\x0b\x7f"
-				"\x16\xad\x21\xb8\x4f\xe6\x5a\xf1"
-				"\x88\x1f\x93\x2a\xc1\x35\xcc\x63"
-				"\xfa\x6e\x05\x9c\x10\xa7\x3e\xd5"
-				"\x49\xe0\x77\x0e\x82\x19\xb0\x24"
-				"\xbb\x52\xe9\x5d\xf4\x8b\x22\x96"
-				"\x2d\xc4\x38\xcf\x66\xfd\x71\x08"
-				"\x9f\x13\xaa\x41\xd8\x4c\xe3\x7a"
-				"\x11\x85\x1c\xb3\x27\xbe\x55\xec"
-				"\x60\xf7\x8e\x02\x99\x30\xc7\x3b"
-				"\xd2\x69\x00\x74\x0b\xa2\x16\xad"
-				"\x44\xdb\x4f\xe6\x7d\x14\x88\x1f"
-				"\xb6\x2a\xc1\x58\xef\x63\xfa\x91"
-				"\x05\x9c\x33\xca\x3e\xd5\x6c\x03"
-				"\x77\x0e\xa5\x19\xb0\x47\xde\x52"
-				"\xe9\x80\x17\x8b\x22\xb9\x2d\xc4"
-				"\x5b\xf2\x66\xfd\x94\x08\x9f\x36"
-				"\xcd\x41\xd8\x6f\x06\x7a\x11\xa8"
-				"\x1c\xb3\x4a\xe1\x55\xec\x83\x1a"
-				"\x8e\x25\xbc\x30\xc7\x5e\xf5\x69"
-				"\x00\x97\x0b\xa2\x39\xd0\x44\xdb"
-				"\x72\x09\x7d\x14\xab\x1f\xb6\x4d"
-				"\xe4\x58\xef\x86\x1d\x91\x28\xbf"
-				"\x33\xca\x61\xf8\x6c\x03\x9a\x0e"
-				"\xa5\x3c\xd3\x47\xde\x75\x0c\x80"
-				"\x17\xae\x22\xb9\x50\xe7\x5b\xf2"
-				"\x89\x20\x94\x2b\xc2\x36\xcd\x64"
-				"\xfb\x6f\x06\x9d\x11\xa8\x3f\xd6"
-				"\x4a\xe1\x78\x0f\x83\x1a\xb1\x25"
-				"\xbc\x53\xea\x5e\xf5\x8c\x00\x97"
-				"\x2e\xc5\x39\xd0\x67\xfe\x72\x09"
-				"\xa0\x14\xab\x42\xd9\x4d\xe4\x7b"
-				"\x12\x86\x1d\xb4\x28\xbf\x56\xed"
-				"\x61\xf8\x8f\x03\x9a\x31\xc8\x3c"
-				"\xd3\x6a\x01\x75\x0c\xa3\x17\xae"
-				"\x45\xdc\x50\xe7\x7e\x15\x89\x20"
-				"\xb7\x2b\xc2\x59\xf0\x64\xfb\x92"
-				"\x06\x9d\x34\xcb\x3f\xd6\x6d\x04"
-				"\x78\x0f\xa6\x1a\xb1\x48\xdf\x53"
-				"\xea\x81\x18\x8c\x23\xba\x2e\xc5"
-				"\x5c\xf3\x67\xfe\x95\x09\xa0\x37"
-				"\xce\x42\xd9\x70\x07\x7b\x12\xa9"
-				"\x1d\xb4\x4b\xe2\x56\xed\x84\x1b"
-				"\x8f\x26\xbd\x31\xc8\x5f\xf6\x6a"
-				"\x01\x98\x0c\xa3\x3a\xd1\x45\xdc"
-				"\x73\x0a\x7e\x15\xac\x20\xb7\x4e"
-				"\xe5\x59\xf0\x87\x1e\x92\x29\xc0"
-				"\x34\xcb\x62\xf9\x6d\x04\x9b\x0f"
-				"\xa6\x3d\xd4\x48\xdf\x76\x0d\x81"
-				"\x18\xaf\x23\xba\x51\xe8\x5c\xf3"
-				"\x8a\x21\x95\x2c\xc3\x37\xce\x65"
-				"\xfc\x70\x07\x9e\x12\xa9\x40\xd7"
-				"\x4b\xe2\x79\x10\x84\x1b\xb2\x26"
-				"\xbd\x54\xeb\x5f\xf6\x8d\x01\x98"
-				"\x2f\xc6\x3a\xd1\x68\xff\x73\x0a"
-				"\xa1\x15\xac\x43\xda\x4e\xe5\x7c"
-				"\x13\x87\x1e\xb5\x29\xc0\x57\xee"
-				"\x62\xf9\x90\x04\x9b\x32\xc9\x3d"
-				"\xd4\x6b\x02\x76\x0d\xa4\x18\xaf"
-				"\x46\xdd\x51\xe8\x7f\x16\x8a\x21"
-				"\xb8\x2c\xc3\x5a\xf1\x65\xfc\x93"
-				"\x07\x9e\x35\xcc\x40\xd7\x6e\x05"
-				"\x79\x10\xa7\x1b\xb2\x49\xe0\x54"
-				"\xeb\x82\x19\x8d\x24\xbb\x2f\xc6"
-				"\x5d\xf4\x68\xff\x96\x0a\xa1\x38"
-				"\xcf\x43\xda\x71\x08\x7c\x13\xaa"
-				"\x1e\xb5\x4c\xe3\x57\xee\x85\x1c"
-				"\x90\x27\xbe\x32\xc9\x60\xf7\x6b"
-				"\x02\x99\x0d\xa4\x3b\xd2\x46\xdd"
-				"\x74\x0b\x7f\x16\xad\x21\xb8\x4f"
-				"\xe6\x5a\xf1\x88\x1f\x93\x2a\xc1"
-				"\x35\xcc\x63\xfa\x6e\x05\x9c\x10"
-				"\xa7\x3e\xd5\x49\xe0\x77\x0e\x82"
-				"\x19\xb0\x24\xbb\x52\xe9\x5d\xf4"
-				"\x8b\x22\x96\x2d\xc4\x38\xcf\x66"
-				"\xfd\x71\x08\x9f\x13\xaa\x41\xd8"
-				"\x4c\xe3\x7a\x11\x85\x1c\xb3\x27"
-				"\xbe\x55\xec\x60\xf7\x8e\x02\x99"
-				"\x30\xc7\x3b\xd2\x69\x00\x74\x0b"
-				"\xa2\x16\xad\x44\xdb\x4f\xe6\x7d"
-				"\x14\x88\x1f\xb6\x2a\xc1\x58\xef"
-				"\x63\xfa\x91\x05\x9c\x33\xca\x3e"
-				"\xd5\x6c\x03\x77\x0e\xa5\x19\xb0"
-				"\x47\xde\x52\xe9\x80\x17\x8b\x22"
-				"\xb9\x2d\xc4\x5b\xf2\x66\xfd\x94"
-				"\x08\x9f\x36\xcd\x41\xd8\x6f\x06"
-				"\x7a\x11\xa8\x1c\xb3\x4a\xe1\x55"
-				"\xec\x83\x1a\x8e\x25\xbc\x30\xc7"
-				"\x5e\xf5\x69\x00\x97\x0b\xa2\x39"
-				"\xd0\x44\xdb\x72\x09\x7d\x14\xab"
-				"\x1f\xb6\x4d\xe4\x58\xef\x86\x1d"
-				"\x91\x28\xbf\x33\xca\x61\xf8\x6c"
-				"\x03\x9a\x0e\xa5\x3c\xd3\x47\xde"
-				"\x75\x0c\x80\x17\xae\x22\xb9\x50"
-				"\xe7\x5b\xf2\x89\x20\x94\x2b\xc2"
-				"\x36\xcd\x64\xfb\x6f\x06\x9d\x11"
-				"\xa8\x3f\xd6\x4a\xe1\x78\x0f\x83"
-				"\x1a\xb1\x25\xbc\x53\xea\x5e\xf5"
-				"\x8c\x00\x97\x2e\xc5\x39\xd0\x67"
-				"\xfe\x72\x09\xa0\x14\xab\x42\xd9"
-				"\x4d\xe4\x7b\x12\x86\x1d\xb4\x28"
-				"\xbf\x56\xed\x61\xf8\x8f\x03\x9a"
-				"\x31\xc8\x3c\xd3\x6a\x01\x75\x0c"
-				"\xa3\x17\xae\x45\xdc\x50\xe7\x7e"
-				"\x15\x89\x20\xb7\x2b\xc2\x59\xf0"
-				"\x64\xfb\x92\x06\x9d\x34\xcb\x3f"
-				"\xd6\x6d\x04\x78\x0f\xa6\x1a\xb1"
-				"\x48\xdf\x53\xea\x81\x18\x8c\x23"
-				"\xba\x2e\xc5\x5c\xf3\x67\xfe\x95"
-				"\x09\xa0\x37\xce\x42\xd9\x70\x07"
-				"\x7b\x12\xa9\x1d\xb4\x4b\xe2\x56"
-				"\xed\x84\x1b\x8f\x26\xbd\x31\xc8"
-				"\x5f\xf6\x6a\x01\x98\x0c\xa3\x3a"
-				"\xd1\x45\xdc\x73\x0a\x7e\x15\xac"
-				"\x20\xb7\x4e\xe5\x59\xf0\x87\x1e"
-				"\x92\x29\xc0\x34\xcb\x62\xf9\x6d"
-				"\x04\x9b\x0f\xa6\x3d\xd4\x48\xdf"
-				"\x76\x0d\x81\x18\xaf\x23\xba\x51"
-				"\xe8\x5c\xf3\x8a\x21\x95\x2c\xc3"
-				"\x37\xce\x65\xfc\x70\x07\x9e\x12"
-				"\xa9\x40\xd7\x4b\xe2\x79\x10\x84"
-				"\x1b\xb2\x26\xbd\x54\xeb\x5f\xf6"
-				"\x8d\x01\x98\x2f\xc6\x3a\xd1\x68"
-				"\xff\x73\x0a\xa1\x15\xac\x43\xda"
-				"\x4e\xe5\x7c\x13\x87\x1e\xb5\x29"
-				"\xc0\x57\xee\x62\xf9\x90\x04\x9b"
-				"\x32\xc9\x3d\xd4\x6b\x02\x76\x0d"
-				"\xa4\x18\xaf\x46\xdd\x51\xe8\x7f"
-				"\x16\x8a\x21\xb8\x2c\xc3\x5a\xf1"
-				"\x65\xfc\x93\x07\x9e\x35\xcc\x40"
-				"\xd7\x6e\x05\x79\x10\xa7\x1b\xb2"
-				"\x49\xe0\x54\xeb\x82\x19\x8d\x24"
-				"\xbb\x2f\xc6\x5d\xf4\x68\xff\x96"
-				"\x0a\xa1\x38\xcf\x43\xda\x71\x08"
-				"\x7c\x13\xaa\x1e\xb5\x4c\xe3\x57"
-				"\xee\x85\x1c\x90\x27\xbe\x32\xc9"
-				"\x60\xf7\x6b\x02\x99\x0d\xa4\x3b"
-				"\xd2\x46\xdd\x74\x0b\x7f\x16\xad"
-				"\x21\xb8\x4f\xe6\x5a\xf1\x88\x1f"
-				"\x93\x2a\xc1\x35\xcc\x63\xfa\x6e"
-				"\x05\x9c\x10\xa7\x3e\xd5\x49\xe0"
-				"\x77\x0e\x82\x19\xb0\x24\xbb\x52"
-				"\xe9\x5d\xf4\x8b\x22\x96\x2d\xc4"
-				"\x38\xcf\x66\xfd\x71\x08\x9f\x13"
-				"\xaa\x41\xd8\x4c\xe3\x7a\x11\x85"
-				"\x1c\xb3\x27\xbe\x55\xec\x60\xf7"
-				"\x8e\x02\x99\x30\xc7\x3b\xd2\x69"
-				"\x00\x74\x0b\xa2\x16\xad\x44\xdb"
-				"\x4f\xe6\x7d\x14\x88\x1f\xb6\x2a"
-				"\xc1\x58\xef\x63\xfa\x91\x05\x9c"
-				"\x33\xca\x3e\xd5\x6c\x03\x77\x0e"
-				"\xa5\x19\xb0\x47\xde\x52\xe9\x80"
-				"\x17\x8b\x22\xb9\x2d\xc4\x5b\xf2"
-				"\x66\xfd\x94\x08\x9f\x36\xcd\x41"
-				"\xd8\x6f\x06\x7a\x11\xa8\x1c\xb3"
-				"\x4a\xe1\x55\xec\x83\x1a\x8e\x25"
-				"\xbc\x30\xc7\x5e\xf5\x69\x00\x97"
-				"\x0b\xa2\x39\xd0\x44\xdb\x72\x09"
-				"\x7d\x14\xab\x1f\xb6\x4d\xe4\x58"
-				"\xef\x86\x1d\x91\x28\xbf\x33\xca"
-				"\x61\xf8\x6c\x03\x9a\x0e\xa5\x3c"
-				"\xd3\x47\xde\x75\x0c\x80\x17\xae"
-				"\x22\xb9\x50\xe7\x5b\xf2\x89\x20"
-				"\x94\x2b\xc2\x36\xcd\x64\xfb\x6f"
-				"\x06\x9d\x11\xa8\x3f\xd6\x4a\xe1"
-				"\x78\x0f\x83\x1a\xb1\x25\xbc\x53"
-				"\xea\x5e\xf5\x8c\x00\x97\x2e\xc5"
-				"\x39\xd0\x67\xfe\x72\x09\xa0\x14"
-				"\xab\x42\xd9\x4d\xe4\x7b\x12\x86"
-				"\x1d\xb4\x28\xbf\x56\xed\x61\xf8"
-				"\x8f\x03\x9a\x31\xc8\x3c\xd3\x6a"
-				"\x01\x75\x0c\xa3\x17\xae\x45\xdc"
-				"\x50\xe7\x7e\x15\x89\x20\xb7\x2b"
-				"\xc2\x59\xf0\x64\xfb\x92\x06\x9d"
-				"\x34\xcb\x3f\xd6\x6d\x04\x78\x0f"
-				"\xa6\x1a\xb1\x48\xdf\x53\xea\x81"
-				"\x18\x8c\x23\xba\x2e\xc5\x5c\xf3"
-				"\x67\xfe\x95\x09\xa0\x37\xce\x42"
-				"\xd9\x70\x07\x7b\x12\xa9\x1d\xb4"
-				"\x4b\xe2\x56\xed\x84\x1b\x8f\x26"
-				"\xbd\x31\xc8\x5f\xf6\x6a\x01\x98",
-		.psize = 2048,
-		.digest		= (u8 *)(u16 []){ 0x23ca },
-	}
-};
-
 /*
  * Streebog test vectors from RFC 6986 and GOST R 34.11-2012
  */
 static const struct hash_testvec streebog256_tv_template[] = {
 	{ /* M1 */
diff --git a/include/linux/crc-t10dif.h b/include/linux/crc-t10dif.h
index 16787c1cee21c..d0706544fc11f 100644
--- a/include/linux/crc-t10dif.h
+++ b/include/linux/crc-t10dif.h
@@ -2,13 +2,10 @@
 #ifndef _LINUX_CRC_T10DIF_H
 #define _LINUX_CRC_T10DIF_H
 
 #include <linux/types.h>
 
-#define CRC_T10DIF_DIGEST_SIZE 2
-#define CRC_T10DIF_BLOCK_SIZE 1
-
 u16 crc_t10dif_arch(u16 crc, const u8 *p, size_t len);
 u16 crc_t10dif_generic(u16 crc, const u8 *p, size_t len);
 
 static inline u16 crc_t10dif_update(u16 crc, const u8 *p, size_t len)
 {
diff --git a/tools/testing/selftests/arm64/fp/kernel-test.c b/tools/testing/selftests/arm64/fp/kernel-test.c
index 348e8bef62c7a..e3cec3723ffa9 100644
--- a/tools/testing/selftests/arm64/fp/kernel-test.c
+++ b/tools/testing/selftests/arm64/fp/kernel-test.c
@@ -44,11 +44,10 @@ static void handle_kick_signal(int sig, siginfo_t *info, void *context)
 {
 	sigs++;
 }
 
 static char *drivers[] = {
-	"crct10dif-arm64",
 	"sha1-ce",
 	"sha224-arm64",
 	"sha224-arm64-neon",
 	"sha224-ce",
 	"sha256-arm64",

base-commit: 8c50e1db89da675917fb6297026f46cf32c515d5
-- 
2.48.1

