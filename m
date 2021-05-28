Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71DCDC47087
	for <linux-crypto@archiver.kernel.org>; Fri, 28 May 2021 05:51:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4CD29613D4
	for <linux-crypto@archiver.kernel.org>; Fri, 28 May 2021 05:51:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234038AbhE1Fwj (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 28 May 2021 01:52:39 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:49326 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233029AbhE1Fwj (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 28 May 2021 01:52:39 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtp (Exim 4.92 #5 (Debian))
        id 1lmVOe-0002RI-OO; Fri, 28 May 2021 13:51:00 +0800
Received: from herbert by gondobar with local (Exim 4.92)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1lmVOZ-0003gz-Ad; Fri, 28 May 2021 13:50:55 +0800
Date:   Fri, 28 May 2021 13:50:55 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Wei Yongjun <weiyongjun1@huawei.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Thara Gopinath <thara.gopinath@linaro.org>,
        linux-crypto@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Hulk Robot <hulkci@huawei.com>
Subject: Re: [PATCH -next] crypto: qce - Fix some error handling path
Message-ID: <20210528055055.GA14152@gondor.apana.org.au>
References: <20210519141650.3059054-1-weiyongjun1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210519141650.3059054-1-weiyongjun1@huawei.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, May 19, 2021 at 02:16:50PM +0000, Wei Yongjun wrote:
>
> @@ -448,13 +450,17 @@ qce_aead_async_req_handle(struct crypto_async_request *async_req)
>  	if (ret)
>  		return ret;

Shouldn't this return do the error_free too?

>  	dst_nents = dma_map_sg(qce->dev, rctx->dst_sg, rctx->dst_nents, dir_dst);
> -	if (dst_nents < 0)
> +	if (dst_nents < 0) {
> +		ret = dst_nents;
>  		goto error_free;
> +	}
>  
>  	if (diff_dst) {
>  		src_nents = dma_map_sg(qce->dev, rctx->src_sg, rctx->src_nents, dir_src);
> -		if (src_nents < 0)
> +		if (src_nents < 0) {
> +			ret = src_nents;
>  			goto error_unmap_dst;
> +		}
>  	} else {
>  		if (IS_CCM(rctx->flags) && IS_DECRYPT(rctx->flags))
>  			src_nents = dst_nents;

If so please send a follow-up patch.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
