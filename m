Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-25.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1,USER_IN_DEF_DKIM_WL autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0227C433E0
	for <linux-crypto@archiver.kernel.org>; Thu,  7 Jan 2021 12:46:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9E21D2337F
	for <linux-crypto@archiver.kernel.org>; Thu,  7 Jan 2021 12:46:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727202AbhAGMqx (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 7 Jan 2021 07:46:53 -0500
Received: from linux.microsoft.com ([13.77.154.182]:59256 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726541AbhAGMqw (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 7 Jan 2021 07:46:52 -0500
Received: from [192.168.0.114] (unknown [49.207.211.144])
        by linux.microsoft.com (Postfix) with ESMTPSA id C5DF420B7192;
        Thu,  7 Jan 2021 04:46:02 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com C5DF420B7192
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1610023571;
        bh=oRvau2/egDUl+G19e+mKJcct9N7ThAjp83e0jgPJfTU=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=ElN2p/YLxSOxarXXe6EodJy3spbth4RctmOJskoyN8cmf+kXe44AeZXr/K7pWKgss
         jHEcRvV984of41rQRvStOiGhwCs9ciGhHnZEB7KeHM+VxG8NROIKn+aUowmt2vjSJX
         zmp7qqUgujmS+rW2cP1cOdEmYc9MZHqV4iaK9orY=
Subject: Re: [PATCH v2 16/19] crypto: rockchip: convert tasklets to use new
 tasklet_setup() API
To:     Emil Renner Berthing <emil.renner.berthing@gmail.com>,
        Allen Pais <allen.lkml@gmail.com>
Cc:     herbert@gondor.apana.org.au, giovanni.cabiddu@intel.com,
        alexandre.belloni@bootlin.com, aymen.sghaier@nxp.com,
        Heiko Stuebner <heiko@sntech.de>, qat-linux@intel.com,
        jamie@jamieiles.com, jesper.nilsson@axis.com,
        linux-samsung-soc@vger.kernel.org, horia.geanta@nxp.com,
        k.konieczny@samsung.com, schalla@marvell.com, krzk@kernel.org,
        "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>,
        ludovic.desroches@microchip.com, thomas.lendacky@amd.com,
        arno@natisbad.org, vz@mleia.com, gilad@benyossef.com,
        gcherian@marvell.com, linux-mediatek@lists.infradead.org,
        lars.persson@axis.com, matthias.bgg@gmail.com, john.allen@amd.com,
        bbrezillon@kernel.org, nicolas.ferre@microchip.com,
        linux-crypto@vger.kernel.org,
        Romain Perier <romain.perier@gmail.com>,
        "David S . Miller" <davem@davemloft.net>
References: <20210107122944.16363-1-allen.lkml@gmail.com>
 <20210107122944.16363-13-allen.lkml@gmail.com>
 <CANBLGcziNt5R9H2eh=3y=jUUjFzHJo+G1FgVVYRgxZpfE8W-6Q@mail.gmail.com>
From:   Allen Pais <apais@linux.microsoft.com>
Message-ID: <546446ed-27e0-e74d-f290-cd8c9097b1ca@linux.microsoft.com>
Date:   Thu, 7 Jan 2021 18:15:56 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CANBLGcziNt5R9H2eh=3y=jUUjFzHJo+G1FgVVYRgxZpfE8W-6Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org



> 
> On Thu, 7 Jan 2021 at 13:32, Allen Pais <allen.lkml@gmail.com> wrote:
>>
>> From: Allen Pais <apais@linux.microsoft.com>
>>
>> In preparation for unconditionally passing the
>> struct tasklet_struct pointer to all tasklet
>> callbacks, switch to using the new tasklet_setup()
>> and from_tasklet() to pass the tasklet pointer explicitly.
>>
>> Signed-off-by: Romain Perier <romain.perier@gmail.com>
>> Signed-off-by: Allen Pais <apais@linux.microsoft.com>
>> ---
>>   drivers/crypto/rockchip/rk3288_crypto.c | 14 ++++++--------
>>   1 file changed, 6 insertions(+), 8 deletions(-)
>>
>> diff --git a/drivers/crypto/rockchip/rk3288_crypto.c b/drivers/crypto/rockchip/rk3288_crypto.c
>> index 35d73061d156..af6ad9f49009 100644
>> --- a/drivers/crypto/rockchip/rk3288_crypto.c
>> +++ b/drivers/crypto/rockchip/rk3288_crypto.c
>> @@ -201,9 +201,9 @@ static int rk_crypto_enqueue(struct rk_crypto_info *dev,
>>          return ret;
>>   }
>>
>> -static void rk_crypto_queue_task_cb(unsigned long data)
>> +static void rk_crypto_queue_task_cb(struct tasklet_struct *T)
>>   {
>> -       struct rk_crypto_info *dev = (struct rk_crypto_info *)data;
>> +       struct rk_crypto_info *dev = from_tasklet(dev, t, queue_task);
> 
> This doesn't look right. First it's called T and then t. I wonder how
> this even compiles..
> 

   Thanks for catching it. I am not sure how I missed it and it even 
compiled. I will fix it.

Thanks.

>>          struct crypto_async_request *async_req, *backlog;
>>          unsigned long flags;
>>          int err = 0;
>> @@ -231,9 +231,9 @@ static void rk_crypto_queue_task_cb(unsigned long data)
>>                  dev->complete(dev->async_req, err);
>>   }
>>
>> -static void rk_crypto_done_task_cb(unsigned long data)
>> +static void rk_crypto_done_task_cb(struct tasklet_struct *t)
>>   {
>> -       struct rk_crypto_info *dev = (struct rk_crypto_info *)data;
>> +       struct rk_crypto_info *dev = from_tasklet(dev, t, done_task);
>>
>>          if (dev->err) {
>>                  dev->complete(dev->async_req, dev->err);
>> @@ -389,10 +389,8 @@ static int rk_crypto_probe(struct platform_device *pdev)
>>          crypto_info->dev = &pdev->dev;
>>          platform_set_drvdata(pdev, crypto_info);
>>
>> -       tasklet_init(&crypto_info->queue_task,
>> -                    rk_crypto_queue_task_cb, (unsigned long)crypto_info);
>> -       tasklet_init(&crypto_info->done_task,
>> -                    rk_crypto_done_task_cb, (unsigned long)crypto_info);
>> +       tasklet_setup(&crypto_info->queue_task, rk_crypto_queue_task_cb);
>> +       tasklet_setup(&crypto_info->done_task, rk_crypto_done_task_cb);
>>          crypto_init_queue(&crypto_info->queue, 50);
>>
>>          crypto_info->enable_clk = rk_crypto_enable_clk;
>> --
>> 2.25.1
>>
>>
>> _______________________________________________
>> Linux-rockchip mailing list
>> Linux-rockchip@lists.infradead.org
>> http://lists.infradead.org/mailman/listinfo/linux-rockchip
