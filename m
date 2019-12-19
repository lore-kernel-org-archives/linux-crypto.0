Return-Path: <SRS0=xTm+=2J=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B0FCC43603
	for <linux-crypto@archiver.kernel.org>; Thu, 19 Dec 2019 16:06:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6223F2146E
	for <linux-crypto@archiver.kernel.org>; Thu, 19 Dec 2019 16:06:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726789AbfLSQGo (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 19 Dec 2019 11:06:44 -0500
Received: from mx2.suse.de ([195.135.220.15]:34286 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726778AbfLSQGn (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 19 Dec 2019 11:06:43 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id E1878AD73;
        Thu, 19 Dec 2019 16:06:39 +0000 (UTC)
From:   Michal Suchanek <msuchanek@suse.de>
To:     linux-crypto@vger.kernel.org
Cc:     Michal Suchanek <msuchanek@suse.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] crypto: testmgr: allow building a copy as loadable module for testing.
Date:   Thu, 19 Dec 2019 17:06:36 +0100
Message-Id: <20191219160636.26316-1-msuchanek@suse.de>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

There is no way to just run the tests built into testmgr. Also it is
rarely possible to build testmgr modular due to KConfig dependencies.

Add a module that does not provide infrastructure, just runs testmgr
tests.

Signed-off-by: Michal Suchanek <msuchanek@suse.de>
---
 crypto/Kconfig            |   8 ++
 crypto/Makefile           |   3 +
 crypto/alg_test_desc.h    | 219 ++++++++++++++++++++++++++++++++++++++
 crypto/algboss.c          |   2 +
 crypto/algboss_runtests.c |  38 +++++++
 crypto/testmgr.c          |  71 +-----------
 crypto/testmgr.h          | 146 +------------------------
 crypto/testmgr_runtests.c |   1 +
 8 files changed, 277 insertions(+), 211 deletions(-)
 create mode 100644 crypto/alg_test_desc.h
 create mode 100644 crypto/algboss_runtests.c
 create mode 120000 crypto/testmgr_runtests.c

diff --git a/crypto/Kconfig b/crypto/Kconfig
index 5575d48473bd..956379b24c74 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -119,6 +119,14 @@ config CRYPTO_MANAGER
 	  Create default cryptographic template instantiations such as
 	  cbc(aes).
 
+config CRYPTO_MANAGER_RUNTESTS
+	tristate "Cryptographic algorithm manager: test module"
+	depends on CRYPTO_MANAGER2 && !CRYPTO_MANAGER_DISABLE_TESTS
+	default m
+	help
+	  Build a module that runs the tests from cryptographic algorithm
+	  manager when loaded.
+
 config CRYPTO_MANAGER2
 	def_tristate CRYPTO_MANAGER || (CRYPTO_MANAGER!=n && CRYPTO_ALGAPI=y)
 	select CRYPTO_AEAD2
diff --git a/crypto/Makefile b/crypto/Makefile
index 4ca12b6044f7..c296b27da29e 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -47,6 +47,9 @@ crypto_acompress-y += scompress.o
 obj-$(CONFIG_CRYPTO_ACOMP2) += crypto_acompress.o
 
 cryptomgr-y := algboss.o testmgr.o
+cryptomgr_runtests-y := testmgr_runtests.o algboss_runtests.o
+
+obj-$(CONFIG_CRYPTO_MANAGER_RUNTESTS) += cryptomgr_runtests.o
 
 obj-$(CONFIG_CRYPTO_MANAGER2) += cryptomgr.o
 obj-$(CONFIG_CRYPTO_USER) += crypto_user.o
diff --git a/crypto/alg_test_desc.h b/crypto/alg_test_desc.h
new file mode 100644
index 000000000000..a718092737d0
--- /dev/null
+++ b/crypto/alg_test_desc.h
@@ -0,0 +1,219 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+#ifndef CRYPTO_ALG_TEST_DESC_H
+#define CRYPTO_ALG_TEST_DESC_H
+
+#include <linux/oid_registry.h>
+
+/*
+ * hash_testvec:	structure to describe a hash (message digest) test
+ * @key:	Pointer to key (NULL if none)
+ * @plaintext:	Pointer to source data
+ * @digest:	Pointer to expected digest
+ * @psize:	Length of source data in bytes
+ * @ksize:	Length of @key in bytes (0 if no key)
+ * @setkey_error: Expected error from setkey()
+ * @digest_error: Expected error from digest()
+ */
+struct hash_testvec {
+	const char *key;
+	const char *plaintext;
+	const char *digest;
+	unsigned int psize;
+	unsigned short ksize;
+	int setkey_error;
+	int digest_error;
+};
+
+/*
+ * cipher_testvec:	structure to describe a symmetric cipher test
+ * @key:	Pointer to key
+ * @klen:	Length of @key in bytes
+ * @iv:		Pointer to IV.  If NULL, an all-zeroes IV is used.
+ * @iv_out:	Pointer to output IV, if applicable for the cipher.
+ * @ptext:	Pointer to plaintext
+ * @ctext:	Pointer to ciphertext
+ * @len:	Length of @ptext and @ctext in bytes
+ * @wk:		Does the test need CRYPTO_TFM_REQ_FORBID_WEAK_KEYS?
+ *		( e.g. test needs to fail due to a weak key )
+ * @fips_skip:	Skip the test vector in FIPS mode
+ * @generates_iv: Encryption should ignore the given IV, and output @iv_out.
+ *		  Decryption takes @iv_out.  Needed for AES Keywrap ("kw(aes)").
+ * @setkey_error: Expected error from setkey()
+ * @crypt_error: Expected error from encrypt() and decrypt()
+ */
+struct cipher_testvec {
+	const char *key;
+	const char *iv;
+	const char *iv_out;
+	const char *ptext;
+	const char *ctext;
+	unsigned char wk; /* weak key flag */
+	unsigned short klen;
+	unsigned int len;
+	bool fips_skip;
+	bool generates_iv;
+	int setkey_error;
+	int crypt_error;
+};
+
+/*
+ * aead_testvec:	structure to describe an AEAD test
+ * @key:	Pointer to key
+ * @iv:		Pointer to IV.  If NULL, an all-zeroes IV is used.
+ * @ptext:	Pointer to plaintext
+ * @assoc:	Pointer to associated data
+ * @ctext:	Pointer to the full authenticated ciphertext.  For AEADs that
+ *		produce a separate "ciphertext" and "authentication tag", these
+ *		two parts are concatenated: ciphertext || tag.
+ * @novrfy:	Decryption verification failure expected?
+ * @wk:		Does the test need CRYPTO_TFM_REQ_FORBID_WEAK_KEYS?
+ *		(e.g. setkey() needs to fail due to a weak key)
+ * @klen:	Length of @key in bytes
+ * @plen:	Length of @ptext in bytes
+ * @alen:	Length of @assoc in bytes
+ * @clen:	Length of @ctext in bytes
+ * @setkey_error: Expected error from setkey()
+ * @setauthsize_error: Expected error from setauthsize()
+ * @crypt_error: Expected error from encrypt() and decrypt()
+ */
+struct aead_testvec {
+	const char *key;
+	const char *iv;
+	const char *ptext;
+	const char *assoc;
+	const char *ctext;
+	unsigned char novrfy;
+	unsigned char wk;
+	unsigned char klen;
+	unsigned int plen;
+	unsigned int clen;
+	unsigned int alen;
+	int setkey_error;
+	int setauthsize_error;
+	int crypt_error;
+};
+
+struct cprng_testvec {
+	const char *key;
+	const char *dt;
+	const char *v;
+	const char *result;
+	unsigned char klen;
+	unsigned short dtlen;
+	unsigned short vlen;
+	unsigned short rlen;
+	unsigned short loops;
+};
+
+struct drbg_testvec {
+	const unsigned char *entropy;
+	size_t entropylen;
+	const unsigned char *entpra;
+	const unsigned char *entprb;
+	size_t entprlen;
+	const unsigned char *addtla;
+	const unsigned char *addtlb;
+	size_t addtllen;
+	const unsigned char *pers;
+	size_t perslen;
+	const unsigned char *expected;
+	size_t expectedlen;
+};
+
+struct akcipher_testvec {
+	const unsigned char *key;
+	const unsigned char *params;
+	const unsigned char *m;
+	const unsigned char *c;
+	unsigned int key_len;
+	unsigned int param_len;
+	unsigned int m_size;
+	unsigned int c_size;
+	bool public_key_vec;
+	bool siggen_sigver_test;
+	enum OID algo;
+};
+
+struct kpp_testvec {
+	const unsigned char *secret;
+	const unsigned char *b_secret;
+	const unsigned char *b_public;
+	const unsigned char *expected_a_public;
+	const unsigned char *expected_ss;
+	unsigned short secret_size;
+	unsigned short b_secret_size;
+	unsigned short b_public_size;
+	unsigned short expected_a_public_size;
+	unsigned short expected_ss_size;
+	bool genkey;
+};
+
+
+struct aead_test_suite {
+	const struct aead_testvec *vecs;
+	unsigned int count;
+};
+
+struct cipher_test_suite {
+	const struct cipher_testvec *vecs;
+	unsigned int count;
+};
+
+struct comp_test_suite {
+	struct {
+		const struct comp_testvec *vecs;
+		unsigned int count;
+	} comp, decomp;
+};
+
+struct hash_test_suite {
+	const struct hash_testvec *vecs;
+	unsigned int count;
+};
+
+struct cprng_test_suite {
+	const struct cprng_testvec *vecs;
+	unsigned int count;
+};
+
+struct drbg_test_suite {
+	const struct drbg_testvec *vecs;
+	unsigned int count;
+};
+
+struct akcipher_test_suite {
+	const struct akcipher_testvec *vecs;
+	unsigned int count;
+};
+
+struct kpp_test_suite {
+	const struct kpp_testvec *vecs;
+	unsigned int count;
+};
+
+struct alg_test_desc {
+	const char *alg;
+	const char *generic_driver;
+	int (*test)(const struct alg_test_desc *desc, const char *driver,
+		    u32 type, u32 mask);
+	int fips_allowed;	/* set if alg is allowed in fips mode */
+
+	union {
+		struct aead_test_suite aead;
+		struct cipher_test_suite cipher;
+		struct comp_test_suite comp;
+		struct hash_test_suite hash;
+		struct cprng_test_suite cprng;
+		struct drbg_test_suite drbg;
+		struct akcipher_test_suite akcipher;
+		struct kpp_test_suite kpp;
+	} suite;
+};
+
+int alg_test_cipher(const struct alg_test_desc *desc,
+		    const char *driver, u32 type, u32 mask);
+
+extern const struct alg_test_desc alg_test_descs[];
+extern const int nr_alg_test_descs;
+
+#endif /* CRYPTO_ALG_TEST_DESC_H */
diff --git a/crypto/algboss.c b/crypto/algboss.c
index a62149d6c839..be37c78c7833 100644
--- a/crypto/algboss.c
+++ b/crypto/algboss.c
@@ -300,5 +300,7 @@ static void __exit cryptomgr_exit(void)
 arch_initcall(cryptomgr_init);
 module_exit(cryptomgr_exit);
 
+EXPORT_SYMBOL_GPL(alg_test);
+
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("Crypto Algorithm Manager");
diff --git a/crypto/algboss_runtests.c b/crypto/algboss_runtests.c
new file mode 100644
index 000000000000..7aa3459cc4fc
--- /dev/null
+++ b/crypto/algboss_runtests.c
@@ -0,0 +1,38 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+#include <linux/module.h>
+#include "alg_test_desc.h"
+
+static int __init testmgr_runtests_init(void)
+{
+	int i;
+	int ret = 0;
+
+	for (i = 0; i < nr_alg_test_descs; i++) {
+		const char *alg = alg_test_descs[i].alg;
+		int rc;
+
+		pr_info("Testing %s ...", alg);
+		rc = alg_test_descs[i].test(alg_test_descs + i, alg, 0, 0);
+		switch (rc) {
+		case 0:
+			pr_info("PASSED\n");
+			break;
+		case -2:
+			pr_info("SKIPPED\n");
+			break;
+
+		default:
+			ret = rc;
+			pr_err("%s FAILED(%i)\n", alg, rc);
+		}
+	}
+	return ret;
+}
+
+static void __exit testmgr_runtests_exit(void) {}
+
+module_init(testmgr_runtests_init);
+module_exit(testmgr_runtests_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("Crypto Algorithm Manager Test Module");
diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index 82513b6b0abd..85d919285e81 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -79,67 +79,6 @@ int alg_test(const char *driver, const char *alg, u32 type, u32 mask)
 #define ENCRYPT 1
 #define DECRYPT 0
 
-struct aead_test_suite {
-	const struct aead_testvec *vecs;
-	unsigned int count;
-};
-
-struct cipher_test_suite {
-	const struct cipher_testvec *vecs;
-	unsigned int count;
-};
-
-struct comp_test_suite {
-	struct {
-		const struct comp_testvec *vecs;
-		unsigned int count;
-	} comp, decomp;
-};
-
-struct hash_test_suite {
-	const struct hash_testvec *vecs;
-	unsigned int count;
-};
-
-struct cprng_test_suite {
-	const struct cprng_testvec *vecs;
-	unsigned int count;
-};
-
-struct drbg_test_suite {
-	const struct drbg_testvec *vecs;
-	unsigned int count;
-};
-
-struct akcipher_test_suite {
-	const struct akcipher_testvec *vecs;
-	unsigned int count;
-};
-
-struct kpp_test_suite {
-	const struct kpp_testvec *vecs;
-	unsigned int count;
-};
-
-struct alg_test_desc {
-	const char *alg;
-	const char *generic_driver;
-	int (*test)(const struct alg_test_desc *desc, const char *driver,
-		    u32 type, u32 mask);
-	int fips_allowed;	/* set if alg is allowed in fips mode */
-
-	union {
-		struct aead_test_suite aead;
-		struct cipher_test_suite cipher;
-		struct comp_test_suite comp;
-		struct hash_test_suite hash;
-		struct cprng_test_suite cprng;
-		struct drbg_test_suite drbg;
-		struct akcipher_test_suite akcipher;
-		struct kpp_test_suite kpp;
-	} suite;
-};
-
 static void hexdump(unsigned char *buf, unsigned int len)
 {
 	print_hex_dump(KERN_CONT, "", DUMP_PREFIX_OFFSET,
@@ -3232,8 +3171,8 @@ static int test_cprng(struct crypto_rng *tfm,
 	return err;
 }
 
-static int alg_test_cipher(const struct alg_test_desc *desc,
-			   const char *driver, u32 type, u32 mask)
+int alg_test_cipher(const struct alg_test_desc *desc,
+		    const char *driver, u32 type, u32 mask)
 {
 	const struct cipher_test_suite *suite = &desc->suite.cipher;
 	struct crypto_cipher *tfm;
@@ -3865,7 +3804,7 @@ static int alg_test_null(const struct alg_test_desc *desc,
 #define __VECS(tv)	{ .vecs = tv, .count = ARRAY_SIZE(tv) }
 
 /* Please keep this list sorted by algorithm name. */
-static const struct alg_test_desc alg_test_descs[] = {
+const struct alg_test_desc alg_test_descs[] = {
 	{
 		.alg = "adiantum(xchacha12,aes)",
 		.generic_driver = "adiantum(xchacha12-generic,aes-generic,nhpoly1305-generic)",
@@ -5204,6 +5143,8 @@ static const struct alg_test_desc alg_test_descs[] = {
 	}
 };
 
+const int nr_alg_test_descs = ARRAY_SIZE(alg_test_descs);
+
 static void alg_check_test_descs_order(void)
 {
 	int i;
@@ -5341,5 +5282,3 @@ int alg_test(const char *driver, const char *alg, u32 type, u32 mask)
 }
 
 #endif /* CONFIG_CRYPTO_MANAGER_DISABLE_TESTS */
-
-EXPORT_SYMBOL_GPL(alg_test);
diff --git a/crypto/testmgr.h b/crypto/testmgr.h
index 48da646651cb..378a1bdce74f 100644
--- a/crypto/testmgr.h
+++ b/crypto/testmgr.h
@@ -20,154 +20,10 @@
 #ifndef _CRYPTO_TESTMGR_H
 #define _CRYPTO_TESTMGR_H
 
-#include <linux/oid_registry.h>
+#include "alg_test_desc.h"
 
 #define MAX_IVLEN		32
 
-/*
- * hash_testvec:	structure to describe a hash (message digest) test
- * @key:	Pointer to key (NULL if none)
- * @plaintext:	Pointer to source data
- * @digest:	Pointer to expected digest
- * @psize:	Length of source data in bytes
- * @ksize:	Length of @key in bytes (0 if no key)
- * @setkey_error: Expected error from setkey()
- * @digest_error: Expected error from digest()
- */
-struct hash_testvec {
-	const char *key;
-	const char *plaintext;
-	const char *digest;
-	unsigned int psize;
-	unsigned short ksize;
-	int setkey_error;
-	int digest_error;
-};
-
-/*
- * cipher_testvec:	structure to describe a symmetric cipher test
- * @key:	Pointer to key
- * @klen:	Length of @key in bytes
- * @iv:		Pointer to IV.  If NULL, an all-zeroes IV is used.
- * @iv_out:	Pointer to output IV, if applicable for the cipher.
- * @ptext:	Pointer to plaintext
- * @ctext:	Pointer to ciphertext
- * @len:	Length of @ptext and @ctext in bytes
- * @wk:		Does the test need CRYPTO_TFM_REQ_FORBID_WEAK_KEYS?
- * 		( e.g. test needs to fail due to a weak key )
- * @fips_skip:	Skip the test vector in FIPS mode
- * @generates_iv: Encryption should ignore the given IV, and output @iv_out.
- *		  Decryption takes @iv_out.  Needed for AES Keywrap ("kw(aes)").
- * @setkey_error: Expected error from setkey()
- * @crypt_error: Expected error from encrypt() and decrypt()
- */
-struct cipher_testvec {
-	const char *key;
-	const char *iv;
-	const char *iv_out;
-	const char *ptext;
-	const char *ctext;
-	unsigned char wk; /* weak key flag */
-	unsigned short klen;
-	unsigned int len;
-	bool fips_skip;
-	bool generates_iv;
-	int setkey_error;
-	int crypt_error;
-};
-
-/*
- * aead_testvec:	structure to describe an AEAD test
- * @key:	Pointer to key
- * @iv:		Pointer to IV.  If NULL, an all-zeroes IV is used.
- * @ptext:	Pointer to plaintext
- * @assoc:	Pointer to associated data
- * @ctext:	Pointer to the full authenticated ciphertext.  For AEADs that
- *		produce a separate "ciphertext" and "authentication tag", these
- *		two parts are concatenated: ciphertext || tag.
- * @novrfy:	Decryption verification failure expected?
- * @wk:		Does the test need CRYPTO_TFM_REQ_FORBID_WEAK_KEYS?
- *		(e.g. setkey() needs to fail due to a weak key)
- * @klen:	Length of @key in bytes
- * @plen:	Length of @ptext in bytes
- * @alen:	Length of @assoc in bytes
- * @clen:	Length of @ctext in bytes
- * @setkey_error: Expected error from setkey()
- * @setauthsize_error: Expected error from setauthsize()
- * @crypt_error: Expected error from encrypt() and decrypt()
- */
-struct aead_testvec {
-	const char *key;
-	const char *iv;
-	const char *ptext;
-	const char *assoc;
-	const char *ctext;
-	unsigned char novrfy;
-	unsigned char wk;
-	unsigned char klen;
-	unsigned int plen;
-	unsigned int clen;
-	unsigned int alen;
-	int setkey_error;
-	int setauthsize_error;
-	int crypt_error;
-};
-
-struct cprng_testvec {
-	const char *key;
-	const char *dt;
-	const char *v;
-	const char *result;
-	unsigned char klen;
-	unsigned short dtlen;
-	unsigned short vlen;
-	unsigned short rlen;
-	unsigned short loops;
-};
-
-struct drbg_testvec {
-	const unsigned char *entropy;
-	size_t entropylen;
-	const unsigned char *entpra;
-	const unsigned char *entprb;
-	size_t entprlen;
-	const unsigned char *addtla;
-	const unsigned char *addtlb;
-	size_t addtllen;
-	const unsigned char *pers;
-	size_t perslen;
-	const unsigned char *expected;
-	size_t expectedlen;
-};
-
-struct akcipher_testvec {
-	const unsigned char *key;
-	const unsigned char *params;
-	const unsigned char *m;
-	const unsigned char *c;
-	unsigned int key_len;
-	unsigned int param_len;
-	unsigned int m_size;
-	unsigned int c_size;
-	bool public_key_vec;
-	bool siggen_sigver_test;
-	enum OID algo;
-};
-
-struct kpp_testvec {
-	const unsigned char *secret;
-	const unsigned char *b_secret;
-	const unsigned char *b_public;
-	const unsigned char *expected_a_public;
-	const unsigned char *expected_ss;
-	unsigned short secret_size;
-	unsigned short b_secret_size;
-	unsigned short b_public_size;
-	unsigned short expected_a_public_size;
-	unsigned short expected_ss_size;
-	bool genkey;
-};
-
 static const char zeroed_string[48];
 
 /*
diff --git a/crypto/testmgr_runtests.c b/crypto/testmgr_runtests.c
new file mode 120000
index 000000000000..e2a85037239d
--- /dev/null
+++ b/crypto/testmgr_runtests.c
@@ -0,0 +1 @@
+testmgr.c
\ No newline at end of file
-- 
2.23.0

