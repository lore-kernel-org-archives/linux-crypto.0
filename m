From: Fabio Estevam <festevam@gmail.com>
Subject: [PATCH v3 2/3] crypto: caam: ctrl: Propagate the real error code
Date: Fri, 21 Aug 2015 13:51:59 -0300
Message-ID: <1440175920-30884-2-git-send-email-festevam@gmail.com>
References: <1440175920-30884-1-git-send-email-festevam@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: vicki.milhoan@freescale.com, horia.geanta@freescale.com,
	linux-crypto@vger.kernel.org,
	Fabio Estevam <fabio.estevam@freescale.com>
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-yk0-f177.google.com ([209.85.160.177]:34949 "EHLO
	mail-yk0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751699AbbHUQwZ (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 21 Aug 2015 12:52:25 -0400
Received: by ykbi184 with SMTP id i184so76145058ykb.2
        for <linux-crypto@vger.kernel.org>; Fri, 21 Aug 2015 09:52:25 -0700 (PDT)
In-Reply-To: <1440175920-30884-1-git-send-email-festevam@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

=46rom: Fabio Estevam <fabio.estevam@freescale.com>

Instead of propagating a 'fake' error code, just propagate the real
one in the case of caam_drv_identify_clk() failure.

Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
Reviewed-by: Horia Geant=C4=83 <horia.geanta@freescale.com>
---
Changes since v2:
- None

 drivers/crypto/caam/ctrl.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/caam/ctrl.c b/drivers/crypto/caam/ctrl.c
index cd22849..b4124a6 100644
--- a/drivers/crypto/caam/ctrl.c
+++ b/drivers/crypto/caam/ctrl.c
@@ -440,7 +440,7 @@ static int caam_probe(struct platform_device *pdev)
 		ret =3D PTR_ERR(clk);
 		dev_err(&pdev->dev,
 			"can't identify CAAM ipg clk: %d\n", ret);
-		return -ENODEV;
+		return ret;
 	}
 	ctrlpriv->caam_ipg =3D clk;
=20
@@ -449,7 +449,7 @@ static int caam_probe(struct platform_device *pdev)
 		ret =3D PTR_ERR(clk);
 		dev_err(&pdev->dev,
 			"can't identify CAAM mem clk: %d\n", ret);
-		return -ENODEV;
+		return ret;
 	}
 	ctrlpriv->caam_mem =3D clk;
=20
@@ -458,7 +458,7 @@ static int caam_probe(struct platform_device *pdev)
 		ret =3D PTR_ERR(clk);
 		dev_err(&pdev->dev,
 			"can't identify CAAM aclk clk: %d\n", ret);
-		return -ENODEV;
+		return ret;
 	}
 	ctrlpriv->caam_aclk =3D clk;
=20
@@ -467,7 +467,7 @@ static int caam_probe(struct platform_device *pdev)
 		ret =3D PTR_ERR(clk);
 		dev_err(&pdev->dev,
 			"can't identify CAAM emi_slow clk: %d\n", ret);
-		return -ENODEV;
+		return ret;
 	}
 	ctrlpriv->caam_emi_slow =3D clk;
=20
--=20
1.9.1
