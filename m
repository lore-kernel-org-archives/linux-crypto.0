From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 1/2] crypto: ccm - honour alignmask of subordinate MAC
 cipher
Date: Wed, 15 Feb 2017 13:34:16 +0800
Message-ID: <20170215053416.GE14043@gondor.apana.org.au>
References: <1486841122-1686-1-git-send-email-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:59181 "EHLO
        helcar.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750722AbdBOFeZ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 15 Feb 2017 00:34:25 -0500
Content-Disposition: inline
In-Reply-To: <1486841122-1686-1-git-send-email-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sat, Feb 11, 2017 at 07:25:21PM +0000, Ard Biesheuvel wrote:
> The CCM driver was recently updated to defer the MAC part of the algorithm
> to a dedicated crypto transform, and a template for instantiating such
> transforms was added at the same time.
> 
> However, this new cbcmac template fails to take the alignmask of the
> encapsulated cipher into account, which may result in buffer addresses
> being passed down that are not sufficiently aligned.
> 
> So update the code to ensure that the digest buffer in the desc ctx
> appears at a sufficiently aligned offset, and tweak the code so that all
> calls to crypto_cipher_encrypt_one() operate on this buffer exclusively.
> 
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
