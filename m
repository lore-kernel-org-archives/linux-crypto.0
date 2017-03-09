From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2 1/2] crypto: arm/aes-neonbs - resolve fallback cipher
 at runtime
Date: Thu, 9 Mar 2017 18:46:26 +0800
Message-ID: <20170309104626.GB7185@gondor.apana.org.au>
References: <1487109062-3419-1-git-send-email-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:55541 "EHLO
        helcar.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S932920AbdCISSh (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 9 Mar 2017 13:18:37 -0500
Content-Disposition: inline
In-Reply-To: <1487109062-3419-1-git-send-email-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Feb 14, 2017 at 09:51:01PM +0000, Ard Biesheuvel wrote:
> Currently, the bit sliced NEON AES code for ARM has a link time
> dependency on the scalar ARM asm implementation, which it uses as a
> fallback to perform CBC encryption and the encryption of the initial
> XTS tweak.
> 
> The bit sliced NEON code is both fast and time invariant, which makes
> it a reasonable default on hardware that supports it. However, the
> ARM asm code it pulls in is not time invariant, and due to the way it
> is linked in, cannot be overridden by the new generic time invariant
> driver. In fact, it will not be used at all, given that the ARM asm
> code registers itself as a cipher with a priority that exceeds the
> priority of the fixed time cipher.
> 
> So remove the link time dependency, and allocate the fallback cipher
> via the crypto API. Note that this requires this driver's module_init
> call to be replaced with late_initcall, so that the (possibly generic)
> fallback cipher is guaranteed to be available when the builtin test
> is performed at registration time.
> 
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
