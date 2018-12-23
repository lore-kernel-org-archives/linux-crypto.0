Return-Path: <SRS0=9Gyh=PA=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:38938 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731793AbeLWEBU (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 22 Dec 2018 23:01:20 -0500
Date: Sun, 23 Dec 2018 12:01:18 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Nathan Chancellor <natechancellor@gmail.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Nick Desaulniers <ndesaulniers@google.com>
Subject: Re: [PATCH] crypto: ux500 - Use proper enum in cryp_set_dma_transfer
Message-ID: <20181223040118.qzk4flxswf5xvckp@gondor.apana.org.au>
References: <20181210234929.5729-1-natechancellor@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181210234929.5729-1-natechancellor@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Dec 10, 2018 at 04:49:29PM -0700, Nathan Chancellor wrote:
> Clang warns when one enumerated type is implicitly converted to another:
> 
> drivers/crypto/ux500/cryp/cryp_core.c:559:5: warning: implicit
> conversion from enumeration type 'enum dma_data_direction' to different
> enumeration type 'enum dma_transfer_direction' [-Wenum-conversion]
>                                 direction, DMA_CTRL_ACK);
>                                 ^~~~~~~~~
> drivers/crypto/ux500/cryp/cryp_core.c:583:5: warning: implicit
> conversion from enumeration type 'enum dma_data_direction' to different
> enumeration type 'enum dma_transfer_direction' [-Wenum-conversion]
>                                 direction,
>                                 ^~~~~~~~~
> 2 warnings generated.
> 
> dmaengine_prep_slave_sg expects an enum from dma_transfer_direction.
> Because we know the value of the dma_data_direction enum from the
> switch statement, we can just use the proper value from
> dma_transfer_direction so there is no more conversion.
> 
> DMA_TO_DEVICE = DMA_MEM_TO_DEV = 1
> DMA_FROM_DEVICE = DMA_DEV_TO_MEM = 2
> 
> Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
> ---
>  drivers/crypto/ux500/cryp/cryp_core.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
