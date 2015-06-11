From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: [PATCH RFC v4 4/4] crypto: add tests vectors for RSA
Date: Thu, 11 Jun 2015 12:05:54 -0700
Message-ID: <20150611190554.31826.85819.stgit@tstruk-mobl1>
References: <20150611190533.31826.13956.stgit@tstruk-mobl1>
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
Received: from mga14.intel.com ([192.55.52.115]:13158 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751133AbbFKTLA (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 11 Jun 2015 15:11:00 -0400
In-Reply-To: <20150611190533.31826.13956.stgit@tstruk-mobl1>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

New test vectors for RSA algorithm.

Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>
---
 crypto/Kconfig   |    1 
 crypto/testmgr.c |  164 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 crypto/testmgr.h |  142 +++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 307 insertions(+)

diff --git a/crypto/Kconfig b/crypto/Kconfig
index 4d1bff3..cbae88a 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -107,6 +107,7 @@ config CRYPTO_RSA
 config CRYPTO_MANAGER
 	tristate "Cryptographic algorithm manager"
 	select CRYPTO_MANAGER2
+	select CRYPTO_AKCIPHER
 	help
 	  Create default cryptographic template instantiations such as
 	  cbc(aes).
diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index ccd19cf..f984328 100644
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
 
@@ -1825,6 +1833,152 @@ static int alg_test_drbg(const struct alg_test_desc *desc, const char *driver,
 
 }
 
+static int do_test_rsa(struct crypto_akcipher *tfm,
+		       struct akcipher_testvec *vecs)
+{
+	struct akcipher_request *req;
+	struct public_key pkey = {0};
+	void *outbuf_enc = NULL;
+	void *outbuf_dec = NULL;
+	struct tcrypt_result result;
+	unsigned int max_out_len, out_len;
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
+	init_completion(&result.completion);
+	crypto_akcipher_setkey(tfm, &pkey);
+	max_out_len = crypto_akcipher_maxsize(tfm);
+	if (!(max_out_len > 0))
+		goto free_d;
+
+	outbuf_enc = kzalloc(max_out_len, GFP_KERNEL);
+	if (!outbuf_enc)
+		goto free_d;
+
+	akcipher_request_set_crypt(req, vecs->m, outbuf_enc, vecs->m_size,
+				   max_out_len, &out_len);
+	akcipher_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG,
+				      tcrypt_complete, &result);
+
+	/* Run RSA encrypt - c = m^e mod n;*/
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
+	/* verify that encrypted message is equal to expected */
+	if (memcmp(vecs->c, outbuf_enc, vecs->c_size)) {
+		pr_err("alg: rsa: encrypt test failed. Invalid output\n");
+		err = -EINVAL;
+		goto free_all;
+	}
+
+	outbuf_dec = kzalloc(max_out_len, GFP_KERNEL);
+	if (!outbuf_dec) {
+		err = -ENOMEM;
+		goto free_all;
+	}
+
+	init_completion(&result.completion);
+	akcipher_request_set_crypt(req, outbuf_enc, outbuf_dec, vecs->c_size,
+				   max_out_len, &out_len);
+
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
+			pr_err("alg: rsa: test failed on vector %d, err=%d\n",
+			       i + 1, ret);
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
+		pr_err("alg: akcipher: Failed to load tfm for %s: %ld\n",
+		       driver, PTR_ERR(tfm));
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
@@ -3453,6 +3607,16 @@ static const struct alg_test_desc alg_test_descs[] = {
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
index 4c2b3e5..b6a514b 100644
--- a/crypto/testmgr.h
+++ b/crypto/testmgr.h
@@ -125,9 +125,151 @@ struct drbg_testvec {
 	size_t expectedlen;
 };
 
+struct akcipher_testvec {
+	unsigned char *pub_key_n;
+	unsigned char *pub_key_e;
+	unsigned char *sec_key_d;
+	unsigned char *m;
+	unsigned char *c;
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
+static struct akcipher_testvec rsa_tv_template[] = {
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
+	.c =
+	"\x63\x1c\xcd\x7b\xe1\x7e\xe4\xde\xc9\xa8\x89\xa1\x74\xcb\x3c\x63"
+	"\x7d\x24\xec\x83\xc3\x15\xe4\x7f\x73\x05\x34\xd1\xec\x22\xbb\x8a"
+	"\x5e\x32\x39\x6d\xc1\x1d\x7d\x50\x3b\x9f\x7a\xad\xf0\x2e\x25\x53"
+	"\x9f\x6e\xbd\x4c\x55\x84\x0c\x9b\xcf\x1a\x4b\x51\x1e\x9e\x0c\x06",
+	.pub_key_n_size = 65,
+	.pub_key_e_size = 1,
+	.sec_key_d_size = 64,
+	.m_size = 8,
+	.c_size = 64,
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
+	.c =
+	"\x74\x1b\x55\xac\x47\xb5\x08\x0a\x6e\x2b\x2d\xf7\x94\xb8\x8a\x95"
+	"\xed\xa3\x6b\xc9\x29\xee\xb2\x2c\x80\xc3\x39\x3b\x8c\x62\x45\x72"
+	"\xc2\x7f\x74\x81\x91\x68\x44\x48\x5a\xdc\xa0\x7e\xa7\x0b\x05\x7f"
+	"\x0e\xa0\x6c\xe5\x8f\x19\x4d\xce\x98\x47\x5f\xbd\x5f\xfe\xe5\x34"
+	"\x59\x89\xaf\xf0\xba\x44\xd7\xf1\x1a\x50\x72\xef\x5e\x4a\xb6\xb7"
+	"\x54\x34\xd1\xc4\x83\x09\xdf\x0f\x91\x5f\x7d\x91\x70\x2f\xd4\x13"
+	"\xcc\x5e\xa4\x6c\xc3\x4d\x28\xef\xda\xaf\xec\x14\x92\xfc\xa3\x75"
+	"\x13\xb4\xc1\xa1\x11\xfc\x40\x2f\x4c\x9d\xdf\x16\x76\x11\x20\x6b",
+	.pub_key_n_size = 129,
+	.pub_key_e_size = 1,
+	.sec_key_d_size = 129,
+	.m_size = 8,
+	.c_size = 128,
+	}, {
+	.pub_key_n =
+	"\xDB\x10\x1A\xC2\xA3\xF1\xDC\xFF\x13\x6B\xED\x44\xDF\xF0\x02\x6D"
+	"\x13\xC7\x88\xDA\x70\x6B\x54\xF1\xE8\x27\xDC\xC3\x0F\x99\x6A\xFA"
+	"\xC6\x67\xFF\x1D\x1E\x3C\x1D\xC1\xB5\x5F\x6C\xC0\xB2\x07\x3A\x6D"
+	"\x41\xE4\x25\x99\xAC\xFC\xD2\x0F\x02\xD3\xD1\x54\x06\x1A\x51\x77"
+	"\xBD\xB6\xBF\xEA\xA7\x5C\x06\xA9\x5D\x69\x84\x45\xD7\xF5\x05\xBA"
+	"\x47\xF0\x1B\xD7\x2B\x24\xEC\xCB\x9B\x1B\x10\x8D\x81\xA0\xBE\xB1"
+	"\x8C\x33\xE4\x36\xB8\x43\xEB\x19\x2A\x81\x8D\xDE\x81\x0A\x99\x48"
+	"\xB6\xF6\xBC\xCD\x49\x34\x3A\x8F\x26\x94\xE3\x28\x82\x1A\x7C\x8F"
+	"\x59\x9F\x45\xE8\x5D\x1A\x45\x76\x04\x56\x05\xA1\xD0\x1B\x8C\x77"
+	"\x6D\xAF\x53\xFA\x71\xE2\x67\xE0\x9A\xFE\x03\xA9\x85\xD2\xC9\xAA"
+	"\xBA\x2A\xBC\xF4\xA0\x08\xF5\x13\x98\x13\x5D\xF0\xD9\x33\x34\x2A"
+	"\x61\xC3\x89\x55\xF0\xAE\x1A\x9C\x22\xEE\x19\x05\x8D\x32\xFE\xEC"
+	"\x9C\x84\xBA\xB7\xF9\x6C\x3A\x4F\x07\xFC\x45\xEB\x12\xE5\x7B\xFD"
+	"\x55\xE6\x29\x69\xD1\xC2\xE8\xB9\x78\x59\xF6\x79\x10\xC6\x4E\xEB"
+	"\x6A\x5E\xB9\x9A\xC7\xC4\x5B\x63\xDA\xA3\x3F\x5E\x92\x7A\x81\x5E"
+	"\xD6\xB0\xE2\x62\x8F\x74\x26\xC2\x0C\xD3\x9A\x17\x47\xE6\x8E\xAB",
+	.pub_key_e = "\x01\x00\x01",
+	.sec_key_d =
+	"\x52\x41\xF4\xDA\x7B\xB7\x59\x55\xCA\xD4\x2F\x0F\x3A\xCB\xA4\x0D"
+	"\x93\x6C\xCC\x9D\xC1\xB2\xFB\xFD\xAE\x40\x31\xAC\x69\x52\x21\x92"
+	"\xB3\x27\xDF\xEA\xEE\x2C\x82\xBB\xF7\x40\x32\xD5\x14\xC4\x94\x12"
+	"\xEC\xB8\x1F\xCA\x59\xE3\xC1\x78\xF3\x85\xD8\x47\xA5\xD7\x02\x1A"
+	"\x65\x79\x97\x0D\x24\xF4\xF0\x67\x6E\x75\x2D\xBF\x10\x3D\xA8\x7D"
+	"\xEF\x7F\x60\xE4\xE6\x05\x82\x89\x5D\xDF\xC6\xD2\x6C\x07\x91\x33"
+	"\x98\x42\xF0\x02\x00\x25\x38\xC5\x85\x69\x8A\x7D\x2F\x95\x6C\x43"
+	"\x9A\xB8\x81\xE2\xD0\x07\x35\xAA\x05\x41\xC9\x1E\xAF\xE4\x04\x3B"
+	"\x19\xB8\x73\xA2\xAC\x4B\x1E\x66\x48\xD8\x72\x1F\xAC\xF6\xCB\xBC"
+	"\x90\x09\xCA\xEC\x0C\xDC\xF9\x2C\xD7\xEB\xAE\xA3\xA4\x47\xD7\x33"
+	"\x2F\x8A\xCA\xBC\x5E\xF0\x77\xE4\x97\x98\x97\xC7\x10\x91\x7D\x2A"
+	"\xA6\xFF\x46\x83\x97\xDE\xE9\xE2\x17\x03\x06\x14\xE2\xD7\xB1\x1D"
+	"\x77\xAF\x51\x27\x5B\x5E\x69\xB8\x81\xE6\x11\xC5\x43\x23\x81\x04"
+	"\x62\xFF\xE9\x46\xB8\xD8\x44\xDB\xA5\xCC\x31\x54\x34\xCE\x3E\x82"
+	"\xD6\xBF\x7A\x0B\x64\x21\x6D\x88\x7E\x5B\x45\x12\x1E\x63\x8D\x49"
+	"\xA7\x1D\xD9\x1E\x06\xCD\xE8\xBA\x2C\x8C\x69\x32\xEA\xBE\x60\x71",
+	.m = "\x54\x85\x9b\x34\x2c\x49\xea\x2a",
+	.c =
+	"\xb2\x97\x76\xb4\xae\x3e\x38\x3c\x7e\x64\x1f\xcc\xa2\x7f\xf6\xbe"
+	"\xcf\x49\xbc\x48\xd3\x6c\x8f\x0a\x0e\xc1\x73\xbd\x7b\x55\x79\x36"
+	"\x0e\xa1\x87\x88\xb9\x2c\x90\xa6\x53\x5e\xe9\xef\xc4\xe2\x4d\xdd"
+	"\xf7\xa6\x69\x82\x3f\x56\xa4\x7b\xfb\x62\xe0\xae\xb8\xd3\x04\xb3"
+	"\xac\x5a\x15\x2a\xe3\x19\x9b\x03\x9a\x0b\x41\xda\x64\xec\x0a\x69"
+	"\xfc\xf2\x10\x92\xf3\xc1\xbf\x84\x7f\xfd\x2c\xae\xc8\xb5\xf6\x41"
+	"\x70\xc5\x47\x03\x8a\xf8\xff\x6f\x3f\xd2\x6f\x09\xb4\x22\xf3\x30"
+	"\xbe\xa9\x85\xcb\x9c\x8d\xf9\x8f\xeb\x32\x91\xa2\x25\x84\x8f\xf5"
+	"\xdc\xc7\x06\x9c\x2d\xe5\x11\x2c\x09\x09\x87\x09\xa9\xf6\x33\x73"
+	"\x90\xf1\x60\xf2\x65\xdd\x30\xa5\x66\xce\x62\x7b\xd0\xf8\x2d\x3d"
+	"\x19\x82\x77\xe3\x0a\x5f\x75\x2f\x8e\xb1\xe5\xe8\x91\x35\x1b\x3b"
+	"\x33\xb7\x66\x92\xd1\xf2\x8e\x6f\xe5\x75\x0c\xad\x36\xfb\x4e\xd0"
+	"\x66\x61\xbd\x49\xfe\xf4\x1a\xa2\x2b\x49\xfe\x03\x4c\x74\x47\x8d"
+	"\x9a\x66\xb2\x49\x46\x4d\x77\xea\x33\x4d\x6b\x3c\xb4\x49\x4a\xc6"
+	"\x7d\x3d\xb5\xb9\x56\x41\x15\x67\x0f\x94\x3c\x93\x65\x27\xe0\x21"
+	"\x5d\x59\xc3\x62\xd5\xa6\xda\x38\x26\x22\x5e\x34\x1c\x94\xaf\x98",
+	.pub_key_n_size = 256,
+	.pub_key_e_size = 3,
+	.sec_key_d_size = 256,
+	.m_size = 8,
+	.c_size = 256,
+	}
+};
+
+/*
  * MD4 test vectors from RFC1320
  */
 #define MD4_TEST_VECTORS	7
