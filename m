From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [patch] crypto: rsa-pkcs1pad: indent a couple statements
Date: Fri, 11 Mar 2016 21:21:38 +0800
Message-ID: <20160311132138.GA24232@gondor.apana.org.au>
References: <20160308120736.GC28684@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Tadeusz Struk <tadeusz.struk@intel.com>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, kernel-janitors@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Return-path: <kernel-janitors-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160308120736.GC28684@mwanda>
Sender: kernel-janitors-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, Mar 08, 2016 at 03:07:36PM +0300, Dan Carpenter wrote:
> These if statements aren't indented far enough and it makes static
> checkers complain.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Sorry but this doesn't apply against cryptodev.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
