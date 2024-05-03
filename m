Received: from smtp.jvdsn.com (smtp.jvdsn.com [129.153.194.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3DBE139563
	for <linux-crypto@vger.kernel.org>; Fri,  3 May 2024 04:39:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=129.153.194.31
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714711173; cv=none; b=BXO+vj3FRft0QM5I1odtWoKg/imlNRA9a7fgCCroySc0RM1vwmx0uq61+I1DOtO82YeqGdE8BgX+zQMBdizC0OYGdswPsCaYcTPBA4v6XcA4fjAHMBFwDaTAeKYEZXC9ZqHU9DsRkP9AuCtOUuDgzoQw7OdBFYuCrRtzjjs0Q60=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714711173; c=relaxed/simple;
	bh=jksnkYTqoJ7V40I1JnjByP4SbO+xtoVW1235TqH2HkA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a4XoKyvRG9NbpjVgHX2R3ZIZZSgWV7IAwXEYrWZw+j9J8am2st9wRVxvEoUejS8nZeYp733IQrzUlBpDFuqU0kFq2rzcr65actD3MO/7zJGpoguS/rwLsQzamkhyGVlqs/t6Yw0LfIuIDvUixkCHFAIZ3ruuDtjG8sQrB5xCZis=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=jvdsn.com; spf=pass smtp.mailfrom=jvdsn.com; dkim=pass (2048-bit key) header.d=jvdsn.com header.i=@jvdsn.com header.b=FMdEdLAF; arc=none smtp.client-ip=129.153.194.31
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=jvdsn.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=jvdsn.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=jvdsn.com header.i=@jvdsn.com header.b="FMdEdLAF"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=jvdsn.com; s=mail;
	t=1714711163; bh=jksnkYTqoJ7V40I1JnjByP4SbO+xtoVW1235TqH2HkA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FMdEdLAFbNMZBVajsipsYW2xm9GQJaHChh0U0c/tX9Frh1BHt6wrRzJTHuNzRVxf4
	 BcKWQ29rrjmzpliwv7ckqIr/ozO5tnsUO/IWnxNqxMVqXPGj0V+wTU2fS/5JLk1G97
	 DMDA1/HR4yRIZd1ioeGMMh7ck5Mwpdxn3+yJ8UYmjZLYgDKv1HkzxcIBmUCcxc0dyg
	 HQWPv0PNm/FM986kI9cBToWRPfTHnouiTEyLt+cHkca7qMoPENSMwIK+ccvS+BRYka
	 eTEpZYSGpH6yoTMolUN1AhgeIKS9+b0ylUWvblTvaMPHsxMtqS0uQvrplnQiKfsBAu
	 JA6aXkaT4k31A==
From: Joachim Vandersmissen <git@jvdsn.com>
To: linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>
Cc: David Howells <dhowells@redhat.com>,
	Simo Sorce <simo@redhat.com>,
	Stephan Mueller <smueller@chronox.de>,
	Joachim Vandersmissen <git@jvdsn.com>
Subject: [PATCH v3 2/2] certs: Add ECDSA signature verification self-test
Date: Thu,  2 May 2024 23:38:57 -0500
Message-ID: <20240503043857.45515-2-git@jvdsn.com>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240503043857.45515-1-git@jvdsn.com>
References: <20240503043857.45515-1-git@jvdsn.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

v3: adding the FIPS_SIGNATURE_SELFTEST_RSA configuration option to
enforce that ECDSA (and SHA-256) are either built-in; or ECDSA
(and SHA-256) and x509_selftest are modules.

---8<---

Commit c27b2d2012e1 ("crypto: testmgr - allow ecdsa-nist-p256 and -p384
in FIPS mode") enabled support for ECDSA in crypto/testmgr.c. The
PKCS#7 signature verification API builds upon the KCAPI primitives to
perform its high-level operations. Therefore, this change in testmgr.c
also allows ECDSA to be used by the PKCS#7 signature verification API
(in FIPS mode).

However, from a FIPS perspective, the PKCS#7 signature verification API
is a distinct "service" from the KCAPI primitives. This is because the
PKCS#7 API performs a "full" signature verification, which consists of
both hashing the data to be verified, and the public key operation.
On the other hand, the KCAPI primitive does not perform this hashing
step - it accepts pre-hashed data from the caller and only performs the
public key operation.

For this reason, the ECDSA self-tests in crypto/testmgr.c are not
sufficient to cover ECDSA signature verification offered by the PKCS#7
API. This is reflected by the self-test already present in this file
for RSA PKCS#1 v1.5 signature verification.

The solution is simply to add a second self-test here for ECDSA. P-256
with SHA-256 hashing was chosen as those parameters should remain
FIPS-approved for the foreseeable future, while keeping the performance
impact to a minimum. The ECDSA certificate and PKCS#7 signed data was
generated using OpenSSL. The input data is identical to the input data
for the existing RSA self-test.

Signed-off-by: Joachim Vandersmissen <git@jvdsn.com>
---
 crypto/asymmetric_keys/Kconfig          | 10 +++
 crypto/asymmetric_keys/Makefile         |  1 +
 crypto/asymmetric_keys/selftest.c       |  1 +
 crypto/asymmetric_keys/selftest.h       |  6 ++
 crypto/asymmetric_keys/selftest_ecdsa.c | 89 +++++++++++++++++++++++++
 5 files changed, 107 insertions(+)
 create mode 100644 crypto/asymmetric_keys/selftest_ecdsa.c

diff --git a/crypto/asymmetric_keys/Kconfig b/crypto/asymmetric_keys/Kconfig
index 68434c745b3c..f01ae999a0d6 100644
--- a/crypto/asymmetric_keys/Kconfig
+++ b/crypto/asymmetric_keys/Kconfig
@@ -96,4 +96,14 @@ config FIPS_SIGNATURE_SELFTEST_RSA
 	depends on CRYPTO_SHA256=y || CRYPTO_SHA256=FIPS_SIGNATURE_SELFTEST
 	depends on CRYPTO_RSA=y || CRYPTO_RSA=FIPS_SIGNATURE_SELFTEST
 
+config FIPS_SIGNATURE_SELFTEST_ECDSA
+	bool "Include ECDSA selftests"
+	help
+	  This option includes the ECDSA selftests in the X.509+PKCS7 selftest
+	  code.  ECDSA and SHA-256 must be available when the selftests are
+	  executed; this is enforced by the dependencies.
+	depends on FIPS_SIGNATURE_SELFTEST
+	depends on CRYPTO_SHA256=y || CRYPTO_SHA256=FIPS_SIGNATURE_SELFTEST
+	depends on CRYPTO_ECDSA=y || CRYPTO_ECDSA=FIPS_SIGNATURE_SELFTEST
+
 endif # ASYMMETRIC_KEY_TYPE
diff --git a/crypto/asymmetric_keys/Makefile b/crypto/asymmetric_keys/Makefile
index ac1402e27324..bc65d3b98dcb 100644
--- a/crypto/asymmetric_keys/Makefile
+++ b/crypto/asymmetric_keys/Makefile
@@ -25,6 +25,7 @@ x509_key_parser-y := \
 obj-$(CONFIG_FIPS_SIGNATURE_SELFTEST) += x509_selftest.o
 x509_selftest-y += selftest.o
 x509_selftest-$(CONFIG_FIPS_SIGNATURE_SELFTEST_RSA) += selftest_rsa.o
+x509_selftest-$(CONFIG_FIPS_SIGNATURE_SELFTEST_ECDSA) += selftest_ecdsa.o
 
 $(obj)/x509_cert_parser.o: \
 	$(obj)/x509.asn1.h \
diff --git a/crypto/asymmetric_keys/selftest.c b/crypto/asymmetric_keys/selftest.c
index ec289d2d065c..98dc5cdfdebe 100644
--- a/crypto/asymmetric_keys/selftest.c
+++ b/crypto/asymmetric_keys/selftest.c
@@ -61,6 +61,7 @@ void fips_signature_selftest(const char *name,
 static int __init fips_signature_selftest_init(void)
 {
 	fips_signature_selftest_rsa();
+	fips_signature_selftest_ecdsa();
 	return 0;
 }
 
diff --git a/crypto/asymmetric_keys/selftest.h b/crypto/asymmetric_keys/selftest.h
index 842ac3cf86b4..4139f05906cb 100644
--- a/crypto/asymmetric_keys/selftest.h
+++ b/crypto/asymmetric_keys/selftest.h
@@ -14,3 +14,9 @@ void __init fips_signature_selftest_rsa(void);
 #else
 static inline void __init fips_signature_selftest_rsa(void) { }
 #endif
+
+#ifdef CONFIG_FIPS_SIGNATURE_SELFTEST_ECDSA
+void __init fips_signature_selftest_ecdsa(void);
+#else
+static inline void __init fips_signature_selftest_ecdsa(void) { }
+#endif
diff --git a/crypto/asymmetric_keys/selftest_ecdsa.c b/crypto/asymmetric_keys/selftest_ecdsa.c
new file mode 100644
index 000000000000..3ee2e4ea9e3f
--- /dev/null
+++ b/crypto/asymmetric_keys/selftest_ecdsa.c
@@ -0,0 +1,89 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/* Self-tests for PKCS#7 ECDSA signature verification.
+ *
+ * Copyright (C) 2024 Joachim Vandersmissen <git@jvdsn.com>
+ */
+
+#include <linux/module.h>
+#include "selftest.h"
+
+/*
+ * Set of X.509 certificates to provide public keys for the tests. These will
+ * be loaded into a temporary keyring for the duration of the testing.
+ */
+static const u8 certs_selftest_ecdsa_keys[] __initconst = {
+	/* P-256 ECDSA certificate */
+	"\x30\x82\x01\xd4\x30\x82\x01\x7b\xa0\x03\x02\x01\x02\x02\x14\x2e"
+	"\xea\x64\x8d\x7f\x17\xe6\x2e\x9e\x58\x69\xc8\x87\xc6\x8e\x1b\xd0"
+	"\xf8\x6f\xde\x30\x0a\x06\x08\x2a\x86\x48\xce\x3d\x04\x03\x02\x30"
+	"\x3a\x31\x38\x30\x36\x06\x03\x55\x04\x03\x0c\x2f\x43\x65\x72\x74"
+	"\x69\x66\x69\x63\x61\x74\x65\x20\x76\x65\x72\x69\x66\x69\x63\x61"
+	"\x74\x69\x6f\x6e\x20\x45\x43\x44\x53\x41\x20\x73\x65\x6c\x66\x2d"
+	"\x74\x65\x73\x74\x69\x6e\x67\x20\x6b\x65\x79\x30\x20\x17\x0d\x32"
+	"\x34\x30\x34\x31\x33\x32\x32\x31\x36\x32\x36\x5a\x18\x0f\x32\x31"
+	"\x32\x34\x30\x33\x32\x30\x32\x32\x31\x36\x32\x36\x5a\x30\x3a\x31"
+	"\x38\x30\x36\x06\x03\x55\x04\x03\x0c\x2f\x43\x65\x72\x74\x69\x66"
+	"\x69\x63\x61\x74\x65\x20\x76\x65\x72\x69\x66\x69\x63\x61\x74\x69"
+	"\x6f\x6e\x20\x45\x43\x44\x53\x41\x20\x73\x65\x6c\x66\x2d\x74\x65"
+	"\x73\x74\x69\x6e\x67\x20\x6b\x65\x79\x30\x59\x30\x13\x06\x07\x2a"
+	"\x86\x48\xce\x3d\x02\x01\x06\x08\x2a\x86\x48\xce\x3d\x03\x01\x07"
+	"\x03\x42\x00\x04\x07\xe5\x6b\x51\xaf\xfc\x19\x41\x2c\x88\x92\x6b"
+	"\x77\x57\x71\x03\x9e\xe2\xfe\x6e\x6a\x71\x4e\xc7\x29\x9f\x90\xe1"
+	"\x77\x18\x9f\xc2\xe7\x0a\x82\xd0\x8a\xe1\x81\xa9\x71\x7c\x5a\x73"
+	"\xfb\x25\xb9\x5b\x1e\x24\x8c\x73\x9f\xf8\x38\xf8\x48\xb4\xad\x16"
+	"\x19\xc0\x22\xc6\xa3\x5d\x30\x5b\x30\x1d\x06\x03\x55\x1d\x0e\x04"
+	"\x16\x04\x14\x29\x00\xbc\xea\x1d\xeb\x7b\xc8\x47\x9a\x84\xa2\x3d"
+	"\x75\x8e\xfd\xfd\xd2\xb2\xd3\x30\x1f\x06\x03\x55\x1d\x23\x04\x18"
+	"\x30\x16\x80\x14\x29\x00\xbc\xea\x1d\xeb\x7b\xc8\x47\x9a\x84\xa2"
+	"\x3d\x75\x8e\xfd\xfd\xd2\xb2\xd3\x30\x0c\x06\x03\x55\x1d\x13\x01"
+	"\x01\xff\x04\x02\x30\x00\x30\x0b\x06\x03\x55\x1d\x0f\x04\x04\x03"
+	"\x02\x07\x80\x30\x0a\x06\x08\x2a\x86\x48\xce\x3d\x04\x03\x02\x03"
+	"\x47\x00\x30\x44\x02\x20\x1a\xd7\xac\x07\xc8\x97\x38\xf4\x89\x43"
+	"\x7e\xc7\x66\x6e\xa5\x00\x7c\x12\x1d\xb4\x09\x76\x0c\x99\x6b\x8c"
+	"\x26\x5d\xe9\x70\x5c\xb4\x02\x20\x73\xb7\xc7\x7a\x5a\xdb\x67\x0a"
+	"\x96\x42\x19\xcf\x4f\x67\x4f\x35\x6a\xee\x29\x25\xf2\x4f\xc8\x10"
+	"\x14\x9d\x79\x69\x1c\x7a\xd7\x5d"
+};
+
+
+/*
+ * Signed data and detached signature blobs that form the verification tests.
+ */
+static const u8 certs_selftest_ecdsa_data[] __initconst = {
+	"\x54\x68\x69\x73\x20\x69\x73\x20\x73\x6f\x6d\x65\x20\x74\x65\x73"
+	"\x74\x20\x64\x61\x74\x61\x20\x75\x73\x65\x64\x20\x66\x6f\x72\x20"
+	"\x73\x65\x6c\x66\x2d\x74\x65\x73\x74\x69\x6e\x67\x20\x63\x65\x72"
+	"\x74\x69\x66\x69\x63\x61\x74\x65\x20\x76\x65\x72\x69\x66\x69\x63"
+	"\x61\x74\x69\x6f\x6e\x2e\x0a"
+};
+
+static const u8 certs_selftest_ecdsa_sig[] __initconst = {
+	/* ECDSA signature using SHA-256 */
+	"\x30\x81\xf4\x06\x09\x2a\x86\x48\x86\xf7\x0d\x01\x07\x02\xa0\x81"
+	"\xe6\x30\x81\xe3\x02\x01\x01\x31\x0f\x30\x0d\x06\x09\x60\x86\x48"
+	"\x01\x65\x03\x04\x02\x01\x05\x00\x30\x0b\x06\x09\x2a\x86\x48\x86"
+	"\xf7\x0d\x01\x07\x01\x31\x81\xbf\x30\x81\xbc\x02\x01\x01\x30\x52"
+	"\x30\x3a\x31\x38\x30\x36\x06\x03\x55\x04\x03\x0c\x2f\x43\x65\x72"
+	"\x74\x69\x66\x69\x63\x61\x74\x65\x20\x76\x65\x72\x69\x66\x69\x63"
+	"\x61\x74\x69\x6f\x6e\x20\x45\x43\x44\x53\x41\x20\x73\x65\x6c\x66"
+	"\x2d\x74\x65\x73\x74\x69\x6e\x67\x20\x6b\x65\x79\x02\x14\x2e\xea"
+	"\x64\x8d\x7f\x17\xe6\x2e\x9e\x58\x69\xc8\x87\xc6\x8e\x1b\xd0\xf8"
+	"\x6f\xde\x30\x0d\x06\x09\x60\x86\x48\x01\x65\x03\x04\x02\x01\x05"
+	"\x00\x30\x0a\x06\x08\x2a\x86\x48\xce\x3d\x04\x03\x02\x04\x48\x30"
+	"\x46\x02\x21\x00\x86\xd1\xf4\x06\xb6\x49\x79\xf9\x09\x5f\x35\x1a"
+	"\x94\x7e\x0e\x1a\x12\x4d\xd9\xe6\x2a\x2d\xcf\x2d\x0a\xee\x88\x76"
+	"\xe0\x35\xf3\xeb\x02\x21\x00\xdf\x11\x8a\xab\x31\xf6\x3c\x1f\x32"
+	"\x43\x94\xe2\xb8\x35\xc9\xf3\x12\x4e\x9b\x31\x08\x10\x5d\x8d\xe2"
+	"\x43\x0a\x5f\xf5\xfd\xa2\xf1"
+};
+
+void __init fips_signature_selftest_ecdsa(void)
+{
+	fips_signature_selftest("ECDSA",
+				certs_selftest_ecdsa_keys,
+				sizeof(certs_selftest_ecdsa_keys) - 1,
+				certs_selftest_ecdsa_data,
+				sizeof(certs_selftest_ecdsa_data) - 1,
+				certs_selftest_ecdsa_sig,
+				sizeof(certs_selftest_ecdsa_sig) - 1);
+}
-- 
2.45.0

