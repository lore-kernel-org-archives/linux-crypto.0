From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [RFC PATCH 0/9] crypto: prevent unkeyed use of keyed algorithms
Date: Fri, 12 Jan 2018 23:24:10 +1100
Message-ID: <20180112122410.GG21636@gondor.apana.org.au>
References: <20180103191630.79917-1-ebiggers3@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Eric Biggers <ebiggers@google.com>
To: Eric Biggers <ebiggers3@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from [128.1.224.119] ([128.1.224.119]:54480 "EHLO ringil.hmeau.com"
        rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S933396AbeALMYt (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 12 Jan 2018 07:24:49 -0500
Content-Disposition: inline
In-Reply-To: <20180103191630.79917-1-ebiggers3@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Jan 03, 2018 at 11:16:21AM -0800, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> This series updates the crypto API to consistently prevent using keyed
> algorithms without setting the key.  Currently this is prevented for
> AF_ALG but not for other crypto API users, which is very problematic for
> other places in the kernel where userspace can specify a hash algorithm
> by name, e.g. KEYCTL_DH_COMPUTE as demonstrated by syzbot
> (https://marc.info/?l=linux-crypto-vger&m=151395810921850).
> 
> This series fixes the bug for all users by adding a flag
> CRYPTO_ALG_NEED_KEY to crypto_tfm.crt_flags.  This flag is set if needed
> when the tfm is created, is cleared when the key is set, and is checked
> when doing an operation that would require the key.
> 
> Patches 1-6 update the hash API, which is the primary fix.  I've marked
> all those patches for stable, which is kind of a pain, but it seems the
> alternative would be very messy -- we'd have to patch at least 5
> different crypto API users (probably missing some), then revert those
> patches upstream once we have the proper fix at the API level.
> 
> The last two patches also extend the fix to the skcipher and AEAD APIs,
> primarily as a sanity check since users should be less likely to try to
> use skciphers or AEADs without setting a key.
> 
> Eric Biggers (9):
>   crypto: hash - introduce crypto_hash_alg_has_setkey()
>   crypto: cryptd - pass through absence of ->setkey()
>   crypto: mcryptd - pass through absence of ->setkey()
>   crypto: poly1305 - remove ->setkey() method
>   crypto: hash - annotate algorithms taking optional key
>   crypto: hash - prevent using keyed hashes without setting key
>   crypto: ghash - remove checks for key being set
>   crypto: skcipher - prevent using skciphers without setting key
>   crypto: aead - prevent using AEADs without setting key

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
