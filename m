Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B23F4ECAAD8
	for <linux-crypto@archiver.kernel.org>; Fri, 16 Sep 2022 11:00:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232145AbiIPLAu (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 16 Sep 2022 07:00:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232388AbiIPK7b (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 16 Sep 2022 06:59:31 -0400
Received: from smtp1.axis.com (smtp1.axis.com [195.60.68.17])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F6D51A801
        for <linux-crypto@vger.kernel.org>; Fri, 16 Sep 2022 03:51:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=axis.com; q=dns/txt; s=axis-central1; t=1663325469;
  x=1694861469;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=V9RAE3E1dJwLbZVFySZDG37T7Lwec2QEaN0NfLgtMb4=;
  b=ldHJM9HibwXuVdEZb1osvB2O2edoeeCcTna17lvxckxd54SjSXIxEFw5
   XrmuYRB0APedlYvYs7amhZj+/LIYB2YpWxNXbuERmK9dpHBnBtI2IP2Cs
   TYj9zny6x4a0XFPLLsNGQee8VTD02/vhRVQbOZLbXPg9ohs9fFGelDL0F
   ifKbZiNYRuyFo0xRRFjy4kcQC0/GRoZr6DAsiy4zTIAKOZX3lTxrJ4zTf
   uxpf62dDlmFozEX+KOsIKyUs/1b8qvbp9xIY7VJnS0aVHZBeIniT7XOR1
   6Z0V6ncvnL7zp08OODOuxYuh64pj+59l1MuB7hd0N0mIDYATRoPh8mYxr
   g==;
Date:   Fri, 16 Sep 2022 12:51:06 +0200
From:   Jesper Nilsson <Jesper.Nilsson@axis.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>
CC:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Jesper Nilsson <Jesper.Nilsson@axis.com>,
        Lars Persson <Lars.Persson@axis.com>,
        linux-arm-kernel <linux-arm-kernel@axis.com>
Subject: Re: [PATCH] crypto: artpec6 - Fix printk warning on size_t/%d
Message-ID: <20220916105106.GO22198@axis.com>
References: <YyRRhv8mHcS4SFQY@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <YyRRhv8mHcS4SFQY@gondor.apana.org.au>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Sep 16, 2022 at 12:35:50PM +0200, Herbert Xu wrote:
> Switch to %zu instead of %d for printing size_t.
> 
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

Acked-by: Jesper Nilsson <jesper.nilsson@axis.com>

> diff --git a/drivers/crypto/axis/artpec6_crypto.c b/drivers/crypto/axis/artpec6_crypto.c
> index b4820594ab80..51c66afbe677 100644
> --- a/drivers/crypto/axis/artpec6_crypto.c
> +++ b/drivers/crypto/axis/artpec6_crypto.c
> @@ -1712,7 +1712,7 @@ static int artpec6_crypto_prepare_crypto(struct skcipher_request *areq)
>  		cipher_len = regk_crypto_key_256;
>  		break;
>  	default:
> -		pr_err("%s: Invalid key length %d!\n",
> +		pr_err("%s: Invalid key length %zu!\n",
>  			MODULE_NAME, ctx->key_length);
>  		return -EINVAL;
>  	}
> -- 
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

/^JN - Jesper Nilsson
-- 
               Jesper Nilsson -- jesper.nilsson@axis.com
