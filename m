From: David Howells <dhowells@redhat.com>
Subject: [PATCH 06/10] X.509: Retain the key verification data
Date: Wed, 21 Oct 2015 16:14:12 +0100
Message-ID: <20151021151412.4583.96359.stgit@warthog.procyon.org.uk>
References: <20151021151314.4583.90962.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: dhowells@redhat.com, linux-security-module@vger.kernel.org,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: keyrings@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20151021151314.4583.90962.stgit@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Retain the key verification data (ie. the struct public_key_signature)
including the digest and the key identifiers.

Note that this means that we need to take a separate copy of the digest in
x509_get_sig_params() rather than lumping it in with the crypto layer data.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 crypto/asymmetric_keys/pkcs7_trust.c      |    8 ++-
 crypto/asymmetric_keys/pkcs7_verify.c     |   20 +++++----
 crypto/asymmetric_keys/x509_cert_parser.c |   43 +++++++++---------
 crypto/asymmetric_keys/x509_parser.h      |    4 --
 crypto/asymmetric_keys/x509_public_key.c  |   68 +++++++++++++++--------------
 5 files changed, 72 insertions(+), 71 deletions(-)

diff --git a/crypto/asymmetric_keys/pkcs7_trust.c b/crypto/asymmetric_keys/pkcs7_trust.c
index 388007fed3b2..7bb9389fd644 100644
--- a/crypto/asymmetric_keys/pkcs7_trust.c
+++ b/crypto/asymmetric_keys/pkcs7_trust.c
@@ -77,16 +77,16 @@ static int pkcs7_validate_trust_one(struct pkcs7_message *pkcs7,
 
 		might_sleep();
 		last = x509;
-		sig = &last->sig;
+		sig = last->sig;
 	}
 
 	/* No match - see if the root certificate has a signer amongst the
 	 * trusted keys.
 	 */
-	if (last && (last->akid_id || last->akid_skid)) {
+	if (last && (last->sig->auth_ids[0] || last->sig->auth_ids[1])) {
 		key = x509_request_asymmetric_key(trust_keyring,
-						  last->akid_id,
-						  last->akid_skid,
+						  last->sig->auth_ids[0],
+						  last->sig->auth_ids[1],
 						  false);
 		if (!IS_ERR(key)) {
 			x509 = last;
diff --git a/crypto/asymmetric_keys/pkcs7_verify.c b/crypto/asymmetric_keys/pkcs7_verify.c
index d20c0b4b880e..e225dccdf559 100644
--- a/crypto/asymmetric_keys/pkcs7_verify.c
+++ b/crypto/asymmetric_keys/pkcs7_verify.c
@@ -175,6 +175,7 @@ static int pkcs7_find_key(struct pkcs7_message *pkcs7,
 static int pkcs7_verify_sig_chain(struct pkcs7_message *pkcs7,
 				  struct pkcs7_signed_info *sinfo)
 {
+	struct public_key_signature *sig;
 	struct x509_certificate *x509 = sinfo->signer, *p;
 	struct asymmetric_key_id *auth;
 	int ret;
@@ -194,14 +195,15 @@ static int pkcs7_verify_sig_chain(struct pkcs7_message *pkcs7,
 			goto maybe_missing_crypto_in_x509;
 
 		pr_debug("- issuer %s\n", x509->issuer);
-		if (x509->akid_id)
+		sig = x509->sig;
+		if (sig->auth_ids[0])
 			pr_debug("- authkeyid.id %*phN\n",
-				 x509->akid_id->len, x509->akid_id->data);
-		if (x509->akid_skid)
+				 sig->auth_ids[0]->len, sig->auth_ids[0]->data);
+		if (sig->auth_ids[1])
 			pr_debug("- authkeyid.skid %*phN\n",
-				 x509->akid_skid->len, x509->akid_skid->data);
+				 sig->auth_ids[1]->len, sig->auth_ids[1]->data);
 
-		if ((!x509->akid_id && !x509->akid_skid) ||
+		if ((!x509->sig->auth_ids[0] && !x509->sig->auth_ids[1]) ||
 		    strcmp(x509->subject, x509->issuer) == 0) {
 			/* If there's no authority certificate specified, then
 			 * the certificate must be self-signed and is the root
@@ -225,7 +227,7 @@ static int pkcs7_verify_sig_chain(struct pkcs7_message *pkcs7,
 		/* Look through the X.509 certificates in the PKCS#7 message's
 		 * list to see if the next one is there.
 		 */
-		auth = x509->akid_id;
+		auth = sig->auth_ids[0];
 		if (auth) {
 			pr_debug("- want %*phN\n", auth->len, auth->data);
 			for (p = pkcs7->certs; p; p = p->next) {
@@ -235,7 +237,7 @@ static int pkcs7_verify_sig_chain(struct pkcs7_message *pkcs7,
 					goto found_issuer_check_skid;
 			}
 		} else {
-			auth = x509->akid_skid;
+			auth = sig->auth_ids[1];
 			pr_debug("- want %*phN\n", auth->len, auth->data);
 			for (p = pkcs7->certs; p; p = p->next) {
 				if (!p->skid)
@@ -255,8 +257,8 @@ static int pkcs7_verify_sig_chain(struct pkcs7_message *pkcs7,
 		/* We matched issuer + serialNumber, but if there's an
 		 * authKeyId.keyId, that must match the CA subjKeyId also.
 		 */
-		if (x509->akid_skid &&
-		    !asymmetric_key_id_same(p->skid, x509->akid_skid)) {
+		if (sig->auth_ids[1] &&
+		    !asymmetric_key_id_same(p->skid, sig->auth_ids[1])) {
 			pr_warn("Sig %u: X.509 chain contains auth-skid nonmatch (%u->%u)\n",
 				sinfo->index, x509->index, p->index);
 			return -EKEYREJECTED;
diff --git a/crypto/asymmetric_keys/x509_cert_parser.c b/crypto/asymmetric_keys/x509_cert_parser.c
index 430848445dd9..09706bf112f3 100644
--- a/crypto/asymmetric_keys/x509_cert_parser.c
+++ b/crypto/asymmetric_keys/x509_cert_parser.c
@@ -48,15 +48,11 @@ struct x509_parse_context {
 void x509_free_certificate(struct x509_certificate *cert)
 {
 	if (cert) {
-		public_key_free(cert->pub, NULL);
+		public_key_free(cert->pub, cert->sig);
 		kfree(cert->issuer);
 		kfree(cert->subject);
 		kfree(cert->id);
 		kfree(cert->skid);
-		kfree(cert->akid_id);
-		kfree(cert->akid_skid);
-		kfree(cert->sig.digest);
-		mpi_free(cert->sig.rsa.s);
 		kfree(cert);
 	}
 }
@@ -79,6 +75,9 @@ struct x509_certificate *x509_cert_parse(const void *data, size_t datalen)
 	cert->pub = kzalloc(sizeof(struct public_key), GFP_KERNEL);
 	if (!cert->pub)
 		goto error_no_ctx;
+	cert->sig = kzalloc(sizeof(struct public_key_signature), GFP_KERNEL);
+	if (!cert->sig)
+		goto error_no_ctx;
 	ctx = kzalloc(sizeof(struct x509_parse_context), GFP_KERNEL);
 	if (!ctx)
 		goto error_no_ctx;
@@ -188,33 +187,33 @@ int x509_note_pkey_algo(void *context, size_t hdrlen,
 		return -ENOPKG; /* Unsupported combination */
 
 	case OID_md4WithRSAEncryption:
-		ctx->cert->sig.pkey_hash_algo = HASH_ALGO_MD5;
-		ctx->cert->sig.pkey_algo = PKEY_ALGO_RSA;
+		ctx->cert->sig->pkey_hash_algo = HASH_ALGO_MD5;
+		ctx->cert->sig->pkey_algo = PKEY_ALGO_RSA;
 		break;
 
 	case OID_sha1WithRSAEncryption:
-		ctx->cert->sig.pkey_hash_algo = HASH_ALGO_SHA1;
-		ctx->cert->sig.pkey_algo = PKEY_ALGO_RSA;
+		ctx->cert->sig->pkey_hash_algo = HASH_ALGO_SHA1;
+		ctx->cert->sig->pkey_algo = PKEY_ALGO_RSA;
 		break;
 
 	case OID_sha256WithRSAEncryption:
-		ctx->cert->sig.pkey_hash_algo = HASH_ALGO_SHA256;
-		ctx->cert->sig.pkey_algo = PKEY_ALGO_RSA;
+		ctx->cert->sig->pkey_hash_algo = HASH_ALGO_SHA256;
+		ctx->cert->sig->pkey_algo = PKEY_ALGO_RSA;
 		break;
 
 	case OID_sha384WithRSAEncryption:
-		ctx->cert->sig.pkey_hash_algo = HASH_ALGO_SHA384;
-		ctx->cert->sig.pkey_algo = PKEY_ALGO_RSA;
+		ctx->cert->sig->pkey_hash_algo = HASH_ALGO_SHA384;
+		ctx->cert->sig->pkey_algo = PKEY_ALGO_RSA;
 		break;
 
 	case OID_sha512WithRSAEncryption:
-		ctx->cert->sig.pkey_hash_algo = HASH_ALGO_SHA512;
-		ctx->cert->sig.pkey_algo = PKEY_ALGO_RSA;
+		ctx->cert->sig->pkey_hash_algo = HASH_ALGO_SHA512;
+		ctx->cert->sig->pkey_algo = PKEY_ALGO_RSA;
 		break;
 
 	case OID_sha224WithRSAEncryption:
-		ctx->cert->sig.pkey_hash_algo = HASH_ALGO_SHA224;
-		ctx->cert->sig.pkey_algo = PKEY_ALGO_RSA;
+		ctx->cert->sig->pkey_hash_algo = HASH_ALGO_SHA224;
+		ctx->cert->sig->pkey_algo = PKEY_ALGO_RSA;
 		break;
 	}
 
@@ -550,7 +549,7 @@ int x509_decode_time(time64_t *_t,  size_t hdrlen,
 	    min < 0 || min > 59 ||
 	    sec < 0 || sec > 59)
 		goto invalid_time;
-	
+
 	*_t = mktime64(year, mon, day, hour, min, sec);
 	return 0;
 
@@ -593,14 +592,14 @@ int x509_akid_note_kid(void *context, size_t hdrlen,
 
 	pr_debug("AKID: keyid: %*phN\n", (int)vlen, value);
 
-	if (ctx->cert->akid_skid)
+	if (ctx->cert->sig->auth_ids[1])
 		return 0;
 
 	kid = asymmetric_key_generate_id(value, vlen, "", 0);
 	if (IS_ERR(kid))
 		return PTR_ERR(kid);
 	pr_debug("authkeyid %*phN\n", kid->len, kid->data);
-	ctx->cert->akid_skid = kid;
+	ctx->cert->sig->auth_ids[1] = kid;
 	return 0;
 }
 
@@ -632,7 +631,7 @@ int x509_akid_note_serial(void *context, size_t hdrlen,
 
 	pr_debug("AKID: serial: %*phN\n", (int)vlen, value);
 
-	if (!ctx->akid_raw_issuer || ctx->cert->akid_id)
+	if (!ctx->akid_raw_issuer || ctx->cert->sig->auth_ids[0])
 		return 0;
 
 	kid = asymmetric_key_generate_id(value,
@@ -643,6 +642,6 @@ int x509_akid_note_serial(void *context, size_t hdrlen,
 		return PTR_ERR(kid);
 
 	pr_debug("authkeyid %*phN\n", kid->len, kid->data);
-	ctx->cert->akid_id = kid;
+	ctx->cert->sig->auth_ids[0] = kid;
 	return 0;
 }
diff --git a/crypto/asymmetric_keys/x509_parser.h b/crypto/asymmetric_keys/x509_parser.h
index 36b7c47335b5..63ff787c74b3 100644
--- a/crypto/asymmetric_keys/x509_parser.h
+++ b/crypto/asymmetric_keys/x509_parser.h
@@ -17,13 +17,11 @@ struct x509_certificate {
 	struct x509_certificate *next;
 	struct x509_certificate *signer;	/* Certificate that signed this one */
 	struct public_key *pub;			/* Public key details */
-	struct public_key_signature sig;	/* Signature parameters */
+	struct public_key_signature *sig;	/* Signature parameters */
 	char		*issuer;		/* Name of certificate issuer */
 	char		*subject;		/* Name of certificate subject */
 	struct asymmetric_key_id *id;		/* Issuer + Serial number */
 	struct asymmetric_key_id *skid;		/* Subject + subjectKeyId (optional) */
-	struct asymmetric_key_id *akid_id;	/* CA AuthKeyId matching ->id (optional) */
-	struct asymmetric_key_id *akid_skid;	/* CA AuthKeyId matching ->skid (optional) */
 	time64_t	valid_from;
 	time64_t	valid_to;
 	const void	*tbs;			/* Signed data */
diff --git a/crypto/asymmetric_keys/x509_public_key.c b/crypto/asymmetric_keys/x509_public_key.c
index 76c211b31da7..6b3711fa71d1 100644
--- a/crypto/asymmetric_keys/x509_public_key.c
+++ b/crypto/asymmetric_keys/x509_public_key.c
@@ -92,7 +92,7 @@ struct key *x509_request_asymmetric_key(struct key *keyring,
 		lookup = skid->data;
 		len = skid->len;
 	}
-	
+
 	/* Construct an identifier "id:<keyid>". */
 	p = req = kmalloc(2 + 1 + len * 2 + 1, GFP_KERNEL);
 	if (!req)
@@ -141,7 +141,7 @@ struct key *x509_request_asymmetric_key(struct key *keyring,
 			goto reject;
 		}
 	}
-	
+
 	pr_devel("<==%s() = 0 [%x]\n", __func__, key_serial(key));
 	return key;
 
@@ -157,28 +157,28 @@ EXPORT_SYMBOL_GPL(x509_request_asymmetric_key);
  */
 int x509_get_sig_params(struct x509_certificate *cert)
 {
+	struct public_key_signature *sig = cert->sig;
 	struct crypto_shash *tfm;
 	struct shash_desc *desc;
-	size_t digest_size, desc_size;
-	void *digest;
+	size_t desc_size;
 	int ret;
 
 	pr_devel("==>%s()\n", __func__);
 
 	if (cert->unsupported_crypto)
 		return -ENOPKG;
-	if (cert->sig.rsa.s)
+	if (sig->rsa.s)
 		return 0;
 
-	cert->sig.rsa.s = mpi_read_raw_data(cert->raw_sig, cert->raw_sig_size);
-	if (!cert->sig.rsa.s)
+	sig->rsa.s = mpi_read_raw_data(cert->raw_sig, cert->raw_sig_size);
+	if (!sig->rsa.s)
 		return -ENOMEM;
-	cert->sig.nr_mpi = 1;
+	sig->nr_mpi = 1;
 
 	/* Allocate the hashing algorithm we're going to need and find out how
 	 * big the hash operational data will be.
 	 */
-	tfm = crypto_alloc_shash(hash_algo_name[cert->sig.pkey_hash_algo], 0, 0);
+	tfm = crypto_alloc_shash(hash_algo_name[sig->pkey_hash_algo], 0, 0);
 	if (IS_ERR(tfm)) {
 		if (PTR_ERR(tfm) == -ENOENT) {
 			cert->unsupported_crypto = true;
@@ -188,30 +188,29 @@ int x509_get_sig_params(struct x509_certificate *cert)
 	}
 
 	desc_size = crypto_shash_descsize(tfm) + sizeof(*desc);
-	digest_size = crypto_shash_digestsize(tfm);
+	sig->digest_size = crypto_shash_digestsize(tfm);
 
-	/* We allocate the hash operational data storage on the end of the
-	 * digest storage space.
-	 */
 	ret = -ENOMEM;
-	digest = kzalloc(digest_size + desc_size, GFP_KERNEL);
-	if (!digest)
+	sig->digest = kmalloc(sig->digest_size, GFP_KERNEL);
+	if (!sig->digest)
 		goto error;
 
-	cert->sig.digest = digest;
-	cert->sig.digest_size = digest_size;
+	desc = kzalloc(desc_size, GFP_KERNEL);
+	if (!desc)
+		goto error;
 
-	desc = digest + digest_size;
 	desc->tfm = tfm;
 	desc->flags = CRYPTO_TFM_REQ_MAY_SLEEP;
 
 	ret = crypto_shash_init(desc);
 	if (ret < 0)
-		goto error;
+		goto error_2;
 	might_sleep();
-	ret = crypto_shash_finup(desc, cert->tbs, cert->tbs_size, digest);
-error:
+	ret = crypto_shash_finup(desc, cert->tbs, cert->tbs_size, sig->digest);
 	crypto_free_shash(tfm);
+error_2:
+	kfree(desc);
+error:
 	pr_devel("<==%s() = %d\n", __func__, ret);
 	return ret;
 }
@@ -231,7 +230,7 @@ int x509_check_signature(const struct public_key *pub,
 	if (ret < 0)
 		return ret;
 
-	ret = public_key_verify_signature(pub, &cert->sig);
+	ret = public_key_verify_signature(pub, cert->sig);
 	if (ret == -ENOPKG)
 		cert->unsupported_crypto = true;
 	pr_debug("Cert Verification: %d\n", ret);
@@ -251,17 +250,18 @@ EXPORT_SYMBOL_GPL(x509_check_signature);
 static int x509_validate_trust(struct x509_certificate *cert,
 			       struct key *trust_keyring)
 {
+	struct public_key_signature *sig = cert->sig;
 	struct key *key;
 	int ret = 1;
 
 	if (!trust_keyring)
 		return -EOPNOTSUPP;
 
-	if (ca_keyid && !asymmetric_key_id_partial(cert->akid_skid, ca_keyid))
+	if (ca_keyid && !asymmetric_key_id_partial(sig->auth_ids[1], ca_keyid))
 		return -EPERM;
 
 	key = x509_request_asymmetric_key(trust_keyring,
-					  cert->akid_id, cert->akid_skid,
+					  sig->auth_ids[0], sig->auth_ids[1],
 					  false);
 	if (!IS_ERR(key))  {
 		if (!use_builtin_keys
@@ -293,11 +293,11 @@ static int x509_key_preparse(struct key_preparsed_payload *prep)
 	pr_devel("Cert Subject: %s\n", cert->subject);
 
 	if (cert->pub->pkey_algo >= PKEY_ALGO__LAST ||
-	    cert->sig.pkey_algo >= PKEY_ALGO__LAST ||
-	    cert->sig.pkey_hash_algo >= PKEY_HASH__LAST ||
+	    cert->sig->pkey_algo >= PKEY_ALGO__LAST ||
+	    cert->sig->pkey_hash_algo >= PKEY_HASH__LAST ||
 	    !pkey_algo[cert->pub->pkey_algo] ||
-	    !pkey_algo[cert->sig.pkey_algo] ||
-	    !hash_algo_name[cert->sig.pkey_hash_algo]) {
+	    !pkey_algo[cert->sig->pkey_algo] ||
+	    !hash_algo_name[cert->sig->pkey_hash_algo]) {
 		ret = -ENOPKG;
 		goto error_free_cert;
 	}
@@ -305,16 +305,16 @@ static int x509_key_preparse(struct key_preparsed_payload *prep)
 	pr_devel("Cert Key Algo: %s\n", pkey_algo_name[cert->pub->pkey_algo]);
 	pr_devel("Cert Valid period: %lld-%lld\n", cert->valid_from, cert->valid_to);
 	pr_devel("Cert Signature: %s + %s\n",
-		 pkey_algo_name[cert->sig.pkey_algo],
-		 hash_algo_name[cert->sig.pkey_hash_algo]);
+		 pkey_algo_name[cert->sig->pkey_algo],
+		 hash_algo_name[cert->sig->pkey_hash_algo]);
 
 	cert->pub->algo = pkey_algo[cert->pub->pkey_algo];
 	cert->pub->id_type = PKEY_ID_X509;
 
 	/* Check the signature on the key if it appears to be self-signed */
-	if ((!cert->akid_skid && !cert->akid_id) ||
-	    asymmetric_key_id_same(cert->skid, cert->akid_skid) ||
-	    asymmetric_key_id_same(cert->id, cert->akid_id)) {
+	if ((!cert->sig->auth_ids[0] && !cert->sig->auth_ids[1]) ||
+	    asymmetric_key_id_same(cert->skid, cert->sig->auth_ids[1]) ||
+	    asymmetric_key_id_same(cert->id, cert->sig->auth_ids[0])) {
 		ret = x509_check_signature(cert->pub, cert); /* self-signed */
 		if (ret < 0)
 			goto error_free_cert;
@@ -356,6 +356,7 @@ static int x509_key_preparse(struct key_preparsed_payload *prep)
 	prep->payload.data[asym_subtype] = &public_key_subtype;
 	prep->payload.data[asym_key_ids] = kids;
 	prep->payload.data[asym_crypto] = cert->pub;
+	prep->payload.data[asym_auth] = cert->sig;
 	prep->description = desc;
 	prep->quotalen = 100;
 
@@ -363,6 +364,7 @@ static int x509_key_preparse(struct key_preparsed_payload *prep)
 	cert->pub = NULL;
 	cert->id = NULL;
 	cert->skid = NULL;
+	cert->sig = NULL;
 	desc = NULL;
 	ret = 0;
 
