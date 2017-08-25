From: Christian Lamparter <chunkeey@googlemail.com>
Subject: [PATCH 01/12] crypto: crypto4xx: remove bad list_del
Date: Fri, 25 Aug 2017 15:47:14 +0200
Message-ID: <71020bd2e3f4100c3c0668a13fdad9d22c8884a7.1503668705.git.chunkeey@googlemail.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        David Miller <davem@davemloft.net>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wr0-f196.google.com ([209.85.128.196]:34743 "EHLO
        mail-wr0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755031AbdHYNr2 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 25 Aug 2017 09:47:28 -0400
Received: by mail-wr0-f196.google.com with SMTP id y14so667163wrd.1
        for <linux-crypto@vger.kernel.org>; Fri, 25 Aug 2017 06:47:27 -0700 (PDT)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

alg entries are only added to the list, after the registration
was successful. If the registration failed, it was never added
to the list in the first place.

Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
---
 drivers/crypto/amcc/crypto4xx_core.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/amcc/crypto4xx_core.c b/drivers/crypto/amcc/crypto4xx_core.c
index 65dc78b91dea..3118cec0d81e 100644
--- a/drivers/crypto/amcc/crypto4xx_core.c
+++ b/drivers/crypto/amcc/crypto4xx_core.c
@@ -1033,12 +1033,10 @@ int crypto4xx_register_alg(struct crypto4xx_device *sec_dev,
 			break;
 		}
 
-		if (rc) {
-			list_del(&alg->entry);
+		if (rc)
 			kfree(alg);
-		} else {
+		else
 			list_add_tail(&alg->entry, &sec_dev->alg_list);
-		}
 	}
 
 	return 0;
-- 
2.14.1
