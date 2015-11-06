From: Zain <zain.wang-TNX95d0MmH7DzftRWevZcw@public.gmane.org>
Subject: Re: [PATCH v2 4/4] crypto: rockchip/crypto - add DT bindings
 documentation
Date: Fri, 6 Nov 2015 17:36:40 +0800
Message-ID: <563C74A8.3000409@rock-chips.com>
References: <1446772644-2352-1-git-send-email-zain.wang@rock-chips.com>
 <1446772644-2352-5-git-send-email-zain.wang@rock-chips.com>
 <5400475.WGQH63T0iE@phil>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: zhengsq-TNX95d0MmH7DzftRWevZcw@public.gmane.org, hl-TNX95d0MmH7DzftRWevZcw@public.gmane.org,
	herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org, davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org,
	mturquette-rdvid1DuHRBWk0Htik3J/w@public.gmane.org, pawel.moll-5wv7dgnIgG8@public.gmane.org,
	ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org, robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org,
	galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org,
	linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-rockchip-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	eddie.cai-TNX95d0MmH7DzftRWevZcw@public.gmane.org
To: Heiko Stuebner <heiko-4mtYJXux2i+zQB+pC5nmwQ@public.gmane.org>
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5400475.WGQH63T0iE@phil>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

Hi

On 2015=E5=B9=B411=E6=9C=8806=E6=97=A5 17:00, Heiko Stuebner wrote:
> Am Freitag, 6. November 2015, 09:17:24 schrieb Zain Wang:
>> Add DT bindings documentation for the rk3288 crypto drivers.
>>
>> Signed-off-by: Zain Wang <zain.wang-TNX95d0MmH7DzftRWevZcw@public.gmane.org>
>> ---
>>
>> Changde in v2:
>> - None
>>
>> Changed in v1:
>> - remove the _crypto suffix
>> - use "rockchip,rk3288-crypto" instead of "rockchip,rk3288"
>> - remove the description of status
>>
>>  .../devicetree/bindings/crypto/rockchip-crypto.txt | 29=20
> ++++++++++++++++++++++
>>  1 file changed, 29 insertions(+)
>>  create mode 100644 Documentation/devicetree/bindings/crypto/rockchi=
p-
> crypto.txt
>> diff --git a/Documentation/devicetree/bindings/crypto/rockchip-crypt=
o.txt=20
> b/Documentation/devicetree/bindings/crypto/rockchip-crypto.txt
>> new file mode 100644
>> index 0000000..d27e203
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/crypto/rockchip-crypto.txt
>> @@ -0,0 +1,29 @@
>> +Rockchip Electronics And Security Accelerator
>> +
>> +Required properties:
>> +- compatible: Should be "rockchip,rk3288-crypto"
>> +- reg: base physical address of the engine and length of memory map=
ped
>> +       region
>> +- interrupts: interrupt number
>> +- clocks: reference to the clocks about crypto
>> +- clock-names: "aclk" used to clock data
>> +	       "hclk" used to clock data
>> +	       "srst" used to clock crypto accelerator
> mistmatch between description and example. I think you mean "sclk" in=
stead of=20
> "srst", like we talked about in the first version.
I am sorry that forgetting to change it here.
You can see I have changed it in other part like example below.
>
>> +	       "apb_pclk" used to clock dma
>> +
>> +Examples:
>> +
>> +	crypto: cypto-controller@ff8a0000 {
>> +		compatible =3D "rockchip,rk3288-crypto";
>> +		reg =3D <0xff8a0000 0x4000>;
>> +		interrupts =3D <GIC_SPI 48 IRQ_TYPE_LEVEL_HIGH>;
>> +		clocks =3D <&cru ACLK_CRYPTO>,
>> +			 <&cru HCLK_CRYPTO>,
>> +			 <&cru SCLK_CRYPTO>,
>> +			 <&cru ACLK_DMAC1>;
>> +		clock-names =3D "aclk",
>> +			      "hclk",
>> +			      "sclk",
>> +			      "apb_pclk";
>> +		status =3D "okay";
>> +	};
>>
>
>
>
Thanks
Zain

--
To unsubscribe from this list: send the line "unsubscribe devicetree" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
