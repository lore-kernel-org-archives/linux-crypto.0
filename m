From: =?iso-8859-2?Q?Horia_Geant=E3?= <horia.geanta@nxp.com>
Subject: Re: [PATCH 2/2] crypto: caam: Use common error handling code in four
 functions
Date: Thu, 15 Feb 2018 08:03:24 +0000
Message-ID: <VI1PR0402MB3342F9E0700AA3A7CC20D8DC98F40@VI1PR0402MB3342.eurprd04.prod.outlook.com>
References: <9a9a602d-93da-457d-c37d-2acbb4b7b5d5@users.sourceforge.net>
 <3c2905a1-b3a4-be87-618e-8562d3a5d8b4@users.sourceforge.net>
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

On 2/14/2018 8:32 PM, SF Markus Elfring wrote:=0A=
> From: Markus Elfring <elfring@users.sourceforge.net>=0A=
> Date: Wed, 14 Feb 2018 19:14:49 +0100=0A=
> =0A=
> Add jump targets so that a bit of exception handling can be better reused=
=0A=
> at the end of these functions.=0A=
> =0A=
> Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>=0A=
[snip]=0A=
> @@ -1096,6 +1092,7 @@ static int ahash_digest(struct ahash_request *req)=
=0A=
>  	if (!ret) {=0A=
>  		ret =3D -EINPROGRESS;=0A=
>  	} else {=0A=
> +unmap_hash:=0A=
>  		ahash_unmap(jrdev, edesc, req, digestsize);=0A=
>  		kfree(edesc);=0A=
>  	}=0A=
> =0A=
I understand jumps are a necessary evil for dealing with shortcomings of C,=
=0A=
however please avoid jumping in an if/else branch.=0A=
=0A=
Code could be rewritten as:=0A=
=0A=
  	if (!ret)=0A=
  		return -EINPROGRESS;=0A=
=0A=
unmap_hash:=0A=
  	ahash_unmap(jrdev, edesc, req, digestsize);=0A=
  	kfree(edesc);=0A=
=0A=
Thanks,=0A=
Horia=0A=
