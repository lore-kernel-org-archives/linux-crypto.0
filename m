From: LABBE Corentin <clabbe.montjoie@gmail.com>
Subject: [PATCH 2/5] hwrng: amd: use the BIT macro
Date: Fri, 19 Aug 2016 15:42:54 +0200
Message-ID: <1471614177-12380-2-git-send-email-clabbe.montjoie@gmail.com>
References: <1471614177-12380-1-git-send-email-clabbe.montjoie@gmail.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        LABBE Corentin <clabbe.montjoie@gmail.com>
To: herbert@gondor.apana.org.au, mpm@selenic.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:32803 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755478AbcHSN6o (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 19 Aug 2016 09:58:44 -0400
In-Reply-To: <1471614177-12380-1-git-send-email-clabbe.montjoie@gmail.com>
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
