Return-Path: <SRS0=cN8K=2F=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4EA7C43603
	for <linux-crypto@archiver.kernel.org>; Sun, 15 Dec 2019 23:52:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 830AB24671
	for <linux-crypto@archiver.kernel.org>; Sun, 15 Dec 2019 23:52:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1576453928;
	bh=Dy/RdwHJnlyJrKsfos4Am7pY/1GWkytAcJWRIMTC6CE=;
	h=From:To:Subject:Date:List-ID:From;
	b=issuTj8XR1hmhQQHbIPqfKql3cCnXcNVWPqSRSdNZnqKSbryBq0KvLkfEw3hXy4rb
	 KLkI+t14iikkmwi1s762ghrVIBCMnd7YDSe1QezBXvwWUVuib9KnuExROPaRw0SLI7
	 nTsyd0AK502GWnmI2EsfRa9YyeK0Zb+rRJoqeZfQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726373AbfLOXwH (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 15 Dec 2019 18:52:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:34364 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726299AbfLOXwH (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 15 Dec 2019 18:52:07 -0500
Received: from sol.localdomain (c-24-5-143-220.hsd1.ca.comcast.net [24.5.143.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D8EA824671
        for <linux-crypto@vger.kernel.org>; Sun, 15 Dec 2019 23:52:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576453926;
        bh=Dy/RdwHJnlyJrKsfos4Am7pY/1GWkytAcJWRIMTC6CE=;
        h=From:To:Subject:Date:From;
        b=Y7H1lhNxlokiJ0Gsgam129pW8vO7yAsLxDfd9uct7vfYzz2i4ea1d0YIKC17JNGjT
         3MAPFInhQiiRmT+BlHp8FwBFUm9U5h4URcc+SIPk6RjrqGAnS5rSpROD0j3ew9Zt2c
         s1OQcn65XT0ZgPQQugOomlM/Kz3uYFz+pBc7x59c=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Subject: [PATCH] crypto: algapi - make unregistration functions return void
Date:   Sun, 15 Dec 2019 15:51:19 -0800
Message-Id: <20191215235119.123636-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Some of the algorithm unregistration functions return -ENOENT when asked
to unregister a non-registered algorithm, while others always return 0
or always return void.  But no users check the return value, except for
two of the bulk unregistration functions which print a message on error
but still always return 0 to their caller, and crypto_del_alg() which
calls crypto_unregister_instance() which always returns 0.

Since unregistering a non-registered algorithm is always a kernel bug
but there isn't anything callers should do to handle this situation at
runtime, let's simplify things by making all the unregistration
functions return void, and moving the error message into
crypto_unregister_alg() and upgrading it to a WARN().

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 Documentation/crypto/devel-algos.rst | 34 ++++++++++------------------
 crypto/acompress.c                   |  4 ++--
 crypto/ahash.c                       |  4 ++--
 crypto/algapi.c                      | 25 +++++++-------------
 crypto/crypto_user_base.c            |  3 ++-
 crypto/scompress.c                   |  4 ++--
 crypto/shash.c                       | 19 +++++-----------
 include/crypto/algapi.h              |  2 +-
 include/crypto/internal/acompress.h  |  4 +---
 include/crypto/internal/hash.h       |  6 ++---
 include/crypto/internal/scompress.h  |  4 +---
 include/linux/crypto.h               |  4 ++--
 12 files changed, 42 insertions(+), 71 deletions(-)

diff --git a/Documentation/crypto/devel-algos.rst b/Documentation/crypto/devel-algos.rst
index fb6b7979a1de..f225a953ab4b 100644
--- a/Documentation/crypto/devel-algos.rst
+++ b/Documentation/crypto/devel-algos.rst
@@ -31,28 +31,18 @@ The counterparts to those functions are listed below.
 
 ::
 
-       int crypto_unregister_alg(struct crypto_alg *alg);
-       int crypto_unregister_algs(struct crypto_alg *algs, int count);
+       void crypto_unregister_alg(struct crypto_alg *alg);
+       void crypto_unregister_algs(struct crypto_alg *algs, int count);
 
 
-Notice that both registration and unregistration functions do return a
-value, so make sure to handle errors. A return code of zero implies
-success. Any return code < 0 implies an error.
+The registration functions return 0 on success, or a negative errno
+value on failure.  crypto_register_algs() succeeds only if it
+successfully registered all the given algorithms; if it fails partway
+through, then any changes are rolled back.
 
-The bulk registration/unregistration functions register/unregister each
-transformation in the given array of length count. They handle errors as
-follows:
-
--  crypto_register_algs() succeeds if and only if it successfully
-   registers all the given transformations. If an error occurs partway
-   through, then it rolls back successful registrations before returning
-   the error code. Note that if a driver needs to handle registration
-   errors for individual transformations, then it will need to use the
-   non-bulk function crypto_register_alg() instead.
-
--  crypto_unregister_algs() tries to unregister all the given
-   transformations, continuing on error. It logs errors and always
-   returns zero.
+The unregistration functions always succeed, so they don't have a
+return value.  Don't try to unregister algorithms that aren't
+currently registered.
 
 Single-Block Symmetric Ciphers [CIPHER]
 ---------------------------------------
@@ -169,10 +159,10 @@ are as follows:
 
 ::
 
-       int crypto_unregister_ahash(struct ahash_alg *alg);
+       void crypto_unregister_ahash(struct ahash_alg *alg);
 
-       int crypto_unregister_shash(struct shash_alg *alg);
-       int crypto_unregister_shashes(struct shash_alg *algs, int count);
+       void crypto_unregister_shash(struct shash_alg *alg);
+       void crypto_unregister_shashes(struct shash_alg *algs, int count);
 
 
 Cipher Definition With struct shash_alg and ahash_alg
diff --git a/crypto/acompress.c b/crypto/acompress.c
index abadcb035a41..84a76723e851 100644
--- a/crypto/acompress.c
+++ b/crypto/acompress.c
@@ -151,9 +151,9 @@ int crypto_register_acomp(struct acomp_alg *alg)
 }
 EXPORT_SYMBOL_GPL(crypto_register_acomp);
 
-int crypto_unregister_acomp(struct acomp_alg *alg)
+void crypto_unregister_acomp(struct acomp_alg *alg)
 {
-	return crypto_unregister_alg(&alg->base);
+	crypto_unregister_alg(&alg->base);
 }
 EXPORT_SYMBOL_GPL(crypto_unregister_acomp);
 
diff --git a/crypto/ahash.c b/crypto/ahash.c
index 3815b363a693..181bd851b429 100644
--- a/crypto/ahash.c
+++ b/crypto/ahash.c
@@ -598,9 +598,9 @@ int crypto_register_ahash(struct ahash_alg *alg)
 }
 EXPORT_SYMBOL_GPL(crypto_register_ahash);
 
-int crypto_unregister_ahash(struct ahash_alg *alg)
+void crypto_unregister_ahash(struct ahash_alg *alg)
 {
-	return crypto_unregister_alg(&alg->halg.base);
+	crypto_unregister_alg(&alg->halg.base);
 }
 EXPORT_SYMBOL_GPL(crypto_unregister_ahash);
 
diff --git a/crypto/algapi.c b/crypto/algapi.c
index 9589b3f0041b..fe57b4f696ac 100644
--- a/crypto/algapi.c
+++ b/crypto/algapi.c
@@ -442,7 +442,7 @@ static int crypto_remove_alg(struct crypto_alg *alg, struct list_head *list)
 	return 0;
 }
 
-int crypto_unregister_alg(struct crypto_alg *alg)
+void crypto_unregister_alg(struct crypto_alg *alg)
 {
 	int ret;
 	LIST_HEAD(list);
@@ -451,15 +451,14 @@ int crypto_unregister_alg(struct crypto_alg *alg)
 	ret = crypto_remove_alg(alg, &list);
 	up_write(&crypto_alg_sem);
 
-	if (ret)
-		return ret;
+	if (WARN(ret, "Algorithm %s is not registered", alg->cra_driver_name))
+		return;
 
 	BUG_ON(refcount_read(&alg->cra_refcnt) != 1);
 	if (alg->cra_destroy)
 		alg->cra_destroy(alg);
 
 	crypto_remove_final(&list);
-	return 0;
 }
 EXPORT_SYMBOL_GPL(crypto_unregister_alg);
 
@@ -483,18 +482,12 @@ int crypto_register_algs(struct crypto_alg *algs, int count)
 }
 EXPORT_SYMBOL_GPL(crypto_register_algs);
 
-int crypto_unregister_algs(struct crypto_alg *algs, int count)
+void crypto_unregister_algs(struct crypto_alg *algs, int count)
 {
-	int i, ret;
-
-	for (i = 0; i < count; i++) {
-		ret = crypto_unregister_alg(&algs[i]);
-		if (ret)
-			pr_err("Failed to unregister %s %s: %d\n",
-			       algs[i].cra_driver_name, algs[i].cra_name, ret);
-	}
+	int i;
 
-	return 0;
+	for (i = 0; i < count; i++)
+		crypto_unregister_alg(&algs[i]);
 }
 EXPORT_SYMBOL_GPL(crypto_unregister_algs);
 
@@ -639,7 +632,7 @@ int crypto_register_instance(struct crypto_template *tmpl,
 }
 EXPORT_SYMBOL_GPL(crypto_register_instance);
 
-int crypto_unregister_instance(struct crypto_instance *inst)
+void crypto_unregister_instance(struct crypto_instance *inst)
 {
 	LIST_HEAD(list);
 
@@ -651,8 +644,6 @@ int crypto_unregister_instance(struct crypto_instance *inst)
 	up_write(&crypto_alg_sem);
 
 	crypto_remove_final(&list);
-
-	return 0;
 }
 EXPORT_SYMBOL_GPL(crypto_unregister_instance);
 
diff --git a/crypto/crypto_user_base.c b/crypto/crypto_user_base.c
index b785c476de67..3fa20f12989f 100644
--- a/crypto/crypto_user_base.c
+++ b/crypto/crypto_user_base.c
@@ -323,7 +323,8 @@ static int crypto_del_alg(struct sk_buff *skb, struct nlmsghdr *nlh,
 	if (refcount_read(&alg->cra_refcnt) > 2)
 		goto drop_alg;
 
-	err = crypto_unregister_instance((struct crypto_instance *)alg);
+	crypto_unregister_instance((struct crypto_instance *)alg);
+	err = 0;
 
 drop_alg:
 	crypto_mod_put(alg);
diff --git a/crypto/scompress.c b/crypto/scompress.c
index 4d50750d01c6..738f4f8f0f41 100644
--- a/crypto/scompress.c
+++ b/crypto/scompress.c
@@ -266,9 +266,9 @@ int crypto_register_scomp(struct scomp_alg *alg)
 }
 EXPORT_SYMBOL_GPL(crypto_register_scomp);
 
-int crypto_unregister_scomp(struct scomp_alg *alg)
+void crypto_unregister_scomp(struct scomp_alg *alg)
 {
-	return crypto_unregister_alg(&alg->base);
+	crypto_unregister_alg(&alg->base);
 }
 EXPORT_SYMBOL_GPL(crypto_unregister_scomp);
 
diff --git a/crypto/shash.c b/crypto/shash.c
index 8042bb0df9c0..7243f60dab87 100644
--- a/crypto/shash.c
+++ b/crypto/shash.c
@@ -520,9 +520,9 @@ int crypto_register_shash(struct shash_alg *alg)
 }
 EXPORT_SYMBOL_GPL(crypto_register_shash);
 
-int crypto_unregister_shash(struct shash_alg *alg)
+void crypto_unregister_shash(struct shash_alg *alg)
 {
-	return crypto_unregister_alg(&alg->base);
+	crypto_unregister_alg(&alg->base);
 }
 EXPORT_SYMBOL_GPL(crypto_unregister_shash);
 
@@ -546,19 +546,12 @@ int crypto_register_shashes(struct shash_alg *algs, int count)
 }
 EXPORT_SYMBOL_GPL(crypto_register_shashes);
 
-int crypto_unregister_shashes(struct shash_alg *algs, int count)
+void crypto_unregister_shashes(struct shash_alg *algs, int count)
 {
-	int i, ret;
-
-	for (i = count - 1; i >= 0; --i) {
-		ret = crypto_unregister_shash(&algs[i]);
-		if (ret)
-			pr_err("Failed to unregister %s %s: %d\n",
-			       algs[i].base.cra_driver_name,
-			       algs[i].base.cra_name, ret);
-	}
+	int i;
 
-	return 0;
+	for (i = count - 1; i >= 0; --i)
+		crypto_unregister_shash(&algs[i]);
 }
 EXPORT_SYMBOL_GPL(crypto_unregister_shashes);
 
diff --git a/include/crypto/algapi.h b/include/crypto/algapi.h
index 771a295ac755..25661b4650ec 100644
--- a/include/crypto/algapi.h
+++ b/include/crypto/algapi.h
@@ -96,7 +96,7 @@ struct crypto_template *crypto_lookup_template(const char *name);
 
 int crypto_register_instance(struct crypto_template *tmpl,
 			     struct crypto_instance *inst);
-int crypto_unregister_instance(struct crypto_instance *inst);
+void crypto_unregister_instance(struct crypto_instance *inst);
 
 int crypto_init_spawn(struct crypto_spawn *spawn, struct crypto_alg *alg,
 		      struct crypto_instance *inst, u32 mask);
diff --git a/include/crypto/internal/acompress.h b/include/crypto/internal/acompress.h
index 9de57367afbb..cf478681b53e 100644
--- a/include/crypto/internal/acompress.h
+++ b/include/crypto/internal/acompress.h
@@ -68,10 +68,8 @@ int crypto_register_acomp(struct acomp_alg *alg);
  * compression algorithm
  *
  * @alg:	algorithm definition
- *
- * Return:	zero on success; error code in case of error
  */
-int crypto_unregister_acomp(struct acomp_alg *alg);
+void crypto_unregister_acomp(struct acomp_alg *alg);
 
 int crypto_register_acomps(struct acomp_alg *algs, int count);
 void crypto_unregister_acomps(struct acomp_alg *algs, int count);
diff --git a/include/crypto/internal/hash.h b/include/crypto/internal/hash.h
index cf8d7f99c93d..d4b1be519590 100644
--- a/include/crypto/internal/hash.h
+++ b/include/crypto/internal/hash.h
@@ -70,7 +70,7 @@ static inline int crypto_ahash_walk_last(struct crypto_hash_walk *walk)
 }
 
 int crypto_register_ahash(struct ahash_alg *alg);
-int crypto_unregister_ahash(struct ahash_alg *alg);
+void crypto_unregister_ahash(struct ahash_alg *alg);
 int crypto_register_ahashes(struct ahash_alg *algs, int count);
 void crypto_unregister_ahashes(struct ahash_alg *algs, int count);
 int ahash_register_instance(struct crypto_template *tmpl,
@@ -105,9 +105,9 @@ static inline void crypto_drop_ahash(struct crypto_ahash_spawn *spawn)
 struct hash_alg_common *ahash_attr_alg(struct rtattr *rta, u32 type, u32 mask);
 
 int crypto_register_shash(struct shash_alg *alg);
-int crypto_unregister_shash(struct shash_alg *alg);
+void crypto_unregister_shash(struct shash_alg *alg);
 int crypto_register_shashes(struct shash_alg *algs, int count);
-int crypto_unregister_shashes(struct shash_alg *algs, int count);
+void crypto_unregister_shashes(struct shash_alg *algs, int count);
 int shash_register_instance(struct crypto_template *tmpl,
 			    struct shash_instance *inst);
 void shash_free_instance(struct crypto_instance *inst);
diff --git a/include/crypto/internal/scompress.h b/include/crypto/internal/scompress.h
index 6727ef0fc4d1..f834274c2493 100644
--- a/include/crypto/internal/scompress.h
+++ b/include/crypto/internal/scompress.h
@@ -112,10 +112,8 @@ int crypto_register_scomp(struct scomp_alg *alg);
  * compression algorithm
  *
  * @alg:	algorithm definition
- *
- * Return: zero on success; error code in case of error
  */
-int crypto_unregister_scomp(struct scomp_alg *alg);
+void crypto_unregister_scomp(struct scomp_alg *alg);
 
 int crypto_register_scomps(struct scomp_alg *algs, int count);
 void crypto_unregister_scomps(struct scomp_alg *algs, int count);
diff --git a/include/linux/crypto.h b/include/linux/crypto.h
index c23f1eed7970..a905e524e332 100644
--- a/include/linux/crypto.h
+++ b/include/linux/crypto.h
@@ -584,9 +584,9 @@ static inline void crypto_init_wait(struct crypto_wait *wait)
  * Algorithm registration interface.
  */
 int crypto_register_alg(struct crypto_alg *alg);
-int crypto_unregister_alg(struct crypto_alg *alg);
+void crypto_unregister_alg(struct crypto_alg *alg);
 int crypto_register_algs(struct crypto_alg *algs, int count);
-int crypto_unregister_algs(struct crypto_alg *algs, int count);
+void crypto_unregister_algs(struct crypto_alg *algs, int count);
 
 /*
  * Algorithm query interface.
-- 
2.24.1

