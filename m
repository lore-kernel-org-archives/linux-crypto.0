From: Anup Patel <anup.patel@broadcom.com>
Subject: [PATCH v2 0/5] Broadcom SBA RAID support
Date: Tue,  7 Feb 2017 13:46:41 +0530
Message-ID: <1486455406-11202-1-git-send-email-anup.patel@broadcom.com>
Cc: Dan Williams <dan.j.williams@intel.com>,
        Ray Jui <rjui@broadcom.com>,
        Scott Branden <sbranden@broadcom.com>,
        Jon Mason <jonmason@broadcom.com>,
        Rob Rice <rob.rice@broadcom.com>,
        bcm-kernel-feedback-list@broadcom.com, dmaengine@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-raid@vger.kernel.org, Anup Patel <anup.patel@broadcom.com>
To: Vinod Koul <vinod.koul@intel.com>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Jassi Brar <jassisinghbrar@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-qk0-f175.google.com ([209.85.220.175]:34691 "EHLO
        mail-qk0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753097AbdBGIRL (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 7 Feb 2017 03:17:11 -0500
Received: by mail-qk0-f175.google.com with SMTP id s186so80581773qkb.1
        for <linux-crypto@vger.kernel.org>; Tue, 07 Feb 2017 00:17:11 -0800 (PST)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The Broadcom SBA RAID is a stream-based device which provides
RAID5/6 offload.

It requires a SoC specific ring manager (such as Broadcom FlexRM
ring manager) to provide ring-based programming interface. Due to
this, the Broadcom SBA RAID driver (mailbox client) implements
DMA device having one DMA channel using a set of mailbox channels
provided by Broadcom SoC specific ring manager driver (mailbox
controller).

Important limitations of Broadcom SBA RAID hardware are:
1. Requires disk position instead of disk coefficient 
2. Supports only 30 PQ disk coefficients

To address limitation #1, we have added raid_gflog table which
will help driver convert disk coefficient to disk position. To
address limitation #2, we have extended Linux Async Tx APIs to
check for available PQ coefficients before doing PQ offload.

This patchset is based on Linux-4.10-rc2 and depends on patchset
"[PATCH v4 0/2] Broadcom FlexRM ring manager support"

It is also available at sba-raid-v2 branch of
https://github.com/Broadcom/arm64-linux.git

Changes since v1:
 - Droped patch to add mbox_channel_device() API
 - Used GENMASK and BIT macros wherever possible in bcm-sba-raid driver
 - Replaced C_MDATA macros with static inline functions in
   bcm-sba-raid driver
 - Removed sba_alloc_chan_resources() callback in bcm-sba-raid driver
 - Used dev_err() instead of dev_info() wherever applicable
 - Removed call to sba_issue_pending() from sba_tx_submit() in
   bcm-sba-raid driver
 - Implemented SBA request chaning for handling (len > sba->req_size)
   in bcm-sba-raid driver
 - Implemented device_terminate_all() callback in bcm-sba-raid driver

Anup Patel (5):
  lib/raid6: Add log-of-2 table for RAID6 HW requiring disk position
  async_tx: Handle DMA devices having support for fewer PQ coefficients
  async_tx: Fix DMA_PREP_FENCE usage in do_async_gen_syndrome()
  dmaengine: Add Broadcom SBA RAID driver
  dt-bindings: Add DT bindings document for Broadcom SBA RAID driver

 .../devicetree/bindings/dma/brcm,iproc-sba.txt     |   29 +
 crypto/async_tx/async_pq.c                         |    8 +-
 crypto/async_tx/async_raid6_recov.c                |   12 +-
 drivers/dma/Kconfig                                |   13 +
 drivers/dma/Makefile                               |    1 +
 drivers/dma/bcm-sba-raid.c                         | 1470 ++++++++++++++++++++
 include/linux/dmaengine.h                          |   19 +
 include/linux/raid/pq.h                            |    4 +
 lib/raid6/mktables.c                               |   20 +
 9 files changed, 1571 insertions(+), 5 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/dma/brcm,iproc-sba.txt
 create mode 100644 drivers/dma/bcm-sba-raid.c

-- 
2.7.4
