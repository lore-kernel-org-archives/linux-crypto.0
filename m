From: Florian Fainelli <f.fainelli@gmail.com>
Subject: [PATCH 0/4] hw_random: bcm63xx-rng: misc cleanups and reorg
Date: Mon, 16 Feb 2015 18:09:12 -0800
Message-ID: <1424138956-11563-1-git-send-email-f.fainelli@gmail.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        mpm@selenic.com, herbert@gondor.apana.org.au, wsa@the-dreams.de,
        cernekee@gmail.com, Florian Fainelli <f.fainelli@gmail.com>
To: linux-mips@linux-mips.org
Return-path: <linux-mips-bounce@linux-mips.org>
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

Hi,

This patchset prepares the driver to be built on non-MIPS bcm63xx architectures
such as the ARM bcm63xx variants, thanks!

Although patch 3 touches a MIPS header file, there should be little to no
conflicts there if all patches went through the hw_random tree (is there one?)

Thanks!

Florian Fainelli (4):
  hw_random: bcm63xx-rng: drop bcm_{readl,writel} macros
  hw_random: bcm63xx-rng: move register definitions to driver
  MIPS: BCM63xx: remove RSET_RNG register definitions
  hw_random: bcm63xx-rng: use devm_* helpers

 arch/mips/include/asm/mach-bcm63xx/bcm63xx_regs.h | 14 --------
 drivers/char/hw_random/bcm63xx-rng.c              | 43 +++++++++++------------
 2 files changed, 21 insertions(+), 36 deletions(-)

-- 
2.1.0
