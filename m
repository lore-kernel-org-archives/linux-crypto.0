From: Florian Fainelli <f.fainelli@gmail.com>
Subject: [PATCH 3/4] MIPS: BCM63xx: remove RSET_RNG register definitions
Date: Mon, 16 Feb 2015 18:09:15 -0800
Message-ID: <1424138956-11563-4-git-send-email-f.fainelli@gmail.com>
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

Now that these definitions have been moved to
drivers/char/hw_random/bcm63xx-rng.c where they belong to make the
driver standalone, we can safely remove these definitions from
bcm63xx_regs.h.

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 arch/mips/include/asm/mach-bcm63xx/bcm63xx_regs.h | 14 --------------
 1 file changed, 14 deletions(-)

diff --git a/arch/mips/include/asm/mach-bcm63xx/bcm63xx_regs.h b/arch/mips/include/asm/mach-bcm63xx/bcm63xx_regs.h
index 4794067cb5a7..5035f09c5427 100644
--- a/arch/mips/include/asm/mach-bcm63xx/bcm63xx_regs.h
+++ b/arch/mips/include/asm/mach-bcm63xx/bcm63xx_regs.h
@@ -1259,20 +1259,6 @@
 #define M2M_DSTID_REG(x)		((x) * 0x40 + 0x18)
 
 /*************************************************************************
- * _REG relative to RSET_RNG
- *************************************************************************/
-
-#define RNG_CTRL			0x00
-#define RNG_EN				(1 << 0)
-
-#define RNG_STAT			0x04
-#define RNG_AVAIL_MASK			(0xff000000)
-
-#define RNG_DATA			0x08
-#define RNG_THRES			0x0c
-#define RNG_MASK			0x10
-
-/*************************************************************************
  * _REG relative to RSET_SPI
  *************************************************************************/
 
-- 
2.1.0
