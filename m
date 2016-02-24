From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: [PATCH 2/2] crypto: remove padding logic from rsa.c
Date: Wed, 24 Feb 2016 09:12:58 -0800
Message-ID: <20160224171258.29272.1684.stgit@tstruk-mobl1>
References: <20160224171237.29272.51126.stgit@tstruk-mobl1>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: tadeusz.struk@intel.com, linux-kernel@vger.kernel.org,
	balrogg@googlemail.com, linux-security-module@vger.kernel.org,
	keyrings@vger.kernel.org, linux-crypto@vger.kernel.org,
	zohar@linux.vnet.ibm.com
To: dhowells@redhat.com
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160224171237.29272.51126.stgit@tstruk-mobl1>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

This reverts back the rsa.c to do the math primitives only.
It also reverts the akcipher api changes as the hash param
will be passed to the rsa-pkcs1 template.
All padding and encoding logic is moved to the rsa-pkcs1pad.
The software_pkey.c uses pkcs1pad template to allocate the akcipher
and the hash param is passed via pksc1pad.

Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>
---
 crypto/asymmetric_keys/software_pkey.c |   28 ++++
 crypto/rsa.c                           |  210 +++++---------------------------
 crypto/testmgr.c                       |    5 -
 include/crypto/akcipher.h              |    7 -
 4 files changed, 56 insertions(+), 194 deletions(-)

diff --git a/crypto/asymmetric_keys/software_pkey.c b/crypto/asymmetric_keys/software_pkey.c
index 8732a41..69693fd 100644
--- a/crypto/asymmetric_keys/software_pkey.c
+++ b/crypto/asymmetric_keys/software_pkey.c
@@ -75,6 +75,9 @@ int software_pkey_verify_signature(const struct software_pkey *pkey,
 	struct crypto_akcipher *tfm;
 	struct akcipher_request *req;
 	struct scatterlist sig_sg, digest_sg;
+	char alg_name[CRYPTO_MAX_ALG_NAME];
+	void *output;
+	unsigned int outlen;
 	int ret = -ENOMEM;
 
 	pr_devel("==>%s()\n", __func__);
@@ -84,7 +87,11 @@ int software_pkey_verify_signature(const struct software_pkey *pkey,
 	BUG_ON(!sig->digest);
 	BUG_ON(!sig->s);
 
-	tfm = crypto_alloc_akcipher(sig->pkey_algo, 0, 0);
+	if (snprintf(alg_name, CRYPTO_MAX_ALG_NAME, "pkcs1pad(%s,%s)",
+		     sig->pkey_algo, sig->hash_algo) >= CRYPTO_MAX_ALG_NAME)
+		return -EINVAL;
+
+	tfm = crypto_alloc_akcipher(alg_name, 0, 0);
 	if (IS_ERR(tfm))
 		return PTR_ERR(tfm);
 
@@ -96,11 +103,15 @@ int software_pkey_verify_signature(const struct software_pkey *pkey,
 	if (ret)
 		goto error_free_req;
 
+	outlen = crypto_akcipher_maxsize(tfm);
+	output = kmalloc(outlen, GFP_KERNEL);
+	if (!output)
+		goto error_free_req;
+
 	sg_init_one(&sig_sg, sig->s, sig->s_size);
-	sg_init_one(&digest_sg, sig->digest, sig->digest_size);
-	akcipher_request_set_crypt(req, &sig_sg, &digest_sg,
-				   sig->s_size, sig->digest_size,
-				   sig->hash_algo);
+	sg_init_one(&digest_sg, output, outlen);
+	akcipher_request_set_crypt(req, &sig_sg, &digest_sg, sig->s_size,
+				   outlen);
 	init_completion(&compl.completion);
 	akcipher_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG |
 				      CRYPTO_TFM_REQ_MAY_SLEEP,
@@ -112,6 +123,13 @@ int software_pkey_verify_signature(const struct software_pkey *pkey,
 		ret = compl.err;
 	}
 
+	if (!ret) {
+		if (memcmp(sig->digest, output, sig->digest_size) ||
+		    req->dst_len != sig->digest_size)
+			ret = -EBADMSG;
+	}
+
+	kfree(output);
 error_free_req:
 	akcipher_request_free(req);
 error_free_tfm:
diff --git a/crypto/rsa.c b/crypto/rsa.c
index 9a7c9ca..77d737f 100644
--- a/crypto/rsa.c
+++ b/crypto/rsa.c
@@ -16,78 +16,6 @@
 #include <crypto/algapi.h>
 
 /*
- * Hash algorithm OIDs plus ASN.1 DER wrappings [RFC4880 sec 5.2.2].
- */
-static const u8 rsa_digest_info_md5[] = {
-	0x30, 0x20, 0x30, 0x0c, 0x06, 0x08,
-	0x2a, 0x86, 0x48, 0x86, 0xf7, 0x0d, 0x02, 0x05, /* OID */
-	0x05, 0x00, 0x04, 0x10
-};
-
-static const u8 rsa_digest_info_sha1[] = {
-	0x30, 0x21, 0x30, 0x09, 0x06, 0x05,
-	0x2b, 0x0e, 0x03, 0x02, 0x1a,
-	0x05, 0x00, 0x04, 0x14
-};
-
-static const u8 rsa_digest_info_rmd160[] = {
-	0x30, 0x21, 0x30, 0x09, 0x06, 0x05,
-	0x2b, 0x24, 0x03, 0x02, 0x01,
-	0x05, 0x00, 0x04, 0x14
-};
-
-static const u8 rsa_digest_info_sha224[] = {
-	0x30, 0x2d, 0x30, 0x0d, 0x06, 0x09,
-	0x60, 0x86, 0x48, 0x01, 0x65, 0x03, 0x04, 0x02, 0x04,
-	0x05, 0x00, 0x04, 0x1c
-};
-
-static const u8 rsa_digest_info_sha256[] = {
-	0x30, 0x31, 0x30, 0x0d, 0x06, 0x09,
-	0x60, 0x86, 0x48, 0x01, 0x65, 0x03, 0x04, 0x02, 0x01,
-	0x05, 0x00, 0x04, 0x20
-};
-
-static const u8 rsa_digest_info_sha384[] = {
-	0x30, 0x41, 0x30, 0x0d, 0x06, 0x09,
-	0x60, 0x86, 0x48, 0x01, 0x65, 0x03, 0x04, 0x02, 0x02,
-	0x05, 0x00, 0x04, 0x30
-};
-
-static const u8 rsa_digest_info_sha512[] = {
-	0x30, 0x51, 0x30, 0x0d, 0x06, 0x09,
-	0x60, 0x86, 0x48, 0x01, 0x65, 0x03, 0x04, 0x02, 0x03,
-	0x05, 0x00, 0x04, 0x40
-};
-
-static const struct rsa_asn1_template {
-	const char	*name;
-	const u8	*data;
-	size_t		size;
-} rsa_asn1_templates[] = {
-#define _(X) { #X, rsa_digest_info_##X, sizeof(rsa_digest_info_##X) }
-	_(md5),
-	_(sha1),
-	_(rmd160),
-	_(sha256),
-	_(sha384),
-	_(sha512),
-	_(sha224),
-	{ NULL }
-#undef _
-};
-
-static const struct rsa_asn1_template *rsa_lookup_asn1(const char *name)
-{
-	const struct rsa_asn1_template *p;
-
-	for (p = rsa_asn1_templates; p->name; p++)
-		if (strcmp(name, p->name) == 0)
-			return p;
-	return NULL;
-}
-
-/*
  * RSAEP function [RFC3447 sec 5.1.1]
  * c = m^e mod n;
  */
@@ -143,13 +71,6 @@ static int _rsa_verify(const struct rsa_key *key, MPI m, MPI s)
 	return mpi_powm(m, s, key->e, key->n);
 }
 
-static int rsa_max_size(struct crypto_akcipher *tfm)
-{
-	struct rsa_key *pkey = akcipher_tfm_ctx(tfm);
-
-	return pkey->n ? mpi_get_size(pkey->n) : -EINVAL;
-}
-
 static inline struct rsa_key *rsa_get_key(struct crypto_akcipher *tfm)
 {
 	return akcipher_tfm_ctx(tfm);
@@ -271,122 +192,44 @@ err_free_s:
 	return ret;
 }
 
-static int rsa_verify_raw(struct akcipher_request *req, MPI EM)
+static int rsa_verify(struct akcipher_request *req)
 {
 	struct crypto_akcipher *tfm = crypto_akcipher_reqtfm(req);
 	const struct rsa_key *pkey = rsa_get_key(tfm);
-	MPI s, m_calc;
-	int ret;
+	MPI s, m = mpi_alloc(0);
+	int ret = 0;
+	int sign;
 
-	m_calc = mpi_alloc(0);
-	if (!m_calc)
+	if (!m)
 		return -ENOMEM;
 
+	if (unlikely(!pkey->n || !pkey->e)) {
+		ret = -EINVAL;
+		goto err_free_m;
+	}
+
 	ret = -ENOMEM;
 	s = mpi_read_raw_from_sgl(req->src, req->src_len);
-	if (!s)
-		goto err_free_m_calc;
+	if (!s) {
+		ret = -ENOMEM;
+		goto err_free_m;
+	}
 
-	ret = _rsa_verify(pkey, m_calc, s);
+	ret = _rsa_verify(pkey, m, s);
 	if (ret)
 		goto err_free_s;
 
-	ret = -EKEYREJECTED;
-	if (mpi_cmp(m_calc, EM) != 0)
+	ret = mpi_write_to_sgl(m, req->dst, &req->dst_len, &sign);
+	if (ret)
 		goto err_free_s;
 
-	ret = 0;
+	if (sign < 0)
+		ret = -EBADMSG;
+
 err_free_s:
 	mpi_free(s);
-err_free_m_calc:
-	mpi_free(m_calc);
-	return ret;
-}
-
-/*
- * Turn Hash(M) into EM for a key of size k and a specified hash algorithm as
- * per EMSA-PKCS1-v1_5:
- *
- *	EM = 0x00 || 0x01 || PS || 0x00 || T
- */
-static MPI rsa_emsa_pkcs1_v1_5(struct scatterlist *H, int H_size, int k,
-			       const char *hash_algo)
-{
-	const struct rsa_asn1_template *asn1;
-	MPI EM;
-	int PS_end, T_offset;
-	u8 *buf;
-
-	asn1 = rsa_lookup_asn1(hash_algo);
-	if (!asn1)
-		return ERR_PTR(-ENOPKG);
-
-	if (k < 2 + 1 + asn1->size + H_size)
-		return ERR_PTR(-EMSGSIZE);
-
-	T_offset = k - (asn1->size + H_size);
-	PS_end = T_offset - 1;
-	if (PS_end - 2 < 8)
-		return ERR_PTR(-EMSGSIZE);
-
-	buf = kmalloc(k, GFP_KERNEL);
-	if (!buf)
-		return ERR_PTR(-ENOMEM);
-
-	/* Set the initial zero and block type octets */
-	buf[0] = 0x00;
-	buf[1] = 0x01;
-
-	/* Set the padding string and the divider */
-	memset(buf + 2, 0xff, PS_end - 2);
-	buf[PS_end] = 0x00;
-
-	/* Set the DER-encoded DigestInfo */
-	memcpy(buf + T_offset, asn1->data, asn1->size);
-
-	/* Finally set the  */
-	if (sg_copy_to_buffer(H, sg_nents(H),
-			      buf + T_offset + asn1->size,
-			      H_size) != H_size) {
-		EM = ERR_PTR(-EMSGSIZE);
-		goto error_free_buf;
-	}
-
-	EM = mpi_read_raw_data(buf, k);
-	if (!EM)
-		EM = ERR_PTR(-ENOMEM);
-	
-error_free_buf:
-	kfree(buf);
-	return EM;
-}
-
-static int rsa_verify_encoded(struct akcipher_request *req)
-{
-	struct crypto_akcipher *tfm = crypto_akcipher_reqtfm(req);
-	const struct rsa_key *pkey = rsa_get_key(tfm);
-	MPI EM;
-	int ret, k;
-
-	pr_devel("==>%s(%u,%u,%s)\n",
-		 __func__, req->src_len, req->dst_len, req->hash_algo);
-
-	if (unlikely(!pkey->n || !pkey->e || !req->hash_algo))
-		return -EINVAL;
-
-	/* Find k - the size of E(M). */
-	k = rsa_max_size(tfm);
-	if (k < 0)
-		return k;
-
-	EM = rsa_emsa_pkcs1_v1_5(req->dst, req->dst_len, k, req->hash_algo);
-	if (IS_ERR(EM))
-		return PTR_ERR(EM);
-
-	ret = rsa_verify_raw(req, EM);
-
-	mpi_free(EM);
-	pr_devel("<==%s() = %d\n", __func__, ret);
+err_free_m:
+	mpi_free(m);
 	return ret;
 }
 
@@ -439,6 +282,13 @@ static int rsa_set_priv_key(struct crypto_akcipher *tfm, const void *key,
 	return ret;
 }
 
+static int rsa_max_size(struct crypto_akcipher *tfm)
+{
+	struct rsa_key *pkey = akcipher_tfm_ctx(tfm);
+
+	return pkey->n ? mpi_get_size(pkey->n) : -EINVAL;
+}
+
 static void rsa_exit_tfm(struct crypto_akcipher *tfm)
 {
 	struct rsa_key *pkey = akcipher_tfm_ctx(tfm);
@@ -450,7 +300,7 @@ static struct akcipher_alg rsa = {
 	.encrypt = rsa_enc,
 	.decrypt = rsa_dec,
 	.sign = rsa_sign,
-	.verify = rsa_verify_encoded,
+	.verify = rsa_verify,
 	.set_priv_key = rsa_set_priv_key,
 	.set_pub_key = rsa_set_pub_key,
 	.max_size = rsa_max_size,
diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index 94879a3..ae8c57fd 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -1882,7 +1882,7 @@ static int do_test_rsa(struct crypto_akcipher *tfm,
 	sg_set_buf(&src_tab[1], vecs->m + 8, vecs->m_size - 8);
 	sg_init_one(&dst, outbuf_enc, out_len_max);
 	akcipher_request_set_crypt(req, src_tab, &dst, vecs->m_size,
-				   out_len_max, NULL);
+				   out_len_max);
 	akcipher_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG,
 				      tcrypt_complete, &result);
 
@@ -1916,8 +1916,7 @@ static int do_test_rsa(struct crypto_akcipher *tfm,
 	sg_init_one(&src, vecs->c, vecs->c_size);
 	sg_init_one(&dst, outbuf_dec, out_len_max);
 	init_completion(&result.completion);
-	akcipher_request_set_crypt(req, &src, &dst, vecs->c_size, out_len_max,
-				   NULL);
+	akcipher_request_set_crypt(req, &src, &dst, vecs->c_size, out_len_max);
 
 	/* Run RSA decrypt - m = c^d mod n;*/
 	err = wait_async_op(&result, crypto_akcipher_decrypt(req));
diff --git a/include/crypto/akcipher.h b/include/crypto/akcipher.h
index a59a6a0..354de15 100644
--- a/include/crypto/akcipher.h
+++ b/include/crypto/akcipher.h
@@ -27,7 +27,6 @@
  *		result.
  *		In case of error where the dst sgl size was insufficient,
  *		it will be updated to the size required for the operation.
- * @hash_algo:	The hash algorithm used for sign/verify operations.
  * @__ctx:	Start of private context data
  */
 struct akcipher_request {
@@ -36,7 +35,6 @@ struct akcipher_request {
 	struct scatterlist *dst;
 	unsigned int src_len;
 	unsigned int dst_len;
-	const char *hash_algo;
 	void *__ctx[] CRYPTO_MINALIGN_ATTR;
 };
 
@@ -243,20 +241,17 @@ static inline void akcipher_request_set_callback(struct akcipher_request *req,
  * @dst:	ptr to output scatter list
  * @src_len:	size of the src input scatter list to be processed
  * @dst_len:	size of the dst output scatter list
- * @hash_algo:	The hash algorithm that was used for a signature (or NULL).
  */
 static inline void akcipher_request_set_crypt(struct akcipher_request *req,
 					      struct scatterlist *src,
 					      struct scatterlist *dst,
 					      unsigned int src_len,
-					      unsigned int dst_len,
-					      const char *hash_algo)
+					      unsigned int dst_len)
 {
 	req->src = src;
 	req->dst = dst;
 	req->src_len = src_len;
 	req->dst_len = dst_len;
-	req->hash_algo = hash_algo;
 }
 
 /**
