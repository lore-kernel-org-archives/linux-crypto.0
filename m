From: Marcel Holtmann <marcel@holtmann.org>
Subject: [PATCH] crypto: Fix ASN.1 key handling for RSA akcipher
Date: Fri, 28 Aug 2015 07:28:58 +0200
Message-ID: <1440739738-19587-1-git-send-email-marcel@holtmann.org>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:45311 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751054AbbH1F3G (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 28 Aug 2015 01:29:06 -0400
Received: from aeonflux.intel.com (S01066c709fd52e10.vc.shawcable.net [50.67.192.56])
	by mail.holtmann.org (Postfix) with ESMTPSA id B57A78B339
	for <linux-crypto@vger.kernel.org>; Fri, 28 Aug 2015 07:29:03 +0200 (CEST)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The RSA algorithm provides two ASN.1 key types. One for RSA Private Key
and another for RSA Public Key. Use these two already defined ASN.1
definitions instead of inventing a new one.

Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
---
 crypto/Makefile           |  9 ++++++---
 crypto/rsa_helper.c       | 13 +++++++++----
 crypto/rsakey.asn1        |  5 -----
 crypto/rsaprivatekey.asn1 | 13 +++++++++++++
 crypto/rsapublickey.asn1  |  4 ++++
 5 files changed, 32 insertions(+), 12 deletions(-)
 delete mode 100644 crypto/rsakey.asn1
 create mode 100644 crypto/rsaprivatekey.asn1
 create mode 100644 crypto/rsapublickey.asn1

diff --git a/crypto/Makefile b/crypto/Makefile
index 3cc91c3301c7..0b056c411aa7 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -31,10 +31,13 @@ obj-$(CONFIG_CRYPTO_HASH2) += crypto_hash.o
 obj-$(CONFIG_CRYPTO_PCOMP2) += pcompress.o
 obj-$(CONFIG_CRYPTO_AKCIPHER2) += akcipher.o
 
-$(obj)/rsakey-asn1.o: $(obj)/rsakey-asn1.c $(obj)/rsakey-asn1.h
-clean-files += rsakey-asn1.c rsakey-asn1.h
+$(obj)/rsapublickey-asn1.o: $(obj)/rsapublickey-asn1.c $(obj)/rsapublickey-asn1.h
+clean-files += rsapublickey-asn1.c rsapublickey-asn1.h
 
-rsa_generic-y := rsakey-asn1.o
+$(obj)/rsaprivatekey-asn1.o: $(obj)/rsaprivatekey-asn1.c $(obj)/rsaprivatekey-asn1.h
+clean-files += rsaprivatekey-asn1.c rsaprivatekey-asn1.h
+
+rsa_generic-y := rsapublickey-asn1.o rsaprivatekey-asn1.o
 rsa_generic-y += rsa.o
 rsa_generic-y += rsa_helper.o
 obj-$(CONFIG_CRYPTO_RSA) += rsa_generic.o
diff --git a/crypto/rsa_helper.c b/crypto/rsa_helper.c
index 8d96ce969b44..26617e3132fb 100644
--- a/crypto/rsa_helper.c
+++ b/crypto/rsa_helper.c
@@ -15,7 +15,8 @@
 #include <linux/err.h>
 #include <linux/fips.h>
 #include <crypto/internal/rsa.h>
-#include "rsakey-asn1.h"
+#include "rsapublickey-asn1.h"
+#include "rsaprivatekey-asn1.h"
 
 int rsa_get_n(void *context, size_t hdrlen, unsigned char tag,
 	      const void *value, size_t vlen)
@@ -109,9 +110,13 @@ int rsa_parse_key(struct rsa_key *rsa_key, const void *key,
 	int ret;
 
 	free_mpis(rsa_key);
-	ret = asn1_ber_decoder(&rsakey_decoder, rsa_key, key, key_len);
-	if (ret < 0)
-		goto error;
+	ret = asn1_ber_decoder(&rsapublickey_decoder, rsa_key, key, key_len);
+	if (ret < 0) {
+		ret = asn1_ber_decoder(&rsaprivatekey_decoder, rsa_key,
+				       key, key_len);
+		if (ret < 0)
+			goto error;
+	}
 
 	return 0;
 error:
diff --git a/crypto/rsakey.asn1 b/crypto/rsakey.asn1
deleted file mode 100644
index 3c7b5df7b428..000000000000
--- a/crypto/rsakey.asn1
+++ /dev/null
@@ -1,5 +0,0 @@
-RsaKey ::= SEQUENCE {
-	n INTEGER ({ rsa_get_n }),
-	e INTEGER ({ rsa_get_e }),
-	d INTEGER ({ rsa_get_d })
-}
diff --git a/crypto/rsaprivatekey.asn1 b/crypto/rsaprivatekey.asn1
new file mode 100644
index 000000000000..58dddc7c1536
--- /dev/null
+++ b/crypto/rsaprivatekey.asn1
@@ -0,0 +1,13 @@
+RSAPrivateKey ::= SEQUENCE {
+	version		Version,
+	modulus		INTEGER ({ rsa_get_n }),	-- n
+	publicExponent	INTEGER ({ rsa_get_e }),	-- e
+	privateExponent	INTEGER ({ rsa_get_d }),	-- d
+	prime1		INTEGER,			-- p
+	prime2		INTEGER,			-- q
+	exponent1	INTEGER,			-- d mod (p-1)
+	exponent2	INTEGER,			-- d mod (q-1)
+	coefficient	INTEGER				-- (inverse of q) mod p
+}
+
+Version ::= INTEGER
diff --git a/crypto/rsapublickey.asn1 b/crypto/rsapublickey.asn1
new file mode 100644
index 000000000000..8f7f8760f2a9
--- /dev/null
+++ b/crypto/rsapublickey.asn1
@@ -0,0 +1,4 @@
+RSAPublicKey ::= SEQUENCE {
+	modulus		INTEGER ({ rsa_get_n }),	-- n
+	publicExponent	INTEGER ({ rsa_get_e })		-- e
+}
-- 
2.4.3
