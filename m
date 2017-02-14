From: Eric Biggers <ebiggers@google.com>
Subject: [PATCH 4/4] crypto: gf128mul - constify 4k and 64k multiplication tables
Date: Tue, 14 Feb 2017 13:43:30 -0800
Message-ID: <20170214214330.99845-5-ebiggers@google.com>
References: <20170214214330.99845-1-ebiggers@google.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Biggers <ebiggers@google.com>,
        Alex Cope <alexcope@google.com>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-it0-f46.google.com ([209.85.214.46]:33071 "EHLO
        mail-it0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753175AbdBNVqG (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 14 Feb 2017 16:46:06 -0500
Received: by mail-it0-f46.google.com with SMTP id d9so21202164itc.0
        for <linux-crypto@vger.kernel.org>; Tue, 14 Feb 2017 13:46:05 -0800 (PST)
In-Reply-To: <20170214214330.99845-1-ebiggers@google.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Constify the multiplication tables passed to the 4k and 64k
multiplication functions, as they are not modified by these functions.

Cc: Alex Cope <alexcope@google.com>
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/gf128mul.c         | 6 +++---
 include/crypto/gf128mul.h | 6 +++---
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/crypto/gf128mul.c b/crypto/gf128mul.c
index 1fde1c79ffa5..04facc0690aa 100644
--- a/crypto/gf128mul.c
+++ b/crypto/gf128mul.c
@@ -329,7 +329,7 @@ void gf128mul_free_64k(struct gf128mul_64k *t)
 }
 EXPORT_SYMBOL(gf128mul_free_64k);
 
-void gf128mul_64k_bbe(be128 *a, struct gf128mul_64k *t)
+void gf128mul_64k_bbe(be128 *a, const struct gf128mul_64k *t)
 {
 	u8 *ap = (u8 *)a;
 	be128 r[1];
@@ -402,7 +402,7 @@ struct gf128mul_4k *gf128mul_init_4k_bbe(const be128 *g)
 }
 EXPORT_SYMBOL(gf128mul_init_4k_bbe);
 
-void gf128mul_4k_lle(be128 *a, struct gf128mul_4k *t)
+void gf128mul_4k_lle(be128 *a, const struct gf128mul_4k *t)
 {
 	u8 *ap = (u8 *)a;
 	be128 r[1];
@@ -417,7 +417,7 @@ void gf128mul_4k_lle(be128 *a, struct gf128mul_4k *t)
 }
 EXPORT_SYMBOL(gf128mul_4k_lle);
 
-void gf128mul_4k_bbe(be128 *a, struct gf128mul_4k *t)
+void gf128mul_4k_bbe(be128 *a, const struct gf128mul_4k *t)
 {
 	u8 *ap = (u8 *)a;
 	be128 r[1];
diff --git a/include/crypto/gf128mul.h b/include/crypto/gf128mul.h
index 9662c4538873..0bc9b5f1c45e 100644
--- a/include/crypto/gf128mul.h
+++ b/include/crypto/gf128mul.h
@@ -174,8 +174,8 @@ struct gf128mul_4k {
 
 struct gf128mul_4k *gf128mul_init_4k_lle(const be128 *g);
 struct gf128mul_4k *gf128mul_init_4k_bbe(const be128 *g);
-void gf128mul_4k_lle(be128 *a, struct gf128mul_4k *t);
-void gf128mul_4k_bbe(be128 *a, struct gf128mul_4k *t);
+void gf128mul_4k_lle(be128 *a, const struct gf128mul_4k *t);
+void gf128mul_4k_bbe(be128 *a, const struct gf128mul_4k *t);
 
 static inline void gf128mul_free_4k(struct gf128mul_4k *t)
 {
@@ -196,6 +196,6 @@ struct gf128mul_64k {
  */
 struct gf128mul_64k *gf128mul_init_64k_bbe(const be128 *g);
 void gf128mul_free_64k(struct gf128mul_64k *t);
-void gf128mul_64k_bbe(be128 *a, struct gf128mul_64k *t);
+void gf128mul_64k_bbe(be128 *a, const struct gf128mul_64k *t);
 
 #endif /* _CRYPTO_GF128MUL_H */
-- 
2.11.0.483.g087da7b7c-goog
