Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E52F7C83F19
	for <linux-crypto@archiver.kernel.org>; Wed, 30 Aug 2023 18:46:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239896AbjH3SoI (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 30 Aug 2023 14:44:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344090AbjH3SGG (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 30 Aug 2023 14:06:06 -0400
Received: from mout.gmx.net (mout.gmx.net [212.227.15.15])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2206D193
        for <linux-crypto@vger.kernel.org>; Wed, 30 Aug 2023 11:06:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
 s=s31663417; t=1693418741; x=1694023541; i=wahrenst@gmx.net;
 bh=hUJK6TjJ0vj8QdMJxqA1jtzz55PeEmDdA/O7liJq+70=;
 h=X-UI-Sender-Class:Date:Subject:To:Cc:References:From:In-Reply-To;
 b=ZyI+CCuv01/YtAieMwnS1nkRA1ijrAtXIL7c6tfxCcQmR+2RPXwJ0mCRJ47vl52EpC803Uk
 I0NSZUlp0GXSBP7U6rj2bqYXnc9z2qS/LCXKjooQ5/qB0SQ6FbtCJOuUd8YiMn96pGD+FZ9UL
 noXgQreY2zdF7Lpmc000asT5QjMAa5d0JUICE6X/2wUAH+Et0nb8qHuL9q4c8Gvt8M6TG7jJW
 SdcTfI0sgw1Sq04ZoVFr3RJ6J5Bzs2siA/APgRSfRO3lCLMjBbyviOJNqIyPbT7ZuyA7MJ0nz
 ZH9+ykgXsKJdvSM+QZ12eJg0joeEAAZReCiPe/XCqOCZs6oiDNSQ==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from [192.168.1.129] ([37.4.248.43]) by mail.gmx.net (mrgmx004
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1MhD2O-1q5wdK3RTu-00eOOs; Wed, 30
 Aug 2023 20:05:40 +0200
Message-ID: <317b15be-3bae-5938-8c27-8a44f79b94d3@gmx.net>
Date:   Wed, 30 Aug 2023 20:05:39 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH] hwrng: bcm2835: Fix hwrng throughput regression
Content-Language: en-US
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Olivia Mackall <olivia@selenic.com>,
        Florian Fainelli <florian.fainelli@broadcom.com>,
        Ray Jui <rjui@broadcom.com>,
        Scott Branden <sbranden@broadcom.com>,
        Mark Brown <broonie@kernel.org>, linux-crypto@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        bcm-kernel-feedback-list@broadcom.com,
        Thorsten Leemhuis <regressions@leemhuis.info>,
        Phil Elwell <phil@raspberrypi.com>
References: <20230826112828.58046-1-wahrenst@gmx.net>
 <ZOnxaXtXeL1FFyIj@zx2c4.com> <56b5000c-89d9-865e-035c-5baf730a5304@gmx.net>
 <ZOoe0lOR9zpcAw5I@zx2c4.com>
From:   Stefan Wahren <wahrenst@gmx.net>
In-Reply-To: <ZOoe0lOR9zpcAw5I@zx2c4.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:KySIrYtZy2TEw8CmXZ1rN39I4k69ce7J/mjoTvxOoc3ffOwK32N
 0784xsT+Pw8fnjbfehB2pPcduVBVWgZAooqa0DIIK1Sxb75hC8Ry3Lct3SuIt6xzMVOcT9l
 TKTREIK93B8LGKa+8929pynNskuUTfmdi70WQy+kUOEPB4IUBNsK0W4WWq1GFOq2n1oJcnv
 SX5ATGOardcBNMhLYKwfg==
UI-OutboundReport: notjunk:1;M01:P0:vIMjQkB7YLU=;Lh48n2EZHAXZKby8aXayx+oAJ5M
 eQQmhCOwW1lqid5O3sreWfeRet5+Uu+iqQEBfpnHMEuveDxu0EmRk+pS+A4YMkIdoJLGV2yPt
 9CS+E6XdoVsKVTeuga+H+I8tPWdwgRaEmyVFGRHcgBX1D4uz8Y7tWbZ2+tkqrjn+4kthif8Ob
 O/0hq5BkvXPgncfjBziwR/XOXGeFqM/rX+BPcofyCAFJ6Ko1DBYyemnSGBOTVeugN21VHFeDz
 BA8DmpzMKmxmJZWG82+FC7uWFEJ2WIUJCtjQEZjcEiUckq+6pxiXVvT0jCUepD8JJlsw6j8hf
 Tup3DVCKJZnj2wQNqmRsSmmwdj+AALac2/s4mzXrh4MNv/XyBvrAKCwjcoaIKsTz8vlKHe9Ws
 T3jwUI0whMDmBUXN5jNiiqWvB/b2keA77xhxXgrZqgfCEtw0AjSWQ9DZRqWb+Nzgs6CHjl9QX
 Ko2waYS4EJYWxubrBEk0nTIoDpehhe10dQxUZR+/GBv/zJiSLQF9AsMJqHIb5VkYfl4U5gWuQ
 EBDatTIs5h5ye936SeB5YqlqXOWbYpycJmk4eCG1CdLlsveNCAHCHJdLHaAZc1lN0JCEOU3mH
 xp7ngvdjG44AyyYkc8QLtUvNIO0MeBxnCM8QWTPvd+kxi8PjnCEM5+Dg3q3hQ71tuqZwfglbb
 GyNHmM+cGDXqahgX+6HKw6LSx7jRmwIOAFex6Xzo8P2W6Wab0Aw/7znSqUkRPqqS/mMNi9P5Z
 Ksz2CEv77pPvcbrvGuPJbLRLQqDsH0V+tK81PwfhnMZ8iOUWtD5hCl7rgFEzbOHqvFtXa87/F
 MYvQDL/Lcpgks+ooSMvQSU1liNgV5mxTPs0Y450JA8YWXSvNc54XBGZ1duwn/u2hrRqjRdxVR
 a8yC6FlLGLcrN2BvtVXnd1ymiQ2jaax7knG0uUquMpy6HGAVBo4Yzsl08C0MLHtjWXDzW7Wn6
 X2uEsPT2c0vnsVkxX4GFFgAPvqs=
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Jason,

Am 26.08.23 um 17:48 schrieb Jason A. Donenfeld:
> On Sat, Aug 26, 2023 at 04:01:58PM +0200, Stefan Wahren wrote:
>> Hi Jason,
>>
>> Am 26.08.23 um 14:34 schrieb Jason A. Donenfeld:
>>> On Sat, Aug 26, 2023 at 01:28:28PM +0200, Stefan Wahren wrote:
>>>> The recent RCU stall fix caused a massive throughput regression of th=
e
>>>> hwrng on Raspberry Pi 0 - 3. So try to restore a similiar throughput
>>>> as before the RCU stall fix.
>>>>
>>>> Some performance measurements on Raspberry Pi 3B+ (arm64/defconfig):
>>>>
>>>> sudo dd if=3D/dev/hwrng of=3D/dev/null count=3D1 bs=3D10000
>>>>
>>>> cpu_relax              ~138025 Bytes / sec
>>>> hwrng_msleep(1000)         ~13 Bytes / sec
>>>> usleep_range(100,200)   ~92141 Bytes / sec
>>>>
>>>> Fixes: 96cb9d055445 ("hwrng: bcm2835 - use hwrng_msleep() instead of =
cpu_relax()")
>>>> Link: https://lore.kernel.org/linux-arm-kernel/bc97ece5-44a3-4c4e-77d=
a-2db3eb66b128@gmx.net/
>>>> Signed-off-by: Stefan Wahren <wahrenst@gmx.net>
>>>> ---
>>>>    drivers/char/hw_random/bcm2835-rng.c | 3 ++-
>>>>    1 file changed, 2 insertions(+), 1 deletion(-)
>>>>
>>>> diff --git a/drivers/char/hw_random/bcm2835-rng.c b/drivers/char/hw_r=
andom/bcm2835-rng.c
>>>> index e98fcac578d6..3f1b6aaa98ee 100644
>>>> --- a/drivers/char/hw_random/bcm2835-rng.c
>>>> +++ b/drivers/char/hw_random/bcm2835-rng.c
>>>> @@ -14,6 +14,7 @@
>>>>    #include <linux/printk.h>
>>>>    #include <linux/clk.h>
>>>>    #include <linux/reset.h>
>>>> +#include <linux/delay.h>
>>>>
>>>>    #define RNG_CTRL	0x0
>>>>    #define RNG_STATUS	0x4
>>>> @@ -71,7 +72,7 @@ static int bcm2835_rng_read(struct hwrng *rng, void=
 *buf, size_t max,
>>>>    	while ((rng_readl(priv, RNG_STATUS) >> 24) =3D=3D 0) {
>>>>    		if (!wait)
>>>>    			return 0;
>>>> -		hwrng_msleep(rng, 1000);
>>>> +		usleep_range(100, 200);
>>> I think we still need to use the hwrng_msleep function so that the sle=
ep
>>> remains cancelable. Maybe just change the 1000 to 100?
>> i found that other hwrng driver like iproc-rng200 (Raspberry Pi 4) also
>> use usleep_range().
>>
>> Nevertheless here are more numbers:
>>
>> usleep_range(200,400) : 47776 bytes / sec
>> hwrng_msleep(20) : 715 bytes / sec
>>
>> Changing to 100 ms won't be a real gain.
> I'm fine with whatever number you want there. Maybe we need a
> hwrng_usleep_range() that takes into account rng->dying like
> hwrng_msleep() does? (And iproc-rng200 should probably use that too?)
the idea of this patch was to fix the performance regression in upcoming
mainline and backport the fix to Linux 6.1 LTS. After that i'm fine with
the introduction of hwrng_usleep_range().

Best regards

> Jason

