From: Florian Fainelli <f.fainelli@gmail.com>
Subject: [PATCH 2/3] hw_random: bcm2835: Add support for Broadcom BCM5301x
Date: Wed, 22 Jun 2016 17:27:02 -0700
Message-ID: <1466641623-3491-3-git-send-email-f.fainelli@gmail.com>
References: <1466641623-3491-1-git-send-email-f.fainelli@gmail.com>
Cc: yendapally.reddy@broadcom.com, herbert@gondor.apana.org.au,
	eric@anholt.net, bcm-kernel-feedback-list@broadcom.com,
	devicetre@vger.kernel.org, hauke@hauke-m.de, zajec5@gmail.com,
	mpm@selenic.com, linux-arm-kernel@lists.infradead.org,
	Florian Fainelli <f.fainelli@gmail.com>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:34221 "EHLO
	mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750787AbcFWA1P (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 22 Jun 2016 20:27:15 -0400
In-Reply-To: <1466641623-3491-1-git-send-email-f.fainelli@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The Broadcom BCM5301x SoCs (Northstar) utilize the same random number
generator peripheral as Northstar Plus and BCM2835, but just like the
NSP SoC, we need to enable the interrupt.

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/char/hw_random/Kconfig       | 2 +-
 drivers/char/hw_random/bcm2835-rng.c | 1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/char/hw_random/Kconfig b/drivers/char/hw_random/Kconfig
index 51401100466b..56ad5a5936a9 100644
--- a/drivers/char/hw_random/Kconfig
+++ b/drivers/char/hw_random/Kconfig
@@ -90,7 +90,7 @@ config HW_RANDOM_BCM63XX
 
 config HW_RANDOM_BCM2835
 	tristate "Broadcom BCM2835 Random Number Generator support"
-	depends on ARCH_BCM2835 || ARCH_BCM_NSP
+	depends on ARCH_BCM2835 || ARCH_BCM_NSP || ARCH_BCM_5301X
 	default HW_RANDOM
 	---help---
 	  This driver provides kernel-side support for the Random Number
diff --git a/drivers/char/hw_random/bcm2835-rng.c b/drivers/char/hw_random/bcm2835-rng.c
index 75ca820730be..af2149273fe0 100644
--- a/drivers/char/hw_random/bcm2835-rng.c
+++ b/drivers/char/hw_random/bcm2835-rng.c
@@ -70,6 +70,7 @@ static struct hwrng bcm2835_rng_ops = {
 static const struct of_device_id bcm2835_rng_of_match[] = {
 	{ .compatible = "brcm,bcm2835-rng"},
 	{ .compatible = "brcm,bcm-nsp-rng", .data = nsp_rng_init},
+	{ .compatible = "brcm,bcm5301x-rng", .data = nsp_rng_init},
 	{},
 };
 
-- 
2.7.4
