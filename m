Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF082C433DB
	for <linux-crypto@archiver.kernel.org>; Thu,  7 Jan 2021 19:03:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 82CB02343F
	for <linux-crypto@archiver.kernel.org>; Thu,  7 Jan 2021 19:03:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727749AbhAGTDM (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 7 Jan 2021 14:03:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:41084 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726326AbhAGTDM (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 7 Jan 2021 14:03:12 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5BF5323436;
        Thu,  7 Jan 2021 19:02:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610046151;
        bh=yL4pVJzbOSHjbSkVXG/J/r2yID2PkcWdc66PL+Y5qyo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=NBIeXN1IopYzDiG8IUJr9Gle6OuGSWKOoKzVWW75+6/b+cNAJxgmQoU+M2E/exHWE
         kmhlhWAK4bAUc68PcyyCv1aF4305i5R8gbWuC8/FfollVY8SMqCxchsH6O4dzMjVUu
         uGp/bQ933dpiL+ZLLFsKSH3s023ySLPjJ2y4jeQ3jrB6PudpvA+Pjm1yhojfgiswiJ
         ElJyUuwqgJFc5xjoYE6USK9b2q+YiPPa15v3lF8gwV3R+9PIZN+rrEkvhx+vOT67IX
         N35LbDZKvOTqv1jvHMlvX+QaC+mGOZS8ckfaA/v38HBFVdFRledEuE+ho2IArJD63m
         M7Qs1uAg9ZiDg==
Date:   Thu, 7 Jan 2021 11:02:29 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        herbert@gondor.apana.org.au, arnd@arndb.de
Subject: Re: [PATCH] crypto - shash: reduce minimum alignment of shash_desc
 structure
Message-ID: <X/daxUIwf8iXkbxr@gmail.com>
References: <20210107124128.19791-1-ardb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210107124128.19791-1-ardb@kernel.org>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Jan 07, 2021 at 01:41:28PM +0100, Ard Biesheuvel wrote:
> Unlike many other structure types defined in the crypto API, the
> 'shash_desc' structure is permitted to live on the stack, which
> implies its contents may not be accessed by DMA masters. (This is
> due to the fact that the stack may be located in the vmalloc area,
> which requires a different virtual-to-physical translation than the
> one implemented by the DMA subsystem)
> 
> Our definition of CRYPTO_MINALIGN_ATTR is based on ARCH_KMALLOC_MINALIGN,
> which may take DMA constraints into account on architectures that support
> non-cache coherent DMA such as ARM and arm64. In this case, the value is
> chosen to reflect the largest cacheline size in the system, in order to
> ensure that explicit cache maintenance as required by non-coherent DMA
> masters does not affect adjacent, unrelated slab allocations. On arm64,
> this value is currently set at 128 bytes.
> 
> This means that applying CRYPTO_MINALIGN_ATTR to struct shash_desc is both
> unnecessary (as it is never used for DMA), and undesirable, given that it
> wastes stack space (on arm64, performing the alignment costs 112 bytes in
> the worst case, and the hole between the 'tfm' and '__ctx' members takes
> up another 120 bytes, resulting in an increased stack footprint of up to
> 232 bytes.) So instead, let's switch to the minimum SLAB alignment, which
> does not take DMA constraints into account.
> 
> Note that this is a no-op for x86.
> 
> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> ---
>  include/crypto/hash.h | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/include/crypto/hash.h b/include/crypto/hash.h
> index af2ff31ff619..13f8a6a54ca8 100644
> --- a/include/crypto/hash.h
> +++ b/include/crypto/hash.h
> @@ -149,7 +149,7 @@ struct ahash_alg {
>  
>  struct shash_desc {
>  	struct crypto_shash *tfm;
> -	void *__ctx[] CRYPTO_MINALIGN_ATTR;
> +	void *__ctx[] __aligned(ARCH_SLAB_MINALIGN);
>  };
>  
>  #define HASH_MAX_DIGESTSIZE	 64
> @@ -162,9 +162,9 @@ struct shash_desc {
>  
>  #define HASH_MAX_STATESIZE	512
>  
> -#define SHASH_DESC_ON_STACK(shash, ctx)				  \
> -	char __##shash##_desc[sizeof(struct shash_desc) +	  \
> -		HASH_MAX_DESCSIZE] CRYPTO_MINALIGN_ATTR; \
> +#define SHASH_DESC_ON_STACK(shash, ctx)					     \
> +	char __##shash##_desc[sizeof(struct shash_desc) + HASH_MAX_DESCSIZE] \
> +		__aligned(__alignof__(struct shash_desc));		     \
>  	struct shash_desc *shash = (struct shash_desc *)__##shash##_desc

Looks good to me, but it would be helpful if the comment above the definition of
CRYPTO_MINALIGN in include/linux/crypto.h was updated.

- Eric
