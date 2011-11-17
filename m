From: Kim Phillips <kim.phillips@freescale.com>
Subject: [PATCH 2/5] crypto: talitos - be less noisy on startup
Date: Wed, 16 Nov 2011 18:19:26 -0600
Message-ID: <20111116181926.2c34cf5fd0e652d2b142f8f7@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from db3ehsobe006.messaging.microsoft.com ([213.199.154.144]:58872
	"EHLO DB3EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754701Ab1KQAU2 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 16 Nov 2011 19:20:28 -0500
Received: from mail79-db3 (localhost.localdomain [127.0.0.1])	by
 mail79-db3-R.bigfish.com (Postfix) with ESMTP id D28C2F40101	for
 <linux-crypto@vger.kernel.org>; Thu, 17 Nov 2011 00:20:14 +0000 (UTC)
Received: from DB3EHSMHS016.bigfish.com (unknown [10.3.81.252])	by
 mail79-db3.bigfish.com (Postfix) with ESMTP id ABB461320051	for
 <linux-crypto@vger.kernel.org>; Thu, 17 Nov 2011 00:20:14 +0000 (UTC)
Received: from x9 (x9.am.freescale.net [10.82.120.9])	by
 az33smr02.freescale.net (8.13.1/8.13.0) with SMTP id pAH0KMxB027487	for
 <linux-crypto@vger.kernel.org>; Wed, 16 Nov 2011 18:20:22 -0600 (CST)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

talitos prints every algorithm it registers at module load time.
Algorithms are being added that make for an excessively noisy console
(latest HMACs patch makes an SEC 3.1 print 20 lines).
Instead, display the SEC h/w version number, and inform the
user of algorithm registration status in /proc/crypto, like so:

talitos ffe30000.crypto: fsl,sec3.1 algorithms registered in /proc/crypto

Signed-off-by: Kim Phillips <kim.phillips@freescale.com>
---
 drivers/crypto/talitos.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
index 8ce8731..c372a18 100644
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -2784,12 +2784,13 @@ static int talitos_probe(struct platform_device *ofdev)
 				dev_err(dev, "%s alg registration failed\n",
 					name);
 				kfree(t_alg);
-			} else {
+			} else
 				list_add_tail(&t_alg->entry, &priv->alg_list);
-				dev_info(dev, "%s\n", name);
-			}
 		}
 	}
+	if (!list_empty(&priv->alg_list))
+		dev_info(dev, "%s algorithms registered in /proc/crypto\n",
+			 (char *)of_get_property(np, "compatible", NULL));
 
 	return 0;
 
-- 
1.7.7
