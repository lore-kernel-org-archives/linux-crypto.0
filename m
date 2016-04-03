From: =?UTF-8?q?=C3=81lvaro=20Fern=C3=A1ndez=20Rojas?=
	<noltari@gmail.com>
Subject: [PATCH] hwrng: bcm63xx - fix device tree compilation
Date: Sun,  3 Apr 2016 14:18:22 +0200
Message-ID: <1459685902-11861-1-git-send-email-noltari@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: =?UTF-8?q?=C3=81lvaro=20Fern=C3=A1ndez=20Rojas?=
	<noltari@gmail.com>
To: linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
	linux-kernel@vger.kernel.org, f.fainelli@gmail.com,
	jogo@openwrt.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-lb0-f175.google.com ([209.85.217.175]:35932 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753528AbcDCMSZ (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 3 Apr 2016 08:18:25 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Adds missing include that resulted in implicit device tree functions er=
rors.

=46ixes: 7b651706712b ("hwrng: bcm63xx - add device tree support")
Signed-off-by: =C3=81lvaro Fern=C3=A1ndez Rojas <noltari@gmail.com>
---
 drivers/char/hw_random/bcm63xx-rng.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/char/hw_random/bcm63xx-rng.c b/drivers/char/hw_ran=
dom/bcm63xx-rng.c
index ca9c403..5132c9c 100644
--- a/drivers/char/hw_random/bcm63xx-rng.c
+++ b/drivers/char/hw_random/bcm63xx-rng.c
@@ -12,6 +12,7 @@
 #include <linux/clk.h>
 #include <linux/platform_device.h>
 #include <linux/hw_random.h>
+#include <linux/of.h>
=20
 #define RNG_CTRL			0x00
 #define RNG_EN				(1 << 0)
--=20
2.1.4
