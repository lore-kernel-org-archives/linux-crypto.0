Return-Path: <SRS0=9Gyh=PA=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:39000 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389961AbeLWEDW (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 22 Dec 2018 23:03:22 -0500
Date: Sun, 23 Dec 2018 12:03:20 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org
Subject: Re: [PATCH] crypto: skcipher - add might_sleep() to
 skcipher_walk_virt()
Message-ID: <20181223040320.etvfog53jtxxlywg@gondor.apana.org.au>
References: <20181215204153.8016-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181215204153.8016-1-ebiggers@kernel.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sat, Dec 15, 2018 at 12:41:53PM -0800, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> skcipher_walk_virt() can still sleep even with atomic=true, since that
> only affects the later calls to skcipher_walk_done().  But,
> skcipher_walk_virt() only has to allocate memory for some input data
> layouts, so incorrectly calling it with preemption disabled can go
> undetected.  Use might_sleep() so that it's detected reliably.
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
>  crypto/skcipher.c | 2 ++
>  1 file changed, 2 insertions(+)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
