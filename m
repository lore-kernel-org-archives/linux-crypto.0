Return-Path: <SRS0=PFiu=AH=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38220C433DF
	for <linux-crypto@archiver.kernel.org>; Fri, 26 Jun 2020 16:46:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 177D3207E8
	for <linux-crypto@archiver.kernel.org>; Fri, 26 Jun 2020 16:46:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1593189981;
	bh=/3LoxLF4057wgZmTfhlnbofhYnbOiICrrbf/TSmHFHs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=bATUeVI2tTTJ7/ogTWn8H7YugF+lf79FgoPgHw9YGrYWZr8iNn6+AsOEFf6hxccCN
	 dwmRHRWrQ7+rKlQFzc3UCVq6Yr2chR9rmodSPZotV1n+tv0TMvinitZQGCpareqAsL
	 HI4lcjLKCsROgaMGB4N5EPeHumZjoYMs83lQv6Oo=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727794AbgFZQqU (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 26 Jun 2020 12:46:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:49534 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727779AbgFZQqU (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 26 Jun 2020 12:46:20 -0400
Received: from gmail.com (unknown [104.132.1.76])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 34A0E20781;
        Fri, 26 Jun 2020 16:46:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593189979;
        bh=/3LoxLF4057wgZmTfhlnbofhYnbOiICrrbf/TSmHFHs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=1q+wodL86TPFmNc+x+aUEA7JqPHajKbmrdBGnBv1znqYozu8EwoloHHYVbVBhZAkg
         6gtR3VAbiLsHLeVpqzD1zRYpFefRRqRRS9xyqIeE+8JrAyPAFWBlcaTb9ywdwrlrM0
         IVArLToo1Om2esBZa3xjZdY4CK1aUGz9AQPxudXw=
Date:   Fri, 26 Jun 2020 09:46:17 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Mikulas Patocka <mpatocka@redhat.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        Mike Snitzer <msnitzer@redhat.com>,
        linux-kernel@vger.kernel.org, dm-devel@redhat.com,
        linux-crypto@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Milan Broz <mbroz@redhat.com>,
        Jonathan Cameron <Jonathan.Cameron@Huawei.com>,
        George Cherian <gcherian@marvell.com>,
        Wei Xu <xuwei5@hisilicon.com>, Zaibo Xu <xuzaibo@Huawei.com>
Subject: Re: [PATCH 1/3 v2] crypto: introduce the flag
 CRYPTO_ALG_ALLOCATES_MEMORY
Message-ID: <20200626164617.GA211634@gmail.com>
References: <alpine.LRH.2.02.2006100756270.27811@file01.intranet.prod.int.rdu2.redhat.com>
 <20200610121106.GA23137@gondor.apana.org.au>
 <alpine.LRH.2.02.2006161052540.28052@file01.intranet.prod.int.rdu2.redhat.com>
 <alpine.LRH.2.02.2006161101080.28052@file01.intranet.prod.int.rdu2.redhat.com>
 <20200616173620.GA207319@gmail.com>
 <alpine.LRH.2.02.2006171107220.18714@file01.intranet.prod.int.rdu2.redhat.com>
 <alpine.LRH.2.02.2006171108440.18714@file01.intranet.prod.int.rdu2.redhat.com>
 <20200626044534.GA2870@gondor.apana.org.au>
 <alpine.LRH.2.02.2006261109520.11899@file01.intranet.prod.int.rdu2.redhat.com>
 <alpine.LRH.2.02.2006261215480.13882@file01.intranet.prod.int.rdu2.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.02.2006261215480.13882@file01.intranet.prod.int.rdu2.redhat.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Jun 26, 2020 at 12:16:33PM -0400, Mikulas Patocka wrote:
> +/*
> + * Pass these flags down through the crypto API.
> + */
> +#define CRYPTO_ALG_INHERITED_FLAGS	(CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY)

This comment is useless.  How about:

/*
 * When an algorithm uses another algorithm (e.g., if it's an instance of a
 * template), these are the flags that always get set on the "outer" algorithm
 * if any "inner" algorithm has them set.  In some cases other flags are
 * inherited too; these are just the flags that are *always* inherited.
 */
#define CRYPTO_ALG_INHERITED_FLAGS	(CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY)

Also I wonder about the case where the inner algorithm is a fallback rather than
part of a template instance.  This patch only handles templates, not fallbacks.
Is that intentional?  Isn't that technically a bug?

> +
> +/*
>   * Transform masks and values (for crt_flags).
>   */
>  #define CRYPTO_TFM_NEED_KEY		0x00000001
> Index: linux-2.6/crypto/authenc.c
> ===================================================================
> --- linux-2.6.orig/crypto/authenc.c	2020-06-26 17:24:03.566417000 +0200
> +++ linux-2.6/crypto/authenc.c	2020-06-26 17:24:03.566417000 +0200
> @@ -388,7 +388,8 @@ static int crypto_authenc_create(struct
>  	if ((algt->type ^ CRYPTO_ALG_TYPE_AEAD) & algt->mask)
>  		return -EINVAL;
>  
> -	mask = crypto_requires_sync(algt->type, algt->mask);
> +	mask = crypto_requires_sync(algt->type, algt->mask) |
> +	       crypto_requires_nomem(algt->type, algt->mask);

As I suggested earlier, shouldn't there be a function that returns the mask for
all inherited flags, rather than handling each flag individually?

>  
>  	inst = kzalloc(sizeof(*inst) + sizeof(*ctx), GFP_KERNEL);
>  	if (!inst)
> @@ -424,7 +425,7 @@ static int crypto_authenc_create(struct
>  		goto err_free_inst;
>  
>  	inst->alg.base.cra_flags = (auth_base->cra_flags |
> -				    enc->base.cra_flags) & CRYPTO_ALG_ASYNC;
> +			enc->base.cra_flags) & CRYPTO_ALG_INHERITED_FLAGS;

Strange indentation here.  Likewise in most of the other files.

> Index: linux-2.6/crypto/xts.c
> ===================================================================
> --- linux-2.6.orig/crypto/xts.c	2020-06-26 17:24:03.566417000 +0200
> +++ linux-2.6/crypto/xts.c	2020-06-26 17:24:03.566417000 +0200
> @@ -415,7 +415,7 @@ static int create(struct crypto_template
>  	} else
>  		goto err_free_inst;
>  
> -	inst->alg.base.cra_flags = alg->base.cra_flags & CRYPTO_ALG_ASYNC;
> +	inst->alg.base.cra_flags = alg->base.cra_flags & CRYPTO_ALG_INHERITED_FLAGS;
>  	inst->alg.base.cra_priority = alg->base.cra_priority;
>  	inst->alg.base.cra_blocksize = XTS_BLOCK_SIZE;
>  	inst->alg.base.cra_alignmask = alg->base.cra_alignmask |

Need to set the mask correctly in this file.

> Index: linux-2.6/crypto/adiantum.c
> ===================================================================
> --- linux-2.6.orig/crypto/adiantum.c	2020-06-26 17:24:03.566417000 +0200
> +++ linux-2.6/crypto/adiantum.c	2020-06-26 17:24:03.566417000 +0200
> @@ -507,7 +507,8 @@ static int adiantum_create(struct crypto
>  	if ((algt->type ^ CRYPTO_ALG_TYPE_SKCIPHER) & algt->mask)
>  		return -EINVAL;
>  
> -	mask = crypto_requires_sync(algt->type, algt->mask);
> +	mask = crypto_requires_sync(algt->type, algt->mask) |
> +	       crypto_requires_nomem(algt->type, algt->mask);
>  
>  	inst = kzalloc(sizeof(*inst) + sizeof(*ictx), GFP_KERNEL);
>  	if (!inst)

Need to use CRYPTO_ALG_INHERITED_FLAGS in this file.

- Eric
