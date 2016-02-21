From: =?UTF-8?q?=C3=81lvaro=20Fern=C3=A1ndez=20Rojas?=
	<noltari@gmail.com>
Subject: [PATCH] hw_random: brcm63xx-rng: fix non device tree compatibility
Date: Sun, 21 Feb 2016 10:53:35 +0100
Message-ID: <1456048415-18465-1-git-send-email-noltari@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: =?UTF-8?q?=C3=81lvaro=20Fern=C3=A1ndez=20Rojas?=
	<noltari@gmail.com>
To: linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
	linux-kernel@vger.kernel.org, f.fainelli@gmail.com,
	jogo@openwrt.org, cernekee@gmail.com
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Allow building when OF is not enabled as suggested by Florian

Signed-off-by: =C3=81lvaro Fern=C3=A1ndez Rojas <noltari@gmail.com>
Reported-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/char/hw_random/bcm63xx-rng.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/char/hw_random/bcm63xx-rng.c b/drivers/char/hw_ran=
dom/bcm63xx-rng.c
index 38553f0..ca9c403 100644
--- a/drivers/char/hw_random/bcm63xx-rng.c
+++ b/drivers/char/hw_random/bcm63xx-rng.c
@@ -130,17 +130,19 @@ static int bcm63xx_rng_probe(struct platform_devi=
ce *pdev)
 	return 0;
 }
=20
+#ifdef CONFIG_OF
 static const struct of_device_id bcm63xx_rng_of_match[] =3D {
 	{ .compatible =3D "brcm,bcm6368-rng", },
 	{},
 };
 MODULE_DEVICE_TABLE(of, bcm63xx_rng_of_match);
+#endif
=20
 static struct platform_driver bcm63xx_rng_driver =3D {
 	.probe		=3D bcm63xx_rng_probe,
 	.driver		=3D {
 		.name	=3D "bcm63xx-rng",
-		.of_match_table =3D bcm63xx_rng_of_match,
+		.of_match_table =3D of_match_ptr(bcm63xx_rng_of_match),
 	},
 };
=20
--=20
1.9.1
