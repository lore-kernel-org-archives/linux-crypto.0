Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7398CC636D7
	for <linux-crypto@archiver.kernel.org>; Thu, 23 Feb 2023 06:01:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233276AbjBWGBD (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 23 Feb 2023 01:01:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233133AbjBWGBC (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 23 Feb 2023 01:01:02 -0500
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 339F328228;
        Wed, 22 Feb 2023 22:00:59 -0800 (PST)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1pV4el-00EjAW-4v; Thu, 23 Feb 2023 14:00:40 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 23 Feb 2023 14:00:39 +0800
Date:   Thu, 23 Feb 2023 14:00:39 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Li kunyu <kunyu@nfschina.com>,
        Linus Walleij <linus.walleij@linaro.org>
Cc:     davem@davemloft.net, mcoquelin.stm32@gmail.com,
        linux-crypto@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] stm32: stm32-hash: Add kmalloc_array allocation check
Message-ID: <Y/cBB+q0Ono9j2Jy@gondor.apana.org.au>
References: <20230224215019.3687-1-kunyu@nfschina.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230224215019.3687-1-kunyu@nfschina.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sat, Feb 25, 2023 at 05:50:19AM +0800, Li kunyu wrote:
> If rctx->hw_context allocation of the context pointer failed. Returning
> -ENOMEM and assigning NULL to the out pointer should improve the
> robustness of the function.
> 
> Signed-off-by: Li kunyu <kunyu@nfschina.com>
> ---
>  drivers/crypto/stm32/stm32-hash.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/drivers/crypto/stm32/stm32-hash.c b/drivers/crypto/stm32/stm32-hash.c
> index d33006d43f76..18e79f62be96 100644
> --- a/drivers/crypto/stm32/stm32-hash.c
> +++ b/drivers/crypto/stm32/stm32-hash.c
> @@ -970,6 +970,10 @@ static int stm32_hash_export(struct ahash_request *req, void *out)
>  	rctx->hw_context = kmalloc_array(3 + HASH_CSR_REGISTER_NUMBER,
>  					 sizeof(u32),
>  					 GFP_KERNEL);
> +	if (rctx->hw_context == NULL) {
> +		out = NULL;
> +		return -ENOMEM;
> +	}
>  
>  	preg = rctx->hw_context;

Shouldn't we free the hw_context at the end of the function?

Why does it even need to be stored in rctx in the first place?

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
