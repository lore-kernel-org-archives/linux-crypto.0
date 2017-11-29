From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [crypto v3 1/2] cxgb4: Add support for Inline IPSec Tx
Date: Wed, 29 Nov 2017 17:37:48 +1100
Message-ID: <20171129063748.GJ21575@gondor.apana.org.au>
References: <1510831599-31915-1-git-send-email-atul.gupta@chelsio.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, netdev@vger.kernel.org,
        davem@davemloft.net, steffen.klassert@secunet.com,
        Ganesh Goudar <ganeshgr@chelsio.com>
To: Atul Gupta <atul.gupta@chelsio.com>
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1510831599-31915-1-git-send-email-atul.gupta@chelsio.com>
Sender: netdev-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, Nov 16, 2017 at 04:56:39PM +0530, Atul Gupta wrote:
> Added Tx routine for ULD
> - define interface for ULD Tx.
> 
> Export routines used for Tx data
> - Routines common for data transmit are used by cxgb4 and chcr
>   drivers.
> - EXPORT routines enable transmit from chcr driver.
> 
> Signed-off-by: Atul Gupta <atul.gupta@chelsio.com>
> Signed-off-by: Ganesh Goudar <ganeshgr@chelsio.com>
> ---
> V2: Fixed the build warnings and created patch against cryptodev
>     to avoid possible merge conflicts
> V3: Fixed a build warning and added flag for data packet

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
