From: Tim Chen <tim.c.chen@linux.intel.com>
Subject: [PATCH] crypto: Add soft module dependency to load HW accelerated
 crypto modules
Date: Fri, 14 Feb 2014 11:14:37 -0800
Message-ID: <1392405277.27116.72.camel@schen9-DESK>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Tim Chen <tim.c.chen@linux.intel.com>, linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"H. Peter Anvin" <hpa@zytor.com>,
	"David S.Miller" <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:50800 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751948AbaBNTOw (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 14 Feb 2014 14:14:52 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

We added the soft module dependency of various crypto algorithm's module alias
 to generic crypto algorithm's module. This loads hardware accelerated
 modules and uses them when available.

Signed-off-by: Tim Chen <tim.c.chen@linux.intel.com>
---
 crypto/blowfish_generic.c | 1 +
 crypto/camellia_generic.c | 1 +
 crypto/cast5_generic.c    | 1 +
 crypto/cast6_generic.c    | 1 +
 crypto/ghash-generic.c    | 1 +
 crypto/salsa20_generic.c  | 1 +
 crypto/serpent_generic.c  | 1 +
 crypto/sha1_generic.c     | 1 +
 crypto/sha256_generic.c   | 2 ++
 crypto/sha512_generic.c   | 2 ++
 crypto/twofish_generic.c  | 1 +
 11 files changed, 13 insertions(+)

diff --git a/crypto/blowfish_generic.c b/crypto/blowfish_generic.c
index 8baf544..6c09e17 100644
--- a/crypto/blowfish_generic.c
+++ b/crypto/blowfish_generic.c
@@ -139,3 +139,4 @@ module_exit(blowfish_mod_fini);
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("Blowfish Cipher Algorithm");
 MODULE_ALIAS("blowfish");
+MODULE_SOFTDEP("pre: blowfish");
diff --git a/crypto/camellia_generic.c b/crypto/camellia_generic.c
index 26bcd7a..c6a1200 100644
--- a/crypto/camellia_generic.c
+++ b/crypto/camellia_generic.c
@@ -1099,3 +1099,4 @@ module_exit(camellia_fini);
 MODULE_DESCRIPTION("Camellia Cipher Algorithm");
 MODULE_LICENSE("GPL");
 MODULE_ALIAS("camellia");
+MODULE_SOFTDEP("pre: camellia");
diff --git a/crypto/cast5_generic.c b/crypto/cast5_generic.c
index 5558f63..58d8c5f 100644
--- a/crypto/cast5_generic.c
+++ b/crypto/cast5_generic.c
@@ -550,3 +550,4 @@ module_exit(cast5_mod_fini);
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("Cast5 Cipher Algorithm");
 MODULE_ALIAS("cast5");
+MODULE_SOFTDEP("pre: cast5");
diff --git a/crypto/cast6_generic.c b/crypto/cast6_generic.c
index de73252..b277744 100644
--- a/crypto/cast6_generic.c
+++ b/crypto/cast6_generic.c
@@ -292,3 +292,4 @@ module_exit(cast6_mod_fini);
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("Cast6 Cipher Algorithm");
 MODULE_ALIAS("cast6");
+MODULE_SOFTDEP("pre: cast6");
diff --git a/crypto/ghash-generic.c b/crypto/ghash-generic.c
index 9d3f0c6..32814ab 100644
--- a/crypto/ghash-generic.c
+++ b/crypto/ghash-generic.c
@@ -173,3 +173,4 @@ module_exit(ghash_mod_exit);
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("GHASH Message Digest Algorithm");
 MODULE_ALIAS("ghash");
+MODULE_SOFTDEP("pre: ghash");
diff --git a/crypto/salsa20_generic.c b/crypto/salsa20_generic.c
index 9a4770c..2c7a308 100644
--- a/crypto/salsa20_generic.c
+++ b/crypto/salsa20_generic.c
@@ -249,3 +249,4 @@ module_exit(salsa20_generic_mod_fini);
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION ("Salsa20 stream cipher algorithm");
 MODULE_ALIAS("salsa20");
+MODULE_SOFTDEP("pre: salsa20");
diff --git a/crypto/serpent_generic.c b/crypto/serpent_generic.c
index 7ddbd7e..61eb7a7 100644
--- a/crypto/serpent_generic.c
+++ b/crypto/serpent_generic.c
@@ -667,3 +667,4 @@ MODULE_DESCRIPTION("Serpent and tnepres (kerneli compatible serpent reversed) Ci
 MODULE_AUTHOR("Dag Arne Osvik <osvik@ii.uib.no>");
 MODULE_ALIAS("tnepres");
 MODULE_ALIAS("serpent");
+MODULE_SOFTDEP("pre: serpent");
diff --git a/crypto/sha1_generic.c b/crypto/sha1_generic.c
index 4279480..0af944b 100644
--- a/crypto/sha1_generic.c
+++ b/crypto/sha1_generic.c
@@ -154,3 +154,4 @@ MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("SHA1 Secure Hash Algorithm");
 
 MODULE_ALIAS("sha1");
+MODULE_SOFTDEP("pre: sha1");
diff --git a/crypto/sha256_generic.c b/crypto/sha256_generic.c
index 5433667..227d570 100644
--- a/crypto/sha256_generic.c
+++ b/crypto/sha256_generic.c
@@ -385,4 +385,6 @@ MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("SHA-224 and SHA-256 Secure Hash Algorithm");
 
 MODULE_ALIAS("sha224");
+MODULE_SOFTDEP("pre: sha224");
 MODULE_ALIAS("sha256");
+MODULE_SOFTDEP("pre: sha256");
diff --git a/crypto/sha512_generic.c b/crypto/sha512_generic.c
index 6ed124f..b1cf774 100644
--- a/crypto/sha512_generic.c
+++ b/crypto/sha512_generic.c
@@ -288,4 +288,6 @@ MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("SHA-512 and SHA-384 Secure Hash Algorithms");
 
 MODULE_ALIAS("sha384");
+MODULE_SOFTDEP("pre: sha384");
 MODULE_ALIAS("sha512");
+MODULE_SOFTDEP("pre: sha512");
diff --git a/crypto/twofish_generic.c b/crypto/twofish_generic.c
index 2d50005..4239386 100644
--- a/crypto/twofish_generic.c
+++ b/crypto/twofish_generic.c
@@ -212,3 +212,4 @@ module_exit(twofish_mod_fini);
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION ("Twofish Cipher Algorithm");
 MODULE_ALIAS("twofish");
+MODULE_SOFTDEP("pre: twofish");
-- 
1.7.11.7
