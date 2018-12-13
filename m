Return-Path: <SRS0=KZld=OW=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:50504 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728388AbeLMKcS (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 13 Dec 2018 05:32:18 -0500
Date: Thu, 13 Dec 2018 18:32:16 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org
Subject: Re: [PATCH] crypto: adiantum - propagate CRYPTO_ALG_ASYNC flag to
 instance
Message-ID: <20181213103216.nc23nggpnl3fz6ft@gondor.apana.org.au>
References: <20181205004654.242204-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181205004654.242204-1-ebiggers@kernel.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Dec 04, 2018 at 04:46:54PM -0800, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> If the stream cipher implementation is asynchronous, then the Adiantum
> instance must be flagged as asynchronous as well.  Otherwise someone
> asking for a synchronous algorithm can get an asynchronous algorithm.
> 
> There are no asynchronous xchacha12 or xchacha20 implementations yet
> which makes this largely a theoretical issue, but it should be fixed.
> 
> Fixes: 059c2a4d8e16 ("crypto: adiantum - add Adiantum support")
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
>  crypto/adiantum.c | 2 ++
>  1 file changed, 2 insertions(+)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
