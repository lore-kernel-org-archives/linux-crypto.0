Return-Path: <SRS0=NifF=5A=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B17C2C10DCE
	for <linux-crypto@archiver.kernel.org>; Sun, 15 Mar 2020 16:11:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 900E0205C9
	for <linux-crypto@archiver.kernel.org>; Sun, 15 Mar 2020 16:11:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728702AbgCOQLD (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 15 Mar 2020 12:11:03 -0400
Received: from stargate.chelsio.com ([12.32.117.8]:53477 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728695AbgCOQLC (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 15 Mar 2020 12:11:02 -0400
Received: from [10.193.177.146] (balakrishna-l.asicdesigners.com [10.193.177.146] (may be forged))
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 02FGAkc9006956;
        Sun, 15 Mar 2020 09:10:47 -0700
Subject: Re: [PATCH -next] crypto: chelsio - remove set but not used variable
 'adap'
To:     YueHaibing <yuehaibing@huawei.com>,
        Ayush Sawal <ayush.sawal@chelsio.com>,
        Vinay Kumar Yadav <vinay.yadav@chelsio.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Cc:     linux-crypto@vger.kernel.org, kernel-janitors@vger.kernel.org
References: <20200314104441.79953-1-yuehaibing@huawei.com>
From:   rohit maheshwari <rohitm@chelsio.com>
Message-ID: <fcf6f896-8d60-836c-cdad-b5ca9c95b562@chelsio.com>
Date:   Sun, 15 Mar 2020 21:40:45 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <20200314104441.79953-1-yuehaibing@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org


On 14/03/20 4:14 PM, YueHaibing wrote:
> drivers/crypto/chelsio/chcr_algo.c: In function 'chcr_device_init':
> drivers/crypto/chelsio/chcr_algo.c:1440:18: warning:
>   variable 'adap' set but not used [-Wunused-but-set-variable]
>   
> commit 567be3a5d227 ("crypto: chelsio - Use multiple txq/rxq per tfm
> to process the requests") involved this unused variable.
>
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
> ---
>   drivers/crypto/chelsio/chcr_algo.c | 2 --
>   1 file changed, 2 deletions(-)
>
> diff --git a/drivers/crypto/chelsio/chcr_algo.c b/drivers/crypto/chelsio/chcr_algo.c
> index 8952732c0b7d..c29b80dd30d8 100644
> --- a/drivers/crypto/chelsio/chcr_algo.c
> +++ b/drivers/crypto/chelsio/chcr_algo.c
> @@ -1437,7 +1437,6 @@ static int chcr_aes_decrypt(struct skcipher_request *req)
>   static int chcr_device_init(struct chcr_context *ctx)
>   {
>   	struct uld_ctx *u_ctx = NULL;
> -	struct adapter *adap;
>   	int txq_perchan, ntxq;
>   	int err = 0, rxq_perchan;
>   
> @@ -1448,7 +1447,6 @@ static int chcr_device_init(struct chcr_context *ctx)
>   			goto out;
>   		}
>   		ctx->dev = &u_ctx->dev;
> -		adap = padap(ctx->dev);
>   		ntxq = u_ctx->lldi.ntxq;
>   		rxq_perchan = u_ctx->lldi.nrxq / u_ctx->lldi.nchan;
>   		txq_perchan = ntxq / u_ctx->lldi.nchan;
>
Thanks for fixing it. Looks good to me.
>
