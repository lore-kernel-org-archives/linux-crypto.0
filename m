From: =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>
Subject: [PATCH 2/2] crypto: caam - enable LARGE_BURST for enhancing DMA transactions size
Date: Tue, 12 Jan 2016 17:14:10 +0200
Message-ID: <1452611650-15803-3-git-send-email-horia.geanta@nxp.com>
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
Received: from mail-bl2on0069.outbound.protection.outlook.com ([65.55.169.69]:39936
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757551AbcALPsu (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 12 Jan 2016 10:48:50 -0500
In-Reply-To: <1452611650-15803-1-git-send-email-horia.geanta@nxp.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Increasing CAAM DMA engine transaction size either
-reduces the number of required transactions or
-adds the ability to transfer more data with same transaction count

Signed-off-by: Horia Geant=C4=83 <horia.geanta@nxp.com>
---
 drivers/crypto/caam/ctrl.c | 2 +-
 drivers/crypto/caam/regs.h | 3 ++-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/caam/ctrl.c b/drivers/crypto/caam/ctrl.c
index 69d4a1326fee..44d30b45f3cc 100644
--- a/drivers/crypto/caam/ctrl.c
+++ b/drivers/crypto/caam/ctrl.c
@@ -534,7 +534,7 @@ static int caam_probe(struct platform_device *pdev)
 	 * long pointers in master configuration register
 	 */
 	clrsetbits_32(&ctrl->mcr, MCFGR_AWCACHE_MASK, MCFGR_AWCACHE_CACH |
-		      MCFGR_AWCACHE_BUFF | MCFGR_WDENABLE |
+		      MCFGR_AWCACHE_BUFF | MCFGR_WDENABLE | MCFGR_LARGE_BURST |
 		      (sizeof(dma_addr_t) =3D=3D sizeof(u64) ? MCFGR_LONG_PTR : 0));
=20
 	/*
diff --git a/drivers/crypto/caam/regs.h b/drivers/crypto/caam/regs.h
index a8a79975682f..0ba9c40597dc 100644
--- a/drivers/crypto/caam/regs.h
+++ b/drivers/crypto/caam/regs.h
@@ -455,7 +455,8 @@ struct caam_ctrl {
 #define MCFGR_AXIPIPE_MASK	(0xf << MCFGR_AXIPIPE_SHIFT)
=20
 #define MCFGR_AXIPRI		0x00000008 /* Assert AXI priority sideband */
-#define MCFGR_BURST_64		0x00000001 /* Max burst size */
+#define MCFGR_LARGE_BURST	0x00000004 /* 128/256-byte burst size */
+#define MCFGR_BURST_64		0x00000001 /* 64-byte burst size */
=20
 /* JRSTART register offsets */
 #define JRSTART_JR0_START       0x00000001 /* Start Job ring 0 */
--=20
2.4.4
