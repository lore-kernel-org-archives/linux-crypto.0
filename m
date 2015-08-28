From: Luis de Bethencourt <luis@debethencourt.com>
Subject: [PATCH 1/3] crypto: amcc: Fix module autoload for OF platform driver
Date: Fri, 28 Aug 2015 18:43:24 +0200
Message-ID: <20150828164324.GA5032@goodgumbo.baconseed.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Wolfram Sang <wsa@the-dreams.de>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	linux-crypto@vger.kernel.org,
	Javier Martinez Canillas <javier@osg.samsung.com>
To: linux-kernel@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:33134 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752664AbbH1Qn1 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 28 Aug 2015 12:43:27 -0400
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This platform driver has a OF device ID table but the OF module
alias information is not created so module autoloading won't work.

Signed-off-by: Luis de Bethencourt <luis@debethencourt.com>
---
 drivers/crypto/amcc/crypto4xx_core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/crypto/amcc/crypto4xx_core.c b/drivers/crypto/amcc/crypto4xx_core.c
index 3b28e8c..3cdc709 100644
--- a/drivers/crypto/amcc/crypto4xx_core.c
+++ b/drivers/crypto/amcc/crypto4xx_core.c
@@ -1284,6 +1284,7 @@ static const struct of_device_id crypto4xx_match[] = {
 	{ .compatible      = "amcc,ppc4xx-crypto",},
 	{ },
 };
+MODULE_DEVICE_TABLE(of, crypto4xx_match);
 
 static struct platform_driver crypto4xx_driver = {
 	.driver = {
-- 
2.4.6
