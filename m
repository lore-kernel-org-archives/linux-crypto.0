From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: [PATCH  v4 3/3] crypto: akcipher - Changes to asymmetric key API
Date: Thu, 01 Oct 2015 13:29:01 -0700
Message-ID: <20151001202901.7193.98754.stgit@tstruk-mobl1>
References: <20151001202845.7193.51602.stgit@tstruk-mobl1>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, qat-linux@intel.com,
	tadeusz.struk@intel.com
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:36998 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756854AbbJAUbH (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 1 Oct 2015 16:31:07 -0400
In-Reply-To: <20151001202845.7193.51602.stgit@tstruk-mobl1>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Setkey function has been split into set_priv_key and set_pub_key.
Akcipher requests takes sgl for src and dst instead of void *.
Users of the API i.e. two existing RSA implementation and
test mgr code have been updated accordingly.

Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>
---
 crypto/Makefile                                   |    9 +
 crypto/rsa.c                                      |  111 ++++++----
 crypto/rsa_helper.c                               |   42 +++-
 crypto/rsakey.asn1                                |    5 
 crypto/rsaprivkey.asn1                            |   11 +
 crypto/rsapubkey.asn1                             |    4 
 crypto/testmgr.c                                  |   38 ++--
 crypto/testmgr.h                                  |   36 ++-
 drivers/crypto/qat/qat_common/Makefile            |   12 +
 drivers/crypto/qat/qat_common/qat_asym_algs.c     |  227 +++++++++++++++------
 drivers/crypto/qat/qat_common/qat_rsakey.asn1     |    5 
 drivers/crypto/qat/qat_common/qat_rsaprivkey.asn1 |   11 +
 drivers/crypto/qat/qat_common/qat_rsapubkey.asn1  |    4 
 include/crypto/akcipher.h                         |   94 ++++++---
 include/crypto/internal/rsa.h                     |    7 -
 15 files changed, 435 insertions(+), 181 deletions(-)
 delete mode 100644 crypto/rsakey.asn1
 create mode 100644 crypto/rsaprivkey.asn1
 create mode 100644 crypto/rsapubkey.asn1
 delete mode 100644 drivers/crypto/qat/qat_common/qat_rsakey.asn1
 create mode 100644 drivers/crypto/qat/qat_common/qat_rsaprivkey.asn1
 create mode 100644 drivers/crypto/qat/qat_common/qat_rsapubkey.asn1

diff --git a/crypto/Makefile b/crypto/Makefile
index e2c5981..d897e0b 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -31,10 +31,13 @@ obj-$(CONFIG_CRYPTO_HASH2) += crypto_hash.o
 obj-$(CONFIG_CRYPTO_PCOMP2) += pcompress.o
 obj-$(CONFIG_CRYPTO_AKCIPHER2) += akcipher.o
 
-$(obj)/rsakey-asn1.o: $(obj)/rsakey-asn1.c $(obj)/rsakey-asn1.h
-clean-files += rsakey-asn1.c rsakey-asn1.h
+$(obj)/rsapubkey-asn1.o: $(obj)/rsapubkey-asn1.c $(obj)/rsapubkey-asn1.h
+$(obj)/rsaprivkey-asn1.o: $(obj)/rsaprivkey-asn1.c $(obj)/rsaprivkey-asn1.h
+clean-files += rsapubkey-asn1.c rsapubkey-asn1.h
+clean-files += rsaprivkey-asn1.c rsaprivkey-asn1.h
 
-rsa_generic-y := rsakey-asn1.o
+rsa_generic-y := rsapubkey-asn1.o
+rsa_generic-y += rsaprivkey-asn1.o
 rsa_generic-y += rsa.o
 rsa_generic-y += rsa_helper.o
 obj-$(CONFIG_CRYPTO_RSA) += rsa_generic.o
diff --git a/crypto/rsa.c b/crypto/rsa.c
index 466003e..f53bef4 100644
--- a/crypto/rsa.c
+++ b/crypto/rsa.c
@@ -80,41 +80,41 @@ static int rsa_enc(struct akcipher_request *req)
 	struct crypto_akcipher *tfm = crypto_akcipher_reqtfm(req);
 	const struct rsa_key *pkey = rsa_get_key(tfm);
 	MPI m, c = mpi_alloc(0);
+	unsigned int src_len = sg_len(req->src), dst_len = sg_len(req->dst);
 	int ret = 0;
 	int sign;
 
 	if (!c)
 		return -ENOMEM;
 
-	if (unlikely(!pkey->n || !pkey->e)) {
+	if (unlikely(!pkey->n || !pkey->e || !src_len ||
+		     src_len < req->src_len)) {
 		ret = -EINVAL;
 		goto err_free_c;
 	}
 
-	if (req->dst_len < mpi_get_size(pkey->n)) {
+	if (dst_len < mpi_get_size(pkey->n)) {
 		req->dst_len = mpi_get_size(pkey->n);
 		ret = -EOVERFLOW;
 		goto err_free_c;
 	}
 
-	m = mpi_read_raw_data(req->src, req->src_len);
-	if (!m) {
-		ret = -ENOMEM;
+	src_len = req->src_len;
+	ret = -ENOMEM;
+	m = mpi_read_raw_from_sgl(req->src, src_len);
+	if (!m)
 		goto err_free_c;
-	}
 
 	ret = _rsa_enc(pkey, c, m);
 	if (ret)
 		goto err_free_m;
 
-	ret = mpi_read_buffer(c, req->dst, req->dst_len, &req->dst_len, &sign);
+	ret = mpi_write_to_sgl(c, req->dst, &req->dst_len, &sign);
 	if (ret)
 		goto err_free_m;
 
-	if (sign < 0) {
+	if (sign < 0)
 		ret = -EBADMSG;
-		goto err_free_m;
-	}
 
 err_free_m:
 	mpi_free(m);
@@ -128,42 +128,41 @@ static int rsa_dec(struct akcipher_request *req)
 	struct crypto_akcipher *tfm = crypto_akcipher_reqtfm(req);
 	const struct rsa_key *pkey = rsa_get_key(tfm);
 	MPI c, m = mpi_alloc(0);
+	unsigned int src_len = sg_len(req->src), dst_len = sg_len(req->dst);
 	int ret = 0;
 	int sign;
 
 	if (!m)
 		return -ENOMEM;
 
-	if (unlikely(!pkey->n || !pkey->d)) {
+	if (unlikely(!pkey->n || !pkey->d || !src_len ||
+		     src_len < req->src_len)) {
 		ret = -EINVAL;
 		goto err_free_m;
 	}
 
-	if (req->dst_len < mpi_get_size(pkey->n)) {
+	if (dst_len < mpi_get_size(pkey->n)) {
 		req->dst_len = mpi_get_size(pkey->n);
 		ret = -EOVERFLOW;
 		goto err_free_m;
 	}
 
-	c = mpi_read_raw_data(req->src, req->src_len);
-	if (!c) {
-		ret = -ENOMEM;
+	src_len = req->src_len;
+	ret = -ENOMEM;
+	c = mpi_read_raw_from_sgl(req->src, src_len);
+	if (!c)
 		goto err_free_m;
-	}
 
 	ret = _rsa_dec(pkey, m, c);
 	if (ret)
 		goto err_free_c;
 
-	ret = mpi_read_buffer(m, req->dst, req->dst_len, &req->dst_len, &sign);
+	ret = mpi_write_to_sgl(m, req->dst, &req->dst_len, &sign);
 	if (ret)
 		goto err_free_c;
 
-	if (sign < 0) {
+	if (sign < 0)
 		ret = -EBADMSG;
-		goto err_free_c;
-	}
-
 err_free_c:
 	mpi_free(c);
 err_free_m:
@@ -176,41 +175,41 @@ static int rsa_sign(struct akcipher_request *req)
 	struct crypto_akcipher *tfm = crypto_akcipher_reqtfm(req);
 	const struct rsa_key *pkey = rsa_get_key(tfm);
 	MPI m, s = mpi_alloc(0);
+	unsigned int src_len = sg_len(req->src), dst_len = sg_len(req->dst);
 	int ret = 0;
 	int sign;
 
 	if (!s)
 		return -ENOMEM;
 
-	if (unlikely(!pkey->n || !pkey->d)) {
+	if (unlikely(!pkey->n || !pkey->d || !src_len ||
+		     src_len < req->src_len)) {
 		ret = -EINVAL;
 		goto err_free_s;
 	}
 
-	if (req->dst_len < mpi_get_size(pkey->n)) {
+	if (dst_len < mpi_get_size(pkey->n)) {
 		req->dst_len = mpi_get_size(pkey->n);
 		ret = -EOVERFLOW;
 		goto err_free_s;
 	}
 
-	m = mpi_read_raw_data(req->src, req->src_len);
-	if (!m) {
-		ret = -ENOMEM;
+	src_len = req->src_len;
+	ret = -ENOMEM;
+	m = mpi_read_raw_from_sgl(req->src, src_len);
+	if (!m)
 		goto err_free_s;
-	}
 
 	ret = _rsa_sign(pkey, s, m);
 	if (ret)
 		goto err_free_m;
 
-	ret = mpi_read_buffer(s, req->dst, req->dst_len, &req->dst_len, &sign);
+	ret = mpi_write_to_sgl(s, req->dst, &req->dst_len, &sign);
 	if (ret)
 		goto err_free_m;
 
-	if (sign < 0) {
+	if (sign < 0)
 		ret = -EBADMSG;
-		goto err_free_m;
-	}
 
 err_free_m:
 	mpi_free(m);
@@ -224,24 +223,28 @@ static int rsa_verify(struct akcipher_request *req)
 	struct crypto_akcipher *tfm = crypto_akcipher_reqtfm(req);
 	const struct rsa_key *pkey = rsa_get_key(tfm);
 	MPI s, m = mpi_alloc(0);
+	unsigned int src_len = sg_len(req->src), dst_len = sg_len(req->dst);
 	int ret = 0;
 	int sign;
 
 	if (!m)
 		return -ENOMEM;
 
-	if (unlikely(!pkey->n || !pkey->e)) {
+	if (unlikely(!pkey->n || !pkey->e || !src_len ||
+		     src_len < req->src_len)) {
 		ret = -EINVAL;
 		goto err_free_m;
 	}
 
-	if (req->dst_len < mpi_get_size(pkey->n)) {
+	if (dst_len < mpi_get_size(pkey->n)) {
 		req->dst_len = mpi_get_size(pkey->n);
 		ret = -EOVERFLOW;
 		goto err_free_m;
 	}
 
-	s = mpi_read_raw_data(req->src, req->src_len);
+	src_len = req->src_len;
+	ret = -ENOMEM;
+	s = mpi_read_raw_from_sgl(req->src, src_len);
 	if (!s) {
 		ret = -ENOMEM;
 		goto err_free_m;
@@ -251,14 +254,12 @@ static int rsa_verify(struct akcipher_request *req)
 	if (ret)
 		goto err_free_s;
 
-	ret = mpi_read_buffer(m, req->dst, req->dst_len, &req->dst_len, &sign);
+	ret = mpi_write_to_sgl(m, req->dst, &req->dst_len, &sign);
 	if (ret)
 		goto err_free_s;
 
-	if (sign < 0) {
+	if (sign < 0)
 		ret = -EBADMSG;
-		goto err_free_s;
-	}
 
 err_free_s:
 	mpi_free(s);
@@ -282,13 +283,13 @@ static int rsa_check_key_length(unsigned int len)
 	return -EINVAL;
 }
 
-static int rsa_setkey(struct crypto_akcipher *tfm, const void *key,
-		      unsigned int keylen)
+static int rsa_set_pub_key(struct crypto_akcipher *tfm, const void *key,
+			   unsigned int keylen)
 {
 	struct rsa_key *pkey = akcipher_tfm_ctx(tfm);
 	int ret;
 
-	ret = rsa_parse_key(pkey, key, keylen);
+	ret = rsa_parse_pub_key(pkey, key, keylen);
 	if (ret)
 		return ret;
 
@@ -299,6 +300,30 @@ static int rsa_setkey(struct crypto_akcipher *tfm, const void *key,
 	return ret;
 }
 
+static int rsa_set_priv_key(struct crypto_akcipher *tfm, const void *key,
+			    unsigned int keylen)
+{
+	struct rsa_key *pkey = akcipher_tfm_ctx(tfm);
+	int ret;
+
+	ret = rsa_parse_priv_key(pkey, key, keylen);
+	if (ret)
+		return ret;
+
+	if (rsa_check_key_length(mpi_get_size(pkey->n) << 3)) {
+		rsa_free_key(pkey);
+		ret = -EINVAL;
+	}
+	return ret;
+}
+
+static int rsa_get_len(struct crypto_akcipher *tfm)
+{
+	struct rsa_key *pkey = akcipher_tfm_ctx(tfm);
+
+	return pkey->n ? mpi_get_size(pkey->n) : -EINVAL;
+}
+
 static void rsa_exit_tfm(struct crypto_akcipher *tfm)
 {
 	struct rsa_key *pkey = akcipher_tfm_ctx(tfm);
@@ -311,7 +336,9 @@ static struct akcipher_alg rsa = {
 	.decrypt = rsa_dec,
 	.sign = rsa_sign,
 	.verify = rsa_verify,
-	.setkey = rsa_setkey,
+	.set_priv_key = rsa_set_priv_key,
+	.set_pub_key = rsa_set_pub_key,
+	.get_len = rsa_get_len,
 	.exit = rsa_exit_tfm,
 	.base = {
 		.cra_name = "rsa",
diff --git a/crypto/rsa_helper.c b/crypto/rsa_helper.c
index 8d96ce9..d226f48 100644
--- a/crypto/rsa_helper.c
+++ b/crypto/rsa_helper.c
@@ -15,7 +15,8 @@
 #include <linux/err.h>
 #include <linux/fips.h>
 #include <crypto/internal/rsa.h>
-#include "rsakey-asn1.h"
+#include "rsapubkey-asn1.h"
+#include "rsaprivkey-asn1.h"
 
 int rsa_get_n(void *context, size_t hdrlen, unsigned char tag,
 	      const void *value, size_t vlen)
@@ -94,8 +95,8 @@ void rsa_free_key(struct rsa_key *key)
 EXPORT_SYMBOL_GPL(rsa_free_key);
 
 /**
- * rsa_parse_key() - extracts an rsa key from BER encoded buffer
- *		     and stores it in the provided struct rsa_key
+ * rsa_parse_pub_key() - extracts an rsa public key from BER encoded buffer
+ *			 and stores it in the provided struct rsa_key
  *
  * @rsa_key:	struct rsa_key key representation
  * @key:	key in BER format
@@ -103,13 +104,13 @@ EXPORT_SYMBOL_GPL(rsa_free_key);
  *
  * Return:	0 on success or error code in case of error
  */
-int rsa_parse_key(struct rsa_key *rsa_key, const void *key,
-		  unsigned int key_len)
+int rsa_parse_pub_key(struct rsa_key *rsa_key, const void *key,
+		      unsigned int key_len)
 {
 	int ret;
 
 	free_mpis(rsa_key);
-	ret = asn1_ber_decoder(&rsakey_decoder, rsa_key, key, key_len);
+	ret = asn1_ber_decoder(&rsapubkey_decoder, rsa_key, key, key_len);
 	if (ret < 0)
 		goto error;
 
@@ -118,4 +119,31 @@ error:
 	free_mpis(rsa_key);
 	return ret;
 }
-EXPORT_SYMBOL_GPL(rsa_parse_key);
+EXPORT_SYMBOL_GPL(rsa_parse_pub_key);
+
+/**
+ * rsa_parse_pub_key() - extracts an rsa private key from BER encoded buffer
+ *			 and stores it in the provided struct rsa_key
+ *
+ * @rsa_key:	struct rsa_key key representation
+ * @key:	key in BER format
+ * @key_len:	length of key
+ *
+ * Return:	0 on success or error code in case of error
+ */
+int rsa_parse_priv_key(struct rsa_key *rsa_key, const void *key,
+		       unsigned int key_len)
+{
+	int ret;
+
+	free_mpis(rsa_key);
+	ret = asn1_ber_decoder(&rsaprivkey_decoder, rsa_key, key, key_len);
+	if (ret < 0)
+		goto error;
+
+	return 0;
+error:
+	free_mpis(rsa_key);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(rsa_parse_priv_key);
diff --git a/crypto/rsakey.asn1 b/crypto/rsakey.asn1
deleted file mode 100644
index 3c7b5df..0000000
--- a/crypto/rsakey.asn1
+++ /dev/null
@@ -1,5 +0,0 @@
-RsaKey ::= SEQUENCE {
-	n INTEGER ({ rsa_get_n }),
-	e INTEGER ({ rsa_get_e }),
-	d INTEGER ({ rsa_get_d })
-}
diff --git a/crypto/rsaprivkey.asn1 b/crypto/rsaprivkey.asn1
new file mode 100644
index 0000000..731aea5
--- /dev/null
+++ b/crypto/rsaprivkey.asn1
@@ -0,0 +1,11 @@
+RsaPrivKey ::= SEQUENCE {
+	version		INTEGER,
+	n		INTEGER ({ rsa_get_n }),
+	e		INTEGER ({ rsa_get_e }),
+	d		INTEGER ({ rsa_get_d }),
+	prime1		INTEGER,
+	prime2		INTEGER,
+	exponent1	INTEGER,
+	exponent2	INTEGER,
+	coefficient	INTEGER
+}
diff --git a/crypto/rsapubkey.asn1 b/crypto/rsapubkey.asn1
new file mode 100644
index 0000000..725498e
--- /dev/null
+++ b/crypto/rsapubkey.asn1
@@ -0,0 +1,4 @@
+RsaPubKey ::= SEQUENCE {
+	n INTEGER ({ rsa_get_n }),
+	e INTEGER ({ rsa_get_e })
+}
diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index 523c9b9..41ab1ba 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -1845,34 +1845,33 @@ static int do_test_rsa(struct crypto_akcipher *tfm,
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
+	akcipher_request_set_crypt(req, src_tab, &dst, vecs->m_size);
 	akcipher_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG,
 				      tcrypt_complete, &result);
 
@@ -1882,13 +1881,13 @@ static int do_test_rsa(struct crypto_akcipher *tfm,
 		pr_err("alg: rsa: encrypt test failed. err %d\n", err);
 		goto free_all;
 	}
-	if (out_len != vecs->c_size) {
+	if (req->dst_len != vecs->c_size) {
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
@@ -1903,9 +1902,10 @@ static int do_test_rsa(struct crypto_akcipher *tfm,
 		err = -ENOMEM;
 		goto free_all;
 	}
+	sg_init_one(&src, vecs->c, vecs->c_size);
+	sg_init_one(&dst, outbuf_dec, out_len_max);
 	init_completion(&result.completion);
-	akcipher_request_set_crypt(req, outbuf_enc, outbuf_dec, vecs->c_size,
-				   out_len);
+	akcipher_request_set_crypt(req, &src, &dst, vecs->c_size);
 
 	/* Run RSA decrypt - m = c^d mod n;*/
 	err = wait_async_op(&result, crypto_akcipher_decrypt(req));
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
diff --git a/drivers/crypto/qat/qat_common/Makefile b/drivers/crypto/qat/qat_common/Makefile
index df20a9d..9e9e196 100644
--- a/drivers/crypto/qat/qat_common/Makefile
+++ b/drivers/crypto/qat/qat_common/Makefile
@@ -1,5 +1,10 @@
-$(obj)/qat_rsakey-asn1.o: $(obj)/qat_rsakey-asn1.c $(obj)/qat_rsakey-asn1.h
-clean-files += qat_rsakey-asn1.c qat_rsakey-asn1.h
+$(obj)/qat_rsapubkey-asn1.o: $(obj)/qat_rsapubkey-asn1.c \
+			     $(obj)/qat_rsapubkey-asn1.h
+$(obj)/qat_rsaprivkey-asn1.o: $(obj)/qat_rsaprivkey-asn1.c \
+			      $(obj)/qat_rsaprivkey-asn1.h
+
+clean-files += qat_rsapubkey-asn1.c qat_rsapubkey-asn1.h
+clean-files += qat_rsaprivkey-asn1.c qat_rsapvivkey-asn1.h
 
 obj-$(CONFIG_CRYPTO_DEV_QAT) += intel_qat.o
 intel_qat-objs := adf_cfg.o \
@@ -13,7 +18,8 @@ intel_qat-objs := adf_cfg.o \
 	adf_hw_arbiter.o \
 	qat_crypto.o \
 	qat_algs.o \
-	qat_rsakey-asn1.o \
+	qat_rsapubkey-asn1.o \
+	qat_rsaprivkey-asn1.o \
 	qat_asym_algs.o \
 	qat_uclo.o \
 	qat_hal.o
diff --git a/drivers/crypto/qat/qat_common/qat_asym_algs.c b/drivers/crypto/qat/qat_common/qat_asym_algs.c
index e87f510..c921448 100644
--- a/drivers/crypto/qat/qat_common/qat_asym_algs.c
+++ b/drivers/crypto/qat/qat_common/qat_asym_algs.c
@@ -51,7 +51,9 @@
 #include <crypto/akcipher.h>
 #include <linux/dma-mapping.h>
 #include <linux/fips.h>
-#include "qat_rsakey-asn1.h"
+#include <crypto/scatterwalk.h>
+#include "qat_rsapubkey-asn1.h"
+#include "qat_rsaprivkey-asn1.h"
 #include "icp_qat_fw_pke.h"
 #include "adf_accel_devices.h"
 #include "adf_transport.h"
@@ -106,6 +108,7 @@ struct qat_rsa_request {
 	dma_addr_t phy_in;
 	dma_addr_t phy_out;
 	char *src_align;
+	char *dst_align;
 	struct icp_qat_fw_pke_request req;
 	struct qat_rsa_ctx *ctx;
 	int err;
@@ -118,7 +121,6 @@ static void qat_rsa_cb(struct icp_qat_fw_pke_resp *resp)
 	struct device *dev = &GET_DEV(req->ctx->inst->accel_dev);
 	int err = ICP_QAT_FW_PKE_RESP_PKE_STAT_GET(
 				resp->pke_resp_hdr.comn_resp_flags);
-	char *ptr = areq->dst;
 
 	err = (err == ICP_QAT_FW_COMN_STATUS_FLAG_OK) ? 0 : -EINVAL;
 
@@ -129,24 +131,44 @@ static void qat_rsa_cb(struct icp_qat_fw_pke_resp *resp)
 		dma_unmap_single(dev, req->in.enc.m, req->ctx->key_sz,
 				 DMA_TO_DEVICE);
 
-	dma_unmap_single(dev, req->out.enc.c, req->ctx->key_sz,
-			 DMA_FROM_DEVICE);
+	areq->dst_len = req->ctx->key_sz;
+	if (req->dst_align) {
+		char *ptr = req->dst_align;
+
+		while (!(*ptr) && areq->dst_len) {
+			areq->dst_len--;
+			ptr++;
+		}
+
+		if (areq->dst_len != req->ctx->key_sz)
+			memmove(req->dst_align, ptr, areq->dst_len);
+
+		scatterwalk_map_and_copy(req->dst_align, areq->dst, 0,
+					 areq->dst_len, 1);
+
+		dma_free_coherent(dev, req->ctx->key_sz, req->dst_align,
+				  req->out.enc.c);
+	} else {
+		char *ptr = sg_virt(areq->dst);
+
+		while (!(*ptr) && areq->dst_len) {
+			areq->dst_len--;
+			ptr++;
+		}
+
+		if (sg_virt(areq->dst) != ptr && areq->dst_len)
+			memmove(sg_virt(areq->dst), ptr, areq->dst_len);
+
+		dma_unmap_single(dev, req->out.enc.c, req->ctx->key_sz,
+				 DMA_FROM_DEVICE);
+	}
+
 	dma_unmap_single(dev, req->phy_in, sizeof(struct qat_rsa_input_params),
 			 DMA_TO_DEVICE);
 	dma_unmap_single(dev, req->phy_out,
 			 sizeof(struct qat_rsa_output_params),
 			 DMA_TO_DEVICE);
 
-	areq->dst_len = req->ctx->key_sz;
-	/* Need to set the corect length of the output */
-	while (!(*ptr) && areq->dst_len) {
-		areq->dst_len--;
-		ptr++;
-	}
-
-	if (areq->dst_len != req->ctx->key_sz)
-		memmove(areq->dst, ptr, areq->dst_len);
-
 	akcipher_request_complete(areq, err);
 }
 
@@ -224,15 +246,17 @@ static int qat_rsa_enc(struct akcipher_request *req)
 	struct qat_rsa_request *qat_req =
 			PTR_ALIGN(akcipher_request_ctx(req), 64);
 	struct icp_qat_fw_pke_request *msg = &qat_req->req;
+	unsigned int src_len = sg_len(req->src), dst_len = sg_len(req->dst);
 	int ret, ctr = 0;
 
-	if (unlikely(!ctx->n || !ctx->e))
+	if (unlikely(!ctx->n || !ctx->e || !src_len || src_len < req->src_len))
 		return -EINVAL;
 
-	if (req->dst_len < ctx->key_sz) {
+	if (dst_len < ctx->key_sz) {
 		req->dst_len = ctx->key_sz;
 		return -EOVERFLOW;
 	}
+	src_len = req->src_len;
 	memset(msg, '\0', sizeof(*msg));
 	ICP_QAT_FW_PKE_HDR_VALID_FLAG_SET(msg->pke_hdr,
 					  ICP_QAT_FW_COMN_REQ_FLAG_SET);
@@ -255,9 +279,17 @@ static int qat_rsa_enc(struct akcipher_request *req)
 	 * same as modulo n so in case it is different we need to allocate a
 	 * new buf and copy src data.
 	 * In other case we just need to map the user provided buffer.
+	 * Also need to make sure that it is in contiguous buffer.
 	 */
-	if (req->src_len < ctx->key_sz) {
-		int shift = ctx->key_sz - req->src_len;
+	if (sg_is_last(req->src) && src_len == ctx->key_sz) {
+		qat_req->src_align = NULL;
+		qat_req->in.enc.m = dma_map_single(dev, sg_virt(req->src),
+						   src_len, DMA_TO_DEVICE);
+		if (unlikely(dma_mapping_error(dev, qat_req->in.enc.m)))
+			return ret;
+
+	} else {
+		int shift = ctx->key_sz - src_len;
 
 		qat_req->src_align = dma_zalloc_coherent(dev, ctx->key_sz,
 							 &qat_req->in.enc.m,
@@ -265,29 +297,38 @@ static int qat_rsa_enc(struct akcipher_request *req)
 		if (unlikely(!qat_req->src_align))
 			return ret;
 
-		memcpy(qat_req->src_align + shift, req->src, req->src_len);
+		scatterwalk_map_and_copy(qat_req->src_align + shift, req->src,
+					 0, src_len, 0);
+	}
+	if (sg_is_last(req->dst) && dst_len == ctx->key_sz) {
+		qat_req->dst_align = NULL;
+		qat_req->out.enc.c = dma_map_single(dev, sg_virt(req->dst),
+						     dst_len, DMA_FROM_DEVICE);
+
+		if (unlikely(dma_mapping_error(dev, qat_req->out.enc.c)))
+			goto unmap_src;
+
 	} else {
-		qat_req->src_align = NULL;
-		qat_req->in.enc.m = dma_map_single(dev, req->src, req->src_len,
-					   DMA_TO_DEVICE);
+		qat_req->dst_align = dma_zalloc_coherent(dev, ctx->key_sz,
+							 &qat_req->out.enc.c,
+							 GFP_KERNEL);
+		if (unlikely(!qat_req->dst_align))
+			goto unmap_src;
+
 	}
 	qat_req->in.in_tab[3] = 0;
-	qat_req->out.enc.c = dma_map_single(dev, req->dst, req->dst_len,
-					    DMA_FROM_DEVICE);
 	qat_req->out.out_tab[1] = 0;
 	qat_req->phy_in = dma_map_single(dev, &qat_req->in.enc.m,
 					 sizeof(struct qat_rsa_input_params),
 					 DMA_TO_DEVICE);
+	if (unlikely(dma_mapping_error(dev, qat_req->phy_in)))
+		goto unmap_dst;
+
 	qat_req->phy_out = dma_map_single(dev, &qat_req->out.enc.c,
 					  sizeof(struct qat_rsa_output_params),
-					    DMA_TO_DEVICE);
-
-	if (unlikely((!qat_req->src_align &&
-		      dma_mapping_error(dev, qat_req->in.enc.m)) ||
-		     dma_mapping_error(dev, qat_req->out.enc.c) ||
-		     dma_mapping_error(dev, qat_req->phy_in) ||
-		     dma_mapping_error(dev, qat_req->phy_out)))
-		goto unmap;
+					  DMA_TO_DEVICE);
+	if (unlikely(dma_mapping_error(dev, qat_req->phy_out)))
+		goto unmap_in_params;
 
 	msg->pke_mid.src_data_addr = qat_req->phy_in;
 	msg->pke_mid.dest_data_addr = qat_req->phy_out;
@@ -300,7 +341,7 @@ static int qat_rsa_enc(struct akcipher_request *req)
 
 	if (!ret)
 		return -EINPROGRESS;
-unmap:
+unmap_src:
 	if (qat_req->src_align)
 		dma_free_coherent(dev, ctx->key_sz, qat_req->src_align,
 				  qat_req->in.enc.m);
@@ -308,9 +349,15 @@ unmap:
 		if (!dma_mapping_error(dev, qat_req->in.enc.m))
 			dma_unmap_single(dev, qat_req->in.enc.m, ctx->key_sz,
 					 DMA_TO_DEVICE);
-	if (!dma_mapping_error(dev, qat_req->out.enc.c))
-		dma_unmap_single(dev, qat_req->out.enc.c, ctx->key_sz,
-				 DMA_FROM_DEVICE);
+unmap_dst:
+	if (qat_req->dst_align)
+		dma_free_coherent(dev, ctx->key_sz, qat_req->dst_align,
+				  qat_req->out.enc.c);
+	else
+		if (!dma_mapping_error(dev, qat_req->out.enc.c))
+			dma_unmap_single(dev, qat_req->out.enc.c, ctx->key_sz,
+					 DMA_FROM_DEVICE);
+unmap_in_params:
 	if (!dma_mapping_error(dev, qat_req->phy_in))
 		dma_unmap_single(dev, qat_req->phy_in,
 				 sizeof(struct qat_rsa_input_params),
@@ -331,15 +378,17 @@ static int qat_rsa_dec(struct akcipher_request *req)
 	struct qat_rsa_request *qat_req =
 			PTR_ALIGN(akcipher_request_ctx(req), 64);
 	struct icp_qat_fw_pke_request *msg = &qat_req->req;
+	unsigned int src_len = sg_len(req->src), dst_len = sg_len(req->dst);
 	int ret, ctr = 0;
 
-	if (unlikely(!ctx->n || !ctx->d))
+	if (unlikely(!ctx->n || !ctx->d || !src_len || src_len < req->src_len))
 		return -EINVAL;
 
-	if (req->dst_len < ctx->key_sz) {
+	if (dst_len < ctx->key_sz) {
 		req->dst_len = ctx->key_sz;
 		return -EOVERFLOW;
 	}
+	src_len = req->src_len;
 	memset(msg, '\0', sizeof(*msg));
 	ICP_QAT_FW_PKE_HDR_VALID_FLAG_SET(msg->pke_hdr,
 					  ICP_QAT_FW_COMN_REQ_FLAG_SET);
@@ -362,9 +411,17 @@ static int qat_rsa_dec(struct akcipher_request *req)
 	 * same as modulo n so in case it is different we need to allocate a
 	 * new buf and copy src data.
 	 * In other case we just need to map the user provided buffer.
+	 * Also need to make sure that it is in contiguous buffer.
 	 */
-	if (req->src_len < ctx->key_sz) {
-		int shift = ctx->key_sz - req->src_len;
+	if (sg_is_last(req->src) && src_len == ctx->key_sz) {
+		qat_req->src_align = NULL;
+		qat_req->in.dec.c = dma_map_single(dev, sg_virt(req->src),
+						   dst_len, DMA_TO_DEVICE);
+		if (unlikely(dma_mapping_error(dev, qat_req->in.dec.c)))
+			return ret;
+
+	} else {
+		int shift = ctx->key_sz - src_len;
 
 		qat_req->src_align = dma_zalloc_coherent(dev, ctx->key_sz,
 							 &qat_req->in.dec.c,
@@ -372,29 +429,39 @@ static int qat_rsa_dec(struct akcipher_request *req)
 		if (unlikely(!qat_req->src_align))
 			return ret;
 
-		memcpy(qat_req->src_align + shift, req->src, req->src_len);
+		scatterwalk_map_and_copy(qat_req->src_align + shift, req->src,
+					 0, src_len, 0);
+	}
+	if (sg_is_last(req->dst) && dst_len == ctx->key_sz) {
+		qat_req->dst_align = NULL;
+		qat_req->out.dec.m = dma_map_single(dev, sg_virt(req->dst),
+						    dst_len, DMA_FROM_DEVICE);
+
+		if (unlikely(dma_mapping_error(dev, qat_req->out.dec.m)))
+			goto unmap_src;
+
 	} else {
-		qat_req->src_align = NULL;
-		qat_req->in.dec.c = dma_map_single(dev, req->src, req->src_len,
-						   DMA_TO_DEVICE);
+		qat_req->dst_align = dma_zalloc_coherent(dev, ctx->key_sz,
+							 &qat_req->out.dec.m,
+							 GFP_KERNEL);
+		if (unlikely(!qat_req->dst_align))
+			goto unmap_src;
+
 	}
+
 	qat_req->in.in_tab[3] = 0;
-	qat_req->out.dec.m = dma_map_single(dev, req->dst, req->dst_len,
-					    DMA_FROM_DEVICE);
 	qat_req->out.out_tab[1] = 0;
 	qat_req->phy_in = dma_map_single(dev, &qat_req->in.dec.c,
 					 sizeof(struct qat_rsa_input_params),
 					 DMA_TO_DEVICE);
+	if (unlikely(dma_mapping_error(dev, qat_req->phy_in)))
+		goto unmap_dst;
+
 	qat_req->phy_out = dma_map_single(dev, &qat_req->out.dec.m,
 					  sizeof(struct qat_rsa_output_params),
-					    DMA_TO_DEVICE);
-
-	if (unlikely((!qat_req->src_align &&
-		      dma_mapping_error(dev, qat_req->in.dec.c)) ||
-		     dma_mapping_error(dev, qat_req->out.dec.m) ||
-		     dma_mapping_error(dev, qat_req->phy_in) ||
-		     dma_mapping_error(dev, qat_req->phy_out)))
-		goto unmap;
+					  DMA_TO_DEVICE);
+	if (unlikely(dma_mapping_error(dev, qat_req->phy_out)))
+		goto unmap_in_params;
 
 	msg->pke_mid.src_data_addr = qat_req->phy_in;
 	msg->pke_mid.dest_data_addr = qat_req->phy_out;
@@ -407,7 +474,7 @@ static int qat_rsa_dec(struct akcipher_request *req)
 
 	if (!ret)
 		return -EINPROGRESS;
-unmap:
+unmap_src:
 	if (qat_req->src_align)
 		dma_free_coherent(dev, ctx->key_sz, qat_req->src_align,
 				  qat_req->in.dec.c);
@@ -415,9 +482,15 @@ unmap:
 		if (!dma_mapping_error(dev, qat_req->in.dec.c))
 			dma_unmap_single(dev, qat_req->in.dec.c, ctx->key_sz,
 					 DMA_TO_DEVICE);
-	if (!dma_mapping_error(dev, qat_req->out.dec.m))
-		dma_unmap_single(dev, qat_req->out.dec.m, ctx->key_sz,
-				 DMA_FROM_DEVICE);
+unmap_dst:
+	if (qat_req->dst_align)
+		dma_free_coherent(dev, ctx->key_sz, qat_req->dst_align,
+				  qat_req->out.dec.m);
+	else
+		if (!dma_mapping_error(dev, qat_req->out.dec.m))
+			dma_unmap_single(dev, qat_req->out.dec.m, ctx->key_sz,
+					 DMA_FROM_DEVICE);
+unmap_in_params:
 	if (!dma_mapping_error(dev, qat_req->phy_in))
 		dma_unmap_single(dev, qat_req->phy_in,
 				 sizeof(struct qat_rsa_input_params),
@@ -531,7 +604,7 @@ err:
 }
 
 static int qat_rsa_setkey(struct crypto_akcipher *tfm, const void *key,
-			  unsigned int keylen)
+			  unsigned int keylen, bool private)
 {
 	struct qat_rsa_ctx *ctx = akcipher_tfm_ctx(tfm);
 	struct device *dev = &GET_DEV(ctx->inst->accel_dev);
@@ -550,7 +623,13 @@ static int qat_rsa_setkey(struct crypto_akcipher *tfm, const void *key,
 	ctx->n = NULL;
 	ctx->e = NULL;
 	ctx->d = NULL;
-	ret = asn1_ber_decoder(&qat_rsakey_decoder, ctx, key, keylen);
+
+	if (private)
+		ret = asn1_ber_decoder(&qat_rsaprivkey_decoder, ctx, key,
+				       keylen);
+	else
+		ret = asn1_ber_decoder(&qat_rsapubkey_decoder, ctx, key,
+				       keylen);
 	if (ret < 0)
 		goto free;
 
@@ -559,6 +638,11 @@ static int qat_rsa_setkey(struct crypto_akcipher *tfm, const void *key,
 		ret = -EINVAL;
 		goto free;
 	}
+	if (private && !ctx->d) {
+		/* invalid private key provided */
+		ret = -EINVAL;
+		goto free;
+	}
 
 	return 0;
 free:
@@ -579,6 +663,25 @@ free:
 	return ret;
 }
 
+static int qat_rsa_setpubkey(struct crypto_akcipher *tfm, const void *key,
+			     unsigned int keylen)
+{
+	return qat_rsa_setkey(tfm, key, keylen, false);
+}
+
+static int qat_rsa_setprivkey(struct crypto_akcipher *tfm, const void *key,
+			      unsigned int keylen)
+{
+	return qat_rsa_setkey(tfm, key, keylen, true);
+}
+
+static int qat_rsa_get_len(struct crypto_akcipher *tfm)
+{
+	struct qat_rsa_ctx *ctx = akcipher_tfm_ctx(tfm);
+
+	return (ctx->n) ? ctx->key_sz : -EINVAL;
+}
+
 static int qat_rsa_init_tfm(struct crypto_akcipher *tfm)
 {
 	struct qat_rsa_ctx *ctx = akcipher_tfm_ctx(tfm);
@@ -617,7 +720,9 @@ static struct akcipher_alg rsa = {
 	.decrypt = qat_rsa_dec,
 	.sign = qat_rsa_dec,
 	.verify = qat_rsa_enc,
-	.setkey = qat_rsa_setkey,
+	.set_pub_key = qat_rsa_setpubkey,
+	.set_priv_key = qat_rsa_setprivkey,
+	.get_len = qat_rsa_get_len,
 	.init = qat_rsa_init_tfm,
 	.exit = qat_rsa_exit_tfm,
 	.reqsize = sizeof(struct qat_rsa_request) + 64,
diff --git a/drivers/crypto/qat/qat_common/qat_rsakey.asn1 b/drivers/crypto/qat/qat_common/qat_rsakey.asn1
deleted file mode 100644
index 97b0e02..0000000
--- a/drivers/crypto/qat/qat_common/qat_rsakey.asn1
+++ /dev/null
@@ -1,5 +0,0 @@
-RsaKey ::= SEQUENCE {
-	n INTEGER ({ qat_rsa_get_n }),
-	e INTEGER ({ qat_rsa_get_e }),
-	d INTEGER ({ qat_rsa_get_d })
-}
diff --git a/drivers/crypto/qat/qat_common/qat_rsaprivkey.asn1 b/drivers/crypto/qat/qat_common/qat_rsaprivkey.asn1
new file mode 100644
index 0000000..f0066ad
--- /dev/null
+++ b/drivers/crypto/qat/qat_common/qat_rsaprivkey.asn1
@@ -0,0 +1,11 @@
+RsaPrivKey ::= SEQUENCE {
+	version		INTEGER,
+	n		INTEGER ({ qat_rsa_get_n }),
+	e		INTEGER ({ qat_rsa_get_e }),
+	d		INTEGER ({ qat_rsa_get_d }),
+	prime1		INTEGER,
+	prime2		INTEGER,
+	exponent1	INTEGER,
+	exponent2	INTEGER,
+	coefficient	INTEGER
+}
diff --git a/drivers/crypto/qat/qat_common/qat_rsapubkey.asn1 b/drivers/crypto/qat/qat_common/qat_rsapubkey.asn1
new file mode 100644
index 0000000..bd667b3
--- /dev/null
+++ b/drivers/crypto/qat/qat_common/qat_rsapubkey.asn1
@@ -0,0 +1,4 @@
+RsaPubKey ::= SEQUENCE {
+	n INTEGER ({ qat_rsa_get_n }),
+	e INTEGER ({ qat_rsa_get_e })
+}
diff --git a/include/crypto/akcipher.h b/include/crypto/akcipher.h
index 69d163e..f708233 100644
--- a/include/crypto/akcipher.h
+++ b/include/crypto/akcipher.h
@@ -13,26 +13,27 @@
 #ifndef _CRYPTO_AKCIPHER_H
 #define _CRYPTO_AKCIPHER_H
 #include <linux/crypto.h>
+#include <linux/scatterlist.h>
 
 /**
  * struct akcipher_request - public key request
  *
  * @base:	Common attributes for async crypto requests
- * @src:	Pointer to memory containing the input parameters
- *		The format of the parameter(s) is expeted to be Octet String
- * @dst:	Pointer to memory whare the result will be stored
- * @src_len:	Size of the input parameter
+ * @src:	Source data
+ * @dst:	Destination data
+ * @src_len:	Size of the input buffer
  * @dst_len:	Size of the output buffer. It needs to be at leaset
  *		as big as the expected result depending	on the operation
  *		After operation it will be updated with the acctual size of the
- *		result. In case of error, where the dst_len was insufficient,
+ *		result.
+ *		In case of error where the dst sgl size was insufficient,
  *		it will be updated to the size required for the operation.
  * @__ctx:	Start of private context data
  */
 struct akcipher_request {
 	struct crypto_async_request base;
-	void *src;
-	void *dst;
+	struct scatterlist *src;
+	struct scatterlist *dst;
 	unsigned int src_len;
 	unsigned int dst_len;
 	void *__ctx[] CRYPTO_MINALIGN_ATTR;
@@ -67,8 +68,13 @@ struct crypto_akcipher {
  *		algorithm. In case of error, where the dst_len was insufficient,
  *		the req->dst_len will be updated to the size required for the
  *		operation
- * @setkey:	Function invokes the algorithm specific set key function, which
- *		knows how to decode and interpret the BER encoded key
+ * @set_pub_key: Function invokes the algorithm specific set public key
+ *		function, which knows how to decode and interpret
+ *		the BER encoded public key
+ * @set_priv_key: Function invokes the algorithm specific set private key
+ *		function, which knows how to decode and interpret
+ *		the BER encoded private key
+ * @get_len:	Function returns minimum dest buffer size for a given key.
  * @init:	Initialize the cryptographic transformation object.
  *		This function is used to initialize the cryptographic
  *		transformation object. This function is called only once at
@@ -89,8 +95,11 @@ struct akcipher_alg {
 	int (*verify)(struct akcipher_request *req);
 	int (*encrypt)(struct akcipher_request *req);
 	int (*decrypt)(struct akcipher_request *req);
-	int (*setkey)(struct crypto_akcipher *tfm, const void *key,
-		      unsigned int keylen);
+	int (*set_pub_key)(struct crypto_akcipher *tfm, const void *key,
+			   unsigned int keylen);
+	int (*set_priv_key)(struct crypto_akcipher *tfm, const void *key,
+			    unsigned int keylen);
+	int (*get_len)(struct crypto_akcipher *tfm);
 	int (*init)(struct crypto_akcipher *tfm);
 	void (*exit)(struct crypto_akcipher *tfm);
 
@@ -229,21 +238,34 @@ static inline void akcipher_request_set_callback(struct akcipher_request *req,
  * Sets parameters required by crypto operation
  *
  * @req:	public key request
- * @src:	ptr to input parameter
- * @dst:	ptr of output parameter
- * @src_len:	size of the input buffer
- * @dst_len:	size of the output buffer. It will be updated by the
- *		implementation to reflect the acctual size of the result
+ * @src:	ptr to input scatter list
+ * @dst:	ptr to output scatter list
+ * @src_len:	size of the src input scatter list to be processed
  */
 static inline void akcipher_request_set_crypt(struct akcipher_request *req,
-					      void *src, void *dst,
-					      unsigned int src_len,
-					      unsigned int dst_len)
+					      struct scatterlist *src,
+					      struct scatterlist *dst,
+					      unsigned int src_len)
 {
 	req->src = src;
 	req->dst = dst;
 	req->src_len = src_len;
-	req->dst_len = dst_len;
+}
+
+/**
+ * crypto_akcipher_get_len() -- Get minimum len for output buffer
+ *
+ * Function returns minimum dest buffer size for a given key
+ *
+ * @tfm:	AKCIPHER tfm handle allocated with crypto_alloc_akcipher()
+ *
+ * Return: minimum len for output buffer or error code in key hasn't been set
+ */
+static inline int crypto_akcipher_get_len(struct crypto_akcipher *tfm)
+{
+	struct akcipher_alg *alg = crypto_akcipher_alg(tfm);
+
+	return alg->get_len(tfm);
 }
 
 /**
@@ -319,22 +341,44 @@ static inline int crypto_akcipher_verify(struct akcipher_request *req)
 }
 
 /**
- * crypto_akcipher_setkey() -- Invoke public key setkey operation
+ * crypto_akcipher_set_pub_key() -- Invoke set public key operation
+ *
+ * Function invokes the algorithm specific set key function, which knows
+ * how to decode and interpret the encoded key
+ *
+ * @tfm:	tfm handle
+ * @key:	BER encoded public key
+ * @keylen:	length of the key
+ *
+ * Return: zero on success; error code in case of error
+ */
+static inline int crypto_akcipher_set_pub_key(struct crypto_akcipher *tfm,
+					      const void *key,
+					      unsigned int keylen)
+{
+	struct akcipher_alg *alg = crypto_akcipher_alg(tfm);
+
+	return alg->set_pub_key(tfm, key, keylen);
+}
+
+/**
+ * crypto_akcipher_set_priv_key() -- Invoke set private key operation
  *
  * Function invokes the algorithm specific set key function, which knows
  * how to decode and interpret the encoded key
  *
  * @tfm:	tfm handle
- * @key:	BER encoded private or public key
+ * @key:	BER encoded private key
  * @keylen:	length of the key
  *
  * Return: zero on success; error code in case of error
  */
-static inline int crypto_akcipher_setkey(struct crypto_akcipher *tfm, void *key,
-					 unsigned int keylen)
+static inline int crypto_akcipher_set_priv_key(struct crypto_akcipher *tfm,
+					       const void *key,
+					       unsigned int keylen)
 {
 	struct akcipher_alg *alg = crypto_akcipher_alg(tfm);
 
-	return alg->setkey(tfm, key, keylen);
+	return alg->set_priv_key(tfm, key, keylen);
 }
 #endif
diff --git a/include/crypto/internal/rsa.h b/include/crypto/internal/rsa.h
index a8c8636..f997e2d 100644
--- a/include/crypto/internal/rsa.h
+++ b/include/crypto/internal/rsa.h
@@ -20,8 +20,11 @@ struct rsa_key {
 	MPI d;
 };
 
-int rsa_parse_key(struct rsa_key *rsa_key, const void *key,
-		  unsigned int key_len);
+int rsa_parse_pub_key(struct rsa_key *rsa_key, const void *key,
+		      unsigned int key_len);
+
+int rsa_parse_priv_key(struct rsa_key *rsa_key, const void *key,
+		       unsigned int key_len);
 
 void rsa_free_key(struct rsa_key *rsa_key);
 #endif
