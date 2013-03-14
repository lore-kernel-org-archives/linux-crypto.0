From: Sachin Kamat <sachin.kamat@linaro.org>
Subject: [PATCH 1/1] crypto: picoxcell_crypto: Use of_match_ptr() macro
Date: Thu, 14 Mar 2013 15:46:58 +0530
Message-ID: <1363256218-26326-1-git-send-email-sachin.kamat@linaro.org>
Cc: herbert@gondor.apana.org.au, jamie@jamieiles.com,
	davem@davemloft.net, sachin.kamat@linaro.org
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pb0-f48.google.com ([209.85.160.48]:42701 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756205Ab3CNK1u (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 14 Mar 2013 06:27:50 -0400
Received: by mail-pb0-f48.google.com with SMTP id wy12so1986872pbc.21
        for <linux-crypto@vger.kernel.org>; Thu, 14 Mar 2013 03:27:50 -0700 (PDT)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This eliminates having an #ifdef returning NULL for the case
when OF is disabled.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/crypto/picoxcell_crypto.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/picoxcell_crypto.c b/drivers/crypto/picoxcell_crypto.c
index 2096d46..ac30724 100644
--- a/drivers/crypto/picoxcell_crypto.c
+++ b/drivers/crypto/picoxcell_crypto.c
@@ -1688,8 +1688,6 @@ static const struct of_device_id spacc_of_id_table[] = {
 	{ .compatible = "picochip,spacc-l2" },
 	{}
 };
-#else /* CONFIG_OF */
-#define spacc_of_id_table NULL
 #endif /* CONFIG_OF */
 
 static bool spacc_is_compatible(struct platform_device *pdev,
@@ -1874,7 +1872,7 @@ static struct platform_driver spacc_driver = {
 #ifdef CONFIG_PM
 		.pm	= &spacc_pm_ops,
 #endif /* CONFIG_PM */
-		.of_match_table	= spacc_of_id_table,
+		.of_match_table	= of_match_ptr(spacc_of_id_table),
 	},
 	.id_table	= spacc_id_table,
 };
-- 
1.7.4.1
