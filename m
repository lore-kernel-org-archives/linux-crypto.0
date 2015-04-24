From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: x86/sha512_ssse3 - fixup for asm function
 prototype change
Date: Fri, 24 Apr 2015 20:20:13 +0800
Message-ID: <20150424122012.GA31439@gondor.apana.org.au>
References: <CAArOQ2U-dSkbNba_dDiO6cgCXDZEQJ8iChBLxxPO=Hi_mn-2Ag@mail.gmail.com>
 <1429857429-13323-1-git-send-email-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, torvalds@linux-foundation.org,
	smueller@chronox.de, davem@davemloft.net,
	linux-kernel@vger.kernel.org, bobbypowers@gmail.com
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1429857429-13323-1-git-send-email-ard.biesheuvel@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Fri, Apr 24, 2015 at 08:37:09AM +0200, Ard Biesheuvel wrote:
> Patch e68410ebf626 ("crypto: x86/sha512_ssse3 - move SHA-384/512
> SSSE3 implementation to base layer") changed the prototypes of the
> core asm SHA-512 implementations so that they are compatible with
> the prototype used by the base layer.
> 
> However, in one instance, the register that was used for passing the
> input buffer was reused as a scratch register later on in the code,
> and since the input buffer param changed places with the digest param
> -which needs to be written back before the function returns- this
> resulted in the scratch register to be dereferenced in a memory write
> operation, causing a GPF.
> 
> Fix this by changing the scratch register to use the same register as
> the input buffer param again.
> 
> Fixes: e68410ebf626 ("crypto: x86/sha512_ssse3 - move SHA-384/512 SSSE3 implementation to base layer")
> Reported-By: Bobby Powers <bobbypowers@gmail.com>
> Tested-By: Bobby Powers <bobbypowers@gmail.com>
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>

Patch applied.  Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
