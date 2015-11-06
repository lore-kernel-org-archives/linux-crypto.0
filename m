From: Zain <zain.wang-TNX95d0MmH7DzftRWevZcw@public.gmane.org>
Subject: Re: [PATCH v2 0/4] Crypto: add crypto accelerator support for rk3288
Date: Fri, 6 Nov 2015 17:53:32 +0800
Message-ID: <563C789C.8020106@rock-chips.com>
References: <1446772644-2352-1-git-send-email-zain.wang@rock-chips.com>
 <563C0430.9000607@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-rockchip-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, eddie.cai-TNX95d0MmH7DzftRWevZcw@public.gmane.org,
	linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Caesar Wang <caesar.upstream-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, zhengsq-TNX95d0MmH7DzftRWevZcw@public.gmane.org,
	hl-TNX95d0MmH7DzftRWevZcw@public.gmane.org, herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org,
	davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org, mturquette-rdvid1DuHRBWk0Htik3J/w@public.gmane.org, heiko-4mtYJXux2i+zQB+pC5nmwQ@public.gmane.org,
	pawel.moll-5wv7dgnIgG8@public.gmane.org, ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org,
	robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org,
	mark.rutland-5wv7dgnIgG8@public.gmane.org
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <563C0430.9000607-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org



On 2015=E5=B9=B411=E6=9C=8806=E6=97=A5 09:36, Caesar Wang wrote:
> Hi
>
> =E5=9C=A8 2015=E5=B9=B411=E6=9C=8806=E6=97=A5 09:17, Zain Wang =E5=86=
=99=E9=81=93:
>> This commit support three cipher(AES/DES/DES3) and two
>> chainmode(ecb/cbc),
>> and the more algorithms and new hash drivers will be added later on.
>>
>> Changed in v2:
>> - remove some part about hash
>> - add weak key detection
>> - changed some variate's type
>>
>> Changed in v1:
>> - modify some variate's name
>> - modify some variate's type
>> - modify some return value
>> - remove or modify some print info
>> - use more dev_xxx in probe
>> - modify the prio of cipher
>> - add Kconfig
>>
>> Zain Wang (4):
>>    Crypto: Crypto driver support aes/des/des3 for rk3288
>>    clk: rockchip: set an id for crypto clk
>>    ARM: dts: rockchip: Add Crypto drivers for rk3288
>>    crypto: rockchip/crypto - add DT bindings documentation
> I guess the series patchs order should be:
>
> pacth 1/4 dt-binds/
> patch 2/4 clk id
> patch 3/4 crypto driver
> patch 4/4 dts
>
ok! done!
>
>
>>
>>   .../devicetree/bindings/crypto/rockchip-crypto.txt |  29 ++
>>   arch/arm/boot/dts/rk3288.dtsi                      |  15 +
>>   drivers/clk/rockchip/clk-rk3288.c                  |   2 +-
>>   drivers/crypto/Kconfig                             |  11 +
>>   drivers/crypto/Makefile                            |   1 +
>>   drivers/crypto/rockchip/Makefile                   |   3 +
>>   drivers/crypto/rockchip/rk3288_crypto.c            | 380
>> +++++++++++++++
>>   drivers/crypto/rockchip/rk3288_crypto.h            | 222 +++++++++
>>   drivers/crypto/rockchip/rk3288_crypto_ablkcipher.c | 511
>> +++++++++++++++++++++
>>   include/dt-bindings/clock/rk3288-cru.h             |   1 +
>>   10 files changed, 1174 insertions(+), 1 deletion(-)
>>   create mode 100644
>> Documentation/devicetree/bindings/crypto/rockchip-crypto.txt
>>   create mode 100644 drivers/crypto/rockchip/Makefile
>>   create mode 100644 drivers/crypto/rockchip/rk3288_crypto.c
>>   create mode 100644 drivers/crypto/rockchip/rk3288_crypto.h
>>   create mode 100644 drivers/crypto/rockchip/rk3288_crypto_ablkciphe=
r.c
>>
>
>


--
To unsubscribe from this list: send the line "unsubscribe devicetree" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
