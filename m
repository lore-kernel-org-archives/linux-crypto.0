From: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v4 3/4] dmaengine: Add Broadcom SBA RAID driver
Date: Tue, 14 Feb 2017 22:43:05 -0800
Message-ID: <CAPcyv4jckb=sbocr3W43NZ2YyUVLbDdhbCAhLfgQwh-bRuvjYQ@mail.gmail.com>
References: <1487055112-5185-1-git-send-email-anup.patel@broadcom.com>
 <1487055112-5185-4-git-send-email-anup.patel@broadcom.com>
 <CAPcyv4g5PU1EQWq-SCbt0QB=vSaMyafqa-ThJifDxEoQha-6Hw@mail.gmail.com> <CAALAos_=TN_ZfeJbRQEwuc+t5zaxKVgrgEMNPQQu8K8Q8+8F6A@mail.gmail.com>
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
To: Anup Patel <anup.patel-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAALAos_=TN_ZfeJbRQEwuc+t5zaxKVgrgEMNPQQu8K8Q8+8F6A-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

On Tue, Feb 14, 2017 at 10:25 PM, Anup Patel <anup.patel-dY08KVG/lbpWk0Htik3J/w@public.gmane.org> wrote:
> On Tue, Feb 14, 2017 at 10:04 PM, Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
>> On Mon, Feb 13, 2017 at 10:51 PM, Anup Patel <anup.patel-dY08KVG/lbpWk0Htik3J/w@public.gmane.org> wrote:
>>> The Broadcom stream buffer accelerator (SBA) provides offloading
>>> capabilities for RAID operations. This SBA offload engine is
>>> accessible via Broadcom SoC specific ring manager.
>>>
>>> This patch adds Broadcom SBA RAID driver which provides one
>>> DMA device with RAID capabilities using one or more Broadcom
>>> SoC specific ring manager channels. The SBA RAID driver in its
>>> current shape implements memcpy, xor, and pq operations.
>>>
>>> Signed-off-by: Anup Patel <anup.patel-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
>>> Reviewed-by: Ray Jui <ray.jui-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
>>> ---
>>>  drivers/dma/Kconfig        |   13 +
>>>  drivers/dma/Makefile       |    1 +
>>>  drivers/dma/bcm-sba-raid.c | 1694 ++++++++++++++++++++++++++++++++++++++++++++
>>>  3 files changed, 1708 insertions(+)
>>>  create mode 100644 drivers/dma/bcm-sba-raid.c
>>>
>>> diff --git a/drivers/dma/Kconfig b/drivers/dma/Kconfig
>>> index 263495d..bf8fb84 100644
>>> --- a/drivers/dma/Kconfig
>>> +++ b/drivers/dma/Kconfig
>>> @@ -99,6 +99,19 @@ config AXI_DMAC
>>>           controller is often used in Analog Device's reference designs for FPGA
>>>           platforms.
>>>
>>> +config BCM_SBA_RAID
>>> +       tristate "Broadcom SBA RAID engine support"
>>> +       depends on (ARM64 && MAILBOX && RAID6_PQ) || COMPILE_TEST
>>> +       select DMA_ENGINE
>>> +       select DMA_ENGINE_RAID
>>> +       select ASYNC_TX_ENABLE_CHANNEL_SWITCH
>>
>> I thought you agreed to drop this. Its usage is broken.
>
> If ASYNC_TX_ENABLE_CHANNEL_SWITCH is not selected
> then async_dma_find_channel() will only try to find channel
> with DMA_ASYNC_TX capability.
>
> The DMA_ASYNC_TX capability is set by
> dma_async_device_register() when all Async Tx
> capabilities are supported by a DMA devices namely
> DMA_INTERRUPT, DMA_MEMCPY, DMA_XOR,
> DMA_XOR_VAL, DMA_PQ, and DMA_PQ_VAL.
>
> We only support DMA_MEMCPY, DMA_XOR, and
> DMA_PQ capabilities in BCM-SBA-RAID driver so
> DMA_ASYNC_TX capability is never set for the
> DMA device registered by BCM-SBA-RAID driver.
>
> Due to above, if ASYNC_TX_ENABLE_CHANNEL_SWITCH
> is not selected then Async Tx APIs fail to find DMA
> channel provided by BCM-SBA-RAID hence the
> option ASYNC_TX_ENABLE_CHANNEL_SWITCH is
> required for BCM-SBA-RAID.
>
> The DMA mappings are violated by channel switching
> only if we switch form DMA channel A to DMA channel
> B and both these DMA channels have different underlying
> "struct device". In most of the cases DMA mappings
> are not violated because DMA channels having
> Async Tx capabilities are provided using same
> underlying "struct device".

No, fix the infrastructure. Do not put local hack in your driver for
this global problem [1].

[1]: https://lwn.net/Articles/443531/
--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
