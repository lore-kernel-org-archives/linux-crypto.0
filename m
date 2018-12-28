Return-Path: <SRS0=sHEo=PF=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from szxga07-in.huawei.com ([45.249.212.35]:41700 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729055AbeL1GnW (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 28 Dec 2018 01:43:22 -0500
Subject: Re: [PATCH -next] crypto: chelsio - CHECK-remove set but not used
 variables 'adap'
To: Harsh Jain <harsh@chelsio.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
References: <1545979302-111921-1-git-send-email-yuehaibing@huawei.com>
CC: <linux-crypto@vger.kernel.org>, <kernel-janitors@vger.kernel.org>
From: YueHaibing <yuehaibing@huawei.com>
Message-ID: <cd4d42db-3c03-1345-7bf5-5b5ece495324@huawei.com>
Date: Fri, 28 Dec 2018 14:43:00 +0800
MIME-Version: 1.0
In-Reply-To: <1545979302-111921-1-git-send-email-yuehaibing@huawei.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Sorry, Pls ignore this, the title need respin.

On 2018/12/28 14:41, YueHaibing wrote:
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
>  drivers/crypto/chelsio/chcr_algo.c | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/drivers/crypto/chelsio/chcr_algo.c b/drivers/crypto/chelsio/chcr_algo.c
> index bcef765..c8cd2d3 100644
> --- a/drivers/crypto/chelsio/chcr_algo.c
> +++ b/drivers/crypto/chelsio/chcr_algo.c
> @@ -1368,7 +1368,6 @@ static int chcr_aes_decrypt(struct ablkcipher_request *req)
>  static int chcr_device_init(struct chcr_context *ctx)
>  {
>  	struct uld_ctx *u_ctx = NULL;
> -	struct adapter *adap;
>  	unsigned int id;
>  	int txq_perchan, txq_idx, ntxq;
>  	int err = 0, rxq_perchan, rxq_idx;
> @@ -1382,7 +1381,6 @@ static int chcr_device_init(struct chcr_context *ctx)
>  			goto out;
>  		}
>  		ctx->dev = &u_ctx->dev;
> -		adap = padap(ctx->dev);
>  		ntxq = u_ctx->lldi.ntxq;
>  		rxq_perchan = u_ctx->lldi.nrxq / u_ctx->lldi.nchan;
>  		txq_perchan = ntxq / u_ctx->lldi.nchan;
> 
> 
> 
> 
> .
> 
