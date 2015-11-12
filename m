From: Zain <zain.wang@rock-chips.com>
Subject: Re: [PATCH v3 1/4] crypto: rockchip/crypto - add DT bindings
 documentation
Date: Thu, 12 Nov 2015 09:15:21 +0800
Message-ID: <5643E829.5030002@rock-chips.com>
References: <1447223759-20730-1-git-send-email-zain.wang@rock-chips.com>
 <1447223759-20730-2-git-send-email-zain.wang@rock-chips.com>
 <20151111202405.GA6512@rob-hp-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: zhengsq@rock-chips.com, hl@rock-chips.com,
	herbert@gondor.apana.org.au, davem@davemloft.net,
	mturquette@baylibre.com, heiko@sntech.de, pawel.moll@arm.com,
	ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
	linux@arm.linux.org.uk, mark.rutland@arm.com,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	linux-rockchip@lists.infradead.org, devicetree@vger.kernel.org,
	eddie.cai@rock-chips.com
To: Rob Herring <robh@kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from regular1.263xmail.com ([211.150.99.134]:50305 "EHLO
	regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752394AbbKLBP0 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 11 Nov 2015 20:15:26 -0500
In-Reply-To: <20151111202405.GA6512@rob-hp-laptop>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Rob,

On 2015=E5=B9=B411=E6=9C=8812=E6=97=A5 04:24, Rob Herring wrote:
> On Wed, Nov 11, 2015 at 02:35:56PM +0800, Zain Wang wrote:
>> Add DT bindings documentation for the rk3288 crypto drivers.
>>
>> Signed-off-by: Zain Wang <zain.wang@rock-chips.com>
> Acked-by: Rob Herring <robh@kernel.org>
Thanks you for responding.

-Zain
>
>> ---
>>
>> Changed in v3:
>> - add reset property
>>
>> Changed in v2:
>> - None
>>
>> Changed in v1:
>> - remove the _crypto suffix
>> - use "rockchip,rk3288-crypto" instead of "rockchip,rk3288"
>> - remove the description of status
>>
>>
>>  .../devicetree/bindings/crypto/rockchip-crypto.txt | 29 +++++++++++=
+++++++++++
>>  1 file changed, 29 insertions(+)
>>  create mode 100644 Documentation/devicetree/bindings/crypto/rockchi=
p-crypto.txt
>>
>> diff --git a/Documentation/devicetree/bindings/crypto/rockchip-crypt=
o.txt b/Documentation/devicetree/bindings/crypto/rockchip-crypto.txt
>> new file mode 100644
>> index 0000000..096df34
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/crypto/rockchip-crypto.txt
>> @@ -0,0 +1,29 @@
>> +Rockchip Electronics And Security Accelerator
>> +
>> +Required properties:
>> +- compatible: Should be "rockchip,rk3288-crypto"
>> +- reg: Base physical address of the engine and length of memory map=
ped
>> +       region
>> +- interrupts: Interrupt number
>> +- clocks: Reference to the clocks about crypto
>> +- clock-names: "aclk" used to clock data
>> +	       "hclk" used to clock data
>> +	       "sclk" used to clock crypto accelerator
>> +	       "apb_pclk" used to clock dma
>> +- resets: Must contain an entry for each entry in reset-names.
>> +	  See ../reset/reset.txt for details.
>> +- reset-names: Must include the name "crypto-rst".
>> +
>> +Examples:
>> +
>> +	crypto: cypto-controller@ff8a0000 {
>> +		compatible =3D "rockchip,rk3288-crypto";
>> +		reg =3D <0xff8a0000 0x4000>;
>> +		interrupts =3D <GIC_SPI 48 IRQ_TYPE_LEVEL_HIGH>;
>> +		clocks =3D <&cru ACLK_CRYPTO>, <&cru HCLK_CRYPTO>,
>> +			 <&cru SCLK_CRYPTO>, <&cru ACLK_DMAC1>;
>> +		clock-names =3D "aclk", "hclk", "sclk", "apb_pclk";
>> +		resets =3D <&cru SRST_CRYPTO>;
>> +		reset-names =3D "crypto-rst";
>> +		status =3D "okay";
>> +	};
>> --=20
>> 1.9.1
>>
>>
>
>
