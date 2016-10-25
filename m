From: Colin King <colin.king@canonical.com>
Subject: [PATCH] crypto: sahara: fix typo "Decidated" -> "Dedicated"
Date: Tue, 25 Oct 2016 12:07:27 +0100
Message-ID: <20161025110727.7744-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Cc: "David S . Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>,
        linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:38409 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751287AbcJYLHa (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 25 Oct 2016 07:07:30 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Colin Ian King <colin.king@canonical.com>

Trivial fix to typo in dev_dbg message

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/crypto/sahara.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/sahara.c b/drivers/crypto/sahara.c
index 0c49956..7ba0eae 100644
--- a/drivers/crypto/sahara.c
+++ b/drivers/crypto/sahara.c
@@ -390,7 +390,7 @@ static void sahara_decode_status(struct sahara_dev *dev, unsigned int status)
 	if (status & SAHARA_STATUS_MODE_BATCH)
 		dev_dbg(dev->device, "	- Batch Mode.\n");
 	else if (status & SAHARA_STATUS_MODE_DEDICATED)
-		dev_dbg(dev->device, "	- Decidated Mode.\n");
+		dev_dbg(dev->device, "	- Dedicated Mode.\n");
 	else if (status & SAHARA_STATUS_MODE_DEBUG)
 		dev_dbg(dev->device, "	- Debug Mode.\n");
 
-- 
2.9.3
