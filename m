From: David Howells <dhowells@redhat.com>
Subject: [PATCH 5/8] KEYS: Provide software public key query function [ver
 #2]
Date: Thu, 23 Jun 2016 14:48:12 +0100
Message-ID: <146668969255.2977.2158699976750892093.stgit@warthog.procyon.org.uk>
References: <146668965425.2977.13357101274301968911.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: dhowells@redhat.com, linux-security-module@vger.kernel.org,
	keyrings@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org
To: mathew.j.martineau@linux.intel.com, dwmw2@infradead.org,
	tadeusz.struk@intel.com
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <146668965425.2977.13357101274301968911.stgit@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Provide a query function for the software public key implementation.  This
permits information about such a key to be obtained using
query_asymmetric_key() or KEYCTL_PKEY_QUERY.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 crypto/asymmetric_keys/public_key.c |   96 ++++++++++++++++++++++++++++++-----
 1 file changed, 82 insertions(+), 14 deletions(-)

diff --git a/crypto/asymmetric_keys/public_key.c b/crypto/asymmetric_keys/public_key.c
index fd76b5fc3b3a..a48a47a1dff0 100644
--- a/crypto/asymmetric_keys/public_key.c
+++ b/crypto/asymmetric_keys/public_key.c
@@ -57,6 +57,81 @@ static void public_key_destroy(void *payload0, void *payload3)
 	public_key_signature_free(payload3);
 }
 
+/*
+ * Determine the crypto algorithm name.
+ */
+static
+int software_key_determine_akcipher(const char *encoding,
+				    const char *hash_algo,
+				    const struct public_key *pkey,
+				    char alg_name[CRYPTO_MAX_ALG_NAME])
+{
+	int n;
+
+	if (strcmp(encoding, "pkcs1") == 0) {
+		/* The data wangled by the RSA algorithm is typically padded
+		 * and encoded in some manner, such as EMSA-PKCS1-1_5 [RFC3447
+		 * sec 8.2].
+		 */
+		if (!hash_algo)
+			n = snprintf(alg_name, CRYPTO_MAX_ALG_NAME,
+				     "pkcs1pad(%s)",
+				     pkey->pkey_algo);
+		else
+			n = snprintf(alg_name, CRYPTO_MAX_ALG_NAME,
+				     "pkcs1pad(%s,%s)",
+				     pkey->pkey_algo, hash_algo);
+		return n >= CRYPTO_MAX_ALG_NAME ? -EINVAL : 0;
+	}
+
+	if (strcmp(encoding, "raw") == 0) {
+		strcpy(alg_name, pkey->pkey_algo);
+		return 0;
+	}
+
+	return -ENOPKG;
+}
+
+/*
+ * Query information about a key.
+ */
+static int software_key_query(const struct kernel_pkey_params *params,
+			      struct kernel_pkey_query *info)
+{
+	struct crypto_akcipher *tfm;
+	struct public_key *pkey = params->key->payload.data[asym_crypto];
+	char alg_name[CRYPTO_MAX_ALG_NAME];
+	int ret, len;
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
+	ret = crypto_akcipher_set_pub_key(tfm, pkey->key, pkey->keylen);
+	if (ret < 0)
+		goto error_free_tfm;
+
+	len = crypto_akcipher_maxsize(tfm);
+	info->key_size = len * 8;
+	info->max_data_size = len;
+	info->max_sig_size = len;
+	info->max_enc_size = len;
+	info->max_dec_size = len;
+	info->supported_ops = KEYCTL_SUPPORTS_VERIFY;
+	ret = 0;
+
+error_free_tfm:
+	crypto_free_akcipher(tfm);
+	pr_devel("<==%s() = %d\n", __func__, ret);
+	return ret;
+}
+
 struct public_key_completion {
 	struct completion completion;
 	int err;
@@ -83,8 +158,7 @@ int public_key_verify_signature(const struct public_key *pkey,
 	struct crypto_akcipher *tfm;
 	struct akcipher_request *req;
 	struct scatterlist sig_sg, digest_sg;
-	const char *alg_name;
-	char alg_name_buf[CRYPTO_MAX_ALG_NAME];
+	char alg_name[CRYPTO_MAX_ALG_NAME];
 	void *output;
 	unsigned int outlen;
 	int ret = -ENOMEM;
@@ -96,18 +170,11 @@ int public_key_verify_signature(const struct public_key *pkey,
 	BUG_ON(!sig->digest);
 	BUG_ON(!sig->s);
 
-	alg_name = sig->pkey_algo;
-	if (strcmp(sig->pkey_algo, "rsa") == 0) {
-		/* The data wangled by the RSA algorithm is typically padded
-		 * and encoded in some manner, such as EMSA-PKCS1-1_5 [RFC3447
-		 * sec 8.2].
-		 */
-		if (snprintf(alg_name_buf, CRYPTO_MAX_ALG_NAME,
-			     "pkcs1pad(rsa,%s)", sig->hash_algo
-			     ) >= CRYPTO_MAX_ALG_NAME)
-			return -EINVAL;
-		alg_name = alg_name_buf;
-	}
+	ret = software_key_determine_akcipher(sig->encoding,
+					      sig->hash_algo,
+					      pkey, alg_name);
+	if (ret < 0)
+		return ret;
 
 	tfm = crypto_alloc_akcipher(alg_name, 0, 0);
 	if (IS_ERR(tfm))
@@ -179,6 +246,7 @@ struct asymmetric_key_subtype public_key_subtype = {
 	.name_len		= sizeof("public_key") - 1,
 	.describe		= public_key_describe,
 	.destroy		= public_key_destroy,
+	.query			= software_key_query,
 	.verify_signature	= public_key_verify_signature_2,
 };
 EXPORT_SYMBOL_GPL(public_key_subtype);
