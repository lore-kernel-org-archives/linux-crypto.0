From: Qiang Liu <qiang.liu@freescale.com>
Subject: [PATCH v3 0/4] Raid: enable talitos xor offload for improving performance
Date: Mon, 16 Jul 2012 12:07:16 +0800
Message-ID: <1342411636-29770-1-git-send-email-qiang.liu@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <leoli@freescale.com>, <kim.phillips@freescale.com>,
	<dan.j.williams@intel.com>, <herbert@gondor.hengli.com.au>,
	<qiang.liu@freescale.com>
To: <linux-crypto@vger.kernel.org>, <linuxppc-dev@lists.ozlabs.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from va3ehsobe004.messaging.microsoft.com ([216.32.180.14]:14043
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750823Ab2GPE2z (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 16 Jul 2012 00:28:55 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The following 4 patches enabling fsl-dma and talitos offload raid
operations for improving raid performance and balancing CPU load.

Write performance will be improved by 25-30% tested by iozone.
Write performance is improved about 2% after using spin_lock_bh replace
spin_lock_irqsave.
CPU load will be reduced by 8%.

Changes in v3:
	- change release process of fsl-dma descriptor for resolve the
	potential race condition
	- add test result when use spin_lock_bh replace spin_lock_irqsave
	- modify the benchmark results according to the latest patch

Changes in v2:
	- rebase onto cryptodev tree
	- split the patch 3/4 up to 3 independent patches
	- remove the patch 4/4, the fix is not for cryptodev tree


Qiang Liu (4):
      Talitos: Support for async_tx XOR offload
      fsl-dma: remove attribute DMA_INTERRUPT of dmaengine
      fsl-dma: change release process of dma descriptor for supporting async_tx
      fsl-dma: use spin_lock_bh to instead of spin_lock_irqsave

 drivers/crypto/Kconfig   |    9 +
 drivers/crypto/talitos.c |  410 +++++++++++++++++++++++++++++++++++++++++++
 drivers/crypto/talitos.h |   53 ++++++
 drivers/dma/fsldma.c     |  436 +++++++++++++++++++++++++---------------------
 drivers/dma/fsldma.h     |    1 +
 5 files changed, 708 insertions(+), 201 deletions(-)
