Return-Path: <SRS0=1iZj=N3=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:35398 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727111AbeKQGWQ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 17 Nov 2018 01:22:16 -0500
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.22/8.16.0.22) with SMTP id wAGK4Cu4132182
        for <linux-crypto@vger.kernel.org>; Fri, 16 Nov 2018 15:08:27 -0500
Received: from e12.ny.us.ibm.com (e12.ny.us.ibm.com [129.33.205.202])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2nt252wwvp-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-crypto@vger.kernel.org>; Fri, 16 Nov 2018 15:08:26 -0500
Received: from localhost
        by e12.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-crypto@vger.kernel.org> from <bauerman@linux.ibm.com>;
        Fri, 16 Nov 2018 20:08:26 -0000
From: Thiago Jung Bauermann <bauerman@linux.ibm.com>
To: linux-integrity@vger.kernel.org
Cc: linux-security-module@vger.kernel.org, keyrings@vger.kernel.org,
        linux-crypto@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mimi Zohar <zohar@linux.ibm.com>,
        Dmitry Kasatkin <dmitry.kasatkin@gmail.com>,
        James Morris <jmorris@namei.org>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        David Howells <dhowells@redhat.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Jessica Yu <jeyu@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Jonathan Corbet <corbet@lwn.net>,
        "AKASHI, Takahiro" <takahiro.akashi@linaro.org>,
        Thiago Jung Bauermann <bauerman@linux.ibm.com>
Subject: [PATCH v8 02/14] PKCS#7: Refactor verify_pkcs7_signature() and add pkcs7_get_message_sig()
Date: Fri, 16 Nov 2018 18:07:00 -0200
In-Reply-To: <20181116200712.14154-1-bauerman@linux.ibm.com>
References: <20181116200712.14154-1-bauerman@linux.ibm.com>
Message-Id: <20181116200712.14154-3-bauerman@linux.ibm.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

IMA will need to verify a PKCS#7 which has already been parsed. For this
reason, factor out the code which does that from verify_pkcs7_signature()
into a new function which takes a struct pkcs7_message instead of a data
buffer.

In addition, IMA will need to know the key that signed a given PKCS#7
message, so add pkcs7_get_message_sig().

Signed-off-by: Thiago Jung Bauermann <bauerman@linux.ibm.com>
Reviewed-by: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: David Howells <dhowells@redhat.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "David S. Miller" <davem@davemloft.net>
---
 certs/system_keyring.c                | 61 ++++++++++++++++++++-------
 crypto/asymmetric_keys/pkcs7_parser.c | 16 +++++++
 include/crypto/pkcs7.h                |  2 +
 include/linux/verification.h          | 10 +++++
 4 files changed, 73 insertions(+), 16 deletions(-)

diff --git a/certs/system_keyring.c b/certs/system_keyring.c
index 81728717523d..dd8c5ef941ce 100644
--- a/certs/system_keyring.c
+++ b/certs/system_keyring.c
@@ -191,33 +191,27 @@ late_initcall(load_system_certificate_list);
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
+			     int (*view_content)(void *ctx,
+						 const void *data, size_t len,
+						 size_t asn1hdrlen),
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
@@ -259,6 +253,41 @@ int verify_pkcs7_signature(const void *data, size_t len,
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
index f0d56e1a8b7e..8df9693f659f 100644
--- a/crypto/asymmetric_keys/pkcs7_parser.c
+++ b/crypto/asymmetric_keys/pkcs7_parser.c
@@ -684,3 +684,19 @@ int pkcs7_note_signed_info(void *context, size_t hdrlen,
 		return -ENOMEM;
 	return 0;
 }
+
+/**
+ * pkcs7_get_message_sig - get signature in @pkcs7
+ */
+const struct public_key_signature *pkcs7_get_message_sig(
+					const struct pkcs7_message *pkcs7)
+{
+	/*
+	 * This function doesn't support messages with more than one signature,
+	 * so don't return anything in that case.
+	 */
+	if (pkcs7->signed_infos == NULL || pkcs7->signed_infos->next != NULL)
+		return NULL;
+
+	return pkcs7->signed_infos->sig;
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
index cfa4730d607a..7b09a55674a7 100644
--- a/include/linux/verification.h
+++ b/include/linux/verification.h
@@ -35,6 +35,7 @@ extern const char *const key_being_used_for[NR__KEY_BEING_USED_FOR];
 #ifdef CONFIG_SYSTEM_DATA_VERIFICATION
 
 struct key;
+struct pkcs7_message;
 
 extern int verify_pkcs7_signature(const void *data, size_t len,
 				  const void *raw_pkcs7, size_t pkcs7_len,
@@ -44,6 +45,15 @@ extern int verify_pkcs7_signature(const void *data, size_t len,
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
