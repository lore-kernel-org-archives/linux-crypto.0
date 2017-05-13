From: Karim Eshapa <karim.eshapa@gmail.com>
Subject: [PATCH] crypto: algapi: Use pr_err common logging style.
Date: Sat, 13 May 2017 21:05:19 +0200
Message-ID: <1494702319-5673-1-git-send-email-karim.eshapa@gmail.com>
Cc: davem@davemloft.net, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, Karim Eshapa <karim.eshapa@gmail.com>
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wr0-f194.google.com ([209.85.128.194]:35900 "EHLO
        mail-wr0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752422AbdEMTFb (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 13 May 2017 15:05:31 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Use more common error logging style.

Signed-off-by: Karim Eshapa <karim.eshapa@gmail.com>
---
 crypto/algapi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/crypto/algapi.c b/crypto/algapi.c
index 9eed4ef..e4cc761 100644
--- a/crypto/algapi.c
+++ b/crypto/algapi.c
@@ -260,7 +260,7 @@ void crypto_alg_tested(const char *name, int err)
 			goto found;
 	}
 
-	printk(KERN_ERR "alg: Unexpected test result for %s: %d\n", name, err);
+	pr_err("alg: Unexpected test result for %s: %d\n", name, err);
 	goto unlock;
 
 found:
-- 
2.7.4
