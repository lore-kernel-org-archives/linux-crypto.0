From: Luis de Bethencourt <luis@debethencourt.com>
Subject: [PATCH 2/3] crypto: picoxcell: Fix module autoload for OF platform
 driver
Date: Fri, 28 Aug 2015 18:44:03 +0200
Message-ID: <20150828164403.GA5083@goodgumbo.baconseed.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jamie Iles <jamie@jamieiles.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
	Javier Martinez Canillas <javier@osg.samsung.com>
To: linux-kernel@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wi0-f179.google.com ([209.85.212.179]:37786 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752664AbbH1QoH (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 28 Aug 2015 12:44:07 -0400
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This platform driver has a OF device ID table but the OF module
alias information is not created so module autoloading won't work.

Signed-off-by: Luis de Bethencourt <luis@debethencourt.com>
---
 drivers/crypto/picoxcell_crypto.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/crypto/picoxcell_crypto.c b/drivers/crypto/picoxcell_crypto.c
index 4f56f36..b6ec2a4 100644
--- a/drivers/crypto/picoxcell_crypto.c
+++ b/drivers/crypto/picoxcell_crypto.c
@@ -1673,6 +1673,7 @@ static const struct of_device_id spacc_of_id_table[] = {
 	{ .compatible = "picochip,spacc-l2" },
 	{}
 };
+MODULE_DEVICE_TABLE(of, spacc_of_id_table);
 #endif /* CONFIG_OF */
 
 static bool spacc_is_compatible(struct platform_device *pdev,
-- 
2.4.6
