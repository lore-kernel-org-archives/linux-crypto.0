From: Gregory CLEMENT <gregory.clement@bootlin.com>
Subject: [PATCH 1/3] crypto: inside-secure - fix clock management
Date: Tue, 13 Mar 2018 17:48:40 +0100
Message-ID: <20180313164842.20042-2-gregory.clement@bootlin.com>
References: <20180313164842.20042-1-gregory.clement@bootlin.com>
Cc: Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Gregory CLEMENT <gregory.clement@bootlin.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        linux-arm-kernel@lists.infradead.org,
        =?UTF-8?q?Miqu=C3=A8l=20Raynal?= <miquel.raynal@bootlin.com>,
        Nadav Haklai <nadavh@marvell.com>,
        Shadi Ammouri <shadi@marvell.com>,
        Omri Itach <omrii@marvell.com>,
        Hanna Hawa <hannah@marvell.com>,
        Igal Liberman <igall@marvell.com>,
        Marcin Wojtas <mw@semihalf.com>, stable@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>, davem@davemloft.net,
        linux-crypto@vger.kernel.org,
        Antoine Tenart <antoine.tenart@bootlin.com>, oferh@marvell.com
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20180313164842.20042-1-gregory.clement@bootlin.com>
Sender: stable-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

In this driver the clock is got but never put when the driver is removed
or if there is an error in the probe.

Using the managed version of clk_get() allows to let the kernel take care
of it.

Fixes: 1b44c5a60c13 ("crypto: inside-secure - add SafeXcel EIP197 crypto
engine driver")
cc: stable@vger.kernel.org
Signed-off-by: Gregory CLEMENT <gregory.clement@bootlin.com>
---
 drivers/crypto/inside-secure/safexcel.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/inside-secure/safexcel.c b/drivers/crypto/inside-secure/safexcel.c
index 384b4ceb37f0..09adeaa0da6b 100644
--- a/drivers/crypto/inside-secure/safexcel.c
+++ b/drivers/crypto/inside-secure/safexcel.c
@@ -881,7 +881,7 @@ static int safexcel_probe(struct platform_device *pdev)
 		return PTR_ERR(priv->base);
 	}
 
-	priv->clk = of_clk_get(dev->of_node, 0);
+	priv->clk = devm_clk_get(&pdev->dev, NULL);
 	if (!IS_ERR(priv->clk)) {
 		ret = clk_prepare_enable(priv->clk);
 		if (ret) {
-- 
2.16.1
