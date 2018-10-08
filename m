From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 0/3] crypto: mxs-dcp - Fix tcrypt on imx6
Date: Mon, 8 Oct 2018 13:52:26 +0800
Message-ID: <20181008055226.kpqykclsjmb72cde@gondor.apana.org.au>
References: <cover.1538505573.git.leonard.crestez@nxp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Marek Vasut <marek.vasut@gmail.com>,
        Fabio Estevam <fabio.estevam@nxp.com>,
        Horia Geanta <horia.geanta@nxp.com>,
        Franck Lenormand <franck.lenormand@nxp.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        "David S . Miller " <davem@davemloft.net>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
To: Leonard Crestez <leonard.crestez@nxp.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <cover.1538505573.git.leonard.crestez@nxp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, Oct 02, 2018 at 07:01:46PM +0000, Leonard Crestez wrote:
> The mxs-dcp driver currently fails to probe on imx6. Fix the whole thing
> by porting a cleaned/squashed version of fixes carried in the NXP vendor
> tree.
> 
> Tested with "modprobe tcrypt" and CONFIG_CRYPTO_MANAGER_DISABLE_TESTS=n
> on imx6sl imx6sll imx6ull: no failures.
> 
> I'm not very familiar with crypto and did not write write these fixes so
> a skeptical review would be appreciated.
> 
> Previously:
>   https://lore.kernel.org/patchwork/patch/989652/
> 
> Dan Douglass (1):
>   crypto: mxs-dcp - Implement sha import/export
> 
> Radu Solea (2):
>   crypto: mxs-dcp - Fix SHA null hashes and output length
>   crypto: mxs-dcp - Fix AES issues
> 
>  drivers/crypto/mxs-dcp.c | 121 ++++++++++++++++++++++++++++++++-------
>  1 file changed, 101 insertions(+), 20 deletions(-)

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
