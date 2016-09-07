From: Romain Perier <romain.perier@free-electrons.com>
Subject: Re: [PATCH 4/9] hwrng: omap - Use the managed device resource API for
 registration
Date: Wed, 7 Sep 2016 16:23:53 +0200
Message-ID: <57D022F9.2020407@free-electrons.com>
References: <20160906153857.5503-1-romain.perier@free-electrons.com>
 <20160906153857.5503-5-romain.perier@free-electrons.com>
 <CANc+2y6LeOqSy37x=vXaLPkGM3C5Wh6Yq11ybO+-0DU19wLBUQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Cc: dsaxena@plexity.net, mpm@selenic.com,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Nadav Haklai <nadavh@marvell.com>,
        Omri Itach <omrii@marvell.com>,
        Shadi Ammouri <shadi@marvell.com>,
        Yahuda Yitschak <yehuday@marvell.com>,
        Hanna Hawa <hannah@marvell.com>,
        Neta Zur Hershkovits <neta@marvell.com>,
        Igal Liberman <igall@marvell.com>,
        Marcin Wojtas <mw@semihalf.com>, linux-crypto@vger.kernel.org
To: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from down.free-electrons.com ([37.187.137.238]:38751 "EHLO
        mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1756118AbcIGOX4 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 7 Sep 2016 10:23:56 -0400
In-Reply-To: <CANc+2y6LeOqSy37x=vXaLPkGM3C5Wh6Yq11ybO+-0DU19wLBUQ@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hello,

Le 06/09/2016 18:31, PrasannaKumar Muralidharan a écrit :
>> Use devm_hwrng_register instead of hwrng_register. It avoids the need
>> to handle unregistration explicitly from the remove function.
>>
>> Signed-off-by: Romain Perier <romain.perier@free-electrons.com>
>> ---
>>   drivers/char/hw_random/omap-rng.c | 4 +---
>>   1 file changed, 1 insertion(+), 3 deletions(-)
>>
>> diff --git a/drivers/char/hw_random/omap-rng.c b/drivers/char/hw_random/omap-rng.c
>> index d47b24d..171c3e8 100644
>> --- a/drivers/char/hw_random/omap-rng.c
>> +++ b/drivers/char/hw_random/omap-rng.c
>> @@ -381,7 +381,7 @@ static int omap_rng_probe(struct platform_device *pdev)
>>          if (ret)
>>                  goto err_ioremap;
>>
>> -       ret = hwrng_register(&omap_rng_ops);
>> +       ret = devm_hwrng_register(dev, &omap_rng_ops);
>>          if (ret)
>>                  goto err_register;
>>
>> @@ -402,8 +402,6 @@ static int omap_rng_remove(struct platform_device *pdev)
>>   {
>>          struct omap_rng_dev *priv = platform_get_drvdata(pdev);
>>
>> -       hwrng_unregister(&omap_rng_ops);
>> -
>>          priv->pdata->cleanup(priv);
>>
>>          pm_runtime_put_sync(&pdev->dev);
>> --
>
> If devm_hwrng_register is used hwrng_unregister will be called after
> pm_runtime_disable is called. If RNG device is in use calling
> omap_rng_remove may not work properly.
>

The case where the remove function is called is if you unbind the driver 
by hand or you call rmmod while the RNG device is used.
I don't think that the kernel will call platform->remove is the device 
is in use (so /dev/hwrng). I mean the argument that the unregister 
function is called after pm_runtime_disable is correct, but I don't 
think that the remove function might be called while the device is in 
use. There is necessarily a mutual exclusive case between "use the 
device" and "call the remove function of the device". However, I am open 
to suggestions.

Regards,
-- 
Romain Perier, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
