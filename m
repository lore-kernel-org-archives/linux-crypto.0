From: Corentin Labbe <clabbe.montjoie@gmail.com>
Subject: [PATCH] crypto: stm32: fix module device table name
Date: Thu, 30 Nov 2017 12:04:33 +0100
Message-ID: <20171130110433.15811-1-clabbe.montjoie@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Corentin Labbe <clabbe.montjoie@gmail.com>
To: herbert@gondor.apana.org.au, fabien.dessenne@st.com,
        alexandre.torgue@st.com, davem@davemloft.net,
        mcoquelin.stm32@gmail.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wr0-f193.google.com ([209.85.128.193]:39442 "EHLO
        mail-wr0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750891AbdK3LHN (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 30 Nov 2017 06:07:13 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch fix the following build failure:
  CC [M]  drivers/crypto/stm32/stm32-cryp.o
In file included from drivers/crypto/stm32/stm32-cryp.c:11:0:
drivers/crypto/stm32/stm32-cryp.c:1049:25: error: 'sti_dt_ids' undeclared here (not in a function)
 MODULE_DEVICE_TABLE(of, sti_dt_ids);

Let's replace sti_dt_ids with stm32_dt_ids which is just declared
before.

Signed-off-by: Corentin Labbe <clabbe.montjoie@gmail.com>
---
 drivers/crypto/stm32/stm32-cryp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/stm32/stm32-cryp.c b/drivers/crypto/stm32/stm32-cryp.c
index 098fad266c41..1807789b23f5 100644
--- a/drivers/crypto/stm32/stm32-cryp.c
+++ b/drivers/crypto/stm32/stm32-cryp.c
@@ -1046,7 +1046,7 @@ static const struct of_device_id stm32_dt_ids[] = {
 	{ .compatible = "st,stm32f756-cryp", },
 	{},
 };
-MODULE_DEVICE_TABLE(of, sti_dt_ids);
+MODULE_DEVICE_TABLE(of, stm32_dt_ids);
 
 static int stm32_cryp_probe(struct platform_device *pdev)
 {
-- 
2.13.6
