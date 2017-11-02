From: Florian Fainelli <f.fainelli-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 00/12] bcm63xx-rng conversion to bcm2835-rng
Date: Wed,  1 Nov 2017 18:03:56 -0700
Message-ID: <20171102010408.27736-1-f.fainelli@gmail.com>
Cc: Florian Fainelli <f.fainelli-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
        Matt Mackall <mpm-VDJrAJ4Gl5ZBDgjK7y7TUQ@public.gmane.org>,
        Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>,
        Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>,
        Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>,
        Ray Jui <rjui-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>,
        Scott Branden <sbranden-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>,
        bcm-kernel-feedback-list-dY08KVG/lbpWk0Htik3J/w@public.gmane.org (maintainer:BROADCOM
        BCM281XX/BCM11XXX/BCM216XX ARM ARCHITE...),
        Eric Anholt <eric-WhKQ6XTQaPysTnJN9+BGXg@public.gmane.org>,
        Stefan Wahren <stefan.wahren-eS4NqCHxEME@public.gmane.org>,
        PrasannaKumar Muralidharan <prasannatsmkumar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
        Russell King <rmk+kernel-I+IVW8TIWO2tmTQ+vhA3Yw@public.gmane.org>,
        Krzysztof Kozlowski <krzk-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>,
        Harald Freudenberger <freude-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>,
        Sean Wang <sean.wang-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org>,
        Martin Kaiser <martin-XxZfDwE/svGeZLLa646FqQ@public.gmane.org>,
        Steffen Trumtrar <s.trumtrar-bIcnvbaLZ9MEGnE8C9+IrQ@public.gmane.org>,
        linux-crypto@vger.k
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

Hi,

As it usually happens when there is a fair amount of HW IP block re-use,
competing implementations show up. In that case the BCM2835 HWRNG driver and
the BCM63xx RNG driver have exactly the same register offsets and this is
indeed the same piece of HW.

This patch series first prepares the bcm2835-rng to be more future proof and
support newer platforms, and the last part brings in what is necessary to
migrate the bcm63xx-rng over to bcm2835-rng. Finally we delete bcm63xx-rng
completely.

The reason why BCM2835 RNG was kept over BCM63xx RNG is because the former
deals correctly with a warm up count and the number of words available in the
FIFO size.

Thanks!

Florian Fainelli (12):
  hwrng: bcm2835-rng: Obtain base register via resource
  hwrng: bcm2835-rng: Define a driver private context
  hwrng: bcm2835-rng: Move enabling to hwrng::init
  hwrng: bcm2835-rng: Implementation cleanup callback
  hwrng: bcm2835-rng: Use device managed helpers
  hwrng: bcm2835-rng: Rework interrupt masking
  hwrng: bcm2835-rng: Manage an optional clock
  hwrng: bcm2835-rng: Abstract I/O accessors
  hwrng: bcm2835-rng: Add Broadcom MIPS I/O accessors
  dt-bindings: rng: Incorporate brcm,bcm6368.txt binding
  hwrng: bcm2835-rng: Enable BCM2835 RNG to work on BCM63xx platforms
  hwrng: bcm63xx-rng: Remove since bcm2835-rng takes over

 .../devicetree/bindings/rng/brcm,bcm2835.txt       |  22 ++-
 .../devicetree/bindings/rng/brcm,bcm6368.txt       |  17 ---
 drivers/char/hw_random/Kconfig                     |  20 +--
 drivers/char/hw_random/Makefile                    |   1 -
 drivers/char/hw_random/bcm2835-rng.c               | 166 ++++++++++++++-------
 drivers/char/hw_random/bcm63xx-rng.c               | 154 -------------------
 6 files changed, 139 insertions(+), 241 deletions(-)
 delete mode 100644 Documentation/devicetree/bindings/rng/brcm,bcm6368.txt
 delete mode 100644 drivers/char/hw_random/bcm63xx-rng.c

-- 
2.9.3

--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
