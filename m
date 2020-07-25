Return-Path: <SRS0=tM/H=BE=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E01BC433E4
	for <linux-crypto@archiver.kernel.org>; Sat, 25 Jul 2020 09:00:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7F4B0206D8
	for <linux-crypto@archiver.kernel.org>; Sat, 25 Jul 2020 09:00:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726799AbgGYJAP (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 25 Jul 2020 05:00:15 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:8826 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726583AbgGYJAO (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 25 Jul 2020 05:00:14 -0400
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id B6D16A367BFF0ECA328B;
        Sat, 25 Jul 2020 17:00:07 +0800 (CST)
Received: from [127.0.0.1] (10.174.179.91) by DGGEMS404-HUB.china.huawei.com
 (10.3.19.204) with Microsoft SMTP Server id 14.3.487.0; Sat, 25 Jul 2020
 17:00:03 +0800
Subject: Re: [PATCH -next] crypto: caam: Convert to DEFINE_SHOW_ATTRIBUTE
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        =?UTF-8?Q?Horia_Geant=c4=83?= <horia.geanta@nxp.com>
CC:     <gregkh@linuxfoundation.org>, <aymen.sghaier@nxp.com>,
        <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <20200723072511.GA6095@gondor.apana.org.au>
From:   miaoqinglang <miaoqinglang@huawei.com>
Message-ID: <62dc973d-71b6-c8ec-9f7a-f1c421a7b1d3@huawei.com>
Date:   Sat, 25 Jul 2020 17:00:02 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200723072511.GA6095@gondor.apana.org.au>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.179.91]
X-CFilter-Loop: Reflected
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org



在 2020/7/23 15:25, Herbert Xu 写道:
> Horia Geantă <horia.geanta@nxp.com> wrote:
>> On 7/16/2020 12:00 PM, Qinglang Miao wrote:
>>> From: Liu Shixin <liushixin2@huawei.com>
>>>
>>> Use DEFINE_SHOW_ATTRIBUTE macro to simplify the code.
>>>
>>> Signed-off-by: Liu Shixin <liushixin2@huawei.com>
>> Reviewed-by: Horia Geantă <horia.geanta@nxp.com>
>>
>> This patch depends on linux-next
>> commit 4d4901c6d748 ("seq_file: switch over direct seq_read method calls to seq_read_iter")
> 
> Please postpone these cleanups until that patch hits mainline.
> 
> Thanks,
> 
Hi Horia,

I'm agree with what you said and I would repostpone these patch when it 
hits mainline.

Or If you don't mind, I can resend a patch besed on mainline rather than 
-next now.

Thanks,

Qinglang.

