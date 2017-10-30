From: =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>
Subject: [PATCH RESEND 0/4] add CAAM DMA memcpy driver
Date: Mon, 30 Oct 2017 15:46:50 +0200
Message-ID: <20171030134654.13729-1-horia.geanta@nxp.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <dmaengine@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
        <devicetree@vger.kernel.org>
To: Vinod Koul <vinod.koul@intel.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Dan Douglass <dan.douglass@nxp.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Radu Alexe <radu.alexe@nxp.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-sn1nam01on0089.outbound.protection.outlook.com ([104.47.32.89]:12513
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751969AbdJ3NrI (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 30 Oct 2017 09:47:08 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Radu Alexe <radu.alexe@nxp.com>

This patch-set introduces a new DMA memcpy driver based on the DMA
capabilities of the CAAM crypto engine. Because of this dependency the
included commits target various parts of the kernel tree.

Patch 1.
Since the CAAM DMA driver is a platform driver it is enabled by a new node
in the device tree. This commit adds documentation for the device tree
bindings.

Patch 2.
This patch adds the "caam-dma" node in the fsl-ls1012a.dtsi file.

Patch 3.
This commit adds various capabilities in the JR driver of the CAAM that is
used by the CAAM DMA driver.

Patch 4.
Adds the CAAM DMA memcpy driver.

Patch 1 and 3 should be ack-ed by the crypto maintainers, patch 2 by
devicetree maintainers and patch 4 by the DMA maintainers.
The intent is to go withh all the patches through the dmaengine tree.

Radu Alexe (4):
  crypto: caam: add caam-dma node to SEC4.0 device tree binding
  arm64: dts: ls1012a: add caam-dma node
  crypto: caam: add functionality used by the caam_dma driver
  dma: caam: add dma memcpy driver

 .../devicetree/bindings/crypto/fsl-sec4.txt        |  21 +
 arch/arm64/boot/dts/freescale/fsl-ls1012a.dtsi     |   6 +
 drivers/crypto/caam/desc.h                         |   3 +
 drivers/crypto/caam/jr.c                           |  42 ++
 drivers/crypto/caam/jr.h                           |   2 +
 drivers/dma/Kconfig                                |  17 +
 drivers/dma/Makefile                               |   1 +
 drivers/dma/caam_dma.c                             | 444 +++++++++++++++++++++
 8 files changed, 536 insertions(+)
 create mode 100644 drivers/dma/caam_dma.c

-- 
2.14.2.606.g7451fcd
