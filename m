Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6D38C6FA8F
	for <linux-crypto@archiver.kernel.org>; Wed, 30 Aug 2023 18:46:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239953AbjH3SoJ (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 30 Aug 2023 14:44:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243297AbjH3KiO (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 30 Aug 2023 06:38:14 -0400
Received: from wp530.webpack.hosteurope.de (wp530.webpack.hosteurope.de [80.237.130.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C96B61A3
        for <linux-crypto@vger.kernel.org>; Wed, 30 Aug 2023 03:38:11 -0700 (PDT)
Received: from [2a02:8108:8980:2478:8cde:aa2c:f324:937e]; authenticated
        by wp530.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
        id 1qbIaK-000308-6C; Wed, 30 Aug 2023 12:38:04 +0200
Message-ID: <2a0fd8ef-8b43-b769-b4aa-c27405ead5e7@leemhuis.info>
Date:   Wed, 30 Aug 2023 12:38:03 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: bcm2835-rng: Performance regression since 96cb9d055445
Content-Language: en-US, de-DE
To:     Stefan Wahren <wahrenst@gmx.net>,
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
From:   Thorsten Leemhuis <regressions@leemhuis.info>
In-Reply-To: <20e3c73c-7736-b010-516a-6618c88d8dad@gmx.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-bounce-key: webpack.hosteurope.de;regressions@leemhuis.info;1693391891;1eeeb97e;
X-HE-SMSGID: 1qbIaK-000308-6C
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

/me gets the impression he has to chime in here

On 25.08.23 14:14, Stefan Wahren wrote:
> Am 25.08.23 um 13:26 schrieb Jason A. Donenfeld:
>> On Fri, Aug 25, 2023 at 01:14:55PM +0200, Stefan Wahren wrote:
>
>>> i didn't find the time to fix the performance regression in bcm2835-rng
>>> which affects Raspberry Pi 0 - 3, so report it at least. AFAIK the first
>>> report about this issue was here [1] and identified the offending
>>> commit:
>>>
>>> 96cb9d055445 ("hwrng: bcm2835 - use hwrng_msleep() instead of
>>>    cpu_relax()")
>>>
>>> #regzbot introduced: 96cb9d055445
>>>
>>> I was able to reproduce this issue with a Raspberry Pi 3 B+ on Linux
>>> 6.5-rc6 (arm64/defconfig).
>>>
>>> Before:
>>> time sudo dd if=/dev/hwrng of=/dev/urandom count=1 bs=4096 status=none
>>>
>>> real    3m29,002s
>>> user    0m0,018s
>>> sys    0m0,054s
>> That's not surprising. But also, does it matter? That script has
>> *always* been wrong. Writing to /dev/urandom like that has *never*
>> ensured that those bytes are taken into account immediately after. It's
>> just not how that interface works. So any assumptions based on that are
>> bogus, and that line effectively does nothing.
>>
>> Fortunately, however, the kernel itself incorporates hwrng output into
>> the rng pool, so you don't need to think about doing it yourself.
>>
>> So go ahead and remove that line from your script.
>
> Thanks for your explanation. Unfortunately this isn't my script.

And I assume it's in the standard install of the RpiOS or similarly
widespread?

> I'm
> just a former BCM2835 maintainer and interested that more user stick to
> the mainline kernel instead of the vendor ones. I will try to report the
> script owner.

thx

>> Now as far as the "regression" goes, we've made an already broken
>> userspace script take 3 minutes longer than usual, but it still does
>> eventually complete, so it's not making boot impossible or something.
>> How this relates to the "don't break userspace" rule might be a matter
>> of opinion.

Yup, but I'd say it bad enough to qualify as regression. If it would be
something like 10 seconds it might be something different, but 3 minutes
will look like a hang to many people, and I'm pretty sure that's
something Linus doesn't want to see. But let's not involve him for now
and first try to solve this differently.

>> If you think it does, maybe send a patch to Herbert reducing
>> that sleep from 1000 to 100 and stating why with my background above,
>> and see if he agrees it's worth fixing.

Stefan, did you try to see how long it would take when the sleep time is
reduced? I guess that might be our best chance to solve this, as
reverting the culprit afaics would lead to regressions for others.

/me wonders if the sleep time could even be reduced futher that 100

Ciao, Thorsten (wearing his 'the Linux kernel's regression tracker' hat)
--
Everything you wanna know about Linux kernel regression tracking:
https://linux-regtracking.leemhuis.info/about/#tldr
If I did something stupid, please tell me, as explained on that page.

> Or, if removing that line from
>> your scripts is good enough for you, that's also fine by me.
> Now i agree that the provided example isn't the proper way to handle
> /dev/urandom. Unfortunately most of the Raspberry Pi users doesn't care
> about such details. In their eyes the mainline kernel is "broken" and
> this is one argument to go back to the vendor ones.
> 
> Beside of the /dev/urandom abuse, i'm not convinced that sleeping for 1
> sec is a good choice. This HRNG IP is used in embedded devices (e.g.
> Router) and mostly without any other good source of entropy. So i think
> it's worth to define a reasonable value.

