From: Dmitry Kasatkin <dmitry.kasatkin@nokia.com>
Subject: Re: [PATCH 01/16] crypto: omap-aes: don't treat NULL clk as an error
Date: Wed, 12 Jan 2011 16:32:31 +0200
Message-ID: <4D2DBB7F.4030402@nokia.com>
References: <1294749833-32019-1-git-send-email-jamie@jamieiles.com> <1294749833-32019-2-git-send-email-jamie@jamieiles.com> <alpine.DEB.1.10.1101111755500.18906@esdhcp041196.research.nokia.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Cc: Jamie Iles <jamie@jamieiles.com>, <linux-kernel@vger.kernel.org>,
	<linux-crypto@vger.kernel.org>
To: Aaro Koskinen <aaro.koskinen@nokia.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.128.26]:30250 "EHLO mgw-da02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750915Ab1ALOci (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 12 Jan 2011 09:32:38 -0500
In-Reply-To: <alpine.DEB.1.10.1101111755500.18906@esdhcp041196.research.nokia.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi,

Indeed, thanks

On 11/01/11 17:56, Aaro Koskinen wrote:
> Hi,
>
> On Tue, 11 Jan 2011, Jamie Iles wrote:
>
>> clk_get() returns a struct clk cookie to the driver and some platforms
>> may return NULL if they only support a single clock.  clk_get() has only
>> failed if it returns a ERR_PTR() encoded pointer.
>>
>> Cc: Dmitry Kasatkin <dmitry.kasatkin@nokia.com>
>> Cc: linux-crypto@vger.kernel.org
>> Signed-off-by: Jamie Iles <jamie@jamieiles.com>
>
> Reviewed-by: Aaro Koskinen <aaro.koskinen@nokia.com>
Reviewed-by: Dmitry Kasatkin <dmitry.kasatkin@nokia.com>
>
>> ---
>> drivers/crypto/omap-aes.c |    5 +++--
>> 1 files changed, 3 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/crypto/omap-aes.c b/drivers/crypto/omap-aes.c
>> index 799ca51..24d0f3f 100644
>> --- a/drivers/crypto/omap-aes.c
>> +++ b/drivers/crypto/omap-aes.c
>> @@ -17,6 +17,7 @@
>> #include <linux/err.h>
>> #include <linux/module.h>
>> #include <linux/init.h>
>> +#include <linux/err.h>
>> #include <linux/errno.h>
>> #include <linux/kernel.h>
>> #include <linux/clk.h>
>> @@ -830,9 +831,9 @@ static int omap_aes_probe(struct platform_device
>> *pdev)
>>
>>     /* Initializing the clock */
>>     dd->iclk = clk_get(dev, "ick");
>> -    if (!dd->iclk) {
>> +    if (IS_ERR(dd->iclk)) {
>>         dev_err(dev, "clock intialization failed.\n");
>> -        err = -ENODEV;
>> +        err = PTR_ERR(dd->iclk);
>>         goto err_res;
>>     }
>>
>> -- 
>> 1.7.3.4
>>
>> -- 
>> To unsubscribe from this list: send the line "unsubscribe
>> linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>>
