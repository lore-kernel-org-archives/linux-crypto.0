From: =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@freescale.com>
Subject: [PATCH 3/4] crypto: caam - fix RNG init descriptor ret. code checking
Date: Fri, 17 Jul 2015 16:54:53 +0300
Message-ID: <1437141294-15678-3-git-send-email-horia.geanta@freescale.com>
References: <1437141294-15678-1-git-send-email-horia.geanta@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bn1bon0140.outbound.protection.outlook.com ([157.56.111.140]:50720
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751305AbbGQN4e (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 17 Jul 2015 09:56:34 -0400
In-Reply-To: <1437141294-15678-1-git-send-email-horia.geanta@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

When successful, the descriptor that performs RNG initialization
is allowed to return a status code of 7000_0000h, since last command
in the descriptor is a JUMP HALT.

Signed-off-by: Horia Geant=C4=83 <horia.geanta@freescale.com>
---
 drivers/crypto/caam/ctrl.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/caam/ctrl.c b/drivers/crypto/caam/ctrl.c
index b924477c0d83..189180976167 100644
--- a/drivers/crypto/caam/ctrl.c
+++ b/drivers/crypto/caam/ctrl.c
@@ -175,7 +175,7 @@ static int instantiate_rng(struct device *ctrldev, =
int state_handle_mask,
 {
 	struct caam_drv_private *ctrlpriv =3D dev_get_drvdata(ctrldev);
 	struct caam_ctrl __iomem *ctrl;
-	u32 *desc, status, rdsta_val;
+	u32 *desc, status =3D 0, rdsta_val;
 	int ret =3D 0, sh_idx;
=20
 	ctrl =3D (struct caam_ctrl __iomem *)ctrlpriv->ctrl;
@@ -207,7 +207,8 @@ static int instantiate_rng(struct device *ctrldev, =
int state_handle_mask,
 		 * CAAM eras), then try again.
 		 */
 		rdsta_val =3D rd_reg32(&ctrl->r4tst[0].rdsta) & RDSTA_IFMASK;
-		if (status || !(rdsta_val & (1 << sh_idx)))
+		if ((status && status !=3D JRSTA_SSRC_JUMP_HALT_CC) ||
+		    !(rdsta_val & (1 << sh_idx)))
 			ret =3D -EAGAIN;
 		if (ret)
 			break;
--=20
2.4.4
