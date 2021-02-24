Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4646BC433DB
	for <linux-crypto@archiver.kernel.org>; Wed, 24 Feb 2021 06:55:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ED49C64EC9
	for <linux-crypto@archiver.kernel.org>; Wed, 24 Feb 2021 06:55:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231881AbhBXGzy (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 24 Feb 2021 01:55:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:52036 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231627AbhBXGzr (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 24 Feb 2021 01:55:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C0B1264D99;
        Wed, 24 Feb 2021 06:54:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614149700;
        bh=7qGuelNU0pGE7JhnH6i9pfp1fcQxCsHNvaRbRe4VfIA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=bOk2SZh+3M7eyWeoqVBSPaLAQPz9QFDlNCq18qHcLM6gr0usU04FcswSKeHrP5P63
         SQu0XuYbsT8YoySOG3QyUlcEhAwY1qnWmLSLz1OIixgAAUavFoAcWsYihSsg65/ixN
         UmZiRrBzJhVyHk9gM9SSBqahoLqDXWs96UB+i7pSI7yIRo7hTGciuU3i+oOjHZ7boN
         +cDCtgJ9ZQ9xPBKjlWxCtKQuodJWTQrW3oaVvbQ78TW9C6m/Dl0UNnsba22RYILBMy
         6NWKNct3lbuafW+Z5Y0McvubraHnBQUd8yEq/N+w3CmJdtTMjWqVN7csFvfWEYXUR5
         lBE/8SlERRy6g==
Date:   Tue, 23 Feb 2021 22:54:58 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Kai Ye <yekai13@huawei.com>
Cc:     herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: testmgr - delete some redundant code
Message-ID: <YDX4Qr9RgVT+wBky@sol.localdomain>
References: <1614051724-31694-1-git-send-email-yekai13@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1614051724-31694-1-git-send-email-yekai13@huawei.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Feb 23, 2021 at 11:42:04AM +0800, Kai Ye wrote:
> Delete sg_data function, because sg_data function definition same as
> sg_virt(), so need to delete it and use sg_virt() replace to sg_data().
> 
> Signed-off-by: Kai Ye <yekai13@huawei.com>
> ---
>  crypto/testmgr.c | 11 +++--------
>  1 file changed, 3 insertions(+), 8 deletions(-)
> 
> diff --git a/crypto/testmgr.c b/crypto/testmgr.c
> index 9335999..e13e73c 100644
> --- a/crypto/testmgr.c
> +++ b/crypto/testmgr.c
> @@ -1168,11 +1168,6 @@ static inline int check_shash_op(const char *op, int err,
>  	return err;
>  }
>  
> -static inline const void *sg_data(struct scatterlist *sg)
> -{
> -	return page_address(sg_page(sg)) + sg->offset;
> -}
> -
>  /* Test one hash test vector in one configuration, using the shash API */
>  static int test_shash_vec_cfg(const struct hash_testvec *vec,
>  			      const char *vec_name,
> @@ -1230,7 +1225,7 @@ static int test_shash_vec_cfg(const struct hash_testvec *vec,
>  			return 0;
>  		if (cfg->nosimd)
>  			crypto_disable_simd_for_test();
> -		err = crypto_shash_digest(desc, sg_data(&tsgl->sgl[0]),
> +		err = crypto_shash_digest(desc, sg_virt(&tsgl->sgl[0]),
>  					  tsgl->sgl[0].length, result);
>  		if (cfg->nosimd)
>  			crypto_reenable_simd_for_test();
> @@ -1266,7 +1261,7 @@ static int test_shash_vec_cfg(const struct hash_testvec *vec,
>  		    cfg->finalization_type == FINALIZATION_TYPE_FINUP) {
>  			if (divs[i]->nosimd)
>  				crypto_disable_simd_for_test();
> -			err = crypto_shash_finup(desc, sg_data(&tsgl->sgl[i]),
> +			err = crypto_shash_finup(desc, sg_virt(&tsgl->sgl[i]),
>  						 tsgl->sgl[i].length, result);
>  			if (divs[i]->nosimd)
>  				crypto_reenable_simd_for_test();
> @@ -1278,7 +1273,7 @@ static int test_shash_vec_cfg(const struct hash_testvec *vec,
>  		}
>  		if (divs[i]->nosimd)
>  			crypto_disable_simd_for_test();
> -		err = crypto_shash_update(desc, sg_data(&tsgl->sgl[i]),
> +		err = crypto_shash_update(desc, sg_virt(&tsgl->sgl[i]),
>  					  tsgl->sgl[i].length);
>  		if (divs[i]->nosimd)
>  			crypto_reenable_simd_for_test();
> -- 

Looks good,

Reviewed-by: Eric Biggers <ebiggers@google.com>

- Eric
