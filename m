From: Thomas Meyer <thomas@m3y3r.de>
Subject: [PATCH] crypto: ux50: Cocci spatch "resource_size.spatch"
Date: Wed, 22 May 2013 21:38:40 +0200
Message-ID: <1369251520.3865.321.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: herbert@gondor.apana.org.au, davem@davemloft.net,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from www17.your-server.de ([213.133.104.17]:46600 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753849Ab3EVUBj (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 22 May 2013 16:01:39 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


Signed-off-by: Thomas Meyer <thomas@m3y3r.de>
---

diff -u -p a/drivers/crypto/ux500/cryp/cryp_core.c b/drivers/crypto/ux500/cryp/cryp_core.c
--- a/drivers/crypto/ux500/cryp/cryp_core.c
+++ b/drivers/crypto/ux500/cryp/cryp_core.c
@@ -1600,7 +1600,7 @@ static int ux500_cryp_remove(struct plat
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (res)
-		release_mem_region(res->start, res->end - res->start + 1);
+		release_mem_region(res->start, resource_size(res));
 
 	kfree(device_data);
 
