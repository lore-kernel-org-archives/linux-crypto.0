From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 0/4] crypto: gf128mul cleanups
Date: Thu, 9 Mar 2017 18:46:09 +0800
Message-ID: <20170309104609.GA7185@gondor.apana.org.au>
References: <20170214214330.99845-1-ebiggers@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>
To: Eric Biggers <ebiggers@google.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:55541 "EHLO
        helcar.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S932866AbdCISSo (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 9 Mar 2017 13:18:44 -0500
Content-Disposition: inline
In-Reply-To: <20170214214330.99845-1-ebiggers@google.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Feb 14, 2017 at 01:43:26PM -0800, Eric Biggers wrote:
> This patchset makes a few cleanups to the generic GF(2^128) multiplication code
> to make it slightly easier to understand and modify.  No functional changes are
> intended.
> 
> Eric Biggers (4):
>   crypto: gf128mul - fix some comments
>   crypto: gf128mul - remove xx() macro
>   crypto: gf128mul - rename the byte overflow tables
>   crypto: gf128mul - constify 4k and 64k multiplication tables
> 
>  crypto/gf128mul.c         | 86 +++++++++++++++++++++++++++--------------------
>  include/crypto/gf128mul.h | 32 +++++++++---------
>  2 files changed, 67 insertions(+), 51 deletions(-)

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
