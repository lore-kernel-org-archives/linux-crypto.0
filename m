From: Nitin Kumbhar <nkumbhar@nvidia.com>
Subject: [PATCH v2 5/6] crypto: testmgr: add ECDSA tests
Date: Fri, 3 Feb 2017 16:42:54 +0530
Message-ID: <1486120375-13070-6-git-send-email-nkumbhar@nvidia.com>
References: <1486120375-13070-1-git-send-email-nkumbhar@nvidia.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-crypto@vger.kernel.org>, Nitin Kumbhar <nkumbhar@nvidia.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from hqemgate14.nvidia.com ([216.228.121.143]:5642 "EHLO
        hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752254AbdBCLNJ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 3 Feb 2017 06:13:09 -0500
In-Reply-To: <1486120375-13070-1-git-send-email-nkumbhar@nvidia.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Update crypto test manager to include NIST ECDSA
test vectors and various ECDSA tests. These include
tests for ECDSA signing, ECDSA sign-verification,
ECDSA signing and verifying generated signatures and
invalidation of incorrect signatures.

Signed-off-by: Nitin Kumbhar <nkumbhar@nvidia.com>
---
 crypto/testmgr.c |  330 +++++++++++++++++++++++++++++++++++++++++++++++++++++-
 crypto/testmgr.h |  140 +++++++++++++++++++++++
 2 files changed, 467 insertions(+), 3 deletions(-)

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index 98eb09782db8..bed448e005b1 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -5,6 +5,7 @@
  * Copyright (c) 2002 Jean-Francois Dive <jef@linuxbe.org>
  * Copyright (c) 2007 Nokia Siemens Networks
  * Copyright (c) 2008 Herbert Xu <herbert@gondor.apana.org.au>
+ * Copyright (c) 2017 NVIDIA Corporation
  *
  * Updated RFC4106 AES-GCM testing.
  *    Authors: Aidan O'Mahony (aidan.o.mahony@intel.com)
@@ -2085,6 +2086,314 @@ static int alg_test_kpp(const struct alg_test_desc *desc, const char *driver,
 	return err;
 }
 
+#define ECDSA_TEST_VALID_VERIFY		0
+#define ECDSA_TEST_INVALID_VERIFY	1
+#define ECDSA_TEST_SIGN_VERIFY		2
+#define ECDSA_TEST_SIGN			3
+
+static int __do_test_ecdsa_verify(struct crypto_akcipher *tfm,
+				  struct akcipher_testvec *vec, int test)
+{
+	struct akcipher_request *req = NULL;
+	u8 *r_str = NULL, *s_str = NULL;
+	u8 *m_str = NULL;
+	struct scatterlist src_tab[3], dst;
+	struct tcrypt_result result;
+	unsigned int outbuf_maxlen;
+	u8 *outbuf = NULL;
+	unsigned int nbytes;
+	int err, m_size;
+
+	/* Alloc akcipher request */
+	req = akcipher_request_alloc(tfm, GFP_KERNEL);
+	if (!req)
+		return -ENOMEM;
+
+	/* Set private key */
+	err = crypto_akcipher_set_pub_key(tfm, vec->key, vec->key_len);
+	if (err)
+		goto error;
+
+	/*
+	 * vec->c always contains k, R and S in that order. All are
+	 * of same size and are equal to n i.e. the order of
+	 * an elliptic curve.
+	 */
+	nbytes = vec->c_size / 3;
+
+	r_str = kzalloc(nbytes, GFP_KERNEL);
+	s_str = kzalloc(nbytes, GFP_KERNEL);
+	m_str = kzalloc(vec->m_size, GFP_KERNEL);
+	if (!r_str || !s_str || !m_str) {
+		err = -ENOMEM;
+		goto error;
+	}
+	memcpy(r_str, (u8 *)vec->c + 1 * nbytes, nbytes);
+	memcpy(s_str, (u8 *)vec->c + 2 * nbytes, nbytes);
+	memcpy(m_str, vec->m, vec->m_size);
+
+	outbuf_maxlen = crypto_akcipher_maxsize(tfm);
+	if (outbuf_maxlen < 0) {
+		err = outbuf_maxlen;
+		goto error;
+	}
+	outbuf = kzalloc(outbuf_maxlen, GFP_KERNEL);
+	if (!outbuf) {
+		err = -ENOMEM;
+		goto error;
+	}
+
+	/* Intentionally set m_size to 8 to test invalid hash */
+	m_size = test == ECDSA_TEST_VALID_VERIFY ? vec->m_size : 8;
+
+	/* Set src and dst buffers */
+	sg_init_table(src_tab, 3);
+	sg_set_buf(&src_tab[0], m_str, m_size);
+	sg_set_buf(&src_tab[1], r_str, nbytes);
+	sg_set_buf(&src_tab[2], s_str, nbytes);
+	sg_init_one(&dst, outbuf, outbuf_maxlen);
+
+	akcipher_request_set_crypt(req, src_tab, &dst,
+				   vec->m_size + 2 * nbytes, outbuf_maxlen);
+
+	/* Set up result callback */
+	init_completion(&result.completion);
+	akcipher_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG,
+				      tcrypt_complete, &result);
+
+	/* Run ecdsa verify operation on sig (r,s) */
+	err = wait_async_op(&result, crypto_akcipher_verify(req));
+error:
+	akcipher_request_free(req);
+	kfree(r_str);
+	kfree(s_str);
+	kfree(m_str);
+	kfree(outbuf);
+	return err;
+}
+
+static int do_test_ecdsa_verify(struct crypto_akcipher *tfm,
+				struct akcipher_testvec *vec)
+{
+	int err;
+
+	err = __do_test_ecdsa_verify(tfm, vec, ECDSA_TEST_VALID_VERIFY);
+	if (err)
+		pr_err("alg: ecdsa: verify(rs) test failed. err %d\n", err);
+
+	return err;
+}
+
+static int do_test_ecdsa_invalid_verify(struct crypto_akcipher *tfm,
+					struct akcipher_testvec *vec)
+{
+	int err;
+
+	err = __do_test_ecdsa_verify(tfm, vec, ECDSA_TEST_INVALID_VERIFY);
+	if (err != -EBADMSG) {
+		pr_err("alg: ecdsa: invalid verify test failed. err %d\n", err);
+		return err;
+	}
+
+	return 0;
+}
+
+static int __do_test_ecdsa_sign_verify(struct crypto_akcipher *tfm,
+				       struct akcipher_testvec *vec,
+				       int test)
+{
+	struct akcipher_request *req = NULL;
+	u8 *r_str = NULL, *s_str = NULL;
+	u8 *sig_r = NULL, *sig_s = NULL;
+	u8 *m_str = NULL, *k_str = NULL;
+	struct scatterlist src_tab[3];
+	struct scatterlist src, dst;
+	struct tcrypt_result result;
+	unsigned int outbuf_maxlen;
+	void *outbuf = NULL;
+	unsigned int nbytes;
+	int err;
+
+	/* Alloc akcipher request */
+	req = akcipher_request_alloc(tfm, GFP_KERNEL);
+	if (!req)
+		return -ENOMEM;
+
+	/* Set private key */
+	err = crypto_akcipher_set_priv_key(tfm, vec->key, vec->key_len);
+	if (err)
+		goto error;
+
+	/* Set pub key */
+	err = crypto_akcipher_set_pub_key(tfm, vec->key, vec->key_len);
+	if (err)
+		goto error;
+
+	/*
+	 * vec->c always contains k, R and S in that order. All are
+	 * of same size and are equal to n i.e. the order of
+	 * an elliptic curve.
+	 */
+	nbytes = vec->c_size / 3;
+
+	k_str = kzalloc(nbytes, GFP_KERNEL);
+	r_str = kzalloc(nbytes, GFP_KERNEL);
+	s_str = kzalloc(nbytes, GFP_KERNEL);
+	m_str = kzalloc(vec->m_size, GFP_KERNEL);
+	if (!k_str || !r_str || !s_str || !m_str) {
+		err = -ENOMEM;
+		goto error;
+	}
+	memcpy(k_str, (u8 *)vec->c + 0 * nbytes, nbytes);
+	memcpy(r_str, (u8 *)vec->c + 1 * nbytes, nbytes);
+	memcpy(s_str, (u8 *)vec->c + 2 * nbytes, nbytes);
+	memcpy(m_str, vec->m, vec->m_size);
+
+	outbuf_maxlen = crypto_akcipher_maxsize(tfm);
+	if (outbuf_maxlen < 0) {
+		err = outbuf_maxlen;
+		goto error;
+	}
+	outbuf = kzalloc(outbuf_maxlen, GFP_KERNEL);
+	if (!outbuf) {
+		err = -ENOMEM;
+		goto error;
+	}
+
+	sg_init_one(&src, m_str, vec->m_size);
+	sg_init_one(&dst, outbuf, outbuf_maxlen);
+
+	akcipher_request_set_crypt(req, &src, &dst,
+				   vec->m_size, outbuf_maxlen);
+
+	/* Set up result callback */
+	init_completion(&result.completion);
+	akcipher_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG,
+				      tcrypt_complete, &result);
+
+	/* Set K in request for signing */
+	if (test == ECDSA_TEST_SIGN)
+		req->info = k_str;
+
+	/* Run ecdsa sign operation on message digest */
+	err = wait_async_op(&result, crypto_akcipher_sign(req));
+	if (err)
+		goto error;
+
+	/* verify that signature (r,s) is valid */
+	if (req->dst_len != 2 * nbytes) {
+		err = -EINVAL;
+		goto error;
+	}
+
+	/* outbuf contains r and s */
+	sig_r = outbuf;
+	sig_s = (u8 *)outbuf + nbytes;
+
+	if (test == ECDSA_TEST_SIGN) {
+		/* compare r & s */
+		if (memcmp(r_str, sig_r, nbytes) ||
+		    memcmp(s_str, sig_s, nbytes)) {
+			err = -EINVAL;
+			goto error;
+		}
+	} else {
+		/* Set src and dst buffers */
+		sg_init_table(src_tab, 3);
+		sg_set_buf(&src_tab[0], m_str, vec->m_size);
+		sg_set_buf(&src_tab[1], sig_r, nbytes);
+		sg_set_buf(&src_tab[2], sig_s, nbytes);
+		sg_init_one(&dst, outbuf, outbuf_maxlen);
+
+		akcipher_request_set_crypt(req, src_tab, &dst,
+					   vec->m_size + 2 * nbytes,
+					   outbuf_maxlen);
+
+		/* Set up result callback */
+		init_completion(&result.completion);
+		akcipher_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG,
+					      tcrypt_complete, &result);
+
+		/* Run ecdsa verify operation on sig (r,s) */
+		err = wait_async_op(&result, crypto_akcipher_verify(req));
+		if (err)
+			goto error;
+	}
+
+error:
+	akcipher_request_free(req);
+	kfree(k_str);
+	kfree(r_str);
+	kfree(s_str);
+	kfree(m_str);
+	kfree(outbuf);
+	return err;
+}
+
+static int do_test_ecdsa_sign_verify(struct crypto_akcipher *tfm,
+				     struct akcipher_testvec *vec)
+{
+	int err;
+
+	err = __do_test_ecdsa_sign_verify(tfm, vec, ECDSA_TEST_SIGN_VERIFY);
+	if (err)
+		pr_err("alg: ecdsa: sign/verify test failed. err %d\n", err);
+
+	return err;
+}
+
+static int do_test_ecdsa_sign(struct crypto_akcipher *tfm,
+			      struct akcipher_testvec *vec)
+{
+	int err;
+
+	err = __do_test_ecdsa_sign_verify(tfm, vec, ECDSA_TEST_SIGN);
+	if (err)
+		pr_err("alg: ecdsa: sign test failed. err %d\n", err);
+
+	return err;
+}
+
+static int test_ecdsa_akcipher(struct crypto_akcipher *tfm, const char *alg,
+		       struct akcipher_testvec *vecs, unsigned int tcount)
+{
+	int i, err = 0;
+
+	for (i = 0; i < tcount; i++) {
+		err = do_test_ecdsa_verify(tfm, &vecs[i]);
+		if (!err)
+			continue;
+
+		return err;
+	}
+
+	for (i = 0; i < tcount; i++) {
+		err = do_test_ecdsa_invalid_verify(tfm, &vecs[i]);
+		if (!err)
+			continue;
+
+		return err;
+	}
+
+	for (i = 0; i < tcount; i++) {
+		err = do_test_ecdsa_sign_verify(tfm, &vecs[i]);
+		if (!err)
+			continue;
+
+		return err;
+	}
+
+	for (i = 0; i < tcount; i++) {
+		err = do_test_ecdsa_sign(tfm, &vecs[i]);
+		if (!err)
+			continue;
+
+		return err;
+	}
+
+	return 0;
+}
+
 static int test_akcipher_one(struct crypto_akcipher *tfm,
 			     struct akcipher_testvec *vecs)
 {
@@ -2236,9 +2545,17 @@ static int alg_test_akcipher(const struct alg_test_desc *desc,
 		       driver, PTR_ERR(tfm));
 		return PTR_ERR(tfm);
 	}
-	if (desc->suite.akcipher.vecs)
-		err = test_akcipher(tfm, desc->alg, desc->suite.akcipher.vecs,
-				    desc->suite.akcipher.count);
+
+	if (desc->suite.akcipher.vecs) {
+		if (strncmp(desc->alg, "ecdsa", 5) == 0)
+			err = test_ecdsa_akcipher(tfm, desc->alg,
+						  desc->suite.akcipher.vecs,
+						  desc->suite.akcipher.count);
+		else
+			err = test_akcipher(tfm, desc->alg,
+					    desc->suite.akcipher.vecs,
+					    desc->suite.akcipher.count);
+	}
 
 	crypto_free_akcipher(tfm);
 	return err;
@@ -2982,6 +3299,13 @@ static int alg_test_null(const struct alg_test_desc *desc,
 			.kpp = __VECS(ecdh_tv_template)
 		}
 	}, {
+		.alg = "ecdsa",
+		.test = alg_test_akcipher,
+		.fips_allowed = 1,
+		.suite = {
+			.akcipher = __VECS(ecdsa_tv_template)
+		}
+	}, {
 		.alg = "gcm(aes)",
 		.test = alg_test_aead,
 		.fips_allowed = 1,
diff --git a/crypto/testmgr.h b/crypto/testmgr.h
index 64595f067d72..00bb57f4707a 100644
--- a/crypto/testmgr.h
+++ b/crypto/testmgr.h
@@ -5,6 +5,7 @@
  * Copyright (c) 2002 Jean-Francois Dive <jef@linuxbe.org>
  * Copyright (c) 2007 Nokia Siemens Networks
  * Copyright (c) 2008 Herbert Xu <herbert@gondor.apana.org.au>
+ * Copyright (c) 2017 NVIDIA Corporation
  *
  * Updated RFC4106 AES-GCM testing. Some test vectors were taken from
  * http://csrc.nist.gov/groups/ST/toolkit/BCM/documents/proposedmodes/
@@ -755,6 +756,145 @@ struct kpp_testvec dh_tv_template[] = {
 	}
 };
 
+/*
+ * ECDSA NIST test vectors from SigGenComponent.txt file from
+ * 186-3ecdsasiggencomponenttestvectors.zip for P-192 and P-256
+ * elliptic curves.
+ */
+static struct akcipher_testvec ecdsa_tv_template[] = {
+	{
+#ifndef CONFIG_CRYPTO_FIPS
+		/* [P-192,SHA-1] */
+		.m =
+		/* Msg / Hash */
+		"\x92\x5b\xd6\xf4\x1c\x55\xbe\x3e"
+		"\x49\xb7\x16\xe6\x1d\x42\x12\x3f"
+		"\x42\x79\x80\x60",
+		.m_size = 20,
+		.key =
+		/* version */
+		"\x01"
+		/* curve_id */
+		"\x01"
+		/* d */
+		"\xf3\xd7\x60\xd6\x75\xf2\xcc\xeb"
+		"\xf0\xd2\xfd\xb3\xb9\x41\x3f\xb0"
+		"\xf8\x4f\x37\xd1\xb3\x37\x4f\xe1"
+		/* Qx */
+		"\xe6\x98\xcf\x5b\x2d\x2d\x98\x94"
+		"\x4c\x49\xa2\x80\x6e\x09\x32\x64"
+		"\xe7\xdb\x08\x0b\xa4\x8e\x00\x07"
+		/* Qy */
+		"\x77\x54\xd6\xe4\xf2\xd7\x1b\xc4"
+		"\x98\x6d\xe2\x5d\x21\xba\x36\xa6"
+		"\x4e\x41\x0b\xd0\x81\xb6\xfa\x76",
+		.key_len = 74,
+		.c =
+		/* k */
+		"\x25\x5f\x68\x89\xa2\x31\xbc\x57"
+		"\x4d\x15\xc4\x12\xfb\x56\x45\x68"
+		"\x83\x07\xa1\x43\x70\xbc\x0a\xcb"
+		/* R */
+		"\x3e\xa6\x58\x62\xb4\x98\x96\x1a"
+		"\xf9\xf2\x5b\xec\x55\xf8\xdd\xff"
+		"\x93\xd7\xd0\xbd\x62\xd9\x94\x69"
+		/* S */
+		"\x41\x9f\x1a\x0e\xc0\x5f\xcf\x73"
+		"\x5b\x40\x21\x85\xbc\x02\xab\x44"
+		"\x37\x90\x34\xa2\x65\x64\xba\x02",
+		.c_size = 72,
+	}, {
+		/* [P-192,SHA-256] */
+		.m =
+		/* Msg / Hash */
+		"\xd0\xd8\xc0\x99\xe0\xe2\xf7\xf8"
+		"\x87\xe1\x6d\x11\xe1\xcc\x20\x43"
+		"\xaf\xc0\x80\xdb\x47\x72\xfa\xe3"
+		"\x95\xe5\xd1\x34\x7d\x31\xe8\x5a",
+		.m_size = 32,
+		.key =
+		/* version */
+		"\x01"
+		/* curve_id */
+		"\x01"
+		/* d */
+		"\x47\x7a\xf2\x5c\x86\xef\x09\x08"
+		"\xa4\x9a\x47\x53\x06\xfc\x61\xbc"
+		"\xa5\x6f\xdd\x7d\x2f\xd2\xed\x24"
+		/* Qx */
+		"\xdc\x14\xd4\xd8\x2e\x1e\x25\x2f"
+		"\x66\x28\xaa\x80\xbc\x38\x6a\x07"
+		"\x8a\x70\xb7\x74\x71\x2d\xf1\x9b"
+		/* Qy */
+		"\x98\x34\x57\x11\xb0\xdc\x3d\xff"
+		"\xfc\xdc\xfe\xa2\x1c\x47\x9e\x4e"
+		"\x82\x08\xfc\x7d\xd0\xc8\x54\x48",
+		.key_len = 74,
+		.c =
+		/* k */
+		"\x3e\x70\xc7\x86\xaf\xaa\x71\x7c"
+		"\x68\x96\xc5\xc3\xec\xb8\x29\xa3"
+		"\xfa\xf7\xa5\x36\xa2\x17\xc8\xa5"
+		/* R */
+		"\xf8\xef\x13\xa8\x86\xe6\x73\x85"
+		"\xdf\x2e\x88\x99\x91\x9b\xc2\x90"
+		"\xea\x1f\x36\xf4\xec\xba\x4a\x35"
+		/* S */
+		"\xc1\x82\x9e\x94\xb7\x58\x2c\x63"
+		"\x8e\xd7\x15\x5a\x38\x47\x30\x9b"
+		"\x1c\x11\x86\xac\x00\x00\xf5\x80",
+		.c_size = 72,
+	}, {
+#endif
+		/* [P-256,SHA-256] */
+		.m =
+		/* Msg / Hash */
+		"\x56\xec\x33\xa1\xa6\xe7\xc4\xdb"
+		"\x77\x03\x90\x1a\xfb\x2e\x1e\x4e"
+		"\x50\x09\xfe\x04\x72\x89\xc5\xc2"
+		"\x42\x13\x6c\xe3\xb7\xf6\xac\x44",
+		.m_size = 32,
+		.key =
+		/* version */
+		"\x01"
+		/* curve_id */
+		"\x02"
+		/* d */
+		"\x64\xb4\x72\xda\x6d\xa5\x54\xca"
+		"\xac\x3e\x4e\x0b\x13\xc8\x44\x5b"
+		"\x1a\x77\xf4\x59\xee\xa8\x4f\x1f"
+		"\x58\x8b\x5f\x71\x3d\x42\x9b\x51"
+		/* Qx */
+		"\x83\xbf\x71\xc2\x46\xff\x59\x3c"
+		"\x2f\xb1\xbf\x4b\xe9\x5d\x56\xd3"
+		"\xcc\x8f\xdb\x48\xa2\xbf\x33\xf0"
+		"\xf4\xc7\x5f\x07\x1c\xe9\xcb\x1c"
+		/* Qy */
+		"\xa9\x4c\x9a\xa8\x5c\xcd\x7c\xdc"
+		"\x78\x4e\x40\xb7\x93\xca\xb7\x6d"
+		"\xe0\x13\x61\x0e\x2c\xdb\x1f\x1a"
+		"\xa2\xf9\x11\x88\xc6\x14\x40\xce",
+		.key_len = 98,
+		.c =
+		/* k */
+		"\xde\x68\x2a\x64\x87\x07\x67\xb9"
+		"\x33\x5d\x4f\x82\x47\x62\x4a\x3b"
+		"\x7f\x3c\xe9\xf9\x45\xf2\x80\xa2"
+		"\x61\x6a\x90\x4b\xb1\xbb\xa1\x94"
+		/* R */
+		"\xac\xc2\xc8\x79\x6f\x5e\xbb\xca"
+		"\x7a\x5a\x55\x6a\x1f\x6b\xfd\x2a"
+		"\xed\x27\x95\x62\xd6\xe3\x43\x88"
+		"\x5b\x79\x14\xb5\x61\x80\xac\xf3"
+		/* S */
+		"\x03\x89\x05\xcc\x2a\xda\xcd\x3c"
+		"\x5a\x17\x6f\xe9\x18\xb2\x97\xef"
+		"\x1c\x37\xf7\x2b\x26\x76\x6c\x78"
+		"\xb2\xa6\x05\xca\x19\x78\xf7\x8b",
+		.c_size = 96,
+	},
+};
+
 struct kpp_testvec ecdh_tv_template[] = {
 	{
 #ifndef CONFIG_CRYPTO_FIPS
-- 
1.7.6.3
