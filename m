Return-Path: <SRS0=EYtX=BJ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7C1AC433DF
	for <linux-crypto@archiver.kernel.org>; Thu, 30 Jul 2020 12:39:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9857520838
	for <linux-crypto@archiver.kernel.org>; Thu, 30 Jul 2020 12:39:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726535AbgG3Mjj (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 30 Jul 2020 08:39:39 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:37034 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726967AbgG3Mji (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 30 Jul 2020 08:39:38 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1k17q5-0006OM-9k; Thu, 30 Jul 2020 22:39:14 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Thu, 30 Jul 2020 22:39:13 +1000
Date:   Thu, 30 Jul 2020 22:39:13 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: [PATCH] crypto: algapi - Move crypto_yield into internal.h
Message-ID: <20200730123913.GA4889@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

crypto: algapi - Move crypto_yield into internal.h

This patch moves crypto_yield into internal.h as it's only used
by internal code such as skcipher.  It also adds a missing inclusion
of sched.h which is required for cond_resched.

The header files in internal.h have been cleaned up to remove some
ancient junk and add some more specific inclusions.
    
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/crypto/internal.h b/crypto/internal.h
index 1b92a5a61852f..976ec9dfc76db 100644
--- a/crypto/internal.h
+++ b/crypto/internal.h
@@ -10,16 +10,14 @@
 
 #include <crypto/algapi.h>
 #include <linux/completion.h>
-#include <linux/mm.h>
-#include <linux/highmem.h>
-#include <linux/interrupt.h>
-#include <linux/init.h>
 #include <linux/list.h>
 #include <linux/module.h>
-#include <linux/kernel.h>
 #include <linux/notifier.h>
+#include <linux/numa.h>
+#include <linux/refcount.h>
 #include <linux/rwsem.h>
-#include <linux/slab.h>
+#include <linux/sched.h>
+#include <linux/types.h>
 
 struct crypto_instance;
 struct crypto_template;
@@ -140,5 +138,11 @@ static inline void crypto_notify(unsigned long val, void *v)
 	blocking_notifier_call_chain(&crypto_chain, val, v);
 }
 
+static inline void crypto_yield(u32 flags)
+{
+	if (flags & CRYPTO_TFM_REQ_MAY_SLEEP)
+		cond_resched();
+}
+
 #endif	/* _CRYPTO_INTERNAL_H */
 
diff --git a/include/crypto/algapi.h b/include/crypto/algapi.h
index 143d884d65c7a..99fcb2d7a8317 100644
--- a/include/crypto/algapi.h
+++ b/include/crypto/algapi.h
@@ -277,12 +277,6 @@ static inline int crypto_memneq(const void *a, const void *b, size_t size)
 	return __crypto_memneq(a, b, size) != 0UL ? 1 : 0;
 }
 
-static inline void crypto_yield(u32 flags)
-{
-	if (flags & CRYPTO_TFM_REQ_MAY_SLEEP)
-		cond_resched();
-}
-
 int crypto_register_notifier(struct notifier_block *nb);
 int crypto_unregister_notifier(struct notifier_block *nb);
 
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
