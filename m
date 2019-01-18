Return-Path: <SRS0=FsAa=P2=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from szxga07-in.huawei.com ([45.249.212.35]:41632 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727167AbfARHyv (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 18 Jan 2019 02:54:51 -0500
Subject: Re: [PATCH 3/4] crypto: hisilicon: Add HiSilicon ZIP accelerator
 support
To: Herbert Xu <herbert@gondor.apana.org.au>
References: <1545465105-133138-1-git-send-email-wangzhou1@hisilicon.com>
 <1545465105-133138-4-git-send-email-wangzhou1@hisilicon.com>
 <20190111060859.k647ltxukywjmi3l@gondor.apana.org.au>
 <5C383908.4090107@hisilicon.com> <5C3F3BDF.6070409@hisilicon.com>
 <20190118045546.hs37a2isfnvxgm7j@gondor.apana.org.au>
CC: <linux-kernel@vger.kernel.org>, <linuxarm@huawei.com>,
        <linux-crypto@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>
From: Zhou Wang <wangzhou1@hisilicon.com>
Message-ID: <5C418659.30904@hisilicon.com>
Date: Fri, 18 Jan 2019 15:55:05 +0800
MIME-Version: 1.0
In-Reply-To: <20190118045546.hs37a2isfnvxgm7j@gondor.apana.org.au>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 2019/1/18 12:55, Herbert Xu wrote:
> On Wed, Jan 16, 2019 at 10:12:47PM +0800, Zhou Wang wrote:
>>
>> A stupid question: how do we test scomp alg?
>>
>> It seems we can not use general comp API, e.g. crypto_alloc_comp
>> to do this.
>>
>> Could you give me any clue about this?
> 
> scomp algorithms are allocated through crypto_alloc_acomp.

A little strange, but let me try firstly.

However, another question is that seems other subsystems in kernel,
e.g. zswap still use crypto_alloc_comp. So we'd better register this
ZIP engine using both cryto_alloc_comp and scomp/acomp interface to
make it compatible with other subsystems?

Best,
Zhou

> 
> Thanks,
> 
