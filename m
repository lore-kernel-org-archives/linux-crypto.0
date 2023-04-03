Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 478B8C76196
	for <linux-crypto@archiver.kernel.org>; Mon,  3 Apr 2023 04:48:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229681AbjDCEsu (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 3 Apr 2023 00:48:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229670AbjDCEst (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 3 Apr 2023 00:48:49 -0400
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E52F8A4A
        for <linux-crypto@vger.kernel.org>; Sun,  2 Apr 2023 21:48:47 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1pjC7W-00BbZG-Ao; Mon, 03 Apr 2023 12:48:43 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 03 Apr 2023 12:48:42 +0800
Date:   Mon, 3 Apr 2023 12:48:42 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: [PATCH] crypto: api - Move low-level functions into algapi.h
Message-ID: <ZCpaqiwr5zC+lN+F@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

A number of low-level functions were exposed in crypto.h.  Move
them into algapi.h (and internal.h).

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/internal.h       |    2 ++
 crypto/tcrypt.c         |   11 +++++++----
 include/crypto/algapi.h |   14 ++++++++++++++
 include/linux/crypto.h  |   30 +++---------------------------
 4 files changed, 26 insertions(+), 31 deletions(-)

diff --git a/crypto/internal.h b/crypto/internal.h
index 932f0aafddc3..f84dfe6491e5 100644
--- a/crypto/internal.h
+++ b/crypto/internal.h
@@ -47,6 +47,8 @@ extern struct list_head crypto_alg_list;
 extern struct rw_semaphore crypto_alg_sem;
 extern struct blocking_notifier_head crypto_chain;
 
+int alg_test(const char *driver, const char *alg, u32 type, u32 mask);
+
 #ifdef CONFIG_CRYPTO_MANAGER_DISABLE_TESTS
 static inline bool crypto_boot_test_finished(void)
 {
diff --git a/crypto/tcrypt.c b/crypto/tcrypt.c
index 6521feec7756..202ca1a3105d 100644
--- a/crypto/tcrypt.c
+++ b/crypto/tcrypt.c
@@ -25,14 +25,17 @@
 #include <linux/err.h>
 #include <linux/fips.h>
 #include <linux/init.h>
-#include <linux/gfp.h>
+#include <linux/interrupt.h>
+#include <linux/jiffies.h>
+#include <linux/kernel.h>
 #include <linux/module.h>
+#include <linux/moduleparam.h>
 #include <linux/scatterlist.h>
+#include <linux/slab.h>
 #include <linux/string.h>
-#include <linux/moduleparam.h>
-#include <linux/jiffies.h>
 #include <linux/timex.h>
-#include <linux/interrupt.h>
+
+#include "internal.h"
 #include "tcrypt.h"
 
 /*
diff --git a/include/crypto/algapi.h b/include/crypto/algapi.h
index bbf8c43c3320..016d5a302b84 100644
--- a/include/crypto/algapi.h
+++ b/include/crypto/algapi.h
@@ -49,6 +49,7 @@ struct crypto_instance;
 struct module;
 struct notifier_block;
 struct rtattr;
+struct scatterlist;
 struct seq_file;
 struct sk_buff;
 
@@ -132,6 +133,14 @@ struct crypto_attr_type {
 	u32 mask;
 };
 
+/*
+ * Algorithm registration interface.
+ */
+int crypto_register_alg(struct crypto_alg *alg);
+void crypto_unregister_alg(struct crypto_alg *alg);
+int crypto_register_algs(struct crypto_alg *algs, int count);
+void crypto_unregister_algs(struct crypto_alg *algs, int count);
+
 void crypto_mod_put(struct crypto_alg *alg);
 
 int crypto_register_template(struct crypto_template *tmpl);
@@ -263,4 +272,9 @@ static inline void crypto_request_complete(struct crypto_async_request *req,
 	req->complete(req->data, err);
 }
 
+static inline u32 crypto_tfm_alg_type(struct crypto_tfm *tfm)
+{
+	return tfm->__crt_alg->cra_flags & CRYPTO_ALG_TYPE_MASK;
+}
+
 #endif	/* _CRYPTO_ALGAPI_H */
diff --git a/include/linux/crypto.h b/include/linux/crypto.h
index d57597ebef6e..fdfa3e8eda43 100644
--- a/include/linux/crypto.h
+++ b/include/linux/crypto.h
@@ -12,13 +12,10 @@
 #ifndef _LINUX_CRYPTO_H
 #define _LINUX_CRYPTO_H
 
-#include <linux/atomic.h>
-#include <linux/kernel.h>
-#include <linux/list.h>
-#include <linux/bug.h>
+#include <linux/completion.h>
 #include <linux/refcount.h>
 #include <linux/slab.h>
-#include <linux/completion.h>
+#include <linux/types.h>
 
 /*
  * Algorithm masks and types.
@@ -158,10 +155,9 @@
 
 #define CRYPTO_MINALIGN_ATTR __attribute__ ((__aligned__(CRYPTO_MINALIGN)))
 
-struct scatterlist;
-struct crypto_async_request;
 struct crypto_tfm;
 struct crypto_type;
+struct module;
 
 typedef void (*crypto_completion_t)(void *req, int err);
 
@@ -411,14 +407,6 @@ static inline void crypto_init_wait(struct crypto_wait *wait)
 	init_completion(&wait->completion);
 }
 
-/*
- * Algorithm registration interface.
- */
-int crypto_register_alg(struct crypto_alg *alg);
-void crypto_unregister_alg(struct crypto_alg *alg);
-int crypto_register_algs(struct crypto_alg *algs, int count);
-void crypto_unregister_algs(struct crypto_alg *algs, int count);
-
 /*
  * Algorithm query interface.
  */
@@ -459,8 +447,6 @@ static inline void crypto_free_tfm(struct crypto_tfm *tfm)
 	return crypto_destroy_tfm(tfm, tfm);
 }
 
-int alg_test(const char *driver, const char *alg, u32 type, u32 mask);
-
 /*
  * Transform helpers which query the underlying algorithm.
  */
@@ -474,16 +460,6 @@ static inline const char *crypto_tfm_alg_driver_name(struct crypto_tfm *tfm)
 	return tfm->__crt_alg->cra_driver_name;
 }
 
-static inline int crypto_tfm_alg_priority(struct crypto_tfm *tfm)
-{
-	return tfm->__crt_alg->cra_priority;
-}
-
-static inline u32 crypto_tfm_alg_type(struct crypto_tfm *tfm)
-{
-	return tfm->__crt_alg->cra_flags & CRYPTO_ALG_TYPE_MASK;
-}
-
 static inline unsigned int crypto_tfm_alg_blocksize(struct crypto_tfm *tfm)
 {
 	return tfm->__crt_alg->cra_blocksize;
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
