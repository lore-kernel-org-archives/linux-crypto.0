From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [patch] crypto: keywrap - memzero the correct memory
Date: Mon, 1 Feb 2016 22:35:21 +0800
Message-ID: <20160201143521.GD11410@gondor.apana.org.au>
References: <20160130143828.GC3462@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Stephan Mueller <smueller@chronox.de>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Return-path: <kernel-janitors-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160130143828.GC3462@mwanda>
Sender: kernel-janitors-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Sat, Jan 30, 2016 at 05:38:28PM +0300, Dan Carpenter wrote:
> We're clearing the wrong memory.  The memory corruption is likely
> harmless because we weren't going to use that stack memory again but not
> zeroing is a potential information leak.
> 
> Fixes: e28facde3c39 ('crypto: keywrap - add key wrapping block chaining mode')
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
