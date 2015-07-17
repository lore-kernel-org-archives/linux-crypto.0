From: =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@freescale.com>
Subject: [PATCH 2/4] crypto: caam - fix snooping for write transactions
Date: Fri, 17 Jul 2015 16:54:52 +0300
Message-ID: <1437141294-15678-2-git-send-email-horia.geanta@freescale.com>
References: <1437141294-15678-1-git-send-email-horia.geanta@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bl2on0124.outbound.protection.outlook.com ([65.55.169.124]:5578
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751305AbbGQN4c (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 17 Jul 2015 09:56:32 -0400
In-Reply-To: <1437141294-15678-1-git-send-email-horia.geanta@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

HW coherency won't work properly for CAAM write transactions
if AWCACHE is left to default (POR) value - 4'b0001.
It has to be programmed to 4'b0010, i.e. AXI3 Cacheable bit set.

=46or platforms that have HW coherency support:
-PPC-based: the update has no effect; CAAM coherency already works
due to the IOMMU (PAMU) driver setting the correct memory coherency
attributes
-ARM-based: the update fixes cache coherency issues,
since IOMMU (SMMU) driver is not programmed to behave similar to PAMU

Signed-off-by: Horia Geant=C4=83 <horia.geanta@freescale.com>
---
 drivers/crypto/caam/ctrl.c | 5 +++--
 drivers/crypto/caam/regs.h | 6 ++++++
 2 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/caam/ctrl.c b/drivers/crypto/caam/ctrl.c
index 598823746a3b..b924477c0d83 100644
--- a/drivers/crypto/caam/ctrl.c
+++ b/drivers/crypto/caam/ctrl.c
@@ -444,8 +444,9 @@ static int caam_probe(struct platform_device *pdev)
 	 * Enable DECO watchdogs and, if this is a PHYS_ADDR_T_64BIT kernel,
 	 * long pointers in master configuration register
 	 */
-	setbits32(&ctrl->mcr, MCFGR_WDENABLE |
-		  (sizeof(dma_addr_t) =3D=3D sizeof(u64) ? MCFGR_LONG_PTR : 0));
+	clrsetbits_be32(&ctrl->mcr, MCFGR_AWCACHE_MASK, MCFGR_AWCACHE_CACH |
+			MCFGR_WDENABLE | (sizeof(dma_addr_t) =3D=3D sizeof(u64) ?
+					 MCFGR_LONG_PTR : 0));
=20
 	/*
 	 *  Read the Compile Time paramters and SCFGR to determine
diff --git a/drivers/crypto/caam/regs.h b/drivers/crypto/caam/regs.h
index 672c97489505..5e643523de15 100644
--- a/drivers/crypto/caam/regs.h
+++ b/drivers/crypto/caam/regs.h
@@ -395,10 +395,16 @@ struct caam_ctrl {
 /* AXI read cache control */
 #define MCFGR_ARCACHE_SHIFT	12
 #define MCFGR_ARCACHE_MASK	(0xf << MCFGR_ARCACHE_SHIFT)
+#define MCFGR_ARCACHE_BUFF	(0x1 << MCFGR_ARCACHE_SHIFT)
+#define MCFGR_ARCACHE_CACH	(0x2 << MCFGR_ARCACHE_SHIFT)
+#define MCFGR_ARCACHE_RALL	(0x4 << MCFGR_ARCACHE_SHIFT)
=20
 /* AXI write cache control */
 #define MCFGR_AWCACHE_SHIFT	8
 #define MCFGR_AWCACHE_MASK	(0xf << MCFGR_AWCACHE_SHIFT)
+#define MCFGR_AWCACHE_BUFF	(0x1 << MCFGR_AWCACHE_SHIFT)
+#define MCFGR_AWCACHE_CACH	(0x2 << MCFGR_AWCACHE_SHIFT)
+#define MCFGR_AWCACHE_WALL	(0x8 << MCFGR_AWCACHE_SHIFT)
=20
 /* AXI pipeline depth */
 #define MCFGR_AXIPIPE_SHIFT	4
--=20
2.4.4
