From: Peter Robinson <pbrobinson@gmail.com>
Subject: [PATCH] crypto: sunxi-ss: Add MODULE_ALIAS to sun4i-ss
Date: Sun, 11 Feb 2018 23:15:37 +0000
Message-ID: <20180211231537.26487-1-pbrobinson@gmail.com>
Cc: Peter Robinson <pbrobinson@gmail.com>, stable@vger.kernel.org
To: Corentin Labbe <clabbe.montjoie@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Chen-Yu Tsai <wens@csie.org>, linux-crypto@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ot0-f195.google.com ([74.125.82.195]:34919 "EHLO
        mail-ot0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932160AbeBKXPx (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 11 Feb 2018 18:15:53 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The MODULE_ALIAS is required to enable the sun4i-ss driver to load
automatically when built at a module. Tested on a Cubietruck.

Fixes: 6298e948215f ("crypto: sunxi-ss - Add Allwinner Security System crypto accelerator")
Cc: <stable@vger.kernel.org>
Signed-off-by: Peter Robinson <pbrobinson@gmail.com>
---
 drivers/crypto/sunxi-ss/sun4i-ss-core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/crypto/sunxi-ss/sun4i-ss-core.c b/drivers/crypto/sunxi-ss/sun4i-ss-core.c
index 1547cbe13dc2..a81d89b3b7d8 100644
--- a/drivers/crypto/sunxi-ss/sun4i-ss-core.c
+++ b/drivers/crypto/sunxi-ss/sun4i-ss-core.c
@@ -451,6 +451,7 @@ static struct platform_driver sun4i_ss_driver = {
 
 module_platform_driver(sun4i_ss_driver);
 
+MODULE_ALIAS("platform:sun4i-ss");
 MODULE_DESCRIPTION("Allwinner Security System cryptographic accelerator");
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Corentin LABBE <clabbe.montjoie@gmail.com>");
-- 
2.14.3
