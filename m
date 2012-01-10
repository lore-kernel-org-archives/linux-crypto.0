From: Kim Phillips <kim.phillips@freescale.com>
Subject: [PATCH 2/2] crypto: caam - be less noisy on startup
Date: Mon, 9 Jan 2012 18:26:49 -0600
Message-ID: <20120109182649.fa0b081b599151e80855bd38@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from db3ehsobe003.messaging.microsoft.com ([213.199.154.141]:27450
	"EHLO DB3EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933521Ab2AJA2L (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 9 Jan 2012 19:28:11 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

sha224 and 384 support extends caam noise to 21 lines.  Do the same
as commit 5b859b6 "crypto: talitos - be less noisy on startup", but
for caam, and display:

caam ffe300000.crypto: fsl,sec-v4.0 algorithms registered in /proc/crypto

Signed-off-by: Kim Phillips <kim.phillips@freescale.com>
---
 drivers/crypto/caam/caamalg.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/caam/caamalg.c b/drivers/crypto/caam/caamalg.c
index f6b8dcc..9526024 100644
--- a/drivers/crypto/caam/caamalg.c
+++ b/drivers/crypto/caam/caamalg.c
@@ -2400,12 +2400,12 @@ static int __init caam_algapi_init(void)
 			dev_warn(ctrldev, "%s alg registration failed\n",
 				t_alg->crypto_alg.cra_driver_name);
 			kfree(t_alg);
-		} else {
+		} else
 			list_add_tail(&t_alg->entry, &priv->alg_list);
-			dev_info(ctrldev, "%s\n",
-				 t_alg->crypto_alg.cra_driver_name);
-		}
 	}
+	if (!list_empty(&priv->alg_list))
+		dev_info(ctrldev, "%s algorithms registered in /proc/crypto\n",
+			 (char *)of_get_property(dev_node, "compatible", NULL));
 
 	return err;
 }
-- 
1.7.8.3
