From: Arvind Yadav <arvind.yadav.cs@gmail.com>
Subject: [PATCH] crypto: sahara : make of_device_ids const.
Date: Tue, 27 Jun 2017 17:11:23 +0530
Message-ID: <6324a0d5dc00bcc8f082d268a15b209ee6a4ee7a.1498563591.git.arvind.yadav.cs@gmail.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: herbert@gondor.apana.org.au, davem@davemloft.net
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:34704 "EHLO
        mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751612AbdF0LmO (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 27 Jun 2017 07:42:14 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

of_device_ids are not supposed to change at runtime. All functions
working with of_device_ids provided by <linux/of.h> work with const
of_device_ids. So mark the non-const structs as const.

File size before:
   text	   data	    bss	    dec	    hex	filename
   9759	   2736	      8	  12503	   30d7	drivers/crypto/sahara.o

File size after constify:
   text	   data	    bss	    dec	    hex	filename
  10367	   2128	      8	  12503	   30d7	drivers/crypto/sahara.o

Signed-off-by: Arvind Yadav <arvind.yadav.cs@gmail.com>
---
 drivers/crypto/sahara.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/sahara.c b/drivers/crypto/sahara.c
index 1d9ecd3..c2174ec 100644
--- a/drivers/crypto/sahara.c
+++ b/drivers/crypto/sahara.c
@@ -1382,7 +1382,7 @@ static void sahara_unregister_algs(struct sahara_dev *dev)
 };
 MODULE_DEVICE_TABLE(platform, sahara_platform_ids);
 
-static struct of_device_id sahara_dt_ids[] = {
+static const struct of_device_id sahara_dt_ids[] = {
 	{ .compatible = "fsl,imx53-sahara" },
 	{ .compatible = "fsl,imx27-sahara" },
 	{ /* sentinel */ }
-- 
1.9.1
