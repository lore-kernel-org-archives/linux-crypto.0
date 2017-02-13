From: Anup Patel <anup.patel@broadcom.com>
Subject: Re: [PATCH v3 3/4] dmaengine: Add Broadcom SBA RAID driver
Date: Mon, 13 Feb 2017 14:43:51 +0530
Message-ID: <CAALAos-dThk-h09Yox5AN37po3OqR1oReoZPfqjZVqTqVkCxUA@mail.gmail.com>
References: <1486717628-17580-1-git-send-email-anup.patel@broadcom.com>
 <1486717628-17580-4-git-send-email-anup.patel@broadcom.com> <CAPcyv4hE5gDiHhfaiHDHbhA2xKa45UdzKcSxnQXK-W92sr3Z1g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Vinod Koul <vinod.koul@intel.com>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Jassi Brar <jassisinghbrar@gmail.com>,
        Ray Jui <rjui@broadcom.com>,
        Scott Branden <sbranden@broadcom.com>,
        Jon Mason <jonmason@broadcom.com>,
        Rob Rice <rob.rice@broadcom.com>,
        BCM Kernel Feedback <bcm-kernel-feedback-list@broadcom.com>,
        "dmaengine@vger.kernel.org" <dmaengine@vger.kernel.org>,
        Device Tree <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org"
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-crypto@vger.kernel.org,
        linux-raid <linux-raid@vger.kernel.org>
To: Dan Williams <dan.j.williams@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAPcyv4hE5gDiHhfaiHDHbhA2xKa45UdzKcSxnQXK-W92sr3Z1g@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Fri, Feb 10, 2017 at 11:20 PM, Dan Williams <dan.j.williams@intel.com> wrote:
> On Fri, Feb 10, 2017 at 1:07 AM, Anup Patel <anup.patel@broadcom.com> wrote:
>> The Broadcom stream buffer accelerator (SBA) provides offloading
>> capabilities for RAID operations. This SBA offload engine is
>> accessible via Broadcom SoC specific ring manager.
>>
>> This patch adds Broadcom SBA RAID driver which provides one
>> DMA device with RAID capabilities using one or more Broadcom
>> SoC specific ring manager channels. The SBA RAID driver in its
>> current shape implements memcpy, xor, and pq operations.
>>
>> Signed-off-by: Anup Patel <anup.patel@broadcom.com>
>> Reviewed-by: Ray Jui <ray.jui@broadcom.com>
>> ---
>>  drivers/dma/Kconfig        |   13 +
>>  drivers/dma/Makefile       |    1 +
>>  drivers/dma/bcm-sba-raid.c | 1711 ++++++++++++++++++++++++++++++++++++++++++++
>>  3 files changed, 1725 insertions(+)
>>  create mode 100644 drivers/dma/bcm-sba-raid.c
>>
>> diff --git a/drivers/dma/Kconfig b/drivers/dma/Kconfig
>> index 263495d..bf8fb84 100644
>> --- a/drivers/dma/Kconfig
>> +++ b/drivers/dma/Kconfig
>> @@ -99,6 +99,19 @@ config AXI_DMAC
>>           controller is often used in Analog Device's reference designs for FPGA
>>           platforms.
>>
>> +config BCM_SBA_RAID
>> +       tristate "Broadcom SBA RAID engine support"
>> +       depends on (ARM64 && MAILBOX && RAID6_PQ) || COMPILE_TEST
>> +       select DMA_ENGINE
>> +       select DMA_ENGINE_RAID
>> +       select ASYNC_TX_ENABLE_CHANNEL_SWITCH
>
> ASYNC_TX_ENABLE_CHANNEL_SWITCH violates the DMA mapping API and
> Russell has warned it's especially problematic on ARM [1].  If you
> need channel switching for this offload engine to be useful then you
> need to move DMA mapping and channel switching responsibilities to MD
> itself.
>
> [1]: http://lists.infradead.org/pipermail/linux-arm-kernel/2011-January/036753.html

Actually driver works fine with/without
ASYNC_TX_ENABLE_CHANNEL_SWITCH enabled
so I am fine with removing dependency on this config option.

>
>
> [..]
>> diff --git a/drivers/dma/bcm-sba-raid.c b/drivers/dma/bcm-sba-raid.c
>> new file mode 100644
>> index 0000000..bab9918
>> --- /dev/null
>> +++ b/drivers/dma/bcm-sba-raid.c
>> @@ -0,0 +1,1711 @@
>> +/*
>> + * Copyright (C) 2017 Broadcom
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License version 2 as
>> + * published by the Free Software Foundation.
>> + */
>> +
>> +/*
>> + * Broadcom SBA RAID Driver
>> + *
>> + * The Broadcom stream buffer accelerator (SBA) provides offloading
>> + * capabilities for RAID operations. The SBA offload engine is accessible
>> + * via Broadcom SoC specific ring manager. Two or more offload engines
>> + * can share same Broadcom SoC specific ring manager due to this Broadcom
>> + * SoC specific ring manager driver is implemented as a mailbox controller
>> + * driver and offload engine drivers are implemented as mallbox clients.
>> + *
>> + * Typically, Broadcom SoC specific ring manager will implement larger
>> + * number of hardware rings over one or more SBA hardware devices. By
>> + * design, the internal buffer size of SBA hardware device is limited
>> + * but all offload operations supported by SBA can be broken down into
>> + * multiple small size requests and executed parallely on multiple SBA
>> + * hardware devices for achieving high through-put.
>> + *
>> + * The Broadcom SBA RAID driver does not require any register programming
>> + * except submitting request to SBA hardware device via mailbox channels.
>> + * This driver implements a DMA device with one DMA channel using a set
>> + * of mailbox channels provided by Broadcom SoC specific ring manager
>> + * driver. To exploit parallelism (as described above), all DMA request
>> + * coming to SBA RAID DMA channel are broken down to smaller requests
>> + * and submitted to multiple mailbox channels in round-robin fashion.
>> + * For having more SBA DMA channels, we can create more SBA device nodes
>> + * in Broadcom SoC specific DTS based on number of hardware rings supported
>> + * by Broadcom SoC ring manager.
>> + */
>> +
>> +#include <linux/bitops.h>
>> +#include <linux/dma-mapping.h>
>> +#include <linux/dmaengine.h>
>> +#include <linux/list.h>
>> +#include <linux/mailbox_client.h>
>> +#include <linux/mailbox/brcm-message.h>
>> +#include <linux/module.h>
>> +#include <linux/of_device.h>
>> +#include <linux/slab.h>
>> +#include <linux/raid/pq.h>
>> +
>> +#include "dmaengine.h"
>> +
>> +/* SBA command helper macros */
>> +#define SBA_DEC(_d, _s, _m)            (((_d) >> (_s)) & (_m))
>> +#define SBA_ENC(_d, _v, _s, _m)                                        \
>> +               do {                                            \
>> +                       (_d) &= ~((u64)(_m) << (_s));           \
>> +                       (_d) |= (((u64)(_v) & (_m)) << (_s));   \
>> +               } while (0)
>
> Reusing a macro argument multiple times is problematic, consider
> SBA_ENC(..., arg++, ...), and hiding assignments in a macro make this
> hard to read. The compiler should inline it properly if you just make
> this a function that returns a value. You could also mark it __pure.

OK, I will make SBA_ENC as "static inline __pure" function.

>
> [..]
>> +
>> +static struct sba_request *sba_alloc_request(struct sba_device *sba)
>> +{
>> +       unsigned long flags;
>> +       struct sba_request *req = NULL;
>> +
>> +       spin_lock_irqsave(&sba->reqs_lock, flags);
>> +
>> +       if (!list_empty(&sba->reqs_free_list)) {
>> +               req = list_first_entry(&sba->reqs_free_list,
>> +                                      struct sba_request,
>> +                                      node);
>
> You could use list_first_entry_or_null() here.

OK, will use this.

>
> [..]
>> +
>> +/* Note: Must be called with sba->reqs_lock held */
>> +static void _sba_pending_request(struct sba_device *sba,
>> +                                struct sba_request *req)
>> +{
>
> You can validate the locking assumptions here with
> lockdep_assert_head(sba->reqs_lock).

OK, will try this.

>
> [..]
>> +
>> +static void sba_cleanup_nonpending_requests(struct sba_device *sba)
>> +{
>> +       unsigned long flags;
>> +       struct sba_request *req, *req1;
>> +
>> +       spin_lock_irqsave(&sba->reqs_lock, flags);
>> +
>> +       /* Freeup all alloced request */
>> +       list_for_each_entry_safe(req, req1, &sba->reqs_alloc_list, node) {
>> +               _sba_free_request(sba, req);
>> +       }
>> +
>> +       /* Freeup all received request */
>> +       list_for_each_entry_safe(req, req1, &sba->reqs_received_list, node) {
>> +               _sba_free_request(sba, req);
>> +       }
>> +
>> +       /* Freeup all completed request */
>> +       list_for_each_entry_safe(req, req1, &sba->reqs_completed_list, node) {
>> +               _sba_free_request(sba, req);
>> +       }
>> +
>> +       /* Set all active requests as aborted */
>> +       list_for_each_entry_safe(req, req1, &sba->reqs_active_list, node) {
>> +               _sba_abort_request(sba, req);
>> +       }
>
> In some parts of the driver you leave off unneeded braces like the for
> loop in sba_prep_dma_pq(), and in some case you include them. I'd say
> remove them if they're not necessary, but either way make it
> consistent across the driver.

I think I relied too much on checkpatch.pl to catch this
kind of coding-style issues.

I will fix this. Thanks for catching.

>
> [..]
>> +
>> +static struct dma_async_tx_descriptor *
>> +sba_prep_dma_pq(struct dma_chan *dchan, dma_addr_t *dst, dma_addr_t *src,
>> +               u32 src_cnt, const u8 *scf, size_t len, unsigned long flags)
>> +{
>> +       u32 i, dst_q_index;
>> +       size_t req_len;
>> +       bool slow = false;
>> +       dma_addr_t off = 0;
>> +       dma_addr_t *dst_p = NULL, *dst_q = NULL;
>> +       struct sba_device *sba = to_sba_device(dchan);
>> +       struct sba_request *first = NULL, *req;
>> +
>> +       /* Sanity checks */
>> +       if (unlikely(src_cnt > sba->max_pq_srcs))
>> +               return NULL;
>> +       for (i = 0; i < src_cnt; i++)
>> +               if (sba->max_pq_coefs <= raid6_gflog[scf[i]])
>> +                       slow = true;
>
> Thanks, yes, I do think this is cleaner here than in async_tx itself.
>
> [..]
>> +static void sba_receive_message(struct mbox_client *cl, void *msg)
>> +{
>> +       unsigned long flags;
>> +       struct brcm_message *m = msg;
>> +       struct sba_request *req = m->ctx, *req1;
>> +       struct sba_device *sba = req->sba;
>> +
>> +       /* Error count if message has error */
>> +       if (m->error < 0) {
>> +               dev_err(sba->dev, "%s got message with error %d",
>> +                       dma_chan_name(&sba->dma_chan), m->error);
>> +       }
>> +
>> +       /* Mark request as received */
>> +       sba_received_request(req);
>> +
>> +       /* Wait for all chained requests to be completed */
>> +       if (atomic_dec_return(&req->first->next_pending_count))
>> +               goto done;
>> +
>> +       /* Point to first request */
>> +       req = req->first;
>> +
>> +       /* Update request */
>> +       if (req->state == SBA_REQUEST_STATE_RECEIVED)
>> +               sba_dma_tx_actions(req);
>> +       else
>> +               sba_free_chained_requests(req);
>> +
>> +       spin_lock_irqsave(&sba->reqs_lock, flags);
>> +
>> +       /* Re-check all completed request waiting for 'ack' */
>> +       list_for_each_entry_safe(req, req1, &sba->reqs_completed_list, node) {
>> +               spin_unlock_irqrestore(&sba->reqs_lock, flags);
>> +               sba_dma_tx_actions(req);
>
> You've now required all callback paths to be hardirq safe whereas
> previously the callbacks only assumed softirq exclusion. Have you run
> this with CONFIG_PROVE_LOCKING enabled?

We have run stress tests on driver with multiple threads
trying to submit txn.

I will certainly try CONFIG_PROVE_LOCKING to be
double sure.

Thanks,
Anup
