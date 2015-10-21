From: David Howells <dhowells@redhat.com>
Subject: [PATCH 04/10] KEYS: Allow authentication data to be stored in an
 asymmetric key
Date: Wed, 21 Oct 2015 16:13:53 +0100
Message-ID: <20151021151353.4583.65314.stgit@warthog.procyon.org.uk>
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

Allow authentication data to be stored in an asymmetric key in the 4th
element of the key payload and provide a way for it to be destroyed.

For the public key subtype, this will be a public_key_signature struct.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 crypto/asymmetric_keys/asymmetric_type.c  |    7 +++++--
 crypto/asymmetric_keys/public_key.c       |   22 +++++++++++++++++++---
 crypto/asymmetric_keys/x509_cert_parser.c |    2 +-
 include/crypto/public_key.h               |    5 +++--
 include/keys/asymmetric-subtype.h         |    2 +-
 include/keys/asymmetric-type.h            |    7 ++++---
 6 files changed, 33 insertions(+), 12 deletions(-)

diff --git a/crypto/asymmetric_keys/asymmetric_type.c b/crypto/asymmetric_keys/asymmetric_type.c
index 9f2165b27d52..a79d30128821 100644
--- a/crypto/asymmetric_keys/asymmetric_type.c
+++ b/crypto/asymmetric_keys/asymmetric_type.c
@@ -331,7 +331,8 @@ static void asymmetric_key_free_preparse(struct key_preparsed_payload *prep)
 	pr_devel("==>%s()\n", __func__);
 
 	if (subtype) {
-		subtype->destroy(prep->payload.data[asym_crypto]);
+		subtype->destroy(prep->payload.data[asym_crypto],
+				 prep->payload.data[asym_auth]);
 		module_put(subtype->owner);
 	}
 	asymmetric_key_free_kids(kids);
@@ -346,13 +347,15 @@ static void asymmetric_key_destroy(struct key *key)
 	struct asymmetric_key_subtype *subtype = asymmetric_key_subtype(key);
 	struct asymmetric_key_ids *kids = key->payload.data[asym_key_ids];
 	void *data = key->payload.data[asym_crypto];
+	void *auth = key->payload.data[asym_auth];
 
 	key->payload.data[asym_crypto] = NULL;
 	key->payload.data[asym_subtype] = NULL;
 	key->payload.data[asym_key_ids] = NULL;
+	key->payload.data[asym_auth] = NULL;
 
 	if (subtype) {
-		subtype->destroy(data);
+		subtype->destroy(data, auth);
 		module_put(subtype->owner);
 	}
 
diff --git a/crypto/asymmetric_keys/public_key.c b/crypto/asymmetric_keys/public_key.c
index 6db4c01c6503..e537aaeafdbf 100644
--- a/crypto/asymmetric_keys/public_key.c
+++ b/crypto/asymmetric_keys/public_key.c
@@ -59,18 +59,34 @@ static void public_key_describe(const struct key *asymmetric_key,
 /*
  * Destroy a public key algorithm key.
  */
-void public_key_destroy(void *payload)
+void public_key_free(struct public_key *key,
+		     struct public_key_signature *sig)
 {
-	struct public_key *key = payload;
 	int i;
 
 	if (key) {
 		for (i = 0; i < ARRAY_SIZE(key->mpi); i++)
 			mpi_free(key->mpi[i]);
 		kfree(key);
+		key = NULL;
 	}
+
+	if (sig) {
+		for (i = 0; i < ARRAY_SIZE(sig->mpi); i++)
+			mpi_free(sig->mpi[i]);
+		kfree(sig->digest);
+		kfree(sig);
+	}
+}
+EXPORT_SYMBOL_GPL(public_key_free);
+
+/*
+ * Destroy a public key algorithm key.
+ */
+static void public_key_destroy(void *payload0, void *payload3)
+{
+	public_key_free(payload0, payload3);
 }
-EXPORT_SYMBOL_GPL(public_key_destroy);
 
 /*
  * Verify a signature using a public key.
diff --git a/crypto/asymmetric_keys/x509_cert_parser.c b/crypto/asymmetric_keys/x509_cert_parser.c
index af71878dc15b..430848445dd9 100644
--- a/crypto/asymmetric_keys/x509_cert_parser.c
+++ b/crypto/asymmetric_keys/x509_cert_parser.c
@@ -48,7 +48,7 @@ struct x509_parse_context {
 void x509_free_certificate(struct x509_certificate *cert)
 {
 	if (cert) {
-		public_key_destroy(cert->pub);
+		public_key_free(cert->pub, NULL);
 		kfree(cert->issuer);
 		kfree(cert->subject);
 		kfree(cert->id);
diff --git a/include/crypto/public_key.h b/include/crypto/public_key.h
index de50d026576d..a3f8f8268e23 100644
--- a/include/crypto/public_key.h
+++ b/include/crypto/public_key.h
@@ -72,8 +72,6 @@ struct public_key {
 	};
 };
 
-extern void public_key_destroy(void *payload);
-
 /*
  * Public key cryptography signature data
  */
@@ -95,6 +93,9 @@ struct public_key_signature {
 	};
 };
 
+extern void public_key_free(struct public_key *key,
+			    struct public_key_signature *sig);
+
 struct key;
 extern int verify_signature(const struct key *key,
 			    const struct public_key_signature *sig);
diff --git a/include/keys/asymmetric-subtype.h b/include/keys/asymmetric-subtype.h
index 4915d40d3c3c..2480469ce8fb 100644
--- a/include/keys/asymmetric-subtype.h
+++ b/include/keys/asymmetric-subtype.h
@@ -32,7 +32,7 @@ struct asymmetric_key_subtype {
 	void (*describe)(const struct key *key, struct seq_file *m);
 
 	/* Destroy a key of this subtype */
-	void (*destroy)(void *payload);
+	void (*destroy)(void *payload_crypto, void *payload_auth);
 
 	/* Verify the signature on a key of this subtype (optional) */
 	int (*verify_signature)(const struct key *key,
diff --git a/include/keys/asymmetric-type.h b/include/keys/asymmetric-type.h
index 72c18c1f3308..d1e23dda4363 100644
--- a/include/keys/asymmetric-type.h
+++ b/include/keys/asymmetric-type.h
@@ -24,9 +24,10 @@ extern struct key_type key_type_asymmetric;
  * follows:
  */
 enum asymmetric_payload_bits {
-	asym_crypto,
-	asym_subtype,
-	asym_key_ids,
+	asym_crypto,		/* The data representing the key */
+	asym_subtype,		/* Pointer to an asymmetric_key_subtype struct */
+	asym_key_ids,		/* Pointer to an asymmetric_key_ids struct */
+	asym_auth		/* The key's authorisation (signature, parent key ID) */
 };
 
 /*
