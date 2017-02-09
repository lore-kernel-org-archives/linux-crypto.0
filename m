From: Anup Patel <anup.patel-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH v2 2/5] async_tx: Handle DMA devices having support for
 fewer PQ coefficients
Date: Thu, 9 Feb 2017 14:59:35 +0530
Message-ID: <CAALAos-ua6hVpUqjnJSQ=ysSOKrN67toiT3J808uHC4A_ZV3mg@mail.gmail.com>
References: <1486455406-11202-1-git-send-email-anup.patel@broadcom.com>
 <1486455406-11202-3-git-send-email-anup.patel@broadcom.com>
 <CAPcyv4gbV1yf52JrejW+Dn3wOPn7Er+8HWdu2qsW0+Qm+cRr9g@mail.gmail.com>
 <CAALAos_yhXufdt79KWY0eugjF5oyJ8+NcPh2E-dEXnSQu2WhhA@mail.gmail.com>
 <CAPcyv4hK_1f8bryq6smPQy7vTnP+QEzmT9wnAEE1xpxq7EAnjQ@mail.gmail.com>
 <CAALAos9ovab4x=waRgM7G2adRC7syHMkY0Rhf-UPB_+h4w3yNQ@mail.gmail.com> <CAPcyv4iFJXxvJFrUs2jtwP9GX5NcJ8LiEDHeZ5b1fwjCAToe5w@mail.gmail.com>
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
In-Reply-To: <CAPcyv4iFJXxvJFrUs2jtwP9GX5NcJ8LiEDHeZ5b1fwjCAToe5w-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

On Wed, Feb 8, 2017 at 9:54 PM, Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
> On Wed, Feb 8, 2017 at 12:57 AM, Anup Patel <anup.patel-dY08KVG/lbpWk0Htik3J/w@public.gmane.org> wrote:
>> On Tue, Feb 7, 2017 at 11:46 PM, Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
>>> On Tue, Feb 7, 2017 at 1:02 AM, Anup Patel <anup.patel-dY08KVG/lbpWk0Htik3J/w@public.gmane.org> wrote:
>>>> On Tue, Feb 7, 2017 at 1:57 PM, Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
>>>>> On Tue, Feb 7, 2017 at 12:16 AM, Anup Patel <anup.patel-dY08KVG/lbpWk0Htik3J/w@public.gmane.org> wrote:
>>>>>> The DMAENGINE framework assumes that if PQ offload is supported by a
>>>>>> DMA device then all 256 PQ coefficients are supported. This assumption
>>>>>> does not hold anymore because we now have BCM-SBA-RAID offload engine
>>>>>> which supports PQ offload with limited number of PQ coefficients.
>>>>>>
>>>>>> This patch extends async_tx APIs to handle DMA devices with support
>>>>>> for fewer PQ coefficients.
>>>>>>
>>>>>> Signed-off-by: Anup Patel <anup.patel-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
>>>>>> Reviewed-by: Scott Branden <scott.branden-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
>>>>>
>>>>> I don't like this approach. Define an interface for md to query the
>>>>> offload engine once at the beginning of time. We should not be adding
>>>>> any new extensions to async_tx.
>>>>
>>>> Even if we do capability checks in Linux MD, we still need a way
>>>> for DMAENGINE drivers to advertise number of PQ coefficients
>>>> handled by the HW.
>>>>
>>>> I agree capability checks should be done once in Linux MD but I don't
>>>> see why this has to be part of BCM-SBA-RAID driver patches. We need
>>>> separate patchsets to address limitations of async_tx framework.
>>>
>>> Right, separate enabling before we pile on new hardware support to a
>>> known broken framework.
>>
>> Linux Async Tx not broken framework. The issue is:
>> 1. Its not complete enough
>> 2. Its not optimized for very high through-put offload engines
>
> I'm not understanding your point. I'm nak'ing this change to add yet
> more per-transaction capability checking to async_tx. I don't like the
> DMA_HAS_FEWER_PQ_COEF flag, especially since it is equal to
> DMA_HAS_PQ_CONTINUE. I'm not asking for all of async_tx's problems to
> be fixed before this new hardware support, I'm simply saying we should
> start the process of moving offload-engine capability checking to the
> raid code.

The DMA_HAS_FEWER_PQ_COEF is not equal to
DMA_HAS_PQ_CONTINUE.

I will try to drop this patch and take care of unsupported PQ
coefficients in BCM-SBA-RAID driver itself even if this means
doing some computations in BCM-SBA-RAID driver itself.

Regards,
Anup
--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
