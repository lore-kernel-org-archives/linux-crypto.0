From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 2/3] crypto: AF_ALG - disregard AAD buffer space for
 output
Date: Sat, 12 Nov 2016 09:55:19 +0800
Message-ID: <20161112015519.GA32234@gondor.apana.org.au>
References: <3302668.EORF2jai5r@positron.chronox.de>
 <3506033.FskOdlTquT@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: mathew.j.martineau@linux.intel.com, linux-crypto@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:33221 "EHLO
        helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S936530AbcKLBzr (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 11 Nov 2016 20:55:47 -0500
Content-Disposition: inline
In-Reply-To: <3506033.FskOdlTquT@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Nov 10, 2016 at 04:32:03AM +0100, Stephan Mueller wrote:
> The kernel crypto API AEAD cipher operation generates output such that
> space for the AAD is reserved in the output buffer without being
> touched. The processed ciphertext/plaintext is appended to the reserved
> AAD buffer.
> 
> The user space interface followed that approach. However, this is a
> violation of the POSIX read definition which requires that any read data
> is placed at the beginning of the caller-provided buffer. As the kernel
> crypto API would leave room for the AAD, the old approach did not fully
> comply with the POSIX specification.

Nack.  The kernel AEAD API will copy the AD as is, it definitely
does not leave the output untouched unless of course when it is
an in-place operation.  The user-space operation should operate
in the same manner.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
