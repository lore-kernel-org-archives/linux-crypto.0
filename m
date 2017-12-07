From: Eric Biggers <ebiggers3@gmail.com>
Subject: [PATCH] crypto: api - Unexport crypto_larval_lookup()
Date: Thu,  7 Dec 2017 10:55:59 -0800
Message-ID: <20171207185559.17087-1-ebiggers3@gmail.com>
Cc: Eric Biggers <ebiggers@google.com>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-it0-f66.google.com ([209.85.214.66]:41143 "EHLO
        mail-it0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752506AbdLGS41 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 7 Dec 2017 13:56:27 -0500
Received: by mail-it0-f66.google.com with SMTP id x28so17191136ita.0
        for <linux-crypto@vger.kernel.org>; Thu, 07 Dec 2017 10:56:27 -0800 (PST)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Eric Biggers <ebiggers@google.com>

crypto_larval_lookup() is not used outside of crypto/api.c, so unexport
it and mark it 'static'.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/api.c      | 4 ++--
 crypto/internal.h | 1 -
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/crypto/api.c b/crypto/api.c
index 2a2479d168aa..6da802d7be67 100644
--- a/crypto/api.c
+++ b/crypto/api.c
@@ -205,7 +205,8 @@ struct crypto_alg *crypto_alg_lookup(const char *name, u32 type, u32 mask)
 }
 EXPORT_SYMBOL_GPL(crypto_alg_lookup);
 
-struct crypto_alg *crypto_larval_lookup(const char *name, u32 type, u32 mask)
+static struct crypto_alg *crypto_larval_lookup(const char *name, u32 type,
+					       u32 mask)
 {
 	struct crypto_alg *alg;
 
@@ -231,7 +232,6 @@ struct crypto_alg *crypto_larval_lookup(const char *name, u32 type, u32 mask)
 
 	return crypto_larval_add(name, type, mask);
 }
-EXPORT_SYMBOL_GPL(crypto_larval_lookup);
 
 int crypto_probing_notify(unsigned long val, void *v)
 {
diff --git a/crypto/internal.h b/crypto/internal.h
index f07320423191..ae65e5fcaa59 100644
--- a/crypto/internal.h
+++ b/crypto/internal.h
@@ -78,7 +78,6 @@ int crypto_init_compress_ops(struct crypto_tfm *tfm);
 
 struct crypto_larval *crypto_larval_alloc(const char *name, u32 type, u32 mask);
 void crypto_larval_kill(struct crypto_alg *alg);
-struct crypto_alg *crypto_larval_lookup(const char *name, u32 type, u32 mask);
 void crypto_alg_tested(const char *name, int err);
 
 void crypto_remove_spawns(struct crypto_alg *alg, struct list_head *list,
-- 
2.15.1.424.g9478a66081-goog
