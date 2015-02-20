From: Andre Wolokita <andre.wolokita@analog.com>
Subject: [PATCH v3] omap-rng: Change RNG_CONFIG_REG to RNG_CONTROL_REG when,
 checking and disabling TRNG
Date: Fri, 20 Feb 2015 15:37:21 +1100
Message-ID: <54E6BA01.7090904@analog.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: <linux-omap@vger.kernel.org>, <linux-crypto@vger.kernel.org>
To: <lokeshvutla@ti.com>, <dsaxena@plexity.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bn1bon0094.outbound.protection.outlook.com ([157.56.111.94]:18017
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753688AbbBTEw5 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 19 Feb 2015 23:52:57 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

In omap4_rng_init(), a check of bit 10 of the RNG_CONFIG_REG is done to determine
whether the RNG is running. This is suspicious firstly due to the use of
RNG_CONTROL_ENABLE_TRNG_MASK and secondly because the same mask is written to
RNG_CONTROL_REG after configuration of the FROs. Similar suspicious logic is
repeated in omap4_rng_cleanup() when RNG_CONTROL_REG masked with
RNG_CONTROL_ENABLE_TRNG_MASK is read, the same mask bit is cleared, and then
written to RNG_CONFIG_REG. Unless the TRNG is enabled with one bit in RNG_CONTROL
and disabled with another in RNG_CONFIG and these bits are mirrored in some way,
I believe that the TRNG is not really shutting off, leaving the FROs running
indefinitely which, in an extreme case, could lead to degredation of the
hardware and potentially reduce the level of entropy generated.

Apart from the strange logic, I have reason to suspect that the OMAP4 related
code in this driver is driving an Inside Secure IP hardware RNG and strongly
suspect that bit 10 of RNG_CONFIG_REG is one of the bits configuring the
sampling rate of the FROs. This option is by default set to 0 and is not being
set anywhere in omap-rng.c. Reading this bit during omap4_rng_init() will
always return 0. It will remain 0 because ~(value of TRNG_MASK in control) will
always be 0, because the TRNG is never shut off. This is of course presuming
that the OMAP4 features the Inside Secure IP, which I strongly suspect.

I'm interested in knowing what the guys at TI think about this, as only they
can confirm or deny the detailed structure of these registers.

Signed-off-by: Andre Wolokita <Andre.Wolokita@analog.com>
---
 drivers/char/hw_random/omap-rng.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/char/hw_random/omap-rng.c b/drivers/char/hw_random/omap-rng.c
index d14dcf7..67151cb 100644
--- a/drivers/char/hw_random/omap-rng.c
+++ b/drivers/char/hw_random/omap-rng.c
@@ -236,7 +236,7 @@ static int omap4_rng_init(struct omap_rng_dev *priv)
        u32 val;

        /* Return if RNG is already running. */
-       if (omap_rng_read(priv, RNG_CONFIG_REG) & RNG_CONTROL_ENABLE_TRNG_MASK)
+       if (omap_rng_read(priv, RNG_CONTROL_REG) & RNG_CONTROL_ENABLE_TRNG_MASK)
                return 0;

        val = RNG_CONFIG_MIN_REFIL_CYCLES << RNG_CONFIG_MIN_REFIL_CYCLES_SHIFT;
@@ -262,7 +262,7 @@ static void omap4_rng_cleanup(struct omap_rng_dev *priv)

        val = omap_rng_read(priv, RNG_CONTROL_REG);
        val &= ~RNG_CONTROL_ENABLE_TRNG_MASK;
-       omap_rng_write(priv, RNG_CONFIG_REG, val);
+       omap_rng_write(priv, RNG_CONTROL_REG, val);
 }

 static irqreturn_t omap4_rng_irq(int irq, void *dev_id)
-- 
1.7.9.5

-- 
Andre Wolokita (andre.wolokita@analog.com)
Design Engineer, Analog Devices Australia Pty Ltd
Unit 3, 97 Lewis Road, Wantirna, Victoria, 3152, AUSTRALIA
Direct: +61 3 9881 9933   Main: +61 3 9881 9999
Fax: +61 3 9881 9988      Web: www.analog.com/au

Embedded DSP software for multimedia & telecommunications.

This communication is proprietary and confidential. 
