Return-Path: <SRS0=9Gyh=PA=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:38952 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731793AbeLWEBa (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 22 Dec 2018 23:01:30 -0500
Date: Sun, 23 Dec 2018 12:01:27 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Nathan Chancellor <natechancellor@gmail.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Nick Desaulniers <ndesaulniers@google.com>
Subject: Re: [PATCH] crypto: ux500 - Use proper enum in hash_set_dma_transfer
Message-ID: <20181223040127.hk2dy4nnfz4uinwn@gondor.apana.org.au>
References: <20181210234954.5862-1-natechancellor@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181210234954.5862-1-natechancellor@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Dec 10, 2018 at 04:49:54PM -0700, Nathan Chancellor wrote:
> Clang warns when one enumerated type is implicitly converted to another:
> 
> drivers/crypto/ux500/hash/hash_core.c:169:4: warning: implicit
> conversion from enumeration type 'enum dma_data_direction' to different
> enumeration type 'enum dma_transfer_direction' [-Wenum-conversion]
>                         direction, DMA_CTRL_ACK | DMA_PREP_INTERRUPT);
>                         ^~~~~~~~~
> 1 warning generated.
> 
> dmaengine_prep_slave_sg expects an enum from dma_transfer_direction.
> We know that the only direction supported by this function is
> DMA_TO_DEVICE because of the check at the top of this function so we can
> just use the equivalent value from dma_transfer_direction.
> 
> DMA_TO_DEVICE = DMA_MEM_TO_DEV = 1
> 
> Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
> ---
>  drivers/crypto/ux500/hash/hash_core.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
