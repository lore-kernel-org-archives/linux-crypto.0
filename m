Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 258D8C83F13
	for <linux-crypto@archiver.kernel.org>; Sat, 26 Aug 2023 14:03:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229628AbjHZOCp (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 26 Aug 2023 10:02:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232673AbjHZOC2 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 26 Aug 2023 10:02:28 -0400
Received: from mout.gmx.net (mout.gmx.net [212.227.17.22])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A122A2
        for <linux-crypto@vger.kernel.org>; Sat, 26 Aug 2023 07:02:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
 s=s31663417; t=1693058524; x=1693663324; i=wahrenst@gmx.net;
 bh=+FLkjKrCDzKql12IEUoim+4KwnxgJTtDmAYwhPO2+JI=;
 h=X-UI-Sender-Class:Date:Subject:To:Cc:References:From:In-Reply-To;
 b=fQEo2zBN8V05NzPNhOB5TNj5KmFWa4n0EVJmJHh+KoXr/Y7/OljZsUlQKRX2vQ2+bAEsIrq
 THLwcEKnp+uel6j3GwjkMR2fSbUk+VybQ0j5Wu8TJbofEdXnzHTnEJMijufFAwQZkGA4n/6ps
 CcclCTu3IqnHb2sijhOjUWy/TBpe0NMp3OxWnNqfostHYq/MwnkrDBxzYV69PibC5t6grCdM4
 JN4NOl7G769YmCPAWVm69hVtKsVUM7TURVH/j09zt4xe3epGFEhXqHySqskbTR+G/Nj+YaHJ8
 t+8j5IUB6+yO0Pgzyc657f6K4PZGSyTqczcCFrAWk2hnzA+hYb3A==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from [192.168.1.129] ([37.4.248.43]) by mail.gmx.net (mrgmx105
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1MLiCu-1qIMyi0PzM-00Hf74; Sat, 26
 Aug 2023 16:02:04 +0200
Message-ID: <56b5000c-89d9-865e-035c-5baf730a5304@gmx.net>
Date:   Sat, 26 Aug 2023 16:01:58 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH] hwrng: bcm2835: Fix hwrng throughput regression
Content-Language: en-US
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     Olivia Mackall <olivia@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Florian Fainelli <florian.fainelli@broadcom.com>,
        Ray Jui <rjui@broadcom.com>,
        Scott Branden <sbranden@broadcom.com>,
        Mark Brown <broonie@kernel.org>, linux-crypto@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        bcm-kernel-feedback-list@broadcom.com
References: <20230826112828.58046-1-wahrenst@gmx.net>
 <ZOnxaXtXeL1FFyIj@zx2c4.com>
From:   Stefan Wahren <wahrenst@gmx.net>
In-Reply-To: <ZOnxaXtXeL1FFyIj@zx2c4.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:4AuqlvCJCzuRvaNqgoJY1/DKhyrPfo7N+uo9cyPo1BxgrsLUMwX
 1yRPua0oXRBTFteFpx4qJpn7m0/K6AVXTvWCa7Umqd7X/1tWm3EcCaldlzEf0FKi0Inw4fx
 gorBdMoL6INt5wxSHSCCTsOMSG3jPVaa+vpULb+43garwe6MbQHUzkS5tWggzjGImmavKzG
 /nobTZfXjPeztXdwmGplg==
UI-OutboundReport: notjunk:1;M01:P0:h5GWWhnSb0s=;wwfKDLC81sykB9fIDnvY5XXoPk0
 UfXy0CYn422x4ZgWjs2LMiQmNwVu440kqVjh7ON0WV9kQ5v6zq7jYxNXDo/Kp2A0xCjjZJPAc
 wLr7wdsrg59madurJdq9Sgy9svFAs8CUhlDTYOSPIJ90ww3LR4WFHPXlj3Bq0U8weu6V9thYb
 C2r0zPVctytgKDbBVq+75qEEq8HoEG8wsGogEytz8GlUcG/GhoiraHzV41YZ3KELw8GLu7vUC
 NxyTKFsZS0YDibkuYFs7BSZTJSujkojBj6z+4SBY5Y5S4RySFvxjMtdH22wWnY8G2l+FipINg
 50E5XOhxWqzY8SlBBeXgffdLKBOE4RUfiGAwrAcv2qg5WOdUE/JaR1wWGW0h3QI9jwO5JzGE0
 AuEUvYTivCebP4Gmu4wsxf0KQhs892/iEFite836mKDsnaj0JNyef5HyAFa3qSfoAxKWJLMqw
 5oGuUORtDwXsdeILYtlUk2eIxVxweFt9g5eMqCo75zkWmebAyh7288qNBgxZQU0fUaIM/k6XZ
 KyBZBR4zm7ZRAycHVF5KH4X9E7YwkSDRTw5bRXAEWrpiUzKLaXMw20xctZQoukhohGOMTw8QN
 /RqSHfzhW94bs5x6Vzr5gaFqBApfND9MdNw/0ZAbOgSUg9aIpetd1mTbBFlTjv8aWpPItlObS
 wHm3brkETMHHfD4+HkjPVhBU6wNRGyOWk+3W425RUkt4570mVtb5crY8gw7sXP3EX83arTKPM
 JuBjPqE+8UsbZJc7SS+OroagkCCCce0M1wL4pun3UBo7aiSB6Fv2fntqGoVJXqtKe/+CuGpku
 0HTf0V3QtdEBe4LemmJdOGuF2Z9stVMmzqTXHuJT1YUK/8NliBNFl99zxqKVU+gJbO8ToDWwA
 GH3qHPg6Liz4iAj+XGly2HiutV8NGlUhnmmowTfWwJOsx1sYUyBLe05S50LSH8kB68n+yZmqd
 pPW9Qra4VLOrA7CpVnbqiCxBrsQ=
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Jason,

Am 26.08.23 um 14:34 schrieb Jason A. Donenfeld:
> On Sat, Aug 26, 2023 at 01:28:28PM +0200, Stefan Wahren wrote:
>> The recent RCU stall fix caused a massive throughput regression of the
>> hwrng on Raspberry Pi 0 - 3. So try to restore a similiar throughput
>> as before the RCU stall fix.
>>
>> Some performance measurements on Raspberry Pi 3B+ (arm64/defconfig):
>>
>> sudo dd if=3D/dev/hwrng of=3D/dev/null count=3D1 bs=3D10000
>>
>> cpu_relax              ~138025 Bytes / sec
>> hwrng_msleep(1000)         ~13 Bytes / sec
>> usleep_range(100,200)   ~92141 Bytes / sec
>>
>> Fixes: 96cb9d055445 ("hwrng: bcm2835 - use hwrng_msleep() instead of cp=
u_relax()")
>> Link: https://lore.kernel.org/linux-arm-kernel/bc97ece5-44a3-4c4e-77da-=
2db3eb66b128@gmx.net/
>> Signed-off-by: Stefan Wahren <wahrenst@gmx.net>
>> ---
>>   drivers/char/hw_random/bcm2835-rng.c | 3 ++-
>>   1 file changed, 2 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/char/hw_random/bcm2835-rng.c b/drivers/char/hw_ran=
dom/bcm2835-rng.c
>> index e98fcac578d6..3f1b6aaa98ee 100644
>> --- a/drivers/char/hw_random/bcm2835-rng.c
>> +++ b/drivers/char/hw_random/bcm2835-rng.c
>> @@ -14,6 +14,7 @@
>>   #include <linux/printk.h>
>>   #include <linux/clk.h>
>>   #include <linux/reset.h>
>> +#include <linux/delay.h>
>>
>>   #define RNG_CTRL	0x0
>>   #define RNG_STATUS	0x4
>> @@ -71,7 +72,7 @@ static int bcm2835_rng_read(struct hwrng *rng, void *=
buf, size_t max,
>>   	while ((rng_readl(priv, RNG_STATUS) >> 24) =3D=3D 0) {
>>   		if (!wait)
>>   			return 0;
>> -		hwrng_msleep(rng, 1000);
>> +		usleep_range(100, 200);
>
> I think we still need to use the hwrng_msleep function so that the sleep
> remains cancelable. Maybe just change the 1000 to 100?
i found that other hwrng driver like iproc-rng200 (Raspberry Pi 4) also
use usleep_range().

Nevertheless here are more numbers:

usleep_range(200,400) : 47776 bytes / sec
hwrng_msleep(20) : 715 bytes / sec

Changing to 100 ms won't be a real gain.

>
> Jason
>
>>   	}
>>
>>   	num_words =3D rng_readl(priv, RNG_STATUS) >> 24;
>> --
>> 2.34.1
>>
>>
>> _______________________________________________
>> linux-arm-kernel mailing list
>> linux-arm-kernel@lists.infradead.org
>> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel

