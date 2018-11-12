Return-Path: <SRS0=oFif=NX=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from lhrrgout.huawei.com ([185.176.76.210]:32743 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727204AbeKLU0y (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 12 Nov 2018 15:26:54 -0500
From: Roberto Sassu <roberto.sassu@huawei.com>
To: <dhowells@redhat.com>, <dwmw2@infradead.org>,
        <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC: <keyrings@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
        <linux-integrity@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <silviu.vlasceanu@huawei.com>,
        Roberto Sassu <roberto.sassu@huawei.com>
Subject: [RFC][PATCH 09/12] verification: introduce verify_pgp_signature()
Date: Mon, 12 Nov 2018 11:24:20 +0100
Message-ID: <20181112102423.30415-10-roberto.sassu@huawei.com>
In-Reply-To: <20181112102423.30415-1-roberto.sassu@huawei.com>
References: <20181112102423.30415-1-roberto.sassu@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Introduce verify_pgp_signature() to to verify PGP signatures from data or
a digest. One user of this function would be IMA, that can verify the
signature of RPM headers when appraisal is enabled.

Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
---
 certs/system_keyring.c       | 39 ++++++++++++++++++++++++++++++++++++
 include/linux/verification.h |  5 +++++
 2 files changed, 44 insertions(+)

diff --git a/certs/system_keyring.c b/certs/system_keyring.c
index 81728717523d..e4c59a5c7a9d 100644
--- a/certs/system_keyring.c
+++ b/certs/system_keyring.c
@@ -19,6 +19,7 @@
 #include <keys/asymmetric-type.h>
 #include <keys/system_keyring.h>
 #include <crypto/pkcs7.h>
+#include <linux/pgp_sig.h>
 
 static struct key *builtin_trusted_keys;
 #ifdef CONFIG_SECONDARY_TRUSTED_KEYRING
@@ -265,4 +266,42 @@ int verify_pkcs7_signature(const void *data, size_t len,
 }
 EXPORT_SYMBOL_GPL(verify_pkcs7_signature);
 
+/**
+ * verify_pgp_signature - Verify a PGP-based signature on system data.
+ * @data: The data to be verified (NULL if expecting internal data).
+ * @len: Size of @data.
+ * @digest: Digest for signature verification.
+ * @digest_size: Size of @digest.
+ * @raw_pgp: The PGP message that is the signature.
+ * @pgp_len: Size of @raw_pgp.
+ * @trusted_keys: Trusted keys to use (NULL for builtin trusted keys only,
+ *				       (void *)1UL for all trusted keys).
+ */
+int verify_pgp_signature(const void *data, size_t len,
+			 const void *digest, size_t digest_size,
+			 const void *raw_pgp, size_t pgp_len,
+			 struct key *trusted_keys)
+{
+	int ret = -ENOTSUPP;
+
+#ifdef CONFIG_PGP_KEY_PARSER
+	if (!trusted_keys) {
+		trusted_keys = builtin_trusted_keys;
+	} else if (trusted_keys == (void *)1UL) {
+#ifdef CONFIG_SECONDARY_TRUSTED_KEYRING
+		trusted_keys = secondary_trusted_keys;
+#else
+		trusted_keys = builtin_trusted_keys;
+#endif
+	}
+
+	ret = pgp_verify_sig(trusted_keys, data, len, digest, digest_size,
+			     raw_pgp, pgp_len);
+
+#endif /* CONFIG_PGP_KEY_PARSER */
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(verify_pgp_signature);
+
 #endif /* CONFIG_SYSTEM_DATA_VERIFICATION */
diff --git a/include/linux/verification.h b/include/linux/verification.h
index cfa4730d607a..6fd7bf60efaa 100644
--- a/include/linux/verification.h
+++ b/include/linux/verification.h
@@ -45,6 +45,11 @@ extern int verify_pkcs7_signature(const void *data, size_t len,
 						      size_t asn1hdrlen),
 				  void *ctx);
 
+extern int verify_pgp_signature(const void *data, size_t len,
+				const void *digest, size_t digest_size,
+				const void *raw_pgp, size_t pgp_len,
+				struct key *trusted_keys);
+
 #ifdef CONFIG_SIGNED_PE_FILE_VERIFICATION
 extern int verify_pefile_signature(const void *pebuf, unsigned pelen,
 				   struct key *trusted_keys,
-- 
2.17.1
