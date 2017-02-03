From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 1/2] crypto: arm64/aes - don't use IV buffer to return
 final keystream block
Date: Fri, 3 Feb 2017 18:22:35 +0800
Message-ID: <20170203102235.GH2632@gondor.apana.org.au>
References: <1486035536-895-1-git-send-email-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:33275 "EHLO
        helcar.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753088AbdBCKXB (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 3 Feb 2017 05:23:01 -0500
Content-Disposition: inline
In-Reply-To: <1486035536-895-1-git-send-email-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Feb 02, 2017 at 11:38:55AM +0000, Ard Biesheuvel wrote:
> The arm64 bit sliced AES core code uses the IV buffer to pass the final
> keystream block back to the glue code if the input is not a multiple of
> the block size, so that the asm code does not have to deal with anything
> except 16 byte blocks. This is done under the assumption that the outgoing
> IV is meaningless anyway in this case, given that chaining is no longer
> possible under these circumstances.
> 
> However, as it turns out, the CCM driver does expect the IV to retain
> a value that is equal to the original IV except for the counter value,
> and even interprets byte zero as a length indicator, which may result
> in memory corruption if the IV is overwritten with something else.
> 
> So use a separate buffer to return the final keystream block.
> 
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
