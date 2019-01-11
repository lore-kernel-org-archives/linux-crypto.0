Return-Path: <SRS0=CSIn=PT=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from szxga04-in.huawei.com ([45.249.212.190]:17104 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728958AbfAKGfG (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 11 Jan 2019 01:35:06 -0500
Subject: Re: [PATCH 3/4] crypto: hisilicon: Add HiSilicon ZIP accelerator
 support
To: Herbert Xu <herbert@gondor.apana.org.au>
References: <1545465105-133138-1-git-send-email-wangzhou1@hisilicon.com>
 <1545465105-133138-4-git-send-email-wangzhou1@hisilicon.com>
 <20190111060859.k647ltxukywjmi3l@gondor.apana.org.au>
CC: "David S . Miller" <davem@davemloft.net>,
        <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linuxarm@huawei.com>, Shiju Jose <shiju.jose@huawei.com>,
        Kenneth Lee <liguozhu@hisilicon.com>,
        Hao Fang <fanghao11@huawei.com>
From: Zhou Wang <wangzhou1@hisilicon.com>
Message-ID: <5C383908.4090107@hisilicon.com>
Date: Fri, 11 Jan 2019 14:34:48 +0800
MIME-Version: 1.0
In-Reply-To: <20190111060859.k647ltxukywjmi3l@gondor.apana.org.au>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 2019/1/11 14:08, Herbert Xu wrote:
> On Sat, Dec 22, 2018 at 03:51:44PM +0800, Zhou Wang wrote:
>>
>> +static struct crypto_alg hisi_zip_zlib = {
>> +	.cra_name		= "zlib-deflate",
>> +	.cra_flags		= CRYPTO_ALG_TYPE_COMPRESS,
>> +	.cra_ctxsize		= sizeof(struct hisi_zip_ctx),
>> +	.cra_priority           = 300,
>> +	.cra_module		= THIS_MODULE,
>> +	.cra_init		= hisi_zip_alloc_comp_ctx,
>> +	.cra_exit		= hisi_zip_free_comp_ctx,
>> +	.cra_u			= {
>> +		.compress = {
>> +			.coa_compress	= hisi_zip_compress,
>> +			.coa_decompress	= hisi_zip_decompress
>> +		}
>> +	}
>> +};
> 
> Please do not add any new implementations using the compress
> interface.  You should either use scomp or acomp depending on
> whether your driver is synchronous or async.

OK, current this driver only supports synchronous interface.
Will fix it in v2.

Thanks,
Zhou

> 
> Thanks,
> 
