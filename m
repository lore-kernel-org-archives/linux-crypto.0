From: Himanshu Jha <himanshujha199640@gmail.com>
Subject: [PATCH 1/2] crypto: n2 - remove null check before kfree
Date: Sun, 27 Aug 2017 02:45:29 +0530
Message-ID: <1503782130-10137-2-git-send-email-himanshujha199640@gmail.com>
References: <1503782130-10137-1-git-send-email-himanshujha199640@gmail.com>
Cc: davem@davemloft.net, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Himanshu Jha <himanshujha199640@gmail.com>
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pg0-f67.google.com ([74.125.83.67]:36572 "EHLO
        mail-pg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751083AbdHZVQI (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 26 Aug 2017 17:16:08 -0400
In-Reply-To: <1503782130-10137-1-git-send-email-himanshujha199640@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

kfree on NULL pointer is a no-op and therefore checking it is redundant.

Signed-off-by: Himanshu Jha <himanshujha199640@gmail.com>
---
 drivers/crypto/n2_core.c | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/crypto/n2_core.c b/drivers/crypto/n2_core.c
index a9fd8b9..48de52c 100644
--- a/drivers/crypto/n2_core.c
+++ b/drivers/crypto/n2_core.c
@@ -1962,10 +1962,8 @@ static struct n2_crypto *alloc_n2cp(void)
 
 static void free_n2cp(struct n2_crypto *np)
 {
-	if (np->cwq_info.ino_table) {
-		kfree(np->cwq_info.ino_table);
-		np->cwq_info.ino_table = NULL;
-	}
+	kfree(np->cwq_info.ino_table);
+	np->cwq_info.ino_table = NULL;
 
 	kfree(np);
 }
@@ -2079,10 +2077,8 @@ static struct n2_mau *alloc_ncp(void)
 
 static void free_ncp(struct n2_mau *mp)
 {
-	if (mp->mau_info.ino_table) {
-		kfree(mp->mau_info.ino_table);
-		mp->mau_info.ino_table = NULL;
-	}
+	kfree(mp->mau_info.ino_table);
+	mp->mau_info.ino_table = NULL;
 
 	kfree(mp);
 }
-- 
2.7.4
