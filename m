From: =?iso-8859-2?Q?Horia_Geant=E3?= <horia.geanta@nxp.com>
Subject: Re: [PATCH 1/2] crypto: caam: Delete an error message for a failed
 memory allocation in seven functions
Date: Thu, 15 Feb 2018 07:45:12 +0000
Message-ID: <VI1PR0402MB334251AFB6F45F48F0A5C32898F40@VI1PR0402MB3342.eurprd04.prod.outlook.com>
References: <9a9a602d-93da-457d-c37d-2acbb4b7b5d5@users.sourceforge.net>
 <594d974d-577d-353d-9e99-4f98ad911cb4@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
Cc: LKML <linux-kernel@vger.kernel.org>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
To: SF Markus Elfring <elfring@users.sourceforge.net>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <kernel-janitors-owner@vger.kernel.org>
Content-Language: en-US
Sender: kernel-janitors-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 2/14/2018 8:31 PM, SF Markus Elfring wrote:=0A=
> From: Markus Elfring <elfring@users.sourceforge.net>=0A=
> Date: Wed, 14 Feb 2018 18:22:38 +0100=0A=
> =0A=
> Omit an extra message for a memory allocation failure in these functions.=
=0A=
> =0A=
> This issue was detected by using the Coccinelle software.=0A=
> =0A=
> Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>=0A=
Reviewed-by: Horia Geant=E3 <horia.geanta@nxp.com>=0A=
=0A=
though please consider the following=0A=
=0A=
> @@ -689,10 +687,8 @@ static struct ahash_edesc *ahash_edesc_alloc(struct =
caam_hash_ctx *ctx,=0A=
>  	unsigned int sg_size =3D sg_num * sizeof(struct sec4_sg_entry);=0A=
>  =0A=
>  	edesc =3D kzalloc(sizeof(*edesc) + sg_size, GFP_DMA | flags);=0A=
> -	if (!edesc) {=0A=
> -		dev_err(ctx->jrdev, "could not allocate extended descriptor\n");=0A=
> +	if (!edesc)=0A=
>  		return NULL;=0A=
> -	}=0A=
>  =0A=
With this change, ctx parameter is no longer used in ahash_edesc_alloc().=
=0A=
Either here on in a different patch the function should be updated.=0A=
=0A=
Thanks,=0A=
Horia=0A=
