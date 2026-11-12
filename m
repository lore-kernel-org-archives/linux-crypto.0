Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=165.173.180.15
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794469552;
	b=1ipUC7H77lYfFhyAhG5tjsj3Mmie5BRjwo0na4izMPx9AOShZ+grh4BIXOjkCJS8SYUO
	 eFECWmG0Xjtojz6WXJ6g8lrd8eHHZ/6s3mrzwtxvXR8gmI2hQg/jX5WDLZ6QatypB1YRr
	 95pLSfCqKVTl9/XwAB1pczPyo1L+pOxSjtSytEcbP4yJHODsCM8YQE+a8MLXSiT3HfgVQ
	 Xb+0DzirAGz75yYshpCFM4+CjfXDsnmprSGoEez2tcnMTh+WI+vwKNMPAO9US2j9rjDGS
	 ppsm4xNfdSDbDP8zARMHXblaQKfv0mU9xZh9ojgzMxzfuXTNPdtnKXe4B19RUIxTe4w==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794469552;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-ZohoMailClient;
	bh=y3w7lCKhUDSJO1hMkA378GpKP59GBJjooc29uy32nbU=;
	b=B8iomBkcTJGClFG8FSWWTDP16eCiwsj7d1yGBk3USVYy3EZ/MFKSQ0RWTahgyp1hlBES
	 GsPo049LvHaUyeQeawtEiDlnRybKxzwZZhY8IF39dss//ZDy5MpZIuEje9SD6e/p8HNHK
	 F4GVBv5Bs4kBvxN2pVHCxs1qV8QVlZJ2XRi/IKsbN21Rku0CPXIt6Xb3ZdcBEfa7SLK9E
	 bDdmOPtpvXvdH22kx4ca8lEKp3xeu5rOTz3rAAXASaP8mTxntj95vwjwtPEh3kIhsUwJ+
	 FDlyClVVGRgVbmJ2Mb9ycUWW/3epILafTVAF8D2SVloJFOpQXw9YS/CF2cr7aS5B1ig==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=none header.from=laveeshbansal.com;
	spf=pass smtp.mailfrom=laveeshbansal.com;
	dkim=pass header.d=laveeshbansal.com header.i=@laveeshbansal.com header.a=rsa-sha256 header.s=zoho header.b=EqxCaVpx;
	arc=pass header.oldest-pass=0 smtp.remote-ip=165.173.180.15
Received: from sender6-op-o15.zoho.com (sender6-op-o15.zoho.com [165.173.180.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72B65606A321;
	Thu, 12 Nov 2026 07:45:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 72B65606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=laveeshbansal.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=laveeshbansal.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=laveeshbansal.com header.i=@laveeshbansal.com header.a=rsa-sha256 header.s=zoho header.b=EqxCaVpx
ARC-Seal: i=1; a=rsa-sha256; t=1794469439; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=oCUrl9IwMAMXQQlv0+PSYzq5FNDjzyU5MXLX5EPwX+ZbdC0yBhl+tULfTqhG4O4GB6GihjnbDrqqF/1sUWlOasYD4ZjH0gVNxzaY8oEZgWVYLWEW8hVecwiw9KJfJV72iErscjNXJAGyjk6w9QJ7VgxFDETpDuixGC1KYAuYvu0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1794469439; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=y3w7lCKhUDSJO1hMkA378GpKP59GBJjooc29uy32nbU=; 
	b=D//EkCDesnrkC8hSBSKs+caHHhQisMJnJEaqS6WJWsy/F1WWoK3dh/p/CXWyK3QEqTRs+Ou2M6KTZbnPvU9V7PORmdEs16SMoimcOH+hCSQ14aMfaRO4YxEwBJP0icoZg4u6PEy+qFtRsTcB8zjX1VnXSpRFxNDEr51OAcnVw6E=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=laveeshbansal.com;
	spf=pass  smtp.mailfrom=laveeshb@laveeshbansal.com;
	dmarc=pass header.from=<laveeshb@laveeshbansal.com>
DKIM-Signature: a=rsa-sha256; b=EqxCaVpxSxZ2zq+LHH34yhkhLvzHMY6AqtXagGyp0K1P3wY3nMUYchRyTkQNa3IJGKOE+vLqCpnyO8YRZsvvJ0y3HCi0rY0xdMxS40Bskc9fiq7zSH9ppfusXxs/sTcFhphgVwUSBuUGotIYYLQ09Arh6GXCLOztx1JWBb5LqqE=; c=relaxed/relaxed; s=zoho; d=laveeshbansal.com; v=1; bh=y3w7lCKhUDSJO1hMkA378GpKP59GBJjooc29uy32nbU=; h=Content-Description:Content-ID:Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:List-Subscribe:List-Post:List-Owner:List-Id:List-Archive:List-Help:List-Unsubscribe:MIME-Version:Message-ID:Resent-Sender:Resent-Cc:Resent-Date:Resent-To:Reply-To:Resent-Message-ID:Resent-From:Sender:Subject:To:Date:From:Message-Id:Reply-To:Subject:To:Cc;
Received: by smtp.zohomail.com with SMTPS id 1794469437222955.0085428812287;
	Wed, 11 Nov 2026 23:43:57 -0800 (PST)
From: Laveesh Bansal <laveeshb@laveeshbansal.com>
To: David Howells <dhowells@redhat.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Cc: Lukas Wunner <lukas@wunner.de>,
	Ignat Korchagin <ignat@linux.win>,
	"David S . Miller" <davem@davemloft.net>,
	Denis Kenzior <denkenz@gmail.com>,
	Maximilian Stahlberg <maximilian.stahlberg@uni-bremen.de>,
	keyrings@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] X.509: Add KUnit tests for the certificate parser
Date: Wed, 11 Nov 2026 23:42:46 -0800
Message-ID: <20261112074246.99421-3-laveeshb@laveeshbansal.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261112074246.99421-1-laveeshb@laveeshbansal.com>
References: <20261112074246.99421-1-laveeshb@laveeshbansal.com>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External

Add a KUnit test for x509_cert_parse() that builds a small certificate
in memory with different Subject and Issuer names. It checks that a
certificate with an empty Subject parses, and that a Subject with a
member that is not a SET and an empty Issuer are rejected.

Signed-off-by: Laveesh Bansal <laveeshb@laveeshbansal.com>
---
Without patch 1, x509_empty_subject fails and the other three cases pass;
with it, all four pass (arm64 QEMU/KVM guest, cbbddb6b08cc, 7.3.0).
 crypto/asymmetric_keys/Kconfig            |  11 ++
 crypto/asymmetric_keys/Makefile           |   1 +
 crypto/asymmetric_keys/x509_parser_test.c | 160 ++++++++++++++++++++++
 3 files changed, 172 insertions(+)
 create mode 100644 crypto/asymmetric_keys/x509_parser_test.c

diff --git a/crypto/asymmetric_keys/Kconfig b/crypto/asymmetric_keys/Kconfig
index c73979b2e98e..ca2c11f82e32 100644
--- a/crypto/asymmetric_keys/Kconfig
+++ b/crypto/asymmetric_keys/Kconfig
@@ -126,4 +126,15 @@ config VERIFY_PEFILE_KUNIT_TEST
 
 	  If unsure, say N.
 
+config X509_PARSER_KUNIT_TEST
+	tristate "KUnit tests for X.509 certificate parsing" if !KUNIT_ALL_TESTS
+	depends on KUNIT && X509_CERTIFICATE_PARSER
+	default KUNIT_ALL_TESTS
+	help
+	  Enable KUnit tests for the X.509 certificate parser.  The tests build
+	  small certificates in memory and check which Subject and Issuer
+	  names x509_cert_parse() accepts.
+
+	  If unsure, say N.
+
 endif # ASYMMETRIC_KEY_TYPE
diff --git a/crypto/asymmetric_keys/Makefile b/crypto/asymmetric_keys/Makefile
index 35172685c533..1ce91737ac89 100644
--- a/crypto/asymmetric_keys/Makefile
+++ b/crypto/asymmetric_keys/Makefile
@@ -22,6 +22,7 @@ x509_key_parser-y := \
 	x509_cert_parser.o \
 	x509_loader.o \
 	x509_public_key.o
+obj-$(CONFIG_X509_PARSER_KUNIT_TEST) += x509_parser_test.o
 obj-$(CONFIG_FIPS_SIGNATURE_SELFTEST) += x509_selftest.o
 x509_selftest-y += selftest.o
 x509_selftest-$(CONFIG_FIPS_SIGNATURE_SELFTEST_RSA) += selftest_rsa.o
diff --git a/crypto/asymmetric_keys/x509_parser_test.c b/crypto/asymmetric_keys/x509_parser_test.c
new file mode 100644
index 000000000000..c005b6fe68a6
--- /dev/null
+++ b/crypto/asymmetric_keys/x509_parser_test.c
@@ -0,0 +1,160 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * KUnit tests for the X.509 certificate parser.
+ *
+ * The cases build a minimal certificate in memory, vary the Subject or Issuer
+ * name, and call x509_cert_parse().  The key and signature are dummies, so
+ * Issuer and Subject must differ or the parser tries to verify the signature
+ * as a self-signed certificate.
+ */
+#include <kunit/test.h>
+#include <linux/cleanup.h>
+#include <linux/err.h>
+#include <linux/slab.h>
+#include <linux/string.h>
+#include "x509_parser.h"
+
+/* Name DERs: empty, CN=x, CN=y, and one whose member is not a SET. */
+static const u8 name_empty[] = { 0x30, 0x00 };
+static const u8 name_cn[] = {
+	0x30, 0x0c, 0x31, 0x0a, 0x30, 0x08, 0x06, 0x03, 0x55, 0x04, 0x03,
+	0x0c, 0x01, 0x78
+};
+
+static const u8 name_other_cn[] = {
+	0x30, 0x0c, 0x31, 0x0a, 0x30, 0x08, 0x06, 0x03, 0x55, 0x04, 0x03,
+	0x0c, 0x01, 0x79
+};
+
+static const u8 name_not_a_set[] = { 0x30, 0x03, 0x02, 0x01, 0x00 };
+
+static const u8 cert_version[] = { 0xa0, 0x03, 0x02, 0x01, 0x02 };
+static const u8 cert_serial[] = { 0x02, 0x01, 0x01 };
+/* sha256WithRSAEncryption, NULL parameters */
+static const u8 cert_sig_algo[] = {
+	0x30, 0x0d, 0x06, 0x09, 0x2a, 0x86, 0x48, 0x86, 0xf7, 0x0d, 0x01, 0x01,
+	0x0b, 0x05, 0x00
+};
+
+/* 2026-01-01 to 2036-01-01 */
+static const u8 cert_validity[] = {
+	0x30, 0x1e,
+	0x17, 0x0d, '2', '6', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', 'Z',
+	0x17, 0x0d, '3', '6', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', 'Z'
+};
+
+/* rsaEncryption with a dummy 4-byte key; the key is not parsed here */
+static const u8 cert_spki[] = {
+	0x30, 0x16,
+	0x30, 0x0d, 0x06, 0x09, 0x2a, 0x86, 0x48, 0x86, 0xf7, 0x0d, 0x01, 0x01,
+	0x01, 0x05, 0x00,
+	0x03, 0x05, 0x00, 0x01, 0x02, 0x03, 0x04
+};
+
+static const u8 cert_signature[] = { 0x03, 0x05, 0x00, 0x01, 0x02, 0x03, 0x04 };
+
+/* Write tag, length (up to 255) and @len bytes of @val at @out. */
+static u8 *put_tlv(u8 *out, u8 tag, const u8 *val, size_t len)
+{
+	*out++ = tag;
+	if (len > 127)
+		*out++ = 0x81;
+	*out++ = len;
+	memcpy(out, val, len);
+	return out + len;
+}
+
+static u8 *put_raw(u8 *out, const u8 *val, size_t len)
+{
+	memcpy(out, val, len);
+	return out + len;
+}
+
+static struct x509_certificate *parse_cert(struct kunit *test,
+					   const u8 *issuer, size_t issuer_len,
+					   const u8 *subject, size_t subject_len)
+{
+	/* The parsed certificate keeps pointers into this buffer. */
+	u8 *cert = kunit_kzalloc(test, 256, GFP_KERNEL);
+	u8 tbs[160], body[256], *p = tbs, *q = body;
+
+	KUNIT_ASSERT_NOT_NULL(test, cert);
+	/* Keep tbs[] and body[] large enough for the fixed parts plus the names. */
+	KUNIT_ASSERT_LE(test, issuer_len + subject_len, 64);
+
+	p = put_raw(p, cert_version, sizeof(cert_version));
+	p = put_raw(p, cert_serial, sizeof(cert_serial));
+	p = put_raw(p, cert_sig_algo, sizeof(cert_sig_algo));
+	p = put_raw(p, issuer, issuer_len);
+	p = put_raw(p, cert_validity, sizeof(cert_validity));
+	p = put_raw(p, subject, subject_len);
+	p = put_raw(p, cert_spki, sizeof(cert_spki));
+
+	q = put_tlv(q, 0x30, tbs, p - tbs);
+	q = put_raw(q, cert_sig_algo, sizeof(cert_sig_algo));
+	q = put_raw(q, cert_signature, sizeof(cert_signature));
+	p = put_tlv(cert, 0x30, body, q - body);
+
+	return x509_cert_parse(cert, p - cert);
+}
+
+/* RFC 5280 allows an empty Subject, so the certificate must parse. */
+static void x509_empty_subject(struct kunit *test)
+{
+	struct x509_certificate *cert __free(x509_free_certificate) =
+		parse_cert(test, name_other_cn, sizeof(name_other_cn),
+			   name_empty, sizeof(name_empty));
+
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, cert);
+	/* raw_subject_size counts the contents, not the tag and length. */
+	KUNIT_EXPECT_EQ(test, cert->raw_subject_size, 0);
+}
+
+/* Control: the same certificate with a one-RDN Subject parses. */
+static void x509_named_subject(struct kunit *test)
+{
+	struct x509_certificate *cert __free(x509_free_certificate) =
+		parse_cert(test, name_other_cn, sizeof(name_other_cn),
+			   name_cn, sizeof(name_cn));
+
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, cert);
+	KUNIT_EXPECT_EQ(test, cert->raw_subject_size, sizeof(name_cn) - 2);
+}
+
+/* A Subject member that is not a SET must be rejected, not looped over. */
+static void x509_subject_not_a_set(struct kunit *test)
+{
+	struct x509_certificate *cert __free(x509_free_certificate) =
+		parse_cert(test, name_other_cn, sizeof(name_other_cn),
+			   name_not_a_set, sizeof(name_not_a_set));
+
+	KUNIT_EXPECT_EQ(test, PTR_ERR_OR_ZERO(cert), -EBADMSG);
+}
+
+/* The Issuer must not be empty. */
+static void x509_empty_issuer(struct kunit *test)
+{
+	struct x509_certificate *cert __free(x509_free_certificate) =
+		parse_cert(test, name_empty, sizeof(name_empty),
+			   name_cn, sizeof(name_cn));
+
+	KUNIT_EXPECT_EQ(test, PTR_ERR_OR_ZERO(cert), -EBADMSG);
+}
+
+static struct kunit_case x509_parser_cases[] = {
+	KUNIT_CASE(x509_empty_subject),
+	KUNIT_CASE(x509_named_subject),
+	KUNIT_CASE(x509_subject_not_a_set),
+	KUNIT_CASE(x509_empty_issuer),
+	{}
+};
+
+static struct kunit_suite x509_parser_suite = {
+	.name = "x509_parser",
+	.test_cases = x509_parser_cases,
+};
+
+kunit_test_suite(x509_parser_suite);
+
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("KUnit tests for the X.509 certificate parser");
-- 
2.54.0

