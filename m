From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2 2/2] crypto: engine - Permit to enqueue skcipher
 request
Date: Mon, 19 Jun 2017 13:27:08 +0800
Message-ID: <20170619052707.GA13180@gondor.apana.org.au>
References: <20170606134417.18850-1-clabbe.montjoie@gmail.com>
 <20170606134417.18850-3-clabbe.montjoie@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: Corentin Labbe <clabbe.montjoie@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170606134417.18850-3-clabbe.montjoie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, Jun 06, 2017 at 03:44:17PM +0200, Corentin Labbe wrote:
> The crypto engine could actually only enqueue hash and ablkcipher request.
> This patch permit it to enqueue skcipher requets by adding all necessary
> functions.
> The only problem is that ablkcipher and skcipher id are the same, so
> only one cipher type is usable on the same crypto engine.
> 
> Signed-off-by: Corentin Labbe <clabbe.montjoie@gmail.com>

I think this should be done as part of the skcipher conversion rather
than as a standalone patch.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
