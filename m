From: Christophe Leroy <christophe.leroy@c-s.fr>
Subject: [PATCH 10/18] crypto: talitos - use of_property_read_u32()
Date: Fri,  6 Oct 2017 15:04:51 +0200 (CEST)
Message-ID: <b4dbdec1ba02c2829ebcbf479eca3bfeac09391b.1507284818.git.christophe.leroy@c-s.fr>
References: <cover.1507284818.git.christophe.leroy@c-s.fr>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1507284818.git.christophe.leroy@c-s.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Use of_property_read_u32() to simplify DT read

Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>
---
 drivers/crypto/talitos.c | 21 +++++----------------
 1 file changed, 5 insertions(+), 16 deletions(-)

diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
index 2a53d0f2a869..f139a0cef2e2 100644
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -3158,7 +3158,6 @@ static int talitos_probe(struct platform_device *ofdev)
 	struct device *dev = &ofdev->dev;
 	struct device_node *np = ofdev->dev.of_node;
 	struct talitos_private *priv;
-	const unsigned int *prop;
 	int i, err;
 	int stride;
 
@@ -3182,21 +3181,11 @@ static int talitos_probe(struct platform_device *ofdev)
 	}
 
 	/* get SEC version capabilities from device tree */
-	prop = of_get_property(np, "fsl,num-channels", NULL);
-	if (prop)
-		priv->num_channels = *prop;
-
-	prop = of_get_property(np, "fsl,channel-fifo-len", NULL);
-	if (prop)
-		priv->chfifo_len = *prop;
-
-	prop = of_get_property(np, "fsl,exec-units-mask", NULL);
-	if (prop)
-		priv->exec_units = *prop;
-
-	prop = of_get_property(np, "fsl,descriptor-types-mask", NULL);
-	if (prop)
-		priv->desc_types = *prop;
+	of_property_read_u32(np, "fsl,num-channels", &priv->num_channels);
+	of_property_read_u32(np, "fsl,channel-fifo-len", &priv->chfifo_len);
+	of_property_read_u32(np, "fsl,exec-units-mask", &priv->exec_units);
+	of_property_read_u32(np, "fsl,descriptor-types-mask",
+			     &priv->desc_types);
 
 	if (!is_power_of_2(priv->num_channels) || !priv->chfifo_len ||
 	    !priv->exec_units || !priv->desc_types) {
-- 
2.13.3
