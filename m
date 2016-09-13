From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 1/2] crypto: arm/aes-ctr: fix NULL dereference in tail
 processing
Date: Tue, 13 Sep 2016 20:43:54 +0800
Message-ID: <20160913124354.GI31835@gondor.apana.org.au>
References: <1473756533-21078-1-git-send-email-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        xiakaixu@huawei.com
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:35451 "EHLO
        helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752028AbcIMMoB (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 13 Sep 2016 08:44:01 -0400
Content-Disposition: inline
In-Reply-To: <1473756533-21078-1-git-send-email-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Sep 13, 2016 at 09:48:52AM +0100, Ard Biesheuvel wrote:
> The AES-CTR glue code avoids calling into the blkcipher API for the
> tail portion of the walk, by comparing the remainder of walk.nbytes
> modulo AES_BLOCK_SIZE with the residual nbytes, and jumping straight
> into the tail processing block if they are equal. This tail processing
> block checks whether nbytes != 0, and does nothing otherwise.
> 
> However, in case of an allocation failure in the blkcipher layer, we
> may enter this code with walk.nbytes == 0, while nbytes > 0. In this
> case, we should not dereference the source and destination pointers,
> since they may be NULL. So instead of checking for nbytes != 0, check
> for (walk.nbytes % AES_BLOCK_SIZE) != 0, which implies the former in
> non-error conditions.
> 
> Fixes: 86464859cc77 ("crypto: arm - AES in ECB/CBC/CTR/XTS modes using ARMv8 Crypto Extensions")
> Reported-by: xiakaixu <xiakaixu@huawei.com>
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> ---

Both patches applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
