From: Arvind Yadav <arvind.yadav.cs@gmail.com>
Subject: [PATCH] crypto: sahara: constify platform_device_id
Date: Sun, 13 Aug 2017 14:34:00 +0530
Message-ID: <f8f2d2b5610c724bf83d31a47fe3b017e047424a.1502614870.git.arvind.yadav.cs@gmail.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: herbert@gondor.apana.org.au, davem@davemloft.net
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:37177 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750922AbdHMJEJ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 13 Aug 2017 05:04:09 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

platform_device_id are not supposed to change at runtime. All functions
working with platform_device_id provided by <linux/platform_device.h>
work with const platform_device_id. So mark the non-const structs as
const.

Signed-off-by: Arvind Yadav <arvind.yadav.cs@gmail.com>
---
 drivers/crypto/sahara.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/sahara.c b/drivers/crypto/sahara.c
index 1d9ecd3..39efa65 100644
--- a/drivers/crypto/sahara.c
+++ b/drivers/crypto/sahara.c
@@ -1376,7 +1376,7 @@ static void sahara_unregister_algs(struct sahara_dev *dev)
 			crypto_unregister_ahash(&sha_v4_algs[i]);
 }
 
-static struct platform_device_id sahara_platform_ids[] = {
+static const struct platform_device_id sahara_platform_ids[] = {
 	{ .name = "sahara-imx27" },
 	{ /* sentinel */ }
 };
-- 
2.7.4
