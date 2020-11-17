Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F778C8300A
	for <linux-crypto@archiver.kernel.org>; Tue, 17 Nov 2020 14:09:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E978620729
	for <linux-crypto@archiver.kernel.org>; Tue, 17 Nov 2020 14:09:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728411AbgKQOI7 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 17 Nov 2020 09:08:59 -0500
Received: from foss.arm.com ([217.140.110.172]:58580 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729498AbgKQOH4 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 17 Nov 2020 09:07:56 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C0635101E;
        Tue, 17 Nov 2020 06:07:55 -0800 (PST)
Received: from [10.57.60.109] (unknown [10.57.60.109])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 572773F718;
        Tue, 17 Nov 2020 06:07:54 -0800 (PST)
Subject: Re: [PATCH 1/2] dt-bindings: crypto: update ccree optional params
To:     Rob Herring <robh@kernel.org>,
        Gilad Ben-Yossef <gilad@benyossef.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Ofir Drang <ofir.drang@arm.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>,
        Steven Price <steven.price@arm.com>
References: <20200916071950.1493-1-gilad@benyossef.com>
 <20200916071950.1493-2-gilad@benyossef.com> <20200923015702.GA3676455@bogus>
 <CAOtvUMekoMjFij_xDnrwRj2PsfgO8tKx4Jk6d7C5vq-Vh+boWw@mail.gmail.com>
 <CAOtvUMfAKnodo+7EYx2M4yAvxu_VmxwXNRmgOW=KFWi3Wy7msQ@mail.gmail.com>
 <CAL_JsqJditVYJ=4K9i11BjoV2ejABnuMbRyLtm8+e93ApUTu9w@mail.gmail.com>
From:   Robin Murphy <robin.murphy@arm.com>
Message-ID: <1450044c-5150-1da2-11e0-2ae48d8b4d0c@arm.com>
Date:   Tue, 17 Nov 2020 14:07:19 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; rv:78.0) Gecko/20100101
 Thunderbird/78.4.3
MIME-Version: 1.0
In-Reply-To: <CAL_JsqJditVYJ=4K9i11BjoV2ejABnuMbRyLtm8+e93ApUTu9w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 2020-11-16 18:54, Rob Herring wrote:
> On Thu, Oct 22, 2020 at 1:18 AM Gilad Ben-Yossef <gilad@benyossef.com> wrote:
>>
>>
>> Hi again,
>>
>> Any opinion on the suggested below?
> 
> Sorry, lost in the pile...
> 
>> Thanks!
>> Gilad
>>
>>
>> On Tue, Sep 29, 2020 at 9:08 PM Gilad Ben-Yossef <gilad@benyossef.com> wrote:
>>>
>>>
>>> On Wed, Sep 23, 2020 at 4:57 AM Rob Herring <robh@kernel.org> wrote:
>>>>
>>>> On Wed, Sep 16, 2020 at 10:19:49AM +0300, Gilad Ben-Yossef wrote:
>>>>> Document ccree driver supporting new optional parameters allowing to
>>>>> customize the DMA transactions cache parameters and ACE bus sharability
>>>>> properties.
>>>>>
>>>>> Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
>>>>> ---
>>>>>   Documentation/devicetree/bindings/crypto/arm-cryptocell.txt | 4 ++++
>>>>>   1 file changed, 4 insertions(+)
>>>>>
>>>>> diff --git a/Documentation/devicetree/bindings/crypto/arm-cryptocell.txt b/Documentation/devicetree/bindings/crypto/arm-cryptocell.txt
>>>>> index 6130e6eb4af8..1a1603e457a8 100644
>>>>> --- a/Documentation/devicetree/bindings/crypto/arm-cryptocell.txt
>>>>> +++ b/Documentation/devicetree/bindings/crypto/arm-cryptocell.txt
>>>>> @@ -13,6 +13,10 @@ Required properties:
>>>>>   Optional properties:
>>>>>   - clocks: Reference to the crypto engine clock.
>>>>>   - dma-coherent: Present if dma operations are coherent.
>>>>> +- awcache: Set write transactions cache attributes
>>>>> +- arcache: Set read transactions cache attributes
>>>>
>>>> dma-coherent already implies these are 011x, 101x or 111x. In my limited
>>>> experience configuring these (Calxeda SATA and ethernet), writeback,
>>>> write-allocate was pretty much always optimal.
>>>
>>> Indeed and these are the default. But not all SoC are born equal and
>>> we got a request to allow setting these.
>>>
>>> Maybe instead of numerical values have three possible verbal setting
>>> would be better?
>>>
>>>
>>>>> +- awdomain: Set write transactions ACE sharability domain (712, 703, 713 only)
>>>>> +- ardomain: Set read transactions ACE sharability domain (712, 703, 713 only)
>>>>
>>>> This probably needs something common. We may need something for Mali,
>>>> too. I don't think different settings for read and write makes much
>>>> sense nor does anything beyond IS or OS.
>>>
>>> I agree. Maybe
>>>
>>> sharability_domain: either "IS" or "OS"?
> 
> It's still an Arm thing, so it would need at least an 'arm,' prefix.
> But ideally it wouldn't be Arm specific though I'm not sure if any
> such thing is needed for other arches. If common either for Arm or
> across arches, then it needs to be documented in a common doc with
> some wider agreement than what a device specific property needs.

"dma-coherent" already encapsulates the shareability. To claim coherency 
you need to be able to access memory with inner shareable inner-outer 
write back attributes, because that's how regular kernel memory is 
mapped. If you don't claim coherency, then you should be using 
non-cacheable (and thus implicitly outer shareable) attributes, because 
there may still be cacheable aliases hanging around and if you 
inadvertently snoop those instead of going direct to DRAM as everything 
else expects, you're going to have a bad time.

Essentially, Linux only uses two sets of memory attributes for DMA 
memory, so any perceived need for more than that is already something 
sufficiently esoteric that it probably doesn't need a generic binding. 
I'm aware that it's against type for me to be arguing Linux details in a 
DT binding, but I checked the TRMs for some of these devices and they 
essentially say "you don't program the hardware directly, you use the 
Linux driver we give you", so it seems like this binding is specifically 
intended never to be consumed by anything else.

>>>> These could also just be implied by the compatible string (and requiring
>>>> an SoC specific one).
>>>
>>> hm... we could do it but this will require us to know (and publicly
>>> acknowledge) of every SoC making use of this piece of hardware design.
> 
> That's already a requirement in general. Sometimes we can avoid it,
> but that's cases of getting lucky.
> 
>>> There is currently no other part of the driver that needs this.
> 
> If your DT is part of firmware, then waiting until adding some driver
> feature or quirk based on a new DT property is too late. Whereas with
> a SoC specific compatible, you can handle any new feature or quirk
> without a DT change (e.g. just a stable kernel update). Some platforms
> may not care about that model, but in general that's the policy we
> follow. Not doing that, we end up with the DWC3 binding.
> 
> A fallback compatible is how we avoid updating drivers for every
> single SoC unless needed.

IMO if this is like PL330 where you just stick some raw AXI attributes 
in a register and that's what goes out on transactions then it's not 
really part of the platform description anyway, it's just driver policy. 
If folks want to tweak the driver's behaviour for secret SoC-specific 
performance optimisation, then give them some module parameters or a 
sysfs interface. I'm assuming this has to be purely a performance thing, 
because I can't see how two different integrations could reasonably 
depend on different baseline attributes for correctness, and even if 
they did then you'd be able to determine that from the compatible 
strings, because they would be different, because those integrations 
would be fundamentally *not* compatible with each other.

Robin.
