From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: obscure state information on free
Date: Sun, 17 Aug 2008 22:20:47 +1000
Message-ID: <20080817122047.GA26084@gondor.apana.org.au>
References: <20080811202607.GA11527@hmsreliant.think-freely.org> <20080814115137.GA5721@gondor.apana.org.au> <20080814122137.GA10969@hmsendeavour.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	davem@davemloft.net
To: Neil Horman <nhorman@tuxdriver.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:60684 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752523AbYHQMUv (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 17 Aug 2008 08:20:51 -0400
Content-Disposition: inline
In-Reply-To: <20080814122137.GA10969@hmsendeavour.rdu.redhat.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Aug 14, 2008 at 08:21:37AM -0400, Neil Horman wrote:
> 
> Looks great to me.  Thanks Herbert!

Unfortunately it didn't quite work :)

First of all there was a module dependency loop between cryptomgr,
rng and crypto_blkcipher.  This is fixed by putting krng in its
own module.  Also I made a typo in the rng_reset helper so it
ended up calling itself over and over again.

Here is an incremental patch to fix this up.  I've also renamed
rngapi.c to rng.c for consistency.

There is also a new global rng object for everyone to use rather
than having it allocated by every user separately.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
--
diff --git a/crypto/Makefile b/crypto/Makefile
index a14ed7d..42e3980 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -24,8 +24,6 @@ obj-$(CONFIG_CRYPTO_HASH) += crypto_hash.o
 
 cryptomgr-objs := algboss.o testmgr.o
 
-rng-objs := rngapi.o krng.o
-
 obj-$(CONFIG_CRYPTO_MANAGER) += cryptomgr.o
 obj-$(CONFIG_CRYPTO_HMAC) += hmac.o
 obj-$(CONFIG_CRYPTO_XCBC) += xcbc.o
@@ -74,6 +72,7 @@ obj-$(CONFIG_CRYPTO_CRC32C) += crc32c.o
 obj-$(CONFIG_CRYPTO_AUTHENC) += authenc.o
 obj-$(CONFIG_CRYPTO_LZO) += lzo.o
 obj-$(CONFIG_CRYPTO_RNG) += rng.o
+obj-$(CONFIG_CRYPTO_RNG) += krng.o
 obj-$(CONFIG_CRYPTO_ANSI_CPRNG) += ansi_cprng.o
 obj-$(CONFIG_CRYPTO_TEST) += tcrypt.o
 
diff --git a/crypto/krng.c b/crypto/krng.c
index 8ef62a9..4328bb3 100644
--- a/crypto/krng.c
+++ b/crypto/krng.c
@@ -62,5 +62,5 @@ module_init(krng_mod_init);
 module_exit(krng_mod_fini);
 
 MODULE_LICENSE("GPL");
-MODULE_DESCRIPTION("Random Number Generator API");
+MODULE_DESCRIPTION("Kernel Random Number Generator");
 MODULE_ALIAS("stdrng");
diff --git a/crypto/rng.c b/crypto/rng.c
new file mode 100644
index 0000000..6e94bc7
--- /dev/null
+++ b/crypto/rng.c
@@ -0,0 +1,126 @@
+/*
+ * Cryptographic API.
+ *
+ * RNG operations.
+ *
+ * Copyright (c) 2008 Neil Horman <nhorman@tuxdriver.com>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the Free
+ * Software Foundation; either version 2 of the License, or (at your option)
+ * any later version.
+ *
+ */
+
+#include <asm/atomic.h>
+#include <crypto/internal/rng.h>
+#include <linux/err.h>
+#include <linux/module.h>
+#include <linux/mutex.h>
+#include <linux/random.h>
+#include <linux/seq_file.h>
+#include <linux/string.h>
+
+static DEFINE_MUTEX(crypto_default_rng_lock);
+struct crypto_rng *crypto_default_rng;
+EXPORT_SYMBOL_GPL(crypto_default_rng);
+static int crypto_default_rng_refcnt;
+
+static int rngapi_reset(struct crypto_rng *tfm, u8 *seed, unsigned int slen)
+{
+	u8 *buf = NULL;
+	int err;
+
+	if (!seed && slen) {
+		buf = kmalloc(slen, GFP_KERNEL);
+		if (!buf)
+			return -ENOMEM;
+
+		get_random_bytes(buf, slen);
+		seed = buf;
+	}
+
+	err = crypto_rng_alg(tfm)->rng_reset(tfm, seed, slen);
+
+	kfree(buf);
+	return err;
+}
+
+static int crypto_init_rng_ops(struct crypto_tfm *tfm, u32 type, u32 mask)
+{
+	struct rng_alg *alg = &tfm->__crt_alg->cra_rng;
+	struct rng_tfm *ops = &tfm->crt_rng;
+
+	ops->rng_gen_random = alg->rng_make_random;
+	ops->rng_reset = rngapi_reset;
+
+	return 0;
+}
+
+static void crypto_rng_show(struct seq_file *m, struct crypto_alg *alg)
+	__attribute__ ((unused));
+static void crypto_rng_show(struct seq_file *m, struct crypto_alg *alg)
+{
+	seq_printf(m, "type         : rng\n");
+	seq_printf(m, "seedsize     : %u\n", alg->cra_rng.seedsize);
+}
+
+static unsigned int crypto_rng_ctxsize(struct crypto_alg *alg, u32 type,
+				       u32 mask)
+{
+	return alg->cra_ctxsize;
+}
+
+const struct crypto_type crypto_rng_type = {
+	.ctxsize = crypto_rng_ctxsize,
+	.init = crypto_init_rng_ops,
+#ifdef CONFIG_PROC_FS
+	.show = crypto_rng_show,
+#endif
+};
+EXPORT_SYMBOL_GPL(crypto_rng_type);
+
+int crypto_get_default_rng(void)
+{
+	struct crypto_rng *rng;
+	int err;
+
+	mutex_lock(&crypto_default_rng_lock);
+	if (!crypto_default_rng) {
+		rng = crypto_alloc_rng("stdrng", 0, 0);
+		err = PTR_ERR(rng);
+		if (IS_ERR(rng))
+			goto unlock;
+
+		err = crypto_rng_reset(rng, NULL, crypto_rng_seedsize(rng));
+		if (err) {
+			crypto_free_rng(rng);
+			goto unlock;
+		}
+
+		crypto_default_rng = rng;
+	}
+
+	crypto_default_rng_refcnt++;
+	err = 0;
+
+unlock:
+	mutex_unlock(&crypto_default_rng_lock);
+
+	return err;
+}
+EXPORT_SYMBOL_GPL(crypto_get_default_rng);
+
+void crypto_put_default_rng(void)
+{
+	mutex_lock(&crypto_default_rng_lock);
+	if (!--crypto_default_rng_refcnt) {
+		crypto_free_rng(crypto_default_rng);
+		crypto_default_rng = NULL;
+	}
+	mutex_unlock(&crypto_default_rng_lock);
+}
+EXPORT_SYMBOL_GPL(crypto_put_default_rng);
+
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("Random Number Genertor");
diff --git a/crypto/rngapi.c b/crypto/rngapi.c
deleted file mode 100644
index ea57697..0000000
--- a/crypto/rngapi.c
+++ /dev/null
@@ -1,74 +0,0 @@
-/*
- * Cryptographic API.
- *
- * RNG operations.
- *
- * Copyright (c) 2008 Neil Horman <nhorman@tuxdriver.com>
- *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of the GNU General Public License as published by the Free
- * Software Foundation; either version 2 of the License, or (at your option)
- * any later version.
- *
- */
-
-#include <crypto/internal/rng.h>
-#include <linux/errno.h>
-#include <linux/module.h>
-#include <linux/random.h>
-#include <linux/seq_file.h>
-#include <linux/string.h>
-
-static int rngapi_reset(struct crypto_rng *tfm, u8 *seed, unsigned int slen)
-{
-	u8 *buf = NULL;
-	int err;
-
-	if (!seed && slen) {
-		buf = kmalloc(slen, GFP_KERNEL);
-		if (!buf)
-			return -ENOMEM;
-
-		get_random_bytes(buf, slen);
-		seed = buf;
-	}
-
-	err = crypto_rng_crt(tfm)->rng_reset(tfm, seed, slen);
-
-	kfree(buf);
-	return err;
-}
-
-static int crypto_init_rng_ops(struct crypto_tfm *tfm, u32 type, u32 mask)
-{
-	struct rng_alg *alg = &tfm->__crt_alg->cra_rng;
-	struct rng_tfm *ops = &tfm->crt_rng;
-
-	ops->rng_gen_random = alg->rng_make_random;
-	ops->rng_reset = rngapi_reset;
-
-	return 0;
-}
-
-static void crypto_rng_show(struct seq_file *m, struct crypto_alg *alg)
-	__attribute__ ((unused));
-static void crypto_rng_show(struct seq_file *m, struct crypto_alg *alg)
-{
-	seq_printf(m, "type         : rng\n");
-	seq_printf(m, "seedsize     : %u\n", alg->cra_rng.seedsize);
-}
-
-static unsigned int crypto_rng_ctxsize(struct crypto_alg *alg, u32 type,
-				       u32 mask)
-{
-	return alg->cra_ctxsize;
-}
