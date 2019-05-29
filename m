Return-Path: <SRS0=BCrf=T5=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D9FCC28CC2
	for <linux-crypto@archiver.kernel.org>; Wed, 29 May 2019 15:48:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5D8C223BCD
	for <linux-crypto@archiver.kernel.org>; Wed, 29 May 2019 15:48:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726799AbfE2Psb (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 29 May 2019 11:48:31 -0400
Received: from mx2.suse.de ([195.135.220.15]:48334 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726699AbfE2Psb (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 29 May 2019 11:48:31 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 2FF5AAE45;
        Wed, 29 May 2019 15:48:29 +0000 (UTC)
From:   Nikolay Borisov <nborisov@suse.com>
To:     herbert@gondor.apana.org.au
Cc:     davem@davemloft.net, linux-crypto@vger.kernel.org, terrelln@fb.com,
        jthumshirn@suse.de, Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH v3] crypto: xxhash - Implement xxhash support
Date:   Wed, 29 May 2019 18:48:26 +0300
Message-Id: <20190529154826.12147-1-nborisov@suse.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

xxhash is currently implemented as a self-contained module in /lib.
This patch enables that module to be used as part of the generic kernel
crypto framework. It adds a simple wrapper to the 64bit version.

I've also added test vectors (with help from Nick Terrell). The upstream
xxhash code is tested by running hashing operation on random 222 byte
data with seed values of 0 and a prime number. The upstream test
suite can be found at https://github.com/Cyan4973/xxHash/blob/cf46e0c/xxhsum.c#L664

Essentially hashing is run on data of length 0,1,14,222 with the
aforementioned seed values 0 and prime 2654435761. The particular random
222 byte string was provided to me by Nick Terrell by reading
/dev/random and the checksums were calculated by the upstream xxsum
utility with the following bash script:

dd if=/dev/random of=TEST_VECTOR bs=1 count=222

for a in 0 1; do
	for l in 0 1 14 222; do
		for s in 0 2654435761; do
			echo algo $a length $l seed $s;
			head -c $l TEST_VECTOR | ~/projects/kernel/xxHash/xxhsum -H$a -s$s
		done
	done
done

This produces output as follows:

algo 0 length 0 seed 0
02cc5d05  stdin
algo 0 length 0 seed 2654435761
02cc5d05  stdin
algo 0 length 1 seed 0
25201171  stdin
algo 0 length 1 seed 2654435761
25201171  stdin
algo 0 length 14 seed 0
c1d95975  stdin
algo 0 length 14 seed 2654435761
c1d95975  stdin
algo 0 length 222 seed 0
b38662a6  stdin
algo 0 length 222 seed 2654435761
b38662a6  stdin
algo 1 length 0 seed 0
ef46db3751d8e999  stdin
algo 1 length 0 seed 2654435761
ac75fda2929b17ef  stdin
algo 1 length 1 seed 0
27c3f04c2881203a  stdin
algo 1 length 1 seed 2654435761
4a15ed26415dfe4d  stdin
algo 1 length 14 seed 0
3d33dc700231dfad  stdin
algo 1 length 14 seed 2654435761
ea5f7ddef9a64f80  stdin
algo 1 length 222 seed 0
5f3d3c08ec2bef34  stdin
algo 1 length 222 seed 2654435761
6a9df59664c7ed62  stdin

algo 1 is xx64 variant, algo 0 is the 32 bit variant which is currently
not hooked up.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---

Changes since v2: 
* Use subsys_initcall instead of module_init (Eric Biggers)

* Move xxhash64_setkey before xxhash64_init to follow the logical sequence those
function need to be called in (Eric Biggers)

Changes since v1:
 * Added SPDX license (Stephan Mueller)
 * Fixed module alias defines (Eric Biggers)
 * Moved the definition of xxhash_generic object to be after LZ4HC (Stephan Mueller)
 * Explained how the test vectors were derived in the commit message (Stephan Mueller)
 * Changed XXHASH64_BLOCK_SIZE to 32 (Eric Biggers)
 * Renamed xxhash64_crypto_ctx to xxhash64_tfm_ctx, also renamed variables of
 this type to have a 't' prefix (Eric Biggers)
 * Removed redundant storage of 'seed' in xxhash64_desc_ctx
 * Switched to using get/put unaligned when reading the seed value from user
 and when returning a digest. (Eric Biggers)
 * Fixed forgotten initialization step in xxhash64_digest (Eric Biggers)
 * Misc indentation fixes (Eric Biggers)
 * Changed test vectors based on feedback from Nick Terrell

 crypto/Kconfig          |   8 +++
 crypto/Makefile         |   1 +
 crypto/testmgr.c        |   7 +++
 crypto/testmgr.h        | 106 ++++++++++++++++++++++++++++++++++++
 crypto/xxhash_generic.c | 115 ++++++++++++++++++++++++++++++++++++++++
 5 files changed, 237 insertions(+)
 create mode 100644 crypto/xxhash_generic.c

diff --git a/crypto/Kconfig b/crypto/Kconfig
index bbab6bf33519..c56cc450ffc0 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -665,6 +665,14 @@ config CRYPTO_CRC32_MIPS
 	  instructions, when available.
 
 
+config CRYPTO_XXHASH
+	tristate "xxHash hash algorithm"
+	select CRYPTO_HASH
+	select XXHASH
+	help
+	  xxHash non-cryptographic hash algorithm. Extremely fast, working at
+	  speeds close to RAM limits.
+
 config CRYPTO_CRCT10DIF
 	tristate "CRCT10DIF algorithm"
 	select CRYPTO_HASH
diff --git a/crypto/Makefile b/crypto/Makefile
index fb5bf2a3a666..c7cb0bf38fd8 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -131,6 +131,7 @@ obj-$(CONFIG_CRYPTO_AUTHENC) += authenc.o authencesn.o
 obj-$(CONFIG_CRYPTO_LZO) += lzo.o lzo-rle.o
 obj-$(CONFIG_CRYPTO_LZ4) += lz4.o
 obj-$(CONFIG_CRYPTO_LZ4HC) += lz4hc.o
+obj-$(CONFIG_CRYPTO_XXHASH) += xxhash_generic.o
 obj-$(CONFIG_CRYPTO_842) += 842.o
 obj-$(CONFIG_CRYPTO_RNG2) += rng.o
 obj-$(CONFIG_CRYPTO_ANSI_CPRNG) += ansi_cprng.o
diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index 8386038d67c7..322e906b6b6a 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -3879,6 +3879,13 @@ static const struct alg_test_desc alg_test_descs[] = {
 		.alg = "xts512(paes)",
 		.test = alg_test_null,
 		.fips_allowed = 1,
+	}, {
+		.alg = "xxhash64",
+		.test = alg_test_hash,
+		.fips_allowed = 1,
+		.suite = {
+			.hash = __VECS(xxhash64_tv_template)
+		}
 	}, {
 		.alg = "zlib-deflate",
 		.test = alg_test_comp,
diff --git a/crypto/testmgr.h b/crypto/testmgr.h
index d18a37629f05..4a2bce0f3eab 100644
--- a/crypto/testmgr.h
+++ b/crypto/testmgr.h
@@ -33218,6 +33218,112 @@ static const struct hash_testvec crc32c_tv_template[] = {
 	}
 };
 
+static const struct hash_testvec xxhash64_tv_template[] = {
+	{
+		.psize = 0,
+		.digest = "\x99\xe9\xd8\x51\x37\xdb\x46\xef",
+	},
+	{
+		.plaintext = "\x40",
+		.psize = 1,
+		.digest = "\x20\x5c\x91\xaa\x88\xeb\x59\xd0",
+	},
+	{
+		.plaintext = "\x40\x8b\xb8\x41\xe4\x42\x15\x2d"
+			     "\x88\xc7\x9a\x09\x1a\x9b",
+		.psize = 14,
+		.digest = "\xa8\xe8\x2b\xa9\x92\xa1\x37\x4a",
+	},
+	{
+		.plaintext = "\x40\x8b\xb8\x41\xe4\x42\x15\x2d"
+		             "\x88\xc7\x9a\x09\x1a\x9b\x42\xe0"
+			     "\xd4\x38\xa5\x2a\x26\xa5\x19\x4b"
+			     "\x57\x65\x7f\xad\xc3\x7d\xca\x40"
+			     "\x31\x65\x05\xbb\x31\xae\x51\x11"
+			     "\xa8\xc0\xb3\x28\x42\xeb\x3c\x46"
+			     "\xc8\xed\xed\x0f\x8d\x0b\xfa\x6e"
+			     "\xbc\xe3\x88\x53\xca\x8f\xc8\xd9"
+			     "\x41\x26\x7a\x3d\x21\xdb\x1a\x3c"
+			     "\x01\x1d\xc9\xe9\xb7\x3a\x78\x67"
+			     "\x57\x20\x94\xf1\x1e\xfd\xce\x39"
+			     "\x99\x57\x69\x39\xa5\xd0\x8d\xd9"
+			     "\x43\xfe\x1d\x66\x04\x3c\x27\x6a"
+			     "\xe1\x0d\xe7\xc9\xfa\xc9\x07\x56"
+			     "\xa5\xb3\xec\xd9\x1f\x42\x65\x66"
+			     "\xaa\xbf\x87\x9b\xc5\x41\x9c\x27"
+			     "\x3f\x2f\xa9\x55\x93\x01\x27\x33"
+			     "\x43\x99\x4d\x81\x85\xae\x82\x00"
+			     "\x6c\xd0\xd1\xa3\x57\x18\x06\xcc"
+			     "\xec\x72\xf7\x8e\x87\x2d\x1f\x5e"
+			     "\xd7\x5b\x1f\x36\x4c\xfa\xfd\x18"
+			     "\x89\x76\xd3\x5e\xb5\x5a\xc0\x01"
+			     "\xd2\xa1\x9a\x50\xe6\x08\xb4\x76"
+			     "\x56\x4f\x0e\xbc\x54\xfc\x67\xe6"
+			     "\xb9\xc0\x28\x4b\xb5\xc3\xff\x79"
+			     "\x52\xea\xa1\x90\xc3\xaf\x08\x70"
+			     "\x12\x02\x0c\xdb\x94\x00\x38\x95"
+			     "\xed\xfd\x08\xf7\xe8\x04",
+		.psize = 222,
+		.digest = "\x41\xfc\xd4\x29\xfe\xe7\x85\x17",
+	},
+	{
+		.psize = 0,
+		.key = "\xb1\x79\x37\x9e\x00\x00\x00\x00",
+		.ksize = 8,
+		.digest = "\xef\x17\x9b\x92\xa2\xfd\x75\xac",
+	},
+
+	{
+		.plaintext = "\x40",
+		.psize = 1,
+		.key = "\xb1\x79\x37\x9e\x00\x00\x00\x00",
+		.ksize = 8,
+		.digest = "\xd1\x70\x4f\x14\x02\xc4\x9e\x71",
+	},
+	{
+		.plaintext = "\x40\x8b\xb8\x41\xe4\x42\x15\x2d"
+			     "\x88\xc7\x9a\x09\x1a\x9b",
+		.psize = 14,
+		.key = "\xb1\x79\x37\x9e\x00\x00\x00\x00",
+		.ksize = 8,
+		.digest = "\xa4\xcd\xfe\x8e\x37\xe2\x1c\x64"
+	},
+	{
+		.plaintext = "\x40\x8b\xb8\x41\xe4\x42\x15\x2d"
+		             "\x88\xc7\x9a\x09\x1a\x9b\x42\xe0"
+			     "\xd4\x38\xa5\x2a\x26\xa5\x19\x4b"
+			     "\x57\x65\x7f\xad\xc3\x7d\xca\x40"
+			     "\x31\x65\x05\xbb\x31\xae\x51\x11"
+			     "\xa8\xc0\xb3\x28\x42\xeb\x3c\x46"
+			     "\xc8\xed\xed\x0f\x8d\x0b\xfa\x6e"
+			     "\xbc\xe3\x88\x53\xca\x8f\xc8\xd9"
+			     "\x41\x26\x7a\x3d\x21\xdb\x1a\x3c"
+			     "\x01\x1d\xc9\xe9\xb7\x3a\x78\x67"
+			     "\x57\x20\x94\xf1\x1e\xfd\xce\x39"
+			     "\x99\x57\x69\x39\xa5\xd0\x8d\xd9"
+			     "\x43\xfe\x1d\x66\x04\x3c\x27\x6a"
+			     "\xe1\x0d\xe7\xc9\xfa\xc9\x07\x56"
+			     "\xa5\xb3\xec\xd9\x1f\x42\x65\x66"
+			     "\xaa\xbf\x87\x9b\xc5\x41\x9c\x27"
+			     "\x3f\x2f\xa9\x55\x93\x01\x27\x33"
+			     "\x43\x99\x4d\x81\x85\xae\x82\x00"
+			     "\x6c\xd0\xd1\xa3\x57\x18\x06\xcc"
+			     "\xec\x72\xf7\x8e\x87\x2d\x1f\x5e"
+			     "\xd7\x5b\x1f\x36\x4c\xfa\xfd\x18"
+			     "\x89\x76\xd3\x5e\xb5\x5a\xc0\x01"
+			     "\xd2\xa1\x9a\x50\xe6\x08\xb4\x76"
+			     "\x56\x4f\x0e\xbc\x54\xfc\x67\xe6"
+			     "\xb9\xc0\x28\x4b\xb5\xc3\xff\x79"
+			     "\x52\xea\xa1\x90\xc3\xaf\x08\x70"
+			     "\x12\x02\x0c\xdb\x94\x00\x38\x95"
+			     "\xed\xfd\x08\xf7\xe8\x04",
+		.psize = 222,
+		.key = "\xb1\x79\x37\x9e\x00\x00\x00\x00",
+		.ksize = 8,
+		.digest = "\x58\xbc\x55\xf2\x42\x81\x5c\xf0"
+	},
+};
+
 static const struct comp_testvec lz4_comp_tv_template[] = {
 	{
 		.inlen	= 255,
diff --git a/crypto/xxhash_generic.c b/crypto/xxhash_generic.c
new file mode 100644
index 000000000000..6d789de77c3e
--- /dev/null
+++ b/crypto/xxhash_generic.c
@@ -0,0 +1,115 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include <crypto/internal/hash.h>
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/xxhash.h>
+#include <asm/unaligned.h>
+
+#define XXHASH64_BLOCK_SIZE	32
+#define XXHASH64_DIGEST_SIZE	8
+
+struct xxhash64_tfm_ctx {
+	u64 seed;
+};
+
+struct xxhash64_desc_ctx {
+	struct xxh64_state xxhstate;
+};
+
+static int xxhash64_setkey(struct crypto_shash *tfm, const u8 *key,
+			 unsigned int keylen)
+{
+	struct xxhash64_tfm_ctx *tctx = crypto_shash_ctx(tfm);
+
+	if (keylen != sizeof(tctx->seed)) {
+		crypto_shash_set_flags(tfm, CRYPTO_TFM_RES_BAD_KEY_LEN);
+		return -EINVAL;
+	}
+	tctx->seed = get_unaligned_le64(key);
+	return 0;
+}
+
+static int xxhash64_init(struct shash_desc *desc)
+{
+	struct xxhash64_tfm_ctx *tctx = crypto_shash_ctx(desc->tfm);
+	struct xxhash64_desc_ctx *dctx = shash_desc_ctx(desc);
+
+	xxh64_reset(&dctx->xxhstate, tctx->seed);
+
+	return 0;
+}
+
+static int xxhash64_update(struct shash_desc *desc, const u8 *data,
+			 unsigned int length)
+{
+	struct xxhash64_desc_ctx *tctx = shash_desc_ctx(desc);
+
+	xxh64_update(&tctx->xxhstate, data, length);
+
+	return 0;
+}
+
+static int xxhash64_final(struct shash_desc *desc, u8 *out)
+{
+	struct xxhash64_desc_ctx *ctx = shash_desc_ctx(desc);
+
+	put_unaligned_le64(xxh64_digest(&ctx->xxhstate), out);
+
+	return 0;
+}
+
+static int xxhash64_finup(struct shash_desc *desc, const u8 *data,
+			unsigned int len, u8 *out)
+{
+	xxhash64_update(desc, data, len);
+	xxhash64_final(desc, out);
+
+	return 0;
+}
+
+static int xxhash64_digest(struct shash_desc *desc, const u8 *data,
+			 unsigned int length, u8 *out)
+{
+	xxhash64_init(desc);
+	return xxhash64_finup(desc, data, length, out);
+}
+
+static struct shash_alg alg = {
+	.digestsize	= XXHASH64_DIGEST_SIZE,
+	.setkey		= xxhash64_setkey,
+	.init		= xxhash64_init,
+	.update		= xxhash64_update,
+	.final		= xxhash64_final,
+	.finup		= xxhash64_finup,
+	.digest		= xxhash64_digest,
+	.descsize	= sizeof(struct xxhash64_desc_ctx),
+	.base		= {
+		.cra_name	 = "xxhash64",
+		.cra_driver_name = "xxhash64-generic",
+		.cra_priority	 = 100,
+		.cra_flags	 = CRYPTO_ALG_OPTIONAL_KEY,
+		.cra_blocksize	 = XXHASH64_BLOCK_SIZE,
+		.cra_ctxsize	 = sizeof(struct xxhash64_tfm_ctx),
+		.cra_module	 = THIS_MODULE,
+	}
+};
+
+static int __init xxhash_mod_init(void)
+{
+	return crypto_register_shash(&alg);
+}
+
+static void __exit xxhash_mod_fini(void)
+{
+	crypto_unregister_shash(&alg);
+}
+
+subsys_initcall(xxhash_mod_init);
+module_exit(xxhash_mod_fini);
+
+MODULE_AUTHOR("Nikolay Borisov <nborisov@suse.com>");
+MODULE_DESCRIPTION("xxhash calculations wrapper for lib/xxhash.c");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS_CRYPTO("xxhash64");
+MODULE_ALIAS_CRYPTO("xxhash64-generic");
-- 
2.17.1

