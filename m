Return-Path: <SRS0=b7+G=PP=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from vmicros1.altlinux.org ([194.107.17.57]:41690 "EHLO
        vmicros1.altlinux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727994AbfAGRyb (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 7 Jan 2019 12:54:31 -0500
From: Vitaly Chikunov <vt@altlinux.org>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] crypto: testmgr - split akcipher tests by a key type
Date: Mon,  7 Jan 2019 20:54:27 +0300
Message-Id: <20190107175427.13261-1-vt@altlinux.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Before this, if akcipher_testvec have `public_key_vec' set to true
(i.e. having a public key) only sign/encrypt test is performed, but
verify/decrypt test is skipped.

With a public key we could do encrypt and verify, but to sign and decrypt
a private key is required.

This logic is correct for encrypt/decrypt tests (decrypt is skipped if
no private key). But incorrect for sign/verify tests - sign is performed
no matter if there is no private key, but verify is skipped if there is
a public key.

Rework `test_akcipher_one' to arrange tests properly depending on value
of `public_key_vec` and `siggen_sigver_test'.

No tests were missed since there is only one sign/verify test (which
have `siggen_sigver_test' set to true) and it has a private key, but
future tests could benefit from this improvement.

Signed-off-by: Vitaly Chikunov <vt@altlinux.org>
---
 crypto/testmgr.c | 86 +++++++++++++++++++++++++++++++++++++-------------------
 1 file changed, 57 insertions(+), 29 deletions(-)

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index 0f684a414acb..1ce53f8058d2 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -2238,6 +2238,9 @@ static int test_akcipher_one(struct crypto_akcipher *tfm,
 	unsigned int out_len_max, out_len = 0;
 	int err = -ENOMEM;
 	struct scatterlist src, dst, src_tab[2];
+	const char *m, *c;
+	unsigned int m_size, c_size;
+	const char *op;
 
 	if (testmgr_alloc_buf(xbuf))
 		return err;
@@ -2259,46 +2262,72 @@ static int test_akcipher_one(struct crypto_akcipher *tfm,
 
 	err = -ENOMEM;
 	out_len_max = crypto_akcipher_maxsize(tfm);
+
+	/*
+	 * First run test which do not require a private key, such as
+	 * encrypt or verify.
+	 */
 	outbuf_enc = kzalloc(out_len_max, GFP_KERNEL);
 	if (!outbuf_enc)
 		goto free_req;
 
-	if (WARN_ON(vecs->m_size > PAGE_SIZE))
-		goto free_all;
+	if (!vecs->siggen_sigver_test) {
+		m = vecs->m;
+		m_size = vecs->m_size;
+		c = vecs->c;
+		c_size = vecs->c_size;
+		op = "encrypt";
+	} else {
+		/* Swap args so we could keep plaintext (digest)
+		 * in vecs->m, and cooked signature in vecs->c.
+		 */
+		m = vecs->c; /* signature */
+		m_size = vecs->c_size;
+		c = vecs->m; /* digest */
+		c_size = vecs->m_size;
+		op = "verify";
+	}
 
-	memcpy(xbuf[0], vecs->m, vecs->m_size);
+	if (WARN_ON(m_size > PAGE_SIZE))
+		goto free_all;
+	memcpy(xbuf[0], m, m_size);
 
 	sg_init_table(src_tab, 2);
 	sg_set_buf(&src_tab[0], xbuf[0], 8);
-	sg_set_buf(&src_tab[1], xbuf[0] + 8, vecs->m_size - 8);
+	sg_set_buf(&src_tab[1], xbuf[0] + 8, m_size - 8);
 	sg_init_one(&dst, outbuf_enc, out_len_max);
-	akcipher_request_set_crypt(req, src_tab, &dst, vecs->m_size,
+	akcipher_request_set_crypt(req, src_tab, &dst, m_size,
 				   out_len_max);
 	akcipher_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG,
 				      crypto_req_done, &wait);
 
 	err = crypto_wait_req(vecs->siggen_sigver_test ?
-			      /* Run asymmetric signature generation */
-			      crypto_akcipher_sign(req) :
+			      /* Run asymmetric signature verification */
+			      crypto_akcipher_verify(req) :
 			      /* Run asymmetric encrypt */
 			      crypto_akcipher_encrypt(req), &wait);
 	if (err) {
-		pr_err("alg: akcipher: encrypt test failed. err %d\n", err);
+		pr_err("alg: akcipher: %s test failed. err %d\n", op, err);
 		goto free_all;
 	}
-	if (req->dst_len != vecs->c_size) {
-		pr_err("alg: akcipher: encrypt test failed. Invalid output len\n");
+	if (req->dst_len != c_size) {
+		pr_err("alg: akcipher: %s test failed. Invalid output len\n",
+		       op);
 		err = -EINVAL;
 		goto free_all;
 	}
 	/* verify that encrypted message is equal to expected */
-	if (memcmp(vecs->c, outbuf_enc, vecs->c_size)) {
-		pr_err("alg: akcipher: encrypt test failed. Invalid output\n");
-		hexdump(outbuf_enc, vecs->c_size);
+	if (memcmp(c, outbuf_enc, c_size)) {
+		pr_err("alg: akcipher: %s test failed. Invalid output\n", op);
+		hexdump(outbuf_enc, c_size);
 		err = -EINVAL;
 		goto free_all;
 	}
-	/* Don't invoke decrypt for vectors with public key */
+
+	/*
+	 * Don't invoke (decrypt or sign) test which require a private key
+	 * for vectors with only a public key.
+	 */
 	if (vecs->public_key_vec) {
 		err = 0;
 		goto free_all;
@@ -2309,37 +2338,36 @@ static int test_akcipher_one(struct crypto_akcipher *tfm,
 		goto free_all;
 	}
 
-	if (WARN_ON(vecs->c_size > PAGE_SIZE))
+	op = vecs->siggen_sigver_test ? "sign" : "decrypt";
+	if (WARN_ON(c_size > PAGE_SIZE))
 		goto free_all;
+	memcpy(xbuf[0], c, c_size);
 
-	memcpy(xbuf[0], vecs->c, vecs->c_size);
-
-	sg_init_one(&src, xbuf[0], vecs->c_size);
+	sg_init_one(&src, xbuf[0], c_size);
 	sg_init_one(&dst, outbuf_dec, out_len_max);
 	crypto_init_wait(&wait);
-	akcipher_request_set_crypt(req, &src, &dst, vecs->c_size, out_len_max);
+	akcipher_request_set_crypt(req, &src, &dst, c_size, out_len_max);
 
 	err = crypto_wait_req(vecs->siggen_sigver_test ?
-			      /* Run asymmetric signature verification */
-			      crypto_akcipher_verify(req) :
+			      /* Run asymmetric signature generation */
+			      crypto_akcipher_sign(req) :
 			      /* Run asymmetric decrypt */
 			      crypto_akcipher_decrypt(req), &wait);
 	if (err) {
-		pr_err("alg: akcipher: decrypt test failed. err %d\n", err);
+		pr_err("alg: akcipher: %s test failed. err %d\n", op, err);
 		goto free_all;
 	}
 	out_len = req->dst_len;
-	if (out_len < vecs->m_size) {
-		pr_err("alg: akcipher: decrypt test failed. "
-		       "Invalid output len %u\n", out_len);
+	if (out_len < m_size) {
+		pr_err("alg: akcipher: %s test failed. Invalid output len %u\n",
+		       op, out_len);
 		err = -EINVAL;
 		goto free_all;
 	}
 	/* verify that decrypted message is equal to the original msg */
-	if (memchr_inv(outbuf_dec, 0, out_len - vecs->m_size) ||
-	    memcmp(vecs->m, outbuf_dec + out_len - vecs->m_size,
-		   vecs->m_size)) {
-		pr_err("alg: akcipher: decrypt test failed. Invalid output\n");
+	if (memchr_inv(outbuf_dec, 0, out_len - m_size) ||
+	    memcmp(m, outbuf_dec + out_len - m_size, m_size)) {
+		pr_err("alg: akcipher: %s test failed. Invalid output\n", op);
 		hexdump(outbuf_dec, out_len);
 		err = -EINVAL;
 	}
-- 
2.11.0
