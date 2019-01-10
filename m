Return-Path: <SRS0=+HSe=PS=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:38660 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728572AbfAJTLN (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 10 Jan 2019 14:11:13 -0500
Date: Thu, 10 Jan 2019 20:11:10 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Eric Biggers <ebiggers@kernel.org>
Cc: stable@vger.kernel.org, linux-crypto@vger.kernel.org,
        Martin Willi <martin@strongswan.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH 4.9,4.4] crypto: x86/chacha20 - avoid sleeping with
 preemption disabled
Message-ID: <20190110191110.GB18221@kroah.com>
References: <20190107231559.13357-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190107231559.13357-1-ebiggers@kernel.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Jan 07, 2019 at 03:15:59PM -0800, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> Hi Greg, please consider applying this to 4.9-stable and 4.4-stable.
> It's a minimal fix for a bug that was fixed incidentally by a large
> refactoring in v4.11.
> 
> >8------------------------------------------------------8<
> 
> In chacha20-simd, clear the MAY_SLEEP flag in the blkcipher_desc to
> prevent sleeping with preemption disabled, under kernel_fpu_begin().
> 
> This was fixed upstream incidentally by a large refactoring,
> commit 9ae433bc79f9 ("crypto: chacha20 - convert generic and x86
> versions to skcipher").  But syzkaller easily trips over this when
> running on older kernels, as it's easily reachable via AF_ALG.
> Therefore, this patch makes the minimal fix for older kernels.
> 
> Fixes: c9320b6dcb89 ("crypto: chacha20 - Add a SSSE3 SIMD variant for x86_64")
> Cc: linux-crypto@vger.kernel.org
> Cc: Martin Willi <martin@strongswan.org>
> Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
>  arch/x86/crypto/chacha20_glue.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/arch/x86/crypto/chacha20_glue.c b/arch/x86/crypto/chacha20_glue.c
> index f910d1d449f00..0a5fedf43bdc8 100644
> --- a/arch/x86/crypto/chacha20_glue.c
> +++ b/arch/x86/crypto/chacha20_glue.c
> @@ -77,6 +77,7 @@ static int chacha20_simd(struct blkcipher_desc *desc, struct scatterlist *dst,
>  
>  	blkcipher_walk_init(&walk, dst, src, nbytes);
>  	err = blkcipher_walk_virt_block(desc, &walk, CHACHA20_BLOCK_SIZE);
> +	desc->flags &= ~CRYPTO_TFM_REQ_MAY_SLEEP;
>  
>  	crypto_chacha20_init(state, crypto_blkcipher_ctx(desc->tfm), walk.iv);
>  
> -- 
> 2.20.1.97.g81188d93c3-goog
> 

Now queued up, thanks.

greg k-h
