From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: arm64/aes: reimplement bit-sliced ARM/NEON
 implementation for arm64
Date: Tue, 27 Dec 2016 17:03:55 +0800
Message-ID: <20161227090355.GD10121@gondor.apana.org.au>
References: <1481564758-7275-1-git-send-email-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        nico@linaro.org, will.deacon@arm.com
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:33311 "EHLO
        helcar.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751019AbcL0JEc (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 27 Dec 2016 04:04:32 -0500
Content-Disposition: inline
In-Reply-To: <1481564758-7275-1-git-send-email-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Dec 12, 2016 at 05:45:58PM +0000, Ard Biesheuvel wrote:
>
> +	.chunksize		= 8 * AES_BLOCK_SIZE,

Same comment as to the previous patches regarding chunksize.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
