From: Matthias Brugger <matthias.bgg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v1 2/2] crypto: mediatek - add DT bindings documentation
Date: Fri, 9 Dec 2016 10:45:00 +0100
Message-ID: <826b263f-8963-11c9-0302-8048cd1dea8e@gmail.com>
References: <1480921284-45827-1-git-send-email-ryder.lee@mediatek.com>
 <1480921284-45827-3-git-send-email-ryder.lee@mediatek.com>
 <4b0df417-825f-65c6-4c02-85fe1c20ce50@gmail.com>
 <1481188776.14860.26.camel@mtkswgap22>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Cc: Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>,
        "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>,
        devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mediatek-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org,
        linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
        linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org,
        Sean Wang <sean.wang-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org>,
        Roy Luo <cheng-hao.luo-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org>
To: Ryder Lee <ryder.lee-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org>
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1481188776.14860.26.camel@mtkswgap22>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org



On 08/12/16 10:19, Ryder Lee wrote:
> Hello,
>
> On Mon, 2016-12-05 at 11:18 +0100, Matthias Brugger wrote:
>>
>> On 05/12/16 08:01, Ryder Lee wrote:
>>> Add DT bindings documentation for the crypto driver
>>>
>>> Signed-off-by: Ryder Lee <ryder.lee-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org>
>>> ---
>>>  .../devicetree/bindings/crypto/mediatek-crypto.txt | 32 ++++++++++++++++++++++
>>>  1 file changed, 32 insertions(+)
>>>  create mode 100644 Documentation/devicetree/bindings/crypto/mediatek-crypto.txt
>>>
>>> diff --git a/Documentation/devicetree/bindings/crypto/mediatek-crypto.txt b/Documentation/devicetree/bindings/crypto/mediatek-crypto.txt
>>> new file mode 100644
>>> index 0000000..8b1db08
>>> --- /dev/null
>>> +++ b/Documentation/devicetree/bindings/crypto/mediatek-crypto.txt
>>> @@ -0,0 +1,32 @@
>>> +MediaTek cryptographic accelerators
>>> +
>>> +Required properties:
>>> +- compatible: Should be "mediatek,mt7623-crypto"
>>
>> Do you know how big the difference is between the crypto engine for
>> mt7623/mt2701/mt8521p in comparison, let's say mt8173 or mt6797?
>> Do this SoCs have a crypot engine? If so and they are quite similar, we
>> might think of adding a mtk-crypto binding and add soc specific bindings.
>
> This engine is just available in mt7623/mt2701/mt8521p series SoCs and
> they have no difference.
>
> But there are still other crypto IPs in MTK, i think maybe we could use
> "mediatek,{IP name}-crypto” to distinguish them ?
>

Sounds good, thanks for the clarification.

Matthias


>> Regards,
>> Matthias
>>
>>> +- reg: Address and length of the register set for the device
>>> +- interrupts: Should contain the five crypto engines interrupts in numeric
>>> +	order. These are global system and four descriptor rings.
>>> +- clocks: the clock used by the core
>>> +- clock-names: the names of the clock listed in the clocks property. These are
>>> +	"ethif", "cryp"
>>> +- power-domains: Must contain a reference to the PM domain.
>>> +
>>> +
>>> +Optional properties:
>>> +- interrupt-parent: Should be the phandle for the interrupt controller
>>> +  that services interrupts for this device
>>> +
>>> +
>>> +Example:
>>> +	crypto: crypto@1b240000 {
>>> +		compatible = "mediatek,mt7623-crypto";
>>> +		reg = <0 0x1b240000 0 0x20000>;
>>> +		interrupts = <GIC_SPI 82 IRQ_TYPE_LEVEL_LOW>,
>>> +			     <GIC_SPI 83 IRQ_TYPE_LEVEL_LOW>,
>>> +			     <GIC_SPI 84 IRQ_TYPE_LEVEL_LOW>,
>>> +			     <GIC_SPI 91 IRQ_TYPE_LEVEL_LOW>,
>>> +			     <GIC_SPI 97 IRQ_TYPE_LEVEL_LOW>;
>>> +		clocks = <&topckgen CLK_TOP_ETHIF_SEL>,
>>> +			 <&ethsys CLK_ETHSYS_CRYPTO>;
>>> +		clock-names = "ethif","cryp";
>>> +		power-domains = <&scpsys MT2701_POWER_DOMAIN_ETH>;
>>> +	};
>>>
>
>
--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
