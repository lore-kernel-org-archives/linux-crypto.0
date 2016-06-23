From: David Howells <dhowells@redhat.com>
Subject: [PATCH 8/8] KEYS: Implement PKCS#8 RSA Private Key parser [ver #2]
Date: Thu, 23 Jun 2016 14:48:35 +0100
Message-ID: <146668971498.2977.8870125865862339946.stgit@warthog.procyon.org.uk>
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
Received: from mx1.redhat.com ([209.132.183.28]:43944 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751746AbcFWNsh (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 23 Jun 2016 09:48:37 -0400
In-Reply-To: <146668965425.2977.13357101274301968911.stgit@warthog.procyon.org.uk>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Implement PKCS#8 RSA Private Key format [RFC 5208] parser for the
asymmetric key type.  For the moment, this will only support unencrypted
DER blobs.  PEM and decryption can be added later.

PKCS#8 keys can be loaded like this:

	openssl pkcs8 -in private_key.pem -topk8 -nocrypt -outform DER | \
	  keyctl padd asymmetric foo @s

Signed-off-by: David Howells <dhowells@redhat.com>
---

 Documentation/crypto/asymmetric-keys.txt |    2 
 crypto/asymmetric_keys/Kconfig           |   10 ++
 crypto/asymmetric_keys/Makefile          |   13 ++
 crypto/asymmetric_keys/pkcs8.asn1        |   24 ++++
 crypto/asymmetric_keys/pkcs8_parser.c    |  184 ++++++++++++++++++++++++++++++
 5 files changed, 233 insertions(+)
 create mode 100644 crypto/asymmetric_keys/pkcs8.asn1
 create mode 100644 crypto/asymmetric_keys/pkcs8_parser.c

diff --git a/Documentation/crypto/asymmetric-keys.txt b/Documentation/crypto/asymmetric-keys.txt
index cdf2aca41b2c..80d45b5776b0 100644
--- a/Documentation/crypto/asymmetric-keys.txt
+++ b/Documentation/crypto/asymmetric-keys.txt
@@ -247,6 +247,8 @@ Examples of blob formats for which parsers could be implemented include:
  - X.509 ASN.1 stream.
  - Pointer to TPM key.
  - Pointer to UEFI key.
+ - PKCS#8 private key [RFC 5208].
+ - PKCS#5 encrypted private key [RFC 2898].
 
 During key instantiation each parser in the list is tried until one doesn't
 return -EBADMSG.
diff --git a/crypto/asymmetric_keys/Kconfig b/crypto/asymmetric_keys/Kconfig
index 331f6baf2df8..338fbed30a32 100644
--- a/crypto/asymmetric_keys/Kconfig
+++ b/crypto/asymmetric_keys/Kconfig
@@ -30,6 +30,16 @@ config X509_CERTIFICATE_PARSER
 	  data and provides the ability to instantiate a crypto key from a
 	  public key packet found inside the certificate.
 
+config PKCS8_PRIVATE_KEY_PARSER
+	tristate "PKCS#8 private key parser"
+	depends on ASYMMETRIC_PUBLIC_KEY_SUBTYPE
+	select ASN1
+	select OID_REGISTRY
+	help
+	  This option provides support for parsing PKCS#8 format blobs for
+	  private key data and provides the ability to instantiate a crypto key
+	  from that data.
+
 config PKCS7_MESSAGE_PARSER
 	tristate "PKCS#7 message parser"
 	depends on X509_CERTIFICATE_PARSER
diff --git a/crypto/asymmetric_keys/Makefile b/crypto/asymmetric_keys/Makefile
index 6516855bec18..ac877577d677 100644
--- a/crypto/asymmetric_keys/Makefile
+++ b/crypto/asymmetric_keys/Makefile
@@ -32,6 +32,19 @@ clean-files	+= x509-asn1.c x509-asn1.h
 clean-files	+= x509_akid-asn1.c x509_akid-asn1.h
 
 #
+# PKCS#8 private key handling
+#
+obj-$(CONFIG_PKCS8_PRIVATE_KEY_PARSER) += pkcs8_key_parser.o
+pkcs8_key_parser-y := \
+	pkcs8-asn1.o \
+	pkcs8_parser.o
+
+$(obj)/pkcs8_parser.o: $(obj)/pkcs8-asn1.h
+$(obj)/pkcs8-asn1.o: $(obj)/pkcs8-asn1.c $(obj)/pkcs8-asn1.h
+
+clean-files	+= pkcs8-asn1.c pkcs8-asn1.h
+
+#
 # PKCS#7 message handling
 #
 obj-$(CONFIG_PKCS7_MESSAGE_PARSER) += pkcs7_message.o
diff --git a/crypto/asymmetric_keys/pkcs8.asn1 b/crypto/asymmetric_keys/pkcs8.asn1
new file mode 100644
index 000000000000..702c41a3c713
--- /dev/null
+++ b/crypto/asymmetric_keys/pkcs8.asn1
@@ -0,0 +1,24 @@
+--
+-- This is the unencrypted variant
+--
+PrivateKeyInfo ::= SEQUENCE {
+	version			Version,
+	privateKeyAlgorithm	PrivateKeyAlgorithmIdentifier,
+	privateKey		PrivateKey,
+	attributes		[0] IMPLICIT Attributes OPTIONAL
+}
+
+Version ::= INTEGER  ({ pkcs8_note_version })
+
+PrivateKeyAlgorithmIdentifier ::= AlgorithmIdentifier ({ pkcs8_note_algo })
+
+PrivateKey ::= OCTET STRING ({ pkcs8_note_key })
+
+Attributes ::= SET OF Attribute
+
+Attribute ::= ANY
+
+AlgorithmIdentifier ::= SEQUENCE {
+	algorithm   OBJECT IDENTIFIER ({ pkcs8_note_OID }),
+	parameters  ANY OPTIONAL
+}
diff --git a/crypto/asymmetric_keys/pkcs8_parser.c b/crypto/asymmetric_keys/pkcs8_parser.c
new file mode 100644
index 000000000000..26a73c0b7eef
--- /dev/null
+++ b/crypto/asymmetric_keys/pkcs8_parser.c
@@ -0,0 +1,184 @@
+/* PKCS#8 Private Key parser [RFC 5208].
+ *
+ * Copyright (C) 2016 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+
+#define pr_fmt(fmt) "PKCS8: "fmt
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/export.h>
+#include <linux/slab.h>
+#include <linux/err.h>
+#include <linux/oid_registry.h>
+#include <keys/asymmetric-subtype.h>
+#include <keys/asymmetric-parser.h>
+#include <crypto/public_key.h>
+#include "pkcs8-asn1.h"
+
+struct pkcs8_parse_context {
+	struct public_key *pub;
+	unsigned long	data;			/* Start of data */
+	enum OID	last_oid;		/* Last OID encountered */
+	enum OID	algo_oid;		/* Algorithm OID */
+	u32		key_size;
+	const void	*key;
+};
+
+/*
+ * Note an OID when we find one for later processing when we know how to
+ * interpret it.
+ */
+int pkcs8_note_OID(void *context, size_t hdrlen,
+		   unsigned char tag,
+		   const void *value, size_t vlen)
+{
+	struct pkcs8_parse_context *ctx = context;
+
+	ctx->last_oid = look_up_OID(value, vlen);
+	if (ctx->last_oid == OID__NR) {
+		char buffer[50];
+
+		sprint_oid(value, vlen, buffer, sizeof(buffer));
+		pr_info("Unknown OID: [%lu] %s\n",
+			(unsigned long)value - ctx->data, buffer);
+	}
+	return 0;
+}
+
+/*
+ * Note the version number of the ASN.1 blob.
+ */
+int pkcs8_note_version(void *context, size_t hdrlen,
+		       unsigned char tag,
+		       const void *value, size_t vlen)
+{
+	if (vlen != 1 || ((const u8 *)value)[0] != 0) {
+		pr_warn("Unsupported PKCS#8 version\n");
+		return -EBADMSG;
+	}
+	return 0;
+}
+
+/*
+ * Note the public algorithm.
+ */
+int pkcs8_note_algo(void *context, size_t hdrlen,
+		    unsigned char tag,
+		    const void *value, size_t vlen)
+{
+	struct pkcs8_parse_context *ctx = context;
+
+	if (ctx->last_oid != OID_rsaEncryption)
+		return -ENOPKG;
+
+	ctx->pub->pkey_algo = "rsa";
+	return 0;
+}
+
+/*
+ * Note the key data of the ASN.1 blob.
+ */
+int pkcs8_note_key(void *context, size_t hdrlen,
+		   unsigned char tag,
+		   const void *value, size_t vlen)
+{
+	struct pkcs8_parse_context *ctx = context;
+
+	ctx->key = value;
+	ctx->key_size = vlen;
+	return 0;
+}
+
+/*
+ * Parse a PKCS#8 private key blob.
+ */
+static struct public_key *pkcs8_parse(const void *data, size_t datalen)
+{
+	struct pkcs8_parse_context ctx;
+	struct public_key *pub;
+	long ret;
+
+	memset(&ctx, 0, sizeof(ctx));
+
+	ret = -ENOMEM;
+	ctx.pub = kzalloc(sizeof(struct public_key), GFP_KERNEL);
+	if (!ctx.pub)
+		goto error;
+
+	ctx.data = (unsigned long)data;
+
+	/* Attempt to decode the private key */
+	ret = asn1_ber_decoder(&pkcs8_decoder, &ctx, data, datalen);
+	if (ret < 0)
+		goto error_decode;
+
+	ret = -ENOMEM;
+	pub = ctx.pub;
+	pub->key = kmemdup(ctx.key, ctx.key_size, GFP_KERNEL);
+	if (!pub->key)
+		goto error_decode;
+
+	pub->keylen = ctx.key_size;
+	pub->key_is_private = true;
+	return pub;
+
+error_decode:
+	kfree(ctx.pub);
+error:
+	return ERR_PTR(ret);
+}
+
+/*
+ * Attempt to parse a data blob for a key as a PKCS#8 private key.
+ */
+static int pkcs8_key_preparse(struct key_preparsed_payload *prep)
+{
+	struct public_key *pub;
+
+	pub = pkcs8_parse(prep->data, prep->datalen);
+	if (IS_ERR(pub))
+		return PTR_ERR(pub);
+
+	pr_devel("Cert Key Algo: %s\n", pub->pkey_algo);
+	pub->id_type = "PKCS8";
+
+	/* We're pinning the module by being linked against it */
+	__module_get(public_key_subtype.owner);
+	prep->payload.data[asym_subtype] = &public_key_subtype;
+	prep->payload.data[asym_key_ids] = NULL;
+	prep->payload.data[asym_crypto] = pub;
+	prep->payload.data[asym_auth] = NULL;
+	prep->quotalen = 100;
+	return 0;
+}
+
+static struct asymmetric_key_parser pkcs8_key_parser = {
+	.owner	= THIS_MODULE,
+	.name	= "pkcs8",
+	.parse	= pkcs8_key_preparse,
+};
+
+/*
+ * Module stuff
+ */
+static int __init pkcs8_key_init(void)
+{
+	return register_asymmetric_key_parser(&pkcs8_key_parser);
+}
+
+static void __exit pkcs8_key_exit(void)
+{
+	unregister_asymmetric_key_parser(&pkcs8_key_parser);
+}
+
+module_init(pkcs8_key_init);
+module_exit(pkcs8_key_exit);
+
+MODULE_DESCRIPTION("PKCS#8 certificate parser");
+MODULE_LICENSE("GPL");
