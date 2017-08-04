From: Thiago Jung Bauermann <bauerman@linux.vnet.ibm.com>
Subject: [PATCH v4 3/7] PKCS#7: Introduce pkcs7_get_message_sig and verify_pkcs7_message_sig
Date: Fri,  4 Aug 2017 19:03:26 -0300
Message-ID: <20170804220330.30026-4-bauerman@linux.vnet.ibm.com>
References: <20170804220330.30026-1-bauerman@linux.vnet.ibm.com>
Cc: linux-ima-devel@lists.sourceforge.net, keyrings@vger.kernel.org,
        linux-crypto@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org,
        Mimi Zohar <zohar@linux.vnet.ibm.com>,
        Dmitry Kasatkin <dmitry.kasatkin@gmail.com>,
        James Morris <james.l.morris@oracle.com>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        David Howells <dhowells@redhat.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Jessica Yu <jeyu@redhat.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        "AKASHI, Takahiro" <takahiro.akashi@linaro.org>,
        Thiago Jung Bauermann <bauerman@linux.vnet.ibm.com>
To: linux-security-module@vger.kernel.org
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <20170804220330.30026-1-bauerman@linux.vnet.ibm.com>
Sender: owner-linux-security-module@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

IMA will need to access the digest used in the signature so that it can
verify files containing module-style appended signatures. For this purpose,
add function pkcs7_get_message_sig.

It will also need to verify an already parsed PKCS#7 message. For this
purpose, add function verify_pkcs7_message_signature which takes a struct
pkcs7_message for verification instead of the raw bytes that
verify_pkcs7_signature takes.

Signed-off-by: Thiago Jung Bauermann <bauerman@linux.vnet.ibm.com>
---
 certs/system_keyring.c                | 60 +++++++++++++++++++++++++----------
 crypto/asymmetric_keys/pkcs7_parser.c | 12 +++++++
 include/crypto/pkcs7.h                |  2 ++
 include/linux/verification.h          | 10 ++++++
 4 files changed, 68 insertions(+), 16 deletions(-)

diff --git a/certs/system_keyring.c b/certs/system_keyring.c
index 6251d1b27f0c..6a8684959780 100644
--- a/certs/system_keyring.c
+++ b/certs/system_keyring.c
@@ -190,33 +190,26 @@ late_initcall(load_system_certificate_list);
 #ifdef CONFIG_SYSTEM_DATA_VERIFICATION
 
 /**
- * verify_pkcs7_signature - Verify a PKCS#7-based signature on system data.
+ * verify_pkcs7_message_sig - Verify a PKCS#7-based signature on system data.
  * @data: The data to be verified (NULL if expecting internal data).
  * @len: Size of @data.
- * @raw_pkcs7: The PKCS#7 message that is the signature.
- * @pkcs7_len: The size of @raw_pkcs7.
+ * @pkcs7: The PKCS#7 message that is the signature.
  * @trusted_keys: Trusted keys to use (NULL for builtin trusted keys only,
  *					(void *)1UL for all trusted keys).
  * @usage: The use to which the key is being put.
  * @view_content: Callback to gain access to content.
  * @ctx: Context for callback.
  */
-int verify_pkcs7_signature(const void *data, size_t len,
-			   const void *raw_pkcs7, size_t pkcs7_len,
-			   struct key *trusted_keys,
-			   enum key_being_used_for usage,
-			   int (*view_content)(void *ctx,
-					       const void *data, size_t len,
-					       size_t asn1hdrlen),
-			   void *ctx)
+int verify_pkcs7_message_sig(const void *data, size_t len,
+			     struct pkcs7_message *pkcs7,
+			     struct key *trusted_keys,
+			     enum key_being_used_for usage,
+			     int (*view_content)(void *ctx, const void *data,
+						 size_t len, size_t asn1hdrlen),
+			     void *ctx)
 {
-	struct pkcs7_message *pkcs7;
 	int ret;
 
-	pkcs7 = pkcs7_parse_message(raw_pkcs7, pkcs7_len);
-	if (IS_ERR(pkcs7))
-		return PTR_ERR(pkcs7);
-
 	/* The data should be detached - so we need to supply it. */
 	if (data && pkcs7_supply_detached_data(pkcs7, data, len) < 0) {
 		pr_err("PKCS#7 signature with non-detached data\n");
@@ -258,6 +251,41 @@ int verify_pkcs7_signature(const void *data, size_t len,
 	}
 
 error:
+	pr_devel("<==%s() = %d\n", __func__, ret);
+	return ret;
+}
+
+/**
+ * verify_pkcs7_signature - Verify a PKCS#7-based signature on system data.
+ * @data: The data to be verified (NULL if expecting internal data).
+ * @len: Size of @data.
+ * @raw_pkcs7: The PKCS#7 message that is the signature.
+ * @pkcs7_len: The size of @raw_pkcs7.
+ * @trusted_keys: Trusted keys to use (NULL for builtin trusted keys only,
+ *					(void *)1UL for all trusted keys).
+ * @usage: The use to which the key is being put.
+ * @view_content: Callback to gain access to content.
+ * @ctx: Context for callback.
+ */
+int verify_pkcs7_signature(const void *data, size_t len,
+			   const void *raw_pkcs7, size_t pkcs7_len,
+			   struct key *trusted_keys,
+			   enum key_being_used_for usage,
+			   int (*view_content)(void *ctx,
+					       const void *data, size_t len,
+					       size_t asn1hdrlen),
+			   void *ctx)
+{
+	struct pkcs7_message *pkcs7;
+	int ret;
+
+	pkcs7 = pkcs7_parse_message(raw_pkcs7, pkcs7_len);
+	if (IS_ERR(pkcs7))
+		return PTR_ERR(pkcs7);
+
+	ret = verify_pkcs7_message_sig(data, len, pkcs7, trusted_keys, usage,
+				       view_content, ctx);
+
 	pkcs7_free_message(pkcs7);
 	pr_devel("<==%s() = %d\n", __func__, ret);
 	return ret;
diff --git a/crypto/asymmetric_keys/pkcs7_parser.c b/crypto/asymmetric_keys/pkcs7_parser.c
index af4cd8649117..e41beda297a8 100644
--- a/crypto/asymmetric_keys/pkcs7_parser.c
+++ b/crypto/asymmetric_keys/pkcs7_parser.c
@@ -673,3 +673,15 @@ int pkcs7_note_signed_info(void *context, size_t hdrlen,
 		return -ENOMEM;
 	return 0;
 }
+
+/**
+ * pkcs7_get_message_sig - get signature in @pkcs7
+ *
+ * This function doesn't meaningfully support messages with more than one
+ * signature. It will always return the first signature.
+ */
+const struct public_key_signature *pkcs7_get_message_sig(
+					const struct pkcs7_message *pkcs7)
+{
+	return pkcs7->signed_infos ? pkcs7->signed_infos->sig : NULL;
+}
diff --git a/include/crypto/pkcs7.h b/include/crypto/pkcs7.h
index 583f199400a3..6f51d0cb6d12 100644
--- a/include/crypto/pkcs7.h
+++ b/include/crypto/pkcs7.h
@@ -28,6 +28,8 @@ extern void pkcs7_free_message(struct pkcs7_message *pkcs7);
 extern int pkcs7_get_content_data(const struct pkcs7_message *pkcs7,
 				  const void **_data, size_t *_datalen,
 				  size_t *_headerlen);
+extern const struct public_key_signature *pkcs7_get_message_sig(
+					const struct pkcs7_message *pkcs7);
 
 /*
  * pkcs7_trust.c
diff --git a/include/linux/verification.h b/include/linux/verification.h
index a10549a6c7cd..f04dac2728ec 100644
--- a/include/linux/verification.h
+++ b/include/linux/verification.h
@@ -29,6 +29,7 @@ extern const char *const key_being_used_for[NR__KEY_BEING_USED_FOR];
 #ifdef CONFIG_SYSTEM_DATA_VERIFICATION
 
 struct key;
+struct pkcs7_message;
 
 extern int verify_pkcs7_signature(const void *data, size_t len,
 				  const void *raw_pkcs7, size_t pkcs7_len,
@@ -38,6 +39,15 @@ extern int verify_pkcs7_signature(const void *data, size_t len,
 						      const void *data, size_t len,
 						      size_t asn1hdrlen),
 				  void *ctx);
+extern int verify_pkcs7_message_sig(const void *data, size_t len,
+				    struct pkcs7_message *pkcs7,
+				    struct key *trusted_keys,
+				    enum key_being_used_for usage,
+				    int (*view_content)(void *ctx,
+							const void *data,
+							size_t len,
+							size_t asn1hdrlen),
+				    void *ctx);
 
 #ifdef CONFIG_SIGNED_PE_FILE_VERIFICATION
 extern int verify_pefile_signature(const void *pebuf, unsigned pelen,
-- 
2.13.0

