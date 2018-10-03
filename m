From: Horia Geanta <horia.geanta@nxp.com>
Subject: Re: [PATCH] crypto: caam/qi2 - avoid double export
Date: Wed, 3 Oct 2018 07:24:18 +0000
Message-ID: <VI1PR0402MB3485CCAD46947DF023B2B3FE98E90@VI1PR0402MB3485.eurprd04.prod.outlook.com>
References: <20181002205720.2255567-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
To: Arnd Bergmann <arnd@arndb.de>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 10/2/2018 11:57 PM, Arnd Bergmann wrote:=0A=
> Both the caam ctrl file and dpaa2_caam export a couple of flags. They=0A=
> use an #ifdef check to make sure that each flag is only built once,=0A=
> but this fails if they are both loadable modules:=0A=
> =0A=
> WARNING: drivers/crypto/caam/dpaa2_caam: 'caam_little_end' exported twice=
. Previous export was in drivers/crypto/caam/caam.ko=0A=
> WARNING: drivers/crypto/caam/dpaa2_caam: 'caam_imx' exported twice. Previ=
ous export was in drivers/crypto/caam/caam.ko=0A=
> =0A=
> Change the #ifdef to an IS_ENABLED() check in order to make it work in=0A=
> all configurations. It may be better to redesign this aspect of the=0A=
> two drivers in a cleaner way.=0A=
> =0A=
I think this fix is ok for the moment.=0A=
Indeed, work is on-going to change the design a bit.=0A=
=0A=
> Fixes: 8d818c105501 ("crypto: caam/qi2 - add DPAA2-CAAM driver")=0A=
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>=0A=
Acked-by: Horia Geant=E3 <horia.geanta@nxp.com>=0A=
=0A=
Thanks,=0A=
Horia=0A=
