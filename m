From: Corentin Labbe <clabbe.montjoie@gmail.com>
Subject: Re: [PATCH 10/11] crypto: sun4i-ss: fix large block size support
Date: Fri, 26 May 2017 16:55:01 +0200
Message-ID: <20170526145501.GA19284@Red>
References: <20170524190652.13278-1-antoine.tenart@free-electrons.com>
 <20170524190652.13278-11-antoine.tenart@free-electrons.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: herbert@gondor.apana.org.au, davem@davemloft.net,
        maxime.ripard@free-electrons.com, wens@csie.org,
        linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org
To: Antoine Tenart <antoine.tenart@free-electrons.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:34643 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1034656AbdEZOzI (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 26 May 2017 10:55:08 -0400
Received: by mail-wm0-f68.google.com with SMTP id d127so4414972wmf.1
        for <linux-crypto@vger.kernel.org>; Fri, 26 May 2017 07:55:08 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20170524190652.13278-11-antoine.tenart@free-electrons.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, May 24, 2017 at 09:06:51PM +0200, Antoine Tenart wrote:
> The run-time self-tests fail quite early, as soon as the input block
> size is larger than 64 bytes:
> 
>   alg: hash: Test 4 failed for sha1-sun4i-ss
>   00000000: b9 c9 1e 52 c0 26 d8 39 81 ff f2 3c 99 b1 27 b2
>   00000010: 30 d6 c9 85
> 
> One thing to notice is the value of the last word, which is the one
> expected (it can sometime be the last two words). The datasheet isn't
> very clear about when the digest is ready to retrieve and is seems the
> bit SS_DATA_END is cleared when the digest was computed *but* that
> doesn't mean the digest is ready to retrieve in the registers.
> 
> A ndelay(1) is added before reading the computed digest to ensure it is
> available in the SS_MD[] registers.
> 
> Signed-off-by: Antoine Tenart <antoine.tenart@free-electrons.com>
> ---
>  drivers/crypto/sunxi-ss/sun4i-ss-hash.c | 18 ++++++++++++++++++
>  1 file changed, 18 insertions(+)
> 
> diff --git a/drivers/crypto/sunxi-ss/sun4i-ss-hash.c b/drivers/crypto/sunxi-ss/sun4i-ss-hash.c
> index 685de5b6ab17..6da8d2bbd4da 100644
> --- a/drivers/crypto/sunxi-ss/sun4i-ss-hash.c
> +++ b/drivers/crypto/sunxi-ss/sun4i-ss-hash.c
> @@ -358,6 +358,15 @@ static int sun4i_hash(struct ahash_request *areq)
>  		goto release_ss;
>  	}
>  
> +	/*
> +	 * The datasheet isn't very clear about when to retrieve the digest. The
> +	 * bit SS_DATA_END is cleared when the engine has processed the data and
> +	 * when the digest is computed *but* it doesn't mean the digest is
> +	 * available in the diesgt registers. Hence the delay to be sure we can

Hello

Small typo here (diesgt/digest)

> +	 * read it.
> +	 */
> +	ndelay(1);
> +
>  	for (i = 0; i < crypto_ahash_digestsize(tfm) / 4; i++)
>  		op->hash[i] = readl(ss->base + SS_MD0 + i * 4);
>  
> @@ -446,6 +455,15 @@ static int sun4i_hash(struct ahash_request *areq)
>  		goto release_ss;
>  	}
>  
> +	/*
> +	 * The datasheet isn't very clear about when to retrieve the digest. The
> +	 * bit SS_DATA_END is cleared when the engine has processed the data and
> +	 * when the digest is computed *but* it doesn't mean the digest is
> +	 * available in the diesgt registers. Hence the delay to be sure we can

and here.

This behaviour is very strange since I didnt get it on other platform.
Could you give me the board name where you get it ?
Does any wmb() after the writel(..SS_DATA_END..) do the trick ?
Which speed are the SS clocks ?

Anyway the whole serie seems good, I will test it just after this weekend.

Thanks
Regards
Corentin Labbe
