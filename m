From: LABBE Corentin <clabbe.montjoie@gmail.com>
Subject: [PATCH] crypto: fix a little typo
Date: Wed, 10 Aug 2016 11:29:33 +0200
Message-ID: <1470821373-8228-1-git-send-email-clabbe.montjoie@gmail.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	LABBE Corentin <clabbe.montjoie@gmail.com>
To: herbert@gondor.apana.org.au
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

The sentence 'Based on' is misspelled, respell it.

Signed-off-by: LABBE Corentin <clabbe.montjoie@gmail.com>
---
 crypto/xts.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/crypto/xts.c b/crypto/xts.c
index 26ba583..305343f 100644
--- a/crypto/xts.c
+++ b/crypto/xts.c
@@ -5,7 +5,7 @@
  *
  * Copyright (c) 2007 Rik Snel <rsnel@cube.dyndns.org>
  *
- * Based om ecb.c
+ * Based on ecb.c
  * Copyright (c) 2006 Herbert Xu <herbert@gondor.apana.org.au>
  *
  * This program is free software; you can redistribute it and/or modify it
-- 
2.7.3
