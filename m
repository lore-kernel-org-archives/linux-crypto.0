From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Subject: [PATCH 3/6] crypto: testmgr - Add support for the pcomp interface
Date: Wed, 25 Feb 2009 14:43:11 +0100
Message-ID: <1235569394-15217-4-git-send-email-Geert.Uytterhoeven@sonycom.com>
References: <1235569394-15217-1-git-send-email-Geert.Uytterhoeven@sonycom.com>
 <1235569394-15217-2-git-send-email-Geert.Uytterhoeven@sonycom.com>
 <1235569394-15217-3-git-send-email-Geert.Uytterhoeven@sonycom.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from vervifontaine.sonytel.be ([80.88.33.193]:63871 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754260AbZBYNnU (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 25 Feb 2009 08:43:20 -0500
In-Reply-To: <1235569394-15217-3-git-send-email-Geert.Uytterhoeven@sonycom.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Signed-off-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
---
 crypto/testmgr.c |  183 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 crypto/testmgr.h |   10 +++
 2 files changed, 193 insertions(+), 0 deletions(-)

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index a75f11f..e750357 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -72,6 +72,13 @@ struct comp_test_suite {
 	} comp, decomp;
 };
 
+struct pcomp_test_suite {
+	struct {
+		struct pcomp_testvec *vecs;
+		unsigned int count;
+	} comp, decomp;
+};
+
 struct hash_test_suite {
 	struct hash_testvec *vecs;
 	unsigned int count;
@@ -86,6 +93,7 @@ struct alg_test_desc {
 		struct aead_test_suite aead;
 		struct cipher_test_suite cipher;
 		struct comp_test_suite comp;
+		struct pcomp_test_suite pcomp;
 		struct hash_test_suite hash;
 	} suite;
 };
@@ -898,6 +906,159 @@ out:
 	return ret;
 }
 
+static int test_pcomp(struct crypto_pcomp *tfm,
+		      struct pcomp_testvec *ctemplate,
+		      struct pcomp_testvec *dtemplate, int ctcount,
+		      int dtcount)
+{
+	const char *algo = crypto_tfm_alg_driver_name(crypto_pcomp_tfm(tfm));
+	unsigned int i;
+	char result[COMP_BUF_SIZE];
+	int error;
+
+	for (i = 0; i < ctcount; i++) {
+		struct comp_request req;
+
+		error = crypto_compress_setup(tfm, ctemplate[i].params,
+					      ctemplate[i].paramsize);
+		if (error) {
+			pr_err("alg: pcomp: compression setup failed on test "
+			       "%d for %s: error=%d\n", i + 1, algo, error);
+			return error;
+		}
+
+		error = crypto_compress_init(tfm);
+		if (error) {
+			pr_err("alg: pcomp: compression init failed on test "
+			       "%d for %s: error=%d\n", i + 1, algo, error);
+			return error;
+		}
+
+		memset(result, 0, sizeof(result));
+
+		req.next_in = ctemplate[i].input;
+		req.avail_in = ctemplate[i].inlen / 2;
+		req.next_out = result;
+		req.avail_out = ctemplate[i].outlen / 2;
+
+		error = crypto_compress_update(tfm, &req);
+		if (error && (error != -EAGAIN || req.avail_in)) {
+			pr_err("alg: pcomp: compression update failed on test "
+			       "%d for %s: error=%d\n", i + 1, algo, error);
+			return error;
+		}
+
+		/* Add remaining input data */
+		req.avail_in += (ctemplate[i].inlen + 1) / 2;
+
+		error = crypto_compress_update(tfm, &req);
+		if (error && (error != -EAGAIN || req.avail_in)) {
+			pr_err("alg: pcomp: compression update failed on test "
+			       "%d for %s: error=%d\n", i + 1, algo, error);
+			return error;
+		}
+
+		/* Provide remaining output space */
+		req.avail_out += COMP_BUF_SIZE - ctemplate[i].outlen / 2;
+
+		error = crypto_compress_final(tfm, &req);
+		if (error) {
+			pr_err("alg: pcomp: compression final failed on test "
+			       "%d for %s: error=%d\n", i + 1, algo, error);
+			return error;
+		}
+
+		if (COMP_BUF_SIZE - req.avail_out != ctemplate[i].outlen) {
+			pr_err("alg: comp: Compression test %d failed for %s: "
+			       "output len = %d (expected %d)\n", i + 1, algo,
+			       COMP_BUF_SIZE - req.avail_out,
+			       ctemplate[i].outlen);
+			return -EINVAL;
+		}
+
+		if (memcmp(result, ctemplate[i].output, ctemplate[i].outlen)) {
+			pr_err("alg: pcomp: Compression test %d failed for "
+			       "%s\n", i + 1, algo);
+			hexdump(result, ctemplate[i].outlen);
+			return -EINVAL;
+		}
+	}
+
+	for (i = 0; i < dtcount; i++) {
+		struct comp_request req;
+
+		error = crypto_decompress_setup(tfm, dtemplate[i].params,
+						dtemplate[i].paramsize);
+		if (error) {
+			pr_err("alg: pcomp: decompression setup failed on "
+			       "test %d for %s: error=%d\n", i + 1, algo,
+			       error);
+			return error;
+		}
+
+		error = crypto_decompress_init(tfm);
+		if (error) {
+			pr_err("alg: pcomp: decompression init failed on test "
+			       "%d for %s: error=%d\n", i + 1, algo, error);
+			return error;
+		}
+
+		memset(result, 0, sizeof(result));
+
+		req.next_in = dtemplate[i].input;
+		req.avail_in = dtemplate[i].inlen / 2;
+		req.next_out = result;
+		req.avail_out = dtemplate[i].outlen / 2;
+
+		error = crypto_decompress_update(tfm, &req);
+		if (error  && (error != -EAGAIN || req.avail_in)) {
+			pr_err("alg: pcomp: decompression update failed on "
+			       "test %d for %s: error=%d\n", i + 1, algo,
+			       error);
+			return error;
+		}
+
+		/* Add remaining input data */
+		req.avail_in += (dtemplate[i].inlen + 1) / 2;
+
+		error = crypto_decompress_update(tfm, &req);
+		if (error  && (error != -EAGAIN || req.avail_in)) {
+			pr_err("alg: pcomp: decompression update failed on "
+			       "test %d for %s: error=%d\n", i + 1, algo,
+			       error);
+			return error;
+		}
+
+		/* Provide remaining output space */
+		req.avail_out += COMP_BUF_SIZE - dtemplate[i].outlen / 2;
+
+		error = crypto_decompress_final(tfm, &req);
+		if (error  && (error != -EAGAIN || req.avail_in)) {
+			pr_err("alg: pcomp: decompression final failed on "
+			       "test %d for %s: error=%d\n", i + 1, algo,
+			       error);
+			return error;
+		}
+
+		if (COMP_BUF_SIZE - req.avail_out != dtemplate[i].outlen) {
+			pr_err("alg: comp: Decompression test %d failed for "
+			       "%s: output len = %d (expected %d)\n", i + 1,
+			       algo, COMP_BUF_SIZE - req.avail_out,
+			       dtemplate[i].outlen);
+			return -EINVAL;
+		}
+
+		if (memcmp(result, dtemplate[i].output, dtemplate[i].outlen)) {
+			pr_err("alg: pcomp: Decompression test %d failed for "
+			       "%s\n", i + 1, algo);
+			hexdump(result, dtemplate[i].outlen);
+			return -EINVAL;
+		}
+	}
+
+	return 0;
+}
+
 static int alg_test_aead(const struct alg_test_desc *desc, const char *driver,
 			 u32 type, u32 mask)
 {
@@ -1007,6 +1168,28 @@ static int alg_test_comp(const struct alg_test_desc *desc, const char *driver,
 	return err;
 }
 
+static int alg_test_pcomp(const struct alg_test_desc *desc, const char *driver,
+			  u32 type, u32 mask)
+{
+	struct crypto_pcomp *tfm;
+	int err;
+
+	tfm = crypto_alloc_pcomp(driver, type, mask);
+	if (IS_ERR(tfm)) {
+		pr_err("alg: pcomp: Failed to load transform for %s: %ld\n",
+		       driver, PTR_ERR(tfm));
+		return PTR_ERR(tfm);
+	}
+
+	err = test_pcomp(tfm, desc->suite.pcomp.comp.vecs,
+			 desc->suite.pcomp.decomp.vecs,
+			 desc->suite.pcomp.comp.count,
+			 desc->suite.pcomp.decomp.count);
+
+	crypto_free_pcomp(tfm);
+	return err;
+}
+
 static int alg_test_hash(const struct alg_test_desc *desc, const char *driver,
 			 u32 type, u32 mask)
 {
diff --git a/crypto/testmgr.h b/crypto/testmgr.h
index 132953e..c517e43 100644
--- a/crypto/testmgr.h
+++ b/crypto/testmgr.h
@@ -15,6 +15,8 @@
 #ifndef _CRYPTO_TESTMGR_H
 #define _CRYPTO_TESTMGR_H
 
+#include <crypto/compress.h>
+
 #define MAX_DIGEST_SIZE		64
 #define MAX_TAP			8
 
@@ -8347,6 +8349,14 @@ struct comp_testvec {
 	char output[COMP_BUF_SIZE];
 };
 
+struct pcomp_testvec {
+	void *params;
+	unsigned int paramsize;
+	int inlen, outlen;
+	char input[COMP_BUF_SIZE];
+	char output[COMP_BUF_SIZE];
+};
+
 /*
  * Deflate test vectors (null-terminated strings).
  * Params: winbits=-11, Z_DEFAULT_COMPRESSION, MAX_MEM_LEVEL.
-- 
1.6.0.4

