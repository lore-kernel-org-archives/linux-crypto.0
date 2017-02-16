From: Anup Patel <anup.patel@broadcom.com>
Subject: [PATCH v5 0/4] Broadcom SBA RAID support
Date: Thu, 16 Feb 2017 12:18:11 +0530
Message-ID: <1487227695-965-1-git-send-email-anup.patel@broadcom.com>
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
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

The Broadcom SBA RAID is a stream-based device which provides
RAID5/6 offload.

It requires a SoC specific ring manager (such as Broadcom FlexRM
ring manager) to provide ring-based programming interface. Due to
this, the Broadcom SBA RAID driver (mailbox client) implements
DMA device having one DMA channel using a set of mailbox channels
provided by Broadcom SoC specific ring manager driver (mailbox
controller).

The Broadcom SBA RAID hardware requires PQ disk position instead
of PQ disk coefficient. To address this, we have added raid_gflog
table which will help driver to convert PQ disk coefficient to PQ
disk position.

This patchset is based on Linux-4.10-rc2 and depends on patchset
"[PATCH v4 0/2] Broadcom FlexRM ring manager support"

It is also available at sba-raid-v5 branch of
https://github.com/Broadcom/arm64-linux.git

Changes since v4:
 - Removed dependency of bcm-sba-raid driver on kconfig opton
   ASYNC_TX_ENABLE_CHANNEL_SWITCH
 - Select kconfig options ASYNC_TX_DISABLE_XOR_VAL_DMA and
   ASYNC_TX_DISABLE_PQ_VAL_DMA for bcm-sba-raid driver
 - Implemented device_prep_dma_interrupt() using dummy 8-byte
   copy operation so that the dma_async_device_register() can
   set DMA_ASYNC_TX capability for the DMA device provided
   by bcm-sba-raid driver

Changes since v3:
 - Replaced SBA_ENC() with sba_cmd_enc() inline function
 - Use list_first_entry_or_null() wherever possible
 - Remove unwanted brances around loops wherever possible
 - Use lockdep_assert_held() where required

Changes since v2:
 - Droped patch to handle DMA devices having support for fewer
   PQ coefficients in Linux Async Tx
 - Added work-around in bcm-sba-raid driver to handle unsupported
   PQ coefficients using multiple SBA requests

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

Anup Patel (4):
  lib/raid6: Add log-of-2 table for RAID6 HW requiring disk position
  async_tx: Fix DMA_PREP_FENCE usage in do_async_gen_syndrome()
  dmaengine: Add Broadcom SBA RAID driver
  dt-bindings: Add DT bindings document for Broadcom SBA RAID driver

 .../devicetree/bindings/dma/brcm,iproc-sba.txt     |   29 +
 crypto/async_tx/async_pq.c                         |    5 +-
 drivers/dma/Kconfig                                |   14 +
 drivers/dma/Makefile                               |    1 +
 drivers/dma/bcm-sba-raid.c                         | 1785 ++++++++++++++++++++
 include/linux/raid/pq.h                            |    1 +
 lib/raid6/mktables.c                               |   20 +
 7 files changed, 1852 insertions(+), 3 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/dma/brcm,iproc-sba.txt
 create mode 100644 drivers/dma/bcm-sba-raid.c

-- 
2.7.4
