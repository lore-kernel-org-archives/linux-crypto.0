Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09A8EC83F1A
	for <linux-crypto@archiver.kernel.org>; Wed, 30 Aug 2023 18:46:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237551AbjH3Snt (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 30 Aug 2023 14:43:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344005AbjH3R4a (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 30 Aug 2023 13:56:30 -0400
Received: from mout.gmx.net (mout.gmx.net [212.227.15.15])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97DB7193
        for <linux-crypto@vger.kernel.org>; Wed, 30 Aug 2023 10:56:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
 s=s31663417; t=1693418158; x=1694022958; i=wahrenst@gmx.net;
 bh=PDL/l6os/JL0sjb08BLPOhoDi81r8MbjrMxF1r4+zKc=;
 h=X-UI-Sender-Class:Date:Subject:To:Cc:References:From:In-Reply-To;
 b=a7xkZz+88sO8XUH+zwOtFQnWE5Vzy6UUEYG4KxQorWp5Ce8jyLaobLukTrEgDg2fWsBXvqI
 w6H5q6v44pSqTQclvzwgyJ92fJxNBI4h8cQ9l/Y9ZwIzCTt9OR3dbVP6aq7TvJs9pEOjFNvQD
 ud5H0oh/uGryjkZgYgB3ErbbRSlbds4kxPDMqtbU5zR+LW+6Dj6ViQtVExxutLUH2AbXamfFi
 RHweFp8W9aMzNLz7K2DN8dKY7IaE4eBIFdyakKMKbCtn8QPbXnM65gKntIgmbOP7IhweKQI7x
 rxGRlq8Nxiup6vHpmfZM963VDngfjg6yVbhePGoo+0Pu5lRNvqlw==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from [192.168.1.129] ([37.4.248.43]) by mail.gmx.net (mrgmx004
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1N1Obh-1pYlEb2RZL-012mvp; Wed, 30
 Aug 2023 19:55:58 +0200
Message-ID: <4dfdadf0-a985-78d9-91b6-065c52d23b34@gmx.net>
Date:   Wed, 30 Aug 2023 19:55:55 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: bcm2835-rng: Performance regression since 96cb9d055445
To:     Thorsten Leemhuis <regressions@leemhuis.info>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        Florian Fainelli <florian.fainelli@broadcom.com>,
        Scott Branden <sbranden@broadcom.com>,
        bcm-kernel-feedback-list@broadcom.com,
        linux-crypto@vger.kernel.org,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Andrei Coardos <aboutphysycs@gmail.com>,
        Martin Kaiser <martin@kaiser.cx>,
        Linux regressions mailing list <regressions@lists.linux.dev>,
        Phil Elwell <phil@raspberrypi.com>
References: <bc97ece5-44a3-4c4e-77da-2db3eb66b128@gmx.net>
 <ZOiP2H_6pfhKN3fj@zx2c4.com> <20e3c73c-7736-b010-516a-6618c88d8dad@gmx.net>
 <2a0fd8ef-8b43-b769-b4aa-c27405ead5e7@leemhuis.info>
Content-Language: en-US
From:   Stefan Wahren <wahrenst@gmx.net>
In-Reply-To: <2a0fd8ef-8b43-b769-b4aa-c27405ead5e7@leemhuis.info>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:icfQAfi9b0eHQhciAtcWG0+l9pF6iiPLg8NGGjLdmTQ+ggLB8aL
 +SBshbE1lC1N17cvq3uhkqDNO/jLRIvCmOArNjIjO4N3xHfZy/LJi9y57aZpznOFoiVO99n
 wZN8+EE+fCTkmDLkqF1X4QnG8HZuwtuOFV9uPqs/T0jP6Q7965Jfq9de/tEYcnTyo/t5mDv
 6x7J04nOIXlNi08bAoflA==
UI-OutboundReport: notjunk:1;M01:P0:Y3tVSRMS7Yo=;FxST7o+5hk3nkqWN640sb+3bcWf
 eMkJHYvw4ZSnEx4KnGJjvLExCnlBv7TbITKiwf4tfV+OlXl1vzhLo6WULMYmzgYoZK4YLkmcg
 +5SLpbWEM93Ix1F9sBMYn6ix6fb/WfIlZKdpatc1f9GjhnSPr7hNrs71juUyyK77JbBjJ3er2
 sznUJ1Q6nR/SuaM5lfJQbGssOaYTg+EpQmvX9APAUc6aeCGRTdvCZcVkeaFPiBqTc4MSLGpvc
 9fSkzM8cXM99nYHaCrYxpjQ0BDuY6LhdD0qq6hn+LvwgOSdBmoZfwEdMvdjtS8UBE5kyPS+gI
 qCLOqQIl1NfAM8hmU2OL+O4muu/Uxb0LGRt731iE+8djAOU6+JBYCWBb345bv+Mro6H/d5cEP
 W/sgZQ9K9DgEzCdw1QuYmb247MIwWrwsuuR9sH0ujk8yBL5CeQKCmYeX/FGScpax8HC++F8JM
 DzyBA788bCEkGdn1VAlpUq35+fiGJaewTpVCx/OebNZ8H6lUVY1TfTAbaE1ZDDbL5ahEx4J1d
 IKxvxmWlhqDDvZXZLx/Lrk/x+pfTEfX46k6XcPp5QtX3s7uEO8MPvjUBaOu776OUmEdkZFgi6
 cc9kL0p3DFBkXHDGq46kKE4xwmjdxvmU8KHJW0zD2m7p6DfJ7YTefBSdZLVB78rJ5LHMuRxtC
 Sf69M5jzQw3iokr4u+msDTA4FQpHQf5nvEwr06+X9WAFLepzB9TFZCeuwjWZZT/Gcq+3Af08p
 O5yK8V2VYfRMTgRbMY89Tv/jh6gcsAc4mS/lGb5vceeHVEz83j/iUvWkxlRxyEWq4iYbR1hST
 vtwAayX6fIEOHoz5MRgUHD0kKq4/tFFuU9A/12C4gvKrcyccQ/I1xmD/YS3kCwH71+08em5VH
 XiqFGZt4D5rboJTauTB91GaeKzTf/QE9Dsw3th+5DpKUp7KhK5JDQJbsujU5qpQGEH/0N1zSp
 5aPwINfLYrqUgmHdR6xciW1qh4I=
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi,

Am 30.08.23 um 12:38 schrieb Thorsten Leemhuis:
> /me gets the impression he has to chime in here
>
> On 25.08.23 14:14, Stefan Wahren wrote:
>> Am 25.08.23 um 13:26 schrieb Jason A. Donenfeld:
>>> On Fri, Aug 25, 2023 at 01:14:55PM +0200, Stefan Wahren wrote:
>>>> i didn't find the time to fix the performance regression in bcm2835-r=
ng
>>>> which affects Raspberry Pi 0 - 3, so report it at least. AFAIK the fi=
rst
>>>> report about this issue was here [1] and identified the offending
>>>> commit:
>>>>
>>>> 96cb9d055445 ("hwrng: bcm2835 - use hwrng_msleep() instead of
>>>>  =C2=A0=C2=A0 cpu_relax()")
>>>>
>>>> #regzbot introduced: 96cb9d055445
>>>>
>>>> I was able to reproduce this issue with a Raspberry Pi 3 B+ on Linux
>>>> 6.5-rc6 (arm64/defconfig).
>>>>
>>>> Before:
>>>> time sudo dd if=3D/dev/hwrng of=3D/dev/urandom count=3D1 bs=3D4096 st=
atus=3Dnone
>>>>
>>>> real=C2=A0=C2=A0=C2=A0 3m29,002s
>>>> user=C2=A0=C2=A0=C2=A0 0m0,018s
>>>> sys=C2=A0=C2=A0=C2=A0 0m0,054s
>>> That's not surprising. But also, does it matter? That script has
>>> *always* been wrong. Writing to /dev/urandom like that has *never*
>>> ensured that those bytes are taken into account immediately after. It'=
s
>>> just not how that interface works. So any assumptions based on that ar=
e
>>> bogus, and that line effectively does nothing.
>>>
>>> Fortunately, however, the kernel itself incorporates hwrng output into
>>> the rng pool, so you don't need to think about doing it yourself.
>>>
>>> So go ahead and remove that line from your script.
>> Thanks for your explanation. Unfortunately this isn't my script.
> And I assume it's in the standard install of the RpiOS or similarly
> widespread?
the repo / script is specific for Raspberry Pi / Debian.
>
>> I'm
>> just a former BCM2835 maintainer and interested that more user stick to
>> the mainline kernel instead of the vendor ones. I will try to report th=
e
>> script owner.
> thx

I made a pull request [1] in order to avoid longer discussions and today
it has been merged :)

[1] - https://github.com/RPi-Distro/raspberrypi-sys-mods/pull/77
