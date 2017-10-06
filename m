From: Christophe Leroy <christophe.leroy@c-s.fr>
Subject: [PATCH 11/18] crypto: talitos - use devm_ioremap()
Date: Fri,  6 Oct 2017 15:04:53 +0200 (CEST)
Message-ID: <0cee991b4ebeabf7a6f3827029ec9acf04774ba6.1507284818.git.christophe.leroy@c-s.fr>
References: <cover.1507284818.git.christophe.leroy@c-s.fr>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from pegase1.c-s.fr ([93.17.236.30]:26821 "EHLO pegase1.c-s.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752688AbdJFNEz (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 6 Oct 2017 09:04:55 -0400
In-Reply-To: <cover.1507284818.git.christophe.leroy@c-s.fr>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Use devm_ioremap()

Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>
---
 drivers/crypto/talitos.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
index f139a0cef2e2..83b2a70a1ba7 100644
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -3008,8 +3008,6 @@ static int talitos_remove(struct platform_device *ofdev)
 	if (priv->irq[1])
 		tasklet_kill(&priv->done_task[1]);
 
-	iounmap(priv->reg);
-
 	return 0;
 }
 
@@ -3160,6 +3158,7 @@ static int talitos_probe(struct platform_device *ofdev)
 	struct talitos_private *priv;
 	int i, err;
 	int stride;
+	struct resource *res;
 
 	priv = devm_kzalloc(dev, sizeof(struct talitos_private), GFP_KERNEL);
 	if (!priv)
@@ -3173,7 +3172,10 @@ static int talitos_probe(struct platform_device *ofdev)
 
 	spin_lock_init(&priv->reg_lock);
 
-	priv->reg = of_iomap(np, 0);
+	res = platform_get_resource(ofdev, IORESOURCE_MEM, 0);
+	if (!res)
+		return -ENXIO;
+	priv->reg = devm_ioremap(dev, res->start, resource_size(res));
 	if (!priv->reg) {
 		dev_err(dev, "failed to of_iomap\n");
 		err = -ENOMEM;
-- 
2.13.3
