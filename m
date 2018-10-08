From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: caam/qi2 - avoid double export
Date: Mon, 8 Oct 2018 13:53:01 +0800
Message-ID: <20181008055301.mngrxpbfye5t4qn2@gondor.apana.org.au>
References: <20181002205720.2255567-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181002205720.2255567-1-arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, Oct 02, 2018 at 10:56:19PM +0200, Arnd Bergmann wrote:
> Both the caam ctrl file and dpaa2_caam export a couple of flags. They
> use an #ifdef check to make sure that each flag is only built once,
> but this fails if they are both loadable modules:
> 
> WARNING: drivers/crypto/caam/dpaa2_caam: 'caam_little_end' exported twice. Previous export was in drivers/crypto/caam/caam.ko
> WARNING: drivers/crypto/caam/dpaa2_caam: 'caam_imx' exported twice. Previous export was in drivers/crypto/caam/caam.ko
> 
> Change the #ifdef to an IS_ENABLED() check in order to make it work in
> all configurations. It may be better to redesign this aspect of the
> two drivers in a cleaner way.
> 
> Fixes: 8d818c105501 ("crypto: caam/qi2 - add DPAA2-CAAM driver")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  drivers/crypto/caam/caamalg_qi2.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
