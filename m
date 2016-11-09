From: Alex Cope <alexcope@google.com>
Subject: [PATCH RESEND] crypto: gf128mul - remove dead gf128mul_64k_lle code
Date: Tue,  8 Nov 2016 17:16:58 -0800
Message-ID: <1478654218-49724-1-git-send-email-alexcope@google.com>
Cc: Alex Cope <alexcope@google.com>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pf0-f170.google.com ([209.85.192.170]:36245 "EHLO
        mail-pf0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752242AbcKIBRM (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 8 Nov 2016 20:17:12 -0500
Received: by mail-pf0-f170.google.com with SMTP id 189so117047582pfz.3
        for <linux-crypto@vger.kernel.org>; Tue, 08 Nov 2016 17:17:11 -0800 (PST)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This code is unlikely to be useful in the future because transforms
don't know how often keys will be changed, new algorithms are unlikely
to use lle representation, and tables should be replaced with
carryless multiplication instructions when available.

Signed-off-by: Alex Cope <alexcope@google.com>
---
 crypto/gf128mul.c         | 55 -----------------------------------------------
 include/crypto/gf128mul.h | 13 ++++++-----
 2 files changed, 6 insertions(+), 62 deletions(-)

diff --git a/crypto/gf128mul.c b/crypto/gf128mul.c
index 5276607..57c85dd 100644
--- a/crypto/gf128mul.c
+++ b/crypto/gf128mul.c
@@ -263,48 +263,6 @@ EXPORT_SYMBOL(gf128mul_bbe);
  * t[1][BYTE] contains g*x^8*BYTE
  *  ..
  * t[15][BYTE] contains g*x^120*BYTE */
-struct gf128mul_64k *gf128mul_init_64k_lle(const be128 *g)
-{
-	struct gf128mul_64k *t;
-	int i, j, k;
-
-	t = kzalloc(sizeof(*t), GFP_KERNEL);
-	if (!t)
-		goto out;
-
-	for (i = 0; i < 16; i++) {
-		t->t[i] = kzalloc(sizeof(*t->t[i]), GFP_KERNEL);
-		if (!t->t[i]) {
-			gf128mul_free_64k(t);
-			t = NULL;
-			goto out;
-		}
-	}
-
-	t->t[0]->t[128] = *g;
-	for (j = 64; j > 0; j >>= 1)
-		gf128mul_x_lle(&t->t[0]->t[j], &t->t[0]->t[j + j]);
-
-	for (i = 0;;) {
-		for (j = 2; j < 256; j += j)
-			for (k = 1; k < j; ++k)
-				be128_xor(&t->t[i]->t[j + k],
-					  &t->t[i]->t[j], &t->t[i]->t[k]);
-
-		if (++i >= 16)
-			break;
-
-		for (j = 128; j > 0; j >>= 1) {
-			t->t[i]->t[j] = t->t[i - 1]->t[j];
-			gf128mul_x8_lle(&t->t[i]->t[j]);
-		}
-	}
-
-out:
-	return t;
-}
-EXPORT_SYMBOL(gf128mul_init_64k_lle);
-
 struct gf128mul_64k *gf128mul_init_64k_bbe(const be128 *g)
 {
 	struct gf128mul_64k *t;
@@ -357,19 +315,6 @@ void gf128mul_free_64k(struct gf128mul_64k *t)
 }
 EXPORT_SYMBOL(gf128mul_free_64k);
 
-void gf128mul_64k_lle(be128 *a, struct gf128mul_64k *t)
-{
-	u8 *ap = (u8 *)a;
-	be128 r[1];
-	int i;
-
-	*r = t->t[0]->t[ap[0]];
-	for (i = 1; i < 16; ++i)
-		be128_xor(r, r, &t->t[i]->t[ap[i]]);
-	*a = *r;
-}
-EXPORT_SYMBOL(gf128mul_64k_lle);
-
 void gf128mul_64k_bbe(be128 *a, struct gf128mul_64k *t)
 {
 	u8 *ap = (u8 *)a;
diff --git a/include/crypto/gf128mul.h b/include/crypto/gf128mul.h
index da2530e..b611aa9 100644
--- a/include/crypto/gf128mul.h
+++ b/include/crypto/gf128mul.h
@@ -181,20 +181,19 @@ static inline void gf128mul_free_4k(struct gf128mul_4k *t)
 }
 
 
-/* 64k table optimization, implemented for lle and bbe */
+/* 64k table optimization, implemented for bbe */
 
 struct gf128mul_64k {
 	struct gf128mul_4k *t[16];
 };
 
-/* first initialize with the constant factor with which you
- * want to multiply and then call gf128_64k_lle with the other
- * factor in the first argument, the table in the second and a
- * scratch register in the third. Afterwards *a = *r. */
-struct gf128mul_64k *gf128mul_init_64k_lle(const be128 *g);
+/* First initialize with the constant factor with which you
+ * want to multiply and then call gf128mul_64k_bbe with the other
+ * factor in the first argument, and the table in the second.
+ * Afterwards, the result is stored in *a.
+ */
 struct gf128mul_64k *gf128mul_init_64k_bbe(const be128 *g);
 void gf128mul_free_64k(struct gf128mul_64k *t);
-void gf128mul_64k_lle(be128 *a, struct gf128mul_64k *t);
 void gf128mul_64k_bbe(be128 *a, struct gf128mul_64k *t);
 
 #endif /* _CRYPTO_GF128MUL_H */
-- 
2.8.0.rc3.226.g39d4020
