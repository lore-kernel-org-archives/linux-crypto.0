From: =?UTF-8?q?=C3=81lvaro=20Fern=C3=A1ndez=20Rojas?=
	<noltari@gmail.com>
Subject: [PATCH v2] hw_random: bcm63xx-rng: Fix driver compilation
Date: Sat,  2 May 2015 12:08:42 +0200
Message-ID: <1430561322-26309-1-git-send-email-noltari@gmail.com>
References: <1430491041-24480-1-git-send-email-noltari@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: =?UTF-8?q?=C3=81lvaro=20Fern=C3=A1ndez=20Rojas?=
	<noltari@gmail.com>
To: herbert@gondor.apana.org.au, dmitry.torokhov@gmail.com,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	jogo@openwrt.org, f.fainelli@gmail.com, cernekee@gmail.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wg0-f41.google.com ([74.125.82.41]:34833 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750839AbbEBKIu (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 2 May 2015 06:08:50 -0400
In-Reply-To: <1430491041-24480-1-git-send-email-noltari@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

- s/clk_didsable_unprepare/clk_disable_unprepare
- s/prov/priv
- s/error/ret (bcm63xx_rng_probe)

=46ixes: 6229c16060fe ("hwrng: bcm63xx - make use of devm_hwrng_registe=
r")
Signed-off-by: =C3=81lvaro Fern=C3=A1ndez Rojas <noltari@gmail.com>
---
 v2: fix subject, add fixes tag as suggested by Florian

 drivers/char/hw_random/bcm63xx-rng.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/char/hw_random/bcm63xx-rng.c b/drivers/char/hw_ran=
dom/bcm63xx-rng.c
index d1494ec..4b31f13 100644
--- a/drivers/char/hw_random/bcm63xx-rng.c
+++ b/drivers/char/hw_random/bcm63xx-rng.c
@@ -57,7 +57,7 @@ static void bcm63xx_rng_cleanup(struct hwrng *rng)
 	val &=3D ~RNG_EN;
 	__raw_writel(val, priv->regs + RNG_CTRL);
=20
-	clk_didsable_unprepare(prov->clk);
+	clk_disable_unprepare(priv->clk);
 }
=20
 static int bcm63xx_rng_data_present(struct hwrng *rng, int wait)
@@ -97,14 +97,14 @@ static int bcm63xx_rng_probe(struct platform_device=
 *pdev)
 	priv->rng.name =3D pdev->name;
 	priv->rng.init =3D bcm63xx_rng_init;
 	priv->rng.cleanup =3D bcm63xx_rng_cleanup;
-	prov->rng.data_present =3D bcm63xx_rng_data_present;
+	priv->rng.data_present =3D bcm63xx_rng_data_present;
 	priv->rng.data_read =3D bcm63xx_rng_data_read;
=20
 	priv->clk =3D devm_clk_get(&pdev->dev, "ipsec");
 	if (IS_ERR(priv->clk)) {
-		error =3D PTR_ERR(priv->clk);
-		dev_err(&pdev->dev, "no clock for device: %d\n", error);
-		return error;
+		ret =3D PTR_ERR(priv->clk);
+		dev_err(&pdev->dev, "no clock for device: %d\n", ret);
+		return ret;
 	}
=20
 	if (!devm_request_mem_region(&pdev->dev, r->start,
@@ -120,11 +120,11 @@ static int bcm63xx_rng_probe(struct platform_devi=
ce *pdev)
 		return -ENOMEM;
 	}
=20
-	error =3D devm_hwrng_register(&pdev->dev, &priv->rng);
-	if (error) {
+	ret =3D devm_hwrng_register(&pdev->dev, &priv->rng);
+	if (ret) {
 		dev_err(&pdev->dev, "failed to register rng device: %d\n",
-			error);
-		return error;
+			ret);
+		return ret;
 	}
=20
 	dev_info(&pdev->dev, "registered RNG driver\n");
--=20
1.9.1
