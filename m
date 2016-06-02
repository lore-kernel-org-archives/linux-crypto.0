From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [RFC v2 2/3] crypto: Introduce CRYPTO_ALG_BULK flag
Date: Thu, 2 Jun 2016 16:26:06 +0800
Message-ID: <20160602082606.GA15226@gondor.apana.org.au>
References: <cover.1464346333.git.baolin.wang@linaro.org>
 <47e9ddd8c9ea9ad9e29c8cb027d19d8459ea1479.1464346333.git.baolin.wang@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: axboe@kernel.dk, agk@redhat.com, snitzer@redhat.com,
	dm-devel@redhat.com, davem@davemloft.net, ebiggers3@gmail.com,
	js1304@gmail.com, tadeusz.struk@intel.com, smueller@chronox.de,
	standby24x7@gmail.com, shli@kernel.org, dan.j.williams@intel.com,
	martin.petersen@oracle.com, sagig@mellanox.com,
	kent.overstreet@gmail.com, keith.busch@intel.com, tj@kernel.org,
	ming.lei@canonical.com, broonie@kernel.org, arnd@arndb.de,
	linux-crypto@vger.kernel.org, linux-block@vger.kernel.org,
	linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
To: Baolin Wang <baolin.wang@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <47e9ddd8c9ea9ad9e29c8cb027d19d8459ea1479.1464346333.git.baolin.wang@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Fri, May 27, 2016 at 07:11:23PM +0800, Baolin Wang wrote:
> Now some cipher hardware engines prefer to handle bulk block rather than one
> sector (512 bytes) created by dm-crypt, cause these cipher engines can handle
> the intermediate values (IV) by themselves in one bulk block. This means we
> can increase the size of the request by merging request rather than always 512
> bytes and thus increase the hardware engine processing speed.
> 
> So introduce 'CRYPTO_ALG_BULK' flag to indicate this cipher can support bulk
> mode.
> 
> Signed-off-by: Baolin Wang <baolin.wang@linaro.org>

I think a better aproach would be to explicitly move the IV generation
into the crypto API, similar to how we handle IPsec.  Once you do
that then every algorithm can be handled through the bulk interface.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
