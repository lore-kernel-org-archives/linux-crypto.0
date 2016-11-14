From: Alex Cope <alexcope@google.com>
Subject: [PATCH] crypto: gf128mul - Zero memory when freeing multiplication table
Date: Mon, 14 Nov 2016 11:02:54 -0800
Message-ID: <1479150174-128347-1-git-send-email-alexcope@google.com>
Cc: Alex Cope <alexcope@google.com>, Eric Biggers <ebiggers@google.com>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pg0-f52.google.com ([74.125.83.52]:35844 "EHLO
        mail-pg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933387AbcKNTLA (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 14 Nov 2016 14:11:00 -0500
Received: by mail-pg0-f52.google.com with SMTP id f188so56957804pgc.3
        for <linux-crypto@vger.kernel.org>; Mon, 14 Nov 2016 11:11:00 -0800 (PST)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

GF(2^128) multiplication tables are typically used for secret
information, so it's a good idea to zero them on free.

Signed-off-by: Alex Cope <alexcope@google.com>
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/gf128mul.c         | 4 ++--
 include/crypto/gf128mul.h | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/crypto/gf128mul.c b/crypto/gf128mul.c
index 5276607..0594dd6 100644
--- a/crypto/gf128mul.c
+++ b/crypto/gf128mul.c
@@ -352,8 +352,8 @@ void gf128mul_free_64k(struct gf128mul_64k *t)
 	int i;
 
 	for (i = 0; i < 16; i++)
-		kfree(t->t[i]);
-	kfree(t);
+		kzfree(t->t[i]);
+	kzfree(t);
 }
 EXPORT_SYMBOL(gf128mul_free_64k);
 
diff --git a/include/crypto/gf128mul.h b/include/crypto/gf128mul.h
index da2530e..7217fe6 100644
--- a/include/crypto/gf128mul.h
+++ b/include/crypto/gf128mul.h
@@ -177,7 +177,7 @@ void gf128mul_4k_bbe(be128 *a, struct gf128mul_4k *t);
 
 static inline void gf128mul_free_4k(struct gf128mul_4k *t)
 {
-	kfree(t);
+	kzfree(t);
 }
 
 
-- 
2.8.0.rc3.226.g39d4020
