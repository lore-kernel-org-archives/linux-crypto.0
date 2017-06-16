From: Arvind Yadav <arvind.yadav.cs@gmail.com>
Subject: [PATCH] crypto: caam: make of_device_ids const.
Date: Fri, 16 Jun 2017 14:46:44 +0530
Message-ID: <006670ce30a5b56744b9a723582702d89fa5f274.1497604474.git.arvind.yadav.cs@gmail.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: horia.geanta@nxp.com, dan.douglass@nxp.com,
        herbert@gondor.apana.org.au, davem@davemloft.net
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:33876 "EHLO
        mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753214AbdFPJRV (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 16 Jun 2017 05:17:21 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

of_device_ids are not supposed to change at runtime. All functions
working with of_device_ids provided by <linux/of.h> work with const
of_device_ids. So mark the non-const structs as const.

File size before:
   text	   data	    bss	    dec	    hex	filename
   2376	    808	    128	   3312	    cf0	drivers/crypto/caam/jr.o

File size after constify caam_jr_match:
   text	   data	    bss	    dec	    hex	filename
   2976	    192	    128	   3296	    ce0	drivers/crypto/caam/jr.o

Signed-off-by: Arvind Yadav <arvind.yadav.cs@gmail.com>
---
 drivers/crypto/caam/jr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/caam/jr.c b/drivers/crypto/caam/jr.c
index 2763100..1ccfb31 100644
--- a/drivers/crypto/caam/jr.c
+++ b/drivers/crypto/caam/jr.c
@@ -536,7 +536,7 @@ static int caam_jr_probe(struct platform_device *pdev)
 	return 0;
 }
 
-static struct of_device_id caam_jr_match[] = {
+static const struct of_device_id caam_jr_match[] = {
 	{
 		.compatible = "fsl,sec-v4.0-job-ring",
 	},
-- 
1.9.1
