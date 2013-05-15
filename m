From: Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 00/39] Continuation of DMA changes in ux500 based drivers
Date: Wed, 15 May 2013 10:51:23 +0100
Message-ID: <1368611522-9984-1-git-send-email-lee.jones@linaro.org>
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
	srinidhi.kasagar@stericsson.com
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	balbi@ti.com, linux-usb@vger.kernel.org,
	linux-crypto@vger.kernel.org, davem@davemloft.net,
	herbert@gondor.apana.org.au, vinod.koul@intel.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wg0-f43.google.com ([74.125.82.43]:50352 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754773Ab3EOJwN (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 15 May 2013 05:52:13 -0400
Received: by mail-wg0-f43.google.com with SMTP id c11so1422794wgh.10
        for <linux-crypto@vger.kernel.org>; Wed, 15 May 2013 02:52:12 -0700 (PDT)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

A great deal of these patches have now been applied through various trees.
We now need to grab the attention of the outstanding DMA clients (MUSB and
Crypto) to progress.

Also, Linus could probably do with a hand from Vinod for the remaining
dmaengine patches.

Thanks in advance.

 Documentation/devicetree/bindings/dma/ste-dma40.txt |    4 ++
 Documentation/devicetree/bindings/usb/ux500-usb.txt |   50 ++++++++++++++++++
 arch/arm/mach-ux500/board-mop500-audio.c            |   12 ++---
 arch/arm/mach-ux500/board-mop500-sdi.c              |   16 +++---
 arch/arm/mach-ux500/board-mop500.c                  |   36 +++++--------
 arch/arm/mach-ux500/cpu-db8500.c                    |   34 ++++--------
 arch/arm/mach-ux500/devices-db8500.c                |   80 ----------------------------
 arch/arm/mach-ux500/usb.c                           |   37 +++----------
 drivers/crypto/ux500/cryp/cryp.h                    |    7 ++-
 drivers/crypto/ux500/cryp/cryp_core.c               |   31 ++++++++++-
 drivers/crypto/ux500/hash/hash_alg.h                |    5 +-
 drivers/crypto/ux500/hash/hash_core.c               |   24 ++++++++-
 drivers/dma/ste_dma40.c                             |  292 +++++++++++++++++++++++++++++++++++++++++++++++++----------------------------------------------------
 drivers/dma/ste_dma40_ll.c                          |  189 +++++++++++++++++++++++++++++++++--------------------------------
 drivers/dma/ste_dma40_ll.h                          |    3 +-
 drivers/usb/musb/ux500.c                            |   61 ++++++++++++++++++++-
 drivers/usb/musb/ux500_dma.c                        |   59 ++++++++++++---------
 include/linux/platform_data/dma-ste-dma40.h         |   25 ++-------
 include/linux/platform_data/usb-musb-ux500.h        |    5 +-
 sound/soc/ux500/ux500_pcm.c                         |   10 ++--
 20 files changed, 506 insertions(+), 474 deletions(-)
