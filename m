From: Zhang Shengju <zhangshengju@cmss.chinamobile.com>
Subject: [-next] crypto: 842 propagate PTR_ERR value instead of -ENOMEM
Date: Thu,  1 Jun 2017 16:57:26 +0800
Message-ID: <1496307446-12377-1-git-send-email-zhangshengju@cmss.chinamobile.com>
To: haren@us.ibm.com, herbert@gondor.apana.org.au,
        linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from cmccmta3.chinamobile.com ([221.176.66.81]:19257 "EHLO
        cmccmta3.chinamobile.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751106AbdFAJGq (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 1 Jun 2017 05:06:46 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

It is better to propagate PTR_ERR value instead of a hardcoded
value(-ENOMEM here).

Signed-off-by: Zhang Shengju <zhangshengju@cmss.chinamobile.com>
---
 crypto/842.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/crypto/842.c b/crypto/842.c
index bc26dc9..6d4f7c7 100644
--- a/crypto/842.c
+++ b/crypto/842.c
@@ -54,7 +54,7 @@ static int crypto842_init(struct crypto_tfm *tfm)
 
 	ctx->wmem = crypto842_alloc_ctx(NULL);
 	if (IS_ERR(ctx->wmem))
-		return -ENOMEM;
+		return PTR_ERR(ctx-wmem);
 
 	return 0;
 }
-- 
1.8.3.1
