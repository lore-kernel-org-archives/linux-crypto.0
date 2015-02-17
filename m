From: Florian Fainelli <f.fainelli@gmail.com>
Subject: [PATCH 2/4] hw_random: bcm63xx-rng: move register definitions to driver
Date: Mon, 16 Feb 2015 18:09:14 -0800
Message-ID: <1424138956-11563-3-git-send-email-f.fainelli@gmail.com>
References: <1424138956-11563-1-git-send-email-f.fainelli@gmail.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        mpm@selenic.com, herbert@gondor.apana.org.au, wsa@the-dreams.de,
        cernekee@gmail.com, Florian Fainelli <f.fainelli@gmail.com>
To: linux-mips@linux-mips.org
Return-path: <linux-mips-bounce@linux-mips.org>
In-Reply-To: <1424138956-11563-1-git-send-email-f.fainelli@gmail.com>
Sender: linux-mips-bounce@linux-mips.org
Errors-to: linux-mips-bounce@linux-mips.org
List-help: <mailto:ecartis@linux-mips.org?Subject=help>
List-unsubscribe: <mailto:ecartis@linux-mips.org?subject=unsubscribe%20linux-mips>
List-software: Ecartis version 1.0.0
List-subscribe: <mailto:ecartis@linux-mips.org?subject=subscribe%20linux-mips>
List-owner: <mailto:ralf@linux-mips.org>
List-post: <mailto:linux-mips@linux-mips.org>
List-archive: <http://www.linux-mips.org/archives/linux-mips/>
List-Id: linux-crypto.vger.kernel.org

arch/mips/include/asm/mach-bcm63xx/bcm63xx_regs.h contains the register
definitions for this random number generator block, incorporate these
register definitions directly into the bcm63xx-rng driver so we do not
rely on this header to be provided.

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/char/hw_random/bcm63xx-rng.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/char/hw_random/bcm63xx-rng.c b/drivers/char/hw_random/bcm63xx-rng.c
index ed9b28b35a39..c7f3af852599 100644
--- a/drivers/char/hw_random/bcm63xx-rng.c
+++ b/drivers/char/hw_random/bcm63xx-rng.c
@@ -13,7 +13,15 @@
 #include <linux/platform_device.h>
 #include <linux/hw_random.h>
 
-#include <bcm63xx_regs.h>
+#define RNG_CTRL			0x00
+#define RNG_EN				(1 << 0)
+
+#define RNG_STAT			0x04
+#define RNG_AVAIL_MASK			(0xff000000)
+
+#define RNG_DATA			0x08
+#define RNG_THRES			0x0c
+#define RNG_MASK			0x10
 
 struct bcm63xx_rng_priv {
 	struct clk *clk;
-- 
2.1.0
