From: Joonsoo Kim <js1304@gmail.com>
Subject: [PATCH RFC 1/7] crypto/compress: remove unused pcomp interface
Date: Mon,  4 Jan 2016 13:46:52 +0900
Message-ID: <1451882819-2810-2-git-send-email-iamjoonsoo.kim@lge.com>
References: <1451882819-2810-1-git-send-email-iamjoonsoo.kim@lge.com>
Cc: "David S. Miller" <davem@davemloft.net>,
	Weigang Li <weigang.li@intel.com>,
	Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>,
	Minchan Kim <minchan@kernel.org>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1451882819-2810-1-git-send-email-iamjoonsoo.kim@lge.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

It is unused now, so remove it.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
---
 crypto/Kconfig                     |  19 --
 crypto/Makefile                    |   2 -
 crypto/pcompress.c                 | 115 -----------
 crypto/testmgr.c                   | 223 ----------------------
 crypto/testmgr.h                   | 142 --------------
 crypto/zlib.c                      | 381 -------------------------------------
 include/crypto/compress.h          | 145 --------------
 include/crypto/internal/compress.h |  28 ---
 include/linux/crypto.h             |   1 -
 9 files changed, 1056 deletions(-)
 delete mode 100644 crypto/pcompress.c
 delete mode 100644 crypto/zlib.c
 delete mode 100644 include/crypto/compress.h
 delete mode 100644 include/crypto/internal/compress.h

diff --git a/crypto/Kconfig b/crypto/Kconfig
index 7240821..c80d34f 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -84,15 +84,6 @@ config CRYPTO_RNG_DEFAULT
 	tristate
 	select CRYPTO_DRBG_MENU
 
-config CRYPTO_PCOMP
-	tristate
-	select CRYPTO_PCOMP2
-	select CRYPTO_ALGAPI
-
-config CRYPTO_PCOMP2
-	tristate
-	select CRYPTO_ALGAPI2
-
 config CRYPTO_AKCIPHER2
 	tristate
 	select CRYPTO_ALGAPI2
@@ -122,7 +113,6 @@ config CRYPTO_MANAGER2
 	select CRYPTO_AEAD2
 	select CRYPTO_HASH2
 	select CRYPTO_BLKCIPHER2
-	select CRYPTO_PCOMP2
 	select CRYPTO_AKCIPHER2
 
 config CRYPTO_USER
@@ -1504,15 +1494,6 @@ config CRYPTO_DEFLATE
 
 	  You will most probably want this if using IPSec.
 
-config CRYPTO_ZLIB
-	tristate "Zlib compression algorithm"
-	select CRYPTO_PCOMP
-	select ZLIB_INFLATE
-	select ZLIB_DEFLATE
-	select NLATTR
-	help
-	  This is the zlib algorithm.
-
 config CRYPTO_LZO
 	tristate "LZO compression algorithm"
 	select CRYPTO_ALGAPI
diff --git a/crypto/Makefile b/crypto/Makefile
index 2acdbbd..ffe18c9 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -28,7 +28,6 @@ crypto_hash-y += ahash.o
 crypto_hash-y += shash.o
 obj-$(CONFIG_CRYPTO_HASH2) += crypto_hash.o
 
-obj-$(CONFIG_CRYPTO_PCOMP2) += pcompress.o
 obj-$(CONFIG_CRYPTO_AKCIPHER2) += akcipher.o
 
 $(obj)/rsapubkey-asn1.o: $(obj)/rsapubkey-asn1.c $(obj)/rsapubkey-asn1.h
@@ -99,7 +98,6 @@ obj-$(CONFIG_CRYPTO_SALSA20) += salsa20_generic.o
 obj-$(CONFIG_CRYPTO_CHACHA20) += chacha20_generic.o
 obj-$(CONFIG_CRYPTO_POLY1305) += poly1305_generic.o
 obj-$(CONFIG_CRYPTO_DEFLATE) += deflate.o
-obj-$(CONFIG_CRYPTO_ZLIB) += zlib.o
 obj-$(CONFIG_CRYPTO_MICHAEL_MIC) += michael_mic.o
 obj-$(CONFIG_CRYPTO_CRC32C) += crc32c_generic.o
 obj-$(CONFIG_CRYPTO_CRC32) += crc32.o
diff --git a/crypto/pcompress.c b/crypto/pcompress.c
deleted file mode 100644
index 7a13b40..0000000
--- a/crypto/pcompress.c
+++ /dev/null
@@ -1,115 +0,0 @@
-/*
- * Cryptographic API.
- *
- * Partial (de)compression operations.
- *
- * Copyright 2008 Sony Corporation
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; version 2 of the License.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program.
- * If not, see <http://www.gnu.org/licenses/>.
- */
-
-#include <linux/crypto.h>
-#include <linux/errno.h>
-#include <linux/module.h>
-#include <linux/seq_file.h>
-#include <linux/string.h>
-#include <linux/cryptouser.h>
-#include <net/netlink.h>
-
-#include <crypto/compress.h>
-#include <crypto/internal/compress.h>
-
-#include "internal.h"
-
-
-static int crypto_pcomp_init(struct crypto_tfm *tfm, u32 type, u32 mask)
-{
-	return 0;
-}
-
-static int crypto_pcomp_init_tfm(struct crypto_tfm *tfm)
-{
-	return 0;
-}
-
-#ifdef CONFIG_NET
-static int crypto_pcomp_report(struct sk_buff *skb, struct crypto_alg *alg)
-{
-	struct crypto_report_comp rpcomp;
-
-	strncpy(rpcomp.type, "pcomp", sizeof(rpcomp.type));
-	if (nla_put(skb, CRYPTOCFGA_REPORT_COMPRESS,
-		    sizeof(struct crypto_report_comp), &rpcomp))
-		goto nla_put_failure;
-	return 0;
-
-nla_put_failure:
-	return -EMSGSIZE;
-}
-#else
-static int crypto_pcomp_report(struct sk_buff *skb, struct crypto_alg *alg)
-{
-	return -ENOSYS;
-}
-#endif
-
-static void crypto_pcomp_show(struct seq_file *m, struct crypto_alg *alg)
-	__attribute__ ((unused));
-static void crypto_pcomp_show(struct seq_file *m, struct crypto_alg *alg)
-{
-	seq_printf(m, "type         : pcomp\n");
-}
-
-static const struct crypto_type crypto_pcomp_type = {
-	.extsize	= crypto_alg_extsize,
-	.init		= crypto_pcomp_init,
-	.init_tfm	= crypto_pcomp_init_tfm,
-#ifdef CONFIG_PROC_FS
-	.show		= crypto_pcomp_show,
-#endif
-	.report		= crypto_pcomp_report,
-	.maskclear	= ~CRYPTO_ALG_TYPE_MASK,
-	.maskset	= CRYPTO_ALG_TYPE_MASK,
-	.type		= CRYPTO_ALG_TYPE_PCOMPRESS,
-	.tfmsize	= offsetof(struct crypto_pcomp, base),
-};
-
-struct crypto_pcomp *crypto_alloc_pcomp(const char *alg_name, u32 type,
-					u32 mask)
-{
-	return crypto_alloc_tfm(alg_name, &crypto_pcomp_type, type, mask);
-}
-EXPORT_SYMBOL_GPL(crypto_alloc_pcomp);
-
-int crypto_register_pcomp(struct pcomp_alg *alg)
-{
-	struct crypto_alg *base = &alg->base;
-
-	base->cra_type = &crypto_pcomp_type;
-	base->cra_flags &= ~CRYPTO_ALG_TYPE_MASK;
-	base->cra_flags |= CRYPTO_ALG_TYPE_PCOMPRESS;
-
-	return crypto_register_alg(base);
-}
-EXPORT_SYMBOL_GPL(crypto_register_pcomp);
-
-int crypto_unregister_pcomp(struct pcomp_alg *alg)
-{
-	return crypto_unregister_alg(&alg->base);
-}
-EXPORT_SYMBOL_GPL(crypto_unregister_pcomp);
-
-MODULE_LICENSE("GPL");
-MODULE_DESCRIPTION("Partial (de)compression type");
-MODULE_AUTHOR("Sony Corporation");
diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index ae8c57fd..086aa4d 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -96,13 +96,6 @@ struct comp_test_suite {
 	} comp, decomp;
 };
 
-struct pcomp_test_suite {
-	struct {
-		struct pcomp_testvec *vecs;
-		unsigned int count;
-	} comp, decomp;
-};
-
 struct hash_test_suite {
 	struct hash_testvec *vecs;
 	unsigned int count;
@@ -133,7 +126,6 @@ struct alg_test_desc {
 		struct aead_test_suite aead;
 		struct cipher_test_suite cipher;
 		struct comp_test_suite comp;
-		struct pcomp_test_suite pcomp;
 		struct hash_test_suite hash;
 		struct cprng_test_suite cprng;
 		struct drbg_test_suite drbg;
@@ -1293,183 +1285,6 @@ out:
 	return ret;
 }
 
-static int test_pcomp(struct crypto_pcomp *tfm,
-		      struct pcomp_testvec *ctemplate,
-		      struct pcomp_testvec *dtemplate, int ctcount,
-		      int dtcount)
-{
-	const char *algo = crypto_tfm_alg_driver_name(crypto_pcomp_tfm(tfm));
-	unsigned int i;
-	char result[COMP_BUF_SIZE];
-	int res;
-
-	for (i = 0; i < ctcount; i++) {
-		struct comp_request req;
-		unsigned int produced = 0;
-
-		res = crypto_compress_setup(tfm, ctemplate[i].params,
-					    ctemplate[i].paramsize);
-		if (res) {
-			pr_err("alg: pcomp: compression setup failed on test "
-			       "%d for %s: error=%d\n", i + 1, algo, res);
-			return res;
-		}
-
-		res = crypto_compress_init(tfm);
-		if (res) {
-			pr_err("alg: pcomp: compression init failed on test "
-			       "%d for %s: error=%d\n", i + 1, algo, res);
-			return res;
-		}
-
-		memset(result, 0, sizeof(result));
-
-		req.next_in = ctemplate[i].input;
-		req.avail_in = ctemplate[i].inlen / 2;
-		req.next_out = result;
-		req.avail_out = ctemplate[i].outlen / 2;
-
-		res = crypto_compress_update(tfm, &req);
-		if (res < 0 && (res != -EAGAIN || req.avail_in)) {
-			pr_err("alg: pcomp: compression update failed on test "
-			       "%d for %s: error=%d\n", i + 1, algo, res);
-			return res;
-		}
-		if (res > 0)
-			produced += res;
-
-		/* Add remaining input data */
-		req.avail_in += (ctemplate[i].inlen + 1) / 2;
-
-		res = crypto_compress_update(tfm, &req);
-		if (res < 0 && (res != -EAGAIN || req.avail_in)) {
-			pr_err("alg: pcomp: compression update failed on test "
-			       "%d for %s: error=%d\n", i + 1, algo, res);
-			return res;
-		}
-		if (res > 0)
-			produced += res;
-
-		/* Provide remaining output space */
-		req.avail_out += COMP_BUF_SIZE - ctemplate[i].outlen / 2;
-
-		res = crypto_compress_final(tfm, &req);
-		if (res < 0) {
-			pr_err("alg: pcomp: compression final failed on test "
-			       "%d for %s: error=%d\n", i + 1, algo, res);
-			return res;
-		}
-		produced += res;
-
-		if (COMP_BUF_SIZE - req.avail_out != ctemplate[i].outlen) {
-			pr_err("alg: comp: Compression test %d failed for %s: "
-			       "output len = %d (expected %d)\n", i + 1, algo,
-			       COMP_BUF_SIZE - req.avail_out,
-			       ctemplate[i].outlen);
-			return -EINVAL;
-		}
-
-		if (produced != ctemplate[i].outlen) {
-			pr_err("alg: comp: Compression test %d failed for %s: "
-			       "returned len = %u (expected %d)\n", i + 1,
-			       algo, produced, ctemplate[i].outlen);
-			return -EINVAL;
-		}
-
-		if (memcmp(result, ctemplate[i].output, ctemplate[i].outlen)) {
-			pr_err("alg: pcomp: Compression test %d failed for "
-			       "%s\n", i + 1, algo);
-			hexdump(result, ctemplate[i].outlen);
-			return -EINVAL;
-		}
-	}
-
-	for (i = 0; i < dtcount; i++) {
-		struct comp_request req;
-		unsigned int produced = 0;
-
-		res = crypto_decompress_setup(tfm, dtemplate[i].params,
-					      dtemplate[i].paramsize);
-		if (res) {
-			pr_err("alg: pcomp: decompression setup failed on "
-			       "test %d for %s: error=%d\n", i + 1, algo, res);
-			return res;
-		}
-
-		res = crypto_decompress_init(tfm);
-		if (res) {
-			pr_err("alg: pcomp: decompression init failed on test "
-			       "%d for %s: error=%d\n", i + 1, algo, res);
-			return res;
-		}
-
-		memset(result, 0, sizeof(result));
-
-		req.next_in = dtemplate[i].input;
-		req.avail_in = dtemplate[i].inlen / 2;
-		req.next_out = result;
-		req.avail_out = dtemplate[i].outlen / 2;
-
-		res = crypto_decompress_update(tfm, &req);
-		if (res < 0 && (res != -EAGAIN || req.avail_in)) {
-			pr_err("alg: pcomp: decompression update failed on "
-			       "test %d for %s: error=%d\n", i + 1, algo, res);
-			return res;
-		}
-		if (res > 0)
-			produced += res;
-
-		/* Add remaining input data */
-		req.avail_in += (dtemplate[i].inlen + 1) / 2;
-
-		res = crypto_decompress_update(tfm, &req);
-		if (res < 0 && (res != -EAGAIN || req.avail_in)) {
-			pr_err("alg: pcomp: decompression update failed on "
-			       "test %d for %s: error=%d\n", i + 1, algo, res);
-			return res;
-		}
-		if (res > 0)
-			produced += res;
-
-		/* Provide remaining output space */
-		req.avail_out += COMP_BUF_SIZE - dtemplate[i].outlen / 2;
-
-		res = crypto_decompress_final(tfm, &req);
-		if (res < 0 && (res != -EAGAIN || req.avail_in)) {
-			pr_err("alg: pcomp: decompression final failed on "
-			       "test %d for %s: error=%d\n", i + 1, algo, res);
-			return res;
-		}
-		if (res > 0)
-			produced += res;
-
-		if (COMP_BUF_SIZE - req.avail_out != dtemplate[i].outlen) {
-			pr_err("alg: comp: Decompression test %d failed for "
-			       "%s: output len = %d (expected %d)\n", i + 1,
-			       algo, COMP_BUF_SIZE - req.avail_out,
-			       dtemplate[i].outlen);
-			return -EINVAL;
-		}
-
-		if (produced != dtemplate[i].outlen) {
-			pr_err("alg: comp: Decompression test %d failed for "
-			       "%s: returned len = %u (expected %d)\n", i + 1,
-			       algo, produced, dtemplate[i].outlen);
-			return -EINVAL;
-		}
-
-		if (memcmp(result, dtemplate[i].output, dtemplate[i].outlen)) {
-			pr_err("alg: pcomp: Decompression test %d failed for "
-			       "%s\n", i + 1, algo);
-			hexdump(result, dtemplate[i].outlen);
-			return -EINVAL;
-		}
-	}
-
-	return 0;
-}
-
-
 static int test_cprng(struct crypto_rng *tfm, struct cprng_testvec *template,
 		      unsigned int tcount)
 {
@@ -1640,28 +1455,6 @@ static int alg_test_comp(const struct alg_test_desc *desc, const char *driver,
 	return err;
 }
 
-static int alg_test_pcomp(const struct alg_test_desc *desc, const char *driver,
-			  u32 type, u32 mask)
-{
-	struct crypto_pcomp *tfm;
-	int err;
-
-	tfm = crypto_alloc_pcomp(driver, type, mask);
-	if (IS_ERR(tfm)) {
-		pr_err("alg: pcomp: Failed to load transform for %s: %ld\n",
-		       driver, PTR_ERR(tfm));
-		return PTR_ERR(tfm);
-	}
-
-	err = test_pcomp(tfm, desc->suite.pcomp.comp.vecs,
-			 desc->suite.pcomp.decomp.vecs,
-			 desc->suite.pcomp.comp.count,
-			 desc->suite.pcomp.decomp.count);
-
-	crypto_free_pcomp(tfm);
-	return err;
-}
-
 static int alg_test_hash(const struct alg_test_desc *desc, const char *driver,
 			 u32 type, u32 mask)
 {
@@ -3840,22 +3633,6 @@ static const struct alg_test_desc alg_test_descs[] = {
 				}
 			}
 		}
-	}, {
-		.alg = "zlib",
-		.test = alg_test_pcomp,
-		.fips_allowed = 1,
-		.suite = {
-			.pcomp = {
-				.comp = {
-					.vecs = zlib_comp_tv_template,
-					.count = ZLIB_COMP_TEST_VECTORS
-				},
-				.decomp = {
-					.vecs = zlib_decomp_tv_template,
-					.count = ZLIB_DECOMP_TEST_VECTORS
-				}
-			}
-		}
 	}
 };
 
diff --git a/crypto/testmgr.h b/crypto/testmgr.h
index da0a8fd..978f676 100644
--- a/crypto/testmgr.h
+++ b/crypto/testmgr.h
@@ -25,7 +25,6 @@
 #define _CRYPTO_TESTMGR_H
 
 #include <linux/netlink.h>
-#include <linux/zlib.h>
 
 #include <crypto/compress.h>
 
@@ -32268,14 +32267,6 @@ struct comp_testvec {
 	char output[COMP_BUF_SIZE];
 };
 
-struct pcomp_testvec {
-	const void *params;
-	unsigned int paramsize;
-	int inlen, outlen;
-	char input[COMP_BUF_SIZE];
-	char output[COMP_BUF_SIZE];
-};
-
 /*
  * Deflate test vectors (null-terminated strings).
  * Params: winbits=-11, Z_DEFAULT_COMPRESSION, MAX_MEM_LEVEL.
@@ -32356,139 +32347,6 @@ static struct comp_testvec deflate_decomp_tv_template[] = {
 	},
 };
 
-#define ZLIB_COMP_TEST_VECTORS 2
-#define ZLIB_DECOMP_TEST_VECTORS 2
-
-static const struct {
-	struct nlattr nla;
-	int val;
-} deflate_comp_params[] = {
-	{
-		.nla = {
-			.nla_len	= NLA_HDRLEN + sizeof(int),
-			.nla_type	= ZLIB_COMP_LEVEL,
-		},
-		.val			= Z_DEFAULT_COMPRESSION,
-	}, {
-		.nla = {
-			.nla_len	= NLA_HDRLEN + sizeof(int),
-			.nla_type	= ZLIB_COMP_METHOD,
-		},
-		.val			= Z_DEFLATED,
-	}, {
-		.nla = {
-			.nla_len	= NLA_HDRLEN + sizeof(int),
-			.nla_type	= ZLIB_COMP_WINDOWBITS,
-		},
-		.val			= -11,
-	}, {
-		.nla = {
-			.nla_len	= NLA_HDRLEN + sizeof(int),
-			.nla_type	= ZLIB_COMP_MEMLEVEL,
-		},
-		.val			= MAX_MEM_LEVEL,
-	}, {
-		.nla = {
-			.nla_len	= NLA_HDRLEN + sizeof(int),
-			.nla_type	= ZLIB_COMP_STRATEGY,
-		},
-		.val			= Z_DEFAULT_STRATEGY,
-	}
-};
-
-static const struct {
-	struct nlattr nla;
-	int val;
-} deflate_decomp_params[] = {
-	{
-		.nla = {
-			.nla_len	= NLA_HDRLEN + sizeof(int),
-			.nla_type	= ZLIB_DECOMP_WINDOWBITS,
-		},
-		.val			= -11,
-	}
-};
-
-static struct pcomp_testvec zlib_comp_tv_template[] = {
-	{
-		.params = &deflate_comp_params,
-		.paramsize = sizeof(deflate_comp_params),
-		.inlen	= 70,
-		.outlen	= 38,
-		.input	= "Join us now and share the software "
-			"Join us now and share the software ",
-		.output	= "\xf3\xca\xcf\xcc\x53\x28\x2d\x56"
-			  "\xc8\xcb\x2f\x57\x48\xcc\x4b\x51"
-			  "\x28\xce\x48\x2c\x4a\x55\x28\xc9"
-			  "\x48\x55\x28\xce\x4f\x2b\x29\x07"
-			  "\x71\xbc\x08\x2b\x01\x00",
-	}, {
-		.params = &deflate_comp_params,
-		.paramsize = sizeof(deflate_comp_params),
-		.inlen	= 191,
-		.outlen	= 122,
-		.input	= "This document describes a compression method based on the DEFLATE"
-			"compression algorithm.  This document defines the application of "
-			"the DEFLATE algorithm to the IP Payload Compression Protocol.",
-		.output	= "\x5d\x8d\x31\x0e\xc2\x30\x10\x04"
-			  "\xbf\xb2\x2f\xc8\x1f\x10\x04\x09"
-			  "\x89\xc2\x85\x3f\x70\xb1\x2f\xf8"
-			  "\x24\xdb\x67\xd9\x47\xc1\xef\x49"
-			  "\x68\x12\x51\xae\x76\x67\xd6\x27"
-			  "\x19\x88\x1a\xde\x85\xab\x21\xf2"
-			  "\x08\x5d\x16\x1e\x20\x04\x2d\xad"
-			  "\xf3\x18\xa2\x15\x85\x2d\x69\xc4"
-			  "\x42\x83\x23\xb6\x6c\x89\x71\x9b"
-			  "\xef\xcf\x8b\x9f\xcf\x33\xca\x2f"
-			  "\xed\x62\xa9\x4c\x80\xff\x13\xaf"
-			  "\x52\x37\xed\x0e\x52\x6b\x59\x02"
-			  "\xd9\x4e\xe8\x7a\x76\x1d\x02\x98"
-			  "\xfe\x8a\x87\x83\xa3\x4f\x56\x8a"
-			  "\xb8\x9e\x8e\x5c\x57\xd3\xa0\x79"
-			  "\xfa\x02",
-	},
-};
-
-static struct pcomp_testvec zlib_decomp_tv_template[] = {
-	{
-		.params = &deflate_decomp_params,
-		.paramsize = sizeof(deflate_decomp_params),
-		.inlen	= 122,
-		.outlen	= 191,
-		.input	= "\x5d\x8d\x31\x0e\xc2\x30\x10\x04"
-			  "\xbf\xb2\x2f\xc8\x1f\x10\x04\x09"
-			  "\x89\xc2\x85\x3f\x70\xb1\x2f\xf8"
-			  "\x24\xdb\x67\xd9\x47\xc1\xef\x49"
-			  "\x68\x12\x51\xae\x76\x67\xd6\x27"
-			  "\x19\x88\x1a\xde\x85\xab\x21\xf2"
-			  "\x08\x5d\x16\x1e\x20\x04\x2d\xad"
-			  "\xf3\x18\xa2\x15\x85\x2d\x69\xc4"
-			  "\x42\x83\x23\xb6\x6c\x89\x71\x9b"
-			  "\xef\xcf\x8b\x9f\xcf\x33\xca\x2f"
-			  "\xed\x62\xa9\x4c\x80\xff\x13\xaf"
-			  "\x52\x37\xed\x0e\x52\x6b\x59\x02"
-			  "\xd9\x4e\xe8\x7a\x76\x1d\x02\x98"
-			  "\xfe\x8a\x87\x83\xa3\x4f\x56\x8a"
-			  "\xb8\x9e\x8e\x5c\x57\xd3\xa0\x79"
-			  "\xfa\x02",
-		.output	= "This document describes a compression method based on the DEFLATE"
-			"compression algorithm.  This document defines the application of "
-			"the DEFLATE algorithm to the IP Payload Compression Protocol.",
-	}, {
-		.params = &deflate_decomp_params,
-		.paramsize = sizeof(deflate_decomp_params),
-		.inlen	= 38,
-		.outlen	= 70,
-		.input	= "\xf3\xca\xcf\xcc\x53\x28\x2d\x56"
-			  "\xc8\xcb\x2f\x57\x48\xcc\x4b\x51"
-			  "\x28\xce\x48\x2c\x4a\x55\x28\xc9"
-			  "\x48\x55\x28\xce\x4f\x2b\x29\x07"
-			  "\x71\xbc\x08\x2b\x01\x00",
-		.output	= "Join us now and share the software "
-			"Join us now and share the software ",
-	},
-};
-
 /*
  * LZO test vectors (null-terminated strings).
  */
diff --git a/crypto/zlib.c b/crypto/zlib.c
deleted file mode 100644
index d51a30a..0000000
--- a/crypto/zlib.c
+++ /dev/null
@@ -1,381 +0,0 @@
-/*
- * Cryptographic API.
- *
- * Zlib algorithm
- *
- * Copyright 2008 Sony Corporation
- *
- * Based on deflate.c, which is
- * Copyright (c) 2003 James Morris <jmorris@intercode.com.au>
- *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of the GNU General Public License as published by the Free
- * Software Foundation; either version 2 of the License, or (at your option)
- * any later version.
- *
- * FIXME: deflate transforms will require up to a total of about 436k of kernel
- * memory on i386 (390k for compression, the rest for decompression), as the
- * current zlib kernel code uses a worst case pre-allocation system by default.
- * This needs to be fixed so that the amount of memory required is properly
- * related to the winbits and memlevel parameters.
- */
-
-#define pr_fmt(fmt)	"%s: " fmt, __func__
-
-#include <linux/init.h>
-#include <linux/module.h>
-#include <linux/zlib.h>
-#include <linux/vmalloc.h>
-#include <linux/interrupt.h>
-#include <linux/mm.h>
-#include <linux/net.h>
-
-#include <crypto/internal/compress.h>
-
-#include <net/netlink.h>
-
-
-struct zlib_ctx {
-	struct z_stream_s comp_stream;
-	struct z_stream_s decomp_stream;
-	int decomp_windowBits;
-};
-
-
-static void zlib_comp_exit(struct zlib_ctx *ctx)
-{
-	struct z_stream_s *stream = &ctx->comp_stream;
-
-	if (stream->workspace) {
-		zlib_deflateEnd(stream);
-		vfree(stream->workspace);
-		stream->workspace = NULL;
-	}
-}
-
-static void zlib_decomp_exit(struct zlib_ctx *ctx)
-{
-	struct z_stream_s *stream = &ctx->decomp_stream;
-
-	if (stream->workspace) {
-		zlib_inflateEnd(stream);
-		vfree(stream->workspace);
-		stream->workspace = NULL;
-	}
-}
-
-static int zlib_init(struct crypto_tfm *tfm)
-{
-	return 0;
-}
-
-static void zlib_exit(struct crypto_tfm *tfm)
-{
-	struct zlib_ctx *ctx = crypto_tfm_ctx(tfm);
-
-	zlib_comp_exit(ctx);
-	zlib_decomp_exit(ctx);
-}
-
-
-static int zlib_compress_setup(struct crypto_pcomp *tfm, const void *params,
-			       unsigned int len)
-{
-	struct zlib_ctx *ctx = crypto_tfm_ctx(crypto_pcomp_tfm(tfm));
-	struct z_stream_s *stream = &ctx->comp_stream;
-	struct nlattr *tb[ZLIB_COMP_MAX + 1];
-	int window_bits, mem_level;
-	size_t workspacesize;
-	int ret;
-
-	ret = nla_parse(tb, ZLIB_COMP_MAX, params, len, NULL);
-	if (ret)
-		return ret;
-
-	zlib_comp_exit(ctx);
-
-	window_bits = tb[ZLIB_COMP_WINDOWBITS]
-					? nla_get_u32(tb[ZLIB_COMP_WINDOWBITS])
-					: MAX_WBITS;
-	mem_level = tb[ZLIB_COMP_MEMLEVEL]
-					? nla_get_u32(tb[ZLIB_COMP_MEMLEVEL])
-					: DEF_MEM_LEVEL;
-
-	workspacesize = zlib_deflate_workspacesize(window_bits, mem_level);
-	stream->workspace = vzalloc(workspacesize);
-	if (!stream->workspace)
-		return -ENOMEM;
-
-	ret = zlib_deflateInit2(stream,
-				tb[ZLIB_COMP_LEVEL]
-					? nla_get_u32(tb[ZLIB_COMP_LEVEL])
-					: Z_DEFAULT_COMPRESSION,
-				tb[ZLIB_COMP_METHOD]
-					? nla_get_u32(tb[ZLIB_COMP_METHOD])
-					: Z_DEFLATED,
-				window_bits,
-				mem_level,
-				tb[ZLIB_COMP_STRATEGY]
-					? nla_get_u32(tb[ZLIB_COMP_STRATEGY])
-					: Z_DEFAULT_STRATEGY);
-	if (ret != Z_OK) {
-		vfree(stream->workspace);
-		stream->workspace = NULL;
-		return -EINVAL;
-	}
-
-	return 0;
-}
-
-static int zlib_compress_init(struct crypto_pcomp *tfm)
-{
-	int ret;
-	struct zlib_ctx *dctx = crypto_tfm_ctx(crypto_pcomp_tfm(tfm));
-	struct z_stream_s *stream = &dctx->comp_stream;
-
-	ret = zlib_deflateReset(stream);
-	if (ret != Z_OK)
-		return -EINVAL;
-
-	return 0;
-}
-
-static int zlib_compress_update(struct crypto_pcomp *tfm,
-				struct comp_request *req)
-{
-	int ret;
-	struct zlib_ctx *dctx = crypto_tfm_ctx(crypto_pcomp_tfm(tfm));
-	struct z_stream_s *stream = &dctx->comp_stream;
-
-	pr_debug("avail_in %u, avail_out %u\n", req->avail_in, req->avail_out);
-	stream->next_in = req->next_in;
-	stream->avail_in = req->avail_in;
-	stream->next_out = req->next_out;
-	stream->avail_out = req->avail_out;
-
-	ret = zlib_deflate(stream, Z_NO_FLUSH);
-	switch (ret) {
-	case Z_OK:
-		break;
-
-	case Z_BUF_ERROR:
-		pr_debug("zlib_deflate could not make progress\n");
-		return -EAGAIN;
-
-	default:
-		pr_debug("zlib_deflate failed %d\n", ret);
-		return -EINVAL;
-	}
-
-	ret = req->avail_out - stream->avail_out;
-	pr_debug("avail_in %lu, avail_out %lu (consumed %lu, produced %u)\n",
-		 stream->avail_in, stream->avail_out,
-		 req->avail_in - stream->avail_in, ret);
-	req->next_in = stream->next_in;
-	req->avail_in = stream->avail_in;
-	req->next_out = stream->next_out;
-	req->avail_out = stream->avail_out;
-	return ret;
-}
-
-static int zlib_compress_final(struct crypto_pcomp *tfm,
-			       struct comp_request *req)
-{
-	int ret;
-	struct zlib_ctx *dctx = crypto_tfm_ctx(crypto_pcomp_tfm(tfm));
-	struct z_stream_s *stream = &dctx->comp_stream;
-
-	pr_debug("avail_in %u, avail_out %u\n", req->avail_in, req->avail_out);
-	stream->next_in = req->next_in;
-	stream->avail_in = req->avail_in;
-	stream->next_out = req->next_out;
-	stream->avail_out = req->avail_out;
-
-	ret = zlib_deflate(stream, Z_FINISH);
-	if (ret != Z_STREAM_END) {
-		pr_debug("zlib_deflate failed %d\n", ret);
-		return -EINVAL;
-	}
-
-	ret = req->avail_out - stream->avail_out;
-	pr_debug("avail_in %lu, avail_out %lu (consumed %lu, produced %u)\n",
-		 stream->avail_in, stream->avail_out,
-		 req->avail_in - stream->avail_in, ret);
-	req->next_in = stream->next_in;
-	req->avail_in = stream->avail_in;
-	req->next_out = stream->next_out;
-	req->avail_out = stream->avail_out;
-	return ret;
-}
-
-
-static int zlib_decompress_setup(struct crypto_pcomp *tfm, const void *params,
-				 unsigned int len)
-{
-	struct zlib_ctx *ctx = crypto_tfm_ctx(crypto_pcomp_tfm(tfm));
-	struct z_stream_s *stream = &ctx->decomp_stream;
-	struct nlattr *tb[ZLIB_DECOMP_MAX + 1];
-	int ret = 0;
-
-	ret = nla_parse(tb, ZLIB_DECOMP_MAX, params, len, NULL);
-	if (ret)
-		return ret;
-
-	zlib_decomp_exit(ctx);
-
-	ctx->decomp_windowBits = tb[ZLIB_DECOMP_WINDOWBITS]
-				 ? nla_get_u32(tb[ZLIB_DECOMP_WINDOWBITS])
-				 : DEF_WBITS;
-
-	stream->workspace = vzalloc(zlib_inflate_workspacesize());
-	if (!stream->workspace)
-		return -ENOMEM;
-
-	ret = zlib_inflateInit2(stream, ctx->decomp_windowBits);
-	if (ret != Z_OK) {
-		vfree(stream->workspace);
-		stream->workspace = NULL;
-		return -EINVAL;
-	}
-
-	return 0;
-}
-
-static int zlib_decompress_init(struct crypto_pcomp *tfm)
-{
-	int ret;
-	struct zlib_ctx *dctx = crypto_tfm_ctx(crypto_pcomp_tfm(tfm));
-	struct z_stream_s *stream = &dctx->decomp_stream;
-
-	ret = zlib_inflateReset(stream);
-	if (ret != Z_OK)
-		return -EINVAL;
-
-	return 0;
-}
-
-static int zlib_decompress_update(struct crypto_pcomp *tfm,
-				  struct comp_request *req)
-{
-	int ret;
-	struct zlib_ctx *dctx = crypto_tfm_ctx(crypto_pcomp_tfm(tfm));
-	struct z_stream_s *stream = &dctx->decomp_stream;
-
-	pr_debug("avail_in %u, avail_out %u\n", req->avail_in, req->avail_out);
-	stream->next_in = req->next_in;
-	stream->avail_in = req->avail_in;
-	stream->next_out = req->next_out;
-	stream->avail_out = req->avail_out;
-
-	ret = zlib_inflate(stream, Z_SYNC_FLUSH);
-	switch (ret) {
-	case Z_OK:
-	case Z_STREAM_END:
-		break;
-
-	case Z_BUF_ERROR:
-		pr_debug("zlib_inflate could not make progress\n");
-		return -EAGAIN;
-
-	default:
-		pr_debug("zlib_inflate failed %d\n", ret);
-		return -EINVAL;
-	}
-
-	ret = req->avail_out - stream->avail_out;
-	pr_debug("avail_in %lu, avail_out %lu (consumed %lu, produced %u)\n",
-		 stream->avail_in, stream->avail_out,
-		 req->avail_in - stream->avail_in, ret);
-	req->next_in = stream->next_in;
-	req->avail_in = stream->avail_in;
-	req->next_out = stream->next_out;
-	req->avail_out = stream->avail_out;
-	return ret;
-}
-
-static int zlib_decompress_final(struct crypto_pcomp *tfm,
-				 struct comp_request *req)
-{
-	int ret;
-	struct zlib_ctx *dctx = crypto_tfm_ctx(crypto_pcomp_tfm(tfm));
-	struct z_stream_s *stream = &dctx->decomp_stream;
-
-	pr_debug("avail_in %u, avail_out %u\n", req->avail_in, req->avail_out);
-	stream->next_in = req->next_in;
-	stream->avail_in = req->avail_in;
-	stream->next_out = req->next_out;
-	stream->avail_out = req->avail_out;
-
-	if (dctx->decomp_windowBits < 0) {
-		ret = zlib_inflate(stream, Z_SYNC_FLUSH);
-		/*
-		 * Work around a bug in zlib, which sometimes wants to taste an
-		 * extra byte when being used in the (undocumented) raw deflate
-		 * mode. (From USAGI).
-		 */
-		if (ret == Z_OK && !stream->avail_in && stream->avail_out) {
-			const void *saved_next_in = stream->next_in;
-			u8 zerostuff = 0;
-
-			stream->next_in = &zerostuff;
-			stream->avail_in = 1;
-			ret = zlib_inflate(stream, Z_FINISH);
-			stream->next_in = saved_next_in;
-			stream->avail_in = 0;
-		}
-	} else
-		ret = zlib_inflate(stream, Z_FINISH);
-	if (ret != Z_STREAM_END) {
-		pr_debug("zlib_inflate failed %d\n", ret);
-		return -EINVAL;
-	}
-
-	ret = req->avail_out - stream->avail_out;
-	pr_debug("avail_in %lu, avail_out %lu (consumed %lu, produced %u)\n",
-		 stream->avail_in, stream->avail_out,
-		 req->avail_in - stream->avail_in, ret);
-	req->next_in = stream->next_in;
-	req->avail_in = stream->avail_in;
-	req->next_out = stream->next_out;
-	req->avail_out = stream->avail_out;
-	return ret;
-}
-
-
-static struct pcomp_alg zlib_alg = {
-	.compress_setup		= zlib_compress_setup,
-	.compress_init		= zlib_compress_init,
-	.compress_update	= zlib_compress_update,
-	.compress_final		= zlib_compress_final,
-	.decompress_setup	= zlib_decompress_setup,
-	.decompress_init	= zlib_decompress_init,
-	.decompress_update	= zlib_decompress_update,
-	.decompress_final	= zlib_decompress_final,
-
-	.base			= {
-		.cra_name	= "zlib",
-		.cra_flags	= CRYPTO_ALG_TYPE_PCOMPRESS,
-		.cra_ctxsize	= sizeof(struct zlib_ctx),
-		.cra_module	= THIS_MODULE,
-		.cra_init	= zlib_init,
-		.cra_exit	= zlib_exit,
-	}
-};
-
-static int __init zlib_mod_init(void)
-{
-	return crypto_register_pcomp(&zlib_alg);
-}
-
-static void __exit zlib_mod_fini(void)
-{
-	crypto_unregister_pcomp(&zlib_alg);
-}
-
-module_init(zlib_mod_init);
-module_exit(zlib_mod_fini);
-
-MODULE_LICENSE("GPL");
-MODULE_DESCRIPTION("Zlib Compression Algorithm");
-MODULE_AUTHOR("Sony Corporation");
-MODULE_ALIAS_CRYPTO("zlib");
diff --git a/include/crypto/compress.h b/include/crypto/compress.h
deleted file mode 100644
index 5b67af8..0000000
--- a/include/crypto/compress.h
+++ /dev/null
@@ -1,145 +0,0 @@
-/*
- * Compress: Compression algorithms under the cryptographic API.
- *
- * Copyright 2008 Sony Corporation
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; version 2 of the License.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program.
- * If not, see <http://www.gnu.org/licenses/>.
- */
-
-#ifndef _CRYPTO_COMPRESS_H
-#define _CRYPTO_COMPRESS_H
-
-#include <linux/crypto.h>
-
-
-struct comp_request {
-	const void *next_in;		/* next input byte */
-	void *next_out;			/* next output byte */
-	unsigned int avail_in;		/* bytes available at next_in */
-	unsigned int avail_out;		/* bytes available at next_out */
-};
-
-enum zlib_comp_params {
-	ZLIB_COMP_LEVEL = 1,		/* e.g. Z_DEFAULT_COMPRESSION */
-	ZLIB_COMP_METHOD,		/* e.g. Z_DEFLATED */
-	ZLIB_COMP_WINDOWBITS,		/* e.g. MAX_WBITS */
-	ZLIB_COMP_MEMLEVEL,		/* e.g. DEF_MEM_LEVEL */
-	ZLIB_COMP_STRATEGY,		/* e.g. Z_DEFAULT_STRATEGY */
-	__ZLIB_COMP_MAX,
-};
-
-#define ZLIB_COMP_MAX	(__ZLIB_COMP_MAX - 1)
-
-
-enum zlib_decomp_params {
-	ZLIB_DECOMP_WINDOWBITS = 1,	/* e.g. DEF_WBITS */
-	__ZLIB_DECOMP_MAX,
-};
-
-#define ZLIB_DECOMP_MAX	(__ZLIB_DECOMP_MAX - 1)
-
-
-struct crypto_pcomp {
-	struct crypto_tfm base;
-};
-
-struct pcomp_alg {
-	int (*compress_setup)(struct crypto_pcomp *tfm, const void *params,
-			      unsigned int len);
-	int (*compress_init)(struct crypto_pcomp *tfm);
-	int (*compress_update)(struct crypto_pcomp *tfm,
-			       struct comp_request *req);
-	int (*compress_final)(struct crypto_pcomp *tfm,
-			      struct comp_request *req);
-	int (*decompress_setup)(struct crypto_pcomp *tfm, const void *params,
-				unsigned int len);
-	int (*decompress_init)(struct crypto_pcomp *tfm);
-	int (*decompress_update)(struct crypto_pcomp *tfm,
-				 struct comp_request *req);
-	int (*decompress_final)(struct crypto_pcomp *tfm,
-				struct comp_request *req);
-
-	struct crypto_alg base;
-};
-
-extern struct crypto_pcomp *crypto_alloc_pcomp(const char *alg_name, u32 type,
-					       u32 mask);
-
-static inline struct crypto_tfm *crypto_pcomp_tfm(struct crypto_pcomp *tfm)
-{
-	return &tfm->base;
-}
-
-static inline void crypto_free_pcomp(struct crypto_pcomp *tfm)
-{
-	crypto_destroy_tfm(tfm, crypto_pcomp_tfm(tfm));
-}
-
-static inline struct pcomp_alg *__crypto_pcomp_alg(struct crypto_alg *alg)
-{
-	return container_of(alg, struct pcomp_alg, base);
-}
-
-static inline struct pcomp_alg *crypto_pcomp_alg(struct crypto_pcomp *tfm)
-{
-	return __crypto_pcomp_alg(crypto_pcomp_tfm(tfm)->__crt_alg);
-}
-
-static inline int crypto_compress_setup(struct crypto_pcomp *tfm,
-					const void *params, unsigned int len)
-{
-	return crypto_pcomp_alg(tfm)->compress_setup(tfm, params, len);
-}
-
-static inline int crypto_compress_init(struct crypto_pcomp *tfm)
-{
-	return crypto_pcomp_alg(tfm)->compress_init(tfm);
-}
-
-static inline int crypto_compress_update(struct crypto_pcomp *tfm,
-					 struct comp_request *req)
-{
-	return crypto_pcomp_alg(tfm)->compress_update(tfm, req);
-}
-
-static inline int crypto_compress_final(struct crypto_pcomp *tfm,
-					struct comp_request *req)
-{
-	return crypto_pcomp_alg(tfm)->compress_final(tfm, req);
-}
-
-static inline int crypto_decompress_setup(struct crypto_pcomp *tfm,
-					  const void *params, unsigned int len)
-{
-	return crypto_pcomp_alg(tfm)->decompress_setup(tfm, params, len);
-}
-
-static inline int crypto_decompress_init(struct crypto_pcomp *tfm)
-{
-	return crypto_pcomp_alg(tfm)->decompress_init(tfm);
-}
-
-static inline int crypto_decompress_update(struct crypto_pcomp *tfm,
-					   struct comp_request *req)
-{
-	return crypto_pcomp_alg(tfm)->decompress_update(tfm, req);
-}
-
-static inline int crypto_decompress_final(struct crypto_pcomp *tfm,
-					  struct comp_request *req)
-{
-	return crypto_pcomp_alg(tfm)->decompress_final(tfm, req);
-}
-
-#endif	/* _CRYPTO_COMPRESS_H */
diff --git a/include/crypto/internal/compress.h b/include/crypto/internal/compress.h
deleted file mode 100644
index 178a888..0000000
--- a/include/crypto/internal/compress.h
+++ /dev/null
@@ -1,28 +0,0 @@
-/*
- * Compress: Compression algorithms under the cryptographic API.
- *
- * Copyright 2008 Sony Corporation
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; version 2 of the License.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program.
- * If not, see <http://www.gnu.org/licenses/>.
- */
-
-#ifndef _CRYPTO_INTERNAL_COMPRESS_H
-#define _CRYPTO_INTERNAL_COMPRESS_H
-
-#include <crypto/compress.h>
-
-extern int crypto_register_pcomp(struct pcomp_alg *alg);
-extern int crypto_unregister_pcomp(struct pcomp_alg *alg);
-
-#endif	/* _CRYPTO_INTERNAL_COMPRESS_H */
diff --git a/include/linux/crypto.h b/include/linux/crypto.h
index e71cb70..ab2a745 100644
--- a/include/linux/crypto.h
+++ b/include/linux/crypto.h
@@ -54,7 +54,6 @@
 #define CRYPTO_ALG_TYPE_AHASH		0x0000000a
 #define CRYPTO_ALG_TYPE_RNG		0x0000000c
 #define CRYPTO_ALG_TYPE_AKCIPHER	0x0000000d
-#define CRYPTO_ALG_TYPE_PCOMPRESS	0x0000000f
 
 #define CRYPTO_ALG_TYPE_HASH_MASK	0x0000000e
 #define CRYPTO_ALG_TYPE_AHASH_MASK	0x0000000c
-- 
1.9.1
