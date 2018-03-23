From: =?iso-8859-2?Q?Horia_Geant=E3?= <horia.geanta@nxp.com>
Subject: Re: [PATCH v2] crypto: talitos - fix IPsec cipher in length
Date: Fri, 23 Mar 2018 08:17:30 +0000
Message-ID: <AM3PR04MB4524FABE12B33113FF4C2D598A80@AM3PR04MB452.eurprd04.prod.outlook.com>
References: <20180322095701.4563E6F352@po15720vm.idsi0.si.c-s.fr>
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

On 3/22/2018 11:57 AM, Christophe Leroy wrote:=0A=
> For SEC 2.x+, cipher in length must contain only the ciphertext length.=
=0A=
          ^^^^ turns out this should be 3.x+=0A=
=0A=
> In case of using hardware ICV checking, the ICV length is provided via=0A=
> the "extent" field of the descriptor pointer.=0A=
> =0A=
> Cc: <stable@vger.kernel.org> # 4.8+=0A=
> Fixes: 549bd8bc5987 ("crypto: talitos - Implement AEAD for SEC1 using HMA=
C_SNOOP_NO_AFEU")=0A=
> Reported-by: Horia Geant=E3 <horia.geanta@nxp.com>=0A=
> Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>=0A=
Tested-by: Horia Geant=E3 <horia.geanta@nxp.com>=0A=
=0A=
Thanks,=0A=
Horia=0A=
=0A=
