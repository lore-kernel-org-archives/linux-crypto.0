From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: [PATCH RFC v3 3/3] crypto: add tests vectors for RSA
Date: Wed, 03 Jun 2015 15:44:24 -0700
Message-ID: <20150603224424.22310.24677.stgit@tstruk-mobl1>
References: <20150603224403.22310.79731.stgit@tstruk-mobl1>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org, keescook@chromium.org,
	jwboyer@redhat.com, richard@nod.at, tadeusz.struk@intel.com,
	steved@redhat.com, qat-linux@intel.com, dhowells@redhat.com,
	linux-crypto@vger.kernel.org, james.l.morris@oracle.com,
	jkosina@suse.cz, zohar@linux.vnet.ibm.com, davem@davemloft.net,
	vgoyal@redhat.com
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:18015 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754065AbbFCWoO (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 3 Jun 2015 18:44:14 -0400
In-Reply-To: <20150603224403.22310.79731.stgit@tstruk-mobl1>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

New test vectors for RSA algorithm.

Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>
---
 crypto/testmgr.c |  151 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 crypto/testmgr.h |   86 +++++++++++++++++++++++++++++++
 2 files changed, 237 insertions(+)

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index 717d6f2..54a5412 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -30,6 +30,8 @@
 #include <linux/string.h>
 #include <crypto/rng.h>
 #include <crypto/drbg.h>
+#include <crypto/public_key.h>
+#include <crypto/akcipher.h>
 
 #include "internal.h"
 
@@ -116,6 +118,11 @@ struct drbg_test_suite {
 	unsigned int count;
 };
 
+struct akcipher_test_suite {
+	struct akcipher_testvec *vecs;
+	unsigned int count;
+};
+
 struct alg_test_desc {
 	const char *alg;
 	int (*test)(const struct alg_test_desc *desc, const char *driver,
@@ -130,6 +137,7 @@ struct alg_test_desc {
 		struct hash_test_suite hash;
 		struct cprng_test_suite cprng;
 		struct drbg_test_suite drbg;
+		struct akcipher_test_suite akcipher;
 	} suite;
 };
 
@@ -1825,6 +1833,139 @@ static int alg_test_drbg(const struct alg_test_desc *desc, const char *driver,
 
 }
 
+static int do_test_rsa(struct crypto_akcipher *tfm,
+		       struct akcipher_testvec *vecs)
+{
+	struct akcipher_request *req;
+	struct public_key pkey;
+	void *outbuf_enc = NULL;
+	void *outbuf_dec = NULL;
+	struct tcrypt_result result;
+	unsigned int out_len = vecs->c_size;
+	int err = -ENOMEM;
+
+	req = akcipher_request_alloc(tfm, GFP_KERNEL);
+	if (!req)
+		return err;
+
+	pkey.rsa.n = mpi_read_raw_data(vecs->pub_key_n, vecs->pub_key_n_size);
+	if (!pkey.rsa.n)
+		goto free_req;
+
+	pkey.rsa.e = mpi_read_raw_data(vecs->pub_key_e, vecs->pub_key_e_size);
+	if (!pkey.rsa.e)
+		goto free_n;
+
+	pkey.rsa.d = mpi_read_raw_data(vecs->sec_key_d, vecs->sec_key_d_size);
+	if (!pkey.rsa.d)
+		goto free_e;
+
+	outbuf_enc = kzalloc(vecs->c_size, GFP_KERNEL);
+	if (!outbuf_enc)
+		goto free_d;
+
+	/* Run RSA encrypt - c = m^e mod n;*/
+	init_completion(&result.completion);
+	crypto_akcipher_setkey(tfm, &pkey);
+	akcipher_request_set_crypt(req, vecs->m, outbuf_enc, vecs->m_size,
+				   out_len, &out_len);
+	akcipher_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG,
+				      tcrypt_complete, &result);
+	err = wait_async_op(&result, crypto_akcipher_encrypt(req));
+	if (err) {
+		pr_err("alg: rsa: encrypt test failed. err %d\n", err);
+		goto free_all;
+	}
+
+	if (out_len != vecs->c_size) {
+		err = -EINVAL;
+		goto free_all;
+	}
+
+	outbuf_dec = kzalloc(out_len, GFP_KERNEL);
+	if (!outbuf_dec) {
+		err = -ENOMEM;
+		goto free_all;
+	}
+
+	init_completion(&result.completion);
+	akcipher_request_set_crypt(req, outbuf_enc, outbuf_dec, vecs->c_size,
+				   out_len, &out_len);
+	/* Run RSA decrypt - m = c^d mod n;*/
+	err = wait_async_op(&result, crypto_akcipher_decrypt(req));
+	if (err) {
+		pr_err("alg: rsa: decrypt test failed. err %d\n", err);
+		goto free_all;
+	}
+
+	if (out_len != vecs->m_size) {
+		err = -EINVAL;
+		goto free_all;
+	}
+
+	/* verify that decrypted message is equal to the original msg */
+	if (memcmp(vecs->m, outbuf_dec, vecs->m_size)) {
+		pr_err("alg: rsa: encrypt test failed. Invalid output\n");
+		err = -EINVAL;
+	}
+free_all:
+	kfree(outbuf_dec);
+	kfree(outbuf_enc);
+free_d:
+	mpi_free(pkey.rsa.d);
+free_e:
+	mpi_free(pkey.rsa.e);
+free_n:
+	mpi_free(pkey.rsa.n);
+free_req:
+	akcipher_request_free(req);
+	return err;
+}
+
+static int test_rsa(struct crypto_akcipher *tfm, struct akcipher_testvec *vecs,
+		    unsigned int tcount)
+{
+	int ret, i;
+
+	for (i = 0; i < tcount; i++) {
+		ret = do_test_rsa(tfm, vecs++);
+		if (ret) {
+			pr_err("alg: rsa: test failed on vector %d\n", i + 1);
+			return ret;
+		}
+	}
+	return 0;
+}
+
+static int test_akcipher(struct crypto_akcipher *tfm, const char *alg,
+			 struct akcipher_testvec *vecs, unsigned int tcount)
+{
+	if (strncmp(alg, "rsa", 3) == 0)
+		return test_rsa(tfm, vecs, tcount);
+
+	return 0;
+}
+
+static int alg_test_akcipher(const struct alg_test_desc *desc,
+			     const char *driver, u32 type, u32 mask)
+{
+	struct crypto_akcipher *tfm;
+	int err = 0;
+
+	tfm = crypto_alloc_akcipher(driver, type | CRYPTO_ALG_INTERNAL, mask);
+	if (IS_ERR(tfm)) {
+		printk(KERN_ERR "alg: akcipher: Failed to load transform for %s: "
+		       "%ld\n", driver, PTR_ERR(tfm));
+		return PTR_ERR(tfm);
+	}
+	if (desc->suite.akcipher.vecs)
+		err = test_akcipher(tfm, desc->alg, desc->suite.akcipher.vecs,
+				    desc->suite.akcipher.count);
+
+	crypto_free_akcipher(tfm);
+	return err;
+}
+
 static int alg_test_null(const struct alg_test_desc *desc,
 			     const char *driver, u32 type, u32 mask)
 {
@@ -3399,6 +3540,16 @@ static const struct alg_test_desc alg_test_descs[] = {
 			}
 		}
 	}, {
+		.alg = "rsa",
+		.test = alg_test_akcipher,
+		.fips_allowed = 1,
+		.suite = {
+			.akcipher = {
+				.vecs = rsa_tv_template,
+				.count = RSA_TEST_VECTORS
+			}
+		}
+	}, {
 		.alg = "salsa20",
 		.test = alg_test_skcipher,
 		.suite = {
diff --git a/crypto/testmgr.h b/crypto/testmgr.h
index 6003143..ab68906 100644
--- a/crypto/testmgr.h
+++ b/crypto/testmgr.h
@@ -107,9 +107,95 @@ struct drbg_testvec {
 	size_t expectedlen;
 };
 
+struct akcipher_testvec {
+	unsigned char *pub_key_n;
+	unsigned char *pub_key_e;
+	unsigned char *sec_key_d;
+	unsigned char *m;
+	unsigned int pub_key_n_size;
+	unsigned int pub_key_e_size;
+	unsigned int sec_key_d_size;
+	unsigned int m_size;
+	unsigned int c_size; /* size of encrypted message */
+};
+
 static char zeroed_string[48];
 
 /*
+ * RSA test vectors. Borrowed from openSSL.
+ */
+#define RSA_TEST_VECTORS	3
+
+static struct akcipher_testvec rsa_tv_template [] = {
+	{
+	.pub_key_n =
+	"\x00\xAA\x36\xAB\xCE\x88\xAC\xFD\xFF\x55\x52\x3C\x7F\xC4\x52\x3F"
+	"\x90\xEF\xA0\x0D\xF3\x77\x4A\x25\x9F\x2E\x62\xB4\xC5\xD9\x9C\xB5"
+	"\xAD\xB3\x00\xA0\x28\x5E\x53\x01\x93\x0E\x0C\x70\xFB\x68\x76\x93"
+	"\x9C\xE6\x16\xCE\x62\x4A\x11\xE0\x08\x6D\x34\x1E\xBC\xAC\xA0\xA1"
+	"\xF5",
+	.pub_key_e = "\x11",
+	.sec_key_d =
+	"\x0A\x03\x37\x48\x62\x64\x87\x69\x5F\x5F\x30\xBC\x38\xB9\x8B\x44"
+	"\xC2\xCD\x2D\xFF\x43\x40\x98\xCD\x20\xD8\xA1\x38\xD0\x90\xBF\x64"
+	"\x79\x7C\x3F\xA7\xA2\xCD\xCB\x3C\xD1\xE0\xBD\xBA\x26\x54\xB4\xF9"
+	"\xDF\x8E\x8A\xE5\x9D\x73\x3D\x9F\x33\xB3\x01\x62\x4A\xFD\x1D\x51",
+	.m = "\x54\x85\x9b\x34\x2c\x49\xea\x2a",
+	.pub_key_n_size = 65,
+	.pub_key_e_size = 1,
+	.sec_key_d_size = 64,
+	.m_size = 8,
+	.c_size = 64,
+	}, {
+	.pub_key_n =
+	"\x00\xA3\x07\x9A\x90\xDF\x0D\xFD\x72\xAC\x09\x0C\xCC\x2A\x78\xB8"
+	"\x74\x13\x13\x3E\x40\x75\x9C\x98\xFA\xF8\x20\x4F\x35\x8A\x0B\x26"
+	"\x3C\x67\x70\xE7\x83\xA9\x3B\x69\x71\xB7\x37\x79\xD2\x71\x7B\xE8"
+	"\x34\x77\xCF",
+	.pub_key_e = "\x3",
+	.sec_key_d =
+	"\x6C\xAF\xBC\x60\x94\xB3\xFE\x4C\x72\xB0\xB3\x32\xC6\xFB\x25\xA2"
+	"\xB7\x62\x29\x80\x4E\x68\x65\xFC\xA4\x5A\x74\xDF\x0F\x8F\xB8\x41"
+	"\x3B\x52\xC0\xD0\xE5\x3D\x9B\x59\x0F\xF1\x9B\xE7\x9F\x49\xDD\x21"
+	"\xE5\xEB",
+	.m = "\x54\x85\x9b\x34\x2c\x49\xea\x2a",
+	.pub_key_n_size = 51,
+	.pub_key_e_size = 1,
+	.sec_key_d_size = 50,
+	.m_size = 8,
+	.c_size = 24,
+	}, {
+	.pub_key_n =
+	"\x00\xBB\xF8\x2F\x09\x06\x82\xCE\x9C\x23\x38\xAC\x2B\x9D\xA8\x71"
+	"\xF7\x36\x8D\x07\xEE\xD4\x10\x43\xA4\x40\xD6\xB6\xF0\x74\x54\xF5"
+	"\x1F\xB8\xDF\xBA\xAF\x03\x5C\x02\xAB\x61\xEA\x48\xCE\xEB\x6F\xCD"
+	"\x48\x76\xED\x52\x0D\x60\xE1\xEC\x46\x19\x71\x9D\x8A\x5B\x8B\x80"
+	"\x7F\xAF\xB8\xE0\xA3\xDF\xC7\x37\x72\x3E\xE6\xB4\xB7\xD9\x3A\x25"
+	"\x84\xEE\x6A\x64\x9D\x06\x09\x53\x74\x88\x34\xB2\x45\x45\x98\x39"
+	"\x4E\xE0\xAA\xB1\x2D\x7B\x61\xA5\x1F\x52\x7A\x9A\x41\xF6\xC1\x68"
+	"\x7F\xE2\x53\x72\x98\xCA\x2A\x8F\x59\x46\xF8\xE5\xFD\x09\x1D\xBD"
+	"\xCB",
+	.pub_key_e = "\x11",
+	.sec_key_d =
+	"\x00\xA5\xDA\xFC\x53\x41\xFA\xF2\x89\xC4\xB9\x88\xDB\x30\xC1\xCD"
+	"\xF8\x3F\x31\x25\x1E\x06\x68\xB4\x27\x84\x81\x38\x01\x57\x96\x41"
+	"\xB2\x94\x10\xB3\xC7\x99\x8D\x6B\xC4\x65\x74\x5E\x5C\x39\x26\x69"
+	"\xD6\x87\x0D\xA2\xC0\x82\xA9\x39\xE3\x7F\xDC\xB8\x2E\xC9\x3E\xDA"
+	"\xC9\x7F\xF3\xAD\x59\x50\xAC\xCF\xBC\x11\x1C\x76\xF1\xA9\x52\x94"
+	"\x44\xE5\x6A\xAF\x68\xC5\x6C\x09\x2C\xD3\x8D\xC3\xBE\xF5\xD2\x0A"
+	"\x93\x99\x26\xED\x4F\x74\xA1\x3E\xDD\xFB\xE1\xA1\xCE\xCC\x48\x94"
+	"\xAF\x94\x28\xC2\xB7\xB8\x88\x3F\xE4\x46\x3A\x4B\xC8\x5B\x1C\xB3"
+	"\xC1",
+	.m = "\x54\x85\x9b\x34\x2c\x49\xea\x2a",
+	.pub_key_n_size = 129,
+	.pub_key_e_size = 1,
+	.sec_key_d_size = 129,
+	.m_size = 8,
+	.c_size = 128,
+	}
+};
+
+/*
  * MD4 test vectors from RFC1320
  */
 #define MD4_TEST_VECTORS	7
