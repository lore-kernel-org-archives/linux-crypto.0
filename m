Return-Path: <SRS0=EVKT=6F=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31925C55181
	for <linux-crypto@archiver.kernel.org>; Tue, 21 Apr 2020 11:20:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 174642076B
	for <linux-crypto@archiver.kernel.org>; Tue, 21 Apr 2020 11:20:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728597AbgDULUj (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 21 Apr 2020 07:20:39 -0400
Received: from cmccmta1.chinamobile.com ([221.176.66.79]:13042 "EHLO
        cmccmta1.chinamobile.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726691AbgDULUi (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 21 Apr 2020 07:20:38 -0400
Received: from spf.mail.chinamobile.com (unknown[172.16.121.11]) by rmmx-syy-dmz-app04-12004 (RichMail) with SMTP id 2ee45e9ed6f055e-ee89b; Tue, 21 Apr 2020 19:20:20 +0800 (CST)
X-RM-TRANSID: 2ee45e9ed6f055e-ee89b
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG: 00000000
Received: from [172.20.146.166] (unknown[112.25.154.146])
        by rmsmtp-syy-appsvr06-12006 (RichMail) with SMTP id 2ee65e9ed6f215c-ede35;
        Tue, 21 Apr 2020 19:20:20 +0800 (CST)
X-RM-TRANSID: 2ee65e9ed6f215c-ede35
Subject: Re: [PATCH] crypto: Delete redundant variable definition
To:     Joe Perches <joe@perches.com>, davem@davemloft.net,
        herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Shengju Zhang <zhangshengju@cmss.chinamobile.com>
References: <20200419071245.3924-1-tangbin@cmss.chinamobile.com>
 <e4a2c1206cc8009f0e0881e2b9ec2e828c5d9e7c.camel@perches.com>
From:   Tang Bin <tangbin@cmss.chinamobile.com>
Message-ID: <74fa3578-b62f-4618-4af1-d8105e561800@cmss.chinamobile.com>
Date:   Tue, 21 Apr 2020 19:22:20 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <e4a2c1206cc8009f0e0881e2b9ec2e828c5d9e7c.camel@perches.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi, Joe:

On 2020/4/19 19:44, Joe Perches wrote:
> On Sun, 2020-04-19 at 15:12 +0800, Tang Bin wrote:
>> The variable "i" is redundant to be assigned a value
>> of zero,because it's assigned in the for loop, so remove
>> redundant one here.
>>
>> Signed-off-by: Shengju Zhang <zhangshengju@cmss.chinamobile.com>
>> Signed-off-by: Tang Bin <tangbin@cmss.chinamobile.com>
>>
>> ---
>>   drivers/crypto/bcm/cipher.c | 1 -
>>   1 file changed, 1 deletion(-)
>>
>> diff --git a/drivers/crypto/bcm/cipher.c b/drivers/crypto/bcm/cipher.c
>> index c8b940854..5db23c18c 100644
>> --- a/drivers/crypto/bcm/cipher.c
>> +++ b/drivers/crypto/bcm/cipher.c
>> @@ -4724,7 +4724,6 @@ static int spu_dt_read(struct platform_device *pdev)
>>   	spu->spu_type = matched_spu_type->type;
>>   	spu->spu_subtype = matched_spu_type->subtype;
>>   
>> -	i = 0;
>>   	for (i = 0; (i < MAX_SPUS) && ((spu_ctrl_regs =
>>   		platform_get_resource(pdev, IORESOURCE_MEM, i)) != NULL); i++) {
> Maybe the for loop could be simplified too by
> moving the assignment inside the loop.
>
> Also, the %pe extension could be used.

Sorry for the delay. Thank you for your advice, I was already thinking 
about optimizing this place.

Thanks,

Tang Bin


>


