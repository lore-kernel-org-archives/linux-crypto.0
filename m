From: Christophe Leroy <christophe.leroy@c-s.fr>
Subject: [PATCH 3/6] crypto: talitos - fix sha224
Date: Thu, 21 Sep 2017 09:19:51 +0200 (CEST)
Message-ID: <6c02a6a98c4e3af746ab7ed7d366192cff2222b8.1575825623.git.christophe.leroy@c-s.fr>
References: <cover.1575825623.git.christophe.leroy@c-s.fr>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from pegase1.c-s.fr ([93.17.236.30]:13973 "EHLO pegase1.c-s.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751579AbdIUHTw (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 21 Sep 2017 03:19:52 -0400
Received: from localhost (mailhub1-int [192.168.12.234])
        by localhost (Postfix) with ESMTP id 3xySfg0nXpz9ttBX
        for <linux-crypto@vger.kernel.org>; Thu, 21 Sep 2017 09:19:39 +0200 (CEST)
Received: from pegase1.c-s.fr ([192.168.12.234])
        by localhost (pegase1.c-s.fr [192.168.12.234]) (amavisd-new, port 10024)
        with ESMTP id iTPFIGPazGFU for <linux-crypto@vger.kernel.org>;
        Thu, 21 Sep 2017 09:19:39 +0200 (CEST)
Received: from messagerie.si.c-s.fr (messagerie.si.c-s.fr [192.168.25.192])
        by pegase1.c-s.fr (Postfix) with ESMTP id 3xySfg0LPVz9ttBK
        for <linux-crypto@vger.kernel.org>; Thu, 21 Sep 2017 09:19:39 +0200 (CEST)
In-Reply-To: <cover.1575825623.git.christophe.leroy@c-s.fr>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Kernel crypto tests report the following error at startup

[    2.752626] alg: hash: Test 4 failed for sha224-talitos
[    2.757907] 00000000: 30 e2 86 e2 e7 8a dd 0d d7 eb 9f d5 83 fe f1 b0
00000010: 2d 5a 6c a5 f9 55 ea fd 0e 72 05 22

This patch fixes it

Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>
---
 drivers/crypto/talitos.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
index 49f1561fa694..dff88838dce7 100644
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -1756,9 +1756,9 @@ static int common_nonsnoop_hash(struct talitos_edesc *edesc,
 		req_ctx->swinit = 0;
 	} else {
 		desc->ptr[1] = zero_entry;
-		/* Indicate next op is not the first. */
-		req_ctx->first = 0;
 	}
+	/* Indicate next op is not the first. */
+	req_ctx->first = 0;
 
 	/* HMAC key */
 	if (ctx->keylen)
-- 
2.13.3
