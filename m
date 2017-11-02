From: Florian Fainelli <f.fainelli@gmail.com>
Subject: [PATCH 09/12] hwrng: bcm2835-rng: Add Broadcom MIPS I/O accessors
Date: Wed,  1 Nov 2017 18:04:05 -0700
Message-ID: <20171102010408.27736-10-f.fainelli@gmail.com>
References: <20171102010408.27736-1-f.fainelli@gmail.com>
Cc: Florian Fainelli <f.fainelli@gmail.com>,
        Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Ray Jui <rjui@broadcom.com>,
        Scott Branden <sbranden@broadcom.com>,
        bcm-kernel-feedback-list@broadcom.com (maintainer:BROADCOM
        BCM281XX/BCM11XXX/BCM216XX ARM ARCHITE...),
        Eric Anholt <eric@anholt.net>,
        Stefan Wahren <stefan.wahren@i2se.com>,
        PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Harald Freudenberger <freude@linux.vnet.ibm.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Martin Kaiser <martin@kaiser.cx>,
        Steffen Trumtrar <s.trumtrar@pengutronix.de>,
        linux-crypto@vger.k
To: linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171102010408.27736-1-f.fainelli@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Broadcom MIPS HW is always strapped to match the system-wide endian such
that all I/O access to this RNG block is done with the native CPU
endian, account for that.

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/char/hw_random/bcm2835-rng.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/char/hw_random/bcm2835-rng.c b/drivers/char/hw_random/bcm2835-rng.c
index 500275d55044..650e0033c273 100644
--- a/drivers/char/hw_random/bcm2835-rng.c
+++ b/drivers/char/hw_random/bcm2835-rng.c
@@ -44,13 +44,22 @@ static inline struct bcm2835_rng_priv *to_rng_priv(struct hwrng *rng)
 
 static inline u32 rng_readl(struct bcm2835_rng_priv *priv, u32 offset)
 {
-	return readl(priv->base + offset);
+	/* MIPS chips strapped for BE will automagically configure the
+	 * peripheral registers for CPU-native byte order.
+	 */
+	if (IS_ENABLED(CONFIG_MIPS) && IS_ENABLED(CONFIG_CPU_BIG_ENDIAN))
+		return __raw_readl(priv->base + offset);
+	else
+		return readl(priv->base + offset);
 }
 
 static inline void rng_writel(struct bcm2835_rng_priv *priv, u32 val,
 			      u32 offset)
 {
-	writel(val, priv->base + offset);
+	if (IS_ENABLED(CONFIG_MIPS) && IS_ENABLED(CONFIG_CPU_BIG_ENDIAN))
+		__raw_writel(val, priv->base + offset);
+	else
+		writel(val, priv->base + offset);
 }
 
 static int bcm2835_rng_read(struct hwrng *rng, void *buf, size_t max,
-- 
2.9.3
