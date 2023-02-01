Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E871C636CC
	for <linux-crypto@archiver.kernel.org>; Wed,  1 Feb 2023 02:53:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230009AbjBACxp (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 31 Jan 2023 21:53:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229962AbjBACxp (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 31 Jan 2023 21:53:45 -0500
Received: from out30-130.freemail.mail.aliyun.com (out30-130.freemail.mail.aliyun.com [115.124.30.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C994910DF
        for <linux-crypto@vger.kernel.org>; Tue, 31 Jan 2023 18:53:42 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R191e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046050;MF=tianjia.zhang@linux.alibaba.com;NM=1;PH=DS;RN=3;SR=0;TI=SMTPD_---0VaZDSP3_1675220019;
Received: from 30.240.102.229(mailfrom:tianjia.zhang@linux.alibaba.com fp:SMTPD_---0VaZDSP3_1675220019)
          by smtp.aliyun-inc.com;
          Wed, 01 Feb 2023 10:53:39 +0800
Message-ID: <b83ca139-1e8c-60f3-939f-15f727710c36@linux.alibaba.com>
Date:   Wed, 1 Feb 2023 10:53:37 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.6.1
Subject: Re: [PATCH] crypto: arm64/aes-ccm - Rewrite skcipher walker loop
Content-Language: en-US
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Ard Biesheuvel <ardb@kernel.org>
References: <Y9eGyzZ+JAqRQvtm@gondor.apana.org.au>
From:   Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
In-Reply-To: <Y9eGyzZ+JAqRQvtm@gondor.apana.org.au>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org



On 1/30/23 4:58 PM, Herbert Xu wrote:
> An often overlooked aspect of the skcipher walker API is that an
> error is not just indicated by a non-zero return value, but by the
> fact that walk->nbytes is zero.
> 
> Thus it is an error to call skcipher_walk_done after getting back
> walk->nbytes == 0 from the previous interaction with the walker.
> 
> This is because when walk->nbytes is zero the walker is left in
> an undefined state and any further calls to it may try to free
> uninitialised stack memory.
> 
> The arm64 ccm code has to deal with zero-length messages, and
> it needs to process data even when walk->nbytes == 0 is returned.
> It doesn't have this bug because there is an explicit check for
> walk->nbytes != 0 prior to the skcipher_walk_done call.
> 
> However, the loop is still sufficiently different from the usual
> layout and it appears to have been copied into other code which
> then ended up with this bug.  This patch rewrites it to follow the
> usual convention of checking walk->nbytes.
> 
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
> 
> diff --git a/arch/arm64/crypto/aes-ce-ccm-glue.c b/arch/arm64/crypto/aes-ce-ccm-glue.c
> index c4f14415f5f0..25cd3808ecbe 100644
> --- a/arch/arm64/crypto/aes-ce-ccm-glue.c
> +++ b/arch/arm64/crypto/aes-ce-ccm-glue.c
> @@ -161,43 +161,39 @@ static int ccm_encrypt(struct aead_request *req)
>   	memcpy(buf, req->iv, AES_BLOCK_SIZE);
>   
>   	err = skcipher_walk_aead_encrypt(&walk, req, false);
> -	if (unlikely(err))
> -		return err;
>   
>   	kernel_neon_begin();
>   
>   	if (req->assoclen)
>   		ccm_calculate_auth_mac(req, mac);
>   
> -	do {
> +	while (walk.nbytes) {
>   		u32 tail = walk.nbytes % AES_BLOCK_SIZE;
> +		bool final = walk.nbytes == walk.total;
>   
> -		if (walk.nbytes == walk.total)
> +		if (final)
>   			tail = 0;
>   
>   		ce_aes_ccm_encrypt(walk.dst.virt.addr, walk.src.virt.addr,
>   				   walk.nbytes - tail, ctx->key_enc,
>   				   num_rounds(ctx), mac, walk.iv);
>   
> -		if (walk.nbytes == walk.total)
> -			ce_aes_ccm_final(mac, buf, ctx->key_enc, num_rounds(ctx));
> +		if (!final)
> +			kernel_neon_end();
> +		err = skcipher_walk_done(&walk, tail);
> +		if (!final)
> +			kernel_neon_begin();
> +	}
>   
> -		kernel_neon_end();
> +	ce_aes_ccm_final(mac, buf, ctx->key_enc, num_rounds(ctx));
>   
> -		if (walk.nbytes) {
> -			err = skcipher_walk_done(&walk, tail);
> -			if (unlikely(err))
> -				return err;
> -			if (unlikely(walk.nbytes))
> -				kernel_neon_begin();
> -		}
> -	} while (walk.nbytes);
> +	kernel_neon_end();
>   
>   	/* copy authtag to end of dst */
>   	scatterwalk_map_and_copy(mac, req->dst, req->assoclen + req->cryptlen,
>   				 crypto_aead_authsize(aead), 1);
>   
> -	return 0;
> +	return err;
>   }

I think the following is a more cleaner rewriting form of the loop,
which handles the last chunk separately, and both gcm and ccm can be
handled similarly.

	while (walk.nbytes != walk.total) {
		u32 tail = walk.nbytes % AES_BLOCK_SIZE;

		ce_aes_ccm_encrypt(walk.dst.virt.addr, walk.src.virt.addr,
				   walk.nbytes - tail, ctx->key_enc,
				   num_rounds(ctx), mac, walk.iv);

		kernel_neon_end();

		err = skcipher_walk_done(&walk, tail);

		kernel_neon_begin();
	}

	if (walk.nbytes) {
		ce_aes_ccm_encrypt(walk.dst.virt.addr, walk.src.virt.addr,
				   walk.nbytes, ctx->key_enc,
				   num_rounds(ctx), mac, walk.iv);

		err = skcipher_walk_done(&walk, 0);
	}

	ce_aes_ccm_final(mac, buf, ctx->key_enc, num_rounds(ctx));

	kernel_neon_end();


I have tested it initially. What are your opinions？

>   
>   static int ccm_decrypt(struct aead_request *req)
> @@ -219,37 +215,36 @@ static int ccm_decrypt(struct aead_request *req)
>   	memcpy(buf, req->iv, AES_BLOCK_SIZE);
>   
>   	err = skcipher_walk_aead_decrypt(&walk, req, false);
> -	if (unlikely(err))
> -		return err;
>   
>   	kernel_neon_begin();
>   
>   	if (req->assoclen)
>   		ccm_calculate_auth_mac(req, mac);
>   
> -	do {
> +	while (walk.nbytes) {
>   		u32 tail = walk.nbytes % AES_BLOCK_SIZE;
> +		bool final = walk.nbytes == walk.total;
>   
> -		if (walk.nbytes == walk.total)
> +		if (final)
>   			tail = 0;
>   
>   		ce_aes_ccm_decrypt(walk.dst.virt.addr, walk.src.virt.addr,
>   				   walk.nbytes - tail, ctx->key_enc,
>   				   num_rounds(ctx), mac, walk.iv);
>   
> -		if (walk.nbytes == walk.total)
> -			ce_aes_ccm_final(mac, buf, ctx->key_enc, num_rounds(ctx));
> +		if (!final)
> +			kernel_neon_end();
> +		err = skcipher_walk_done(&walk, tail);
> +		if (!final)
> +			kernel_neon_begin();
> +	}
>   
> -		kernel_neon_end();
> +	ce_aes_ccm_final(mac, buf, ctx->key_enc, num_rounds(ctx));
>   
> -		if (walk.nbytes) {
> -			err = skcipher_walk_done(&walk, tail);
> -			if (unlikely(err))
> -				return err;
> -			if (unlikely(walk.nbytes))
> -				kernel_neon_begin();
> -		}
> -	} while (walk.nbytes);
> +	kernel_neon_end();
> +
> +	if (unlikely(err))
> +		return err;
>   
>   	/* compare calculated auth tag with the stored one */
>   	scatterwalk_map_and_copy(buf, req->src,
