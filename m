From: David Howells <dhowells@redhat.com>
Subject: [PATCH 08/10] PKCS#7: Make the signature a pointer rather than
 embedding it
Date: Wed, 21 Oct 2015 16:14:31 +0100
Message-ID: <20151021151431.4583.71498.stgit@warthog.procyon.org.uk>
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

Point to the public_key_signature struct from the pkcs7_signed_info struct
rather than embedding it.  This makes it easier to have it take an
arbitrary number of MPIs in future.

We also save a copy of the digest in the signature without sharing the
memory with the crypto layer metadata.  This means we can use
public_key_free() to get rid of the signature record.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 crypto/asymmetric_keys/pkcs7_parser.c |   38 +++++++++++++++---------
 crypto/asymmetric_keys/pkcs7_parser.h |   10 +++---
 crypto/asymmetric_keys/pkcs7_trust.c  |    4 +--
 crypto/asymmetric_keys/pkcs7_verify.c |   52 +++++++++++++++++----------------
 4 files changed, 56 insertions(+), 48 deletions(-)

diff --git a/crypto/asymmetric_keys/pkcs7_parser.c b/crypto/asymmetric_keys/pkcs7_parser.c
index 7b69783cff99..8454ae5b5aa8 100644
--- a/crypto/asymmetric_keys/pkcs7_parser.c
+++ b/crypto/asymmetric_keys/pkcs7_parser.c
@@ -44,9 +44,7 @@ struct pkcs7_parse_context {
 static void pkcs7_free_signed_info(struct pkcs7_signed_info *sinfo)
 {
 	if (sinfo) {
-		mpi_free(sinfo->sig.mpi[0]);
-		kfree(sinfo->sig.digest);
-		kfree(sinfo->signing_cert_id);
+		public_key_free(NULL, sinfo->sig);
 		kfree(sinfo);
 	}
 }
@@ -125,6 +123,10 @@ struct pkcs7_message *pkcs7_parse_message(const void *data, size_t datalen)
 	ctx->sinfo = kzalloc(sizeof(struct pkcs7_signed_info), GFP_KERNEL);
 	if (!ctx->sinfo)
 		goto out_no_sinfo;
+	ctx->sinfo->sig = kzalloc(sizeof(struct public_key_signature),
+				  GFP_KERNEL);
+	if (!ctx->sinfo->sig)
+		goto out_no_sig;
 
 	ctx->data = (unsigned long)data;
 	ctx->ppcerts = &ctx->certs;
@@ -150,6 +152,7 @@ out:
 		ctx->certs = cert->next;
 		x509_free_certificate(cert);
 	}
+out_no_sig:
 	pkcs7_free_signed_info(ctx->sinfo);
 out_no_sinfo:
 	pkcs7_free_message(ctx->msg);
@@ -219,25 +222,25 @@ int pkcs7_sig_note_digest_algo(void *context, size_t hdrlen,
 
 	switch (ctx->last_oid) {
 	case OID_md4:
-		ctx->sinfo->sig.pkey_hash_algo = HASH_ALGO_MD4;
+		ctx->sinfo->sig->pkey_hash_algo = HASH_ALGO_MD4;
 		break;
 	case OID_md5:
-		ctx->sinfo->sig.pkey_hash_algo = HASH_ALGO_MD5;
+		ctx->sinfo->sig->pkey_hash_algo = HASH_ALGO_MD5;
 		break;
 	case OID_sha1:
-		ctx->sinfo->sig.pkey_hash_algo = HASH_ALGO_SHA1;
+		ctx->sinfo->sig->pkey_hash_algo = HASH_ALGO_SHA1;
 		break;
 	case OID_sha256:
-		ctx->sinfo->sig.pkey_hash_algo = HASH_ALGO_SHA256;
+		ctx->sinfo->sig->pkey_hash_algo = HASH_ALGO_SHA256;
 		break;
 	case OID_sha384:
-		ctx->sinfo->sig.pkey_hash_algo = HASH_ALGO_SHA384;
+		ctx->sinfo->sig->pkey_hash_algo = HASH_ALGO_SHA384;
 		break;
 	case OID_sha512:
-		ctx->sinfo->sig.pkey_hash_algo = HASH_ALGO_SHA512;
+		ctx->sinfo->sig->pkey_hash_algo = HASH_ALGO_SHA512;
 		break;
 	case OID_sha224:
-		ctx->sinfo->sig.pkey_hash_algo = HASH_ALGO_SHA224;
+		ctx->sinfo->sig->pkey_hash_algo = HASH_ALGO_SHA224;
 	default:
 		printk("Unsupported digest algo: %u\n", ctx->last_oid);
 		return -ENOPKG;
@@ -256,7 +259,7 @@ int pkcs7_sig_note_pkey_algo(void *context, size_t hdrlen,
 
 	switch (ctx->last_oid) {
 	case OID_rsaEncryption:
-		ctx->sinfo->sig.pkey_algo = PKEY_ALGO_RSA;
+		ctx->sinfo->sig->pkey_algo = PKEY_ALGO_RSA;
 		break;
 	default:
 		printk("Unsupported pkey algo: %u\n", ctx->last_oid);
@@ -617,16 +620,17 @@ int pkcs7_sig_note_signature(void *context, size_t hdrlen,
 			     const void *value, size_t vlen)
 {
 	struct pkcs7_parse_context *ctx = context;
+	struct public_key_signature *sig = ctx->sinfo->sig;
 	MPI mpi;
 
-	BUG_ON(ctx->sinfo->sig.pkey_algo != PKEY_ALGO_RSA);
+	BUG_ON(sig->pkey_algo != PKEY_ALGO_RSA);
 
 	mpi = mpi_read_raw_data(value, vlen);
 	if (!mpi)
 		return -ENOMEM;
 
-	ctx->sinfo->sig.mpi[0] = mpi;
-	ctx->sinfo->sig.nr_mpi = 1;
+	sig->mpi[0] = mpi;
+	sig->nr_mpi = 1;
 	return 0;
 }
 
@@ -662,12 +666,16 @@ int pkcs7_note_signed_info(void *context, size_t hdrlen,
 
 	pr_devel("SINFO KID: %u [%*phN]\n", kid->len, kid->len, kid->data);
 
-	sinfo->signing_cert_id = kid;
+	sinfo->sig->auth_ids[0] = kid;
 	sinfo->index = ++ctx->sinfo_index;
 	*ctx->ppsinfo = sinfo;
 	ctx->ppsinfo = &sinfo->next;
 	ctx->sinfo = kzalloc(sizeof(struct pkcs7_signed_info), GFP_KERNEL);
 	if (!ctx->sinfo)
 		return -ENOMEM;
+	ctx->sinfo->sig = kzalloc(sizeof(struct public_key_signature),
+				  GFP_KERNEL);
+	if (!ctx->sinfo->sig)
+		return -ENOMEM;
 	return 0;
 }
diff --git a/crypto/asymmetric_keys/pkcs7_parser.h b/crypto/asymmetric_keys/pkcs7_parser.h
index c8159983ed8f..f4e81074f5e0 100644
--- a/crypto/asymmetric_keys/pkcs7_parser.h
+++ b/crypto/asymmetric_keys/pkcs7_parser.h
@@ -40,19 +40,17 @@ struct pkcs7_signed_info {
 #define	sinfo_has_ms_statement_type	5
 	time64_t	signing_time;
 
-	/* Issuing cert serial number and issuer's name [PKCS#7 or CMS ver 1]
-	 * or issuing cert's SKID [CMS ver 3].
-	 */
-	struct asymmetric_key_id *signing_cert_id;
-
 	/* Message signature.
 	 *
 	 * This contains the generated digest of _either_ the Content Data or
 	 * the Authenticated Attributes [RFC2315 9.3].  If the latter, one of
 	 * the attributes contains the digest of the the Content Data within
 	 * it.
+	 *
+	 * THis also contains the issuing cert serial number and issuer's name
+	 * [PKCS#7 or CMS ver 1] or issuing cert's SKID [CMS ver 3].
 	 */
-	struct public_key_signature sig;
+	struct public_key_signature *sig;
 };
 
 struct pkcs7_message {
diff --git a/crypto/asymmetric_keys/pkcs7_trust.c b/crypto/asymmetric_keys/pkcs7_trust.c
index 7bb9389fd644..400ef359448a 100644
--- a/crypto/asymmetric_keys/pkcs7_trust.c
+++ b/crypto/asymmetric_keys/pkcs7_trust.c
@@ -27,7 +27,7 @@ static int pkcs7_validate_trust_one(struct pkcs7_message *pkcs7,
 				    struct pkcs7_signed_info *sinfo,
 				    struct key *trust_keyring)
 {
-	struct public_key_signature *sig = &sinfo->sig;
+	struct public_key_signature *sig = sinfo->sig;
 	struct x509_certificate *x509, *last = NULL, *p;
 	struct key *key;
 	int ret;
@@ -102,7 +102,7 @@ static int pkcs7_validate_trust_one(struct pkcs7_message *pkcs7,
 	 * the signed info directly.
 	 */
 	key = x509_request_asymmetric_key(trust_keyring,
-					  sinfo->signing_cert_id,
+					  sinfo->sig->auth_ids[0],
 					  NULL,
 					  false);
 	if (!IS_ERR(key)) {
diff --git a/crypto/asymmetric_keys/pkcs7_verify.c b/crypto/asymmetric_keys/pkcs7_verify.c
index 1dede0199673..3b8124c2cd91 100644
--- a/crypto/asymmetric_keys/pkcs7_verify.c
+++ b/crypto/asymmetric_keys/pkcs7_verify.c
@@ -25,35 +25,38 @@
 static int pkcs7_digest(struct pkcs7_message *pkcs7,
 			struct pkcs7_signed_info *sinfo)
 {
+	struct public_key_signature *sig = sinfo->sig;
 	struct crypto_shash *tfm;
 	struct shash_desc *desc;
-	size_t digest_size, desc_size;
-	void *digest;
+	size_t desc_size;
 	int ret;
 
-	kenter(",%u,%u", sinfo->index, sinfo->sig.pkey_hash_algo);
+	kenter(",%u,%u", sinfo->index, sig->pkey_hash_algo);
 
-	if (sinfo->sig.pkey_hash_algo >= PKEY_HASH__LAST ||
-	    !hash_algo_name[sinfo->sig.pkey_hash_algo])
+	if (sig->pkey_hash_algo >= PKEY_HASH__LAST ||
+	    !hash_algo_name[sig->pkey_hash_algo])
 		return -ENOPKG;
 
 	/* Allocate the hashing algorithm we're going to need and find out how
 	 * big the hash operational data will be.
 	 */
-	tfm = crypto_alloc_shash(hash_algo_name[sinfo->sig.pkey_hash_algo],
+	tfm = crypto_alloc_shash(hash_algo_name[sinfo->sig->pkey_hash_algo],
 				 0, 0);
 	if (IS_ERR(tfm))
 		return (PTR_ERR(tfm) == -ENOENT) ? -ENOPKG : PTR_ERR(tfm);
 
 	desc_size = crypto_shash_descsize(tfm) + sizeof(*desc);
-	sinfo->sig.digest_size = digest_size = crypto_shash_digestsize(tfm);
+	sig->digest_size = crypto_shash_digestsize(tfm);
 
 	ret = -ENOMEM;
-	digest = kzalloc(digest_size + desc_size, GFP_KERNEL);
-	if (!digest)
+	sig->digest = kmalloc(sig->digest_size, GFP_KERNEL);
+	if (!sig->digest)
+		goto error_no_desc;
+
+	desc = kzalloc(desc_size, GFP_KERNEL);
+	if (!desc)
 		goto error_no_desc;
 
-	desc = digest + digest_size;
 	desc->tfm   = tfm;
 	desc->flags = CRYPTO_TFM_REQ_MAY_SLEEP;
 
@@ -61,10 +64,11 @@ static int pkcs7_digest(struct pkcs7_message *pkcs7,
 	ret = crypto_shash_init(desc);
 	if (ret < 0)
 		goto error;
-	ret = crypto_shash_finup(desc, pkcs7->data, pkcs7->data_len, digest);
+	ret = crypto_shash_finup(desc, pkcs7->data, pkcs7->data_len,
+				 sig->digest);
 	if (ret < 0)
 		goto error;
-	pr_devel("MsgDigest = [%*ph]\n", 8, digest);
+	pr_devel("MsgDigest = [%*ph]\n", 8, sig->digest);
 
 	/* However, if there are authenticated attributes, there must be a
 	 * message digest attribute amongst them which corresponds to the
@@ -79,14 +83,15 @@ static int pkcs7_digest(struct pkcs7_message *pkcs7,
 			goto error;
 		}
 
-		if (sinfo->msgdigest_len != sinfo->sig.digest_size) {
+		if (sinfo->msgdigest_len != sig->digest_size) {
 			pr_debug("Sig %u: Invalid digest size (%u)\n",
 				 sinfo->index, sinfo->msgdigest_len);
 			ret = -EBADMSG;
 			goto error;
 		}
 
-		if (memcmp(digest, sinfo->msgdigest, sinfo->msgdigest_len) != 0) {
+		if (memcmp(sig->digest, sinfo->msgdigest,
+			   sinfo->msgdigest_len) != 0) {
 			pr_debug("Sig %u: Message digest doesn't match\n",
 				 sinfo->index);
 			ret = -EKEYREJECTED;
@@ -98,7 +103,7 @@ static int pkcs7_digest(struct pkcs7_message *pkcs7,
 		 * convert the attributes from a CONT.0 into a SET before we
 		 * hash it.
 		 */
-		memset(digest, 0, sinfo->sig.digest_size);
+		memset(sig->digest, 0, sig->digest_size);
 
 		ret = crypto_shash_init(desc);
 		if (ret < 0)
@@ -108,17 +113,14 @@ static int pkcs7_digest(struct pkcs7_message *pkcs7,
 		if (ret < 0)
 			goto error;
 		ret = crypto_shash_finup(desc, sinfo->authattrs,
-					 sinfo->authattrs_len, digest);
+					 sinfo->authattrs_len, sig->digest);
 		if (ret < 0)
 			goto error;
-		pr_devel("AADigest = [%*ph]\n", 8, digest);
+		pr_devel("AADigest = [%*ph]\n", 8, sig->digest);
 	}
 
-	sinfo->sig.digest = digest;
-	digest = NULL;
-
 error:
-	kfree(digest);
+	kfree(desc);
 error_no_desc:
 	crypto_free_shash(tfm);
 	kleave(" = %d", ret);
@@ -145,12 +147,12 @@ static int pkcs7_find_key(struct pkcs7_message *pkcs7,
 		 * PKCS#7 message - but I can't be 100% sure of that.  It's
 		 * possible this will need element-by-element comparison.
 		 */
-		if (!asymmetric_key_id_same(x509->id, sinfo->signing_cert_id))
+		if (!asymmetric_key_id_same(x509->id, sinfo->sig->auth_ids[0]))
 			continue;
 		pr_devel("Sig %u: Found cert serial match X.509[%u]\n",
 			 sinfo->index, certix);
 
-		if (x509->pub->pkey_algo != sinfo->sig.pkey_algo) {
+		if (x509->pub->pkey_algo != sinfo->sig->pkey_algo) {
 			pr_warn("Sig %u: X.509 algo and PKCS#7 sig algo don't match\n",
 				sinfo->index);
 			continue;
@@ -165,7 +167,7 @@ static int pkcs7_find_key(struct pkcs7_message *pkcs7,
 	 */
 	pr_debug("Sig %u: Issuing X.509 cert not found (#%*phN)\n",
 		 sinfo->index,
-		 sinfo->signing_cert_id->len, sinfo->signing_cert_id->data);
+		 sinfo->sig->auth_ids[0]->len, sinfo->sig->auth_ids[0]->data);
 	return 0;
 }
 
@@ -324,7 +326,7 @@ static int pkcs7_verify_one(struct pkcs7_message *pkcs7,
 	}
 
 	/* Verify the PKCS#7 binary against the key */
-	ret = public_key_verify_signature(sinfo->signer->pub, &sinfo->sig);
+	ret = public_key_verify_signature(sinfo->signer->pub, sinfo->sig);
 	if (ret < 0)
 		return ret;
 
