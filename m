From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [patch] crypto: nx - off by one bug in nx_of_update_msc()
Date: Mon, 18 Jul 2016 18:23:33 +0800
Message-ID: <20160718102333.GC13780@gondor.apana.org.au>
References: <20160715110912.GE9258@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Leonidas S. Barbosa" <leosilva@linux.vnet.ibm.com>,
	Kent Yoder <key@linux.vnet.ibm.com>,
	Paulo Flabiano Smorigo <pfsmorigo@linux.vnet.ibm.com>,
	Benjamin Herrenschmidt <benh@kernel.crashing.org>,
	Paul Mackerras <paulus@samba.org>,
	Michael Ellerman <mpe@ellerman.id.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
	kernel-janitors@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Return-path: <kernel-janitors-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160715110912.GE9258@mwanda>
Sender: kernel-janitors-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Fri, Jul 15, 2016 at 02:09:13PM +0300, Dan Carpenter wrote:
> The props->ap[] array is defined like this:
> 
> 	struct alg_props ap[NX_MAX_FC][NX_MAX_MODE][3];
> 
> So we can see that if msc->fc and msc->mode are == to NX_MAX_FC or
> NX_MAX_MODE then we're off by one.
> 
> Fixes: ae0222b7289d ('powerpc/crypto: nx driver code supporting nx encryption')
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
