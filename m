From: =?iso-8859-2?Q?Horia_Geant=E3?= <horia.geanta@nxp.com>
Subject: Re: [PATCH v3 2/5] crypto: caam: Fix endless loop when RNG is already
 initialized
Date: Thu, 1 Feb 2018 12:16:51 +0000
Message-ID: <VI1PR0402MB334297558BB1984131546B1D98FA0@VI1PR0402MB3342.eurprd04.prod.outlook.com>
References: <1517364040-27607-1-git-send-email-pure.logic@nexus-software.ie>
 <1517364040-27607-3-git-send-email-pure.logic@nexus-software.ie>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
Cc: Fabio Estevam <fabio.estevam@nxp.com>, Peng Fan <peng.fan@nxp.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "lukas.auer@aisec.fraunhofer.de" <lukas.auer@aisec.fraunhofer.de>,
        "rui.silva@linaro.org" <rui.silva@linaro.org>,
        "ryan.harkin@linaro.org" <ryan.harkin@linaro.org>,
        Herbert Xu <herbert@gondor.apana.org.au>
To: Bryan O'Donoghue <pure.logic@nexus-software.ie>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 1/31/2018 4:00 AM, Bryan O'Donoghue wrote:=0A=
> commit 1005bccd7a4a ("crypto: caam - enable instantiation of all RNG4 sta=
te=0A=
> handles") introduces a control when incrementing ent_delay which contains=
=0A=
> the following comment above it:=0A=
> =0A=
> /*=0A=
>  * If either SH were instantiated by somebody else=0A=
>  * (e.g. u-boot) then it is assumed that the entropy=0A=
>  * parameters are properly set and thus the function=0A=
>  * setting these (kick_trng(...)) is skipped.=0A=
>  * Also, if a handle was instantiated, do not change=0A=
>  * the TRNG parameters.=0A=
>  */=0A=
> =0A=
> This is a problem observed when sec_init() has been run in u-boot and=0A=
> and TrustZone is enabled. We can fix this by instantiating all rng state=
=0A=
> handles in u-boot but, on the Kernel side we should ensure that this=0A=
> non-terminating path is dealt with.=0A=
> =0A=
> Fixes: 1005bccd7a4a ("crypto: caam - enable instantiation of all RNG4 sta=
te=0A=
> handles")=0A=
> =0A=
> Reported-by: Ryan Harkin <ryan.harkin@linaro.org>=0A=
> Cc: "Horia Geant=E3" <horia.geanta@nxp.com>=0A=
> Cc: Aymen Sghaier <aymen.sghaier@nxp.com>=0A=
> Cc: Fabio Estevam <fabio.estevam@nxp.com>=0A=
> Cc: Peng Fan <peng.fan@nxp.com>=0A=
> Cc: "David S. Miller" <davem@davemloft.net>=0A=
> Cc: Lukas Auer <lukas.auer@aisec.fraunhofer.de>=0A=
> Cc: <stable@vger.kernel.org> # 4.12+=0A=
> Signed-off-by: Bryan O'Donoghue <pure.logic@nexus-software.ie>=0A=
> ---=0A=
>  drivers/crypto/caam/ctrl.c | 3 +++=0A=
>  1 file changed, 3 insertions(+)=0A=
> =0A=
> diff --git a/drivers/crypto/caam/ctrl.c b/drivers/crypto/caam/ctrl.c=0A=
> index 98986d3..0a1e96b 100644=0A=
> --- a/drivers/crypto/caam/ctrl.c=0A=
> +++ b/drivers/crypto/caam/ctrl.c=0A=
> @@ -704,7 +704,10 @@ static int caam_probe(struct platform_device *pdev)=
=0A=
>  					 ent_delay);=0A=
>  				kick_trng(pdev, ent_delay);=0A=
>  				ent_delay +=3D 400;=0A=
> +			} else if (ctrlpriv->rng4_sh_init && inst_handles) {=0A=
> +				ent_delay +=3D 400;=0A=
>  			}=0A=
If both RNG state handles are initialized before kernel runs, then=0A=
instantiate_rng() should be a no-op and return 0, which is enough to exit t=
he=0A=
loop: while ((ret =3D=3D -EAGAIN) && (ent_delay < RTSDCTL_ENT_DLY_MAX))=0A=
=0A=
If the loop cannot exit based on value of "ret" !=3D -EAGAIN, then it means=
=0A=
caam_probe() will eventually fail due to ret =3D=3D -EAGAIN:=0A=
	if (ret) {=0A=
		dev_err(dev, "failed to instantiate RNG");=0A=
		goto caam_remove;=0A=
	}=0A=
=0A=
Please provide more details, so that the root cause is found and fixed.=0A=
For e.g. what is the value of RDSTA (RNG DRNG Status register @0x6C0):=0A=
-before & after u-boot initializes RNG=0A=
-as seen by kernel during caam_probe()=0A=
Also provide related error messages displayed during boot.=0A=
=0A=
Thanks,=0A=
Horia=0A=
