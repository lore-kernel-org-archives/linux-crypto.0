From: Anup Patel <anup.patel@broadcom.com>
Subject: Re: [PATCH v2 2/5] async_tx: Handle DMA devices having support for
 fewer PQ coefficients
Date: Wed, 8 Feb 2017 14:27:23 +0530
Message-ID: <CAALAos9ovab4x=waRgM7G2adRC7syHMkY0Rhf-UPB_+h4w3yNQ@mail.gmail.com>
References: <1486455406-11202-1-git-send-email-anup.patel@broadcom.com>
 <1486455406-11202-3-git-send-email-anup.patel@broadcom.com>
 <CAPcyv4gbV1yf52JrejW+Dn3wOPn7Er+8HWdu2qsW0+Qm+cRr9g@mail.gmail.com>
 <CAALAos_yhXufdt79KWY0eugjF5oyJ8+NcPh2E-dEXnSQu2WhhA@mail.gmail.com> <CAPcyv4hK_1f8bryq6smPQy7vTnP+QEzmT9wnAEE1xpxq7EAnjQ@mail.gmail.com>
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
In-Reply-To: <CAPcyv4hK_1f8bryq6smPQy7vTnP+QEzmT9wnAEE1xpxq7EAnjQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, Feb 7, 2017 at 11:46 PM, Dan Williams <dan.j.williams@intel.com> wrote:
> On Tue, Feb 7, 2017 at 1:02 AM, Anup Patel <anup.patel@broadcom.com> wrote:
>> On Tue, Feb 7, 2017 at 1:57 PM, Dan Williams <dan.j.williams@intel.com> wrote:
>>> On Tue, Feb 7, 2017 at 12:16 AM, Anup Patel <anup.patel@broadcom.com> wrote:
>>>> The DMAENGINE framework assumes that if PQ offload is supported by a
>>>> DMA device then all 256 PQ coefficients are supported. This assumption
>>>> does not hold anymore because we now have BCM-SBA-RAID offload engine
>>>> which supports PQ offload with limited number of PQ coefficients.
>>>>
>>>> This patch extends async_tx APIs to handle DMA devices with support
>>>> for fewer PQ coefficients.
>>>>
>>>> Signed-off-by: Anup Patel <anup.patel@broadcom.com>
>>>> Reviewed-by: Scott Branden <scott.branden@broadcom.com>
>>>
>>> I don't like this approach. Define an interface for md to query the
>>> offload engine once at the beginning of time. We should not be adding
>>> any new extensions to async_tx.
>>
>> Even if we do capability checks in Linux MD, we still need a way
>> for DMAENGINE drivers to advertise number of PQ coefficients
>> handled by the HW.
>>
>> I agree capability checks should be done once in Linux MD but I don't
>> see why this has to be part of BCM-SBA-RAID driver patches. We need
>> separate patchsets to address limitations of async_tx framework.
>
> Right, separate enabling before we pile on new hardware support to a
> known broken framework.

Linux Async Tx not broken framework. The issue is:
1. Its not complete enough
2. Its not optimized for very high through-put offload engines

Regards,
Anup
