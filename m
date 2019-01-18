Return-Path: <SRS0=FsAa=P2=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:48158 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727077AbfARE4B (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 17 Jan 2019 23:56:01 -0500
Date: Fri, 18 Jan 2019 12:55:46 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Zhou Wang <wangzhou1@hisilicon.com>
Cc: linux-kernel@vger.kernel.org, linuxarm@huawei.com,
        linux-crypto@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH 3/4] crypto: hisilicon: Add HiSilicon ZIP accelerator
 support
Message-ID: <20190118045546.hs37a2isfnvxgm7j@gondor.apana.org.au>
References: <1545465105-133138-1-git-send-email-wangzhou1@hisilicon.com>
 <1545465105-133138-4-git-send-email-wangzhou1@hisilicon.com>
 <20190111060859.k647ltxukywjmi3l@gondor.apana.org.au>
 <5C383908.4090107@hisilicon.com>
 <5C3F3BDF.6070409@hisilicon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5C3F3BDF.6070409@hisilicon.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Jan 16, 2019 at 10:12:47PM +0800, Zhou Wang wrote:
>
> A stupid question: how do we test scomp alg?
> 
> It seems we can not use general comp API, e.g. crypto_alloc_comp
> to do this.
> 
> Could you give me any clue about this?

scomp algorithms are allocated through crypto_alloc_acomp.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
