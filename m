Return-Path: <SRS0=FsAa=P2=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:48242 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725898AbfARKJg (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 18 Jan 2019 05:09:36 -0500
Date: Fri, 18 Jan 2019 18:09:26 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Zhou Wang <wangzhou1@hisilicon.com>
Cc: linux-kernel@vger.kernel.org, linuxarm@huawei.com,
        linux-crypto@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH 3/4] crypto: hisilicon: Add HiSilicon ZIP accelerator
 support
Message-ID: <20190118100926.tr6yti2vlqbnwnd4@gondor.apana.org.au>
References: <1545465105-133138-1-git-send-email-wangzhou1@hisilicon.com>
 <1545465105-133138-4-git-send-email-wangzhou1@hisilicon.com>
 <20190111060859.k647ltxukywjmi3l@gondor.apana.org.au>
 <5C383908.4090107@hisilicon.com>
 <5C3F3BDF.6070409@hisilicon.com>
 <20190118045546.hs37a2isfnvxgm7j@gondor.apana.org.au>
 <5C418659.30904@hisilicon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5C418659.30904@hisilicon.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Jan 18, 2019 at 03:55:05PM +0800, Zhou Wang wrote:
>
> However, another question is that seems other subsystems in kernel,
> e.g. zswap still use crypto_alloc_comp. So we'd better register this
> ZIP engine using both cryto_alloc_comp and scomp/acomp interface to
> make it compatible with other subsystems?

Existing users should switch over to acomp.  We're not adding any
more new algorithms to the legacy compress interface.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
