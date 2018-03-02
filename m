From: =?iso-8859-2?Q?Horia_Geant=E3?= <horia.geanta@nxp.com>
Subject: Re: [PATCH 17/18] crypto: talitos - chain in buffered data for ahash
 on SEC1
Date: Fri, 2 Mar 2018 17:27:41 +0000
Message-ID: <VI1PR0402MB3342BDF9D4E389B4E296A53298C50@VI1PR0402MB3342.eurprd04.prod.outlook.com>
References: <cover.1507284818.git.christophe.leroy@c-s.fr>
 <28d351a973d31d140239c7e7e64999d95a011e8c.1507284818.git.christophe.leroy@c-s.fr>
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

On 10/6/2017 4:05 PM, Christophe Leroy wrote:=0A=
[...]=0A=
> @@ -1778,6 +1814,36 @@ static int common_nonsnoop_hash(struct talitos_ede=
sc *edesc,=0A=
>  	if (is_sec1 && from_talitos_ptr_len(&desc->ptr[3], true) =3D=3D 0)=0A=
>  		talitos_handle_buggy_hash(ctx, edesc, &desc->ptr[3]);=0A=
>  =0A=
> +	if (is_sec1 && req_ctx->nbuf && length) {=0A=
> +		struct talitos_desc *desc2 =3D desc + 1;=0A=
> +		dma_addr_t next_desc;=0A=
[...]=0A=
> +		next_desc =3D dma_map_single(dev, &desc2->hdr1, TALITOS_DESC_SIZE,=0A=
> +					   DMA_BIDIRECTIONAL);=0A=
> +		desc->next_desc =3D cpu_to_be32(next_desc);=0A=
Where is desc->next_desc initialized for the !is_sec1 case?=0A=
Memory allocation is done using kmalloc(), and since desc->next_desc is che=
cked=0A=
in some cases also for SEC 2.x+, it should be initialized to 0.=0A=
=0A=
Thanks,=0A=
Horia=0A=
=0A=
