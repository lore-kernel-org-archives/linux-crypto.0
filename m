Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 371BCECAAD3
	for <linux-crypto@archiver.kernel.org>; Wed,  7 Sep 2022 06:52:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229777AbiIGGwQ (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 7 Sep 2022 02:52:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229526AbiIGGwP (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 7 Sep 2022 02:52:15 -0400
Received: from fornost.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 094581CFCB
        for <linux-crypto@vger.kernel.org>; Tue,  6 Sep 2022 23:52:11 -0700 (PDT)
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1oVous-001v4u-MR; Wed, 07 Sep 2022 16:52:07 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Wed, 07 Sep 2022 14:52:06 +0800
Date:   Wed, 7 Sep 2022 14:52:06 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Peter Harliman Liem <pliem@maxlinear.com>
Cc:     atenart@kernel.org, linux-crypto@vger.kernel.org,
        linux-lgm-soc@maxlinear.com
Subject: Re: [PATCH v2 1/2] crypto: inside_secure - Avoid dma map if size is
 zero
Message-ID: <Yxg/lipSWadoeD6E@gondor.apana.org.au>
References: <de6de430fd9bbc2d38ff2d5a1ce89983421b9dda.1662432407.git.pliem@maxlinear.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <de6de430fd9bbc2d38ff2d5a1ce89983421b9dda.1662432407.git.pliem@maxlinear.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Sep 06, 2022 at 10:51:49AM +0800, Peter Harliman Liem wrote:
>
> diff --git a/drivers/crypto/inside-secure/safexcel_cipher.c b/drivers/crypto/inside-secure/safexcel_cipher.c
> index d68ef16650d4..3775497775e0 100644
> --- a/drivers/crypto/inside-secure/safexcel_cipher.c
> +++ b/drivers/crypto/inside-secure/safexcel_cipher.c
> @@ -737,14 +737,17 @@ static int safexcel_send_req(struct crypto_async_request *base, int ring,
>  				max(totlen_src, totlen_dst));
>  			return -EINVAL;
>  		}
> -		dma_map_sg(priv->dev, src, sreq->nr_src, DMA_BIDIRECTIONAL);
> +		if (sreq->nr_src > 0)
> +			dma_map_sg(priv->dev, src, sreq->nr_src, DMA_BIDIRECTIONAL);

Where is the corresponding check on unmap?

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
