From: Horia Geanta <horia.geanta@nxp.com>
Subject: Re: [PATCH] crypto: caam/qi2 - add CONFIG_NETDEVICES dependency
Date: Wed, 26 Sep 2018 13:07:21 +0000
Message-ID: <VI1PR0402MB3485AB14555EE65B951F787998150@VI1PR0402MB3485.eurprd04.prod.outlook.com>
References: <20180926130045.2295764-1-arnd@arndb.de>
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

On 9/26/2018 4:01 PM, Arnd Bergmann wrote:=0A=
> This driver implements a (part of a) network driver, and fails to=0A=
> build if we have turned off networking support:=0A=
> =0A=
> drivers/crypto/caam/caamalg_qi2.o: In function `dpaa2_caam_fqdan_cb':=0A=
> caamalg_qi2.c:(.text+0x577c): undefined reference to `napi_schedule_prep'=
=0A=
> caamalg_qi2.c:(.text+0x578c): undefined reference to `__napi_schedule_irq=
off'=0A=
> drivers/crypto/caam/caamalg_qi2.o: In function `dpaa2_dpseci_poll':=0A=
> caamalg_qi2.c:(.text+0x59b8): undefined reference to `napi_complete_done'=
=0A=
> drivers/crypto/caam/caamalg_qi2.o: In function `dpaa2_caam_remove':=0A=
> caamalg_qi2.c:(.text.unlikely+0x4e0): undefined reference to `napi_disabl=
e'=0A=
> caamalg_qi2.c:(.text.unlikely+0x4e8): undefined reference to `netif_napi_=
del'=0A=
> drivers/crypto/caam/caamalg_qi2.o: In function `dpaa2_dpseci_setup':=0A=
> caamalg_qi2.c:(.text.unlikely+0xc98): undefined reference to `netif_napi_=
add'=0A=
> =0A=
> From what I can tell, CONFIG_NETDEVICES is the correct dependency here,=
=0A=
> and adding it fixes the randconfig failures.=0A=
> =0A=
> Fixes: 8d818c105501 ("crypto: caam/qi2 - add DPAA2-CAAM driver")=0A=
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>=0A=
Acked-by: Horia Geant=E3 <horia.geanta@nxp.com>=0A=
=0A=
Thanks,=0A=
Horia=0A=
