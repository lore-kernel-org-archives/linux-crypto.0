From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: arm/aesbs - fix brokenness after skcipher
 conversion
Date: Wed, 30 Nov 2016 21:19:22 +0800
Message-ID: <20161130131921.GD4126@gondor.apana.org.au>
References: <1480440216-341-1-git-send-email-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:57772 "EHLO
        helcar.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1756986AbcK3NTb (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 30 Nov 2016 08:19:31 -0500
Content-Disposition: inline
In-Reply-To: <1480440216-341-1-git-send-email-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Nov 29, 2016 at 05:23:36PM +0000, Ard Biesheuvel wrote:
> The CBC encryption routine should use the encryption round keys, not
> the decryption round keys.
> 
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>

Patch applied.  Thanks.
 
> Another fix for the queued changes, this time for 32-bit ARM.
> 
> I must say, I'm not impressed with the level of testing that has been
> carried out after applying these changes. If you had cc'd me on these
> patches, I would have been happy to test/review.

Sorry.  I'll make sure you're CCed for ARM patches in future.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
