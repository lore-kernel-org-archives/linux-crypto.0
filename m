From: Horia Geanta Neag <horia.geanta@nxp.com>
Subject: Re: crypto-caamhash: Fine-tuning for several function implementations
Date: Thu, 15 Sep 2016 15:30:04 +0000
Message-ID: <DB4PR04MB08478A32519FC440E476FDEC98F00@DB4PR04MB0847.eurprd04.prod.outlook.com>
References: <566ABCD9.1060404@users.sourceforge.net>
 <970e9e1b-c1dc-eb28-b380-92c15e9b1961@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-2"
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
Return-path: <kernel-janitors-owner@vger.kernel.org>
Content-Language: en-US
Sender: kernel-janitors-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 9/15/2016 5:37 PM, SF Markus Elfring wrote:=0A=
> From: Markus Elfring <elfring@users.sourceforge.net>=0A=
> Date: Thu, 15 Sep 2016 16:27:23 +0200=0A=
> =0A=
> Some update suggestions were taken into account=0A=
> from static source code analysis.=0A=
> =0A=
> Markus Elfring (6):=0A=
>   Use kmalloc_array() in ahash_setkey()=0A=
>   Rename jump labels in ahash_setkey()=0A=
>   Rename a jump label in five functions=0A=
>   Return a value directly in caam_hash_cra_init()=0A=
>   Delete an unnecessary initialisation in seven functions=0A=
>   Move common error handling code in two functions=0A=
> =0A=
>  drivers/crypto/caam/caamhash.c | 111 +++++++++++++++++++----------------=
------=0A=
>  1 file changed, 52 insertions(+), 59 deletions(-)=0A=
> =0A=
Thanks Markus!=0A=
=0A=
For patches 2-6:=0A=
Reviewed-by: Horia Geant=E3 <horia.geanta@nxp.com>=0A=
=0A=
though headline prefix should be changed to "crypto: caam -"=0A=
=0A=
Horia=0A=
=0A=
