From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 0/5] crypto: chacha20 - Alignment fixes
Date: Wed, 29 Nov 2017 17:39:27 +1100
Message-ID: <20171129063927.GO21575@gondor.apana.org.au>
References: <20171122195139.121269-1-ebiggers3@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Martin Willi <martin@strongswan.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        linux-kernel@vger.kernel.org, Eric Biggers <ebiggers@google.com>
To: Eric Biggers <ebiggers3@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from [128.1.224.119] ([128.1.224.119]:40798 "EHLO ringil.hmeau.com"
        rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1752310AbdK2GkC (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 29 Nov 2017 01:40:02 -0500
Content-Disposition: inline
In-Reply-To: <20171122195139.121269-1-ebiggers3@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Nov 22, 2017 at 11:51:34AM -0800, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> This series fixes potentially unaligned memory accesses when loading the
> initial state, key, and IV for ChaCha20, and when outputting each
> keystream block.
> 
> It also removes the cra_alignmask from the generic and x86 ChaCha20
> implementations, once it is no longer needed.
> 
> Eric Biggers (5):
>   crypto: chacha20 - Fix unaligned access when loading constants
>   crypto: chacha20 - Use unaligned access macros when loading key and IV
>   crypto: chacha20 - Remove cra_alignmask
>   crypto: x86/chacha20 - Remove cra_alignmask
>   crypto: chacha20 - Fix keystream alignment for chacha20_block()

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
