Return-Path: <SRS0=fFzG=7R=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18552C433DF
	for <linux-crypto@archiver.kernel.org>; Thu,  4 Jun 2020 13:53:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E893C207D8
	for <linux-crypto@archiver.kernel.org>; Thu,  4 Jun 2020 13:53:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728688AbgFDNxG (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 4 Jun 2020 09:53:06 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:60582 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728666AbgFDNxG (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 4 Jun 2020 09:53:06 -0400
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id D4DCC29C3458C616DBC9;
        Thu,  4 Jun 2020 21:53:03 +0800 (CST)
Received: from [10.63.139.185] (10.63.139.185) by
 DGGEMS407-HUB.china.huawei.com (10.3.19.207) with Microsoft SMTP Server id
 14.3.487.0; Thu, 4 Jun 2020 21:52:55 +0800
Subject: Re: [PATCH] crypto: hisilicon - fix strncpy warning with strlcpy
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        Zhangfei Gao <zhangfei.gao@linaro.org>
References: <202006032110.BEbKqovX%lkp@intel.com>
 <1591241524-6452-1-git-send-email-zhangfei.gao@linaro.org>
 <20200604033918.GA2286@gondor.apana.org.au>
 <b6ad8af2-1cb7-faac-0446-5e09e97f3616@linaro.org>
 <20200604061811.GA28759@gondor.apana.org.au>
 <b23433f8-d95d-8142-c830-fb92e5ccd4a1@linaro.org>
 <20200604065009.GA29822@gondor.apana.org.au>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
        <kbuild-all@lists.01.org>
From:   Zhou Wang <wangzhou1@hisilicon.com>
Message-ID: <5ED8FCB7.1020305@hisilicon.com>
Date:   Thu, 4 Jun 2020 21:52:55 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:38.0) Gecko/20100101
 Thunderbird/38.5.1
MIME-Version: 1.0
In-Reply-To: <20200604065009.GA29822@gondor.apana.org.au>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.63.139.185]
X-CFilter-Loop: Reflected
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 2020/6/4 14:50, Herbert Xu wrote:
> On Thu, Jun 04, 2020 at 02:44:16PM +0800, Zhangfei Gao wrote:
>>
>> I think it is fine.
>> 1. Currently the name size is 64, bigger enough.
>> Simply grep in driver name, 64 should be enough.
>> We can make it larger when there is a request.
>> 2. it does not matter what the name is, since it is just an interface.
>> cat /sys/class/uacce/hisi_zip-0/flags
>> cat /sys/class/uacce/his-0/flags
>> should be both fine to app only they can be distinguished.
>> 3. It maybe a hard restriction to fail just because of a long name.
> 
> I think we should err on the side of caution.  IOW, unless you
> know that you need it to succeed when it exceeds the limit, then
> you should just make it fail.

Yes. We need make it fail to avoid silent truncation.

> 
> Thanks,
> 
