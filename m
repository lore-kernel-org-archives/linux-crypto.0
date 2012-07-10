From: Qiang Liu <qiang.liu@freescale.com>
Subject: [PATCH 0/3] Raid: enable talitos xor offload for improving performance
Date: Tue, 10 Jul 2012 13:54:41 +0800
Message-ID: <1341899685-18665-1-git-send-email-qiang.liu@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <leoli@freescale.com>, <kim.phillips@freescale.com>
To: <linux-crypto@vger.kernel.org>, <linuxppc-dev@lists.ozlabs.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from va3ehsobe002.messaging.microsoft.com ([216.32.180.12]:53278
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751770Ab2GJGPv (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 10 Jul 2012 02:15:51 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The following 4 patches enabling fsl-dma and talitos offload raid
operations for improving raid performance and balancing CPU load.

Write performance will be improved by 40% tested by iozone. CPU load
will be reduced by 8%.

Qiang Liu (4):
      Talitos: move the data structure into header file
      Talitos: Support for async_tx XOR offload
      fsl-dma: support attribute of DMA_MEMORY when async_tx enabled
      Talitos: fix the issue of dma memory leak

 drivers/crypto/Kconfig   |    9 +
 drivers/crypto/talitos.c |  520 ++++++++++++++++++++++++++++++++++++----------
 drivers/crypto/talitos.h |  161 ++++++++++++++
 drivers/dma/fsldma.c     |   78 +++-----
 4 files changed, 606 insertions(+), 162 deletions(-)
