Return-Path: <SRS0=4UkV=XO=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2AAF3C3A5A6
	for <linux-crypto@archiver.kernel.org>; Thu, 19 Sep 2019 08:11:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 05F8D207FC
	for <linux-crypto@archiver.kernel.org>; Thu, 19 Sep 2019 08:11:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731681AbfISIL3 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 19 Sep 2019 04:11:29 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:2735 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727033AbfISIL3 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 19 Sep 2019 04:11:29 -0400
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 81500F5F3AA2D190C1C0;
        Thu, 19 Sep 2019 16:11:25 +0800 (CST)
Received: from [127.0.0.1] (10.63.139.185) by DGGEMS403-HUB.china.huawei.com
 (10.3.19.203) with Microsoft SMTP Server id 14.3.439.0; Thu, 19 Sep 2019
 16:11:15 +0800
Subject: Re: [PATCH 2/2] crypto: hisilicon - avoid unused function warning
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        Arnd Bergmann <arnd@arndb.de>
References: <20190906152250.1450649-1-arnd@arndb.de>
 <20190906152250.1450649-2-arnd@arndb.de>
 <20190913091718.GA6382@gondor.apana.org.au>
CC:     "David S. Miller" <davem@davemloft.net>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Hao Fang <fanghao11@huawei.com>,
        Kenneth Lee <liguozhu@hisilicon.com>,
        <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
From:   Zhou Wang <wangzhou1@hisilicon.com>
Message-ID: <5D833821.5000504@hisilicon.com>
Date:   Thu, 19 Sep 2019 16:11:13 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:38.0) Gecko/20100101
 Thunderbird/38.5.1
MIME-Version: 1.0
In-Reply-To: <20190913091718.GA6382@gondor.apana.org.au>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.63.139.185]
X-CFilter-Loop: Reflected
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 2019/9/13 17:17, Herbert Xu wrote:
> On Fri, Sep 06, 2019 at 05:22:30PM +0200, Arnd Bergmann wrote:
>> The only caller of hisi_zip_vf_q_assign() is hidden in an #ifdef,
>> so the function causes a warning when CONFIG_PCI_IOV is disabled:
>>
>> drivers/crypto/hisilicon/zip/zip_main.c:740:12: error: unused function 'hisi_zip_vf_q_assign' [-Werror,-Wunused-function]
>>
>> Move it into the same #ifdef.
>>
>> Fixes: 79e09f30eeba ("crypto: hisilicon - add SRIOV support for ZIP")
>> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
>> ---
>>  drivers/crypto/hisilicon/zip/zip_main.c | 2 ++
>>  1 file changed, 2 insertions(+)
> 
> Please find a way to fix this warning without reducing compiler
> coverage.  I prefer to see any compile issues immediately rather
> than through automated build testing.
> 
> Thanks,
>

Sorry for missing this patch.

Seems other drivers also do like using #ifdef. Do you mean something like this:
#ifdef CONFIG_PCI_IOV
sriov_enable()
...
#else
/* stub */
sriov_enable()
...
#endif

Best,
Zhou



