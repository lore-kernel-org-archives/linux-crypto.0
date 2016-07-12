From: Stephan Mueller <smueller@chronox.de>
Subject: [PATCH v3 2/4] crypto: kdf - add known answer tests
Date: Tue, 12 Jul 2016 11:07:37 +0200
Message-ID: <1505143.XxAfVFQV9S@positron.chronox.de>
References: <4161793.TTVXSVQtZL@positron.chronox.de> <1517551.AxEWRg6eD0@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: David Howells <dhowells@redhat.com>, keyrings@vger.kernel.org,
	linux-crypto@vger.kernel.org
To: Mat Martineau <mathew.j.martineau@linux.intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:39010 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752711AbcGLJJT (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 12 Jul 2016 05:09:19 -0400
In-Reply-To: <1517551.AxEWRg6eD0@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Add known answer tests to the testmgr for the KDF (SP800-108) cipher.

Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 crypto/testmgr.c | 226 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 crypto/testmgr.h | 110 +++++++++++++++++++++++++++
 2 files changed, 336 insertions(+)

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index 8ea0d3f..a513d71 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -116,6 +116,11 @@ struct drbg_test_suite {
 	unsigned int count;
 };
 
+struct kdf_test_suite {
+	struct kdf_testvec *vecs;
+	unsigned int count;
+};
+
 struct akcipher_test_suite {
 	struct akcipher_testvec *vecs;
 	unsigned int count;
@@ -139,6 +144,7 @@ struct alg_test_desc {
 		struct hash_test_suite hash;
 		struct cprng_test_suite cprng;
 		struct drbg_test_suite drbg;
+		struct kdf_test_suite kdf;
 		struct akcipher_test_suite akcipher;
 		struct kpp_test_suite kpp;
 	} suite;
@@ -1758,6 +1764,64 @@ outbuf:
 	return ret;
 }
 
+static int kdf_cavs_test(struct kdf_testvec *test,
+			 const char *driver, u32 type, u32 mask)
+{
+	int ret = -EAGAIN;
+	struct crypto_rng *drng;
+	unsigned char *buf = kzalloc(test->expectedlen, GFP_KERNEL);
+
+	if (!buf)
+		return -ENOMEM;
+
+	drng = crypto_alloc_rng(driver, type | CRYPTO_ALG_INTERNAL, mask);
+	if (IS_ERR(drng)) {
+		printk(KERN_ERR "alg: kdf: could not allocate cipher handle "
+		       "for %s\n", driver);
+		kzfree(buf);
+		return -ENOMEM;
+	}
+
+	ret = crypto_rng_reset(drng, test->K1, test->K1len);
+	if (ret) {
+		printk(KERN_ERR "alg: kdf: could not set key derivation key\n");
+		goto err;
+	}
+
+	ret = crypto_rng_generate(drng, test->context, test->contextlen,
+				  buf, test->expectedlen);
+	if (ret) {
+		printk(KERN_ERR "alg: kdf: could not obtain key data\n");
+		goto err;
+	}
+
+	ret = memcmp(test->expected, buf, test->expectedlen);
+
+err:
+	crypto_free_rng(drng);
+	kzfree(buf);
+	return ret;
+}
+
+static int alg_test_kdf(const struct alg_test_desc *desc, const char *driver,
+			u32 type, u32 mask)
+{
+	int err = 0;
+	unsigned int i = 0;
+	struct kdf_testvec *template = desc->suite.kdf.vecs;
+	unsigned int tcount = desc->suite.kdf.count;
+
+	for (i = 0; i < tcount; i++) {
+		err = kdf_cavs_test(&template[i], driver, type, mask);
+		if (err) {
+			printk(KERN_ERR "alg: kdf: Test %d failed for %s\n",
+			       i, driver);
+			err = -EINVAL;
+			break;
+		}
+	}
+	return err;
+}
 
 static int alg_test_drbg(const struct alg_test_desc *desc, const char *driver,
 			 u32 type, u32 mask)
@@ -3464,6 +3528,168 @@ static const struct alg_test_desc alg_test_descs[] = {
 		.fips_allowed = 1,
 		.test = alg_test_null,
 	}, {
+		.alg = "kdf_ctr(cmac(aes))",
+		.test = alg_test_null,
+		.fips_allowed = 1,
+	}, {
+		.alg = "kdf_ctr(cmac(des3_ede))",
+		.test = alg_test_null,
+		.fips_allowed = 1,
+	}, {
+		.alg = "kdf_ctr(hmac(sha1))",
+		.test = alg_test_null,
+		.fips_allowed = 1,
+	}, {
+		.alg = "kdf_ctr(hmac(sha224))",
+		.test = alg_test_null,
+		.fips_allowed = 1,
+	}, {
+		.alg = "kdf_ctr(hmac(sha256))",
+		.test = alg_test_kdf,
+		.fips_allowed = 1,
+		.suite = {
+			.kdf = {
+				.vecs = kdf_ctr_hmac_sha256_tv_template,
+				.count = ARRAY_SIZE(kdf_ctr_hmac_sha256_tv_template)
+			}
+		}
+	}, {
+		.alg = "kdf_ctr(hmac(sha384))",
+		.test = alg_test_null,
+		.fips_allowed = 1,
+	}, {
+		.alg = "kdf_ctr(hmac(sha512))",
+		.test = alg_test_null,
+		.fips_allowed = 1,
+	}, {
+		.alg = "kdf_ctr(sha1)",
+		.test = alg_test_null,
+		.fips_allowed = 1,
+	}, {
+		.alg = "kdf_ctr(sha224)",
+		.test = alg_test_null,
+		.fips_allowed = 1,
+	}, {
+		.alg = "kdf_ctr(sha256)",
+		.test = alg_test_null,
+		.fips_allowed = 1,
+	}, {
+		.alg = "kdf_ctr(sha384)",
+		.test = alg_test_null,
+		.fips_allowed = 1,
+	}, {
+		.alg = "kdf_ctr(sha512)",
+		.test = alg_test_null,
+		.fips_allowed = 1,
+	}, {
+		.alg = "kdf_dpi(cmac(aes))",
+		.test = alg_test_null,
+		.fips_allowed = 1,
+	}, {
+		.alg = "kdf_dpi(cmac(des3_ede))",
+		.test = alg_test_null,
+		.fips_allowed = 1,
+	}, {
+		.alg = "kdf_dpi(hmac(sha1))",
+		.test = alg_test_null,
+		.fips_allowed = 1,
+	}, {
+		.alg = "kdf_dpi(hmac(sha224))",
+		.test = alg_test_null,
+		.fips_allowed = 1,
+	}, {
+		.alg = "kdf_dpi(hmac(sha256))",
+		.test = alg_test_kdf,
+		.fips_allowed = 1,
+		.suite = {
+			.kdf = {
+				.vecs = kdf_dpi_hmac_sha256_tv_template,
+				.count = ARRAY_SIZE(kdf_dpi_hmac_sha256_tv_template)
+			}
+		}
+	}, {
+		.alg = "kdf_dpi(hmac(sha384))",
+		.test = alg_test_null,
+		.fips_allowed = 1,
+	}, {
+		.alg = "kdf_dpi(hmac(sha512))",
+		.test = alg_test_null,
+		.fips_allowed = 1,
+	}, {
+		.alg = "kdf_dpi(sha1)",
+		.test = alg_test_null,
+		.fips_allowed = 1,
+	}, {
+		.alg = "kdf_dpi(sha224)",
+		.test = alg_test_null,
+		.fips_allowed = 1,
+	}, {
+		.alg = "kdf_dpi(sha256)",
+		.test = alg_test_null,
+		.fips_allowed = 1,
+	}, {
+		.alg = "kdf_dpi(sha384)",
+		.test = alg_test_null,
+		.fips_allowed = 1,
+	}, {
+		.alg = "kdf_dpi(sha512)",
+		.test = alg_test_null,
+		.fips_allowed = 1,
+	}, {
+		.alg = "kdf_fb(cmac(aes))",
+		.test = alg_test_null,
+		.fips_allowed = 1,
+	}, {
+		.alg = "kdf_fb(cmac(des3_ede))",
+		.test = alg_test_null,
+		.fips_allowed = 1,
+	}, {
+		.alg = "kdf_fb(hmac(sha1))",
+		.test = alg_test_null,
+		.fips_allowed = 1,
+	}, {
+		.alg = "kdf_fb(hmac(sha224))",
+		.test = alg_test_null,
+		.fips_allowed = 1,
+	}, {
+		.alg = "kdf_fb(hmac(sha256))",
+		.test = alg_test_kdf,
+		.fips_allowed = 1,
+		.suite = {
+			.kdf = {
+				.vecs = kdf_fb_hmac_sha256_tv_template,
+				.count = ARRAY_SIZE(kdf_fb_hmac_sha256_tv_template)
+			}
+		}
+	}, {
+		.alg = "kdf_fb(hmac(sha384))",
+		.test = alg_test_null,
+		.fips_allowed = 1,
+	}, {
+		.alg = "kdf_fb(hmac(sha512))",
+		.test = alg_test_null,
+		.fips_allowed = 1,
+	}, {
+		.alg = "kdf_fb(sha1)",
+		.test = alg_test_null,
+		.fips_allowed = 1,
+	}, {
+		.alg = "kdf_fb(sha224)",
+		.test = alg_test_null,
+		.fips_allowed = 1,
+	}, {
+		.alg = "kdf_fb(sha256)",
+		.test = alg_test_null,
+		.fips_allowed = 1,
+	}, {
+		.alg = "kdf_fb(sha384)",
+		.test = alg_test_null,
+		.fips_allowed = 1,
+	}, {
+		.alg = "kdf_fb(sha512)",
+		.test = alg_test_null,
+		.fips_allowed = 1,
+	}, {
 		.alg = "kw(aes)",
 		.test = alg_test_skcipher,
 		.fips_allowed = 1,
diff --git a/crypto/testmgr.h b/crypto/testmgr.h
index 4ce2d86..bfb5da3 100644
--- a/crypto/testmgr.h
+++ b/crypto/testmgr.h
@@ -123,6 +123,15 @@ struct drbg_testvec {
 	size_t expectedlen;
 };
 
+struct kdf_testvec {
+	unsigned char *K1;
+	size_t K1len;
+	unsigned char *context;
+	size_t contextlen;
+	unsigned char *expected;
+	size_t expectedlen;
+};
+
 struct akcipher_testvec {
 	unsigned char *key;
 	unsigned char *m;
@@ -25629,6 +25638,107 @@ static struct drbg_testvec drbg_nopr_ctr_aes128_tv_template[] = {
 	},
 };
 
+/*
+ * Test vector obtained from
+ * http://csrc.nist.gov/groups/STM/cavp/documents/KBKDF800-108/CounterMode.zip
+ */
+static struct kdf_testvec kdf_ctr_hmac_sha256_tv_template[] = {
+	{
+		.K1 = (unsigned char *)
+			"\xdd\x1d\x91\xb7\xd9\x0b\x2b\xd3"
+			"\x13\x85\x33\xce\x92\xb2\x72\xfb"
+			"\xf8\xa3\x69\x31\x6a\xef\xe2\x42"
+			"\xe6\x59\xcc\x0a\xe2\x38\xaf\xe0",
+		.K1len = 32,
+		.context = (unsigned char *)
+			"\x01\x32\x2b\x96\xb3\x0a\xcd\x19"
+			"\x79\x79\x44\x4e\x46\x8e\x1c\x5c"
+			"\x68\x59\xbf\x1b\x1c\xf9\x51\xb7"
+			"\xe7\x25\x30\x3e\x23\x7e\x46\xb8"
+			"\x64\xa1\x45\xfa\xb2\x5e\x51\x7b"
+			"\x08\xf8\x68\x3d\x03\x15\xbb\x29"
+			"\x11\xd8\x0a\x0e\x8a\xba\x17\xf3"
+			"\xb4\x13\xfa\xac",
+		.contextlen = 60,
+		.expected = (unsigned char *)
+			"\x10\x62\x13\x42\xbf\xb0\xfd\x40"
+			"\x04\x6c\x0e\x29\xf2\xcf\xdb\xf0",
+		.expectedlen = 16
+	}
+};
+
+/*
+ * Test vector obtained from
+ * http://csrc.nist.gov/groups/STM/cavp/documents/KBKDF800-108/FeedbackModeNOzeroiv.zip
+ */
+static struct kdf_testvec kdf_fb_hmac_sha256_tv_template[] = {
+	{
+		.K1 = (unsigned char *)
+			"\x93\xf6\x98\xe8\x42\xee\xd7\x53"
+			"\x94\xd6\x29\xd9\x57\xe2\xe8\x9c"
+			"\x6e\x74\x1f\x81\x0b\x62\x3c\x8b"
+			"\x90\x1e\x38\x37\x6d\x06\x8e\x7b",
+		.K1len = 32,
+		.context = (unsigned char *)
+			"\x9f\x57\x5d\x90\x59\xd3\xe0\xc0"
+			"\x80\x3f\x08\x11\x2f\x8a\x80\x6d"
+			"\xe3\xc3\x47\x19\x12\xcd\xf4\x2b"
+			"\x09\x53\x88\xb1\x4b\x33\x50\x8e"
+			"\x53\xb8\x9c\x18\x69\x0e\x20\x57"
+			"\xa1\xd1\x67\x82\x2e\x63\x6d\xe5"
+			"\x0b\xe0\x01\x85\x32\xc4\x31\xf7"
+			"\xf5\xe3\x7f\x77\x13\x92\x20\xd5"
+			"\xe0\x42\x59\x9e\xbe\x26\x6a\xf5"
+			"\x76\x7e\xe1\x8c\xd2\xc5\xc1\x9a"
+			"\x1f\x0f\x80",
+		.contextlen = 83,
+		.expected = (unsigned char *)
+			"\xbd\x14\x76\xf4\x3a\x4e\x31\x57"
+			"\x47\xcf\x59\x18\xe0\xea\x5b\xc0"
+			"\xd9\x87\x69\x45\x74\x77\xc3\xab"
+			"\x18\xb7\x42\xde\xf0\xe0\x79\xa9"
+			"\x33\xb7\x56\x36\x5a\xfb\x55\x41"
+			"\xf2\x53\xfe\xe4\x3c\x6f\xd7\x88"
+			"\xa4\x40\x41\x03\x85\x09\xe9\xee"
+			"\xb6\x8f\x7d\x65\xff\xbb\x5f\x95",
+		.expectedlen = 64
+	}
+};
+
+/*
+ * Test vector obtained from
+ * http://csrc.nist.gov/groups/STM/cavp/documents/KBKDF800-108/PipelineModewithCounter.zip
+ */
+static struct kdf_testvec kdf_dpi_hmac_sha256_tv_template[] = {
+	{
+		.K1 = (unsigned char *)
+			"\x02\xd3\x6f\xa0\x21\xc2\x0d\xdb"
+			"\xde\xe4\x69\xf0\x57\x94\x68\xba"
+			"\xe5\xcb\x13\xb5\x48\xb6\xc6\x1c"
+			"\xdf\x9d\x3e\xc4\x19\x11\x1d\xe2",
+		.K1len = 32,
+		.context = (unsigned char *)
+			"\x85\xab\xe3\x8b\xf2\x65\xfb\xdc"
+			"\x64\x45\xae\x5c\x71\x15\x9f\x15"
+			"\x48\xc7\x3b\x7d\x52\x6a\x62\x31"
+			"\x04\x90\x4a\x0f\x87\x92\x07\x0b"
+			"\x3d\xf9\x90\x2b\x96\x69\x49\x04"
+			"\x25\xa3\x85\xea\xdb\x0f\x9c\x76"
+			"\xe4\x6f\x0f",
+		.contextlen = 51,
+		.expected = (unsigned char *)
+			"\xd6\x9f\x74\xf5\x18\xc9\xf6\x4f"
+			"\x90\xa0\xbe\xeb\xab\x69\xf6\x89"
+			"\xb7\x3b\x5c\x13\xeb\x0f\x86\x0a"
+			"\x95\xca\xd7\xd9\x81\x4f\x8c\x50"
+			"\x6e\xb7\xb1\x79\xa5\xc5\xb4\x46"
+			"\x6a\x9e\xc1\x54\xc3\xbf\x1c\x13"
+			"\xef\xd6\xec\x0d\x82\xb0\x2c\x29"
+			"\xaf\x2c\x69\x02\x99\xed\xc4\x53",
+		.expectedlen = 64
+	}
+};
+
 /* Cast5 test vectors from RFC 2144 */
 #define CAST5_ENC_TEST_VECTORS		4
 #define CAST5_DEC_TEST_VECTORS		4
-- 
2.7.4
