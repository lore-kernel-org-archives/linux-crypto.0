From: Horia Geanta Neag <horia.geanta@nxp.com>
Subject: Re: [PATCH 1/6] crypto-caamhash: Use kmalloc_array() in
 ahash_setkey()
Date: Thu, 15 Sep 2016 15:12:53 +0000
Message-ID: <DB4PR04MB08474A72E7EDE8691A344FA998F00@DB4PR04MB0847.eurprd04.prod.outlook.com>
References: <566ABCD9.1060404@users.sourceforge.net>
 <970e9e1b-c1dc-eb28-b380-92c15e9b1961@users.sourceforge.net>
 <4e1bc780-fa00-cfc9-c058-240bb899d701@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Cc: LKML <linux-kernel@vger.kernel.org>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        Julia Lawall <julia.lawall@lip6.fr>
To: SF Markus Elfring <elfring@users.sourceforge.net>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Labbe Corentin <clabbe.montjoie@gmail.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-db5eur01on0070.outbound.protection.outlook.com ([104.47.2.70]:23184
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751570AbcIOPM4 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 15 Sep 2016 11:12:56 -0400
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 9/15/2016 5:43 PM, SF Markus Elfring wrote:=0A=
> From: Markus Elfring <elfring@users.sourceforge.net>=0A=
> Date: Thu, 15 Sep 2016 11:20:09 +0200=0A=
> =0A=
> * A multiplication for the size determination of a memory allocation=0A=
>   indicated that an array data structure should be processed.=0A=
>   Thus use the corresponding function "kmalloc_array".=0A=
> =0A=
>   This issue was detected by using the Coccinelle software.=0A=
> =0A=
> * Replace the specification of a data type by a pointer dereference=0A=
>   to make the corresponding size determination a bit safer according to=
=0A=
>   the Linux coding style convention.=0A=
> =0A=
> Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>=0A=
> ---=0A=
>  drivers/crypto/caam/caamhash.c | 5 +++--=0A=
>  1 file changed, 3 insertions(+), 2 deletions(-)=0A=
> =0A=
> diff --git a/drivers/crypto/caam/caamhash.c b/drivers/crypto/caam/caamhas=
h.c=0A=
> index 9d7fc9e..f19df8f 100644=0A=
> --- a/drivers/crypto/caam/caamhash.c=0A=
> +++ b/drivers/crypto/caam/caamhash.c=0A=
> @@ -525,8 +525,9 @@ static int ahash_setkey(struct crypto_ahash *ahash,=
=0A=
>  #endif=0A=
>  =0A=
>  	if (keylen > blocksize) {=0A=
> -		hashed_key =3D kmalloc(sizeof(u8) * digestsize, GFP_KERNEL |=0A=
> -				     GFP_DMA);=0A=
> +		hashed_key =3D kmalloc_array(digestsize,=0A=
> +					   sizeof(*hashed_key),=0A=
> +					   GFP_KERNEL | GFP_DMA);=0A=
While correct, instead I would go with kmalloc() and get rid of sizeof(u8).=
=0A=
=0A=
Horia=0A=
