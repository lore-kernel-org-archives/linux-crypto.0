From: Florian Fainelli <f.fainelli@gmail.com>
Subject: [PATCH 0/2] hwrng: iproc-rng200: Add support for BCM7278
Date: Wed,  1 Nov 2017 16:20:04 -0700
Message-ID: <20171101232006.3943-1-f.fainelli@gmail.com>
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
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi,

This patch series adds support for the RNG200 block found on the BCM7278 SoC.
This requires us to update the compatible string (and associated binding
document) as well as the Kconfig option to make that driver selectable with
ARCH_BRCMSTB gating the enabling of such SoCs.

Thank you

Florian Fainelli (2):
  dt-bindings: rng: Document BCM7278 RNG200 compatible
  hwrng: iproc-rng200: Add support for BCM7278

 Documentation/devicetree/bindings/rng/brcm,iproc-rng200.txt | 4 +++-
 drivers/char/hw_random/Kconfig                              | 6 +++---
 drivers/char/hw_random/iproc-rng200.c                       | 1 +
 3 files changed, 7 insertions(+), 4 deletions(-)

-- 
2.9.3
