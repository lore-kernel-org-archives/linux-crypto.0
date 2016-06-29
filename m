From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [v4 PATCH 1/8] crypto: testmgr - Allow leading zeros in RSA
Date: Wed, 29 Jun 2016 19:32:20 +0800
Message-ID: <E1bIDjA-0007CT-Gd@gondolin.me.apana.org.au>
References: <20160629113125.GA27643@gondor.apana.org.au>
To: Andrzej Zaborowski <andrew.zaborowski@intel.com>,
	Tadeusz Struk <tadeusz.struk@intel.com>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Tudor Ambarus <tudor-dan.ambarus@nxp.com>,
	Stephan Mueller <smueller@chronox.de>,
	Mat Martineau <mathew.j.martineau@linux.intel.com>,
	Denis Kenzior <denkenz@gmail.com>,
	Salvatore Benedetto <salvatore.benedetto@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:42097 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751784AbcF2LcY (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 29 Jun 2016 07:32:24 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch allows RSA implementations to produce output with
leading zeroes.  testmgr will skip leading zeroes when comparing
the output.

This patch also tries to make the RSA test function generic enough
to potentially handle other akcipher algorithms.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/testmgr.c |   51 ++++++++++++++++++++++++---------------------------
 1 file changed, 24 insertions(+), 27 deletions(-)

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index 537fdc3..38e23be31 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -1911,8 +1911,8 @@ static int alg_test_kpp(const struct alg_test_desc *desc, const char *driver,
 	return err;
 }
 
-static int do_test_rsa(struct crypto_akcipher *tfm,
-		       struct akcipher_testvec *vecs)
+static int test_akcipher_one(struct crypto_akcipher *tfm,
+			     struct akcipher_testvec *vecs)
 {
 	char *xbuf[XBUFSIZE];
 	struct akcipher_request *req;
@@ -1963,17 +1963,18 @@ static int do_test_rsa(struct crypto_akcipher *tfm,
 	/* Run RSA encrypt - c = m^e mod n;*/
 	err = wait_async_op(&result, crypto_akcipher_encrypt(req));
 	if (err) {
-		pr_err("alg: rsa: encrypt test failed. err %d\n", err);
+		pr_err("alg: akcipher: encrypt test failed. err %d\n", err);
 		goto free_all;
 	}
 	if (req->dst_len != vecs->c_size) {
-		pr_err("alg: rsa: encrypt test failed. Invalid output len\n");
+		pr_err("alg: akcipher: encrypt test failed. Invalid output len\n");
 		err = -EINVAL;
 		goto free_all;
 	}
 	/* verify that encrypted message is equal to expected */
 	if (memcmp(vecs->c, outbuf_enc, vecs->c_size)) {
-		pr_err("alg: rsa: encrypt test failed. Invalid output\n");
+		pr_err("alg: akcipher: encrypt test failed. Invalid output\n");
+		hexdump(outbuf_enc, vecs->c_size);
 		err = -EINVAL;
 		goto free_all;
 	}
@@ -2001,18 +2002,22 @@ static int do_test_rsa(struct crypto_akcipher *tfm,
 	/* Run RSA decrypt - m = c^d mod n;*/
 	err = wait_async_op(&result, crypto_akcipher_decrypt(req));
 	if (err) {
-		pr_err("alg: rsa: decrypt test failed. err %d\n", err);
+		pr_err("alg: akcipher: decrypt test failed. err %d\n", err);
 		goto free_all;
 	}
 	out_len = req->dst_len;
-	if (out_len != vecs->m_size) {
-		pr_err("alg: rsa: decrypt test failed. Invalid output len\n");
+	if (out_len < vecs->m_size) {
+		pr_err("alg: akcipher: decrypt test failed. "
+		       "Invalid output len %u\n", out_len);
 		err = -EINVAL;
 		goto free_all;
 	}
 	/* verify that decrypted message is equal to the original msg */
-	if (memcmp(vecs->m, outbuf_dec, vecs->m_size)) {
-		pr_err("alg: rsa: decrypt test failed. Invalid output\n");
+	if (memchr_inv(outbuf_dec, 0, out_len - vecs->m_size) ||
+	    memcmp(vecs->m, outbuf_dec + out_len - vecs->m_size,
+		   vecs->m_size)) {
+		pr_err("alg: akcipher: decrypt test failed. Invalid output\n");
+		hexdump(outbuf_dec, out_len);
 		err = -EINVAL;
 	}
 free_all:
@@ -2025,28 +2030,20 @@ free_xbuf:
 	return err;
 }
 
-static int test_rsa(struct crypto_akcipher *tfm, struct akcipher_testvec *vecs,
-		    unsigned int tcount)
+static int test_akcipher(struct crypto_akcipher *tfm, const char *alg,
+			 struct akcipher_testvec *vecs, unsigned int tcount)
 {
 	int ret, i;
 
 	for (i = 0; i < tcount; i++) {
-		ret = do_test_rsa(tfm, vecs++);
-		if (ret) {
-			pr_err("alg: rsa: test failed on vector %d, err=%d\n",
-			       i + 1, ret);
-			return ret;
-		}
-	}
-	return 0;
-}
-
-static int test_akcipher(struct crypto_akcipher *tfm, const char *alg,
-			 struct akcipher_testvec *vecs, unsigned int tcount)
-{
-	if (strncmp(alg, "rsa", 3) == 0)
-		return test_rsa(tfm, vecs, tcount);
+		ret = test_akcipher_one(tfm, vecs++);
+		if (!ret)
+			continue;
 
+		pr_err("alg: akcipher: test failed on vector %d, err=%d\n",
+		       i + 1, ret);
+		return ret;
+	}
 	return 0;
 }
 
