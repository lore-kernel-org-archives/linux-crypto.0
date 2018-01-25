From: =?iso-8859-2?Q?Horia_Geant=E3?= <horia.geanta@nxp.com>
Subject: Re: [RESEND PATCH 1/6] crypto: caam: Fix null dereference at error
 path
Date: Thu, 25 Jan 2018 17:09:42 +0000
Message-ID: <VI1PR0402MB33427BA4CB6A5D768E35CA9498E10@VI1PR0402MB3342.eurprd04.prod.outlook.com>
References: <1516805435-15034-1-git-send-email-pure.logic@nexus-software.ie>
 <1516805435-15034-2-git-send-email-pure.logic@nexus-software.ie>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
Cc: Fabio Estevam <fabio.estevam@nxp.com>, Peng Fan <peng.fan@nxp.com>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "lukas.auer@aisec.fraunhofer.de" <lukas.auer@aisec.fraunhofer.de>,
        "rui.silva@linaro.org" <rui.silva@linaro.org>,
        "ryan.harkin@linaro.org" <ryan.harkin@linaro.org>
To: Bryan O'Donoghue <pure.logic@nexus-software.ie>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-db5eur01on0083.outbound.protection.outlook.com ([104.47.2.83]:24992
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750992AbeAYRJq (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 25 Jan 2018 12:09:46 -0500
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 1/24/2018 4:50 PM, Bryan O'Donoghue wrote:=0A=
> From: Rui Miguel Silva <rui.silva@linaro.org>=0A=
> =0A=
> caam_remove already removes the debugfs entry, so we need to remove the o=
ne=0A=
> immediately before calling caam_remove.=0A=
> =0A=
> This fix a NULL dereference at error paths is caam_probe fail.=0A=
> =0A=
> [bod: changed name prefix to "crypto: caam: Fix .."]=0A=
> [bod: added Fixes tag]=0A=
> =0A=
> Fixes: 67c2315def06 ("crypto: caam - add Queue Interface (QI) backend=0A=
> support")=0A=
Cc: <stable@vger.kernel.org> # 4.12+=0A=
=0A=
> =0A=
> Tested-by: Ryan Harkin <ryan.harkin@linaro.org>=0A=
> Signed-off-by: Rui Miguel Silva <rui.silva@linaro.org>=0A=
> Cc: "Horia Geant=E3" <horia.geanta@nxp.com>=0A=
> Cc: Aymen Sghaier <aymen.sghaier@nxp.com>=0A=
> Cc: Fabio Estevam <fabio.estevam@nxp.com>=0A=
> Cc: Peng Fan <peng.fan@nxp.com>=0A=
> Cc: Herbert Xu <herbert@gondor.apana.org.au>=0A=
> Cc: "David S. Miller" <davem@davemloft.net>=0A=
> Cc: Lukas Auer <lukas.auer@aisec.fraunhofer.de>=0A=
> Signed-off-by: Bryan O'Donoghue <pure.logic@nexus-software.ie>=0A=
Reviewed-by: Horia Geant=E3 <horia.geanta@nxp.com>=0A=
=0A=
Thanks,=0A=
Horia=0A=
