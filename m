From: Stefan Wahren <stefan.wahren@i2se.com>
Subject: Re: [PATCH 00/12] bcm63xx-rng conversion to bcm2835-rng
Date: Thu, 2 Nov 2017 20:01:00 +0100 (CET)
Message-ID: <1329593033.127526.1509649260041@email.1und1.de>
References: <20171102010408.27736-1-f.fainelli@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Mark Rutland <mark.rutland@arm.com>,
 "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS"
 <devicetree@vger.kernel.org>, Sean Wang <sean.wang@mediatek.com>,
 Martin Kaiser <martin@kaiser.cx>, Herbert Xu <herbert@gondor.apana.org.au>,
 Scott Branden <sbranden@broadcom.com>, Ray Jui <rjui@broadcom.com>,
 Matt Mackall <mpm@selenic.com>, Russell King <rmk+kernel@armlinux.org.uk>,
 Krzysztof Kozlowski <krzk@kernel.org>, linux-kernel@vger.kernel.org,
 Eric Anholt <eric@anholt.net>,
 Harald Freudenberger <freude@linux.vnet.ibm.com>,
 Rob Herring <robh+dt@kernel.org>,
 "maintainer:BROADCOM BCM281XX/BCM11XXX/BCM216XX ARM ARCHITE..."
 <bcm-kernel-feedback-list@broadcom.com>,
 "open list:HARDWARE RANDOM NUMBER GENERATOR CORE"
 <linux-crypto@vger.kernel.org>,
 PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>,
 Steffen Trumtrar <s.trumtrar@pengutronix.de>,
 "moderated list:BROADCO
To: Florian Fainelli <f.fainelli@gmail.com>
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <20171102010408.27736-1-f.fainelli@gmail.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
List-Id: linux-crypto.vger.kernel.org

Hi Florian,

> Florian Fainelli <f.fainelli@gmail.com> hat am 2. November 2017 um 02:03 geschrieben:
> 
> 
> Hi,
> 
> As it usually happens when there is a fair amount of HW IP block re-use,
> competing implementations show up. In that case the BCM2835 HWRNG driver and
> the BCM63xx RNG driver have exactly the same register offsets and this is
> indeed the same piece of HW.
> 
> This patch series first prepares the bcm2835-rng to be more future proof and
> support newer platforms, and the last part brings in what is necessary to
> migrate the bcm63xx-rng over to bcm2835-rng. Finally we delete bcm63xx-rng
> completely.
> 
> The reason why BCM2835 RNG was kept over BCM63xx RNG is because the former
> deals correctly with a warm up count and the number of words available in the
> FIFO size.

are these the same patches as in this branch [1]?

https://github.com/ffainelli/linux/commits/rng-consolidation

Regards
Stefan

> 
> Thanks!
> 
> Florian Fainelli (12):
>   hwrng: bcm2835-rng: Obtain base register via resource
>   hwrng: bcm2835-rng: Define a driver private context
>   hwrng: bcm2835-rng: Move enabling to hwrng::init
>   hwrng: bcm2835-rng: Implementation cleanup callback
>   hwrng: bcm2835-rng: Use device managed helpers
>   hwrng: bcm2835-rng: Rework interrupt masking
>   hwrng: bcm2835-rng: Manage an optional clock
>   hwrng: bcm2835-rng: Abstract I/O accessors
>   hwrng: bcm2835-rng: Add Broadcom MIPS I/O accessors
>   dt-bindings: rng: Incorporate brcm,bcm6368.txt binding
>   hwrng: bcm2835-rng: Enable BCM2835 RNG to work on BCM63xx platforms
>   hwrng: bcm63xx-rng: Remove since bcm2835-rng takes over
> 
>  .../devicetree/bindings/rng/brcm,bcm2835.txt       |  22 ++-
>  .../devicetree/bindings/rng/brcm,bcm6368.txt       |  17 ---
>  drivers/char/hw_random/Kconfig                     |  20 +--
>  drivers/char/hw_random/Makefile                    |   1 -
>  drivers/char/hw_random/bcm2835-rng.c               | 166 ++++++++++++++-------
>  drivers/char/hw_random/bcm63xx-rng.c               | 154 -------------------
>  6 files changed, 139 insertions(+), 241 deletions(-)
>  delete mode 100644 Documentation/devicetree/bindings/rng/brcm,bcm6368.txt
>  delete mode 100644 drivers/char/hw_random/bcm63xx-rng.c
> 
> -- 
> 2.9.3
> 
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
