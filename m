From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2] crypto: AF_ALG - fix AEAD AIO handling of zero buffer
Date: Thu, 1 Dec 2016 21:22:07 +0800
Message-ID: <20161201132207.GF2249@gondor.apana.org.au>
References: <3547426.Fep2bfj8cH@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:44313 "EHLO
        helcar.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1757311AbcLANWm (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 1 Dec 2016 08:22:42 -0500
Content-Disposition: inline
In-Reply-To: <3547426.Fep2bfj8cH@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Dec 01, 2016 at 08:22:37AM +0100, Stephan Mueller wrote:
> Hi Herbert,
> 
> I split out the bug fix patch from the AD/tag formatting patch as they most likely will come after the next merge window.
> 
> ---8<---
> 
> Handle the case when the caller provided a zero buffer to
> sendmsg/sendpage. Such scenario is legal for AEAD ciphers when no
> plaintext / ciphertext and no AAD is provided and the caller only
> requests the generation of the tag value.
> 
> Signed-off-by: Stephan Mueller <smueller@chronox.de>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
