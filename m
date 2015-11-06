From: Zain <zain.wang@rock-chips.com>
Subject: Re: [PATCH v2 3/4] ARM: dts: rockchip: Add Crypto drivers for rk3288
Date: Fri, 6 Nov 2015 17:50:15 +0800
Message-ID: <563C77D7.4010701@rock-chips.com>
References: <1446772644-2352-1-git-send-email-zain.wang@rock-chips.com>
 <1446772644-2352-4-git-send-email-zain.wang@rock-chips.com>
 <563C09D3.1050508@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: zhengsq@rock-chips.com, hl@rock-chips.com,
	herbert@gondor.apana.org.au, davem@davemloft.net,
	mturquette@baylibre.com, heiko@sntech.de, pawel.moll@arm.com,
	ijc+devicetree@hellion.org.uk, robh+dt@kernel.org,
	galak@codeaurora.org, linux@arm.linux.org.uk,
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-rockchip@lists.infradead.org, eddie.cai@rock-chips.com,
	linux-crypto@vger.kernel.org
To: Caesar Wang <caesar.upstream@gmail.com>, mark.rutland@arm.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from regular1.263xmail.com ([211.150.99.133]:54494 "EHLO
	regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030698AbbKFJu1 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 6 Nov 2015 04:50:27 -0500
In-Reply-To: <563C09D3.1050508@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi:

On 2015=E5=B9=B411=E6=9C=8806=E6=97=A5 10:00, Caesar Wang wrote:
> the subject should be add the node/info for crypto...
ok! done!
>
> =E5=9C=A8 2015=E5=B9=B411=E6=9C=8806=E6=97=A5 09:17, Zain Wang =E5=86=
=99=E9=81=93:
>> Add Crypto drivers for rk3288 including crypto controller and dma cl=
k.
>>
>> Signed-off-by: Zain Wang <zain.wang@rock-chips.com>
>> ---
>>
>> Changed in v2:
>> - None
>>
>> Changed in v1:
>> - remove the _crypto suffix
>> - use "rockchip,rk3288-crypto" instead of "rockchip,rk3288"
>>
>>   arch/arm/boot/dts/rk3288.dtsi | 15 +++++++++++++++
>>   1 file changed, 15 insertions(+)
>>
>> diff --git a/arch/arm/boot/dts/rk3288.dtsi
>> b/arch/arm/boot/dts/rk3288.dtsi
>> index 6a79c9c..7b7914e 100644
>> --- a/arch/arm/boot/dts/rk3288.dtsi
>> +++ b/arch/arm/boot/dts/rk3288.dtsi
>> @@ -170,6 +170,21 @@
>>           };
>>       };
>>   +    crypto: cypto-controller@ff8a0000 {
>> +        compatible =3D "rockchip,rk3288-crypto";
>> +        reg =3D <0xff8a0000 0x4000>;
>> +        interrupts =3D <GIC_SPI 48 IRQ_TYPE_LEVEL_HIGH>;
>> +        clocks =3D <&cru ACLK_CRYPTO>,
>> +             <&cru HCLK_CRYPTO>,
>> +             <&cru SCLK_CRYPTO>,
>> +             <&cru ACLK_DMAC1>;
>> +        clock-names =3D "aclk",
>> +                  "hclk",
>> +                  "sclk",
>> +                  "apb_pclk";
>
> I guess  you can do this:
>
> clocks =3D <&cru ACLK_CRYPTO>, <&cru HCLK_CRYPTO>,  <&cru SCLK_CRYPTO=
>,=20
> <&cru ACLK_DMAC1>;
>
> clock-names =3D "aclk", "hclk",  "sclk", "apb_pclk";
ok! done!
>
>
>> +        status =3D "okay";
>> +    };
>> +
>>       reserved-memory {
>>           #address-cells =3D <1>;
>>           #size-cells =3D <1>;
>
>
