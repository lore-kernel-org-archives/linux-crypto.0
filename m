From: =?iso-8859-2?Q?Horia_Geant=E3?= <horia.geanta@nxp.com>
Subject: Re: [PATCH 1/2] crypto: talitos - don't persistently map
 req_ctx->hw_context and req_ctx->buf
Date: Fri, 2 Mar 2018 18:19:23 +0000
Message-ID: <VI1PR0402MB3342DC809DACC396FAA21A4698C50@VI1PR0402MB3342.eurprd04.prod.outlook.com>
References: <7c934f0788d60bd82fb1cb51d712c9ab1ea7fcb4.1519660621.git.christophe.leroy@c-s.fr>
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

On 2/26/2018 6:40 PM, Christophe Leroy wrote:=0A=
> Commit 49f9783b0cea ("crypto: talitos - do hw_context DMA mapping=0A=
> outside the requests") introduced a persistent dma mapping of=0A=
> req_ctx->hw_context=0A=
> Commit 37b5e8897eb5 ("crypto: talitos - chain in buffered data for ahash=
=0A=
> on SEC1") introduced a persistent dma mapping of req_ctx->buf=0A=
> =0A=
> As there is no destructor for req_ctx (the request context), the=0A=
> associated dma handlers where set in ctx (the tfm context). This is=0A=
> wrong as several hash operations can run with the same ctx.=0A=
> =0A=
> This patch removes this persistent mapping.=0A=
> =0A=
> Reported-by: Horia Geanta <horia.geanta@nxp.com>=0A=
> Fixes: 49f9783b0cea ("crypto: talitos - do hw_context DMA mapping outside=
 the requests")=0A=
> Fixes: 37b5e8897eb5 ("crypto: talitos - chain in buffered data for ahash =
on SEC1")=0A=
> Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>=0A=
Tested-by: Horia Geant=E3 <horia.geanta@nxp.com>=0A=
=0A=
Please add this to 4.15.y -stable tree.=0A=
=0A=
Thanks,=0A=
Horia=0A=
