From: Nishanth Menon <nm@ti.com>
Subject: Re: [PATCH] hwrng: OMAP: Fix assumption that runtime_get_sync will
 always succeed
Date: Fri, 24 Jun 2016 11:46:58 -0500
Message-ID: <576D6402.1090201@ti.com>
References: <1466783867-25743-1-git-send-email-nm@ti.com>
 <576D6156.2050508@ti.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	Paul Walmsley <paul@pwsan.com>
To: Suman Anna <s-anna@ti.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Matt Mackall <mpm@selenic.com>,
	Deepak Saxena <dsaxena@plexity.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([198.47.19.12]:42558 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751089AbcFXQr1 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 24 Jun 2016 12:47:27 -0400
In-Reply-To: <576D6156.2050508@ti.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 06/24/2016 11:35 AM, Suman Anna wrote:
[...]
>> diff --git a/drivers/char/hw_random/omap-rng.c b/drivers/char/hw_random/omap-rng.c
>> index 8a1432e8bb80..f30a1870cb64 100644
>> --- a/drivers/char/hw_random/omap-rng.c
>> +++ b/drivers/char/hw_random/omap-rng.c
>> @@ -384,7 +384,11 @@ static int omap_rng_probe(struct platform_device *pdev)
>>  	}
>>  
>>  	pm_runtime_enable(&pdev->dev);
>> -	pm_runtime_get_sync(&pdev->dev);
>> +	ret = pm_runtime_get_sync(&pdev->dev);
>> +	if (ret) {
>> +		dev_err(&pdev->dev, "Failed to runtime_get device: %d\n", ret);
>> +		goto err_ioremap;
> 
> You need to also add a pm_runtime_put_noidle() on get_sync failures to
> balance the device's power usage_count.
> 

Crap, yep, I should have known better. thanks for catching it.. v2
incoming..


-- 
Regards,
Nishanth Menon
