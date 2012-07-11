From: Qiang Liu <qiang.liu@freescale.com>
Subject: [PATCH v2 0/4] Raid: enable talitos xor offload for improving performance
Date: Wed, 11 Jul 2012 16:57:24 +0800
Message-ID: <1341997044-17994-1-git-send-email-qiang.liu@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <leoli@freescale.com>, <kim.phillips@freescale.com>,
	<qiang.liu@freescale.com>, <herbert@gondor.hengli.com.au>,
	<davem@davemloft.net>, <vinod.koul@intel.com>,
	<dan.j.williams@intel.com>
To: <linux-crypto@vger.kernel.org>, <linuxppc-dev@lists.ozlabs.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from co1ehsobe001.messaging.microsoft.com ([216.32.180.184]:40276
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751926Ab2GKJSf (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 11 Jul 2012 05:18:35 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The following 4 patches enabling fsl-dma and talitos offload raid
operations for improving raid performance and balancing CPU load.

Write performance will be improved by 40% tested by iozone. CPU load
will be reduced by 8%.

Changes in v2:
	- rebase onto cryptodev tree
	- split the patch 3/4 up to 3 independent patches
	- remove the patch 4/4, the fix is not for cryptodev tree

Qiang Liu (4):
      Talitos: Support for async_tx XOR offload
      fsl-dma: remove attribute DMA_INTERRUPT of dmaengine
      fsl-dma: change the release process of dma descriptor
      fsl-dma: use spin_lock_bh to instead of spin_lock_irqsave

 drivers/crypto/Kconfig   |    9 +
 drivers/crypto/talitos.c |  410 ++++++++++++++++++++++++++++++++++++++++++++++
 drivers/crypto/talitos.h |   53 ++++++
 drivers/dma/fsldma.c     |   76 +++------
 4 files changed, 496 insertions(+), 52 deletions(-)
