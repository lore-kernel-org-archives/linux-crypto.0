From: Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: [PATCH 0/8] ARM: mvebu: Add support for RAID6 PQ offloading
Date: Tue, 12 May 2015 17:37:35 +0200
Message-ID: <1431445063-20226-1-git-send-email-maxime.ripard@free-electrons.com>
Cc: dmaengine@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	Lior Amsalem <alior@marvell.com>,
	Thomas Petazzoni <thomas@free-electrons.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Maxime Ripard <maxime.ripard@free-electrons.com>
To: Vinod Koul <vinod.koul@intel.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Gregory Clement <gregory.clement@free-electrons.com>,
	Jason Cooper <jason@lakedaemon.net>,
	Andrew Lunn <andrew@lunn.ch>,
	Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi,

This serie refactors the mv_xor in order to support the latest Armada
38x features, including the PQ support in order to offload the RAID6
PQ operations.

Not all the PQ operations are supported by the XOR engine, so we had
to introduce new async_tx flags in the process to identify
un-supported operations.

Please note that this is currently not usable because of a possible
regression in the RAID stack in 4.1 that is being discussed at the
moment here: https://lkml.org/lkml/2015/5/7/527

Let me know what you think,
Maxime

Lior Amsalem (7):
  dmaengine: mv_xor: add support for a38x command in descriptor mode
  dmaengine: mv_xor: Enlarge descriptor pool size
  dmaengine: mv_xor: improve descriptors list handling and reduce
    locking
  dmaengine: mv_xor: bug fix for racing condition in descriptors cleanup
  async_tx: adding mult and sum_product flags
  dmaengine: mv_xor: add support for a38x RAID6 support
  ARM: mvebu: a38x: Enable A38x XOR engine features

Maxime Ripard (1):
  dmaengine: mv_xor: Rename function for consistent naming

 Documentation/devicetree/bindings/dma/mv-xor.txt |   2 +-
 arch/arm/boot/dts/armada-38x.dtsi                |  20 +-
 crypto/async_tx/async_raid6_recov.c              |   4 +-
 drivers/dma/mv_xor.c                             | 459 +++++++++++++++--------
 drivers/dma/mv_xor.h                             |  32 +-
 include/linux/dmaengine.h                        |   4 +
 6 files changed, 326 insertions(+), 195 deletions(-)

-- 
2.4.0
