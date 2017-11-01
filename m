From: Florian Fainelli <f.fainelli@gmail.com>
Subject: [PATCH 2/2] hwrng: iproc-rng200: Add support for BCM7278
Date: Wed,  1 Nov 2017 16:20:06 -0700
Message-ID: <20171101232006.3943-3-f.fainelli@gmail.com>
References: <20171101232006.3943-1-f.fainelli@gmail.com>
Cc: Florian Fainelli <f.fainelli@gmail.com>,
        Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Ray Jui <rjui@broadcom.com>,
        Scott Branden <sbranden@broadcom.com>,
        Jon Mason <jonmason@broadcom.com>,
        bcm-kernel-feedback-list@broadcom.com (maintainer:BROADCOM IPROC ARM
        ARCHITECTURE),
        PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Harald Freudenberger <freude@linux.vnet.ibm.com>,
        Martin Kaiser <martin@kaiser.cx>,
        linux-crypto@vger.kernel.org (open list:HARDWARE RANDOM NUMBER
        GENERATOR CORE),
        devicetree@vger.kernel.org (open list:OP
To: linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171101232006.3943-1-f.fainelli@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

BCM7278 features a RNG200 hardware random number generator block, add
support for this chip by matching the chip-specific compatible string
and extending the Kconfig dependencies to allow building on ARCH_BRCMSTB
(base platform for 7278).

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/char/hw_random/Kconfig        | 6 +++---
 drivers/char/hw_random/iproc-rng200.c | 1 +
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/char/hw_random/Kconfig b/drivers/char/hw_random/Kconfig
index 95a031e9eced..f6e3e5abc117 100644
--- a/drivers/char/hw_random/Kconfig
+++ b/drivers/char/hw_random/Kconfig
@@ -100,12 +100,12 @@ config HW_RANDOM_BCM2835
 	  If unsure, say Y.
 
 config HW_RANDOM_IPROC_RNG200
-	tristate "Broadcom iProc RNG200 support"
-	depends on ARCH_BCM_IPROC
+	tristate "Broadcom iProc/STB RNG200 support"
+	depends on ARCH_BCM_IPROC || ARCH_BRCMSTB
 	default HW_RANDOM
 	---help---
 	  This driver provides kernel-side support for the RNG200
-	  hardware found on the Broadcom iProc SoCs.
+	  hardware found on the Broadcom iProc and STB SoCs.
 
 	  To compile this driver as a module, choose M here: the
 	  module will be called iproc-rng200
diff --git a/drivers/char/hw_random/iproc-rng200.c b/drivers/char/hw_random/iproc-rng200.c
index 3eaf7cb96d36..8b5a20b35293 100644
--- a/drivers/char/hw_random/iproc-rng200.c
+++ b/drivers/char/hw_random/iproc-rng200.c
@@ -220,6 +220,7 @@ static int iproc_rng200_probe(struct platform_device *pdev)
 }
 
 static const struct of_device_id iproc_rng200_of_match[] = {
+	{ .compatible = "brcm,bcm7278-rng200", },
 	{ .compatible = "brcm,iproc-rng200", },
 	{},
 };
-- 
2.9.3
