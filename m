From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 2/2] crypto: ccm - drop unnecessary minimum 32-bit
 alignment
Date: Wed, 15 Feb 2017 13:34:31 +0800
Message-ID: <20170215053431.GF14043@gondor.apana.org.au>
References: <1486841122-1686-1-git-send-email-ard.biesheuvel@linaro.org>
 <1486841122-1686-2-git-send-email-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:36471 "EHLO
        helcar.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750722AbdBOFei (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 15 Feb 2017 00:34:38 -0500
Content-Disposition: inline
In-Reply-To: <1486841122-1686-2-git-send-email-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sat, Feb 11, 2017 at 07:25:22PM +0000, Ard Biesheuvel wrote:
> The CCM driver forces 32-bit alignment even if the underlying ciphers
> don't care about alignment. This is because crypto_xor() used to require
> this, but since this is no longer the case, drop the hardcoded minimum
> of 32 bits.
> 
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
