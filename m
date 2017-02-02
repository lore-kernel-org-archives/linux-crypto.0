From: Anup Patel <anup.patel-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 0/6] Broadcom SBA RAID support
Date: Thu,  2 Feb 2017 10:17:10 +0530
Message-ID: <1486010836-25228-1-git-send-email-anup.patel@broadcom.com>
Cc: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>,
        Ray Jui <rjui-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>,
        Scott Branden <sbranden-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>,
        Jon Mason <jonmason-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>,
        Rob Rice <rob.rice-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>,
        bcm-kernel-feedback-list-dY08KVG/lbpWk0Htik3J/w@public.gmane.org, dmaengine-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
        devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org,
        linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
        linux-raid-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Anup Patel <anup.patel-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
To: Vinod Koul <vinod.koul-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>,
        Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>,
        Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>,
        Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>,
        "David S . Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>,
        Jassi Brar <jassisinghbrar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

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

This patchset is based on Linux-4.10-rc6 and depends on patchset
"[PATCH v4 0/2] Broadcom FlexRM ring manager support"

It is also available at sba-raid-v1 branch of
https://github.com/Broadcom/arm64-linux.git

Anup Patel (6):
  mailbox: Add new API mbox_channel_device() for clients
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
 drivers/dma/bcm-sba-raid.c                         | 1309 ++++++++++++++++++++
 drivers/mailbox/mailbox.c                          |   21 +
 include/linux/dmaengine.h                          |   19 +
 include/linux/mailbox_client.h                     |    1 +
 include/linux/raid/pq.h                            |    4 +
 lib/raid6/mktables.c                               |   20 +
 11 files changed, 1432 insertions(+), 5 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/dma/brcm,iproc-sba.txt
 create mode 100644 drivers/dma/bcm-sba-raid.c

-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
