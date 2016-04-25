From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [patch 1/2] crypto: mxc-scc - signedness bugs in
 mxc_scc_ablkcipher_req_init()
Date: Mon, 25 Apr 2016 19:22:52 +0800
Message-ID: <20160425112252.GC10114@gondor.apana.org.au>
References: <20160422095631.GC11398@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Steffen Trumtrar <s.trumtrar@pengutronix.de>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, kernel-janitors@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Return-path: <kernel-janitors-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160422095631.GC11398@mwanda>
Sender: kernel-janitors-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Fri, Apr 22, 2016 at 12:56:31PM +0300, Dan Carpenter wrote:
> ->src_nents and ->dst_nents are unsigned so they can't be less than
> zero.  I fixed this by introducing a temporary "nents" variable.
> 
> Fixes: d293b640ebd5 ('crypto: mxc-scc - add basic driver for the MXC SCC')
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Both applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
