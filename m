From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: arm64/aes-blk - honour iv_out requirement in CBC
 and CTR modes
Date: Mon, 23 Jan 2017 22:58:37 +0800
Message-ID: <20170123145837.GC20806@gondor.apana.org.au>
References: <1484660789-7036-1-git-send-email-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:44371 "EHLO
        helcar.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751032AbdAWO6y (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 23 Jan 2017 09:58:54 -0500
Content-Disposition: inline
In-Reply-To: <1484660789-7036-1-git-send-email-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Jan 17, 2017 at 01:46:29PM +0000, Ard Biesheuvel wrote:
> Update the ARMv8 Crypto Extensions and the plain NEON AES implementations
> in CBC and CTR modes to return the next IV back to the skcipher API client.
> This is necessary for chaining to work correctly.
> 
> Note that for CTR, this is only done if the request is a round multiple of
> the block size, since otherwise, chaining is impossible anyway.
> 
> Cc: <stable@vger.kernel.org> # v3.16+
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
