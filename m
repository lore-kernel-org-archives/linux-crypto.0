From: Horia Geanta <horia.geanta@freescale.com>
Subject: [PATCH 1/4] crypto: talitos - avoid memleak in talitos_alg_alloc()
Date: Mon, 11 May 2015 20:03:24 +0300
Message-ID: <1431363804-2331-1-git-send-email-horia.geanta@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-crypto@vger.kernel.org>,
	"David S. Miller" <davem@davemloft.net>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bl2on0116.outbound.protection.outlook.com ([65.55.169.116]:15680
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752321AbbEKREK (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 11 May 2015 13:04:10 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Cc: <stable@vger.kernel.org> # 3.2+
Fixes: 1d11911a8c57 ("crypto: talitos - fix warning: 'alg' may be used uninitialized in this function")
Signed-off-by: Horia Geanta <horia.geanta@freescale.com>
---
 drivers/crypto/talitos.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
index c04074d08461..2c2ec0e0c145 100644
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -2813,6 +2813,7 @@ static struct talitos_crypto_alg *talitos_alg_alloc(struct device *dev,
 		break;
 	default:
 		dev_err(dev, "unknown algorithm type %d\n", t_alg->algt.type);
+		kfree(t_alg);
 		return ERR_PTR(-EINVAL);
 	}
 
-- 
1.8.3.1
