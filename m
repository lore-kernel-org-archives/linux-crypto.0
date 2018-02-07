From: =?iso-8859-2?Q?Horia_Geant=E3?= <horia.geanta@nxp.com>
Subject: Re: [PATCH 16/18] crypto: talitos - do hw_context DMA mapping outside
 the requests
Date: Wed, 7 Feb 2018 14:39:52 +0000
Message-ID: <VI1PR0402MB3342A0A8530F74D408CA2F0298FC0@VI1PR0402MB3342.eurprd04.prod.outlook.com>
References: <cover.1507284818.git.christophe.leroy@c-s.fr>
 <e47bf94ae44f23230b1647e31c9623f1075d3b79.1507284818.git.christophe.leroy@c-s.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>
To: Christophe Leroy <christophe.leroy@c-s.fr>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 10/6/2017 4:06 PM, Christophe Leroy wrote:=0A=
> At every request, we map and unmap the same hash hw_context.=0A=
> =0A=
> This patch moves the dma mapping/unmapping in functions ahash_init()=0A=
> and ahash_import().=0A=
> =0A=
> Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>=0A=
> ---=0A=
>  drivers/crypto/talitos.c | 80 ++++++++++++++++++++++++++++++++++--------=
------=0A=
>  1 file changed, 57 insertions(+), 23 deletions(-)=0A=
> =0A=
> diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c=0A=
> index ebfd6d982ed6..d495649d5267 100644=0A=
> --- a/drivers/crypto/talitos.c=0A=
> +++ b/drivers/crypto/talitos.c=0A=
> @@ -819,6 +819,7 @@ struct talitos_ctx {=0A=
>  	unsigned int keylen;=0A=
>  	unsigned int enckeylen;=0A=
>  	unsigned int authkeylen;=0A=
> +	dma_addr_t dma_hw_context;=0A=
This doesn't look correct.=0A=
=0A=
talitos_ctx structure is the tfm context.=0A=
dma_hw_context is the IOVA of hw_context, located in talitos_ahash_req_ctx=
=0A=
structure (request context).=0A=
=0A=
If there are multiple requests in flight for the same tfm, dma_hw_context w=
ill=0A=
be overwritten.=0A=
=0A=
dma_hw_context needs to be moved in request context (talitos_ahash_req_ctx =
struct).=0A=
=0A=
Thanks,=0A=
Horia=0A=
