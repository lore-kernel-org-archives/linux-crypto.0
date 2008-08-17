From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: crypto: skcipher - Use RNG interface instead of get_random_bytes
Date: Sun, 17 Aug 2008 22:22:33 +1000
Message-ID: <20080817122233.GA26195@gondor.apana.org.au>
References: <20080811202607.GA11527@hmsreliant.think-freely.org> <20080814115137.GA5721@gondor.apana.org.au> <20080814122331.GA21061@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	davem@davemloft.net
To: Neil Horman <nhorman@tuxdriver.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:60689 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752658AbYHQMWg (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 17 Aug 2008 08:22:36 -0400
Content-Disposition: inline
In-Reply-To: <20080814122331.GA21061@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Aug 14, 2008 at 10:23:31PM +1000, Herbert Xu wrote:
> 
> And here is the IV generator patch on top.

This also dead-locked if built as modules.  I've split out the
IV generators from crypto_blkcipher so it doesn't interfere with
cryptomgr.

commit 106475b7c368794f22493fc67d98b874eb0f9383
Author: Herbert Xu <herbert@gondor.apana.org.au>
Date:   Sun Aug 17 18:04:30 2008 +1000

    crypto: skcipher - Move IV generators into their own modules
    
    This patch moves the default IV generators into their own modules
    in order to break a dependency loop between cryptomgr, rng, and
    blkcipher.
    
    Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/crypto/Makefile b/crypto/Makefile
index 42e3980..ed2be05 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -13,9 +13,9 @@ obj-$(CONFIG_CRYPTO_AEAD) += aead.o
 
 crypto_blkcipher-objs := ablkcipher.o
 crypto_blkcipher-objs += blkcipher.o
-crypto_blkcipher-objs += chainiv.o
-crypto_blkcipher-objs += eseqiv.o
 obj-$(CONFIG_CRYPTO_BLKCIPHER) += crypto_blkcipher.o
+obj-$(CONFIG_CRYPTO_BLKCIPHER) += chainiv.o
+obj-$(CONFIG_CRYPTO_BLKCIPHER) += eseqiv.o
 obj-$(CONFIG_CRYPTO_SEQIV) += seqiv.o
 
 crypto_hash-objs := hash.o
diff --git a/crypto/blkcipher.c b/crypto/blkcipher.c
index 185f955..4a7e65c 100644
--- a/crypto/blkcipher.c
+++ b/crypto/blkcipher.c
@@ -696,34 +696,5 @@ void skcipher_geniv_exit(struct crypto_tfm *tfm)
 }
 EXPORT_SYMBOL_GPL(skcipher_geniv_exit);
 
-static int __init blkcipher_module_init(void)
-{
-	int err;
-
-	err = chainiv_module_init();
-	if (err)
-		goto out;
-
-	err = eseqiv_module_init();
-	if (err)
-		goto eseqiv_err;
-
-out:
-	return err;
-
-eseqiv_err:
-	chainiv_module_exit();
-	goto out;
-}
-
-static void __exit blkcipher_module_exit(void)
-{
-	eseqiv_module_exit();
-	chainiv_module_exit();
-}
-
-module_init(blkcipher_module_init);
-module_exit(blkcipher_module_exit);
-
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("Generic block chaining cipher type");
diff --git a/crypto/chainiv.c b/crypto/chainiv.c
index 9affade..cf68d43 100644
--- a/crypto/chainiv.c
+++ b/crypto/chainiv.c
@@ -320,12 +320,18 @@ static struct crypto_template chainiv_tmpl = {
 	.module = THIS_MODULE,
 };
 
-int __init chainiv_module_init(void)
+static int __init chainiv_module_init(void)
 {
 	return crypto_register_template(&chainiv_tmpl);
 }
 
-void chainiv_module_exit(void)
+static void chainiv_module_exit(void)
 {
 	crypto_unregister_template(&chainiv_tmpl);
 }
+
+module_init(chainiv_module_init);
+module_exit(chainiv_module_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("Chain IV Generator");
diff --git a/crypto/eseqiv.c b/crypto/eseqiv.c
index 881d309..f5def21 100644
--- a/crypto/eseqiv.c
+++ b/crypto/eseqiv.c
@@ -248,12 +248,18 @@ static struct crypto_template eseqiv_tmpl = {
 	.module = THIS_MODULE,
 };
 
-int __init eseqiv_module_init(void)
+static int __init eseqiv_module_init(void)
 {
 	return crypto_register_template(&eseqiv_tmpl);
 }
 
-void __exit eseqiv_module_exit(void)
+static void __exit eseqiv_module_exit(void)
 {
 	crypto_unregister_template(&eseqiv_tmpl);
 }
+
+module_init(eseqiv_module_init);
+module_exit(eseqiv_module_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("Encrypted Sequence Number IV Generator");
diff --git a/include/crypto/internal/skcipher.h b/include/crypto/internal/skcipher.h
index ccc32ba..2ba42cd 100644
--- a/include/crypto/internal/skcipher.h
+++ b/include/crypto/internal/skcipher.h
@@ -15,7 +15,6 @@
 
 #include <crypto/algapi.h>
 #include <crypto/skcipher.h>
-#include <linux/init.h>
 #include <linux/types.h>
 
 struct rtattr;
@@ -65,11 +64,6 @@ void skcipher_geniv_free(struct crypto_instance *inst);
 int skcipher_geniv_init(struct crypto_tfm *tfm);
 void skcipher_geniv_exit(struct crypto_tfm *tfm);
 
-int __init eseqiv_module_init(void);
-void __exit eseqiv_module_exit(void);
-int __init chainiv_module_init(void);
-void chainiv_module_exit(void);
