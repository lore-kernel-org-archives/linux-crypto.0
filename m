Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43A21C25B0E
	for <linux-crypto@archiver.kernel.org>; Tue, 16 Aug 2022 18:48:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236044AbiHPSsS (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 16 Aug 2022 14:48:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232654AbiHPSsR (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 16 Aug 2022 14:48:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41DD66338
        for <linux-crypto@vger.kernel.org>; Tue, 16 Aug 2022 11:48:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EE9FCB81AA9
        for <linux-crypto@vger.kernel.org>; Tue, 16 Aug 2022 18:48:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61B40C433D6;
        Tue, 16 Aug 2022 18:48:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660675693;
        bh=f5wBYm2DYlyFdHcAIFTSXbusboTGLq7mBcEZ+py7tfE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=KRXoEXfFxf+Ywy0eVjPbrEw7VHwe8qGkNS8bLgBmaEvjRclvW2Kxyg6kgXDaDJJH2
         H5bcKp3qXFhRneq74Gby3/RUXUA6MpcTm0gmLEnkDDjmPYI+TdpuAW+vrNmbobI4Tm
         j2LahDbx7vcxroa6iDQEo5p47OxHKDkXOLj5WsZiZqacvlG2zm5SsvaovdLWIJ+kfa
         YoVk5oi7gWN5+c9+DaASJAFfWJhXUUHuqEORsrT8MZuaje9/MFTwv2ZWVOEr1BfIqW
         GHIA1egA2Cs+KP6nuBF+6e/zMJVwvEj8kOsvb8YZR2hxPEV70DDu9rrf+wKOnNgSmQ
         o9IGRfhtGCy9w==
Date:   Tue, 16 Aug 2022 11:48:11 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     cgel.zte@gmail.com
Cc:     davem@davemloft.net, herbert@gondor.apana.org.au,
        linux-crypto@vger.kernel.org, ye xingchen <ye.xingchen@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
Subject: Re: [PATCH linux-next] crypto: api - Avoid NULL pointer dereference
 in crypto_larval_destroy()
Message-ID: <Yvvmaw70Ot0bNDdM@sol.localdomain>
References: <20220816113722.82894-1-ye.xingchen@zte.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220816113722.82894-1-ye.xingchen@zte.com.cn>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Aug 16, 2022 at 11:37:22AM +0000, cgel.zte@gmail.com wrote:
> From: ye xingchen <ye.xingchen@zte.com.cn>
> 
> When we have no primary larval or when it's a software node, we may end up
>  in the situation when larval is a NULL pointer. There is no point to look
> for secondary larval in such case. Add a necessary check to a condition.
> 
> Reported-by: Zeal Robot <zealci@zte.com.cn>
> Signed-off-by: ye xingchen <ye.xingchen@zte.com.cn>
> ---
>  crypto/api.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/crypto/api.c b/crypto/api.c
> index 69508ae9345e..f2399aac831d 100644
> --- a/crypto/api.c
> +++ b/crypto/api.c
> @@ -96,7 +96,7 @@ static void crypto_larval_destroy(struct crypto_alg *alg)
>  	struct crypto_larval *larval = (void *)alg;
>  
>  	BUG_ON(!crypto_is_larval(alg));
> -	if (!IS_ERR_OR_NULL(larval->adult))
> +	if (larval && !IS_ERR_OR_NULL(larval->adult))
>  		crypto_mod_put(larval->adult);
>  	kfree(larval);
>  }
> -- 

How does this new NULL check do anything when the pointer is unconditionally
dereferenced in the previous line?

- Eric
