From: =?UTF-8?q?=C3=81lvaro=20Fern=C3=A1ndez=20Rojas?=
	<noltari@gmail.com>
Subject: [PATCH 2/4] hw_random: bcm63xx-rng: add device tree support
Date: Sun, 17 Jan 2016 10:03:55 +0100
Message-ID: <1453021437-12531-2-git-send-email-noltari@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: =?UTF-8?q?=C3=81lvaro=20Fern=C3=A1ndez=20Rojas?=
	<noltari@gmail.com>
To: linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
	linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
	f.fainelli@gmail.com, jogo@openwrt.org, cernekee@gmail.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:34566 "EHLO
	mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751779AbcAQJDd (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 17 Jan 2016 04:03:33 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Adds device tree support for BCM6368, which seems to be the only BCM63x=
x with
bcm63xx-rng support.

Signed-off-by: =C3=81lvaro Fern=C3=A1ndez Rojas <noltari@gmail.com>
---
 drivers/char/hw_random/bcm63xx-rng.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/char/hw_random/bcm63xx-rng.c b/drivers/char/hw_ran=
dom/bcm63xx-rng.c
index c303f30..38553f0 100644
--- a/drivers/char/hw_random/bcm63xx-rng.c
+++ b/drivers/char/hw_random/bcm63xx-rng.c
@@ -130,10 +130,17 @@ static int bcm63xx_rng_probe(struct platform_devi=
ce *pdev)
 	return 0;
 }
=20
+static const struct of_device_id bcm63xx_rng_of_match[] =3D {
+	{ .compatible =3D "brcm,bcm6368-rng", },
+	{},
+};
+MODULE_DEVICE_TABLE(of, bcm63xx_rng_of_match);
+
 static struct platform_driver bcm63xx_rng_driver =3D {
 	.probe		=3D bcm63xx_rng_probe,
 	.driver		=3D {
 		.name	=3D "bcm63xx-rng",
+		.of_match_table =3D bcm63xx_rng_of_match,
 	},
 };
=20
--=20
1.9.1
