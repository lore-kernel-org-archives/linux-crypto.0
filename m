Return-Path: <SRS0=wQ8K=4O=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E98CC4BA09
	for <linux-crypto@archiver.kernel.org>; Wed, 26 Feb 2020 01:42:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DA5532082F
	for <linux-crypto@archiver.kernel.org>; Wed, 26 Feb 2020 01:42:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729465AbgBZBmp (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 25 Feb 2020 20:42:45 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:11106 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729403AbgBZBmp (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 25 Feb 2020 20:42:45 -0500
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 0084616CA8CEA96D3FCD;
        Wed, 26 Feb 2020 09:42:42 +0800 (CST)
Received: from [127.0.0.1] (10.63.139.185) by DGGEMS411-HUB.china.huawei.com
 (10.3.19.211) with Microsoft SMTP Server id 14.3.439.0; Wed, 26 Feb 2020
 09:42:34 +0800
Subject: Re: [PATCH -next] crypto: hisilicon - qm depends on UACCE
To:     Herbert Xu <herbert@gondor.apana.org.au>
References: <20200225030356.44008-1-yaohongbo@huawei.com>
 <5E54DE89.2030703@hisilicon.com> <20200225102237.GA31328@gondor.apana.org.au>
CC:     Hongbo Yao <yaohongbo@huawei.com>, <davem@davemloft.net>,
        <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
        <chenzhou10@huawei.com>, <xuzaibo@huawei.com>
From:   Zhou Wang <wangzhou1@hisilicon.com>
Message-ID: <5E55CD0A.4060209@hisilicon.com>
Date:   Wed, 26 Feb 2020 09:42:34 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:38.0) Gecko/20100101
 Thunderbird/38.5.1
MIME-Version: 1.0
In-Reply-To: <20200225102237.GA31328@gondor.apana.org.au>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.63.139.185]
X-CFilter-Loop: Reflected
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 2020/2/25 18:22, Herbert Xu wrote:
> On Tue, Feb 25, 2020 at 04:44:57PM +0800, Zhou Wang wrote:
>>
>>> diff --git a/drivers/crypto/hisilicon/Kconfig b/drivers/crypto/hisilicon/Kconfig
>>> index 8851161f722f..b35c2ec15bc2 100644
>>> --- a/drivers/crypto/hisilicon/Kconfig
>>> +++ b/drivers/crypto/hisilicon/Kconfig
>>> @@ -40,6 +40,7 @@ config CRYPTO_DEV_HISI_QM
>>>  	tristate
>>>  	depends on ARM64 || COMPILE_TEST
>>>  	depends on PCI && PCI_MSI
>>> +	depends on UACCE
>>>  	help
>>>  	  HiSilicon accelerator engines use a common queue management
>>>  	  interface. Specific engine driver may use this module.
>>>
>>
>> Indeed, this driver does not depend on uacce fully, as if there is no uacce, it still can
>> register to kernel crypto.
>>
>> Seems that changing uacce config to bool can avoid this problem.
> 
> You shouldn't make it a bool.  The standard way to solve this is to
> add this:
> 
> 	depends on UACCE || UACCE=n

Thanks! Let's fix together with zip Kconfig.

Best,
Zhou

> 
> Cheers,
> 

