Return-Path: <SRS0=FsAa=P2=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:48456 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727039AbfARKzh (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 18 Jan 2019 05:55:37 -0500
Date: Fri, 18 Jan 2019 18:55:36 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org
Subject: Re: [PATCH 0/3] crypto: set CRYPTO_TFM_NEED_KEY if ->setkey() fails
Message-ID: <20190118105536.4i4xwqindoqh2wex@gondor.apana.org.au>
References: <20190107024744.4952-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190107024744.4952-1-ebiggers@kernel.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sun, Jan 06, 2019 at 06:47:41PM -0800, Eric Biggers wrote:
> This series makes the crypto API mark shash, ahash, skcipher, and aead
> tfms as needing a key again if setting a key fails, since on failure
> many algorithms can leave the tfm in an intermediate state that is
> neither the old key nor the new key -- and use of such tfms for hashing,
> encryption, or decryption will produce bogus results or crashes.
> 
> Eric Biggers (3):
>   crypto: hash - set CRYPTO_TFM_NEED_KEY if ->setkey() fails
>   crypto: skcipher - set CRYPTO_TFM_NEED_KEY if ->setkey() fails
>   crypto: aead - set CRYPTO_TFM_NEED_KEY if ->setkey() fails
> 
>  crypto/aead.c     |  4 +++-
>  crypto/ahash.c    | 28 +++++++++++++++++++---------
>  crypto/shash.c    | 18 +++++++++++++-----
>  crypto/skcipher.c | 27 ++++++++++++++++++---------
>  4 files changed, 53 insertions(+), 24 deletions(-)

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
