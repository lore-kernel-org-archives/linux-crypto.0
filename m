Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CCE74C3DA6F
	for <linux-crypto@archiver.kernel.org>; Fri, 25 Aug 2023 12:15:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241285AbjHYMPN (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 25 Aug 2023 08:15:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244566AbjHYMOp (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 25 Aug 2023 08:14:45 -0400
Received: from mout.gmx.net (mout.gmx.net [212.227.15.15])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1179210A
        for <linux-crypto@vger.kernel.org>; Fri, 25 Aug 2023 05:14:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
 s=s31663417; t=1692965661; x=1693570461; i=wahrenst@gmx.net;
 bh=fCfmUZ9y2OW+VD5pOAsTNkaXpwFH0ITwIigwyh1KSi8=;
 h=X-UI-Sender-Class:Date:Subject:To:Cc:References:From:In-Reply-To;
 b=DohdBf4Y7A/t/R69f5W4zT6rjFkP4lmH57+a5PozBwoMZzD6AoSLrTCtC/keBkKChgMiVw7
 Q0o9nc2Pl2EMyiv/hfbVbnkk/I9lyR1+MjLi86oBYD60kH07IvMi/Y7vnsheCiLRWmvNfYLmt
 QKA42YFEXyPRIulNnyjkoc3VLbOtNJwOcV42/b0oy64PD2+VaqWNwbHNjku5NgZlAVhaxIOds
 5ToSjXb8nNz3e4aGCryP+7DwWGk9JYn+cTmtbK4j1VD5b564yl9jqlSmkYMNNi8tAVXJjxG/W
 gt2EKqvh5RJjeCopH5uyiYfxUaYcuAFzbNWhzBjfJtLaVlyWSQEQ==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from [192.168.1.129] ([37.4.248.43]) by mail.gmx.net (mrgmx005
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1MnakR-1psmyG29Ej-00jcW0; Fri, 25
 Aug 2023 14:14:21 +0200
Message-ID: <20e3c73c-7736-b010-516a-6618c88d8dad@gmx.net>
Date:   Fri, 25 Aug 2023 14:14:19 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: bcm2835-rng: Performance regression since 96cb9d055445
Content-Language: en-US
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
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
 <ZOiP2H_6pfhKN3fj@zx2c4.com>
From:   Stefan Wahren <wahrenst@gmx.net>
In-Reply-To: <ZOiP2H_6pfhKN3fj@zx2c4.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:k+ydxWD8F27tvwolbfoiF9VhPfuhmZ0BIFdAZOfhRltJ/UXgoL3
 raY/toYrx9cgXV+UpV83Qxwm6AV5fzr8VteYl6/8I63FFCKc/zVPWhEIDJu1fPC+r45+SAd
 a+kEbH+1TS6xEGVpdnICoaJc1Dboy6tKy4Z2YTvDWjzBejen1TB54EGxvzACBQsYpoXHvqk
 m29abvdyGiknSpSQaQoyw==
UI-OutboundReport: notjunk:1;M01:P0:HKG9TUu/MGc=;5xCFcdhpJDoTvNkhY4zmv+/ZK75
 LyArpiio00WpyT7NU9JOV/x4jTGRMhjPWblGSBqloTqtjnXyNhCteG+5ARjbhCAwxwSCGmAeV
 s3QNVcoGcIkqKKZytti4Hw2q96WDqhDC36tC7S7/2PnPJN3fAtH4ezIUBJ406M4WqEgY84X2f
 9LRN1+vrJTB4Og94B4C7zkDAbGh662IluQOgtjni2GFesNgALbFGb5EtBXlzQP0ndiKS6R0lR
 Ufcxmb6gD+ju0IjY1mCmSIu8dhoJ/FjD39fS2Q8gQA95HqjQ35+QdW5cSjGlVRArr865Sacj2
 9kXFJceeusZTnwoytzR6Excvfm0EE32lo2WJb3YGF7s0X7sv7xs2e/IBUxaOXqQ/zJxO/6omo
 Shm1tb0nGL4TyZsN90Ni3Yw/KZns8x3fJPg97dBWNSR2fj/nrXg0FiUGLVTyQalkZIYkwT8Jw
 xx/LYerHN7955SsyWQWd7YtonTbpDZ5qgkV+jZEYhf9oXuxdKzs0vliuI921ZOwhg/HJIe9vx
 GNPXTnT8ISNbgRAx0RiOqntyeeeAbn+8qzAXjkA0yVE0iIB5qIOW/i4V80RtPaDYFPKxQRA8o
 3KMKLlHhYLOby/xX1mNkxHd4KC//Aq0dejDpcTV0WW0QIqNBrW3EXufyupc8LlqYMNu9IgNi4
 BgvMJcB7QBjt65Kx2ca/SWebtMfygWr7D6EmH4DYqfVWhVQkzXcKSHUKMrEPAn4hS3vx1wHDD
 oeQXIYEbjX/Lns08Q5FoiqyHYJI0QqQKKu3RfMLgou9j2kZEy6BhRLu/HWVSgR3Dq/Kcw1C/i
 uW/QNP+QP35udE21idSQLFXc7xHuBh58NnxkASUVF8NG3j6PFJizcAKsU1N1hbWIKiID2zV28
 jMZWeqwcBJjGdKAfbot7j5SMstSGYQcq2zd+Ua/2DZGeK83p7xpd6ijV//HEMBxGAjBlOVJXD
 mUENx8y3uoyBWFJn2PQurhYiicc=
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Jason,

Am 25.08.23 um 13:26 schrieb Jason A. Donenfeld:
> Hi Stefan,
>
> On Fri, Aug 25, 2023 at 01:14:55PM +0200, Stefan Wahren wrote:
>> Hi,
>>
>> i didn't find the time to fix the performance regression in bcm2835-rng
>> which affects Raspberry Pi 0 - 3, so report it at least. AFAIK the firs=
t
>> report about this issue was here [1] and identified the offending commi=
t:
>>
>> 96cb9d055445 ("hwrng: bcm2835 - use hwrng_msleep() instead of
>>    cpu_relax()")
>>
>> #regzbot introduced: 96cb9d055445
>>
>> I was able to reproduce this issue with a Raspberry Pi 3 B+ on Linux
>> 6.5-rc6 (arm64/defconfig).
>>
>> Before:
>> time sudo dd if=3D/dev/hwrng of=3D/dev/urandom count=3D1 bs=3D4096 stat=
us=3Dnone
>>
>> real	3m29,002s
>> user	0m0,018s
>> sys	0m0,054s
> That's not surprising. But also, does it matter? That script has
> *always* been wrong. Writing to /dev/urandom like that has *never*
> ensured that those bytes are taken into account immediately after. It's
> just not how that interface works. So any assumptions based on that are
> bogus, and that line effectively does nothing.
>
> Fortunately, however, the kernel itself incorporates hwrng output into
> the rng pool, so you don't need to think about doing it yourself.
>
> So go ahead and remove that line from your script.
Thanks for your explanation. Unfortunately this isn't my script. I'm
just a former BCM2835 maintainer and interested that more user stick to
the mainline kernel instead of the vendor ones. I will try to report the
script owner.
> Now as far as the "regression" goes, we've made an already broken
> userspace script take 3 minutes longer than usual, but it still does
> eventually complete, so it's not making boot impossible or something.
> How this relates to the "don't break userspace" rule might be a matter
> of opinion. If you think it does, maybe send a patch to Herbert reducing
> that sleep from 1000 to 100 and stating why with my background above,
> and see if he agrees it's worth fixing. Or, if removing that line from
> your scripts is good enough for you, that's also fine by me.
Now i agree that the provided example isn't the proper way to handle
/dev/urandom. Unfortunately most of the Raspberry Pi users doesn't care
about such details. In their eyes the mainline kernel is "broken" and
this is one argument to go back to the vendor ones.

Beside of the /dev/urandom abuse, i'm not convinced that sleeping for 1
sec is a good choice. This HRNG IP is used in embedded devices (e.g.
Router) and mostly without any other good source of entropy. So i think
it's worth to define a reasonable value.

Best regards
>
> Jason

