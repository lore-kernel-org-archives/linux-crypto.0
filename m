From: Lee Nipper <lee.nipper@gmail.com>
Subject: Re: [PATCH] crypto: talitos - add support for sha224
Date: Sat, 01 May 2010 20:28:41 -0500
Message-ID: <4BDCD549.1020709@gmail.com>
References: <20100430222759.c116410a.kim.phillips@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org
To: Kim Phillips <kim.phillips@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-gw0-f46.google.com ([74.125.83.46]:59412 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754114Ab0EBB2x (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 1 May 2010 21:28:53 -0400
Received: by gwj19 with SMTP id 19so676856gwj.19
        for <linux-crypto@vger.kernel.org>; Sat, 01 May 2010 18:28:52 -0700 (PDT)
In-Reply-To: <20100430222759.c116410a.kim.phillips@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Kim Phillips wrote:
> SEC h/w versions 2.1 and above support sha224 via explicit instruction.
> 
> Performing sha224 ahashes on earlier versions is still possible because
> they support sha256 (sha224 is sha256 with different initial constants
> and a different truncation length).  We do this by overriding hardware
> context self-initialization, and perform it manually in s/w instead.
> 
> Signed-off-by: Kim Phillips <kim.phillips@freescale.com>

tested on my 8349E, and discovered it needed
a couple of small changes.  I've noted them below.

> @@ -1722,7 +1725,7 @@ static int ahash_init(struct ahash_request *areq)
>  
>  	/* Initialize the context */
>  	req_ctx->count = 0;
> -	req_ctx->first = 1; /* first indicates h/w must init it's context */
> +	req_ctx->first = 1; /* first indicates h/w must init its context */

need this here:

+	req_ctx->swinit = 0;/* assume h/w init of context */

>  	req_ctx->hw_context_size =
>  		(crypto_ahash_digestsize(tfm) <= SHA256_DIGEST_SIZE)
>  			? TALITOS_MDEU_CONTEXT_SIZE_MD5_SHA1_SHA256
> @@ -1731,6 +1734,29 @@ static int ahash_init(struct ahash_request *areq)
>  	return 0;
>  }
>  
> +/*
> + * on h/w without explicit sha224 support, we initialize h/w context
> + * manually with sha224 constants, and tell it to run sha256.
> + */
> +static int ahash_init_sha224_swinit(struct ahash_request *areq)
> +{
> +	struct talitos_ahash_req_ctx *req_ctx = ahash_request_ctx(areq);
> +
> +	ahash_init(areq);
> +	req_ctx->swinit = 1;/* prevent h/w initting context with sha256 values*/
> +
> +	req_ctx->hw_context[0] = cpu_to_be32(SHA224_H0);
> +	req_ctx->hw_context[1] = cpu_to_be32(SHA224_H1);
> +	req_ctx->hw_context[2] = cpu_to_be32(SHA224_H2);
> +	req_ctx->hw_context[3] = cpu_to_be32(SHA224_H3);
> +	req_ctx->hw_context[4] = cpu_to_be32(SHA224_H4);
> +	req_ctx->hw_context[5] = cpu_to_be32(SHA224_H5);
> +	req_ctx->hw_context[6] = cpu_to_be32(SHA224_H6);
> +	req_ctx->hw_context[7] = cpu_to_be32(SHA224_H7);

need to add this here:

+       req_ctx->hw_context[8] = 0; /* Initialize 64-bit count */
+       req_ctx->hw_context[9] = 0;

> +
> +	return 0;
> +}
> +
>  static int ahash_process_req(struct ahash_request *areq, unsigned int nbytes)
>  {
>  	struct crypto_ahash *tfm = crypto_ahash_reqtfm(areq);

With the extra initialization, it's all good.

Nice way to overcome the 8349E 1.x errata and
add support for all driver compatible devices. I like it.

Signed-off by: Lee Nipper <lee.nipper@gmail.com>

