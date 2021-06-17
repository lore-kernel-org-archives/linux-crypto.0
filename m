Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6199C2B9F4
	for <linux-crypto@archiver.kernel.org>; Thu, 17 Jun 2021 07:28:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 76EB16135C
	for <linux-crypto@archiver.kernel.org>; Thu, 17 Jun 2021 07:28:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229671AbhFQHaT (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 17 Jun 2021 03:30:19 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:50716 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229580AbhFQHaT (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 17 Jun 2021 03:30:19 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtp (Exim 4.92 #5 (Debian))
        id 1ltmRf-00036q-DQ; Thu, 17 Jun 2021 15:28:11 +0800
Received: from herbert by gondobar with local (Exim 4.92)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1ltmRe-0001KN-DY; Thu, 17 Jun 2021 15:28:10 +0800
Date:   Thu, 17 Jun 2021 15:28:10 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: [PATCH] crypto: api - Move crypto attr definitions out of crypto.h
Message-ID: <20210617072810.GA1944@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The definitions for crypto_attr-related types and enums are not
needed by most Crypto API users.  This patch moves them out of
crypto.h and into algapi.h/internal.h depending on the extent of
their use.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/crypto/internal.h b/crypto/internal.h
index 976ec9dfc76d..f00869af689f 100644
--- a/crypto/internal.h
+++ b/crypto/internal.h
@@ -29,6 +29,18 @@ struct crypto_larval {
 	u32 mask;
 };
 
+enum {
+	CRYPTOA_UNSPEC,
+	CRYPTOA_ALG,
+	CRYPTOA_TYPE,
+	__CRYPTOA_MAX,
+};
+
+#define CRYPTOA_MAX (__CRYPTOA_MAX - 1)
+
+/* Maximum number of (rtattr) parameters for each template. */
+#define CRYPTO_MAX_ATTRS 32
+
 extern struct list_head crypto_alg_list;
 extern struct rw_semaphore crypto_alg_sem;
 extern struct blocking_notifier_head crypto_chain;
diff --git a/include/crypto/algapi.h b/include/crypto/algapi.h
index 41d42e649da4..5f6841c73e5a 100644
--- a/include/crypto/algapi.h
+++ b/include/crypto/algapi.h
@@ -96,6 +96,15 @@ struct scatter_walk {
 	unsigned int offset;
 };
 
+struct crypto_attr_alg {
+	char name[CRYPTO_MAX_ALG_NAME];
+};
+
+struct crypto_attr_type {
+	u32 type;
+	u32 mask;
+};
+
 void crypto_mod_put(struct crypto_alg *alg);
 
 int crypto_register_template(struct crypto_template *tmpl);
diff --git a/include/linux/crypto.h b/include/linux/crypto.h
index 3b9263d6122f..855869e1fd32 100644
--- a/include/linux/crypto.h
+++ b/include/linux/crypto.h
@@ -643,27 +643,6 @@ struct crypto_comp {
 	struct crypto_tfm base;
 };
 
-enum {
-	CRYPTOA_UNSPEC,
-	CRYPTOA_ALG,
-	CRYPTOA_TYPE,
-	__CRYPTOA_MAX,
-};
-
-#define CRYPTOA_MAX (__CRYPTOA_MAX - 1)
-
-/* Maximum number of (rtattr) parameters for each template. */
-#define CRYPTO_MAX_ATTRS 32
-
-struct crypto_attr_alg {
-	char name[CRYPTO_MAX_ALG_NAME];
-};
-
-struct crypto_attr_type {
-	u32 type;
-	u32 mask;
-};
-
 /* 
  * Transform user interface.
  */
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
