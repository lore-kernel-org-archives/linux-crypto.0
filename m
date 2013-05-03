From: Sachin Kamat <sachin.kamat@linaro.org>
Subject: [PATCH 1/2] crypto: mv_cesa: Remove redundant platform_set_drvdata()
Date: Fri,  3 May 2013 14:48:14 +0530
Message-ID: <1367572695-10713-1-git-send-email-sachin.kamat@linaro.org>
Cc: herbert@gondor.apana.org.au, davem@davemloft.net,
	sachin.kamat@linaro.org, patches@linaro.org,
	Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pb0-f50.google.com ([209.85.160.50]:60656 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752730Ab3ECJbM (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 3 May 2013 05:31:12 -0400
Received: by mail-pb0-f50.google.com with SMTP id um15so801909pbc.23
        for <linux-crypto@vger.kernel.org>; Fri, 03 May 2013 02:31:12 -0700 (PDT)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Commit 0998d06310 (device-core: Ensure drvdata = NULL when no
driver is bound) removes the need to set driver data field to
NULL.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
Cc: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
---
 drivers/crypto/mv_cesa.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/crypto/mv_cesa.c b/drivers/crypto/mv_cesa.c
index ce6290e..3374a3e 100644
--- a/drivers/crypto/mv_cesa.c
+++ b/drivers/crypto/mv_cesa.c
@@ -1146,7 +1146,6 @@ err_unmap_reg:
 err:
 	kfree(cp);
 	cpg = NULL;
-	platform_set_drvdata(pdev, NULL);
 	return ret;
 }
 
-- 
1.7.9.5
