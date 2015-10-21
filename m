From: David Howells <dhowells@redhat.com>
Subject: [PATCH 01/10] KEYS: Generalise system_verify_data() to provide
 access to internal content
Date: Wed, 21 Oct 2015 16:13:25 +0100
Message-ID: <20151021151324.4583.68262.stgit@warthog.procyon.org.uk>
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

Generalise system_verify_data() to provide access to internal content
through a callback.  This allows all the PKCS#7 stuff to be hidden inside
this function and removed from the PE file parser and the PKCS#7 test key.

If external content is not required, NULL should be passed as data to the
function.  If the callback is not required, that can be set to NULL.

The function is now called verify_pkcs7_signature() to contrast with
verify_pefile_signature() and the definitions of both have been moved into
linux/verification.h along with the key_being_used_for enum.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 arch/x86/kernel/kexec-bzimage64.c       |   18 ++-------
 certs/system_keyring.c                  |   45 +++++++++++++++++-----
 crypto/asymmetric_keys/Kconfig          |    1 
 crypto/asymmetric_keys/mscode_parser.c  |   21 +++-------
 crypto/asymmetric_keys/pkcs7_key_type.c |   64 +++++++++++++++----------------
 crypto/asymmetric_keys/pkcs7_parser.c   |   21 +++++-----
 crypto/asymmetric_keys/verify_pefile.c  |   40 ++++---------------
 crypto/asymmetric_keys/verify_pefile.h  |    5 +-
 include/crypto/pkcs7.h                  |    3 +
 include/crypto/public_key.h             |   14 -------
 include/keys/asymmetric-type.h          |    1 
 include/keys/system_keyring.h           |    7 ---
 include/linux/verification.h            |   50 ++++++++++++++++++++++++
 include/linux/verify_pefile.h           |   22 -----------
 kernel/module_signing.c                 |    5 +-
 15 files changed, 156 insertions(+), 161 deletions(-)
 create mode 100644 include/linux/verification.h
 delete mode 100644 include/linux/verify_pefile.h

diff --git a/arch/x86/kernel/kexec-bzimage64.c b/arch/x86/kernel/kexec-bzimage64.c
index 0f8a6bbaaa44..0b5da62eb203 100644
--- a/arch/x86/kernel/kexec-bzimage64.c
+++ b/arch/x86/kernel/kexec-bzimage64.c
@@ -19,8 +19,7 @@
 #include <linux/kernel.h>
 #include <linux/mm.h>
 #include <linux/efi.h>
-#include <linux/verify_pefile.h>
-#include <keys/system_keyring.h>
+#include <linux/verification.h>
 
 #include <asm/bootparam.h>
 #include <asm/setup.h>
@@ -529,18 +528,9 @@ static int bzImage64_cleanup(void *loader_data)
 #ifdef CONFIG_KEXEC_BZIMAGE_VERIFY_SIG
 static int bzImage64_verify_sig(const char *kernel, unsigned long kernel_len)
 {
-	bool trusted;
-	int ret;
-
-	ret = verify_pefile_signature(kernel, kernel_len,
-				      system_trusted_keyring,
-				      VERIFYING_KEXEC_PE_SIGNATURE,
-				      &trusted);
-	if (ret < 0)
-		return ret;
-	if (!trusted)
-		return -EKEYREJECTED;
-	return 0;
+	return verify_pefile_signature(kernel, kernel_len,
+				       NULL,
+				       VERIFYING_KEXEC_PE_SIGNATURE);
 }
 #endif
 
diff --git a/certs/system_keyring.c b/certs/system_keyring.c
index 2570598b784d..cf55bd3a072a 100644
--- a/certs/system_keyring.c
+++ b/certs/system_keyring.c
@@ -108,16 +108,25 @@ late_initcall(load_system_certificate_list);
 #ifdef CONFIG_SYSTEM_DATA_VERIFICATION
 
 /**
- * Verify a PKCS#7-based signature on system data.
- * @data: The data to be verified.
+ * verify_pkcs7_signature - Verify a PKCS#7-based signature on system data.
+ * @data: The data to be verified (NULL if expecting internal data).
  * @len: Size of @data.
  * @raw_pkcs7: The PKCS#7 message that is the signature.
  * @pkcs7_len: The size of @raw_pkcs7.
+ * @trusted_keys: Trusted keys to use (NULL for system_trusted_keyring).
  * @usage: The use to which the key is being put.
+ * @view_content: Callback to gain access to content.
+ * @ctx: Context for callback.
  */
-int system_verify_data(const void *data, unsigned long len,
-		       const void *raw_pkcs7, size_t pkcs7_len,
-		       enum key_being_used_for usage)
+int verify_pkcs7_signature(const void *data, size_t len,
+			   const void *raw_pkcs7, size_t pkcs7_len,
+			   struct key *trusted_keys,
+			   int untrusted_error,
+			   enum key_being_used_for usage,
+			   int (*view_content)(void *ctx,
+					       const void *data, size_t len,
+					       size_t asn1hdrlen),
+			   void *ctx)
 {
 	struct pkcs7_message *pkcs7;
 	bool trusted;
@@ -128,7 +137,7 @@ int system_verify_data(const void *data, unsigned long len,
 		return PTR_ERR(pkcs7);
 
 	/* The data should be detached - so we need to supply it. */
-	if (pkcs7_supply_detached_data(pkcs7, data, len) < 0) {
+	if (data && pkcs7_supply_detached_data(pkcs7, data, len) < 0) {
 		pr_err("PKCS#7 signature with non-detached data\n");
 		ret = -EBADMSG;
 		goto error;
@@ -138,13 +147,29 @@ int system_verify_data(const void *data, unsigned long len,
 	if (ret < 0)
 		goto error;
 
-	ret = pkcs7_validate_trust(pkcs7, system_trusted_keyring, &trusted);
+	if (!trusted_keys)
+		trusted_keys = system_trusted_keyring;
+	ret = pkcs7_validate_trust(pkcs7, trusted_keys, &trusted);
 	if (ret < 0)
 		goto error;
 
-	if (!trusted) {
+	if (!trusted && untrusted_error) {
 		pr_err("PKCS#7 signature not signed with a trusted key\n");
-		ret = -ENOKEY;
+		ret = untrusted_error;
+		goto error;
+	}
+
+	if (view_content) {
+		size_t asn1hdrlen;
+
+		ret = pkcs7_get_content_data(pkcs7, &data, &len, &asn1hdrlen);
+		if (ret < 0) {
+			if (ret == -ENODATA)
+				pr_devel("PKCS#7 message does not contain data\n");
+			goto error;
+		}
+
+		ret = view_content(ctx, data, len, asn1hdrlen);
 	}
 
 error:
@@ -152,6 +177,6 @@ error:
 	pr_devel("<==%s() = %d\n", __func__, ret);
 	return ret;
 }
-EXPORT_SYMBOL_GPL(system_verify_data);
+EXPORT_SYMBOL_GPL(verify_pkcs7_signature);
 
 #endif /* CONFIG_SYSTEM_DATA_VERIFICATION */
diff --git a/crypto/asymmetric_keys/Kconfig b/crypto/asymmetric_keys/Kconfig
index 4870f28403f5..d071989142b5 100644
--- a/crypto/asymmetric_keys/Kconfig
+++ b/crypto/asymmetric_keys/Kconfig
@@ -61,6 +61,7 @@ config PKCS7_TEST_KEY
 config SIGNED_PE_FILE_VERIFICATION
 	bool "Support for PE file signature verification"
 	depends on PKCS7_MESSAGE_PARSER=y
+	depends on SYSTEM_DATA_VERIFICATION
 	select ASN1
 	select OID_REGISTRY
 	help
diff --git a/crypto/asymmetric_keys/mscode_parser.c b/crypto/asymmetric_keys/mscode_parser.c
index adcef59eec0b..b2fa9eea3ef6 100644
--- a/crypto/asymmetric_keys/mscode_parser.c
+++ b/crypto/asymmetric_keys/mscode_parser.c
@@ -21,19 +21,13 @@
 /*
  * Parse a Microsoft Individual Code Signing blob
  */
-int mscode_parse(struct pefile_context *ctx)
+int mscode_parse(void *_ctx, const void *content_data, size_t data_len,
+		 size_t asn1hdrlen)
 {
-	const void *content_data;
-	size_t data_len;
-	int ret;
-
-	ret = pkcs7_get_content_data(ctx->pkcs7, &content_data, &data_len, 1);
-
-	if (ret) {
-		pr_debug("PKCS#7 message does not contain data\n");
-		return ret;
-	}
+	struct pefile_context *ctx = _ctx;
 
+	content_data -= asn1hdrlen;
+	data_len += asn1hdrlen;
 	pr_devel("Data: %zu [%*ph]\n", data_len, (unsigned)(data_len),
 		 content_data);
 
@@ -129,7 +123,6 @@ int mscode_note_digest(void *context, size_t hdrlen,
 {
 	struct pefile_context *ctx = context;
 
-	ctx->digest = value;
-	ctx->digest_len = vlen;
-	return 0;
+	ctx->digest = kmemdup(value, vlen, GFP_KERNEL);
+	return ctx->digest ? 0 : -ENOMEM;
 }
diff --git a/crypto/asymmetric_keys/pkcs7_key_type.c b/crypto/asymmetric_keys/pkcs7_key_type.c
index e2d0edbbc71a..240a5303ebb7 100644
--- a/crypto/asymmetric_keys/pkcs7_key_type.c
+++ b/crypto/asymmetric_keys/pkcs7_key_type.c
@@ -29,15 +29,37 @@ MODULE_PARM_DESC(pkcs7_usage,
 		 "Usage to specify when verifying the PKCS#7 message");
 
 /*
+ * Retrieve the PKCS#7 message content.
+ */
+static int pkcs7_view_content(void *ctx, const void *data, size_t len,
+			      size_t asn1hdrlen)
+{
+	struct key_preparsed_payload *prep = ctx;
+	const void *saved_prep_data;
+	size_t saved_prep_datalen;
+	int ret;
+
+	kenter(",%zu", len);
+
+	saved_prep_data = prep->data;
+	saved_prep_datalen = prep->datalen;
+	prep->data = data;
+	prep->datalen = len;
+
+	ret = user_preparse(prep);
+
+	prep->data = saved_prep_data;
+	prep->datalen = saved_prep_datalen;
+	kleave(" = %d", ret);
+	return ret;
+}
+
+/*
  * Preparse a PKCS#7 wrapped and validated data blob.
  */
 static int pkcs7_preparse(struct key_preparsed_payload *prep)
 {
 	enum key_being_used_for usage = pkcs7_usage;
-	struct pkcs7_message *pkcs7;
-	const void *data, *saved_prep_data;
-	size_t datalen, saved_prep_datalen;
-	bool trusted;
 	int ret;
 
 	kenter("");
@@ -47,37 +69,11 @@ static int pkcs7_preparse(struct key_preparsed_payload *prep)
 		return -EINVAL;
 	}
 
-	saved_prep_data = prep->data;
-	saved_prep_datalen = prep->datalen;
-	pkcs7 = pkcs7_parse_message(saved_prep_data, saved_prep_datalen);
-	if (IS_ERR(pkcs7)) {
-		ret = PTR_ERR(pkcs7);
-		goto error;
-	}
-
-	ret = pkcs7_verify(pkcs7, usage);
-	if (ret < 0)
-		goto error_free;
-
-	ret = pkcs7_validate_trust(pkcs7, system_trusted_keyring, &trusted);
-	if (ret < 0)
-		goto error_free;
-	if (!trusted)
-		pr_warn("PKCS#7 message doesn't chain back to a trusted key\n");
-
-	ret = pkcs7_get_content_data(pkcs7, &data, &datalen, false);
-	if (ret < 0)
-		goto error_free;
-
-	prep->data = data;
-	prep->datalen = datalen;
-	ret = user_preparse(prep);
-	prep->data = saved_prep_data;
-	prep->datalen = saved_prep_datalen;
+	ret = verify_pkcs7_signature(NULL, 0,
+				     prep->data, prep->datalen,
+				     NULL, -ENOKEY, usage,
+				     pkcs7_view_content, prep);
 
-error_free:
-	pkcs7_free_message(pkcs7);
-error:
 	kleave(" = %d", ret);
 	return ret;
 }
diff --git a/crypto/asymmetric_keys/pkcs7_parser.c b/crypto/asymmetric_keys/pkcs7_parser.c
index 758acabf2d81..7b69783cff99 100644
--- a/crypto/asymmetric_keys/pkcs7_parser.c
+++ b/crypto/asymmetric_keys/pkcs7_parser.c
@@ -165,24 +165,25 @@ EXPORT_SYMBOL_GPL(pkcs7_parse_message);
  * @pkcs7: The preparsed PKCS#7 message to access
  * @_data: Place to return a pointer to the data
  * @_data_len: Place to return the data length
- * @want_wrapper: True if the ASN.1 object header should be included in the data
+ * @_headerlen: Size of ASN.1 header not included in _data
  *
- * Get access to the data content of the PKCS#7 message, including, optionally,
- * the header of the ASN.1 object that contains it.  Returns -ENODATA if the
- * data object was missing from the message.
+ * Get access to the data content of the PKCS#7 message.  The size of the
+ * header of the ASN.1 object that contains it is also provided and can be used
+ * to adjust *_data and *_data_len to get the entire object.
+ *
+ * Returns -ENODATA if the data object was missing from the message.
  */
 int pkcs7_get_content_data(const struct pkcs7_message *pkcs7,
 			   const void **_data, size_t *_data_len,
-			   bool want_wrapper)
+			   size_t *_headerlen)
 {
-	size_t wrapper;
-
 	if (!pkcs7->data)
 		return -ENODATA;
 
-	wrapper = want_wrapper ? pkcs7->data_hdrlen : 0;
-	*_data = pkcs7->data - wrapper;
-	*_data_len = pkcs7->data_len + wrapper;
+	*_data = pkcs7->data;
+	*_data_len = pkcs7->data_len;
+	if (_headerlen)
+		*_headerlen = pkcs7->data_hdrlen;
 	return 0;
 }
 EXPORT_SYMBOL_GPL(pkcs7_get_content_data);
diff --git a/crypto/asymmetric_keys/verify_pefile.c b/crypto/asymmetric_keys/verify_pefile.c
index 897b734dabf9..443a00f9cd7a 100644
--- a/crypto/asymmetric_keys/verify_pefile.c
+++ b/crypto/asymmetric_keys/verify_pefile.c
@@ -16,7 +16,7 @@
 #include <linux/err.h>
 #include <linux/pe.h>
 #include <linux/asn1.h>
-#include <crypto/pkcs7.h>
+#include <linux/verification.h>
 #include <crypto/hash.h>
 #include "verify_pefile.h"
 
@@ -392,9 +392,8 @@ error_no_desc:
  * verify_pefile_signature - Verify the signature on a PE binary image
  * @pebuf: Buffer containing the PE binary image
  * @pelen: Length of the binary image
- * @trust_keyring: Signing certificates to use as starting points
+ * @trust_keys: Signing certificate(s) to use as starting points
  * @usage: The use to which the key is being put.
- * @_trusted: Set to true if trustworth, false otherwise
  *
  * Validate that the certificate chain inside the PKCS#7 message inside the PE
  * binary image intersects keys we already know and trust.
@@ -418,14 +417,10 @@ error_no_desc:
  * May also return -ENOMEM.
  */
 int verify_pefile_signature(const void *pebuf, unsigned pelen,
-			    struct key *trusted_keyring,
-			    enum key_being_used_for usage,
-			    bool *_trusted)
+			    struct key *trusted_keys,
+			    enum key_being_used_for usage)
 {
-	struct pkcs7_message *pkcs7;
 	struct pefile_context ctx;
-	const void *data;
-	size_t datalen;
 	int ret;
 
 	kenter("");
@@ -439,19 +434,10 @@ int verify_pefile_signature(const void *pebuf, unsigned pelen,
 	if (ret < 0)
 		return ret;
 
-	pkcs7 = pkcs7_parse_message(pebuf + ctx.sig_offset, ctx.sig_len);
-	if (IS_ERR(pkcs7))
-		return PTR_ERR(pkcs7);
-	ctx.pkcs7 = pkcs7;
-
-	ret = pkcs7_get_content_data(ctx.pkcs7, &data, &datalen, false);
-	if (ret < 0 || datalen == 0) {
-		pr_devel("PKCS#7 message does not contain data\n");
-		ret = -EBADMSG;
-		goto error;
-	}
-
-	ret = mscode_parse(&ctx);
+	ret = verify_pkcs7_signature(NULL, 0,
+				     pebuf + ctx.sig_offset, ctx.sig_len,
+				     trusted_keys, -EKEYREJECTED, usage,
+				     mscode_parse, &ctx);
 	if (ret < 0)
 		goto error;
 
@@ -462,16 +448,8 @@ int verify_pefile_signature(const void *pebuf, unsigned pelen,
 	 * contents.
 	 */
 	ret = pefile_digest_pe(pebuf, pelen, &ctx);
-	if (ret < 0)
-		goto error;
-
-	ret = pkcs7_verify(pkcs7, usage);
-	if (ret < 0)
-		goto error;
-
-	ret = pkcs7_validate_trust(pkcs7, trusted_keyring, _trusted);
 
 error:
-	pkcs7_free_message(ctx.pkcs7);
+	kfree(ctx.digest);
 	return ret;
 }
diff --git a/crypto/asymmetric_keys/verify_pefile.h b/crypto/asymmetric_keys/verify_pefile.h
index 55d5f7ebc45a..d6341d5406d4 100644
--- a/crypto/asymmetric_keys/verify_pefile.h
+++ b/crypto/asymmetric_keys/verify_pefile.h
@@ -9,7 +9,6 @@
  * 2 of the Licence, or (at your option) any later version.
  */
 
-#include <linux/verify_pefile.h>
 #include <crypto/pkcs7.h>
 #include <crypto/hash_info.h>
 
@@ -23,7 +22,6 @@ struct pefile_context {
 	unsigned	sig_offset;
 	unsigned	sig_len;
 	const struct section_header *secs;
-	struct pkcs7_message *pkcs7;
 
 	/* PKCS#7 MS Individual Code Signing content */
 	const void	*digest;		/* Digest */
@@ -39,4 +37,5 @@ struct pefile_context {
 /*
  * mscode_parser.c
  */
-extern int mscode_parse(struct pefile_context *ctx);
+extern int mscode_parse(void *_ctx, const void *content_data, size_t data_len,
+			size_t asn1hdrlen);
diff --git a/include/crypto/pkcs7.h b/include/crypto/pkcs7.h
index 441aff9b5aa7..8323e3e57131 100644
--- a/include/crypto/pkcs7.h
+++ b/include/crypto/pkcs7.h
@@ -12,6 +12,7 @@
 #ifndef _CRYPTO_PKCS7_H
 #define _CRYPTO_PKCS7_H
 
+#include <linux/verification.h>
 #include <crypto/public_key.h>
 
 struct key;
@@ -26,7 +27,7 @@ extern void pkcs7_free_message(struct pkcs7_message *pkcs7);
 
 extern int pkcs7_get_content_data(const struct pkcs7_message *pkcs7,
 				  const void **_data, size_t *_datalen,
-				  bool want_wrapper);
+				  size_t *_headerlen);
 
 /*
  * pkcs7_trust.c
diff --git a/include/crypto/public_key.h b/include/crypto/public_key.h
index cc2516df0efa..de50d026576d 100644
--- a/include/crypto/public_key.h
+++ b/include/crypto/public_key.h
@@ -39,20 +39,6 @@ enum pkey_id_type {
 extern const char *const pkey_id_type_name[PKEY_ID_TYPE__LAST];
 
 /*
- * The use to which an asymmetric key is being put.
- */
-enum key_being_used_for {
-	VERIFYING_MODULE_SIGNATURE,
-	VERIFYING_FIRMWARE_SIGNATURE,
-	VERIFYING_KEXEC_PE_SIGNATURE,
-	VERIFYING_KEY_SIGNATURE,
-	VERIFYING_KEY_SELF_SIGNATURE,
-	VERIFYING_UNSPECIFIED_SIGNATURE,
-	NR__KEY_BEING_USED_FOR
-};
-extern const char *const key_being_used_for[NR__KEY_BEING_USED_FOR];
-
-/*
  * Cryptographic data for the public-key subtype of the asymmetric key type.
  *
  * Note that this may include private part of the key as well as the public
diff --git a/include/keys/asymmetric-type.h b/include/keys/asymmetric-type.h
index 59c1df9cf922..72c18c1f3308 100644
--- a/include/keys/asymmetric-type.h
+++ b/include/keys/asymmetric-type.h
@@ -15,6 +15,7 @@
 #define _KEYS_ASYMMETRIC_TYPE_H
 
 #include <linux/key-type.h>
+#include <linux/verification.h>
 
 extern struct key_type key_type_asymmetric;
 
diff --git a/include/keys/system_keyring.h b/include/keys/system_keyring.h
index b20cd885c1fd..18e9310b0a36 100644
--- a/include/keys/system_keyring.h
+++ b/include/keys/system_keyring.h
@@ -15,6 +15,7 @@
 #ifdef CONFIG_SYSTEM_TRUSTED_KEYRING
 
 #include <linux/key.h>
+#include <linux/verification.h>
 #include <crypto/public_key.h>
 
 extern struct key *system_trusted_keyring;
@@ -29,10 +30,4 @@ static inline struct key *get_system_trusted_keyring(void)
 }
 #endif
 
-#ifdef CONFIG_SYSTEM_DATA_VERIFICATION
-extern int system_verify_data(const void *data, unsigned long len,
-			      const void *raw_pkcs7, size_t pkcs7_len,
-			      enum key_being_used_for usage);
-#endif
-
 #endif /* _KEYS_SYSTEM_KEYRING_H */
diff --git a/include/linux/verification.h b/include/linux/verification.h
new file mode 100644
index 000000000000..bb0fcf941cb7
--- /dev/null
+++ b/include/linux/verification.h
@@ -0,0 +1,50 @@
+/* Signature verification
+ *
+ * Copyright (C) 2014 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+
+#ifndef _LINUX_VERIFICATION_H
+#define _LINUX_VERIFICATION_H
+
+/*
+ * The use to which an asymmetric key is being put.
+ */
+enum key_being_used_for {
+	VERIFYING_MODULE_SIGNATURE,
+	VERIFYING_FIRMWARE_SIGNATURE,
+	VERIFYING_KEXEC_PE_SIGNATURE,
+	VERIFYING_KEY_SIGNATURE,
+	VERIFYING_KEY_SELF_SIGNATURE,
+	VERIFYING_UNSPECIFIED_SIGNATURE,
+	NR__KEY_BEING_USED_FOR
+};
+extern const char *const key_being_used_for[NR__KEY_BEING_USED_FOR];
+
+#ifdef CONFIG_SYSTEM_DATA_VERIFICATION
+
+struct key;
+
+extern int verify_pkcs7_signature(const void *data, size_t len,
+				  const void *raw_pkcs7, size_t pkcs7_len,
+				  struct key *trusted_keys,
+				  int untrusted_error,
+				  enum key_being_used_for usage,
+				  int (*view_content)(void *ctx,
+						      const void *data, size_t len,
+						      size_t asn1hdrlen),
+				  void *ctx);
+
+#ifdef CONFIG_SIGNED_PE_FILE_VERIFICATION
+extern int verify_pefile_signature(const void *pebuf, unsigned pelen,
+				   struct key *trusted_keys,
+				   enum key_being_used_for usage);
+#endif
+
+#endif /* CONFIG_SYSTEM_DATA_VERIFICATION */
+#endif /* _LINUX_VERIFY_PEFILE_H */
diff --git a/include/linux/verify_pefile.h b/include/linux/verify_pefile.h
deleted file mode 100644
index da2049b5161c..000000000000
--- a/include/linux/verify_pefile.h
+++ /dev/null
@@ -1,22 +0,0 @@
-/* Signed PE file verification
- *
- * Copyright (C) 2014 Red Hat, Inc. All Rights Reserved.
- * Written by David Howells (dhowells@redhat.com)
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public Licence
- * as published by the Free Software Foundation; either version
- * 2 of the Licence, or (at your option) any later version.
- */
-
-#ifndef _LINUX_VERIFY_PEFILE_H
-#define _LINUX_VERIFY_PEFILE_H
-
-#include <crypto/public_key.h>
-
-extern int verify_pefile_signature(const void *pebuf, unsigned pelen,
-				   struct key *trusted_keyring,
-				   enum key_being_used_for usage,
-				   bool *_trusted);
-
-#endif /* _LINUX_VERIFY_PEFILE_H */
diff --git a/kernel/module_signing.c b/kernel/module_signing.c
index 6528a79d998d..70cf0220efeb 100644
--- a/kernel/module_signing.c
+++ b/kernel/module_signing.c
@@ -73,6 +73,7 @@ int mod_verify_sig(const void *mod, unsigned long *_modlen)
 		return -EBADMSG;
 	}
 
-	return system_verify_data(mod, modlen, mod + modlen, sig_len,
-				  VERIFYING_MODULE_SIGNATURE);
+	return verify_pkcs7_signature(mod, modlen, mod + modlen, sig_len,
+				      NULL, -ENOKEY, VERIFYING_MODULE_SIGNATURE,
+				      NULL, NULL);
 }
