From: Anup Patel <anup.patel@broadcom.com>
Subject: Re: [PATCH v4 3/4] dmaengine: Add Broadcom SBA RAID driver
Date: Wed, 15 Feb 2017 14:03:18 +0530
Message-ID: <CAALAos8z+z6Sh_tzXYv=CFT54NxT1XGT8uyiXFxcYKBmuDYZbg@mail.gmail.com>
References: <1487055112-5185-1-git-send-email-anup.patel@broadcom.com>
 <1487055112-5185-4-git-send-email-anup.patel@broadcom.com>
 <CAPcyv4g5PU1EQWq-SCbt0QB=vSaMyafqa-ThJifDxEoQha-6Hw@mail.gmail.com>
 <CAALAos_=TN_ZfeJbRQEwuc+t5zaxKVgrgEMNPQQu8K8Q8+8F6A@mail.gmail.com>
 <CAPcyv4jckb=sbocr3W43NZ2YyUVLbDdhbCAhLfgQwh-bRuvjYQ@mail.gmail.com>
 <CAALAos-txDCs3QZ4HGBNicOD8t49NPT6E8RpjVMccMn1D-UTgQ@mail.gmail.com> <CAPcyv4h83vgeB82KmEEFV196MsWdteRqypY5_tcSyaMM_QwYMA@mail.gmail.com>
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
In-Reply-To: <CAPcyv4h83vgeB82KmEEFV196MsWdteRqypY5_tcSyaMM_QwYMA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wed, Feb 15, 2017 at 12:55 PM, Dan Williams <dan.j.williams@intel.com> wrote:
> On Tue, Feb 14, 2017 at 11:03 PM, Anup Patel <anup.patel@broadcom.com> wrote:
>> On Wed, Feb 15, 2017 at 12:13 PM, Dan Williams <dan.j.williams@intel.com> wrote:
>>> On Tue, Feb 14, 2017 at 10:25 PM, Anup Patel <anup.patel@broadcom.com> wrote:
>>>> On Tue, Feb 14, 2017 at 10:04 PM, Dan Williams <dan.j.williams@intel.com> wrote:
>>>>> On Mon, Feb 13, 2017 at 10:51 PM, Anup Patel <anup.patel@broadcom.com> wrote:
>>>>>> The Broadcom stream buffer accelerator (SBA) provides offloading
>>>>>> capabilities for RAID operations. This SBA offload engine is
>>>>>> accessible via Broadcom SoC specific ring manager.
>>>>>>
>>>>>> This patch adds Broadcom SBA RAID driver which provides one
>>>>>> DMA device with RAID capabilities using one or more Broadcom
>>>>>> SoC specific ring manager channels. The SBA RAID driver in its
>>>>>> current shape implements memcpy, xor, and pq operations.
>>>>>>
>>>>>> Signed-off-by: Anup Patel <anup.patel@broadcom.com>
>>>>>> Reviewed-by: Ray Jui <ray.jui@broadcom.com>
>>>>>> ---
>>>>>>  drivers/dma/Kconfig        |   13 +
>>>>>>  drivers/dma/Makefile       |    1 +
>>>>>>  drivers/dma/bcm-sba-raid.c | 1694 ++++++++++++++++++++++++++++++++++++++++++++
>>>>>>  3 files changed, 1708 insertions(+)
>>>>>>  create mode 100644 drivers/dma/bcm-sba-raid.c
>>>>>>
>>>>>> diff --git a/drivers/dma/Kconfig b/drivers/dma/Kconfig
>>>>>> index 263495d..bf8fb84 100644
>>>>>> --- a/drivers/dma/Kconfig
>>>>>> +++ b/drivers/dma/Kconfig
>>>>>> @@ -99,6 +99,19 @@ config AXI_DMAC
>>>>>>           controller is often used in Analog Device's reference designs for FPGA
>>>>>>           platforms.
>>>>>>
>>>>>> +config BCM_SBA_RAID
>>>>>> +       tristate "Broadcom SBA RAID engine support"
>>>>>> +       depends on (ARM64 && MAILBOX && RAID6_PQ) || COMPILE_TEST
>>>>>> +       select DMA_ENGINE
>>>>>> +       select DMA_ENGINE_RAID
>>>>>> +       select ASYNC_TX_ENABLE_CHANNEL_SWITCH
>>>>>
>>>>> I thought you agreed to drop this. Its usage is broken.
>>>>
>>>> If ASYNC_TX_ENABLE_CHANNEL_SWITCH is not selected
>>>> then async_dma_find_channel() will only try to find channel
>>>> with DMA_ASYNC_TX capability.
>>>>
>>>> The DMA_ASYNC_TX capability is set by
>>>> dma_async_device_register() when all Async Tx
>>>> capabilities are supported by a DMA devices namely
>>>> DMA_INTERRUPT, DMA_MEMCPY, DMA_XOR,
>>>> DMA_XOR_VAL, DMA_PQ, and DMA_PQ_VAL.
>>>>
>>>> We only support DMA_MEMCPY, DMA_XOR, and
>>>> DMA_PQ capabilities in BCM-SBA-RAID driver so
>>>> DMA_ASYNC_TX capability is never set for the
>>>> DMA device registered by BCM-SBA-RAID driver.
>>>>
>>>> Due to above, if ASYNC_TX_ENABLE_CHANNEL_SWITCH
>>>> is not selected then Async Tx APIs fail to find DMA
>>>> channel provided by BCM-SBA-RAID hence the
>>>> option ASYNC_TX_ENABLE_CHANNEL_SWITCH is
>>>> required for BCM-SBA-RAID.
>>>>
>>>> The DMA mappings are violated by channel switching
>>>> only if we switch form DMA channel A to DMA channel
>>>> B and both these DMA channels have different underlying
>>>> "struct device". In most of the cases DMA mappings
>>>> are not violated because DMA channels having
>>>> Async Tx capabilities are provided using same
>>>> underlying "struct device".
>>>
>>> No, fix the infrastructure. Do not put local hack in your driver for
>>> this global problem [1].
>>
>> There is no hack in the driver. We need
>> ASYNC_TX_ENABLE_CHANNEL_SWITCH
>> based on current state of dmaengine framework.
>>
>> The framework should be fixed as separate patchset.
>>
>> We have other RAID drivers such as xgene-dma and
>> mv_xor_v2 who also require
>> ASYNC_TX_ENABLE_CHANNEL_SWITCH due
>> to same reason.
>>
>> Fixing the framework and improving framework is
>> a ongoing process. I don't see why that should
>> stop this patchset.
>>
>
> Because this driver is turning on a dangerous compile time option and
> is not using the functionality. If this silicon IP block appears in
> another product in the future paired with another DMA engine then the
> assumptions about a safe/single dma-device is violated.
>
> The realization of how async_tx was breaking DMA mapping api
> assumptions came after some of these dma-drivers were added to the
> kernel. We should stop making the problem worse.
>
> I should have submitted a patch like the below at the time we
> discovered this problem, but unfortunately it languished when I
> stopped maintaining the iop-adma and ioat drivers.
>
> diff --git a/drivers/dma/Kconfig b/drivers/dma/Kconfig
> index 263495d0adbd..6b30eb9ad125 100644
> --- a/drivers/dma/Kconfig
> +++ b/drivers/dma/Kconfig
> @@ -35,6 +35,7 @@ comment "DMA Devices"
>
>  #core
>  config ASYNC_TX_ENABLE_CHANNEL_SWITCH
> +       depends on BROKEN
>         bool
>
>  config ARCH_HAS_ASYNC_TX_FIND_CHANNEL

Instead of selecting
ASYNC_TX_ENABLE_CHANNEL_SWITCH,
we can select the following in BCM_SBA_RAID config
option:
1. ASYNC_TX_DISABLE_XOR_VAL
2. ASYNC_TX_DISABLE_PQ_VAL

This will satisfy the needs of
dma_async_device_register() when
ASYNC_TX_ENABLE_CHANNEL_SWITCH is
not selected.

Will this be acceptable ??

Regards,
Anup
