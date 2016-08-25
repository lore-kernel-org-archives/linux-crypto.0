From: LABBE Corentin <clabbe.montjoie@gmail.com>
Subject: [PATCH v2 2/5] hwrng: amd: use the BIT macro
Date: Thu, 25 Aug 2016 14:16:32 +0200
Message-ID: <1472127395-32195-3-git-send-email-clabbe.montjoie@gmail.com>
References: <1472127395-32195-1-git-send-email-clabbe.montjoie@gmail.com>
Cc: linux-kernel@vger.kernel.org,
        LABBE Corentin <clabbe.montjoie@gmail.com>
To: mpm@selenic.com, herbert@gondor.apana.org.au,
        linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:36457 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933831AbcHYMRJ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 25 Aug 2016 08:17:09 -0400
In-Reply-To: <1472127395-32195-1-git-send-email-clabbe.montjoie@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch add usage of the BIT() macro

Signed-off-by: LABBE Corentin <clabbe.montjoie@gmail.com>
---
 drivers/char/hw_random/amd-rng.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/char/hw_random/amd-rng.c b/drivers/char/hw_random/amd-rng.c
index 45b7965..d0042f5 100644
--- a/drivers/char/hw_random/amd-rng.c
+++ b/drivers/char/hw_random/amd-rng.c
@@ -78,11 +78,11 @@ static int amd_rng_init(struct hwrng *rng)
 	u8 rnen;
 
 	pci_read_config_byte(amd_pdev, 0x40, &rnen);
-	rnen |= (1 << 7);	/* RNG on */
+	rnen |= BIT(7);	/* RNG on */
 	pci_write_config_byte(amd_pdev, 0x40, rnen);
 
 	pci_read_config_byte(amd_pdev, 0x41, &rnen);
-	rnen |= (1 << 7);	/* PMIO enable */
+	rnen |= BIT(7);	/* PMIO enable */
 	pci_write_config_byte(amd_pdev, 0x41, rnen);
 
 	return 0;
@@ -93,7 +93,7 @@ static void amd_rng_cleanup(struct hwrng *rng)
 	u8 rnen;
 
 	pci_read_config_byte(amd_pdev, 0x40, &rnen);
-	rnen &= ~(1 << 7);	/* RNG off */
+	rnen &= ~BIT(7);	/* RNG off */
 	pci_write_config_byte(amd_pdev, 0x40, rnen);
 }
 
-- 
2.7.3
