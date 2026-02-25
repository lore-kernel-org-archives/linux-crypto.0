Received: from lamorak.hansenpartnership.com (lamorak.hansenpartnership.com [198.37.111.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E91C2F25E4
	for <linux-crypto@vger.kernel.org>; Wed, 25 Feb 2026 21:21:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.37.111.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772054486; cv=none; b=kG/EofEdeUa7asAbNvR0eCzjFY+epgSkCbsUcYa8T66tTC5yJkxbWTzYsBsxj8qS6hQ2C5hIFL1b6JrK5Kosu3uJ05Q77HM8NVOFBP+L/4FJ1CRq2ZrR5hz0FEybnlH+tF8+D5kPxQKwJOQWg3VdxJJEmkBDqvm1Sme3no9uDFk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772054486; c=relaxed/simple;
	bh=pgwB2aWSaEwwN34xXIerq9Wy0VEEaZnmg933NADEuuk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j9pKfsA8LDHUwVAD9zNU/6bXBEfHWlsUIVkMocfhU+agAluHh/4RhDFlIVvlvD/w8t/8bjoXYMni8XmOckPNuyPnEZpANjK2hyokYmxi2MdrutMgNW0musO1y30W0qkC5m4NbKMtYqdVdFznS6xBVUluQle64E3qgiMYDThoHic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=HansenPartnership.com; spf=pass smtp.mailfrom=HansenPartnership.com; dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b=En7b1Cor; arc=none smtp.client-ip=198.37.111.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=HansenPartnership.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=HansenPartnership.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="En7b1Cor"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
	d=hansenpartnership.com; s=20151216; t=1772054484;
	bh=pgwB2aWSaEwwN34xXIerq9Wy0VEEaZnmg933NADEuuk=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:From;
	b=En7b1CorMMx5Q+d00lINaK/FqXZ6SJ6wpUCYYk28YVGOr4QSDxMGH4/RxRorp1dP9
	 rJLLlK7djxXHiigYey0uyXaLz5dUVHlQp/4gdbSyhtzcprp5jYkTVNbkGKPtlBVCiA
	 KAjrslItskcCKzrGVytRs9DQ+TKBkJ15g3GeiKls=
Received: from lingrow.int.hansenpartnership.com (unknown [153.66.160.227])
	by lamorak.hansenpartnership.com (Postfix) with ESMTP id 5125D1C02E8;
	Wed, 25 Feb 2026 16:21:24 -0500 (EST)
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: linux-crypto@vger.kernel.org
Cc: David Howells <dhowells@redhat.com>,
	Blaise Boscaccy <bboscaccy@linux.microsoft.com>
Subject: [PATCH v3 4/5] crypto: pkcs7: add ability to extract signed attributes by OID
Date: Wed, 25 Feb 2026 16:19:06 -0500
Message-ID: <20260225211907.7368-5-James.Bottomley@HansenPartnership.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260225211907.7368-1-James.Bottomley@HansenPartnership.com>
References: <20260225211907.7368-1-James.Bottomley@HansenPartnership.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Signers may add any information they like in signed attributes and
sometimes this information turns out to be relevant to specific
signing cases, so add an api pkcs7_get_authattr() to extract the value
of an authenticated attribute by specific OID.  The current
implementation is designed for the single signer use case and simply
terminates the search when it finds the relevant OID.

Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>

---
v2: fix docbook
---
 crypto/asymmetric_keys/Makefile       |  4 +-
 crypto/asymmetric_keys/pkcs7_aa.asn1  | 18 ++++++
 crypto/asymmetric_keys/pkcs7_parser.c | 81 +++++++++++++++++++++++++++
 include/crypto/pkcs7.h                |  4 ++
 4 files changed, 106 insertions(+), 1 deletion(-)
 create mode 100644 crypto/asymmetric_keys/pkcs7_aa.asn1

diff --git a/crypto/asymmetric_keys/Makefile b/crypto/asymmetric_keys/Makefile
index bc65d3b98dcb..f99b7169ae7c 100644
--- a/crypto/asymmetric_keys/Makefile
+++ b/crypto/asymmetric_keys/Makefile
@@ -53,12 +53,14 @@ clean-files	+= pkcs8.asn1.c pkcs8.asn1.h
 obj-$(CONFIG_PKCS7_MESSAGE_PARSER) += pkcs7_message.o
 pkcs7_message-y := \
 	pkcs7.asn1.o \
+	pkcs7_aa.asn1.o \
 	pkcs7_parser.o \
 	pkcs7_trust.o \
 	pkcs7_verify.o
 
-$(obj)/pkcs7_parser.o: $(obj)/pkcs7.asn1.h
+$(obj)/pkcs7_parser.o: $(obj)/pkcs7.asn1.h $(obj)/pkcs7_aa.asn1.h
 $(obj)/pkcs7.asn1.o: $(obj)/pkcs7.asn1.c $(obj)/pkcs7.asn1.h
+$(obj)/pkcs7_aa.asn1.o: $(obj)/pkcs7_aa.asn1.c $(obj)/pkcs7_aa.asn1.h
 
 #
 # PKCS#7 parser testing key
diff --git a/crypto/asymmetric_keys/pkcs7_aa.asn1 b/crypto/asymmetric_keys/pkcs7_aa.asn1
new file mode 100644
index 000000000000..7a8857bdf56e
--- /dev/null
+++ b/crypto/asymmetric_keys/pkcs7_aa.asn1
@@ -0,0 +1,18 @@
+-- SPDX-License-Identifier: BSD-3-Clause
+--
+-- Copyright (C) 2009 IETF Trust and the persons identified as authors
+-- of the code
+--
+-- https://www.rfc-editor.org/rfc/rfc5652#section-3
+
+AA ::= 	CHOICE {
+	aaSet		[0] IMPLICIT AASet,
+	aaSequence	[2] EXPLICIT SEQUENCE OF AuthenticatedAttribute
+}
+
+AASet ::= SET OF AuthenticatedAttribute
+
+AuthenticatedAttribute ::= SEQUENCE {
+	type	OBJECT IDENTIFIER ({ pkcs7_aa_note_OID }),
+	values	SET OF ANY ({ pkcs7_aa_note_attr })
+}
diff --git a/crypto/asymmetric_keys/pkcs7_parser.c b/crypto/asymmetric_keys/pkcs7_parser.c
index 6e3ffdac83ac..d467866f7d93 100644
--- a/crypto/asymmetric_keys/pkcs7_parser.c
+++ b/crypto/asymmetric_keys/pkcs7_parser.c
@@ -15,6 +15,7 @@
 #include <crypto/public_key.h>
 #include "pkcs7_parser.h"
 #include "pkcs7.asn1.h"
+#include "pkcs7_aa.asn1.h"
 
 MODULE_DESCRIPTION("PKCS#7 parser");
 MODULE_AUTHOR("Red Hat, Inc.");
@@ -211,6 +212,86 @@ int pkcs7_get_content_data(const struct pkcs7_message *pkcs7,
 }
 EXPORT_SYMBOL_GPL(pkcs7_get_content_data);
 
+struct pkcs7_aa_context {
+	bool found;
+	enum OID oid_to_find;
+	const void *data;
+	size_t len;
+};
+
+int pkcs7_aa_note_OID(void *context, size_t hdrlen,
+		      unsigned char tag,
+		      const void *value, size_t vlen)
+{
+	struct pkcs7_aa_context *ctx = context;
+	enum OID oid = look_up_OID(value, vlen);
+
+	ctx->found = (oid == ctx->oid_to_find);
+
+	return 0;
+}
+
+int pkcs7_aa_note_attr(void *context, size_t hdrlen,
+		       unsigned char tag,
+		       const void *value, size_t vlen)
+{
+	struct pkcs7_aa_context *ctx = context;
+
+	if (ctx->found) {
+		ctx->data = value;
+		ctx->len = vlen;
+	}
+
+	return 0;
+}
+
+/**
+ * pkcs7_get_authattr - get authenticated attribute by OID
+ * @pkcs7: The preparsed PKCS#7 message
+ * @oid: the enum value of the OID to find
+ * @_data: Place to return a pointer to the attribute value
+ * @_len: length of the attribute value
+ *
+ * Searches the authenticated attributes until one is found with a
+ * matching OID.  Note that because the attributes are per signer
+ * there could be multiple signers with different values, but this
+ * routine will simply return the first one in parse order.
+ *
+ * Returns -ENODATA if the attribute can't be found
+ */
+int pkcs7_get_authattr(const struct pkcs7_message *pkcs7,
+		       enum OID oid,
+		       const void **_data, size_t *_len)
+{
+	struct pkcs7_signed_info *sinfo = pkcs7->signed_infos;
+	struct pkcs7_aa_context ctx;
+
+	ctx.data = NULL;
+	ctx.oid_to_find = oid;
+
+	for (; sinfo; sinfo = sinfo->next) {
+		int ret;
+
+		/* only extract OIDs from validated signers */
+		if (!sinfo->verified)
+			continue;
+
+		ret = asn1_ber_decoder(&pkcs7_aa_decoder, &ctx,
+				       sinfo->authattrs, sinfo->authattrs_len);
+		if (ret < 0 || ctx.data != NULL)
+			break;
+	}
+
+	if (!ctx.data)
+		return -ENODATA;
+
+	*_data = ctx.data;
+	*_len = ctx.len;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(pkcs7_get_authattr);
+
 /*
  * Note an OID when we find one for later processing when we know how
  * to interpret it.
diff --git a/include/crypto/pkcs7.h b/include/crypto/pkcs7.h
index 38ec7f5f9041..bd83202cd805 100644
--- a/include/crypto/pkcs7.h
+++ b/include/crypto/pkcs7.h
@@ -25,6 +25,10 @@ extern void pkcs7_free_message(struct pkcs7_message *pkcs7);
 extern int pkcs7_get_content_data(const struct pkcs7_message *pkcs7,
 				  const void **_data, size_t *_datalen,
 				  size_t *_headerlen);
+extern int pkcs7_get_authattr(const struct pkcs7_message *pkcs7,
+			      enum OID oid,
+			      const void **_data, size_t *_len);
+
 
 /*
  * pkcs7_trust.c
-- 
2.51.0

