From: David Howells <dhowells@redhat.com>
Subject: [PATCH 07/10] X.509: Extract signature digest and make self-signed
 cert checks earlier
Date: Wed, 21 Oct 2015 16:14:21 +0100
Message-ID: <20151021151421.4583.25712.stgit@warthog.procyon.org.uk>
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

Extract the signature digest for an X.509 certificate earlier, at the end
of x509_cert_parse() rather than leaving it to the callers thereof.

Further, immediately after that, check the signature on self-signed
certificates, also rather in the callers of x509_cert_parse().

This we need to determine whether or not the X.509 cert requires crypto
that we don't support before we do the above two steps.

We note in the x509_certificate struct the following bits of information:

 (1) Whether the signature is self-signed (even if we can't check the
     signature due to missing crypto).

 (2) Whether the key held in the certificate needs unsupported crypto to be
     used.  We may get a PKCS#7 message with X.509 certs that we can't make
     use of - we just ignore them and give ENOPKG at the end it we couldn't
     verify anything if at least one of these unusable certs are in the
     chain of trust.

 (3) Whether the signature held in the certificate needs unsupported crypto
     to be checked.  We can still use the key held in this certificate,
     even if we can't check the signature on it - if it is held in the
     system trusted keyring, for instance.  We just can't add it to a ring
     of trusted keys or follow it further up the chain of trust.

Making these checks earlier allows x509_check_signature() to be removed and
replaced with direct calls to public_key_verify_signature().

Signed-off-by: David Howells <dhowells@redhat.com>
---

 crypto/asymmetric_keys/pkcs7_verify.c     |   38 ++------
 crypto/asymmetric_keys/x509_cert_parser.c |   10 ++
 crypto/asymmetric_keys/x509_parser.h      |    7 +
 crypto/asymmetric_keys/x509_public_key.c  |  139 ++++++++++++++++++++---------
 4 files changed, 121 insertions(+), 73 deletions(-)

diff --git a/crypto/asymmetric_keys/pkcs7_verify.c b/crypto/asymmetric_keys/pkcs7_verify.c
index e225dccdf559..1dede0199673 100644
--- a/crypto/asymmetric_keys/pkcs7_verify.c
+++ b/crypto/asymmetric_keys/pkcs7_verify.c
@@ -190,9 +190,8 @@ static int pkcs7_verify_sig_chain(struct pkcs7_message *pkcs7,
 			 x509->subject,
 			 x509->raw_serial_size, x509->raw_serial);
 		x509->seen = true;
-		ret = x509_get_sig_params(x509);
-		if (ret < 0)
-			goto maybe_missing_crypto_in_x509;
+		if (x509->unsupported_key)
+			goto unsupported_crypto_in_x509;
 
 		pr_debug("- issuer %s\n", x509->issuer);
 		sig = x509->sig;
@@ -203,22 +202,14 @@ static int pkcs7_verify_sig_chain(struct pkcs7_message *pkcs7,
 			pr_debug("- authkeyid.skid %*phN\n",
 				 sig->auth_ids[1]->len, sig->auth_ids[1]->data);
 
-		if ((!x509->sig->auth_ids[0] && !x509->sig->auth_ids[1]) ||
-		    strcmp(x509->subject, x509->issuer) == 0) {
+		if (x509->self_signed) {
 			/* If there's no authority certificate specified, then
 			 * the certificate must be self-signed and is the root
 			 * of the chain.  Likewise if the cert is its own
 			 * authority.
 			 */
-			pr_debug("- no auth?\n");
-			if (x509->raw_subject_size != x509->raw_issuer_size ||
-			    memcmp(x509->raw_subject, x509->raw_issuer,
-				   x509->raw_issuer_size) != 0)
-				return 0;
-
-			ret = x509_check_signature(x509->pub, x509);
-			if (ret < 0)
-				goto maybe_missing_crypto_in_x509;
+			if (x509->unsupported_sig)
+				goto unsupported_crypto_in_x509;
 			x509->signer = x509;
 			pr_debug("- self-signed\n");
 			return 0;
@@ -270,7 +261,7 @@ static int pkcs7_verify_sig_chain(struct pkcs7_message *pkcs7,
 				sinfo->index);
 			return 0;
 		}
-		ret = x509_check_signature(p->pub, x509);
+		ret = public_key_verify_signature(p->pub, p->sig);
 		if (ret < 0)
 			return ret;
 		x509->signer = p;
@@ -282,16 +273,14 @@ static int pkcs7_verify_sig_chain(struct pkcs7_message *pkcs7,
 		might_sleep();
 	}
 
-maybe_missing_crypto_in_x509:
+unsupported_crypto_in_x509:
 	/* Just prune the certificate chain at this point if we lack some
 	 * crypto module to go further.  Note, however, we don't want to set
-	 * sinfo->missing_crypto as the signed info block may still be
+	 * sinfo->unsupported_crypto as the signed info block may still be
 	 * validatable against an X.509 cert lower in the chain that we have a
 	 * trusted copy of.
 	 */
-	if (ret == -ENOPKG)
-		return 0;
-	return ret;
+	return 0;
 }
 
 /*
@@ -378,9 +367,8 @@ int pkcs7_verify(struct pkcs7_message *pkcs7,
 		 enum key_being_used_for usage)
 {
 	struct pkcs7_signed_info *sinfo;
-	struct x509_certificate *x509;
 	int enopkg = -ENOPKG;
-	int ret, n;
+	int ret;
 
 	kenter("");
 
@@ -422,12 +410,6 @@ int pkcs7_verify(struct pkcs7_message *pkcs7,
 		return -EINVAL;
 	}
 
-	for (n = 0, x509 = pkcs7->certs; x509; x509 = x509->next, n++) {
-		ret = x509_get_sig_params(x509);
-		if (ret < 0)
-			return ret;
-	}
-
 	for (sinfo = pkcs7->signed_infos; sinfo; sinfo = sinfo->next) {
 		ret = pkcs7_verify_one(pkcs7, sinfo);
 		if (ret < 0) {
diff --git a/crypto/asymmetric_keys/x509_cert_parser.c b/crypto/asymmetric_keys/x509_cert_parser.c
index 09706bf112f3..f8cb4b01932a 100644
--- a/crypto/asymmetric_keys/x509_cert_parser.c
+++ b/crypto/asymmetric_keys/x509_cert_parser.c
@@ -108,6 +108,11 @@ struct x509_certificate *x509_cert_parse(const void *data, size_t datalen)
 	if (ret < 0)
 		goto error_decode;
 
+	/* Grab the signature bits */
+	ret = x509_get_sig_params(cert);
+	if (ret < 0)
+		goto error_decode;
+
 	/* Generate cert issuer + serial number key ID */
 	kid = asymmetric_key_generate_id(cert->raw_serial,
 					 cert->raw_serial_size,
@@ -119,6 +124,11 @@ struct x509_certificate *x509_cert_parse(const void *data, size_t datalen)
 	}
 	cert->id = kid;
 
+	/* Detect self-signed certificates */
+	ret = x509_check_for_self_signed(cert);
+	if (ret < 0)
+		goto error_decode;
+
 	kfree(ctx);
 	return cert;
 
diff --git a/crypto/asymmetric_keys/x509_parser.h b/crypto/asymmetric_keys/x509_parser.h
index 63ff787c74b3..05eef1c68881 100644
--- a/crypto/asymmetric_keys/x509_parser.h
+++ b/crypto/asymmetric_keys/x509_parser.h
@@ -39,7 +39,9 @@ struct x509_certificate {
 	unsigned	index;
 	bool		seen;			/* Infinite recursion prevention */
 	bool		verified;
-	bool		unsupported_crypto;	/* T if can't be verified due to missing crypto */
+	bool		self_signed;		/* T if self-signed (check unsupported_sig too) */
+	bool		unsupported_key;	/* T if key uses unsupported crypto */
+	bool		unsupported_sig;	/* T if signature uses unsupported crypto */
 };
 
 /*
@@ -55,5 +57,4 @@ extern int x509_decode_time(time64_t *_t,  size_t hdrlen,
  * x509_public_key.c
  */
 extern int x509_get_sig_params(struct x509_certificate *cert);
-extern int x509_check_signature(const struct public_key *pub,
-				struct x509_certificate *cert);
+extern int x509_check_for_self_signed(struct x509_certificate *cert);
diff --git a/crypto/asymmetric_keys/x509_public_key.c b/crypto/asymmetric_keys/x509_public_key.c
index 6b3711fa71d1..2b9e754e3ab9 100644
--- a/crypto/asymmetric_keys/x509_public_key.c
+++ b/crypto/asymmetric_keys/x509_public_key.c
@@ -165,10 +165,20 @@ int x509_get_sig_params(struct x509_certificate *cert)
 
 	pr_devel("==>%s()\n", __func__);
 
-	if (cert->unsupported_crypto)
-		return -ENOPKG;
-	if (sig->rsa.s)
+	if (cert->pub->pkey_algo >= PKEY_ALGO__LAST ||
+	    !pkey_algo[cert->pub->pkey_algo])
+		cert->unsupported_key = true;
+
+	if (sig->pkey_algo >= PKEY_ALGO__LAST ||
+	    !pkey_algo[sig->pkey_algo])
+		cert->unsupported_sig = true;
+
+	/* We check the hash if we can - even if we can't then verify it */
+	if (sig->pkey_hash_algo >= PKEY_HASH__LAST ||
+	    !hash_algo_name[sig->pkey_hash_algo]) {
+		cert->unsupported_sig = true;
 		return 0;
+	}
 
 	sig->rsa.s = mpi_read_raw_data(cert->raw_sig, cert->raw_sig_size);
 	if (!sig->rsa.s)
@@ -181,8 +191,8 @@ int x509_get_sig_params(struct x509_certificate *cert)
 	tfm = crypto_alloc_shash(hash_algo_name[sig->pkey_hash_algo], 0, 0);
 	if (IS_ERR(tfm)) {
 		if (PTR_ERR(tfm) == -ENOENT) {
-			cert->unsupported_crypto = true;
-			return -ENOPKG;
+			cert->unsupported_sig = true;
+			return 0;
 		}
 		return PTR_ERR(tfm);
 	}
@@ -217,26 +227,60 @@ error:
 EXPORT_SYMBOL_GPL(x509_get_sig_params);
 
 /*
- * Check the signature on a certificate using the provided public key
+ * Check for self-signedness in an X.509 cert and if found, check the signature
+ * immediately if we can.
  */
-int x509_check_signature(const struct public_key *pub,
-			 struct x509_certificate *cert)
+int x509_check_for_self_signed(struct x509_certificate *cert)
 {
-	int ret;
+	int ret = 0;
 
 	pr_devel("==>%s()\n", __func__);
 
-	ret = x509_get_sig_params(cert);
-	if (ret < 0)
-		return ret;
+	if (cert->raw_subject_size != cert->raw_issuer_size ||
+	    memcmp(cert->raw_subject, cert->raw_issuer,
+		   cert->raw_issuer_size) != 0)
+		goto not_self_signed;
+
+	if (cert->sig->auth_ids[0] || cert->sig->auth_ids[1]) {
+		/* If the AKID is present it may have one or two parts.  If
+		 * both are supplied, both must match.
+		 */
+		bool a = asymmetric_key_id_same(cert->skid, cert->sig->auth_ids[1]);
+		bool b = asymmetric_key_id_same(cert->id, cert->sig->auth_ids[0]);
+
+		if (!a && !b)
+			goto not_self_signed;
+
+		ret = -EKEYREJECTED;
+		if (((a && !b) || (b && !a)) &&
+		    cert->sig->auth_ids[0] && cert->sig->auth_ids[1])
+			goto out;
+	}
+
+	ret = -EKEYREJECTED;
+	if (cert->pub->pkey_algo != cert->sig->pkey_algo)
+		goto out;
 
-	ret = public_key_verify_signature(pub, cert->sig);
-	if (ret == -ENOPKG)
-		cert->unsupported_crypto = true;
-	pr_debug("Cert Verification: %d\n", ret);
+	ret = public_key_verify_signature(cert->pub, cert->sig);
+	if (ret < 0) {
+		if (ret == -ENOPKG) {
+			cert->unsupported_sig = true;
+			ret = 0;
+		}
+		goto out;
+	}
+
+	pr_devel("Cert Self-signature verified");
+	cert->self_signed = true;
+
+out:
+	pr_devel("<==%s() = %d\n", __func__, ret);
 	return ret;
+
+not_self_signed:
+	pr_devel("<==%s() = 0 [not]\n", __func__);
+	return 0;
 }
-EXPORT_SYMBOL_GPL(x509_check_signature);
 
 /*
  * Check the new certificate against the ones in the trust keyring.  If one of
@@ -256,20 +300,25 @@ static int x509_validate_trust(struct x509_certificate *cert,
 
 	if (!trust_keyring)
 		return -EOPNOTSUPP;
-
 	if (ca_keyid && !asymmetric_key_id_partial(sig->auth_ids[1], ca_keyid))
 		return -EPERM;
+	if (cert->unsupported_sig)
+		return -ENOPKG;
 
 	key = x509_request_asymmetric_key(trust_keyring,
 					  sig->auth_ids[0], sig->auth_ids[1],
 					  false);
-	if (!IS_ERR(key))  {
-		if (!use_builtin_keys
-		    || test_bit(KEY_FLAG_BUILTIN, &key->flags))
-			ret = x509_check_signature(key->payload.data[asym_crypto],
-						   cert);
-		key_put(key);
+	if (IS_ERR(key))
+		return PTR_ERR(key);
+
+	if (!use_builtin_keys ||
+	    test_bit(KEY_FLAG_BUILTIN, &key->flags)) {
+		ret = public_key_verify_signature(
+			key->payload.data[asym_crypto], cert->sig);
+		if (ret == -ENOPKG)
+			cert->unsupported_sig = true;
 	}
+	key_put(key);
 	return ret;
 }
 
@@ -292,36 +341,42 @@ static int x509_key_preparse(struct key_preparsed_payload *prep)
 	pr_devel("Cert Issuer: %s\n", cert->issuer);
 	pr_devel("Cert Subject: %s\n", cert->subject);
 
-	if (cert->pub->pkey_algo >= PKEY_ALGO__LAST ||
-	    cert->sig->pkey_algo >= PKEY_ALGO__LAST ||
-	    cert->sig->pkey_hash_algo >= PKEY_HASH__LAST ||
-	    !pkey_algo[cert->pub->pkey_algo] ||
-	    !pkey_algo[cert->sig->pkey_algo] ||
-	    !hash_algo_name[cert->sig->pkey_hash_algo]) {
+	if (cert->unsupported_key) {
 		ret = -ENOPKG;
 		goto error_free_cert;
 	}
 
 	pr_devel("Cert Key Algo: %s\n", pkey_algo_name[cert->pub->pkey_algo]);
 	pr_devel("Cert Valid period: %lld-%lld\n", cert->valid_from, cert->valid_to);
-	pr_devel("Cert Signature: %s + %s\n",
-		 pkey_algo_name[cert->sig->pkey_algo],
-		 hash_algo_name[cert->sig->pkey_hash_algo]);
 
 	cert->pub->algo = pkey_algo[cert->pub->pkey_algo];
 	cert->pub->id_type = PKEY_ID_X509;
 
 	/* Check the signature on the key if it appears to be self-signed */
-	if ((!cert->sig->auth_ids[0] && !cert->sig->auth_ids[1]) ||
-	    asymmetric_key_id_same(cert->skid, cert->sig->auth_ids[1]) ||
-	    asymmetric_key_id_same(cert->id, cert->sig->auth_ids[0])) {
-		ret = x509_check_signature(cert->pub, cert); /* self-signed */
-		if (ret < 0)
-			goto error_free_cert;
+	if (cert->unsupported_sig) {
+		public_key_free(NULL, cert->sig);
+		cert->sig = NULL;
 	} else {
-		ret = x509_validate_trust(cert, get_system_trusted_keyring());
-		if (ret == -EKEYREJECTED)
-			goto error_free_cert;
+		pr_devel("Cert Signature: %s + %s\n",
+			 pkey_algo_name[cert->sig->pkey_algo],
+			 hash_algo_name[cert->sig->pkey_hash_algo]);
+
+		if (cert->self_signed) {
+			/* Self-signed */
+			if (cert->unsupported_sig) {
+				ret = -ENOPKG;
+				goto error_free_cert;
+			}
+
+			/* There's no point retaining the signature */
+			public_key_free(NULL, cert->sig);
+			cert->sig = NULL;
+		} else {
+			ret = x509_validate_trust(cert,
+						  get_system_trusted_keyring());
+			if (ret == -EKEYREJECTED)
+				goto error_free_cert;
+		}
 	}
 
 	/* Propose a description */
