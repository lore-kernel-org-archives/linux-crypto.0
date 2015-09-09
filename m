From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: [PATCH 8/8] crypto: testmgr - update test mgr according to API
 changes
Date: Wed, 09 Sep 2015 09:15:44 -0700
Message-ID: <20150909161544.2828.6243.stgit@tstruk-mobl1>
References: <20150909161454.2828.70445.stgit@tstruk-mobl1>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, qat-linux@intel.com,
	tadeusz.struk@intel.com
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:54028 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754578AbbIIQRi (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 9 Sep 2015 12:17:38 -0400
In-Reply-To: <20150909161454.2828.70445.stgit@tstruk-mobl1>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>
---
 crypto/testmgr.c |   44 +++++++++++++++++++++-----------------------
 crypto/testmgr.h |   36 +++++++++++++++++++++++++++---------
 2 files changed, 48 insertions(+), 32 deletions(-)

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index 2f2b66e..f268707 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -1835,7 +1835,6 @@ static int alg_test_drbg(const struct alg_test_desc *desc, const char *driver,
 
 }
 
-#if 0
 static int do_test_rsa(struct crypto_akcipher *tfm,
 		       struct akcipher_testvec *vecs)
 {
@@ -1845,34 +1844,33 @@ static int do_test_rsa(struct crypto_akcipher *tfm,
 	struct tcrypt_result result;
 	unsigned int out_len_max, out_len = 0;
 	int err = -ENOMEM;
+	struct scatterlist src, dst, src_tab[2];
 
 	req = akcipher_request_alloc(tfm, GFP_KERNEL);
 	if (!req)
 		return err;
 
 	init_completion(&result.completion);
-	err = crypto_akcipher_setkey(tfm, vecs->key, vecs->key_len);
-	if (err)
-		goto free_req;
 
-	akcipher_request_set_crypt(req, vecs->m, outbuf_enc, vecs->m_size,
-				   out_len);
-	/* expect this to fail, and update the required buf len */
-	crypto_akcipher_encrypt(req);
-	out_len = req->dst_len;
-	if (!out_len) {
-		err = -EINVAL;
+	if (vecs->public_key_vec)
+		err = crypto_akcipher_set_pub_key(tfm, vecs->key,
+						  vecs->key_len);
+	else
+		err = crypto_akcipher_set_priv_key(tfm, vecs->key,
+						   vecs->key_len);
+	if (err)
 		goto free_req;
-	}
 
-	out_len_max = out_len;
-	err = -ENOMEM;
+	out_len_max = crypto_akcipher_get_len(tfm);
 	outbuf_enc = kzalloc(out_len_max, GFP_KERNEL);
 	if (!outbuf_enc)
 		goto free_req;
 
-	akcipher_request_set_crypt(req, vecs->m, outbuf_enc, vecs->m_size,
-				   out_len);
+	sg_init_table(src_tab, 2);
+	sg_set_buf(&src_tab[0], vecs->m, 8);
+	sg_set_buf(&src_tab[1], vecs->m + 8, vecs->m_size - 8);
+	sg_init_one(&dst, outbuf_enc, out_len_max);
+	akcipher_request_set_crypt(req, src_tab, &dst);
 	akcipher_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG,
 				      tcrypt_complete, &result);
 
@@ -1882,13 +1880,13 @@ static int do_test_rsa(struct crypto_akcipher *tfm,
 		pr_err("alg: rsa: encrypt test failed. err %d\n", err);
 		goto free_all;
 	}
-	if (out_len != vecs->c_size) {
+	if (req->out_len != vecs->c_size) {
 		pr_err("alg: rsa: encrypt test failed. Invalid output len\n");
 		err = -EINVAL;
 		goto free_all;
 	}
 	/* verify that encrypted message is equal to expected */
-	if (memcmp(vecs->c, outbuf_enc, vecs->c_size)) {
+	if (memcmp(vecs->c, sg_virt(req->dst), vecs->c_size)) {
 		pr_err("alg: rsa: encrypt test failed. Invalid output\n");
 		err = -EINVAL;
 		goto free_all;
@@ -1903,9 +1901,10 @@ static int do_test_rsa(struct crypto_akcipher *tfm,
 		err = -ENOMEM;
 		goto free_all;
 	}
+	sg_init_one(&src, vecs->c, vecs->c_size);
+	sg_init_one(&dst, outbuf_dec, out_len_max);
 	init_completion(&result.completion);
-	akcipher_request_set_crypt(req, outbuf_enc, outbuf_dec, vecs->c_size,
-				   out_len);
+	akcipher_request_set_crypt(req, &src, &dst);
 
 	/* Run RSA decrypt - m = c^d mod n;*/
 	err = wait_async_op(&result, crypto_akcipher_decrypt(req));
@@ -1913,7 +1912,7 @@ static int do_test_rsa(struct crypto_akcipher *tfm,
 		pr_err("alg: rsa: decrypt test failed. err %d\n", err);
 		goto free_all;
 	}
-	out_len = req->dst_len;
+	out_len = req->out_len;
 	if (out_len != vecs->m_size) {
 		pr_err("alg: rsa: decrypt test failed. Invalid output len\n");
 		err = -EINVAL;
@@ -1976,7 +1975,6 @@ static int alg_test_akcipher(const struct alg_test_desc *desc,
 	crypto_free_akcipher(tfm);
 	return err;
 }
-#endif
 
 static int alg_test_null(const struct alg_test_desc *desc,
 			     const char *driver, u32 type, u32 mask)
@@ -3613,7 +3611,7 @@ static const struct alg_test_desc alg_test_descs[] = {
 		}
 	}, {
 		.alg = "rsa",
-		.test = alg_test_null,
+		.test = alg_test_akcipher,
 		.fips_allowed = 1,
 		.suite = {
 			.akcipher = {
diff --git a/crypto/testmgr.h b/crypto/testmgr.h
index 64b8a80..e10582d 100644
--- a/crypto/testmgr.h
+++ b/crypto/testmgr.h
@@ -149,7 +149,8 @@ static struct akcipher_testvec rsa_tv_template[] = {
 	{
 #ifndef CONFIG_CRYPTO_FIPS
 	.key =
-	"\x30\x81\x88" /* sequence of 136 bytes */
+	"\x30\x81\x9A" /* sequence of 154 bytes */
+	"\x02\x01\x01" /* version - integer of 1 byte */
 	"\x02\x41" /* modulus - integer of 65 bytes */
 	"\x00\xAA\x36\xAB\xCE\x88\xAC\xFD\xFF\x55\x52\x3C\x7F\xC4\x52\x3F"
 	"\x90\xEF\xA0\x0D\xF3\x77\x4A\x25\x9F\x2E\x62\xB4\xC5\xD9\x9C\xB5"
@@ -161,19 +162,25 @@ static struct akcipher_testvec rsa_tv_template[] = {
 	"\x0A\x03\x37\x48\x62\x64\x87\x69\x5F\x5F\x30\xBC\x38\xB9\x8B\x44"
 	"\xC2\xCD\x2D\xFF\x43\x40\x98\xCD\x20\xD8\xA1\x38\xD0\x90\xBF\x64"
 	"\x79\x7C\x3F\xA7\xA2\xCD\xCB\x3C\xD1\xE0\xBD\xBA\x26\x54\xB4\xF9"
-	"\xDF\x8E\x8A\xE5\x9D\x73\x3D\x9F\x33\xB3\x01\x62\x4A\xFD\x1D\x51",
+	"\xDF\x8E\x8A\xE5\x9D\x73\x3D\x9F\x33\xB3\x01\x62\x4A\xFD\x1D\x51"
+	"\x02\x01\x00" /* prime1 - integer of 1 byte */
+	"\x02\x01\x00" /* prime2 - integer of 1 byte */
+	"\x02\x01\x00" /* exponent1 - integer of 1 byte */
+	"\x02\x01\x00" /* exponent2 - integer of 1 byte */
+	"\x02\x01\x00", /* coefficient - integer of 1 byte */
 	.m = "\x54\x85\x9b\x34\x2c\x49\xea\x2a",
 	.c =
 	"\x63\x1c\xcd\x7b\xe1\x7e\xe4\xde\xc9\xa8\x89\xa1\x74\xcb\x3c\x63"
 	"\x7d\x24\xec\x83\xc3\x15\xe4\x7f\x73\x05\x34\xd1\xec\x22\xbb\x8a"
 	"\x5e\x32\x39\x6d\xc1\x1d\x7d\x50\x3b\x9f\x7a\xad\xf0\x2e\x25\x53"
 	"\x9f\x6e\xbd\x4c\x55\x84\x0c\x9b\xcf\x1a\x4b\x51\x1e\x9e\x0c\x06",
-	.key_len = 139,
+	.key_len = 157,
 	.m_size = 8,
 	.c_size = 64,
 	}, {
 	.key =
-	"\x30\x82\x01\x0B" /* sequence of 267 bytes */
+	"\x30\x82\x01\x1D" /* sequence of 285 bytes */
+	"\x02\x01\x01" /* version - integer of 1 byte */
 	"\x02\x81\x81" /* modulus - integer of 129 bytes */
 	"\x00\xBB\xF8\x2F\x09\x06\x82\xCE\x9C\x23\x38\xAC\x2B\x9D\xA8\x71"
 	"\xF7\x36\x8D\x07\xEE\xD4\x10\x43\xA4\x40\xD6\xB6\xF0\x74\x54\xF5"
@@ -194,8 +201,13 @@ static struct akcipher_testvec rsa_tv_template[] = {
 	"\x44\xE5\x6A\xAF\x68\xC5\x6C\x09\x2C\xD3\x8D\xC3\xBE\xF5\xD2\x0A"
 	"\x93\x99\x26\xED\x4F\x74\xA1\x3E\xDD\xFB\xE1\xA1\xCE\xCC\x48\x94"
 	"\xAF\x94\x28\xC2\xB7\xB8\x88\x3F\xE4\x46\x3A\x4B\xC8\x5B\x1C\xB3"
-	"\xC1",
-	.key_len = 271,
+	"\xC1"
+	"\x02\x01\x00" /* prime1 - integer of 1 byte */
+	"\x02\x01\x00" /* prime2 - integer of 1 byte */
+	"\x02\x01\x00" /* exponent1 - integer of 1 byte */
+	"\x02\x01\x00" /* exponent2 - integer of 1 byte */
+	"\x02\x01\x00", /* coefficient - integer of 1 byte */
+	.key_len = 289,
 	.m = "\x54\x85\x9b\x34\x2c\x49\xea\x2a",
 	.c =
 	"\x74\x1b\x55\xac\x47\xb5\x08\x0a\x6e\x2b\x2d\xf7\x94\xb8\x8a\x95"
@@ -211,7 +223,8 @@ static struct akcipher_testvec rsa_tv_template[] = {
 	}, {
 #endif
 	.key =
-	"\x30\x82\x02\x0D" /* sequence of 525 bytes */
+	"\x30\x82\x02\x1F" /* sequence of 543 bytes */
+	"\x02\x01\x01" /* version - integer of 1 byte */
 	"\x02\x82\x01\x00" /* modulus - integer of 256 bytes */
 	"\xDB\x10\x1A\xC2\xA3\xF1\xDC\xFF\x13\x6B\xED\x44\xDF\xF0\x02\x6D"
 	"\x13\xC7\x88\xDA\x70\x6B\x54\xF1\xE8\x27\xDC\xC3\x0F\x99\x6A\xFA"
@@ -246,8 +259,13 @@ static struct akcipher_testvec rsa_tv_template[] = {
 	"\x77\xAF\x51\x27\x5B\x5E\x69\xB8\x81\xE6\x11\xC5\x43\x23\x81\x04"
 	"\x62\xFF\xE9\x46\xB8\xD8\x44\xDB\xA5\xCC\x31\x54\x34\xCE\x3E\x82"
 	"\xD6\xBF\x7A\x0B\x64\x21\x6D\x88\x7E\x5B\x45\x12\x1E\x63\x8D\x49"
-	"\xA7\x1D\xD9\x1E\x06\xCD\xE8\xBA\x2C\x8C\x69\x32\xEA\xBE\x60\x71",
-	.key_len = 529,
+	"\xA7\x1D\xD9\x1E\x06\xCD\xE8\xBA\x2C\x8C\x69\x32\xEA\xBE\x60\x71"
+	"\x02\x01\x00" /* prime1 - integer of 1 byte */
+	"\x02\x01\x00" /* prime2 - integer of 1 byte */
+	"\x02\x01\x00" /* exponent1 - integer of 1 byte */
+	"\x02\x01\x00" /* exponent2 - integer of 1 byte */
+	"\x02\x01\x00", /* coefficient - integer of 1 byte */
+	.key_len = 547,
 	.m = "\x54\x85\x9b\x34\x2c\x49\xea\x2a",
 	.c =
 	"\xb2\x97\x76\xb4\xae\x3e\x38\x3c\x7e\x64\x1f\xcc\xa2\x7f\xf6\xbe"
