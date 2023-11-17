Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 874F4A6;
	Fri, 17 Nov 2023 03:23:50 -0800 (PST)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
	id 1r3wwj-000dKF-QR; Fri, 17 Nov 2023 19:23:38 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 17 Nov 2023 19:23:45 +0800
Date: Fri, 17 Nov 2023 19:23:45 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Dan Carpenter <dan.carpenter@linaro.org>
Cc: Mahmoud Adam <mngyadam@amazon.com>,
	"David S. Miller" <davem@davemloft.net>,
	Stephan Mueller <smueller@chronox.de>, linux-crypto@vger.kernel.org,
	kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] crypto: rsa - add a check for allocation failure
Message-ID: <ZVdNQV7GLhUsQ97L@gondor.apana.org.au>
References: <d870c278-3f0e-4386-a58d-c9e2c97a7c6c@moroto.mountain>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d870c278-3f0e-4386-a58d-c9e2c97a7c6c@moroto.mountain>

On Mon, Oct 30, 2023 at 12:02:59PM +0300, Dan Carpenter wrote:
> Static checkers insist that the mpi_alloc() allocation can fail so add
> a check to prevent a NULL dereference.  Small allocations like this
> can't actually fail in current kernels, but adding a check is very
> simple and makes the static checkers happy.
> 
> Fixes: 6637e11e4ad2 ("crypto: rsa - allow only odd e and restrict value in FIPS mode")
> Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
> ---
>  crypto/rsa.c | 2 ++
>  1 file changed, 2 insertions(+)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
