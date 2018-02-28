From: Gregory CLEMENT <gregory.clement@bootlin.com>
Subject: [PATCH 0/2] hwrng: omap: Fix clock resource for Armada 7K/8K
Date: Wed, 28 Feb 2018 15:27:21 +0100
Message-ID: <20180228142723.11562-1-gregory.clement@bootlin.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Andrew Lunn <andrew@lunn.ch>, Jason Cooper <jason@lakedaemon.net>,
 Antoine Tenart <antoine.tenart@bootlin.com>,
 Gregory CLEMENT <gregory.clement@bootlin.com>, Omri Itach <omrii@marvell.com>,
 Nadav Haklai <nadavh@marvell.com>, Shadi Ammouri <shadi@marvell.com>,
 Igal Liberman <igall@marvell.com>,
 Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
 =?UTF-8?q?Miqu=C3=A8l=20Raynal?= <miquel.raynal@bootlin.com>,
 Marcin Wojtas <mw@semihalf.com>, Hanna Hawa <hannah@marvell.com>,
 linux-arm-kernel@lists.infradead.org,
 Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
 Deepak Saxena <dsaxena@plexity.net>, linux-crypto@vger.kernel.org
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

Hi,

This short series fixes the way the clocks are used for the SafeXcel
IP-76 controller embedded in the Marvell Armada 7K/8K SoCs. On these
SoCs a second one is needed in order to clock the registers. It was
not noticed until now because we relied on the bootloader and also
because the clock driver was wrong.

Thanks to this fix, it would be possible to fix the clock driver
without introducing a regression.

The first patch is just a small cleanup found when I wrote the main
patch.

Gregory CLEMENT (2):
  hwrng: omap - Remove useless test before clk_disable_unprepare
  hwrng: omap - Fix clock resource by adding a register clock

 Documentation/devicetree/bindings/rng/omap_rng.txt |  7 ++++++-
 drivers/char/hw_random/omap-rng.c                  | 22 ++++++++++++++++++----
 2 files changed, 24 insertions(+), 5 deletions(-)

-- 
2.16.1
