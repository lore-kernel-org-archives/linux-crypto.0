Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A893C433B4
	for <linux-crypto@archiver.kernel.org>; Wed, 12 May 2021 07:04:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6E3EF6188B
	for <linux-crypto@archiver.kernel.org>; Wed, 12 May 2021 07:04:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229627AbhELHFY (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 12 May 2021 03:05:24 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:2636 "EHLO
        szxga06-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229626AbhELHFY (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 12 May 2021 03:05:24 -0400
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4Fg5Lz70RMzld5G;
        Wed, 12 May 2021 15:02:03 +0800 (CST)
Received: from [10.174.178.208] (10.174.178.208) by
 DGGEMS409-HUB.china.huawei.com (10.3.19.209) with Microsoft SMTP Server id
 14.3.498.0; Wed, 12 May 2021 15:04:07 +0800
Subject: Re: [PATCH -next] crypto: hisilicon -: switch to memdup_user_nul()
To:     Zhou Wang <wangzhou1@hisilicon.com>, <herbert@gondor.apana.org.au>,
        <davem@davemloft.net>
CC:     <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <1620715031-107265-1-git-send-email-zou_wei@huawei.com>
 <c3bfff60-5e78-c0b0-797b-499c70da0ff2@hisilicon.com>
From:   Samuel Zou <zou_wei@huawei.com>
Message-ID: <04aa944f-c07c-1263-a17d-ac647725e2b9@huawei.com>
Date:   Wed, 12 May 2021 15:04:07 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <c3bfff60-5e78-c0b0-797b-499c70da0ff2@hisilicon.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.178.208]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi,

Sorry for the mistake, I will send v2 soon.

On 2021/5/11 15:07, Zhou Wang wrote:
> On 2021/5/11 14:37, Zou Wei wrote:
>> Use memdup_user_nul() helper instead of open-coding to
>> simplify the code.
>>
>> Reported-by: Hulk Robot <hulkci@huawei.com>
>> Signed-off-by: Zou Wei <zou_wei@huawei.com>
>> ---
>>   drivers/crypto/hisilicon/qm.c | 11 ++---------
>>   1 file changed, 2 insertions(+), 9 deletions(-)
>>
>> diff --git a/drivers/crypto/hisilicon/qm.c b/drivers/crypto/hisilicon/qm.c
>> index ce439a0..83a5d30 100644
>> --- a/drivers/crypto/hisilicon/qm.c
>> +++ b/drivers/crypto/hisilicon/qm.c
>> @@ -1570,17 +1570,10 @@ static ssize_t qm_cmd_write(struct file *filp, const char __user *buffer,
>>   	if (count > QM_DBG_WRITE_LEN)
>>   		return -ENOSPC;
>>   
>> -	cmd_buf = kzalloc(count + 1, GFP_KERNEL);
>> -	if (!cmd_buf)
>> +	cmd_buf = memdup_user_nul(buffer, count);
>> +	if (IS_ERR(cmd_buf))
>>   		return -ENOMEM;
>>   
>> -	if (copy_from_user(cmd_buf, buffer, count)) {
>> -		kfree(cmd_buf);
>> -		return -EFAULT;
>> -	}
>> -
>> -	cmd_buf[count] = '\0';
>> -
>>   	cmd_buf_tmp = strchr(cmd_buf, '\n');
>>   	if (cmd_buf_tmp) {
>>   		*cmd_buf_tmp = '\0';
>>
> 
> It is fine to me, thanks!
> 
> BTW, normally we use crypto: hisilicon - switch to memdup_user_nul() as the subject line,
> just like other patches :)
> 
> .
> 
