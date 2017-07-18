From: Suniel Mahesh <sunil.m@techveda.org>
Subject: Re: [PATCH 1/3] staging: ccree: Replace kzalloc with devm_kzalloc
Date: Tue, 18 Jul 2017 10:04:54 +0530
Message-ID: <86219666-8252-c175-c5a0-cffd6a5584c4@techveda.org>
References: <1500105116-30290-1-git-send-email-sunil.m@techveda.org>
 <1500105116-30290-2-git-send-email-sunil.m@techveda.org>
 <20170717123306.GF24503@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: gilad@benyossef.com, devel@driverdev.osuosl.org,
        driverdev-devel@linuxdriverproject.org, karthik@techveda.org,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
To: Greg KH <gregkh@linuxfoundation.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:36573 "EHLO
        mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751072AbdGREfA (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 18 Jul 2017 00:35:00 -0400
Received: by mail-pf0-f194.google.com with SMTP id a11so1253642pfj.3
        for <linux-crypto@vger.kernel.org>; Mon, 17 Jul 2017 21:35:00 -0700 (PDT)
In-Reply-To: <20170717123306.GF24503@kroah.com>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Monday 17 July 2017 06:03 PM, Greg KH wrote:
> On Sat, Jul 15, 2017 at 01:21:54PM +0530, sunil.m@techveda.org wrote:
>> From: Suniel Mahesh <sunil.m@techveda.org>
>>
>> It is recommended to use managed function devm_kzalloc, which
>> simplifies driver cleanup paths and driver code.
>> This patch does the following:
>> (a) replace kzalloc with devm_kzalloc.
>> (b) drop kfree(), because memory allocated with devm_kzalloc() is
>> automatically freed on driver detach, otherwise it leads to a double
>> free.
>> (c) remove unnecessary blank lines.
>>
>> Signed-off-by: Suniel Mahesh <sunil.m@techveda.org>
>> ---
>> Note:
>> - Patch was tested and built(ARCH=arm) on next-20170714.
>>   No build issues reported, however it was not tested on
>>   real hardware.
>> ---
>>  drivers/staging/ccree/ssi_driver.c | 10 ++++------
>>  1 file changed, 4 insertions(+), 6 deletions(-)
>>
>> diff --git a/drivers/staging/ccree/ssi_driver.c b/drivers/staging/ccree/ssi_driver.c
>> index 78709b92..f231ecf 100644
>> --- a/drivers/staging/ccree/ssi_driver.c
>> +++ b/drivers/staging/ccree/ssi_driver.c
>> @@ -224,13 +224,15 @@ static int init_cc_resources(struct platform_device *plat_dev)
>>  	struct resource *req_mem_cc_regs = NULL;
>>  	void __iomem *cc_base = NULL;
>>  	bool irq_registered = false;
>> -	struct ssi_drvdata *new_drvdata = kzalloc(sizeof(struct ssi_drvdata), GFP_KERNEL);
>> +	struct ssi_drvdata *new_drvdata;
>>  	struct device *dev = &plat_dev->dev;
>>  	struct device_node *np = dev->of_node;
>>  	u32 signature_val;
>>  	int rc = 0;
>>  
>> -	if (unlikely(!new_drvdata)) {
>> +	new_drvdata = devm_kzalloc(&plat_dev->dev, sizeof(struct ssi_drvdata),
> 
> sizeof(*new_drvdata), right?
> 
Yes, sending v2 in a while. Thanks for the review
suniel
> thanks,
> 
> greg k-h
> 
