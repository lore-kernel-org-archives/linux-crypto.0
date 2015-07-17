From: =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@freescale.com>
Subject: [PATCH 1/4] crypto: caam - fix ERA property reading
Date: Fri, 17 Jul 2015 16:54:51 +0300
Message-ID: <1437141294-15678-1-git-send-email-horia.geanta@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: <linux-crypto@vger.kernel.org>,
	Alex Porosanu <alexandru.porosanu@freescale.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bn1bon0110.outbound.protection.outlook.com ([157.56.111.110]:63205
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751305AbbGQN4a (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 17 Jul 2015 09:56:30 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

=46rom: Alex Porosanu <alexandru.porosanu@freescale.com>

In order to ensure that the ERA property is properly read from DT
on all platforms, of_property_read* function needs to be used.

Signed-off-by: Alex Porosanu <alexandru.porosanu@freescale.com>
Signed-off-by: Horia Geant=C4=83 <horia.geanta@freescale.com>
---
 drivers/crypto/caam/ctrl.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/crypto/caam/ctrl.c b/drivers/crypto/caam/ctrl.c
index efacab7539ef..598823746a3b 100644
--- a/drivers/crypto/caam/ctrl.c
+++ b/drivers/crypto/caam/ctrl.c
@@ -370,14 +370,14 @@ static void kick_trng(struct platform_device *pde=
v, int ent_delay)
 int caam_get_era(void)
 {
 	struct device_node *caam_node;
-	for_each_compatible_node(caam_node, NULL, "fsl,sec-v4.0") {
-		const uint32_t *prop =3D (uint32_t *)of_get_property(caam_node,
-				"fsl,sec-era",
-				NULL);
-		return prop ? *prop : -ENOTSUPP;
-	}
+	int ret;
+	u32 prop;
+
+	caam_node =3D of_find_compatible_node(NULL, NULL, "fsl,sec-v4.0");
+	ret =3D of_property_read_u32(caam_node, "fsl,sec-era", &prop);
+	of_node_put(caam_node);
=20
-	return -ENOTSUPP;
+	return IS_ERR_VALUE(ret) ? -ENOTSUPP : prop;
 }
 EXPORT_SYMBOL(caam_get_era);
=20
--=20
2.4.4
