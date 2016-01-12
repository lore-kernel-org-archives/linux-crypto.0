From: =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>
Subject: [PATCH 1/2] crypto: caam - make write transactions bufferable on PPC platforms
Date: Tue, 12 Jan 2016 17:14:09 +0200
Message-ID: <1452611650-15803-2-git-send-email-horia.geanta@nxp.com>
References: <1452611650-15803-1-git-send-email-horia.geanta@nxp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: <linux-crypto@vger.kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Fabio Estevam <fabio.estevam@nxp.com>,
	Alex Porosanu <alexandru.porosanu@nxp.com>,
	Scott Wood <scott.wood@nxp.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bn1on0065.outbound.protection.outlook.com ([157.56.110.65]:56928
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S934184AbcALPsR (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 12 Jan 2016 10:48:17 -0500
In-Reply-To: <1452611650-15803-1-git-send-email-horia.geanta@nxp.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Previous change (see "Fixes" tag) to the MCFGR register
clears AWCACHE[0] ("bufferable" AXI3 attribute) (which is "1" at POR).

This makes all writes non-bufferable, causing a ~ 5% performance drop
for PPC-based platforms.

Rework previous change such that MCFGR[AWCACHE]=3D4'b0011
(bufferable + cacheable) for all platforms.
Note: For ARM-based platforms, AWCACHE[0] is ignored
by the interconnect IP.

=46ixes: f10967495144 ("crypto: caam - fix snooping for write transacti=
ons")
Signed-off-by: Horia Geant=C4=83 <horia.geanta@nxp.com>
---
 drivers/crypto/caam/ctrl.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/caam/ctrl.c b/drivers/crypto/caam/ctrl.c
index 8abb4bc548cc..69d4a1326fee 100644
--- a/drivers/crypto/caam/ctrl.c
+++ b/drivers/crypto/caam/ctrl.c
@@ -534,8 +534,8 @@ static int caam_probe(struct platform_device *pdev)
 	 * long pointers in master configuration register
 	 */
 	clrsetbits_32(&ctrl->mcr, MCFGR_AWCACHE_MASK, MCFGR_AWCACHE_CACH |
-		      MCFGR_WDENABLE | (sizeof(dma_addr_t) =3D=3D sizeof(u64) ?
-					MCFGR_LONG_PTR : 0));
+		      MCFGR_AWCACHE_BUFF | MCFGR_WDENABLE |
+		      (sizeof(dma_addr_t) =3D=3D sizeof(u64) ? MCFGR_LONG_PTR : 0));
=20
 	/*
 	 *  Read the Compile Time paramters and SCFGR to determine
--=20
2.4.4
