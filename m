From: =?UTF-8?q?=C3=81lvaro=20Fern=C3=A1ndez=20Rojas?=
	<noltari@gmail.com>
Subject: [PATCH 1/4] hw_random: bcm63xx-rng: remove unused variables
Date: Sun, 17 Jan 2016 10:03:54 +0100
Message-ID: <1453021437-12531-1-git-send-email-noltari@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: =?UTF-8?q?=C3=81lvaro=20Fern=C3=A1ndez=20Rojas?=
	<noltari@gmail.com>
To: linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
	linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
	f.fainelli@gmail.com, jogo@openwrt.org, cernekee@gmail.com
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

These variables where left as unused in commit 6229c16060fe
("hwrng: bcm63xx - make use of devm_hwrng_register")

=46ixes the following warning:
drivers/char/hw_random/bcm63xx-rng.c: In function 'bcm63xx_rng_probe':
drivers/char/hw_random/bcm63xx-rng.c:85:16: warning: unused variable 'r=
ng'
[-Wunused-variable]
  struct hwrng *rng;
                ^
drivers/char/hw_random/bcm63xx-rng.c:82:14: warning: unused variable 'c=
lk'
[-Wunused-variable]
  struct clk *clk;

Signed-off-by: =C3=81lvaro Fern=C3=A1ndez Rojas <noltari@gmail.com>
---
 drivers/char/hw_random/bcm63xx-rng.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/char/hw_random/bcm63xx-rng.c b/drivers/char/hw_ran=
dom/bcm63xx-rng.c
index 4b31f13..c303f30 100644
--- a/drivers/char/hw_random/bcm63xx-rng.c
+++ b/drivers/char/hw_random/bcm63xx-rng.c
@@ -79,10 +79,8 @@ static int bcm63xx_rng_data_read(struct hwrng *rng, =
u32 *data)
 static int bcm63xx_rng_probe(struct platform_device *pdev)
 {
 	struct resource *r;
-	struct clk *clk;
 	int ret;
 	struct bcm63xx_rng_priv *priv;
-	struct hwrng *rng;
=20
 	r =3D platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (!r) {
--=20
1.9.1
