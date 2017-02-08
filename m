From: Anup Patel <anup.patel@broadcom.com>
Subject: Re: [PATCH v2 2/5] async_tx: Handle DMA devices having support for
 fewer PQ coefficients
Date: Wed, 8 Feb 2017 12:07:23 +0530
Message-ID: <CAALAos__1XVv-=CitWfWLsXUt7nYC5bN6qaVUBWY7fiLA1UtGg@mail.gmail.com>
References: <1486455406-11202-1-git-send-email-anup.patel@broadcom.com>
 <1486455406-11202-3-git-send-email-anup.patel@broadcom.com>
 <CAPcyv4gbV1yf52JrejW+Dn3wOPn7Er+8HWdu2qsW0+Qm+cRr9g@mail.gmail.com>
 <CAALAos_yhXufdt79KWY0eugjF5oyJ8+NcPh2E-dEXnSQu2WhhA@mail.gmail.com> <20170207164207.GI19244@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Dan Williams <dan.j.williams@intel.com>,
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
To: Vinod Koul <vinod.koul@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170207164207.GI19244@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, Feb 7, 2017 at 10:12 PM, Vinod Koul <vinod.koul@intel.com> wrote:
> On Tue, Feb 07, 2017 at 02:32:15PM +0530, Anup Patel wrote:
>> On Tue, Feb 7, 2017 at 1:57 PM, Dan Williams <dan.j.williams@intel.com> wrote:
>> > On Tue, Feb 7, 2017 at 12:16 AM, Anup Patel <anup.patel@broadcom.com> wrote:
>> >> The DMAENGINE framework assumes that if PQ offload is supported by a
>> >> DMA device then all 256 PQ coefficients are supported. This assumption
>> >> does not hold anymore because we now have BCM-SBA-RAID offload engine
>> >> which supports PQ offload with limited number of PQ coefficients.
>> >>
>> >> This patch extends async_tx APIs to handle DMA devices with support
>> >> for fewer PQ coefficients.
>> >>
>> >> Signed-off-by: Anup Patel <anup.patel@broadcom.com>
>> >> Reviewed-by: Scott Branden <scott.branden@broadcom.com>
>> >
>> > I don't like this approach. Define an interface for md to query the
>> > offload engine once at the beginning of time. We should not be adding
>> > any new extensions to async_tx.
>>
>> Even if we do capability checks in Linux MD, we still need a way
>> for DMAENGINE drivers to advertise number of PQ coefficients
>> handled by the HW.
>
> If the question is only for advertising caps, then why not do as done
> for dma_get_slave_caps(). you can add dma_get_pq_caps() so that clients (md)
> in this case would know the HW capability.

We have large number of possible capabilities for
DMA slave such as src_addr_widths, dst_addr_widths,
directions, max_burst, residue_granularity, and
descriptor_resue.

The possible capabilities of PQ offload are:
1. Number of PQ sources handled by PQ offload
(Represented by "max_pq" member of "struct dma_device")
2. Number of PQ coefficients handled by PQ offload

The above two PQ capabilities are good enough for
current PQ HW and future PQ HW so we just need a
way to specify number of PQ coefficients.

Till now all of the PQ HW always supported all 256
PQ coefficients so we never felt the need of capability
to specify PQ coefficients. The BCM-SBA-RAID is the
only HW (as far as I know) which does not support all
256 PQ coefficients.

Currently, DMAENGINE drivers use dma_set_maxpq() to
specify number of PQ sources handled by PQ HW and
Linux Async Tx uses dma_maxpq() to get number of
PQ sources.

On similar lines, we added dma_set_maxpqcoef() to
specify number of PQ coefficients and Linux Async Tx
uses dma_maxpqcoef() to get number of PQ coefficients.
If DMAENGINE driver does not specify PQ coefficients
then dma_maxpqcoef() will return 256 assuming all
PQ coefficients are supported. This approach is
backward compatible to existing DMAENGINE APIs
and will not break existing DMAENGINE drivers.

If we add dma_get_pq_caps() similar to the
dma_get_slave_caps() for PQ capabilities then we
will have to use this new method for both of the above
PQ capabilities and we have to change all DMAENGINE
drivers to use new method of specifying PQ capabilities.
I think this is too intrusive and bit overkill because its
very very unlikely to see anymore additions to
PQ capabilities.

Regards,
Anup
