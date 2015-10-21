From: David Howells <dhowells@redhat.com>
Subject: [PATCH 02/10] PKCS#7: Make trust determination dependent on
 contents of trust keyring
Date: Wed, 21 Oct 2015 16:13:34 +0100
Message-ID: <20151021151334.4583.3660.stgit@warthog.procyon.org.uk>
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

Make the determination of the trustworthiness of a key dependent on whether
a key that can verify it is present in the ring of trusted keys rather than
whether or not the verifying key has KEY_FLAG_TRUSTED set.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 certs/system_keyring.c                  |   13 ++++---------
 crypto/asymmetric_keys/pkcs7_key_type.c |    2 +-
 crypto/asymmetric_keys/pkcs7_parser.h   |    1 -
 crypto/asymmetric_keys/pkcs7_trust.c    |   16 +++-------------
 crypto/asymmetric_keys/verify_pefile.c  |    2 +-
 crypto/asymmetric_keys/x509_parser.h    |    1 -
 include/crypto/pkcs7.h                  |    3 +--
 include/linux/verification.h            |    1 -
 kernel/module_signing.c                 |    2 +-
 9 files changed, 11 insertions(+), 30 deletions(-)

diff --git a/certs/system_keyring.c b/certs/system_keyring.c
index cf55bd3a072a..e7f286413276 100644
--- a/certs/system_keyring.c
+++ b/certs/system_keyring.c
@@ -121,7 +121,6 @@ late_initcall(load_system_certificate_list);
 int verify_pkcs7_signature(const void *data, size_t len,
 			   const void *raw_pkcs7, size_t pkcs7_len,
 			   struct key *trusted_keys,
-			   int untrusted_error,
 			   enum key_being_used_for usage,
 			   int (*view_content)(void *ctx,
 					       const void *data, size_t len,
@@ -129,7 +128,6 @@ int verify_pkcs7_signature(const void *data, size_t len,
 			   void *ctx)
 {
 	struct pkcs7_message *pkcs7;
-	bool trusted;
 	int ret;
 
 	pkcs7 = pkcs7_parse_message(raw_pkcs7, pkcs7_len);
@@ -149,13 +147,10 @@ int verify_pkcs7_signature(const void *data, size_t len,
 
 	if (!trusted_keys)
 		trusted_keys = system_trusted_keyring;
-	ret = pkcs7_validate_trust(pkcs7, trusted_keys, &trusted);
-	if (ret < 0)
-		goto error;
-
-	if (!trusted && untrusted_error) {
-		pr_err("PKCS#7 signature not signed with a trusted key\n");
-		ret = untrusted_error;
+	ret = pkcs7_validate_trust(pkcs7, trusted_keys);
+	if (ret < 0) {
+		if (ret == -ENOKEY)
+			pr_err("PKCS#7 signature not signed with a trusted key\n");
 		goto error;
 	}
 
diff --git a/crypto/asymmetric_keys/pkcs7_key_type.c b/crypto/asymmetric_keys/pkcs7_key_type.c
index 240a5303ebb7..89b75477868d 100644
--- a/crypto/asymmetric_keys/pkcs7_key_type.c
+++ b/crypto/asymmetric_keys/pkcs7_key_type.c
@@ -71,7 +71,7 @@ static int pkcs7_preparse(struct key_preparsed_payload *prep)
 
 	ret = verify_pkcs7_signature(NULL, 0,
 				     prep->data, prep->datalen,
-				     NULL, -ENOKEY, usage,
+				     NULL, usage,
 				     pkcs7_view_content, prep);
 
 	kleave(" = %d", ret);
diff --git a/crypto/asymmetric_keys/pkcs7_parser.h b/crypto/asymmetric_keys/pkcs7_parser.h
index a66b19ebcf47..c8159983ed8f 100644
--- a/crypto/asymmetric_keys/pkcs7_parser.h
+++ b/crypto/asymmetric_keys/pkcs7_parser.h
@@ -22,7 +22,6 @@ struct pkcs7_signed_info {
 	struct pkcs7_signed_info *next;
 	struct x509_certificate *signer; /* Signing certificate (in msg->certs) */
 	unsigned	index;
-	bool		trusted;
 	bool		unsupported_crypto;	/* T if not usable due to missing crypto */
 
 	/* Message digest - the digest of the Content Data (or NULL) */
diff --git a/crypto/asymmetric_keys/pkcs7_trust.c b/crypto/asymmetric_keys/pkcs7_trust.c
index 90d6d47965b0..388007fed3b2 100644
--- a/crypto/asymmetric_keys/pkcs7_trust.c
+++ b/crypto/asymmetric_keys/pkcs7_trust.c
@@ -30,7 +30,6 @@ static int pkcs7_validate_trust_one(struct pkcs7_message *pkcs7,
 	struct public_key_signature *sig = &sinfo->sig;
 	struct x509_certificate *x509, *last = NULL, *p;
 	struct key *key;
-	bool trusted;
 	int ret;
 
 	kenter(",%u,", sinfo->index);
@@ -42,10 +41,8 @@ static int pkcs7_validate_trust_one(struct pkcs7_message *pkcs7,
 
 	for (x509 = sinfo->signer; x509; x509 = x509->signer) {
 		if (x509->seen) {
-			if (x509->verified) {
-				trusted = x509->trusted;
+			if (x509->verified)
 				goto verified;
-			}
 			kleave(" = -ENOKEY [cached]");
 			return -ENOKEY;
 		}
@@ -122,7 +119,6 @@ static int pkcs7_validate_trust_one(struct pkcs7_message *pkcs7,
 
 matched:
 	ret = verify_signature(key, sig);
-	trusted = test_bit(KEY_FLAG_TRUSTED, &key->flags);
 	key_put(key);
 	if (ret < 0) {
 		if (ret == -ENOMEM)
@@ -134,12 +130,9 @@ matched:
 verified:
 	if (x509) {
 		x509->verified = true;
-		for (p = sinfo->signer; p != x509; p = p->signer) {
+		for (p = sinfo->signer; p != x509; p = p->signer)
 			p->verified = true;
-			p->trusted = trusted;
-		}
 	}
-	sinfo->trusted = trusted;
 	kleave(" = 0");
 	return 0;
 }
@@ -148,7 +141,6 @@ verified:
  * pkcs7_validate_trust - Validate PKCS#7 trust chain
  * @pkcs7: The PKCS#7 certificate to validate
  * @trust_keyring: Signing certificates to use as starting points
- * @_trusted: Set to true if trustworth, false otherwise
  *
  * Validate that the certificate chain inside the PKCS#7 message intersects
  * keys we already know and trust.
@@ -170,8 +162,7 @@ verified:
  * May also return -ENOMEM.
  */
 int pkcs7_validate_trust(struct pkcs7_message *pkcs7,
-			 struct key *trust_keyring,
-			 bool *_trusted)
+			 struct key *trust_keyring)
 {
 	struct pkcs7_signed_info *sinfo;
 	struct x509_certificate *p;
@@ -191,7 +182,6 @@ int pkcs7_validate_trust(struct pkcs7_message *pkcs7,
 				cached_ret = -ENOPKG;
 			continue;
 		case 0:
-			*_trusted |= sinfo->trusted;
 			cached_ret = 0;
 			continue;
 		default:
diff --git a/crypto/asymmetric_keys/verify_pefile.c b/crypto/asymmetric_keys/verify_pefile.c
index 443a00f9cd7a..4112f922cc66 100644
--- a/crypto/asymmetric_keys/verify_pefile.c
+++ b/crypto/asymmetric_keys/verify_pefile.c
@@ -436,7 +436,7 @@ int verify_pefile_signature(const void *pebuf, unsigned pelen,
 
 	ret = verify_pkcs7_signature(NULL, 0,
 				     pebuf + ctx.sig_offset, ctx.sig_len,
-				     trusted_keys, -EKEYREJECTED, usage,
+				     trusted_keys, usage,
 				     mscode_parse, &ctx);
 	if (ret < 0)
 		goto error;
diff --git a/crypto/asymmetric_keys/x509_parser.h b/crypto/asymmetric_keys/x509_parser.h
index dbeed6018e63..36b7c47335b5 100644
--- a/crypto/asymmetric_keys/x509_parser.h
+++ b/crypto/asymmetric_keys/x509_parser.h
@@ -41,7 +41,6 @@ struct x509_certificate {
 	unsigned	index;
 	bool		seen;			/* Infinite recursion prevention */
 	bool		verified;
-	bool		trusted;
 	bool		unsupported_crypto;	/* T if can't be verified due to missing crypto */
 };
 
diff --git a/include/crypto/pkcs7.h b/include/crypto/pkcs7.h
index 8323e3e57131..583f199400a3 100644
--- a/include/crypto/pkcs7.h
+++ b/include/crypto/pkcs7.h
@@ -33,8 +33,7 @@ extern int pkcs7_get_content_data(const struct pkcs7_message *pkcs7,
  * pkcs7_trust.c
  */
 extern int pkcs7_validate_trust(struct pkcs7_message *pkcs7,
-				struct key *trust_keyring,
-				bool *_trusted);
+				struct key *trust_keyring);
 
 /*
  * pkcs7_verify.c
diff --git a/include/linux/verification.h b/include/linux/verification.h
index bb0fcf941cb7..a10549a6c7cd 100644
--- a/include/linux/verification.h
+++ b/include/linux/verification.h
@@ -33,7 +33,6 @@ struct key;
 extern int verify_pkcs7_signature(const void *data, size_t len,
 				  const void *raw_pkcs7, size_t pkcs7_len,
 				  struct key *trusted_keys,
-				  int untrusted_error,
 				  enum key_being_used_for usage,
 				  int (*view_content)(void *ctx,
 						      const void *data, size_t len,
diff --git a/kernel/module_signing.c b/kernel/module_signing.c
index 70cf0220efeb..b3dafe4fd320 100644
--- a/kernel/module_signing.c
+++ b/kernel/module_signing.c
@@ -74,6 +74,6 @@ int mod_verify_sig(const void *mod, unsigned long *_modlen)
 	}
 
 	return verify_pkcs7_signature(mod, modlen, mod + modlen, sig_len,
-				      NULL, -ENOKEY, VERIFYING_MODULE_SIGNATURE,
+				      NULL, VERIFYING_MODULE_SIGNATURE,
 				      NULL, NULL);
 }
