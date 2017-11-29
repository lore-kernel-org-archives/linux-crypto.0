From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [crypto v3 2/2] chcr: Add support for Inline IPSec
Date: Wed, 29 Nov 2017 17:37:56 +1100
Message-ID: <20171129063756.GK21575@gondor.apana.org.au>
References: <1510831628-31955-1-git-send-email-atul.gupta@chelsio.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, netdev@vger.kernel.org,
        davem@davemloft.net, steffen.klassert@secunet.com,
        Harsh Jain <harsh@chelsio.com>,
        Ganesh Goudar <ganeshgr@chelsio.com>
To: Atul Gupta <atul.gupta@chelsio.com>
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1510831628-31955-1-git-send-email-atul.gupta@chelsio.com>
Sender: netdev-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, Nov 16, 2017 at 04:57:08PM +0530, Atul Gupta wrote:
> register xfrmdev_ops callbacks, Send IPsec tunneled data
> to HW for inline processing.
> The driver use hardware crypto accelerator to encrypt and
> generate ICV for the transmitted packet in Inline mode.
> 
> Signed-off-by: Atul Gupta <atul.gupta@chelsio.com>
> Signed-off-by: Harsh Jain <harsh@chelsio.com>
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
