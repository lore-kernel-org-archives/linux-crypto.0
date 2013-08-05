From: Lokesh Vutla <lokeshvutla@ti.com>
Subject: [PATCH 0/6] hwrng: OMAP: Updates for OMAP RNG module
Date: Mon, 5 Aug 2013 20:17:17 +0530
Message-ID: <1375714043-23407-1-git-send-email-lokeshvutla@ti.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: dsaxena@plexity.net, Lokesh Vutla <lokeshvutla@ti.com>,
 herbert@gondor.hengli.com.au, linux-crypto@vger.kernel.org, mpm@selenic.com,
 linux-arm-kernel@lists.infradead.org
To: <linux-omap@vger.kernel.org>
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
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

This patch series adds support for OMAP4 version of RNG module.
This module produce a 64 bit random number and also allows to
de tune FROs when repeated pattern is coming out of FROs.
This series also has few fixes for the driver.

Lokesh Vutla (6):
  hwrng: OMAP: Use module_platform_driver macro
  hwrng: OMAP: Convert to devm_kzalloc()
  hwrng: OMAP: Remove duplicated function call
  hwrng: OMAP: Add device tree support
  ARM: OMAP2+: Only manually add hwmod data when DT not used.
  hwrng: OMAP: Add OMAP4 TRNG support

 arch/arm/mach-omap2/devices.c     |    2 +-
 drivers/char/hw_random/Kconfig    |    6 +-
 drivers/char/hw_random/omap-rng.c |  386 ++++++++++++++++++++++++++++++-------
 3 files changed, 319 insertions(+), 75 deletions(-)

-- 
1.7.9.5
