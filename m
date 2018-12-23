Return-Path: <SRS0=9Gyh=PA=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:39010 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389657AbeLWEDa (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 22 Dec 2018 23:03:30 -0500
Date: Sun, 23 Dec 2018 12:03:29 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org
Subject: Re: [PATCH] crypto: salsa20-generic - don't unnecessarily use atomic
 walk
Message-ID: <20181223040329.ccno7ybpoeeygoog@gondor.apana.org.au>
References: <20181215204252.8138-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181215204252.8138-1-ebiggers@kernel.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sat, Dec 15, 2018 at 12:42:52PM -0800, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> salsa20-generic doesn't use SIMD instructions or otherwise disable
> preemption, so passing atomic=true to skcipher_walk_virt() is
> unnecessary.
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
>  crypto/salsa20_generic.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
