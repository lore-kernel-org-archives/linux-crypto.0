Return-Path: <SRS0=Veu2=ZL=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 364D4C432C3
	for <linux-crypto@archiver.kernel.org>; Tue, 19 Nov 2019 17:00:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0674C208D4
	for <linux-crypto@archiver.kernel.org>; Tue, 19 Nov 2019 17:00:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=gmx.net header.i=@gmx.net header.b="BJUxT4Ak"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728638AbfKSRAY (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 19 Nov 2019 12:00:24 -0500
Received: from mout.gmx.net ([212.227.17.21]:42271 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728630AbfKSRAX (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 19 Nov 2019 12:00:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1574182796;
        bh=TpXSWByPbpcS18BolyKKvZeopxt2k9g6A1fqu2PDz/8=;
        h=X-UI-Sender-Class:Subject:To:Cc:References:From:Date:In-Reply-To;
        b=BJUxT4Ak+dwZbIjg6+Ycb7pSyGwGV8FyauCguv503K9ohgt65z0Xd4/APR0YFU7Fy
         Bg1vOEMrUSCKpAMHUA6IPwuZBaNqmY+EAEILEZofqzPpBQ/7S846RNMyN30fGPev7k
         H/fUjIwLXbVizVUiUhH9iLxEhpuMIUZwo+MuDlIE=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [192.168.1.176] ([37.4.249.139]) by mail.gmx.com (mrgmx104
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1MsHnm-1hjG3a1c54-00toTm; Tue, 19
 Nov 2019 17:59:56 +0100
Subject: Re: [PATCH v2 3/3] ARM: dts: bcm2711: Enable HWRNG support
To:     Matthias Brugger <matthias.bgg@gmail.com>,
        Nicolas Saenz Julienne <nsaenzjulienne@suse.de>,
        Stephen Brennan <stephen@brennan.io>
Cc:     Mark Rutland <mark.rutland@arm.com>, devicetree@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Scott Branden <sbranden@broadcom.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, Ray Jui <rjui@broadcom.com>,
        Eric Anholt <eric@anholt.net>,
        Rob Herring <robh+dt@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, linux-crypto@vger.kernel.org,
        Matt Mackall <mpm@selenic.com>,
        bcm-kernel-feedback-list@broadcom.com,
        linux-arm-kernel@lists.infradead.org,
        linux-rpi-kernel@lists.infradead.org
References: <20191119061407.69911-1-stephen@brennan.io>
 <20191119061407.69911-4-stephen@brennan.io>
 <e38de8daad5a2c9b03bda1aa2632844e3ed3d11e.camel@suse.de>
 <4ae008c8-6e41-01f8-10a6-7b6ea72f96c4@gmail.com>
From:   Stefan Wahren <wahrenst@gmx.net>
Message-ID: <b7e8c7fa-930e-c6d5-ae21-970709dd4285@gmx.net>
Date:   Tue, 19 Nov 2019 17:59:53 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <4ae008c8-6e41-01f8-10a6-7b6ea72f96c4@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Content-Language: en-US
X-Provags-ID: V03:K1:F3pJv1hU47e85VdlRkDt6C2TCE+n1NEcF8BVsmtfvZOQj+Z76Dp
 SLQNuTK+r50H1zWgUj7tbnOJMy6CY9k8uoLtNSnLSGgbFPapU2zxZ45awIUEC4DbspUFgwx
 dW3iyoLUcdq28eFqJo4boqTKbiUw61K08p4gzlompp+dktL1URL3LAHSb37ty0aJmGi7KSV
 b3DltoRvjqa3GmgINvr6g==
X-UI-Out-Filterresults: notjunk:1;V03:K0:/Rbeb5FlTZE=:Tu5w7I/3fml3REGXM/fhZf
 PXoqWNwJBygfUtM3rUJHOXMey5HAfIWZLcqF2TG8GT2kU2jVa3tVxxsoyuy8AQSyn+HJgL1NC
 q9LonkbgXhkD+6fM6cuiqAYBs/g9XerIFU7L01dtyAArXObg7K89fS3Z114OR5tVMENK1/ztK
 PMAUNNPhnBE2AamOsAMPoVf76iWvQWXhZtPqChE66rE/vv61gLd0xVKOvI6F9f353IgadwEvb
 Yid/b+ANPMgFzhvwKWpzjskJH8awE404lrTnN4Ze8r3Iq3frdmYS4Ob8pnIgSBDXhSvt/dVU5
 0Pj2YDKUWkwJ9ZIrA0/eY5PP+F4rEhxsgy7f6Hrvre8aoPX+FQ/V0+50zkoY5+HSQddZEEpIY
 Pbg9bSvP5+vHKSVINKKOnTIUKLa6Myl/pbUI4fxKrncQGIwXiwNKTVzL7sRPMunEjBxwotpaV
 xINlGIahDOjBX3hyqpcPVtcU0W0UafZaR3PQRKj+8sisIMb011aDG+ni6CWaO7wr+3awiwya2
 q2LqiBFo6bDwHb8nRWy1W7ak1UY4l8NcTjprPd7n8afkK6BPjwD+6MHkpRzYDTJZ25+BzflrC
 snoyxdYjF6zgOF2zPpw70Ql3wPHj0xy5VdA+qxiGjnclq6qchK9rZdBf2M96STreSkhvwkCCT
 ZuychAPVdkWiXUreHlhm+5dR2hDcXh8ftVRr5fhdhdU+uCl/bxZbP8jZjs1/n7US0Jcm0ja78
 YexRGTe1IQ8a7Hvm8uqjT/2XNqp6lE3nLLwS7z0N5L2umpBgbT+bTiYS02Kp8GCRrBx7nHvh6
 3RC/HK6pjHn/jozKfbzVHDF6zXs4042U40Gi8wwKCXS+F0TjqioVL6ZRaXLlBBfqZfF4mYkes
 mcPmnBjybTZTRxyBhFib1flvxavoiRqXq5L5RVikg1OmtDLaHJ02oUoHtRsSPR+T6IzO05OmJ
 CCT/DwmVLEahbpXvm7X/tKJzL14qE5HLj4A8AAAc5feVaDodyG3WvsRLS/DiA2rdiW43FVk5z
 10Qp1Pg+vEdad2HQQf9+OGjMzSQxC+wrIAXPPQ8c20FDLfyFlhFN+Sfy8Oruv+pATmp853a7z
 NVit31ZUMKQ1xVwWeYAcGGxZS1e1YqV2YYXDdSssbOflAURVGy96lw25RQkCZJnfwrNEieGoP
 95xyOJS7L8O7wGzR6I0vYPSogEMQFwjLCflXviEt8a90k08aO++QiTSqa0Zis0uyYev+iw0LL
 XeipxOxHjkHqH1AAsqa884coqTPr8q5DI5asP/2nTdedeyzy2asurcfouu94=
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Stephen,

Am 19.11.19 um 12:15 schrieb Matthias Brugger:
>
> On 19/11/2019 11:07, Nicolas Saenz Julienne wrote:
>> Hi Stephen, thanks for the follow-up.
>>
>> On Mon, 2019-11-18 at 22:14 -0800, Stephen Brennan wrote:
>>> BCM2711 features a RNG200 hardware random number generator block, whic=
h is
>>> different from the BCM283x from which it inherits. Move the rng block =
from
>>> BCM283x into a separate common file, and update the rng declaration of
>>> BCM2711.
>>>
>>> Signed-off-by: Stephen Brennan <stephen@brennan.io>
>>> ---
>> It's petty in this case but you should add a list of changes here too.
>>
>>>  arch/arm/boot/dts/bcm2711.dtsi        |  6 +++---
>>>  arch/arm/boot/dts/bcm2835.dtsi        |  1 +
>>>  arch/arm/boot/dts/bcm2836.dtsi        |  1 +
>>>  arch/arm/boot/dts/bcm2837.dtsi        |  1 +
>>>  arch/arm/boot/dts/bcm283x-common.dtsi | 11 +++++++++++
>>>  arch/arm/boot/dts/bcm283x.dtsi        |  6 ------
>>>  6 files changed, 17 insertions(+), 9 deletions(-)
>>>  create mode 100644 arch/arm/boot/dts/bcm283x-common.dtsi
>>>
>>> diff --git a/arch/arm/boot/dts/bcm2711.dtsi b/arch/arm/boot/dts/bcm271=
1.dtsi
>>> index ac83dac2e6ba..4975567e948e 100644
>>> --- a/arch/arm/boot/dts/bcm2711.dtsi
>>> +++ b/arch/arm/boot/dts/bcm2711.dtsi
>>> @@ -92,10 +92,10 @@ pm: watchdog@7e100000 {
>>>  		};
>>>
>>>  		rng@7e104000 {
>>> +			compatible =3D "brcm,bcm2711-rng200";
>>> +			reg =3D <0x7e104000 0x28>;
>>>  			interrupts =3D <GIC_SPI 125 IRQ_TYPE_LEVEL_HIGH>;
please take into account that according to the rng200 binding document
there is no interrupt or clock. So drop it.
>>> -
>>> -			/* RNG is incompatible with brcm,bcm2835-rng */
>>> -			status =3D "disabled";
>>> +			status =3D "okay";
>>>  		};
>>>
>>>  		uart2: serial@7e201400 {
>>> diff --git a/arch/arm/boot/dts/bcm2835.dtsi b/arch/arm/boot/dts/bcm283=
5.dtsi
>>> index 53bf4579cc22..f7b2f46e307d 100644
>>> --- a/arch/arm/boot/dts/bcm2835.dtsi
>>> +++ b/arch/arm/boot/dts/bcm2835.dtsi
>>> @@ -1,5 +1,6 @@
>>>  // SPDX-License-Identifier: GPL-2.0
>>>  #include "bcm283x.dtsi"
>>> +#include "bcm283x-common.dtsi"
>>>  #include "bcm2835-common.dtsi"
>>>
>>>  / {
>>> diff --git a/arch/arm/boot/dts/bcm2836.dtsi b/arch/arm/boot/dts/bcm283=
6.dtsi
>>> index 82d6c4662ae4..a85374195796 100644
>>> --- a/arch/arm/boot/dts/bcm2836.dtsi
>>> +++ b/arch/arm/boot/dts/bcm2836.dtsi
>>> @@ -1,5 +1,6 @@
>>>  // SPDX-License-Identifier: GPL-2.0
>>>  #include "bcm283x.dtsi"
>>> +#include "bcm283x-common.dtsi"
>>>  #include "bcm2835-common.dtsi"
>>>
>>>  / {
>>> diff --git a/arch/arm/boot/dts/bcm2837.dtsi b/arch/arm/boot/dts/bcm283=
7.dtsi
>>> index 9e95fee78e19..045d78ffea08 100644
>>> --- a/arch/arm/boot/dts/bcm2837.dtsi
>>> +++ b/arch/arm/boot/dts/bcm2837.dtsi
>>> @@ -1,4 +1,5 @@
>>>  #include "bcm283x.dtsi"
>>> +#include "bcm283x-common.dtsi"
>>>  #include "bcm2835-common.dtsi"
>>>
>>>  / {
>>> diff --git a/arch/arm/boot/dts/bcm283x-common.dtsi
>>> b/arch/arm/boot/dts/bcm283x-common.dtsi
>>> new file mode 100644
>>> index 000000000000..3c8834bee390
>>> --- /dev/null
>>> +++ b/arch/arm/boot/dts/bcm283x-common.dtsi
>>> @@ -0,0 +1,11 @@
>>> +// SPDX-License-Identifier: GPL-2.0
>>> +
>>> +/ {
>>> +	soc {
>>> +		rng@7e104000 {
>>> +			compatible =3D "brcm,bcm2835-rng";
>>> +			reg =3D <0x7e104000 0x10>;
>>> +			interrupts =3D <2 29>;
>>> +		};
>>> +	};
>>> +};
>> I think Stefan wrote bcm283x-common.dtsi by mistake, he really meant
>> bcm2835-common.dtsi.

Correct. Sorry for the confusion.

Regards
Stefan

>>
> Thanks I was just wondering on which tree/patch-set this was based.
>
> Regards,
> Matthias
>
>> See bcm2835-common.dtsi's header comment:
>>
>> /* This include file covers the common peripherals and configuration be=
tween
>>  * bcm2835, bcm2836 and bcm2837 implementations.
>>  */
>>
>> Regards,
>> Nicolas
>>
>>
>> _______________________________________________
>> linux-arm-kernel mailing list
>> linux-arm-kernel@lists.infradead.org
>> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
>>
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
