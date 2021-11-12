Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 501FDC433EF
	for <linux-crypto@archiver.kernel.org>; Fri, 12 Nov 2021 17:39:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 31FCB60FE3
	for <linux-crypto@archiver.kernel.org>; Fri, 12 Nov 2021 17:39:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235420AbhKLRmq (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 12 Nov 2021 12:42:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:47328 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233404AbhKLRmp (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 12 Nov 2021 12:42:45 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 729F960FE7;
        Fri, 12 Nov 2021 17:39:54 +0000 (UTC)
From:   Chuck Lever <chuck.lever@oracle.com>
To:     dhowells@redhat.com
Cc:     ak@tempesta-tech.com, linux-crypto@vger.kernel.org
Subject: [PATCH Strawman] crypto: Handle PEM-encoded x.509 certificates
Date:   Fri, 12 Nov 2021 12:39:52 -0500
Message-Id:  <163673838611.45802.5085223391786276660.stgit@morisot.1015granger.net>
X-Mailer: git-send-email 2.33.0
User-Agent: StGit/1.4
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Developer-Signature: v=1; a=openpgp-sha256; l=11131; h=from:subject:message-id; bh=qKTUvTIVw8p+7BNq59Lhbz1JipQqS8JAzjd2dgeXDvU=; b=owEBbQKS/ZANAwAIATNqszNvZn+XAcsmYgBhjqbimfjqDvQJslhMdQd5hbL8ixIT88pDP97Sif5N A4TjfNmJAjMEAAEIAB0WIQQosuWwEobfJDzyPv4zarMzb2Z/lwUCYY6m4gAKCRAzarMzb2Z/lx2xD/ 48O9Jjpe6DtSJHg0hQXgf5JfZbEbxbSKY2xiaXbHpi/jJcZ2D4rGCLD76cOPXhXyqcTpMfp24jggCR ja9YfL1rhG9K3Bn8H3uyqKCwn7qHQ/InFcNo+stJ5WUFPAhI6SiNHugXuw4M4JWkO4bAdZj9JJB0Jm VLbmUPiXuCKtcy18tBXppg69lMAeWZfZ0dN5F5s1sZQUI1M7EvHkYxrmXPEuCPCSLDActiD0b0R8HF imFSrUBnLqDriknOfbDo19aiMRBzImCB2mgP3ao2S10rkoJ9fq3S5FECAFCYFKe/ntbUn8dh/wAVgY iMhNG/22IOjM36XOsL3AGWSA3Zaj9aBVFc8f7eze80yvcnuQmN2qoBXutn5R9SQuWvaFFvPKn9qwKf +JYYkdd9FXyPmMeTeGfn0jL8TWk184lm/ZoCfMp3d0AuLADhuF9afcGXRTcNTrP4yyDYEdV2GEMJjO LENUE1DShSQmN3F2uXBd44jq9rgD0d3d3IeigC1Tn9c5OYjAF9ytRJFZRJMJc7423qGh9TyEhQAm7k 3QiT1O2nqkUAV+e3oi189pdeo1s6YRd42S8tuHv4fHKJeit6xsUkDEA+CS2FP9w4THhzoLmB9ZZTUp jccQ6NzkzF8O0yNM4LO0NNpvbVNqFT2f/kLMudkqNQuxkd+tUHcZKlNDvoCQ==
X-Developer-Key: i=chuck.lever@oracle.com; a=openpgp; fpr=28B2E5B01286DF243CF23EFE336AB3336F667F97
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This enables "# cat cert.pem | keyctl padd asymmetric <keyring>"

Since prep->data is a "const void *" I didn't feel comfortable with
pem_decode() simply overwriting either the pointer or the contents
of the provided buffer. A secondary buffer is therefore allocated,
and then later freed by .free_preparse.

This compiles, but is otherwise untested. I'm interested in opinions
about this approach.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 crypto/asymmetric_keys/Makefile          |    3 
 crypto/asymmetric_keys/asymmetric_type.c |    7 +
 crypto/asymmetric_keys/pem.c             |  185 ++++++++++++++++++++++++++++++
 crypto/asymmetric_keys/pem.h             |    8 +
 crypto/asymmetric_keys/pkcs8_parser.c    |    5 +
 crypto/asymmetric_keys/x509_public_key.c |    5 +
 include/linux/key-type.h                 |    2 
 7 files changed, 212 insertions(+), 3 deletions(-)
 create mode 100644 crypto/asymmetric_keys/pem.c
 create mode 100644 crypto/asymmetric_keys/pem.h

diff --git a/crypto/asymmetric_keys/Makefile b/crypto/asymmetric_keys/Makefile
index 28b91adba2ae..1df8c976dd2f 100644
--- a/crypto/asymmetric_keys/Makefile
+++ b/crypto/asymmetric_keys/Makefile
@@ -8,7 +8,8 @@ obj-$(CONFIG_ASYMMETRIC_KEY_TYPE) += asymmetric_keys.o
 asymmetric_keys-y := \
 	asymmetric_type.o \
 	restrict.o \
-	signature.o
+	signature.o \
+	pem.o
 
 obj-$(CONFIG_ASYMMETRIC_PUBLIC_KEY_SUBTYPE) += public_key.o
 obj-$(CONFIG_ASYMMETRIC_TPM_KEY_SUBTYPE) += asym_tpm.o
diff --git a/crypto/asymmetric_keys/asymmetric_type.c b/crypto/asymmetric_keys/asymmetric_type.c
index ad8af3d70ac0..f5d810c079b6 100644
--- a/crypto/asymmetric_keys/asymmetric_type.c
+++ b/crypto/asymmetric_keys/asymmetric_type.c
@@ -12,10 +12,12 @@
 #include <linux/seq_file.h>
 #include <linux/module.h>
 #include <linux/slab.h>
+#include <linux/vmalloc.h>
 #include <linux/ctype.h>
 #include <keys/system_keyring.h>
 #include <keys/user-type.h>
 #include "asymmetric_keys.h"
+#include "pem.h"
 
 MODULE_LICENSE("GPL");
 
@@ -378,6 +380,10 @@ static int asymmetric_key_preparse(struct key_preparsed_payload *prep)
 	if (prep->datalen == 0)
 		return -EINVAL;
 
+	ret = pem_decode(prep);
+	if (ret < 0)
+		return ret;
+
 	down_read(&asymmetric_key_parsers_sem);
 
 	ret = -EBADMSG;
@@ -428,6 +434,7 @@ static void asymmetric_key_free_preparse(struct key_preparsed_payload *prep)
 	}
 	asymmetric_key_free_kids(kids);
 	kfree(prep->description);
+	vfree(prep->decoded);
 }
 
 /*
diff --git a/crypto/asymmetric_keys/pem.c b/crypto/asymmetric_keys/pem.c
new file mode 100644
index 000000000000..b989fe7c1049
--- /dev/null
+++ b/crypto/asymmetric_keys/pem.c
@@ -0,0 +1,185 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Unwrap a PEM-encoded asymmetric key. This implementation unwraps
+ * the interoperable text encoding format specified in RFC 7468.
+ *
+ * Author: Chuck Lever <chuck.lever@oracle.com>
+ *
+ * Copyright (c) 2021, Oracle and/or its affiliates.
+ */
+
+#include <linux/kernel.h>
+#include <linux/slab.h>
+#include <linux/vmalloc.h>
+#include <linux/key-type.h>
+
+#include "pem.h"
+
+/* Encapsulation boundaries */
+#define PEM_EB_MARKER		"-----"
+#define PEM_BEGIN_MARKER	PEM_EB_MARKER "BEGIN"
+#define PEM_END_MARKER		PEM_EB_MARKER "END"
+
+/*
+ * Unremarkable table-driven base64 decoder based on the public domain
+ * implementation provided at:
+ *   https://en.wikibooks.org/wiki/Algorithm_Implementation/Miscellaneous/Base64
+ *
+ * XXX: Replace this implementation with one that handles EBCDIC input properly.
+ */
+
+#define WHITESPACE 253
+#define EQUALS     254
+#define INVALID    255
+
+static const u8 alphabet[] = {
+	INVALID, INVALID, INVALID, INVALID, INVALID, INVALID, INVALID, INVALID,
+	INVALID, INVALID, WHITESPACE, INVALID, INVALID, INVALID, INVALID, INVALID,
+	INVALID, INVALID, INVALID, INVALID, INVALID, INVALID, INVALID, INVALID,
+	INVALID, INVALID, INVALID, INVALID, INVALID, INVALID, INVALID, INVALID,
+	INVALID, INVALID, INVALID, INVALID, INVALID, INVALID, INVALID, INVALID,
+	INVALID, INVALID, INVALID, 62,      INVALID, INVALID, INVALID, 63,
+	52,      53,      54,      55,      56,      57,      58,      59,
+	60,      61,      INVALID, INVALID, INVALID, EQUALS,  INVALID, INVALID,
+	INVALID, 0,       1,       2,       3,       4,       5,       6,
+	7,       8,       9,       10,      11,      12,      13,      14,
+	15,      16,      17,      18,      19,      20,      21,      22,
+	23,      24,      25,      INVALID, INVALID, INVALID, INVALID, INVALID,
+	INVALID, 26,      27,      28,      29,      30,      31,      32,
+	33,      34,      35,      36,      37,      38,      39,      40,
+	41,      42,      43,      44,      45,      46,      47,      48,
+	49,      50,      51,      INVALID, INVALID, INVALID, INVALID, INVALID,
+	INVALID, INVALID, INVALID, INVALID, INVALID, INVALID, INVALID, INVALID,
+	INVALID, INVALID, INVALID, INVALID, INVALID, INVALID, INVALID, INVALID,
+	INVALID, INVALID, INVALID, INVALID, INVALID, INVALID, INVALID, INVALID,
+	INVALID, INVALID, INVALID, INVALID, INVALID, INVALID, INVALID, INVALID,
+	INVALID, INVALID, INVALID, INVALID, INVALID, INVALID, INVALID, INVALID,
+	INVALID, INVALID, INVALID, INVALID, INVALID, INVALID, INVALID, INVALID,
+	INVALID, INVALID, INVALID, INVALID, INVALID, INVALID, INVALID, INVALID,
+	INVALID, INVALID, INVALID, INVALID, INVALID, INVALID, INVALID, INVALID,
+	INVALID, INVALID, INVALID, INVALID, INVALID, INVALID, INVALID, INVALID,
+	INVALID, INVALID, INVALID, INVALID, INVALID, INVALID, INVALID, INVALID,
+	INVALID, INVALID, INVALID, INVALID, INVALID, INVALID, INVALID, INVALID,
+	INVALID, INVALID, INVALID, INVALID, INVALID, INVALID, INVALID, INVALID,
+	INVALID, INVALID, INVALID, INVALID, INVALID, INVALID, INVALID, INVALID,
+	INVALID, INVALID, INVALID, INVALID, INVALID, INVALID, INVALID, INVALID,
+	INVALID, INVALID, INVALID, INVALID, INVALID, INVALID, INVALID, INVALID,
+	INVALID, INVALID, INVALID, INVALID, INVALID, INVALID, INVALID, INVALID,
+};
+
+static bool base64decode(unsigned char *in, size_t inLen,
+			 unsigned char *out, size_t *outLen)
+{
+	unsigned char *end = in + inLen;
+	char iter = 0;
+	uint32_t buf = 0;
+	size_t len = 0;
+
+	while (in < end) {
+		u8 c = alphabet[*in++];
+
+		switch (c) {
+		case WHITESPACE:
+			continue;
+		case INVALID:
+			return false;
+		case EQUALS:
+			in = end;
+			continue;
+		default:
+			buf = buf << 6 | c;
+			iter++;
+
+			if (iter == 4) {
+				if ((len += 3) > *outLen)
+					return false;
+				*(out++) = (buf >> 16) & 255;
+				*(out++) = (buf >> 8) & 255;
+				*(out++) = buf & 255;
+				buf = 0;
+				iter = 0;
+			}
+		}
+	}
+
+	if (iter == 3) {
+		if ((len += 2) > *outLen)
+			return false;
+		*(out++) = (buf >> 10) & 255;
+		*(out++) = (buf >> 2) & 255;
+	} else if (iter == 2) {
+		if (++len > *outLen)
+			return false;
+		*(out++) = (buf >> 4) & 255;
+	}
+
+	*outLen = len;
+	return true;
+}
+
+/**
+ * pem_decode - Attempt to decode a PEM-encoded data blob.
+ * @prep: Data content to examine
+ *
+ * Assumptions:
+ * - The input data buffer is not more than a few pages in size.
+ * - The input data buffer has already been vetted for proper
+ *   kernel read access.
+ * - The input data buffer might not be NUL-terminated.
+ *
+ * PEM type labels are ignored. Subsequent parsing of the
+ * decoded message adequately identifies its content.
+ *
+ * On success, a pointer to a dynamically-allocated buffer
+ * containing the decoded content is returned. This buffer is
+ * vfree'd in the .free_preparse method.
+ *
+ * Return values:
+ *   %1: @prep.decoded points to the decoded message
+ *   %0: @prep did not contain a PEM-encoded message
+ *
+ * A negative errno is returned if an unexpected error has
+ * occurred (eg, memory exhaustion).
+ */
+int pem_decode(struct key_preparsed_payload *prep)
+{
+	const unsigned char *in = prep->data;
+	unsigned char *begin, *end, *out;
+	size_t outlen;
+
+	prep->decoded = NULL;
+	prep->decoded_len = 0;
+
+	/* Find the beginning encapsulation boundary */
+	begin = strnstr(in, PEM_BEGIN_MARKER, prep->datalen);
+	if (!begin)
+		goto out_not_pem;
+	begin = strnstr(begin, PEM_EB_MARKER, begin - in);
+	if (!begin)
+		goto out_not_pem;
+	begin += sizeof(PEM_EB_MARKER);
+
+	/* Find the ending encapsulation boundary */
+	end = strnstr(begin, PEM_END_MARKER, begin - in);
+	if (!end)
+		goto out_not_pem;
+	if (!strnstr(end, PEM_EB_MARKER, end - in))
+		goto out_not_pem;
+	end--;
+
+	/* Attempt to decode */
+	out = vmalloc(end - begin);
+	if (!out)
+		return -ENOMEM;
+	if (!base64decode(begin, end - begin, out, &outlen)) {
+		vfree(out);
+		goto out_not_pem;
+	}
+
+	prep->decoded = out;
+	prep->decoded_len = outlen;
+	return 1;
+
+out_not_pem:
+	return 0;
+}
diff --git a/crypto/asymmetric_keys/pem.h b/crypto/asymmetric_keys/pem.h
new file mode 100644
index 000000000000..51b9db517f94
--- /dev/null
+++ b/crypto/asymmetric_keys/pem.h
@@ -0,0 +1,8 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+
+#ifndef __ASYMMETRIC_PEM_H
+#define __ASYMMETRIC_PEM_H
+
+int pem_decode(struct key_preparsed_payload *prep);
+
+#endif /* __ASYMMETRIC_PEM_H */
diff --git a/crypto/asymmetric_keys/pkcs8_parser.c b/crypto/asymmetric_keys/pkcs8_parser.c
index 105dcce27f71..b7ce76d3a767 100644
--- a/crypto/asymmetric_keys/pkcs8_parser.c
+++ b/crypto/asymmetric_keys/pkcs8_parser.c
@@ -137,7 +137,10 @@ static int pkcs8_key_preparse(struct key_preparsed_payload *prep)
 {
 	struct public_key *pub;
 
-	pub = pkcs8_parse(prep->data, prep->datalen);
+	if (prep->decoded)
+		pub = pkcs8_parse(prep->decoded, prep->decoded_len);
+	else
+		pub = pkcs8_parse(prep->data, prep->datalen);
 	if (IS_ERR(pub))
 		return PTR_ERR(pub);
 
diff --git a/crypto/asymmetric_keys/x509_public_key.c b/crypto/asymmetric_keys/x509_public_key.c
index 3d45161b271a..d8b559ac6d7c 100644
--- a/crypto/asymmetric_keys/x509_public_key.c
+++ b/crypto/asymmetric_keys/x509_public_key.c
@@ -167,7 +167,10 @@ static int x509_key_preparse(struct key_preparsed_payload *prep)
 	char *desc = NULL, *p;
 	int ret;
 
-	cert = x509_cert_parse(prep->data, prep->datalen);
+	if (prep->decoded)
+		cert = x509_cert_parse(prep->decoded, prep->decoded_len);
+	else
+		cert = x509_cert_parse(prep->data, prep->datalen);
 	if (IS_ERR(cert))
 		return PTR_ERR(cert);
 
diff --git a/include/linux/key-type.h b/include/linux/key-type.h
index 7d985a1dfe4a..1672f9599afa 100644
--- a/include/linux/key-type.h
+++ b/include/linux/key-type.h
@@ -34,6 +34,8 @@ struct key_preparsed_payload {
 	union key_payload payload;	/* Proposed payload */
 	const void	*data;		/* Raw data */
 	size_t		datalen;	/* Raw datalen */
+	const void	*decoded;	/* PEM-decoded data */
+	size_t		decoded_len;	/* Length of PEM-decoded data */
 	size_t		quotalen;	/* Quota length for proposed payload */
 	time64_t	expiry;		/* Expiry time of key */
 } __randomize_layout;

