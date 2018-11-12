Return-Path: <SRS0=oFif=NX=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from lhrrgout.huawei.com ([185.176.76.210]:32744 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727204AbeKLU1R (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 12 Nov 2018 15:27:17 -0500
From: Roberto Sassu <roberto.sassu@huawei.com>
To: <dhowells@redhat.com>, <dwmw2@infradead.org>,
        <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC: <keyrings@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
        <linux-integrity@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <silviu.vlasceanu@huawei.com>
Subject: [RFC][PATCH 10/12] PGP: Provide a key type for testing PGP signatures
Date: Mon, 12 Nov 2018 11:24:21 +0100
Message-ID: <20181112102423.30415-11-roberto.sassu@huawei.com>
In-Reply-To: <20181112102423.30415-1-roberto.sassu@huawei.com>
References: <20181112102423.30415-1-roberto.sassu@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: David Howells <dhowells@redhat.com>

Provide a key type for testing the PGP signature parser.  It is given a
non-detached PGP message as payload:

	keyctl padd pgp_test a @s <content.txt.gpg

A suitable message can be generated like this:

	echo "This is a test attached-signed content" >content.txt
	gpg --compress-algo=none -s content.txt

Changelog

v0:
- use verify_pgp_signature() to verify signatures with builtin_trusted_keys
  or secondary_trusted_keys (Roberto Sassu)
- use pgp_verify_sig() to verify signatures with keys in the user keyring
  (Roberto Sassu)
- replace user_instantiate with generic_key_instantiate (Roberto Sassu)
- remove .def_lookup_type and .match methods (Roberto Sassu)
- fix style issues (Roberto Sassu)

Signed-off-by: David Howells <dhowells@redhat.com>
Co-developed-by: Roberto Sassu <roberto.sassu@huawei.com>
---
 crypto/asymmetric_keys/Kconfig        |  13 +++
 crypto/asymmetric_keys/Makefile       |   4 +
 crypto/asymmetric_keys/pgp_library.c  |  64 +++++++++++++
 crypto/asymmetric_keys/pgp_test_key.c | 132 ++++++++++++++++++++++++++
 include/linux/pgplib.h                |  15 +++
 5 files changed, 228 insertions(+)
 create mode 100644 crypto/asymmetric_keys/pgp_test_key.c

diff --git a/crypto/asymmetric_keys/Kconfig b/crypto/asymmetric_keys/Kconfig
index 356b85fc34bd..8226d06fe1e0 100644
--- a/crypto/asymmetric_keys/Kconfig
+++ b/crypto/asymmetric_keys/Kconfig
@@ -110,4 +110,17 @@ config PGP_KEY_PARSER
 	  for key data and provides the ability to instantiate a crypto key
 	  from a public key packet found inside the blob.
 
+config PGP_TEST_KEY
+	tristate "PGP testing key type"
+	depends on PGP_KEY_PARSER
+	depends on SYSTEM_DATA_VERIFICATION
+	help
+	  This option provides a type of key that can be loaded up from a
+	  PGP message - provided the message is signed by a trusted key.  If
+	  it is, the PGP wrapper is discarded and reading the key returns
+	  just the payload.  If it isn't, adding the key will fail with an
+	  error.
+
+	  This is intended for testing the PGP parser.
+
 endif # ASYMMETRIC_KEY_TYPE
diff --git a/crypto/asymmetric_keys/Makefile b/crypto/asymmetric_keys/Makefile
index e2aeb2a4b6a6..48bbe2b1d446 100644
--- a/crypto/asymmetric_keys/Makefile
+++ b/crypto/asymmetric_keys/Makefile
@@ -96,3 +96,7 @@ obj-$(CONFIG_PGP_KEY_PARSER) += pgp_key_parser.o
 pgp_key_parser-y := \
 	pgp_public_key.o \
 	pgp_signature.o
+obj-$(CONFIG_PGP_TEST_KEY) += pgp_test.o
+pgp_test-y := \
+	pgp_test_key.o \
+	pgp_signature.o
diff --git a/crypto/asymmetric_keys/pgp_library.c b/crypto/asymmetric_keys/pgp_library.c
index 13bfc9db1ae4..3a2bd73f1915 100644
--- a/crypto/asymmetric_keys/pgp_library.c
+++ b/crypto/asymmetric_keys/pgp_library.c
@@ -559,3 +559,67 @@ int pgp_parse_sig_params(const u8 **_data, size_t *_datalen,
 	return 0;
 }
 EXPORT_SYMBOL_GPL(pgp_parse_sig_params);
+
+#if IS_ENABLED(CONFIG_PGP_TEST_KEY)
+
+/**
+ * pgp_parse_literal_data - Parse basic params from a PGP literal data packet
+ * @data: Content of packet
+ * @datalen: Length of packet remaining
+ * @p: The basic parameters
+ *
+ * Parse the basic parameters from a PGP literal data packet [RFC 4880: 5.9]
+ * that are needed to work out what form the data is in and where it is.
+ *
+ * Returns 0 if successful or a negative error code.
+ */
+int pgp_parse_literal_data(const u8 *data, size_t datalen,
+			   struct pgp_literal_data_parameters *p)
+{
+	unsigned int tmp;
+
+	pr_devel("-->%s(,%zu,,)\n", __func__, datalen);
+
+	if (datalen < 6)
+		goto too_short;
+	datalen -= 6;
+
+	p->format = *data++;
+	switch (p->format) {
+	case PGP_LIT_FORMAT_BINARY:
+	case PGP_LIT_FORMAT_TEXT:
+	case PGP_LIT_FORMAT_TEXT_UTF8:
+		break;
+	default:
+		pr_debug("Literal data packet with unhandled format %02x\n",
+			 p->format);
+		return -EBADMSG;
+	}
+
+	p->filename_len = *data++;
+	p->filename_offset = 2;
+	if (datalen < p->filename_len)
+		goto too_short;
+	data += p->filename_len;
+	datalen -= p->filename_len;
+
+	tmp  = *data++ << 24;
+	tmp |= *data++ << 16;
+	tmp |= *data++ << 8;
+	tmp |= *data++;
+	p->time = tmp;
+
+	p->content_offset = 6 + p->filename_len;
+	p->content_len = datalen;
+
+	pr_devel("%x,%u,%x,%u\n",
+		 p->format, p->filename_len, p->time, p->content_len);
+	return 0;
+
+too_short:
+	pr_debug("Literal data packet too short\n");
+	return -EBADMSG;
+}
+EXPORT_SYMBOL_GPL(pgp_parse_literal_data);
+
+#endif /* CONFIG_PGP_TEST_KEY */
diff --git a/crypto/asymmetric_keys/pgp_test_key.c b/crypto/asymmetric_keys/pgp_test_key.c
new file mode 100644
index 000000000000..55bc6cad8559
--- /dev/null
+++ b/crypto/asymmetric_keys/pgp_test_key.c
@@ -0,0 +1,132 @@
+/* Testing module to load key from trusted PGP message
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
+#define pr_fmt(fmt) "PGPtest: "fmt
+#include <linux/key.h>
+#include <linux/key-type.h>
+#include <linux/cred.h>
+#include <linux/err.h>
+#include <linux/pgp.h>
+#include <linux/pgplib.h>
+#include <linux/pgp_sig.h>
+#include <linux/module.h>
+#include <linux/verification.h>
+#include <keys/user-type.h>
+#include <keys/system_keyring.h>
+#include "pgp_parser.h"
+
+MODULE_LICENSE("GPL");
+
+struct pgp_test_parse_context {
+	struct pgp_parse_context pgp;
+	struct pgp_literal_data_parameters params;
+	const void *content;
+};
+
+static int pgp_test_parse_data(struct pgp_parse_context *context,
+			       enum pgp_packet_tag type,
+			       u8 headerlen,
+			       const u8 *data,
+			       size_t datalen)
+{
+	struct pgp_test_parse_context *ctx =
+		container_of(context, struct pgp_test_parse_context, pgp);
+	int ret;
+
+	kenter("");
+
+	ret = pgp_parse_literal_data(data, datalen, &ctx->params);
+	if (ret == 0)
+		ctx->content = data + ctx->params.content_offset;
+	return ret;
+}
+
+/*
+ * Instantiate a PGP wrapped and validated key.
+ */
+static int pgp_test_instantiate(struct key *key,
+				struct key_preparsed_payload *prep)
+{
+	struct pgp_test_parse_context p;
+	const void *saved_prep_data;
+	size_t saved_prep_datalen;
+	int ret;
+
+	kenter("");
+
+	if (!current_cred()->user->uid_keyring)
+		return -ENOKEY;
+
+	memset(&p, 0, sizeof(p));
+	p.pgp.types_of_interest = (1 << PGP_PKT_LITERAL_DATA);
+	p.pgp.process_packet = pgp_test_parse_data;
+	ret = pgp_parse_packets(prep->data, prep->datalen, &p.pgp);
+	if (ret < 0) {
+		kleave(" = %d [parse]", ret);
+		return ret;
+	}
+
+	if (!p.params.content_len) {
+		kleave(" = -ENODATA [no literal data");
+		return -ENODATA;
+	}
+
+	ret = verify_pgp_signature(p.content, p.params.content_len,
+				   NULL, 0, prep->data, prep->datalen, NULL);
+	if (ret < 0) {
+		ret = pgp_verify_sig(NULL, p.content, p.params.content_len,
+				     NULL, 0, prep->data, prep->datalen);
+		if (ret < 0)
+			goto error;
+
+		pr_warn("PGP message doesn't chain back to a trusted key\n");
+	}
+
+	saved_prep_data = prep->data;
+	saved_prep_datalen = prep->datalen;
+	prep->data = p.content;
+	prep->datalen = p.params.content_len;
+	ret = generic_key_instantiate(key, prep);
+	prep->data = saved_prep_data;
+	prep->datalen = saved_prep_datalen;
+error:
+	kleave(" = %d", ret);
+	return ret;
+}
+
+/*
+ * user defined keys take an arbitrary string as the description and an
+ * arbitrary blob of data as the payload
+ */
+static struct key_type key_type_pgp_test = {
+	.name			= "pgp_test",
+	.instantiate		= pgp_test_instantiate,
+	.revoke			= user_revoke,
+	.destroy		= user_destroy,
+	.describe		= user_describe,
+	.read			= user_read,
+};
+
+/*
+ * Module stuff
+ */
+static int __init pgp_key_init(void)
+{
+	return register_key_type(&key_type_pgp_test);
+}
+
+static void __exit pgp_key_cleanup(void)
+{
+	unregister_key_type(&key_type_pgp_test);
+}
+
+module_init(pgp_key_init);
+module_exit(pgp_key_cleanup);
diff --git a/include/linux/pgplib.h b/include/linux/pgplib.h
index 44c8a07b32e3..21999bfe8e2a 100644
--- a/include/linux/pgplib.h
+++ b/include/linux/pgplib.h
@@ -66,6 +66,21 @@ struct pgp_sig_parameters {
 extern int pgp_parse_sig_params(const u8 **_data, size_t *_datalen,
 				struct pgp_sig_parameters *p);
 
+#if IS_ENABLED(CONFIG_PGP_TEST_KEY)
+
+struct pgp_literal_data_parameters {
+	enum pgp_literal_data_format format : 8;
+	u8 filename_len;
+	u8 filename_offset;
+	u8 content_offset;
+	u32 content_len;
+	u32 time;
+};
+
+extern int pgp_parse_literal_data(const u8 *data, size_t datalen,
+				  struct pgp_literal_data_parameters *p);
+
+#endif /* CONFIG_PGP_TEST_KEY */
 
 #endif /* CONFIG_PGP_LIBRARY */
 
-- 
2.17.1
