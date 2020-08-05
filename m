Return-Path: <SRS0=mrTw=BP=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B588C433E0
	for <linux-crypto@archiver.kernel.org>; Wed,  5 Aug 2020 01:58:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F029A208C7
	for <linux-crypto@archiver.kernel.org>; Wed,  5 Aug 2020 01:58:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726011AbgHEB6R (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 4 Aug 2020 21:58:17 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:50712 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725981AbgHEB6R (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 4 Aug 2020 21:58:17 -0400
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 333DC5996704AFF08E50;
        Wed,  5 Aug 2020 09:58:10 +0800 (CST)
Received: from [127.0.0.1] (10.74.173.29) by DGGEMS407-HUB.china.huawei.com
 (10.3.19.207) with Microsoft SMTP Server id 14.3.487.0; Wed, 5 Aug 2020
 09:58:00 +0800
Subject: Re: [PATCH v4 01/10] crypto: hisilicon/qm - fix wrong release after
 using strsep
To:     Markus Elfring <Markus.Elfring@web.de>,
        Sihang Chen <chensihang1@hisilicon.com>,
        <linux-crypto@vger.kernel.org>
References: <96ffa633-dda1-7ad1-72da-5563906c1561@web.de>
CC:     <linux-kernel@vger.kernel.org>, <kernel-janitors@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Zaibo Xu <xuzaibo@huawei.com>,
        Zhou Wang <wangzhou1@hisilicon.com>
From:   "shenyang (M)" <shenyang39@huawei.com>
Message-ID: <425f4bdd-cf55-6537-28bf-0377564b531b@huawei.com>
Date:   Wed, 5 Aug 2020 09:58:00 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
MIME-Version: 1.0
In-Reply-To: <96ffa633-dda1-7ad1-72da-5563906c1561@web.de>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.74.173.29]
X-CFilter-Loop: Reflected
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org



On 2020/8/5 2:34, Markus Elfring wrote:
> …
>> +++ b/drivers/crypto/hisilicon/qm.c
>> @@ -1420,16 +1420,17 @@ static int qm_dbg_help(struct hisi_qm *qm, char *s)
> …
>> +	s_tmp = s;
>>  	presult = strsep(&s, " ");
>>  	if (!presult) {
>> -		kfree(s);
>> +		kfree(s_tmp);
>>  		return -EINVAL;
>>  	}
>
> -		kfree(s);
> -		return -EINVAL;
> +		ret = -EINVAL;
> +		goto free_tmp;
>
> I suggest to add a jump target for the desired exception handling.
>
> Regards,
> Markus
>
> .
>

Thanks for your review. There is only one error branch need to do
something uninit. So I think the jump is not necessary and will
affect code reading.:)

Thanks,
Yang

