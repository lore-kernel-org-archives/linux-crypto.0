From: =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>
Subject: [PATCH] crypto: caam - fix pointer size for AArch64 boot loader, AArch32 kernel
Date: Mon, 5 Dec 2016 11:06:58 +0200
Message-ID: <1480928818-8166-1-git-send-email-horia.geanta@nxp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Cc: "David S. Miller" <davem@davemloft.net>,
        <linux-crypto@vger.kernel.org>,
        Dan Douglass <dan.douglass@nxp.com>,
        Alison Wang <alison.wang@nxp.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-dm3nam03on0045.outbound.protection.outlook.com ([104.47.41.45]:29213
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751704AbcLEJXS (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 5 Dec 2016 04:23:18 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Start with a clean slate before dealing with bit 16 (pointer size)
of Master Configuration Register.
This fixes the case of AArch64 boot loader + AArch32 kernel, when
the boot loader might set MCFGR[PS] and kernel would fail to clear it.

Cc: <stable@vger.kernel.org>
Reported-by: Alison Wang <alison.wang@nxp.com>
Signed-off-by: Horia Geantă <horia.geanta@nxp.com>
---
 drivers/crypto/caam/ctrl.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/caam/ctrl.c b/drivers/crypto/caam/ctrl.c
index be62a7f482ac..0a6ca3919270 100644
--- a/drivers/crypto/caam/ctrl.c
+++ b/drivers/crypto/caam/ctrl.c
@@ -556,8 +556,9 @@ static int caam_probe(struct platform_device *pdev)
 	 * Enable DECO watchdogs and, if this is a PHYS_ADDR_T_64BIT kernel,
 	 * long pointers in master configuration register
 	 */
-	clrsetbits_32(&ctrl->mcr, MCFGR_AWCACHE_MASK, MCFGR_AWCACHE_CACH |
-		      MCFGR_AWCACHE_BUFF | MCFGR_WDENABLE | MCFGR_LARGE_BURST |
+	clrsetbits_32(&ctrl->mcr, MCFGR_AWCACHE_MASK | MCFGR_LONG_PTR,
+		      MCFGR_AWCACHE_CACH | MCFGR_AWCACHE_BUFF |
+		      MCFGR_WDENABLE | MCFGR_LARGE_BURST |
 		      (sizeof(dma_addr_t) == sizeof(u64) ? MCFGR_LONG_PTR : 0));
 
 	/*
-- 
2.4.4
