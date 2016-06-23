From: David Howells <dhowells@redhat.com>
Subject: [PATCH 7/8] KEYS: Implement encrypt,
 decrypt and sign for software asymmetric key [ver #2]
Date: Thu, 23 Jun 2016 14:48:27 +0100
Message-ID: <146668970745.2977.5678776037703132724.stgit@warthog.procyon.org.uk>
References: <146668965425.2977.13357101274301968911.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: dhowells@redhat.com, linux-security-module@vger.kernel.org,
	keyrings@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org
To: mathew.j.martineau@linux.intel.com, dwmw2@infradead.org,
	tadeusz.struk@intel.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44249 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752651AbcFWNsa (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 23 Jun 2016 09:48:30 -0400
In-Reply-To: <146668965425.2977.13357101274301968911.stgit@warthog.procyon.org.uk>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Implement the encrypt, decrypt and sign operations for the software
asymmetric key subtype.  This mostly involves offloading the call to the
crypto layer.

Note that the decrypt and sign operations require a private key to be
supplied.  Encrypt (and also verify) will work with either a public or a
private key.  A public key can be supplied with an X.509 certificate and a
private key can be supplied using a PKCS#8 blob:

	# j=`openssl pkcs8 -in ~/pkcs7/firmwarekey2.priv -topk8 -nocrypt -outform DER | keyctl padd asymmetric foo @s`
	# keyctl pkey_query $j - enc=pkcs1
	key_size=4096
	max_data_size=512
	max_sig_size=512
	max_enc_size=512
	max_dec_size=512
	encrypt=y
	decrypt=y
	sign=y
	verify=y
	# keyctl pkey_encrypt $j 0 data enc=pkcs1 >/tmp/enc
	# keyctl pkey_decrypt $j 0 /tmp/enc enc=pkcs1 >/tmp/dec
	# cmp data /tmp/dec
	# keyctl pkey_sign $j 0 data enc=pkcs1 hash=sha1 >/tmp/sig
	# keyctl pkey_verify $j 0 data /tmp/sig enc=pkcs1 hash=sha1
	#

Signed-off-by: David Howells <dhowells@redhat.com>
---

 crypto/asymmetric_keys/public_key.c |   89 ++++++++++++++++++++++++++++++++++-
 1 file changed, 86 insertions(+), 3 deletions(-)

diff --git a/crypto/asymmetric_keys/public_key.c b/crypto/asymmetric_keys/public_key.c
index a29ca01a41a0..8be2586028b6 100644
--- a/crypto/asymmetric_keys/public_key.c
+++ b/crypto/asymmetric_keys/public_key.c
@@ -128,7 +128,11 @@ static int software_key_query(const struct kernel_pkey_params *params,
 	info->max_sig_size = len;
 	info->max_enc_size = len;
 	info->max_dec_size = len;
-	info->supported_ops = KEYCTL_SUPPORTS_VERIFY;
+	info->supported_ops = (KEYCTL_SUPPORTS_ENCRYPT |
+			       KEYCTL_SUPPORTS_VERIFY);
+	if (pkey->key_is_private)
+		info->supported_ops |= (KEYCTL_SUPPORTS_DECRYPT |
+					KEYCTL_SUPPORTS_SIGN);
 	ret = 0;
 
 error_free_tfm:
@@ -142,7 +146,7 @@ struct public_key_completion {
 	int err;
 };
 
-static void public_key_verify_done(struct crypto_async_request *req, int err)
+static void public_key_crypto_done(struct crypto_async_request *req, int err)
 {
 	struct public_key_completion *compl = req->data;
 
@@ -154,6 +158,84 @@ static void public_key_verify_done(struct crypto_async_request *req, int err)
 }
 
 /*
+ * Do encryption, decryption and signing ops.
+ */
+static int software_key_eds_op(struct kernel_pkey_params *params,
+			       const void *in, void *out)
+{
+	struct public_key_completion compl;
+	const struct public_key *pkey = params->key->payload.data[asym_crypto];
+	struct akcipher_request *req;
+	struct crypto_akcipher *tfm;
+	struct scatterlist in_sg, out_sg;
+	char alg_name[CRYPTO_MAX_ALG_NAME];
+	int ret;
+
+	pr_devel("==>%s()\n", __func__);
+
+	ret = software_key_determine_akcipher(params->encoding,
+					      params->hash_algo,
+					      pkey, alg_name);
+	if (ret < 0)
+		return ret;
+
+	tfm = crypto_alloc_akcipher(alg_name, 0, 0);
+	if (IS_ERR(tfm))
+		return PTR_ERR(tfm);
+
+	req = akcipher_request_alloc(tfm, GFP_KERNEL);
+	if (!req)
+		goto error_free_tfm;
+
+	if (pkey->key_is_private)
+		ret = crypto_akcipher_set_priv_key(tfm,
+						   pkey->key, pkey->keylen);
+	else
+		ret = crypto_akcipher_set_pub_key(tfm,
+						  pkey->key, pkey->keylen);
+	if (ret)
+		goto error_free_req;
+
+	sg_init_one(&in_sg, in, params->in_len);
+	sg_init_one(&out_sg, out, params->out_len);
+	akcipher_request_set_crypt(req, &in_sg, &out_sg, params->in_len,
+				   params->out_len);
+	init_completion(&compl.completion);
+	akcipher_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG |
+				      CRYPTO_TFM_REQ_MAY_SLEEP,
+				      public_key_crypto_done, &compl);
+
+	/* Perform the encryption calculation. */
+	switch (params->op) {
+	case kernel_pkey_encrypt:
+		ret = crypto_akcipher_encrypt(req);
+		break;
+	case kernel_pkey_decrypt:
+		ret = crypto_akcipher_decrypt(req);
+		break;
+	case kernel_pkey_sign:
+		ret = crypto_akcipher_sign(req);
+		break;
+	default:
+		BUG();
+	}
+	if (ret == -EINPROGRESS) {
+		wait_for_completion(&compl.completion);
+		ret = compl.err;
+	}
+
+	if (ret == 0)
+		ret = req->dst_len;
+
+error_free_req:
+	akcipher_request_free(req);
+error_free_tfm:
+	crypto_free_akcipher(tfm);
+	pr_devel("<==%s() = %d\n", __func__, ret);
+	return ret;
+}
+
+/*
  * Verify a signature using a public key.
  */
 int public_key_verify_signature(const struct public_key *pkey,
@@ -210,7 +292,7 @@ int public_key_verify_signature(const struct public_key *pkey,
 	init_completion(&compl.completion);
 	akcipher_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG |
 				      CRYPTO_TFM_REQ_MAY_SLEEP,
-				      public_key_verify_done, &compl);
+				      public_key_crypto_done, &compl);
 
 	/* Perform the verification calculation.  This doesn't actually do the
 	 * verification, but rather calculates the hash expected by the
@@ -257,6 +339,7 @@ struct asymmetric_key_subtype public_key_subtype = {
 	.describe		= public_key_describe,
 	.destroy		= public_key_destroy,
 	.query			= software_key_query,
+	.eds_op			= software_key_eds_op,
 	.verify_signature	= public_key_verify_signature_2,
 };
 EXPORT_SYMBOL_GPL(public_key_subtype);
