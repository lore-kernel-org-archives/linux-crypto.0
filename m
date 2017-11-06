From: Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH 11/12] hwrng: bcm2835-rng: Enable BCM2835 RNG to work on
 BCM63xx platforms
Date: Mon, 6 Nov 2017 12:16:02 -0800
Message-ID: <2538f1bb-e0f8-c336-d82a-0cb2f19b0ead@gmail.com>
References: <20171102010408.27736-1-f.fainelli@gmail.com>
 <20171102010408.27736-12-f.fainelli@gmail.com>
 <1831955836.132229.1509820078271@email.1und1.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: Krzysztof Kozlowski <krzk@kernel.org>, Ray Jui <rjui@broadcom.com>,
        Eric Anholt <eric@anholt.net>,
        Rob Herring <robh+dt@kernel.org>,
        Steffen Trumtrar <s.trumtrar@pengutronix.de>,
        Harald Freudenberger <freude@linux.vnet.ibm.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        "moderated list:BROADCOM BCM2835 ARM ARCHITECTURE"
        <linux-arm-kernel@lists.infradead.org>,
        PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>,
        Scott Branden <sbranden@broadcom.com>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE"
        <linux-crypto@vger.kernel.org>, Martin Kaiser <martin@kaiser.cx>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "maintainer:BROADCOM BCM281XX/BCM11XXX/BCM216XX ARM ARCHITE..."
        <bcm-kernel-feedback-list@broadcom.com>,
        Matt Mackall <mpm@selenic.com>,
        Mark Rutlan
To: Stefan Wahren <stefan.wahren@i2se.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-qt0-f193.google.com ([209.85.216.193]:52908 "EHLO
        mail-qt0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751951AbdKFUQM (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 6 Nov 2017 15:16:12 -0500
In-Reply-To: <1831955836.132229.1509820078271@email.1und1.de>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 11/04/2017 11:27 AM, Stefan Wahren wrote:
> Hi Florian
> 
>> Florian Fainelli <f.fainelli@gmail.com> hat am 2. November 2017 um 02:04 geschrieben:
>>
>>
>> We have now incorporated all necessary functionality for the BCM63xx
>> platforms to successfully migrate over bcm2835-rng, so add the final
>> bits: Kconfig selection and proper platform_device device type matching
>> to keep the same platform device name for registration to work.
>>
>> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
>> ---
>>  drivers/char/hw_random/Kconfig       |  7 ++++---
>>  drivers/char/hw_random/bcm2835-rng.c | 11 ++++++++++-
>>  2 files changed, 14 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/char/hw_random/Kconfig b/drivers/char/hw_random/Kconfig
>> index 95a031e9eced..d0689cc8c7fc 100644
>> --- a/drivers/char/hw_random/Kconfig
>> +++ b/drivers/char/hw_random/Kconfig
>> @@ -87,12 +87,13 @@ config HW_RANDOM_BCM63XX
>>  	  If unusure, say Y.
>>  
>>  config HW_RANDOM_BCM2835
>> -	tristate "Broadcom BCM2835 Random Number Generator support"
>> -	depends on ARCH_BCM2835 || ARCH_BCM_NSP || ARCH_BCM_5301X
>> +	tristate "Broadcom BCM2835/BCM63xx Random Number Generator support"
>> +	depends on ARCH_BCM2835 || ARCH_BCM_NSP || ARCH_BCM_5301X || \
>> +		   ARCH_BCM_63XX || BCM63XX || BMIPS_GENERIC
>>  	default HW_RANDOM
>>  	---help---
>>  	  This driver provides kernel-side support for the Random Number
>> -	  Generator hardware found on the Broadcom BCM2835 SoCs.
>> +	  Generator hardware found on the Broadcom BCM2835 and BCM63xx SoCs.
>>  
>>  	  To compile this driver as a module, choose M here: the
>>  	  module will be called bcm2835-rng
>> diff --git a/drivers/char/hw_random/bcm2835-rng.c b/drivers/char/hw_random/bcm2835-rng.c
>> index 650e0033c273..d9ffe14f312b 100644
>> --- a/drivers/char/hw_random/bcm2835-rng.c
>> +++ b/drivers/char/hw_random/bcm2835-rng.c
>> @@ -131,6 +131,7 @@ static const struct of_device_id bcm2835_rng_of_match[] = {
>>  	{ .compatible = "brcm,bcm2835-rng"},
>>  	{ .compatible = "brcm,bcm-nsp-rng", .data = &nsp_rng_of_data },
>>  	{ .compatible = "brcm,bcm5301x-rng", .data = &nsp_rng_of_data },
>> +	{ .compatible = "brcm,bcm6368-rng"},
>>  	{},
>>  };
>>  
>> @@ -164,7 +165,7 @@ static int bcm2835_rng_probe(struct platform_device *pdev)
>>  	if (IS_ERR(priv->clk))
>>  		priv->clk = NULL;
>>  
>> -	priv->rng.name = "bcm2835-rng";
>> +	priv->rng.name = pdev->id_entry->name;
> 
> this change breaks registration on bcm2835, because the name is NULL.

OH right, I will fix that in v2, I am assuming that if you did something
like this, things still work correctly for you on 2835:

if (!priv->id_entry->name)
	priv->rng.name = "bcm2835-rng";
else
	priv->rng.name = priv->id_entry->name;

?

> 
> Regards
> Stefan
> 
>>  	priv->rng.init = bcm2835_rng_init;
>>  	priv->rng.read = bcm2835_rng_read;
>>  	priv->rng.cleanup = bcm2835_rng_cleanup;
>> @@ -190,12 +191,20 @@ static int bcm2835_rng_probe(struct platform_device *pdev)
>>  
>>  MODULE_DEVICE_TABLE(of, bcm2835_rng_of_match);
>>  
>> +static struct platform_device_id bcm2835_rng_devtype[] = {
>> +	{ .name = "bcm2835-rng" },
>> +	{ .name = "bcm63xx-rng" },
>> +	{ /* sentinel */ }
>> +};
>> +MODULE_DEVICE_TABLE(platform, bcm2835_rng_devtype);
>> +
>>  static struct platform_driver bcm2835_rng_driver = {
>>  	.driver = {
>>  		.name = "bcm2835-rng",
>>  		.of_match_table = bcm2835_rng_of_match,
>>  	},
>>  	.probe		= bcm2835_rng_probe,
>> +	.id_table	= bcm2835_rng_devtype,
>>  };
>>  module_platform_driver(bcm2835_rng_driver);
>>  
>> -- 
>> 2.9.3
>>
>>
>> _______________________________________________
>> linux-arm-kernel mailing list
>> linux-arm-kernel@lists.infradead.org
>> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel


-- 
Florian
