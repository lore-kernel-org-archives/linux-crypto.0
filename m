From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: caam - properly set IV after {en,de}crypt
Date: Wed, 12 Jul 2017 18:51:56 +0800
Message-ID: <20170712105156.GC22109@gondor.apana.org.au>
References: <20170602122446.2427-1-david@sigma-star.at>
 <20170628132710.97278-1-david@sigma-star.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: horia.geanta@nxp.com, dan.douglass@nxp.com, davem@davemloft.net,
        richard@sigma-star.at, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
To: David Gstir <david@sigma-star.at>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170628132710.97278-1-david@sigma-star.at>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wed, Jun 28, 2017 at 03:27:10PM +0200, David Gstir wrote:
> Certain cipher modes like CTS expect the IV (req->info) of
> ablkcipher_request (or equivalently req->iv of skcipher_request) to
> contain the last ciphertext block when the {en,de}crypt operation is done.
> This is currently not the case for the CAAM driver which in turn breaks
> e.g. cts(cbc(aes)) when the CAAM driver is enabled.
> 
> This patch fixes the CAAM driver to properly set the IV after the
> {en,de}crypt operation of ablkcipher finishes.
> 
> This issue was revealed by the changes in the SW CTS mode in commit
> 0605c41cc53ca ("crypto: cts - Convert to skcipher")
> 
> Cc: <stable@vger.kernel.org> # 4.8+
> Signed-off-by: David Gstir <david@sigma-star.at>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
