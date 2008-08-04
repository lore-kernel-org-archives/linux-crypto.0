From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 3/5] crypto: tcrypt - Add alg_test interface
Date: Mon, 04 Aug 2008 15:02:38 +0800
Message-ID: <E1KPu5W-0002An-00@gondolin.me.apana.org.au>
References: <20080804065958.GA8264@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:44857 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1761471AbYHDHCn (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 4 Aug 2008 03:02:43 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6] ident=mail)
	by arnor.apana.org.au with esmtp (Exim 4.63 #1 (Debian))
	id 1KPu5W-0001oq-UY
	for <linux-crypto@vger.kernel.org>; Mon, 04 Aug 2008 17:02:39 +1000
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

crypto: tcrypt - Add alg_test interface

This patch creates a new interface algorithm testing.  A test can
be requested for a particular implementation of an algorithm.  This
is achieved by taking both the name of the algorithm and that of
the implementation.

The all-inclusive test has also been rewritten to no longer require
a duplicate listing of all algorithms with tests.  In that process
a number of missing tests have also been discovered and rectified.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/tcrypt.c | 1454 +++++++++++++++++++++++++++++++++++++++-----------------
 1 file changed, 1017 insertions(+), 437 deletions(-)

diff --git a/crypto/tcrypt.c b/crypto/tcrypt.c
index c89c30e..64f7532 100644
--- a/crypto/tcrypt.c
+++ b/crypto/tcrypt.c
@@ -59,6 +59,45 @@ struct tcrypt_result {
 	int err;
 };
 
+struct aead_test_suite {
+	struct {
+		struct aead_testvec *vecs;
+		unsigned int count;
+	} enc, dec;
+};
+
+struct cipher_test_suite {
+	struct {
+		struct cipher_testvec *vecs;
+		unsigned int count;
+	} enc, dec;
+};
+
+struct comp_test_suite {
+	struct {
+		struct comp_testvec *vecs;
+		unsigned int count;
+	} comp, decomp;
+};
+
+struct hash_test_suite {
+	struct hash_testvec *vecs;
+	unsigned int count;
+};
+
+struct alg_test_desc {
+	const char *alg;
+	int (*test)(const struct alg_test_desc *desc, const char *driver,
+		    u32 type, u32 mask);
+
+	union {
+		struct aead_test_suite aead;
+		struct cipher_test_suite cipher;
+		struct comp_test_suite comp;
+		struct hash_test_suite hash;
+	} suite;
+};
+
 static unsigned int IDX[8] = { IDX1, IDX2, IDX3, IDX4, IDX5, IDX6, IDX7, IDX8 };
 
 /*
@@ -98,13 +137,13 @@ static void tcrypt_complete(struct crypto_async_request *req, int err)
 	complete(&res->completion);
 }
 
-static int test_hash(char *algo, struct hash_testvec *template,
+static int test_hash(struct crypto_ahash *tfm, struct hash_testvec *template,
 		     unsigned int tcount)
 {
+	const char *algo = crypto_tfm_alg_driver_name(crypto_ahash_tfm(tfm));
 	unsigned int i, j, k, temp;
 	struct scatterlist sg[8];
 	char result[64];
-	struct crypto_ahash *tfm;
 	struct ahash_request *req;
 	struct tcrypt_result tresult;
 	int ret;
@@ -112,13 +151,6 @@ static int test_hash(char *algo, struct hash_testvec *template,
 
 	init_completion(&tresult.completion);
 
-	tfm = crypto_alloc_ahash(algo, 0, 0);
-	if (IS_ERR(tfm)) {
-		printk(KERN_ERR "alg: hash: Failed to load transform for %s: "
-		       "%ld\n", algo, PTR_ERR(tfm));
-		return PTR_ERR(tfm);
-	}
-
 	req = ahash_request_alloc(tfm, GFP_KERNEL);
 	if (!req) {
 		printk(KERN_ERR "alg: hash: Failed to allocate request for "
@@ -249,17 +281,16 @@ static int test_hash(char *algo, struct hash_testvec *template,
 out:
 	ahash_request_free(req);
 out_noreq:
-	crypto_free_ahash(tfm);
 	return ret;
 }
 
-static int test_aead(char *algo, int enc, struct aead_testvec *template,
-		     unsigned int tcount)
+static int test_aead(struct crypto_aead *tfm, int enc,
+		     struct aead_testvec *template, unsigned int tcount)
 {
+	const char *algo = crypto_tfm_alg_driver_name(crypto_aead_tfm(tfm));
 	unsigned int i, j, k, n, temp;
 	int ret = 0;
 	char *q;
-	struct crypto_aead *tfm;
 	char *key;
 	struct aead_request *req;
 	struct scatterlist sg[8];
@@ -278,14 +309,6 @@ static int test_aead(char *algo, int enc, struct aead_testvec *template,
 
 	init_completion(&result.completion);
 
-	tfm = crypto_alloc_aead(algo, 0, 0);
-
-	if (IS_ERR(tfm)) {
-		printk(KERN_ERR "alg: aead: Failed to load transform for %s: "
-		       "%ld\n", algo, PTR_ERR(tfm));
-		return PTR_ERR(tfm);
-	}
-
 	req = aead_request_alloc(tfm, GFP_KERNEL);
 	if (!req) {
 		printk(KERN_ERR "alg: aead: Failed to allocate request for "
@@ -537,18 +560,18 @@ static int test_aead(char *algo, int enc, struct aead_testvec *template,
 	ret = 0;
 
 out:
-	crypto_free_aead(tfm);
 	aead_request_free(req);
 	return ret;
 }
 
-static int test_cipher(char *algo, int enc,
+static int test_cipher(struct crypto_ablkcipher *tfm, int enc,
 		       struct cipher_testvec *template, unsigned int tcount)
 {
+	const char *algo =
+		crypto_tfm_alg_driver_name(crypto_ablkcipher_tfm(tfm));
 	unsigned int i, j, k, n, temp;
 	int ret;
 	char *q;
-	struct crypto_ablkcipher *tfm;
 	struct ablkcipher_request *req;
 	struct scatterlist sg[8];
 	const char *e;
@@ -562,13 +585,6 @@ static int test_cipher(char *algo, int enc,
 		e = "decryption";
 
 	init_completion(&result.completion);
-	tfm = crypto_alloc_ablkcipher(algo, 0, 0);
-
-	if (IS_ERR(tfm)) {
-		printk(KERN_ERR "alg: cipher: Failed to load transform for "
-		       "%s: %ld\n", algo, PTR_ERR(tfm));
-		return PTR_ERR(tfm);
-	}
 
 	req = ablkcipher_request_alloc(tfm, GFP_KERNEL);
 	if (!req) {
@@ -836,7 +852,7 @@ out:
 
 static u32 block_sizes[] = { 16, 64, 256, 1024, 8192, 0 };
 
-static void test_cipher_speed(char *algo, int enc, unsigned int sec,
+static void test_cipher_speed(const char *algo, int enc, unsigned int sec,
 			      struct cipher_testvec *template,
 			      unsigned int tcount, u8 *keysize)
 {
@@ -1096,8 +1112,8 @@ out:
 	return 0;
 }
 
-static void test_hash_speed(char *algo, unsigned int sec,
-			      struct hash_speed *speed)
+static void test_hash_speed(const char *algo, unsigned int sec,
+			    struct hash_speed *speed)
 {
 	struct scatterlist sg[TVMEMSIZE];
 	struct crypto_hash *tfm;
@@ -1158,21 +1174,14 @@ out:
 	crypto_free_hash(tfm);
 }
 
-static int test_comp(char *algo, struct comp_testvec *ctemplate,
+static int test_comp(struct crypto_comp *tfm, struct comp_testvec *ctemplate,
 		     struct comp_testvec *dtemplate, int ctcount, int dtcount)
 {
+	const char *algo = crypto_tfm_alg_driver_name(crypto_comp_tfm(tfm));
 	unsigned int i;
 	char result[COMP_BUF_SIZE];
-	struct crypto_comp *tfm;
 	int ret;
 
-	tfm = crypto_alloc_comp(algo, 0, CRYPTO_ALG_ASYNC);
-	if (IS_ERR(tfm)) {
-		printk(KERN_ERR "alg: comp: Failed to load transform for %s: "
-		       "%ld\n", algo, PTR_ERR(tfm));
-		return PTR_ERR(tfm);
-	}
-
 	for (i = 0; i < ctcount; i++) {
 		int ilen, dlen = COMP_BUF_SIZE;
 
@@ -1224,7 +1233,6 @@ static int test_comp(char *algo, struct comp_testvec *ctemplate,
 	ret = 0;
 
 out:
-	crypto_free_comp(tfm);
 	return ret;
 }
 
@@ -1240,549 +1248,1126 @@ static void test_available(void)
 	}
 }
 
-static void do_test(void)
+static int alg_test_aead(const struct alg_test_desc *desc, const char *driver,
+			 u32 type, u32 mask)
 {
-	switch (mode) {
+	struct crypto_aead *tfm;
+	int err = 0;
+
+	tfm = crypto_alloc_aead(driver, type, mask);
+	if (IS_ERR(tfm)) {
+		printk(KERN_ERR "alg: aead: Failed to load transform for %s: "
+		       "%ld\n", driver, PTR_ERR(tfm));
+		return PTR_ERR(tfm);
+	}
+
+	if (desc->suite.aead.enc.vecs) {
+		err = test_aead(tfm, ENCRYPT, desc->suite.aead.enc.vecs,
+				desc->suite.aead.enc.count);
+		if (err)
+			goto out;
+	}
+
+	if (!err && desc->suite.aead.dec.vecs)
+		err = test_aead(tfm, DECRYPT, desc->suite.aead.dec.vecs,
+				desc->suite.aead.dec.count);
+
+out:
+	crypto_free_aead(tfm);
+	return err;
+}
+
+static int alg_test_cipher(const struct alg_test_desc *desc,
+			   const char *driver, u32 type, u32 mask)
+{
+	struct crypto_ablkcipher *tfm;
+	int err = 0;
+
+	tfm = crypto_alloc_ablkcipher(driver, type, mask);
+	if (IS_ERR(tfm)) {
+		printk(KERN_ERR "alg: cipher: Failed to load transform for "
+		       "%s: %ld\n", driver, PTR_ERR(tfm));
+		return PTR_ERR(tfm);
+	}
+
+	if (desc->suite.cipher.enc.vecs) {
+		err = test_cipher(tfm, ENCRYPT, desc->suite.cipher.enc.vecs,
+				  desc->suite.cipher.enc.count);
+		if (err)
+			goto out;
+	}
+
+	if (desc->suite.cipher.dec.vecs)
+		err = test_cipher(tfm, DECRYPT, desc->suite.cipher.dec.vecs,
+				  desc->suite.cipher.dec.count);
+
+out:
+	crypto_free_ablkcipher(tfm);
+	return err;
+}
 
+static int alg_test_comp(const struct alg_test_desc *desc, const char *driver,
+			 u32 type, u32 mask)
+{
+	struct crypto_comp *tfm;
+	int err;
+
+	tfm = crypto_alloc_comp(driver, type, mask);
+	if (IS_ERR(tfm)) {
+		printk(KERN_ERR "alg: comp: Failed to load transform for %s: "
+		       "%ld\n", driver, PTR_ERR(tfm));
+		return PTR_ERR(tfm);
+	}
+
+	err = test_comp(tfm, desc->suite.comp.comp.vecs,
+			desc->suite.comp.decomp.vecs,
+			desc->suite.comp.comp.count,
+			desc->suite.comp.decomp.count);
+
+	crypto_free_comp(tfm);
+	return err;
+}
+
+static int alg_test_hash(const struct alg_test_desc *desc, const char *driver,
+			 u32 type, u32 mask)
+{
+	struct crypto_ahash *tfm;
+	int err;
+
+	tfm = crypto_alloc_ahash(driver, type, mask);
+	if (IS_ERR(tfm)) {
+		printk(KERN_ERR "alg: hash: Failed to load transform for %s: "
+		       "%ld\n", driver, PTR_ERR(tfm));
+		return PTR_ERR(tfm);
+	}
+
+	err = test_hash(tfm, desc->suite.hash.vecs, desc->suite.hash.count);
+
+	crypto_free_ahash(tfm);
+	return err;
+}
+
+/* Please keep this list sorted by algorithm name. */
+static const struct alg_test_desc alg_test_descs[] = {
+	{
+		.alg = "cbc(aes)",
+		.test = alg_test_cipher,
+		.suite = {
+			.cipher = {
+				.enc = {
+					.vecs = aes_cbc_enc_tv_template,
+					.count = AES_CBC_ENC_TEST_VECTORS
+				},
+				.dec = {
+					.vecs = aes_cbc_dec_tv_template,
+					.count = AES_CBC_DEC_TEST_VECTORS
+				}
+			}
+		}
+	}, {
+		.alg = "cbc(anubis)",
+		.test = alg_test_cipher,
+		.suite = {
+			.cipher = {
+				.enc = {
+					.vecs = anubis_cbc_enc_tv_template,
+					.count = ANUBIS_CBC_ENC_TEST_VECTORS
+				},
+				.dec = {
+					.vecs = anubis_cbc_dec_tv_template,
+					.count = ANUBIS_CBC_DEC_TEST_VECTORS
+				}
+			}
+		}
+	}, {
+		.alg = "cbc(blowfish)",
+		.test = alg_test_cipher,
+		.suite = {
+			.cipher = {
+				.enc = {
+					.vecs = bf_cbc_enc_tv_template,
+					.count = BF_CBC_ENC_TEST_VECTORS
+				},
+				.dec = {
+					.vecs = bf_cbc_dec_tv_template,
+					.count = BF_CBC_DEC_TEST_VECTORS
+				}
+			}
+		}
+	}, {
+		.alg = "cbc(camellia)",
+		.test = alg_test_cipher,
+		.suite = {
+			.cipher = {
+				.enc = {
+					.vecs = camellia_cbc_enc_tv_template,
+					.count = CAMELLIA_CBC_ENC_TEST_VECTORS
+				},
+				.dec = {
+					.vecs = camellia_cbc_dec_tv_template,
+					.count = CAMELLIA_CBC_DEC_TEST_VECTORS
+				}
+			}
+		}
+	}, {
+		.alg = "cbc(des)",
+		.test = alg_test_cipher,
+		.suite = {
+			.cipher = {
+				.enc = {
+					.vecs = des_cbc_enc_tv_template,
+					.count = DES_CBC_ENC_TEST_VECTORS
+				},
+				.dec = {
+					.vecs = des_cbc_dec_tv_template,
+					.count = DES_CBC_DEC_TEST_VECTORS
+				}
+			}
+		}
+	}, {
+		.alg = "cbc(des3_ede)",
+		.test = alg_test_cipher,
+		.suite = {
+			.cipher = {
+				.enc = {
+					.vecs = des3_ede_cbc_enc_tv_template,
+					.count = DES3_EDE_CBC_ENC_TEST_VECTORS
+				},
+				.dec = {
+					.vecs = des3_ede_cbc_dec_tv_template,
+					.count = DES3_EDE_CBC_DEC_TEST_VECTORS
+				}
+			}
+		}
+	}, {
+		.alg = "cbc(twofish)",
+		.test = alg_test_cipher,
+		.suite = {
+			.cipher = {
+				.enc = {
+					.vecs = tf_cbc_enc_tv_template,
+					.count = TF_CBC_ENC_TEST_VECTORS
+				},
+				.dec = {
+					.vecs = tf_cbc_dec_tv_template,
+					.count = TF_CBC_DEC_TEST_VECTORS
+				}
+			}
+		}
+	}, {
+		.alg = "ccm(aes)",
+		.test = alg_test_aead,
+		.suite = {
+			.aead = {
+				.enc = {
+					.vecs = aes_ccm_enc_tv_template,
+					.count = AES_CCM_ENC_TEST_VECTORS
+				},
+				.dec = {
+					.vecs = aes_ccm_dec_tv_template,
+					.count = AES_CCM_DEC_TEST_VECTORS
+				}
+			}
+		}
+	}, {
+		.alg = "crc32c",
+		.test = alg_test_hash,
+		.suite = {
+			.hash = {
+				.vecs = crc32c_tv_template,
+				.count = CRC32C_TEST_VECTORS
+			}
+		}
+	}, {
+		.alg = "cts(cbc(aes))",
+		.test = alg_test_cipher,
+		.suite = {
+			.cipher = {
+				.enc = {
+					.vecs = cts_mode_enc_tv_template,
+					.count = CTS_MODE_ENC_TEST_VECTORS
+				},
+				.dec = {
+					.vecs = cts_mode_dec_tv_template,
+					.count = CTS_MODE_DEC_TEST_VECTORS
+				}
+			}
+		}
+	}, {
+		.alg = "deflate",
+		.test = alg_test_comp,
+		.suite = {
+			.comp = {
+				.comp = {
+					.vecs = deflate_comp_tv_template,
+					.count = DEFLATE_COMP_TEST_VECTORS
+				},
+				.decomp = {
+					.vecs = deflate_decomp_tv_template,
+					.count = DEFLATE_DECOMP_TEST_VECTORS
+				}
+			}
+		}
+	}, {
+		.alg = "ecb(aes)",
+		.test = alg_test_cipher,
+		.suite = {
+			.cipher = {
+				.enc = {
+					.vecs = aes_enc_tv_template,
+					.count = AES_ENC_TEST_VECTORS
+				},
+				.dec = {
+					.vecs = aes_dec_tv_template,
+					.count = AES_DEC_TEST_VECTORS
+				}
+			}
+		}
+	}, {
+		.alg = "ecb(anubis)",
+		.test = alg_test_cipher,
+		.suite = {
+			.cipher = {
+				.enc = {
+					.vecs = anubis_enc_tv_template,
+					.count = ANUBIS_ENC_TEST_VECTORS
+				},
+				.dec = {
+					.vecs = anubis_dec_tv_template,
+					.count = ANUBIS_DEC_TEST_VECTORS
+				}
+			}
+		}
+	}, {
+		.alg = "ecb(arc4)",
+		.test = alg_test_cipher,
+		.suite = {
+			.cipher = {
+				.enc = {
+					.vecs = arc4_enc_tv_template,
+					.count = ARC4_ENC_TEST_VECTORS
+				},
+				.dec = {
+					.vecs = arc4_dec_tv_template,
+					.count = ARC4_DEC_TEST_VECTORS
+				}
+			}
+		}
+	}, {
+		.alg = "ecb(blowfish)",
+		.test = alg_test_cipher,
+		.suite = {
+			.cipher = {
+				.enc = {
+					.vecs = bf_enc_tv_template,
+					.count = BF_ENC_TEST_VECTORS
+				},
+				.dec = {
+					.vecs = bf_dec_tv_template,
+					.count = BF_DEC_TEST_VECTORS
+				}
+			}
+		}
+	}, {
+		.alg = "ecb(camellia)",
+		.test = alg_test_cipher,
+		.suite = {
+			.cipher = {
+				.enc = {
+					.vecs = camellia_enc_tv_template,
+					.count = CAMELLIA_ENC_TEST_VECTORS
+				},
+				.dec = {
+					.vecs = camellia_dec_tv_template,
+					.count = CAMELLIA_DEC_TEST_VECTORS
+				}
+			}
+		}
+	}, {
+		.alg = "ecb(cast5)",
+		.test = alg_test_cipher,
+		.suite = {
+			.cipher = {
+				.enc = {
+					.vecs = cast5_enc_tv_template,
+					.count = CAST5_ENC_TEST_VECTORS
+				},
+				.dec = {
+					.vecs = cast5_dec_tv_template,
+					.count = CAST5_DEC_TEST_VECTORS
+				}
+			}
+		}
+	}, {
+		.alg = "ecb(cast6)",
+		.test = alg_test_cipher,
+		.suite = {
+			.cipher = {
+				.enc = {
+					.vecs = cast6_enc_tv_template,
+					.count = CAST6_ENC_TEST_VECTORS
+				},
+				.dec = {
+					.vecs = cast6_dec_tv_template,
+					.count = CAST6_DEC_TEST_VECTORS
+				}
+			}
+		}
+	}, {
+		.alg = "ecb(des)",
+		.test = alg_test_cipher,
+		.suite = {
+			.cipher = {
+				.enc = {
+					.vecs = des_enc_tv_template,
+					.count = DES_ENC_TEST_VECTORS
+				},
+				.dec = {
+					.vecs = des_dec_tv_template,
+					.count = DES_DEC_TEST_VECTORS
+				}
+			}
+		}
+	}, {
+		.alg = "ecb(des3_ede)",
+		.test = alg_test_cipher,
+		.suite = {
+			.cipher = {
+				.enc = {
+					.vecs = des3_ede_enc_tv_template,
+					.count = DES3_EDE_ENC_TEST_VECTORS
+				},
+				.dec = {
+					.vecs = des3_ede_dec_tv_template,
+					.count = DES3_EDE_DEC_TEST_VECTORS
+				}
+			}
+		}
+	}, {
+		.alg = "ecb(khazad)",
+		.test = alg_test_cipher,
+		.suite = {
+			.cipher = {
+				.enc = {
+					.vecs = khazad_enc_tv_template,
+					.count = KHAZAD_ENC_TEST_VECTORS
+				},
+				.dec = {
+					.vecs = khazad_dec_tv_template,
+					.count = KHAZAD_DEC_TEST_VECTORS
+				}
+			}
+		}
+	}, {
+		.alg = "ecb(seed)",
+		.test = alg_test_cipher,
+		.suite = {
+			.cipher = {
+				.enc = {
+					.vecs = seed_enc_tv_template,
+					.count = SEED_ENC_TEST_VECTORS
+				},
+				.dec = {
+					.vecs = seed_dec_tv_template,
+					.count = SEED_DEC_TEST_VECTORS
+				}
+			}
+		}
+	}, {
+		.alg = "ecb(serpent)",
+		.test = alg_test_cipher,
+		.suite = {
+			.cipher = {
+				.enc = {
+					.vecs = serpent_enc_tv_template,
+					.count = SERPENT_ENC_TEST_VECTORS
+				},
+				.dec = {
+					.vecs = serpent_dec_tv_template,
+					.count = SERPENT_DEC_TEST_VECTORS
+				}
+			}
+		}
+	}, {
+		.alg = "ecb(tea)",
+		.test = alg_test_cipher,
+		.suite = {
+			.cipher = {
+				.enc = {
+					.vecs = tea_enc_tv_template,
+					.count = TEA_ENC_TEST_VECTORS
+				},
+				.dec = {
+					.vecs = tea_dec_tv_template,
+					.count = TEA_DEC_TEST_VECTORS
+				}
+			}
+		}
+	}, {
+		.alg = "ecb(tnepres)",
+		.test = alg_test_cipher,
+		.suite = {
+			.cipher = {
+				.enc = {
+					.vecs = tnepres_enc_tv_template,
+					.count = TNEPRES_ENC_TEST_VECTORS
+				},
+				.dec = {
+					.vecs = tnepres_dec_tv_template,
+					.count = TNEPRES_DEC_TEST_VECTORS
+				}
+			}
+		}
+	}, {
+		.alg = "ecb(twofish)",
+		.test = alg_test_cipher,
+		.suite = {
+			.cipher = {
+				.enc = {
+					.vecs = tf_enc_tv_template,
+					.count = TF_ENC_TEST_VECTORS
+				},
+				.dec = {
+					.vecs = tf_dec_tv_template,
+					.count = TF_DEC_TEST_VECTORS
+				}
+			}
+		}
+	}, {
+		.alg = "ecb(xeta)",
+		.test = alg_test_cipher,
+		.suite = {
+			.cipher = {
+				.enc = {
+					.vecs = xeta_enc_tv_template,
+					.count = XETA_ENC_TEST_VECTORS
+				},
+				.dec = {
+					.vecs = xeta_dec_tv_template,
+					.count = XETA_DEC_TEST_VECTORS
+				}
+			}
+		}
+	}, {
+		.alg = "ecb(xtea)",
+		.test = alg_test_cipher,
+		.suite = {
+			.cipher = {
+				.enc = {
+					.vecs = xtea_enc_tv_template,
+					.count = XTEA_ENC_TEST_VECTORS
+				},
+				.dec = {
+					.vecs = xtea_dec_tv_template,
+					.count = XTEA_DEC_TEST_VECTORS
+				}
+			}
+		}
+	}, {
+		.alg = "gcm(aes)",
+		.test = alg_test_aead,
+		.suite = {
+			.aead = {
+				.enc = {
+					.vecs = aes_gcm_enc_tv_template,
+					.count = AES_GCM_ENC_TEST_VECTORS
+				},
+				.dec = {
+					.vecs = aes_gcm_dec_tv_template,
+					.count = AES_GCM_DEC_TEST_VECTORS
+				}
+			}
+		}
+	}, {
+		.alg = "hmac(md5)",
+		.test = alg_test_hash,
+		.suite = {
+			.hash = {
+				.vecs = hmac_md5_tv_template,
+				.count = HMAC_MD5_TEST_VECTORS
+			}
+		}
+	}, {
+		.alg = "hmac(rmd128)",
+		.test = alg_test_hash,
+		.suite = {
+			.hash = {
+				.vecs = hmac_rmd128_tv_template,
+				.count = HMAC_RMD128_TEST_VECTORS
+			}
+		}
+	}, {
+		.alg = "hmac(rmd160)",
+		.test = alg_test_hash,
+		.suite = {
+			.hash = {
+				.vecs = hmac_rmd160_tv_template,
+				.count = HMAC_RMD160_TEST_VECTORS
+			}
+		}
+	}, {
+		.alg = "hmac(sha1)",
+		.test = alg_test_hash,
+		.suite = {
+			.hash = {
+				.vecs = hmac_sha1_tv_template,
+				.count = HMAC_SHA1_TEST_VECTORS
+			}
+		}
+	}, {
+		.alg = "hmac(sha224)",
+		.test = alg_test_hash,
+		.suite = {
+			.hash = {
+				.vecs = hmac_sha224_tv_template,
+				.count = HMAC_SHA224_TEST_VECTORS
+			}
+		}
+	}, {
+		.alg = "hmac(sha256)",
+		.test = alg_test_hash,
+		.suite = {
+			.hash = {
+				.vecs = hmac_sha256_tv_template,
+				.count = HMAC_SHA256_TEST_VECTORS
+			}
+		}
+	}, {
+		.alg = "hmac(sha384)",
+		.test = alg_test_hash,
+		.suite = {
+			.hash = {
+				.vecs = hmac_sha384_tv_template,
+				.count = HMAC_SHA384_TEST_VECTORS
+			}
+		}
+	}, {
+		.alg = "hmac(sha512)",
+		.test = alg_test_hash,
+		.suite = {
+			.hash = {
+				.vecs = hmac_sha512_tv_template,
+				.count = HMAC_SHA512_TEST_VECTORS
+			}
+		}
+	}, {
+		.alg = "lrw(aes)",
+		.test = alg_test_cipher,
+		.suite = {
+			.cipher = {
+				.enc = {
+					.vecs = aes_lrw_enc_tv_template,
+					.count = AES_LRW_ENC_TEST_VECTORS
+				},
+				.dec = {
+					.vecs = aes_lrw_dec_tv_template,
+					.count = AES_LRW_DEC_TEST_VECTORS
+				}
+			}
+		}
+	}, {
+		.alg = "lzo",
+		.test = alg_test_comp,
+		.suite = {
+			.comp = {
+				.comp = {
+					.vecs = lzo_comp_tv_template,
+					.count = LZO_COMP_TEST_VECTORS
+				},
+				.decomp = {
+					.vecs = lzo_decomp_tv_template,
+					.count = LZO_DECOMP_TEST_VECTORS
+				}
+			}
+		}
+	}, {
+		.alg = "md4",
+		.test = alg_test_hash,
+		.suite = {
+			.hash = {
+				.vecs = md4_tv_template,
+				.count = MD4_TEST_VECTORS
+			}
+		}
+	}, {
+		.alg = "md5",
+		.test = alg_test_hash,
+		.suite = {
+			.hash = {
+				.vecs = md5_tv_template,
+				.count = MD5_TEST_VECTORS
+			}
+		}
+	}, {
+		.alg = "michael_mic",
+		.test = alg_test_hash,
+		.suite = {
+			.hash = {
+				.vecs = michael_mic_tv_template,
+				.count = MICHAEL_MIC_TEST_VECTORS
+			}
+		}
+	}, {
+		.alg = "pcbc(fcrypt)",
+		.test = alg_test_cipher,
+		.suite = {
+			.cipher = {
+				.enc = {
+					.vecs = fcrypt_pcbc_enc_tv_template,
+					.count = FCRYPT_ENC_TEST_VECTORS
+				},
+				.dec = {
+					.vecs = fcrypt_pcbc_dec_tv_template,
+					.count = FCRYPT_DEC_TEST_VECTORS
+				}
+			}
+		}
+	}, {
+		.alg = "rfc3686(ctr(aes))",
+		.test = alg_test_cipher,
+		.suite = {
+			.cipher = {
+				.enc = {
+					.vecs = aes_ctr_enc_tv_template,
+					.count = AES_CTR_ENC_TEST_VECTORS
+				},
+				.dec = {
+					.vecs = aes_ctr_dec_tv_template,
+					.count = AES_CTR_DEC_TEST_VECTORS
+				}
+			}
+		}
+	}, {
+		.alg = "rmd128",
+		.test = alg_test_hash,
+		.suite = {
+			.hash = {
+				.vecs = rmd128_tv_template,
+				.count = RMD128_TEST_VECTORS
+			}
+		}
+	}, {
+		.alg = "rmd160",
+		.test = alg_test_hash,
+		.suite = {
+			.hash = {
+				.vecs = rmd160_tv_template,
+				.count = RMD160_TEST_VECTORS
+			}
+		}
+	}, {
+		.alg = "rmd256",
+		.test = alg_test_hash,
+		.suite = {
+			.hash = {
+				.vecs = rmd256_tv_template,
+				.count = RMD256_TEST_VECTORS
+			}
+		}
+	}, {
+		.alg = "rmd320",
+		.test = alg_test_hash,
+		.suite = {
+			.hash = {
+				.vecs = rmd320_tv_template,
+				.count = RMD320_TEST_VECTORS
+			}
+		}
+	}, {
+		.alg = "salsa20",
+		.test = alg_test_cipher,
+		.suite = {
+			.cipher = {
+				.enc = {
+					.vecs = salsa20_stream_enc_tv_template,
+					.count = SALSA20_STREAM_ENC_TEST_VECTORS
+				}
+			}
+		}
+	}, {
+		.alg = "sha1",
+		.test = alg_test_hash,
+		.suite = {
+			.hash = {
+				.vecs = sha1_tv_template,
+				.count = SHA1_TEST_VECTORS
+			}
+		}
+	}, {
+		.alg = "sha224",
+		.test = alg_test_hash,
+		.suite = {
+			.hash = {
+				.vecs = sha224_tv_template,
+				.count = SHA224_TEST_VECTORS
+			}
+		}
+	}, {
+		.alg = "sha256",
+		.test = alg_test_hash,
+		.suite = {
+			.hash = {
+				.vecs = sha256_tv_template,
+				.count = SHA256_TEST_VECTORS
+			}
+		}
+	}, {
+		.alg = "sha384",
+		.test = alg_test_hash,
+		.suite = {
+			.hash = {
+				.vecs = sha384_tv_template,
+				.count = SHA384_TEST_VECTORS
+			}
+		}
+	}, {
+		.alg = "sha512",
+		.test = alg_test_hash,
+		.suite = {
+			.hash = {
+				.vecs = sha512_tv_template,
+				.count = SHA512_TEST_VECTORS
+			}
+		}
+	}, {
+		.alg = "tgr128",
+		.test = alg_test_hash,
+		.suite = {
+			.hash = {
+				.vecs = tgr128_tv_template,
+				.count = TGR128_TEST_VECTORS
+			}
+		}
+	}, {
+		.alg = "tgr160",
+		.test = alg_test_hash,
+		.suite = {
+			.hash = {
+				.vecs = tgr160_tv_template,
+				.count = TGR160_TEST_VECTORS
+			}
+		}
+	}, {
+		.alg = "tgr192",
+		.test = alg_test_hash,
+		.suite = {
+			.hash = {
+				.vecs = tgr192_tv_template,
+				.count = TGR192_TEST_VECTORS
+			}
+		}
+	}, {
+		.alg = "wp256",
+		.test = alg_test_hash,
+		.suite = {
+			.hash = {
+				.vecs = wp256_tv_template,
+				.count = WP256_TEST_VECTORS
+			}
+		}
+	}, {
+		.alg = "wp384",
+		.test = alg_test_hash,
+		.suite = {
+			.hash = {
+				.vecs = wp384_tv_template,
+				.count = WP384_TEST_VECTORS
+			}
+		}
+	}, {
+		.alg = "wp512",
+		.test = alg_test_hash,
+		.suite = {
+			.hash = {
+				.vecs = wp512_tv_template,
+				.count = WP512_TEST_VECTORS
+			}
+		}
+	}, {
+		.alg = "xcbc(aes)",
+		.test = alg_test_hash,
+		.suite = {
+			.hash = {
+				.vecs = aes_xcbc128_tv_template,
+				.count = XCBC_AES_TEST_VECTORS
+			}
+		}
+	}, {
+		.alg = "xts(aes)",
+		.test = alg_test_cipher,
+		.suite = {
+			.cipher = {
+				.enc = {
+					.vecs = aes_xts_enc_tv_template,
+					.count = AES_XTS_ENC_TEST_VECTORS
+				},
+				.dec = {
+					.vecs = aes_xts_dec_tv_template,
+					.count = AES_XTS_DEC_TEST_VECTORS
+				}
+			}
+		}
+	},
+};
+
+static int alg_test(const char *driver, const char *alg, u32 type, u32 mask)
+{
+	int start = 0;
+	int end = ARRAY_SIZE(alg_test_descs);
+
+	while (start < end) {
+		int i = (start + end) / 2;
+		int diff = strcmp(alg_test_descs[i].alg, alg);
+
+		if (diff > 0) {
+			end = i;
+			continue;
+		}
+
+		if (diff < 0) {
+			start = i + 1;
+			continue;
+		}
+
+		return alg_test_descs[i].test(alg_test_descs + i, driver,
+					      type, mask);
+	}
+
+	printk(KERN_INFO "alg: No test for %s (%s)\n", alg, driver);
+	return 0;
+}
+
+static inline int tcrypt_test(const char *alg)
+{
+	return alg_test(alg, alg, 0, 0);
+}
+
+static void do_test(int m)
+{
+	int i;
+
+	switch (m) {
 	case 0:
-		test_hash("md5", md5_tv_template, MD5_TEST_VECTORS);
-
-		test_hash("sha1", sha1_tv_template, SHA1_TEST_VECTORS);
-
-		//DES
-		test_cipher("ecb(des)", ENCRYPT, des_enc_tv_template,
-			    DES_ENC_TEST_VECTORS);
-		test_cipher("ecb(des)", DECRYPT, des_dec_tv_template,
-			    DES_DEC_TEST_VECTORS);
-		test_cipher("cbc(des)", ENCRYPT, des_cbc_enc_tv_template,
-			    DES_CBC_ENC_TEST_VECTORS);
-		test_cipher("cbc(des)", DECRYPT, des_cbc_dec_tv_template,
-			    DES_CBC_DEC_TEST_VECTORS);
-
-		//DES3_EDE
-		test_cipher("ecb(des3_ede)", ENCRYPT, des3_ede_enc_tv_template,
-			    DES3_EDE_ENC_TEST_VECTORS);
-		test_cipher("ecb(des3_ede)", DECRYPT, des3_ede_dec_tv_template,
-			    DES3_EDE_DEC_TEST_VECTORS);
-
-		test_cipher("cbc(des3_ede)", ENCRYPT,
-			    des3_ede_cbc_enc_tv_template,
-			    DES3_EDE_CBC_ENC_TEST_VECTORS);
-
-		test_cipher("cbc(des3_ede)", DECRYPT,
-			    des3_ede_cbc_dec_tv_template,
-			    DES3_EDE_CBC_DEC_TEST_VECTORS);
-
-		test_hash("md4", md4_tv_template, MD4_TEST_VECTORS);
-
-		test_hash("sha224", sha224_tv_template, SHA224_TEST_VECTORS);
-
-		test_hash("sha256", sha256_tv_template, SHA256_TEST_VECTORS);
-
-		//BLOWFISH
-		test_cipher("ecb(blowfish)", ENCRYPT, bf_enc_tv_template,
-			    BF_ENC_TEST_VECTORS);
-		test_cipher("ecb(blowfish)", DECRYPT, bf_dec_tv_template,
-			    BF_DEC_TEST_VECTORS);
-		test_cipher("cbc(blowfish)", ENCRYPT, bf_cbc_enc_tv_template,
-			    BF_CBC_ENC_TEST_VECTORS);
-		test_cipher("cbc(blowfish)", DECRYPT, bf_cbc_dec_tv_template,
-			    BF_CBC_DEC_TEST_VECTORS);
-
-		//TWOFISH
-		test_cipher("ecb(twofish)", ENCRYPT, tf_enc_tv_template,
-			    TF_ENC_TEST_VECTORS);
-		test_cipher("ecb(twofish)", DECRYPT, tf_dec_tv_template,
-			    TF_DEC_TEST_VECTORS);
-		test_cipher("cbc(twofish)", ENCRYPT, tf_cbc_enc_tv_template,
-			    TF_CBC_ENC_TEST_VECTORS);
-		test_cipher("cbc(twofish)", DECRYPT, tf_cbc_dec_tv_template,
-			    TF_CBC_DEC_TEST_VECTORS);
-
-		//SERPENT
-		test_cipher("ecb(serpent)", ENCRYPT, serpent_enc_tv_template,
-			    SERPENT_ENC_TEST_VECTORS);
-		test_cipher("ecb(serpent)", DECRYPT, serpent_dec_tv_template,
-			    SERPENT_DEC_TEST_VECTORS);
-
-		//TNEPRES
-		test_cipher("ecb(tnepres)", ENCRYPT, tnepres_enc_tv_template,
-			    TNEPRES_ENC_TEST_VECTORS);
-		test_cipher("ecb(tnepres)", DECRYPT, tnepres_dec_tv_template,
-			    TNEPRES_DEC_TEST_VECTORS);
-
-		//AES
-		test_cipher("ecb(aes)", ENCRYPT, aes_enc_tv_template,
-			    AES_ENC_TEST_VECTORS);
-		test_cipher("ecb(aes)", DECRYPT, aes_dec_tv_template,
-			    AES_DEC_TEST_VECTORS);
-		test_cipher("cbc(aes)", ENCRYPT, aes_cbc_enc_tv_template,
-			    AES_CBC_ENC_TEST_VECTORS);
-		test_cipher("cbc(aes)", DECRYPT, aes_cbc_dec_tv_template,
-			    AES_CBC_DEC_TEST_VECTORS);
-		test_cipher("lrw(aes)", ENCRYPT, aes_lrw_enc_tv_template,
-			    AES_LRW_ENC_TEST_VECTORS);
-		test_cipher("lrw(aes)", DECRYPT, aes_lrw_dec_tv_template,
-			    AES_LRW_DEC_TEST_VECTORS);
-		test_cipher("xts(aes)", ENCRYPT, aes_xts_enc_tv_template,
-			    AES_XTS_ENC_TEST_VECTORS);
-		test_cipher("xts(aes)", DECRYPT, aes_xts_dec_tv_template,
-			    AES_XTS_DEC_TEST_VECTORS);
-		test_cipher("rfc3686(ctr(aes))", ENCRYPT, aes_ctr_enc_tv_template,
-			    AES_CTR_ENC_TEST_VECTORS);
-		test_cipher("rfc3686(ctr(aes))", DECRYPT, aes_ctr_dec_tv_template,
-			    AES_CTR_DEC_TEST_VECTORS);
-		test_aead("gcm(aes)", ENCRYPT, aes_gcm_enc_tv_template,
-			  AES_GCM_ENC_TEST_VECTORS);
-		test_aead("gcm(aes)", DECRYPT, aes_gcm_dec_tv_template,
-			  AES_GCM_DEC_TEST_VECTORS);
-		test_aead("ccm(aes)", ENCRYPT, aes_ccm_enc_tv_template,
-			  AES_CCM_ENC_TEST_VECTORS);
-		test_aead("ccm(aes)", DECRYPT, aes_ccm_dec_tv_template,
-			  AES_CCM_DEC_TEST_VECTORS);
-
-		//CAST5
-		test_cipher("ecb(cast5)", ENCRYPT, cast5_enc_tv_template,
-			    CAST5_ENC_TEST_VECTORS);
-		test_cipher("ecb(cast5)", DECRYPT, cast5_dec_tv_template,
-			    CAST5_DEC_TEST_VECTORS);
-
-		//CAST6
-		test_cipher("ecb(cast6)", ENCRYPT, cast6_enc_tv_template,
-			    CAST6_ENC_TEST_VECTORS);
-		test_cipher("ecb(cast6)", DECRYPT, cast6_dec_tv_template,
-			    CAST6_DEC_TEST_VECTORS);
-
-		//ARC4
-		test_cipher("ecb(arc4)", ENCRYPT, arc4_enc_tv_template,
-			    ARC4_ENC_TEST_VECTORS);
-		test_cipher("ecb(arc4)", DECRYPT, arc4_dec_tv_template,
-			    ARC4_DEC_TEST_VECTORS);
-
-		//TEA
-		test_cipher("ecb(tea)", ENCRYPT, tea_enc_tv_template,
-			    TEA_ENC_TEST_VECTORS);
-		test_cipher("ecb(tea)", DECRYPT, tea_dec_tv_template,
-			    TEA_DEC_TEST_VECTORS);
-
-
-		//XTEA
-		test_cipher("ecb(xtea)", ENCRYPT, xtea_enc_tv_template,
-			    XTEA_ENC_TEST_VECTORS);
-		test_cipher("ecb(xtea)", DECRYPT, xtea_dec_tv_template,
-			    XTEA_DEC_TEST_VECTORS);
-
-		//KHAZAD
-		test_cipher("ecb(khazad)", ENCRYPT, khazad_enc_tv_template,
-			    KHAZAD_ENC_TEST_VECTORS);
-		test_cipher("ecb(khazad)", DECRYPT, khazad_dec_tv_template,
-			    KHAZAD_DEC_TEST_VECTORS);
-
-		//ANUBIS
-		test_cipher("ecb(anubis)", ENCRYPT, anubis_enc_tv_template,
-			    ANUBIS_ENC_TEST_VECTORS);
-		test_cipher("ecb(anubis)", DECRYPT, anubis_dec_tv_template,
-			    ANUBIS_DEC_TEST_VECTORS);
-		test_cipher("cbc(anubis)", ENCRYPT, anubis_cbc_enc_tv_template,
-			    ANUBIS_CBC_ENC_TEST_VECTORS);
-		test_cipher("cbc(anubis)", DECRYPT, anubis_cbc_dec_tv_template,
-			    ANUBIS_CBC_ENC_TEST_VECTORS);
-
-		//XETA
-		test_cipher("ecb(xeta)", ENCRYPT, xeta_enc_tv_template,
-			    XETA_ENC_TEST_VECTORS);
-		test_cipher("ecb(xeta)", DECRYPT, xeta_dec_tv_template,
-			    XETA_DEC_TEST_VECTORS);
-
-		//FCrypt
-		test_cipher("pcbc(fcrypt)", ENCRYPT, fcrypt_pcbc_enc_tv_template,
-			    FCRYPT_ENC_TEST_VECTORS);
-		test_cipher("pcbc(fcrypt)", DECRYPT, fcrypt_pcbc_dec_tv_template,
-			    FCRYPT_DEC_TEST_VECTORS);
-
-		//CAMELLIA
-		test_cipher("ecb(camellia)", ENCRYPT,
-			    camellia_enc_tv_template,
-			    CAMELLIA_ENC_TEST_VECTORS);
-		test_cipher("ecb(camellia)", DECRYPT,
-			    camellia_dec_tv_template,
-			    CAMELLIA_DEC_TEST_VECTORS);
-		test_cipher("cbc(camellia)", ENCRYPT,
-			    camellia_cbc_enc_tv_template,
-			    CAMELLIA_CBC_ENC_TEST_VECTORS);
-		test_cipher("cbc(camellia)", DECRYPT,
-			    camellia_cbc_dec_tv_template,
-			    CAMELLIA_CBC_DEC_TEST_VECTORS);
-
-		//SEED
-		test_cipher("ecb(seed)", ENCRYPT, seed_enc_tv_template,
-			    SEED_ENC_TEST_VECTORS);
-		test_cipher("ecb(seed)", DECRYPT, seed_dec_tv_template,
-			    SEED_DEC_TEST_VECTORS);
-
-		//CTS
-		test_cipher("cts(cbc(aes))", ENCRYPT, cts_mode_enc_tv_template,
-			    CTS_MODE_ENC_TEST_VECTORS);
-		test_cipher("cts(cbc(aes))", DECRYPT, cts_mode_dec_tv_template,
-			    CTS_MODE_DEC_TEST_VECTORS);
-
-		test_hash("sha384", sha384_tv_template, SHA384_TEST_VECTORS);
-		test_hash("sha512", sha512_tv_template, SHA512_TEST_VECTORS);
-		test_hash("wp512", wp512_tv_template, WP512_TEST_VECTORS);
-		test_hash("wp384", wp384_tv_template, WP384_TEST_VECTORS);
-		test_hash("wp256", wp256_tv_template, WP256_TEST_VECTORS);
-		test_hash("tgr192", tgr192_tv_template, TGR192_TEST_VECTORS);
-		test_hash("tgr160", tgr160_tv_template, TGR160_TEST_VECTORS);
-		test_hash("tgr128", tgr128_tv_template, TGR128_TEST_VECTORS);
-		test_comp("deflate", deflate_comp_tv_template,
-			  deflate_decomp_tv_template, DEFLATE_COMP_TEST_VECTORS,
-			  DEFLATE_DECOMP_TEST_VECTORS);
-		test_comp("lzo", lzo_comp_tv_template, lzo_decomp_tv_template,
-			  LZO_COMP_TEST_VECTORS, LZO_DECOMP_TEST_VECTORS);
-		test_hash("crc32c", crc32c_tv_template, CRC32C_TEST_VECTORS);
-		test_hash("hmac(md5)", hmac_md5_tv_template,
-			  HMAC_MD5_TEST_VECTORS);
-		test_hash("hmac(sha1)", hmac_sha1_tv_template,
-			  HMAC_SHA1_TEST_VECTORS);
-		test_hash("hmac(sha224)", hmac_sha224_tv_template,
-			  HMAC_SHA224_TEST_VECTORS);
-		test_hash("hmac(sha256)", hmac_sha256_tv_template,
-			  HMAC_SHA256_TEST_VECTORS);
-		test_hash("hmac(sha384)", hmac_sha384_tv_template,
-			  HMAC_SHA384_TEST_VECTORS);
-		test_hash("hmac(sha512)", hmac_sha512_tv_template,
-			  HMAC_SHA512_TEST_VECTORS);
-
-		test_hash("xcbc(aes)", aes_xcbc128_tv_template,
-			  XCBC_AES_TEST_VECTORS);
-
-		test_hash("michael_mic", michael_mic_tv_template, MICHAEL_MIC_TEST_VECTORS);
+		for (i = 1; i < 200; i++)
+			do_test(i);
 		break;
 
 	case 1:
-		test_hash("md5", md5_tv_template, MD5_TEST_VECTORS);
+		tcrypt_test("md5");
 		break;
 
 	case 2:
-		test_hash("sha1", sha1_tv_template, SHA1_TEST_VECTORS);
+		tcrypt_test("sha1");
 		break;
 
 	case 3:
-		test_cipher("ecb(des)", ENCRYPT, des_enc_tv_template,
-			    DES_ENC_TEST_VECTORS);
-		test_cipher("ecb(des)", DECRYPT, des_dec_tv_template,
-			    DES_DEC_TEST_VECTORS);
-		test_cipher("cbc(des)", ENCRYPT, des_cbc_enc_tv_template,
-			    DES_CBC_ENC_TEST_VECTORS);
-		test_cipher("cbc(des)", DECRYPT, des_cbc_dec_tv_template,
-			    DES_CBC_DEC_TEST_VECTORS);
+		tcrypt_test("ecb(des)");
+		tcrypt_test("cbc(des)");
 		break;
 
 	case 4:
-		test_cipher("ecb(des3_ede)", ENCRYPT, des3_ede_enc_tv_template,
-			    DES3_EDE_ENC_TEST_VECTORS);
-		test_cipher("ecb(des3_ede)", DECRYPT, des3_ede_dec_tv_template,
-			    DES3_EDE_DEC_TEST_VECTORS);
-
-		test_cipher("cbc(des3_ede)", ENCRYPT,
-			    des3_ede_cbc_enc_tv_template,
-			    DES3_EDE_CBC_ENC_TEST_VECTORS);
-
-		test_cipher("cbc(des3_ede)", DECRYPT,
-			    des3_ede_cbc_dec_tv_template,
-			    DES3_EDE_CBC_DEC_TEST_VECTORS);
+		tcrypt_test("ecb(des3_ede)");
+		tcrypt_test("cbc(des3_ede)");
 		break;
 
 	case 5:
-		test_hash("md4", md4_tv_template, MD4_TEST_VECTORS);
+		tcrypt_test("md4");
 		break;
 
 	case 6:
-		test_hash("sha256", sha256_tv_template, SHA256_TEST_VECTORS);
+		tcrypt_test("sha256");
 		break;
 
 	case 7:
-		test_cipher("ecb(blowfish)", ENCRYPT, bf_enc_tv_template,
-			    BF_ENC_TEST_VECTORS);
-		test_cipher("ecb(blowfish)", DECRYPT, bf_dec_tv_template,
-			    BF_DEC_TEST_VECTORS);
-		test_cipher("cbc(blowfish)", ENCRYPT, bf_cbc_enc_tv_template,
-			    BF_CBC_ENC_TEST_VECTORS);
-		test_cipher("cbc(blowfish)", DECRYPT, bf_cbc_dec_tv_template,
-			    BF_CBC_DEC_TEST_VECTORS);
+		tcrypt_test("ecb(blowfish)");
+		tcrypt_test("cbc(blowfish)");
 		break;
 
 	case 8:
-		test_cipher("ecb(twofish)", ENCRYPT, tf_enc_tv_template,
-			    TF_ENC_TEST_VECTORS);
-		test_cipher("ecb(twofish)", DECRYPT, tf_dec_tv_template,
-			    TF_DEC_TEST_VECTORS);
-		test_cipher("cbc(twofish)", ENCRYPT, tf_cbc_enc_tv_template,
-			    TF_CBC_ENC_TEST_VECTORS);
-		test_cipher("cbc(twofish)", DECRYPT, tf_cbc_dec_tv_template,
-			    TF_CBC_DEC_TEST_VECTORS);
+		tcrypt_test("ecb(twofish)");
+		tcrypt_test("cbc(twofish)");
 		break;
 
 	case 9:
-		test_cipher("ecb(serpent)", ENCRYPT, serpent_enc_tv_template,
-			    SERPENT_ENC_TEST_VECTORS);
-		test_cipher("ecb(serpent)", DECRYPT, serpent_dec_tv_template,
-			    SERPENT_DEC_TEST_VECTORS);
+		tcrypt_test("ecb(serpent)");
 		break;
 
 	case 10:
-		test_cipher("ecb(aes)", ENCRYPT, aes_enc_tv_template,
-			    AES_ENC_TEST_VECTORS);
-		test_cipher("ecb(aes)", DECRYPT, aes_dec_tv_template,
-			    AES_DEC_TEST_VECTORS);
-		test_cipher("cbc(aes)", ENCRYPT, aes_cbc_enc_tv_template,
-			    AES_CBC_ENC_TEST_VECTORS);
-		test_cipher("cbc(aes)", DECRYPT, aes_cbc_dec_tv_template,
-			    AES_CBC_DEC_TEST_VECTORS);
-		test_cipher("lrw(aes)", ENCRYPT, aes_lrw_enc_tv_template,
-			    AES_LRW_ENC_TEST_VECTORS);
-		test_cipher("lrw(aes)", DECRYPT, aes_lrw_dec_tv_template,
-			    AES_LRW_DEC_TEST_VECTORS);
-		test_cipher("xts(aes)", ENCRYPT, aes_xts_enc_tv_template,
-			    AES_XTS_ENC_TEST_VECTORS);
-		test_cipher("xts(aes)", DECRYPT, aes_xts_dec_tv_template,
-			    AES_XTS_DEC_TEST_VECTORS);
-		test_cipher("rfc3686(ctr(aes))", ENCRYPT, aes_ctr_enc_tv_template,
-			    AES_CTR_ENC_TEST_VECTORS);
-		test_cipher("rfc3686(ctr(aes))", DECRYPT, aes_ctr_dec_tv_template,
-			    AES_CTR_DEC_TEST_VECTORS);
+		tcrypt_test("ecb(aes)");
+		tcrypt_test("cbc(aes)");
+		tcrypt_test("lrw(aes)");
+		tcrypt_test("xts(aes)");
+		tcrypt_test("rfc3686(ctr(aes))");
 		break;
 
 	case 11:
-		test_hash("sha384", sha384_tv_template, SHA384_TEST_VECTORS);
+		tcrypt_test("sha384");
 		break;
 
 	case 12:
-		test_hash("sha512", sha512_tv_template, SHA512_TEST_VECTORS);
+		tcrypt_test("sha512");
 		break;
 
 	case 13:
-		test_comp("deflate", deflate_comp_tv_template,
-			  deflate_decomp_tv_template, DEFLATE_COMP_TEST_VECTORS,
-			  DEFLATE_DECOMP_TEST_VECTORS);
+		tcrypt_test("deflate");
 		break;
 
 	case 14:
-		test_cipher("ecb(cast5)", ENCRYPT, cast5_enc_tv_template,
-			    CAST5_ENC_TEST_VECTORS);
-		test_cipher("ecb(cast5)", DECRYPT, cast5_dec_tv_template,
-			    CAST5_DEC_TEST_VECTORS);
+		tcrypt_test("ecb(cast5)");
 		break;
 
 	case 15:
-		test_cipher("ecb(cast6)", ENCRYPT, cast6_enc_tv_template,
-			    CAST6_ENC_TEST_VECTORS);
-		test_cipher("ecb(cast6)", DECRYPT, cast6_dec_tv_template,
-			    CAST6_DEC_TEST_VECTORS);
+		tcrypt_test("ecb(cast6)");
 		break;
 
 	case 16:
-		test_cipher("ecb(arc4)", ENCRYPT, arc4_enc_tv_template,
-			    ARC4_ENC_TEST_VECTORS);
-		test_cipher("ecb(arc4)", DECRYPT, arc4_dec_tv_template,
-			    ARC4_DEC_TEST_VECTORS);
+		tcrypt_test("ecb(arc4)");
 		break;
 
 	case 17:
-		test_hash("michael_mic", michael_mic_tv_template, MICHAEL_MIC_TEST_VECTORS);
+		tcrypt_test("michael_mic");
 		break;
 
 	case 18:
-		test_hash("crc32c", crc32c_tv_template, CRC32C_TEST_VECTORS);
+		tcrypt_test("crc32c");
 		break;
 
 	case 19:
-		test_cipher("ecb(tea)", ENCRYPT, tea_enc_tv_template,
-			    TEA_ENC_TEST_VECTORS);
-		test_cipher("ecb(tea)", DECRYPT, tea_dec_tv_template,
-			    TEA_DEC_TEST_VECTORS);
+		tcrypt_test("ecb(tea)");
 		break;
 
 	case 20:
-		test_cipher("ecb(xtea)", ENCRYPT, xtea_enc_tv_template,
-			    XTEA_ENC_TEST_VECTORS);
-		test_cipher("ecb(xtea)", DECRYPT, xtea_dec_tv_template,
-			    XTEA_DEC_TEST_VECTORS);
+		tcrypt_test("ecb(xtea)");
 		break;
 
 	case 21:
-		test_cipher("ecb(khazad)", ENCRYPT, khazad_enc_tv_template,
-			    KHAZAD_ENC_TEST_VECTORS);
-		test_cipher("ecb(khazad)", DECRYPT, khazad_dec_tv_template,
-			    KHAZAD_DEC_TEST_VECTORS);
+		tcrypt_test("ecb(khazad)");
 		break;
 
 	case 22:
-		test_hash("wp512", wp512_tv_template, WP512_TEST_VECTORS);
+		tcrypt_test("wp512");
 		break;
 
 	case 23:
-		test_hash("wp384", wp384_tv_template, WP384_TEST_VECTORS);
+		tcrypt_test("wp384");
 		break;
 
 	case 24:
-		test_hash("wp256", wp256_tv_template, WP256_TEST_VECTORS);
+		tcrypt_test("wp256");
 		break;
 
 	case 25:
-		test_cipher("ecb(tnepres)", ENCRYPT, tnepres_enc_tv_template,
-			    TNEPRES_ENC_TEST_VECTORS);
-		test_cipher("ecb(tnepres)", DECRYPT, tnepres_dec_tv_template,
-			    TNEPRES_DEC_TEST_VECTORS);
+		tcrypt_test("ecb(tnepres)");
 		break;
 
 	case 26:
-		test_cipher("ecb(anubis)", ENCRYPT, anubis_enc_tv_template,
-			    ANUBIS_ENC_TEST_VECTORS);
-		test_cipher("ecb(anubis)", DECRYPT, anubis_dec_tv_template,
-			    ANUBIS_DEC_TEST_VECTORS);
-		test_cipher("cbc(anubis)", ENCRYPT, anubis_cbc_enc_tv_template,
-			    ANUBIS_CBC_ENC_TEST_VECTORS);
-		test_cipher("cbc(anubis)", DECRYPT, anubis_cbc_dec_tv_template,
-			    ANUBIS_CBC_ENC_TEST_VECTORS);
+		tcrypt_test("ecb(anubis)");
+		tcrypt_test("cbc(anubis)");
 		break;
 
 	case 27:
-		test_hash("tgr192", tgr192_tv_template, TGR192_TEST_VECTORS);
+		tcrypt_test("tgr192");
 		break;
 
 	case 28:
 
-		test_hash("tgr160", tgr160_tv_template, TGR160_TEST_VECTORS);
+		tcrypt_test("tgr160");
 		break;
 
 	case 29:
-		test_hash("tgr128", tgr128_tv_template, TGR128_TEST_VECTORS);
+		tcrypt_test("tgr128");
 		break;
 
 	case 30:
-		test_cipher("ecb(xeta)", ENCRYPT, xeta_enc_tv_template,
-			    XETA_ENC_TEST_VECTORS);
-		test_cipher("ecb(xeta)", DECRYPT, xeta_dec_tv_template,
-			    XETA_DEC_TEST_VECTORS);
+		tcrypt_test("ecb(xeta)");
 		break;
 
 	case 31:
-		test_cipher("pcbc(fcrypt)", ENCRYPT, fcrypt_pcbc_enc_tv_template,
-			    FCRYPT_ENC_TEST_VECTORS);
-		test_cipher("pcbc(fcrypt)", DECRYPT, fcrypt_pcbc_dec_tv_template,
-			    FCRYPT_DEC_TEST_VECTORS);
+		tcrypt_test("pcbc(fcrypt)");
 		break;
 
 	case 32:
-		test_cipher("ecb(camellia)", ENCRYPT,
-			    camellia_enc_tv_template,
-			    CAMELLIA_ENC_TEST_VECTORS);
-		test_cipher("ecb(camellia)", DECRYPT,
-			    camellia_dec_tv_template,
-			    CAMELLIA_DEC_TEST_VECTORS);
-		test_cipher("cbc(camellia)", ENCRYPT,
-			    camellia_cbc_enc_tv_template,
-			    CAMELLIA_CBC_ENC_TEST_VECTORS);
-		test_cipher("cbc(camellia)", DECRYPT,
-			    camellia_cbc_dec_tv_template,
-			    CAMELLIA_CBC_DEC_TEST_VECTORS);
+		tcrypt_test("ecb(camellia)");
+		tcrypt_test("cbc(camellia)");
 		break;
 	case 33:
-		test_hash("sha224", sha224_tv_template, SHA224_TEST_VECTORS);
+		tcrypt_test("sha224");
 		break;
 
 	case 34:
-		test_cipher("salsa20", ENCRYPT,
-			    salsa20_stream_enc_tv_template,
-			    SALSA20_STREAM_ENC_TEST_VECTORS);
+		tcrypt_test("salsa20");
 		break;
 
 	case 35:
-		test_aead("gcm(aes)", ENCRYPT, aes_gcm_enc_tv_template,
-			  AES_GCM_ENC_TEST_VECTORS);
-		test_aead("gcm(aes)", DECRYPT, aes_gcm_dec_tv_template,
-			  AES_GCM_DEC_TEST_VECTORS);
+		tcrypt_test("gcm(aes)");
 		break;
 
 	case 36:
-		test_comp("lzo", lzo_comp_tv_template, lzo_decomp_tv_template,
-			  LZO_COMP_TEST_VECTORS, LZO_DECOMP_TEST_VECTORS);
+		tcrypt_test("lzo");
 		break;
 
 	case 37:
-		test_aead("ccm(aes)", ENCRYPT, aes_ccm_enc_tv_template,
-			  AES_CCM_ENC_TEST_VECTORS);
-		test_aead("ccm(aes)", DECRYPT, aes_ccm_dec_tv_template,
-			  AES_CCM_DEC_TEST_VECTORS);
+		tcrypt_test("ccm(aes)");
 		break;
 
 	case 38:
-		test_cipher("cts(cbc(aes))", ENCRYPT, cts_mode_enc_tv_template,
-			    CTS_MODE_ENC_TEST_VECTORS);
-		test_cipher("cts(cbc(aes))", DECRYPT, cts_mode_dec_tv_template,
-			    CTS_MODE_DEC_TEST_VECTORS);
+		tcrypt_test("cts(cbc(aes))");
 		break;
 
         case 39:
-		test_hash("rmd128", rmd128_tv_template, RMD128_TEST_VECTORS);
+		tcrypt_test("rmd128");
 		break;
 
         case 40:
-		test_hash("rmd160", rmd160_tv_template, RMD160_TEST_VECTORS);
+		tcrypt_test("rmd160");
 		break;
 
 	case 41:
-		test_hash("rmd256", rmd256_tv_template, RMD256_TEST_VECTORS);
+		tcrypt_test("rmd256");
 		break;
 
 	case 42:
-		test_hash("rmd320", rmd320_tv_template, RMD320_TEST_VECTORS);
+		tcrypt_test("rmd320");
+		break;
+
+	case 43:
+		tcrypt_test("ecb(seed)");
 		break;
 
 	case 100:
-		test_hash("hmac(md5)", hmac_md5_tv_template,
-			  HMAC_MD5_TEST_VECTORS);
+		tcrypt_test("hmac(md5)");
 		break;
 
 	case 101:
-		test_hash("hmac(sha1)", hmac_sha1_tv_template,
-			  HMAC_SHA1_TEST_VECTORS);
+		tcrypt_test("hmac(sha1)");
 		break;
 
 	case 102:
-		test_hash("hmac(sha256)", hmac_sha256_tv_template,
-			  HMAC_SHA256_TEST_VECTORS);
+		tcrypt_test("hmac(sha256)");
 		break;
 
 	case 103:
-		test_hash("hmac(sha384)", hmac_sha384_tv_template,
-			  HMAC_SHA384_TEST_VECTORS);
+		tcrypt_test("hmac(sha384)");
 		break;
 
 	case 104:
-		test_hash("hmac(sha512)", hmac_sha512_tv_template,
-			  HMAC_SHA512_TEST_VECTORS);
+		tcrypt_test("hmac(sha512)");
 		break;
 
 	case 105:
-		test_hash("hmac(sha224)", hmac_sha224_tv_template,
-			  HMAC_SHA224_TEST_VECTORS);
+		tcrypt_test("hmac(sha224)");
 		break;
 
 	case 106:
-		test_hash("xcbc(aes)", aes_xcbc128_tv_template,
-			  XCBC_AES_TEST_VECTORS);
+		tcrypt_test("xcbc(aes)");
 		break;
 
 	case 107:
-		test_hash("hmac(rmd128)", hmac_rmd128_tv_template,
-			  HMAC_RMD128_TEST_VECTORS);
+		tcrypt_test("hmac(rmd128)");
 		break;
 
 	case 108:
-		test_hash("hmac(rmd160)", hmac_rmd160_tv_template,
-			  HMAC_RMD160_TEST_VECTORS);
+		tcrypt_test("hmac(rmd160)");
 		break;
 
 	case 200:
@@ -1945,11 +2530,6 @@ static void do_test(void)
 	case 1000:
 		test_available();
 		break;
