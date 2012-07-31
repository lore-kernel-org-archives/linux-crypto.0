From: "Ira W. Snyder" <iws@ovro.caltech.edu>
Subject: [PATCH 0/7] fsl-dma: fixes for Freescale DMA driver
Date: Tue, 31 Jul 2012 16:45:45 -0700
Message-ID: <1343778352-5549-1-git-send-email-iws@ovro.caltech.edu>
Cc: linuxppc-dev@lists.ozlabs.org, B32616@freescale.com,
	"Ira W. Snyder" <iws@ovro.caltech.edu>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ovro.ovro.caltech.edu ([192.100.16.2]:59600 "EHLO
	ovro.ovro.caltech.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756260Ab2GaXp4 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 31 Jul 2012 19:45:56 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: "Ira W. Snyder" <iws@ovro.caltech.edu>

Hello everyone,

This is my alternative (simpler) attempt at solving the problems reported
by Qiang Liu with the async_tx API and MD RAID hardware offload support
when using the Freescale DMA driver.

The bug is caused by this driver freeing descriptors before they have been
ACKed by software using the async_tx API.

I don't like Qiang Liu's code to check where the hardware is in the
processing of the descriptor chain, and try to free a partial list of
descriptors. This was a source of bugs in this driver before I fixed them
several years ago.

Instead, the DMA controller raises an interrupt every time it has completed
a descriptor chain. This means it is ready for new descriptors: no need to
try and figure out where it is in the middle of a descriptor chain.

Qiang Liu: I do not have a hardware setup capable of using MD RAID. Please
test these patches to see if they fix the bug you reported. You may use
these patches as-is, or build upon them.

I have tested this using the drivers/dma/dmatest.c driver, as well as the
CARMA drivers. There are no regressions that I can find.

[  355.069679] dma0chan3-copy0: terminating after 100000 tests, 0 failures (status 0)
[  355.192278] dma0chan2-copy0: terminating after 100000 tests, 0 failures (status 0)

Ira W. Snyder (5):
  fsl-dma: minimize locking overhead
  fsl-dma: add fsl_dma_free_descriptor() to reduce code duplication
  fsl-dma: move functions to avoid forward declarations
  fsl-dma: fix support for async_tx API
  carma: remove unnecessary DMA_INTERRUPT capability

Qiang Liu (2):
  fsl-dma: remove attribute DMA_INTERRUPT of dmaengine
  fsl-dma: fix a warning of unitialized cookie

 drivers/dma/fsldma.c                    |  318 +++++++++++++++----------------
 drivers/dma/fsldma.h                    |    1 +
 drivers/misc/carma/carma-fpga-program.c |    1 -
 drivers/misc/carma/carma-fpga.c         |    3 +-
 4 files changed, 159 insertions(+), 164 deletions(-)

-- 
1.7.8.6
