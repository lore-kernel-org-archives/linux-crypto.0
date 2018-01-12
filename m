From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2 0/3] crypto: salsa20 - cleanup and convert to skcipher
 API
Date: Fri, 12 Jan 2018 23:25:47 +1100
Message-ID: <20180112122547.GI21636@gondor.apana.org.au>
References: <20180105190959.89682-1-ebiggers3@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Eric Biggers <ebiggers@google.com>
To: Eric Biggers <ebiggers3@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from [128.1.224.119] ([128.1.224.119]:54530 "EHLO ringil.hmeau.com"
        rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S933719AbeALMZv (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 12 Jan 2018 07:25:51 -0500
Content-Disposition: inline
In-Reply-To: <20180105190959.89682-1-ebiggers3@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Jan 05, 2018 at 11:09:56AM -0800, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> This series converts the Salsa20 implementations over to the skcipher
> API, in the process fixing a couple bugs and making them be more similar
> to the ChaCha20 implementations, rather than doing things slightly
> differently for no good reason.  (Note, however, that Salsa20 still
> interprets the IV differently from ChaCha20; I didn't change that.)
> 
> I'm not sure who is actually using Salsa20 in the kernel, but either way
> if we're going to have it at all we might as well keep it up to date.
> 
> The Salsa20 algorithms still pass the self-tests after these changes.
> 
> Changed since v1:
> 
>     - Use '__le32' type for keystream, as suggested by Stephan.
> 
> Eric Biggers (3):
>   crypto: salsa20-generic - cleanup and convert to skcipher API
>   crypto: salsa20 - export generic helpers
>   crypto: x86/salsa20 - cleanup and convert to skcipher API
> 
>  arch/x86/crypto/salsa20-i586-asm_32.S   | 184 +-----------------------
>  arch/x86/crypto/salsa20-x86_64-asm_64.S | 114 ---------------
>  arch/x86/crypto/salsa20_glue.c          | 105 ++++++--------
>  crypto/Kconfig                          |   2 +
>  crypto/salsa20_generic.c                | 240 ++++++++++++++------------------
>  include/crypto/salsa20.h                |  27 ++++
>  6 files changed, 174 insertions(+), 498 deletions(-)
>  create mode 100644 include/crypto/salsa20.h

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
