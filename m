From: Matthias Brugger <matthias.bgg@gmail.com>
Subject: Re: [PATCH 1/4] dt-bindings: rng: add generic bindings for MediaTek
 SoCs
Date: Wed, 7 Jun 2017 15:25:59 +0200
Message-ID: <a8b797e9-db6f-7f92-2cee-72d456815310@gmail.com>
References: <cover.1496255334.git.sean.wang@mediatek.com>
 <1d9c981e1b45bf2f04732a02d90e6857cc203ce5.1496255334.git.sean.wang@mediatek.com>
 <9eb87222-ca89-0abb-4532-3887008f6e7a@gmail.com>
 <1496841619.30833.5.camel@mtkswgap22>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: herbert@gondor.apana.org.au, mpm@selenic.com, robh+dt@kernel.org,
        mark.rutland@arm.com, clabbe.montjoie@gmail.com,
        prasannatsmkumar@gmail.com, romain.perier@free-electrons.com,
        shannon.nelson@oracle.com, devicetree@vger.kernel.org,
        keyhaede@gmail.com, linux-kernel@vger.kernel.org,
        linux-mediatek@lists.infradead.org, linux-crypto@vger.kernel.org,
        weiyongjun1@huawei.com, linux-arm-kernel@lists.infradead.org
To: Sean Wang <sean.wang@mediatek.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:34828 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751535AbdFGN0H (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 7 Jun 2017 09:26:07 -0400
In-Reply-To: <1496841619.30833.5.camel@mtkswgap22>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>



On 07/06/17 15:20, Sean Wang wrote:
> On Tue, 2017-06-06 at 13:07 +0200, Matthias Brugger wrote:
>>
>> On 31/05/17 20:44, sean.wang@mediatek.com wrote:
>>> From: Sean Wang <sean.wang@mediatek.com>
>>>
>>> Add the generic binding for allowing the support of RNG on MediaTek SoCs
>>> such as MT7622.
>>>
>>> Signed-off-by: Sean Wang <sean.wang@mediatek.com>
>>> ---
>>>    Documentation/devicetree/bindings/rng/mtk-rng.txt | 3 ++-
>>>    1 file changed, 2 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/Documentation/devicetree/bindings/rng/mtk-rng.txt b/Documentation/devicetree/bindings/rng/mtk-rng.txt
>>> index a6d62a2..0772913 100644
>>> --- a/Documentation/devicetree/bindings/rng/mtk-rng.txt
>>> +++ b/Documentation/devicetree/bindings/rng/mtk-rng.txt
>>> @@ -2,7 +2,8 @@ Device-Tree bindings for Mediatek random number generator
>>>    found in Mediatek SoC family
>>>    
>>>    Required properties:
>>> -- compatible	    : Should be "mediatek,mt7623-rng"
>>> +- compatible	    : Should be "mediatek,generic-rng" or
>>> +				"mediatek,mt7623-rng".
>>
>> What does generic-rng mean. Is it for all mt7xxx, or also for mt6xxx and
>> mt8xxx based SoCs? I think we should stick with SoC specific bindings,
>> as we don't know if Mediatek won't publish a new IP block next year
>> which is differnet.
>>
> 
> Yes, what I mean is generic-rng can be applied to all
> platform MediaTek provides.
> 
> 
>> Just in case we should add a binding for the actual SoC + a fallback.
>> For example.
>> - compatible " Should be
>> 	"mediatek,mt7622-rng", 	"mediatek,mt7623-rng" for SoC mt7622
>> 	"mediatek,mt7623-rng" for SoC mt7623
>>
>> This will also eliminate the need of adding mt6722-rng to the driver, as
>> it will use mt7623-rng as fallback. If in the future we realize that
>> mt7622-rng has a extra feature/bug, we can still work around it, without
>> breaking the bindings.
>>
> 
> I knew the fallback rules you said here because I saw them being used in
> many drivers such as sysirq and uart driver, such kind of basic drivers.
> 
> These drivers are basic enough, various following chipsets almost fall
> back into the oldest one. So the clues let me think the hardware
> interface shouldn't have too much differences among them.
> 
> If there is string used like generic-uart or generic-sysirq, it can
> stop we blindly add new string into the binding document when a new
> platform is introduced.
> 
> And they easily allows users unfamiliar MediaTek platform (they didn't
> know what the oldest MediaTek chipset is) pick up the right compatible
> string to start bring up the new platform.
> 
> The specific one can be added after new feature required is added or
> critical hardware bug is found. Otherwise the generic one can fit
> all generic needs for those.
> 
> Those are only opinions, if you don't like it, I still can accept the
> original way as you suggest :)
> 

I can see your reasoning, but the device tree maintainers prefer to have 
the bindings updated for a new SoC. As I mentioned before, just imagine 
next year Mediatek changes the IP block and from now on, it uses the new 
device in all SoCs. In 5 years we would have a binding which states 
'generic' although it is not compatible with any SoC of the last So

So please keep with the bindings as done up to now.

Best regards,
Matthias

> 
>> Makes sense?
>>
>> Regards,
>> Matthias
>>
>>>    - clocks	    : list of clock specifiers, corresponding to
>>>    		      entries in clock-names property;
>>>    - clock-names	    : Should contain "rng" entries;
>>>
> 
> 
