From: Anup Patel <anup.patel-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH v3 3/4] dmaengine: Add Broadcom SBA RAID driver
Date: Tue, 14 Feb 2017 10:54:27 +0530
Message-ID: <CAALAos-+7kL6C7ZOUgX1AMqzKR6kL82qcz4wvmx5p9Ujj77tuQ@mail.gmail.com>
References: <1486717628-17580-1-git-send-email-anup.patel@broadcom.com>
 <1486717628-17580-4-git-send-email-anup.patel@broadcom.com> <CAPcyv4hE5gDiHhfaiHDHbhA2xKa45UdzKcSxnQXK-W92sr3Z1g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Vinod Koul <vinod.koul-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>,
        Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>,
        Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>,
        Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>,
        "David S . Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>,
        Jassi Brar <jassisinghbrar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
        Ray Jui <rjui-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>,
        Scott Branden <sbranden-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>,
        Jon Mason <jonmason-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>,
        Rob Rice <rob.rice-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>,
        BCM Kernel Feedback <bcm-kernel-feedback-list-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>,
        "dmaengine-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <dmaengine-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        Device Tree <devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org"
        <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>,
        "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
        linux-raid <linux-raid-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAPcyv4hE5gDiHhfaiHDHbhA2xKa45UdzKcSxnQXK-W92sr3Z1g-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

On Fri, Feb 10, 2017 at 11:20 PM, Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
> On Fri, Feb 10, 2017 at 1:07 AM, Anup Patel <anup.patel-dY08KVG/lbpWk0Htik3J/w@public.gmane.org> wrote:
>> The Broadcom stream buffer accelerator (SBA) provides offloading
>> capabilities for RAID operations. This SBA offload engine is
>> accessible via Broadcom SoC specific ring manager.
>>
>> This patch adds Broadcom SBA RAID driver which provides one
>> DMA device with RAID capabilities using one or more Broadcom
>> SoC specific ring manager channels. The SBA RAID driver in its
>> current shape implements memcpy, xor, and pq operations.
>>
>> Signed-off-by: Anup Patel <anup.patel-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
>> Reviewed-by: Ray Jui <ray.jui-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
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

In case of BCM-SBA-RAID, the underlying "struct device" for each
DMA channel is the mailbox controller "struct device" (i.e. Ring
Manager device). This is because Ring Manager HW is the front
facing device which we program to submit work to BCM-SBA-RAID
HW.

This means DMA channels provided by BCM-SBA-RAID driver
will use same "struct device" for DMA mappings hence channel
switching between BCM-SBA-RAID DMA channels is safe.

Due to above, we can safely enable
ASYNC_TX_ENABLE_CHANNEL_SWITCH option for
BCM-SBA-RAID driver.

Regards,
Anup
--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
