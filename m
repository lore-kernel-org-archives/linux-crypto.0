From: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Subject: [PATCH] [crypto] fix lrw,pcbc and xts blockmode
Date: Wed, 10 Oct 2007 01:18:12 +0200
Message-ID: <E1IfOiI-0003kz-Uf@Chamillionaire.breakpoint.cc>
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:47426 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751504AbXJIXmN (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 9 Oct 2007 19:42:13 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Commit 553011f7cc9b86e10f157bf175bf7c883039c8c6
[CRYPTO] blkcipher: Add IV generation

broke the three block modes because the new logic expects the
block mode to provide the IV instead of the crypto user.
Now the three block modes are using the same "random" function
for IV creating like cbc does.

Signed-off-by: Sebastian Siewior <sebastian@breakpoint.cc>
---

Herbert, with that patch tcrypt mode=200 works for lrw/xts again.
For some reason, the default tcrypt run fails for ecb(xtea) in 
encryption test 3 only. 

diff --git a/crypto/Kconfig b/crypto/Kconfig
index 083d2e1..b7e4f05 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -167,6 +167,7 @@ config CRYPTO_PCBC
 	tristate "PCBC support"
 	select CRYPTO_BLKCIPHER
 	select CRYPTO_MANAGER
+	select CRYPTO_CBC
 	help
 	  PCBC: Propagating Cipher Block Chaining mode
 	  This block cipher algorithm is required for RxRPC.
@@ -177,6 +178,7 @@ config CRYPTO_LRW
 	select CRYPTO_BLKCIPHER
 	select CRYPTO_MANAGER
 	select CRYPTO_GF128MUL
+	select CRYPTO_CBC
 	help
 	  LRW: Liskov Rivest Wagner, a tweakable, non malleable, non movable
 	  narrow block cipher mode for dm-crypt.  Use it with cipher
@@ -190,6 +192,7 @@ config CRYPTO_XTS
 	select CRYPTO_BLKCIPHER
 	select CRYPTO_MANAGER
 	select CRYPTO_GF128MUL
+	select CRYPTO_CBC
 	help
 	  XTS: IEEE1619/D16 narrow block cipher use with aes-xts-plain,
 	  key size 256, 384 or 512 bits. This implementation currently
diff --git a/crypto/lrw.c b/crypto/lrw.c
index 621095d..1f016fd 100644
--- a/crypto/lrw.c
+++ b/crypto/lrw.c
@@ -17,6 +17,7 @@
  *
  * The test vectors are included in the testing module tcrypt.[ch] */
 #include <crypto/algapi.h>
+#include <crypto/cbc.h>
 #include <linux/err.h>
 #include <linux/init.h>
 #include <linux/kernel.h>
@@ -271,6 +272,7 @@ static struct crypto_instance *alloc(struct rtattr **tb)
 	inst->alg.cra_blkcipher.setkey = setkey;
 	inst->alg.cra_blkcipher.encrypt = encrypt;
 	inst->alg.cra_blkcipher.decrypt = decrypt;
+	inst->alg.cra_blkcipher.geniv = crypto_cbc_geniv;
 
 out_put_alg:
 	crypto_mod_put(alg);
diff --git a/crypto/pcbc.c b/crypto/pcbc.c
index c3ed8a1..eb3e581 100644
--- a/crypto/pcbc.c
+++ b/crypto/pcbc.c
@@ -15,6 +15,7 @@
  */
 
 #include <crypto/algapi.h>
+#include <crypto/cbc.h>
 #include <linux/err.h>
 #include <linux/init.h>
 #include <linux/kernel.h>
@@ -318,6 +319,7 @@ static struct crypto_instance *crypto_pcbc_alloc(struct rtattr **tb)
 	inst->alg.cra_blkcipher.setkey = crypto_pcbc_setkey;
 	inst->alg.cra_blkcipher.encrypt = crypto_pcbc_encrypt;
 	inst->alg.cra_blkcipher.decrypt = crypto_pcbc_decrypt;
+	inst->alg.cra_blkcipher.geniv = crypto_cbc_geniv;
 
 out_put_alg:
 	crypto_mod_put(alg);
diff --git a/crypto/xts.c b/crypto/xts.c
index 8eb08bf..b5d5b57 100644
--- a/crypto/xts.c
+++ b/crypto/xts.c
@@ -14,6 +14,7 @@
  * any later version.
  */
 #include <crypto/algapi.h>
+#include <crypto/cbc.h>
 #include <linux/err.h>
 #include <linux/init.h>
 #include <linux/kernel.h>
@@ -256,6 +257,7 @@ static struct crypto_instance *alloc(struct rtattr **tb)
 	inst->alg.cra_blkcipher.setkey = setkey;
 	inst->alg.cra_blkcipher.encrypt = encrypt;
 	inst->alg.cra_blkcipher.decrypt = decrypt;
+	inst->alg.cra_blkcipher.geniv = crypto_cbc_geniv;
 
 out_put_alg:
 	crypto_mod_put(alg);
-- 
1.5.3.4
