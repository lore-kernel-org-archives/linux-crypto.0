Return-Path: <SRS0=C62c=C3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04FB6C43463
	for <linux-crypto@archiver.kernel.org>; Fri, 18 Sep 2020 01:29:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BBCF5208C3
	for <linux-crypto@archiver.kernel.org>; Fri, 18 Sep 2020 01:29:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726117AbgIRB3a (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 17 Sep 2020 21:29:30 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:13247 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726007AbgIRB3a (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 17 Sep 2020 21:29:30 -0400
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 91D75909FAFC2E4055A2;
        Fri, 18 Sep 2020 09:29:28 +0800 (CST)
Received: from [10.174.179.91] (10.174.179.91) by
 DGGEMS408-HUB.china.huawei.com (10.3.19.208) with Microsoft SMTP Server id
 14.3.487.0; Fri, 18 Sep 2020 09:29:25 +0800
Subject: Re: [PATCH -next] crypto: caam: Convert to DEFINE_SHOW_ATTRIBUTE
To:     =?UTF-8?Q?Horia_Geant=c4=83?= <horia.geanta@nxp.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Aymen Sghaier <aymen.sghaier@nxp.com>
CC:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20200716090403.13507-1-miaoqinglang@huawei.com>
 <00ab6498-a1cb-afb2-b1e4-75389bfbbd4c@nxp.com>
From:   miaoqinglang <miaoqinglang@huawei.com>
Message-ID: <10ed0a23-a4bb-5c30-fa7e-ca9f2a20c596@huawei.com>
Date:   Fri, 18 Sep 2020 09:29:25 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <00ab6498-a1cb-afb2-b1e4-75389bfbbd4c@nxp.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.179.91]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org



在 2020/7/20 20:01, Horia Geantă 写道:
> On 7/16/2020 12:00 PM, Qinglang Miao wrote:
>> From: Liu Shixin <liushixin2@huawei.com>
>>
>> Use DEFINE_SHOW_ATTRIBUTE macro to simplify the code.
>>
>> Signed-off-by: Liu Shixin <liushixin2@huawei.com>
> Reviewed-by: Horia Geantă <horia.geanta@nxp.com>
> 
> This patch depends on linux-next
> commit 4d4901c6d748 ("seq_file: switch over direct seq_read method calls to seq_read_iter")
Hi Horia,

I noticed that 4d4901c6d748 in linux-next has been reverted, so I resent 
a new patch against linux-next(20200917), and it can be applied to 
mainline cleanly now.

Thanks.
> 
> Horia
> 
