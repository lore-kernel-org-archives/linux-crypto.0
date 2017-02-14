From: Rob Rice <rob.rice@broadcom.com>
Subject: [PATCH 1/1] crypto: brcm - Avoid double free in ahash_finup()
Date: Tue, 14 Feb 2017 12:45:52 -0500
Message-ID: <1487094352-2016-1-git-send-email-rob.rice@broadcom.com>
Cc: Rob Rice <rob.rice@broadcom.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        bcm-kernel-feedback-list@broadcom.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-qt0-f177.google.com ([209.85.216.177]:33297 "EHLO
        mail-qt0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932290AbdBNRqg (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 14 Feb 2017 12:46:36 -0500
Received: by mail-qt0-f177.google.com with SMTP id v23so117439063qtb.0
        for <linux-crypto@vger.kernel.org>; Tue, 14 Feb 2017 09:46:36 -0800 (PST)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

In Broadcom SPU driver, in case where incremental hash
is done in software in ahash_finup(), tmpbuf was freed
twice.

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Rob Rice <rob.rice@broadcom.com>
---
 drivers/crypto/bcm/cipher.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/crypto/bcm/cipher.c b/drivers/crypto/bcm/cipher.c
index a654a01..cc0d5b9 100644
--- a/drivers/crypto/bcm/cipher.c
+++ b/drivers/crypto/bcm/cipher.c
@@ -2331,7 +2331,6 @@ static int ahash_finup(struct ahash_request *req)
 		/* Call synchronous update */
 		ret = crypto_shash_finup(ctx->shash, tmpbuf, req->nbytes,
 					 req->result);
-		kfree(tmpbuf);
 	} else {
 		/* Otherwise call the internal function which uses SPU hw */
 		return __ahash_finup(req);
-- 
2.1.0
