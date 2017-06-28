From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [BUGFIX] crypto: atmel: only treat EBUSY as transient if backlog
Date: Wed, 28 Jun 2017 10:22:03 +0300
Message-ID: <1498634523-2660-1-git-send-email-gilad@benyossef.com>
Cc: Ofir Drang <ofir.drang@arm.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from foss.arm.com ([217.140.101.70]:37820 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751560AbdF1HWL (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 28 Jun 2017 03:22:11 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The Atmel SHA driver was treating -EBUSY as indication of queueing
to backlog without checking that backlog is enabled for the request.

Fix it by checking request flags.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---

Please note I do not have access to the hardware or know it very well,
so this patch was only compile tested.  I ran into this while working
on a crypto API change and it seemed wrong.

Please review and test if you can!

 drivers/crypto/atmel-sha.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/atmel-sha.c b/drivers/crypto/atmel-sha.c
index a948202..dad4e5b 100644
--- a/drivers/crypto/atmel-sha.c
+++ b/drivers/crypto/atmel-sha.c
@@ -1204,7 +1204,9 @@ static int atmel_sha_finup(struct ahash_request *req)
 	ctx->flags |= SHA_FLAGS_FINUP;
 
 	err1 = atmel_sha_update(req);
-	if (err1 == -EINPROGRESS || err1 == -EBUSY)
+	if (err1 == -EINPROGRESS ||
+	    (err1 == -EBUSY && (ahash_request_flags(req) &
+				CRYPTO_TFM_REQ_MAY_BACKLOG)))
 		return err1;
 
 	/*
-- 
2.1.4
