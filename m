From: Zain <zain.wang@rock-chips.com>
Subject: Re: [RESEND PATCH 4/4] crypto: rk_crypto - add DT bindings
 documentation
Date: Mon, 2 Nov 2015 17:13:38 +0800
Message-ID: <56372942.2080900@rock-chips.com>
References: <1446193369-4453-1-git-send-email-zain.wang@rock-chips.com>
 <1446193369-4453-5-git-send-email-zain.wang@rock-chips.com>
 <20151030140334.GB31073@leverpostej>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: zhengsq@rock-chips.com, hl@rock-chips.com,
	herbert@gondor.apana.org.au, davem@davemloft.net,
	mturquette@baylibre.com, heiko@sntech.de, pawel.moll@arm.com,
	ijc+devicetree@hellion.org.uk, robh+dt@kernel.org,
	galak@codeaurora.org, linux@arm.linux.org.uk,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	linux-rockchip@lists.infradead.org, devicetree@vger.kernel.org,
	eddie.cai@rock-chips.com
To: Mark Rutland <mark.rutland@arm.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from regular1.263xmail.com ([211.150.99.134]:52010 "EHLO
	regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751061AbbKBJOH (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 2 Nov 2015 04:14:07 -0500
In-Reply-To: <20151030140334.GB31073@leverpostej>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Mark

On 2015=E5=B9=B410=E6=9C=8830=E6=97=A5 22:03, Mark Rutland wrote:
> On Fri, Oct 30, 2015 at 04:22:49PM +0800, Zain Wang wrote:
>> Add DT bindings documentation for the rk3288 crypto drivers.
>>
>> Signed-off-by: Zain Wang <zain.wang@rock-chips.com>
>> ---
>>  .../devicetree/bindings/crypto/rk-crypto.txt       | 31 +++++++++++=
+++++++++++
>>  1 file changed, 31 insertions(+)
>>  create mode 100644 Documentation/devicetree/bindings/crypto/rk-cryp=
to.txt
>>
>> diff --git a/Documentation/devicetree/bindings/crypto/rk-crypto.txt =
b/Documentation/devicetree/bindings/crypto/rk-crypto.txt
>> new file mode 100644
>> index 0000000..1e50768
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/crypto/rk-crypto.txt
>> @@ -0,0 +1,31 @@
>> +Rockchip Electronics And Security Accelerator
>> +
>> +Required properties:
>> +- compatible: should be "rockchip,crypto"
> Choose a more specific name. Rockchip could easily come up with anoth=
er
> crypto accelerator later.
ok! done.
rk3288_crypto may be better than crypto.
>> +- reg: base physical address of the engine and length of memory map=
ped
>> +       region.
>> +- interrupts: interrupt number
>> +- clocks: clock specifiers
>> +- clock-names: "aclk_crypto" used to clock data
>> +			   "hclk_crypto" used to clock data
>> +			   "srst_crypto" used to clock crypto accelerator
>> +			   "apb_pclk"    used to clock dma
>> +-status: Enable
> No need to mention the status property.
ok! done!
> Thanks,
> Mark.
>
>> +
>> +Examples:
>> +
>> +	crypto: cypto-controller@ff8a0000 {
>> +		compatible =3D "rockchip,crypto";
>> +		reg =3D <0xff8a0000 0x4000>;
>> +		interrupts =3D <GIC_SPI 48 IRQ_TYPE_LEVEL_HIGH>;
>> +		clocks =3D <&cru ACLK_CRYPTO>,
>> +			 <&cru HCLK_CRYPTO>,
>> +			 <&cru SRST_CRYPTO>,
>> +			 <&cru ACLK_DMAC1>;
>> +
>> +		clock-names =3D "aclk_crypto",
>> +			      "hclk_crypto",
>> +			      "srst_crypto",
>> +				  "apb_pclk";
>> +		status =3D "okay";
>> +	};
>> --=20
>> 1.9.1
>>
>>
>
Thanks
Zain
