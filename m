Return-Path: <SRS0=CSIn=PT=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:33254 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725773AbfAKGcO (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 11 Jan 2019 01:32:14 -0500
Date: Fri, 11 Jan 2019 14:32:06 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: YueHaibing <yuehaibing@huawei.com>
Cc: Harsh Jain <harsh@chelsio.com>, linux-crypto@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH v2 -next] crypto: chelsio - remove set but not used
 variables 'adap'
Message-ID: <20190111063206.fhdvukubaqjjayiv@gondor.apana.org.au>
References: <1545979302-111921-1-git-send-email-yuehaibing@huawei.com>
 <1545980033-196068-1-git-send-email-yuehaibing@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1545980033-196068-1-git-send-email-yuehaibing@huawei.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Dec 28, 2018 at 06:53:53AM +0000, YueHaibing wrote:
> Fixes gcc '-Wunused-but-set-variable' warning:
> 
> drivers/crypto/chelsio/chcr_algo.c: In function 'chcr_device_init':
> drivers/crypto/chelsio/chcr_algo.c:1371:18: warning:
>  variable 'adap' set but not used [-Wunused-but-set-variable]
> 
> It not used since commit a1c6fd4308d3 ("crypto: chelsio - Update ntx queue
> received from cxgb4")
> 
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
> ---
> v2: fix title
> ---
>  drivers/crypto/chelsio/chcr_algo.c | 2 --
>  1 file changed, 2 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
