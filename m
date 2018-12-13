Return-Path: <SRS0=KZld=OW=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:50556 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728341AbeLMKfh (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 13 Dec 2018 05:35:37 -0500
Date: Thu, 13 Dec 2018 18:35:34 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org, PanBian <bianpan2016@163.com>
Subject: Re: [PATCH] crypto: adiantum - fix leaking reference to hash
 algorithm
Message-ID: <20181213103534.5xnn76nkoewedrbb@gondor.apana.org.au>
References: <20181210194558.106364-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181210194558.106364-1-ebiggers@kernel.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Dec 10, 2018 at 11:45:58AM -0800, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> crypto_alg_mod_lookup() takes a reference to the hash algorithm but
> crypto_init_shash_spawn() doesn't take ownership of it, hence the
> reference needs to be dropped in adiantum_create().
> 
> Fixes: 059c2a4d8e16 ("crypto: adiantum - add Adiantum support")
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
