From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2] crypto: skcipher: remove the exporting of
 skcipher_walk_next
Date: Sun, 1 Jul 2018 21:19:08 +0800
Message-ID: <20180701131908.jl5kg6gosrvkmc4p@gondor.apana.org.au>
References: <20180617174959.29864-1-efremov@linux.com>
 <20180619202357.10805-1-efremov@linux.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Biggers <ebiggers3@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        ldv-project@linuxtesting.org
To: efremov@linux.com
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180619202357.10805-1-efremov@linux.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, Jun 19, 2018 at 11:23:57PM +0300, efremov@linux.com wrote:
> The function skcipher_walk_next declared as static and marked as
> EXPORT_SYMBOL_GPL. It's a bit confusing for internal function to be
> exported. The area of visibility for such function is its .c file
> and all other modules. Other *.c files of the same module can't use it,
> despite all other modules can. Relying on the fact that this is the
> internal function and it's not a crucial part of the API, the patch
> just removes the EXPORT_SYMBOL_GPL marking of skcipher_walk_next.
> 
> Found by Linux Driver Verification project (linuxtesting.org).
> 
> Signed-off-by: Denis Efremov <efremov@linux.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
