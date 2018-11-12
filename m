Return-Path: <SRS0=oFif=NX=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from lhrrgout.huawei.com ([185.176.76.210]:32745 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727156AbeKLU2f (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 12 Nov 2018 15:28:35 -0500
From: Roberto Sassu <roberto.sassu@huawei.com>
To: <dhowells@redhat.com>, <dwmw2@infradead.org>,
        <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC: <keyrings@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
        <linux-integrity@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <silviu.vlasceanu@huawei.com>
Subject: [RFC][PATCH 11/12] KEYS: Provide a function to load keys from a PGP keyring blob
Date: Mon, 12 Nov 2018 11:24:22 +0100
Message-ID: <20181112102423.30415-12-roberto.sassu@huawei.com>
In-Reply-To: <20181112102423.30415-1-roberto.sassu@huawei.com>
References: <20181112102423.30415-1-roberto.sassu@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: David Howells <dhowells@redhat.com>

Provide a function to load keys from a PGP keyring blob for use in
initialising the module signing key keyring:

	int preload_pgp_keys(const u8 *pgpdata, size_t pgpdatalen,
			     struct key *keyring);

Descriptions are generated from user ID notes and key fingerprints.  The
keys will actually be identified by the ID calculated from the PGP data
rather than by the description, so this shouldn't be a problem.

The keys are attached to the keyring supplied.

Looking as root in /proc/keys after the module signing keyring has been
loaded:

383a00c1 I------     1 perm 1f030000     0     0 asymmetri \
				Red Hat, Inc. dbeca166: PGP.DSA dbeca166 []

Thanks to Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp> for some
pointing out some errors.

Changelog

v0:
- avoid Kconfig circular dependency (Roberto Sassu)
- modify flags passed to key_create_or_update() (Roberto Sassu)
- don't process Public-Subkey packets (Roberto Sassu)

Signed-off-by: David Howells <dhowells@redhat.com>
Co-developed-by: Roberto Sassu <roberto.sassu@huawei.com>
---
 crypto/asymmetric_keys/Kconfig       |   8 ++
 crypto/asymmetric_keys/Makefile      |   1 +
 crypto/asymmetric_keys/pgp_preload.c | 118 +++++++++++++++++++++++++++
 include/linux/pgp_sig.h              |   3 +
 4 files changed, 130 insertions(+)
 create mode 100644 crypto/asymmetric_keys/pgp_preload.c

diff --git a/crypto/asymmetric_keys/Kconfig b/crypto/asymmetric_keys/Kconfig
index 8226d06fe1e0..f0b4e3ccf1b8 100644
--- a/crypto/asymmetric_keys/Kconfig
+++ b/crypto/asymmetric_keys/Kconfig
@@ -123,4 +123,12 @@ config PGP_TEST_KEY
 
 	  This is intended for testing the PGP parser.
 
+config PGP_PRELOAD
+	bool "PGP public key preloading facility"
+	select PGP_KEY_PARSER
+	help
+	  This option provides a facility for the kernel to preload PGP-wrapped
+	  bundles of keys during boot.  It is used by module signing to load
+	  the module signing keys for example.
+
 endif # ASYMMETRIC_KEY_TYPE
diff --git a/crypto/asymmetric_keys/Makefile b/crypto/asymmetric_keys/Makefile
index 48bbe2b1d446..c04a103a99c5 100644
--- a/crypto/asymmetric_keys/Makefile
+++ b/crypto/asymmetric_keys/Makefile
@@ -91,6 +91,7 @@ $(obj)/tpm.asn1.o: $(obj)/tpm.asn1.c $(obj)/tpm.asn1.h
 # PGP handling
 #
 obj-$(CONFIG_PGP_LIBRARY) += pgp_library.o
+obj-$(CONFIG_PGP_PRELOAD) += pgp_preload.o
 
 obj-$(CONFIG_PGP_KEY_PARSER) += pgp_key_parser.o
 pgp_key_parser-y := \
diff --git a/crypto/asymmetric_keys/pgp_preload.c b/crypto/asymmetric_keys/pgp_preload.c
new file mode 100644
index 000000000000..7cabade16780
--- /dev/null
+++ b/crypto/asymmetric_keys/pgp_preload.c
@@ -0,0 +1,118 @@
+/* Cryptographic key request handling
+ *
+ * Copyright (C) 2011 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ *
+ * See Documentation/security/keys-crypto.txt
+ */
+
+#include <linux/module.h>
+#include <linux/key.h>
+#include <linux/pgp_sig.h>
+#include <linux/pgplib.h>
+#include <linux/err.h>
+#include <keys/asymmetric-type.h>
+
+struct preload_pgp_keys_context {
+	struct pgp_parse_context pgp;
+	key_ref_t keyring;
+	const u8 *key_start;
+	const u8 *key_end;
+	bool found_key;
+};
+
+/*
+ * Create a key.
+ */
+static int __init create_pgp_key(struct preload_pgp_keys_context *ctx)
+{
+	key_ref_t key;
+
+	key = key_create_or_update(ctx->keyring,
+				   "asymmetric",
+				   NULL,
+				   ctx->key_start,
+				   ctx->key_end - ctx->key_start,
+				   ((KEY_POS_ALL & ~KEY_POS_SETATTR) |
+				    KEY_USR_VIEW | KEY_USR_READ),
+				   KEY_ALLOC_NOT_IN_QUOTA |
+				   KEY_ALLOC_BUILT_IN |
+				   KEY_ALLOC_BYPASS_RESTRICTION);
+	if (IS_ERR(key))
+		return PTR_ERR(key);
+
+	pr_notice("Loaded PGP key '%s'\n",
+		  key_ref_to_ptr(key)->description);
+
+	key_ref_put(key);
+	return 0;
+}
+
+/*
+ * Extract a public key or subkey from the PGP stream.
+ */
+static int __init found_pgp_key(struct pgp_parse_context *context,
+				enum pgp_packet_tag type, u8 headerlen,
+				const u8 *data, size_t datalen)
+{
+	struct preload_pgp_keys_context *ctx =
+		container_of(context, struct preload_pgp_keys_context, pgp);
+	int ret;
+
+	if (ctx->found_key) {
+		ctx->key_end = data - headerlen;
+		ret = create_pgp_key(ctx);
+		if (ret < 0)
+			return ret;
+	}
+
+	ctx->key_start = data - headerlen;
+	ctx->found_key = true;
+	return 0;
+}
+
+/**
+ * preload_pgp_keys - Load keys from a PGP keyring blob
+ * @pgpdata: The PGP keyring blob containing the keys.
+ * @pgpdatalen: The size of the @pgpdata blob.
+ * @keyring: The keyring to add the new keys to.
+ *
+ * Preload a pack of keys from a PGP keyring blob.
+ *
+ * The keys have their descriptions generated from the user ID and fingerprint
+ * in the PGP stream.  Since keys can be matched on their key IDs independently
+ * of the key description, the description is mostly irrelevant apart from the
+ * fact that keys of the same description displace one another from a keyring.
+ *
+ * The caller should override the current creds if they want the keys to be
+ * owned by someone other than the current process's owner.  Keys will not be
+ * accounted towards the owner's quota.
+ *
+ * This function may only be called whilst the kernel is booting.
+ */
+int __init preload_pgp_keys(const u8 *pgpdata, size_t pgpdatalen,
+			    struct key *keyring)
+{
+	struct preload_pgp_keys_context ctx;
+	int ret;
+
+	ctx.pgp.types_of_interest = (1 << PGP_PKT_PUBLIC_KEY);
+	ctx.pgp.process_packet = found_pgp_key;
+	ctx.keyring = make_key_ref(keyring, 1);
+	ctx.found_key = false;
+
+	ret = pgp_parse_packets(pgpdata, pgpdatalen, &ctx.pgp);
+	if (ret < 0)
+		return ret;
+
+	if (ctx.found_key) {
+		ctx.key_end = pgpdata + pgpdatalen;
+		return create_pgp_key(&ctx);
+	}
+	return 0;
+}
diff --git a/include/linux/pgp_sig.h b/include/linux/pgp_sig.h
index d7c6fb6c61aa..c0114cfc2f20 100644
--- a/include/linux/pgp_sig.h
+++ b/include/linux/pgp_sig.h
@@ -18,4 +18,7 @@ int pgp_verify_sig(struct key *keyring, const u8 *raw_data, size_t raw_datalen,
 		   const u8 *digest, size_t digest_size, const u8 *sig_data,
 		   size_t sig_datalen);
 
+int __init preload_pgp_keys(const u8 *pgpdata, size_t pgpdatalen,
+			    struct key *keyring);
+
 #endif /* _LINUX_PGP_SIG_H */
-- 
2.17.1
