From: Horia Geanta <horia.geanta@freescale.com>
Subject: [PATCH] crypto: caam - fix DECO RSR polling
Date: Mon, 21 Jul 2014 16:03:21 +0300
Message-ID: <1405947801-3318-1-git-send-email-horia.geanta@freescale.com>
References: <53CCC5A5.1070004@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: "David S. Miller" <davem@davemloft.net>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	<linux-crypto@vger.kernel.org>,
	Ruchika Gupta <ruchika.gupta@freescale.com>,
	Kim Phillips <kim.phillips@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bn1lp0145.outbound.protection.outlook.com ([207.46.163.145]:1034
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755209AbaGUNEh (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 21 Jul 2014 09:04:37 -0400
In-Reply-To: <53CCC5A5.1070004@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

RSR (Request Source Register) is not used when
virtualization is disabled, thus don't poll for Valid bit.

Besides this, if used, timeout has to be reinitialized.

Signed-off-by: Horia Geanta <horia.geanta@freescale.com>
---
Only compile-tested.
Ruchika / Kim, please review / test.

 drivers/crypto/caam/ctrl.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/caam/ctrl.c b/drivers/crypto/caam/ctrl.c
index c6e9d3b2d502..84d4b95c761e 100644
--- a/drivers/crypto/caam/ctrl.c
+++ b/drivers/crypto/caam/ctrl.c
@@ -89,12 +89,15 @@ static inline int run_descriptor_deco0(struct device *ctrldev, u32 *desc,
 	/* Set the bit to request direct access to DECO0 */
 	topregs = (struct caam_full __iomem *)ctrlpriv->ctrl;
 
-	if (ctrlpriv->virt_en == 1)
+	if (ctrlpriv->virt_en == 1) {
 		setbits32(&topregs->ctrl.deco_rsr, DECORSR_JR0);
 
-	while (!(rd_reg32(&topregs->ctrl.deco_rsr) & DECORSR_VALID) &&
-	       --timeout)
-		cpu_relax();
+		while (!(rd_reg32(&topregs->ctrl.deco_rsr) & DECORSR_VALID) &&
+		       --timeout)
+			cpu_relax();
+
+		timeout = 100000;
+	}
 
 	setbits32(&topregs->ctrl.deco_rq, DECORR_RQD0ENABLE);
 
-- 
1.8.3.1
