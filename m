From: =?iso-8859-2?Q?Horia_Geant=E3?= <horia.geanta@nxp.com>
Subject: Re: [PATCH v3 2/5] crypto: caam: Fix endless loop when RNG is already
 initialized
Date: Mon, 5 Feb 2018 08:45:59 +0000
Message-ID: <VI1PR0402MB3342899B009D1A6CC0569CFE98FE0@VI1PR0402MB3342.eurprd04.prod.outlook.com>
References: <1517364040-27607-1-git-send-email-pure.logic@nexus-software.ie>
 <1517364040-27607-3-git-send-email-pure.logic@nexus-software.ie>
 <VI1PR0402MB334297558BB1984131546B1D98FA0@VI1PR0402MB3342.eurprd04.prod.outlook.com>
 <78ad6a62-190c-e4fe-dd23-e1d058f9bbb2@nexus-software.ie>
 <1517576063.2002.19.camel@aisec.fraunhofer.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
Cc: Peng Fan <peng.fan@nxp.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "ryan.harkin@linaro.org" <ryan.harkin@linaro.org>,
        Fabio Estevam <fabio.estevam@nxp.com>,
        "rui.silva@linaro.org" <rui.silva@linaro.org>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>
To: "Auer, Lukas" <lukas.auer@aisec.fraunhofer.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        "pure.logic@nexus-software.ie" <pure.logic@nexus-software.ie>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ve1eur01on0051.outbound.protection.outlook.com ([104.47.1.51]:61547
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752195AbeBEIqE (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 5 Feb 2018 03:46:04 -0500
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 2/2/2018 2:54 PM, Auer, Lukas wrote:=0A=
> On Fri, 2018-02-02 at 11:20 +0000, Bryan O'Donoghue wrote:=0A=
>> On 01/02/18 12:16, Horia Geant=E3 wrote:=0A=
>>> If the loop cannot exit based on value of "ret" !=3D -EAGAIN, then it=
=0A=
>>> means=0A=
>>> caam_probe() will eventually fail due to ret =3D=3D -EAGAIN:=0A=
>>> 	if (ret) {=0A=
>>> 		dev_err(dev, "failed to instantiate RNG");=0A=
>>> 		goto caam_remove;=0A=
>>> 	}=0A=
>>=0A=
>> For me it's an endless loop applying the first two=0A=
>>=0A=
>> https://patchwork.ozlabs.org/patch/866460/=0A=
>> https://patchwork.ozlabs.org/patch/866462/=0A=
>>=0A=
>> but not this one=0A=
>>=0A=
>> https://patchwork.ozlabs.org/patch/865890/=0A=
>>=0A=
[snip]=0A=
> =0A=
> I think the problem lies in the instantiate_rng() function. If the=0A=
> driver is unable to acquire DEC0 it'll return -ENODEV. This should=0A=
> terminate the while loop in the probe function. However, the return=0A=
> value is never checked and is instead overwritten with -EAGAIN, causing=
=0A=
> the endless loop.=0A=
> =0A=
> This problem only occurs if u-boot instantiates only one of the state=0A=
> handles (ent_delay doesn't get incremented) and the kernel runs in non-=
=0A=
> secure mode (DEC0 can't get acquired). Instantiating all state handles=0A=
> in u-boot therefore fixes this problem. In addition, the return value=0A=
> in instantiate_rng() should be handled correctly by including=0A=
> =0A=
> if (ret)=0A=
> 	break;=0A=
> =0A=
> right after "ret =3D run_descriptor_deco0(ctrldev, desc, &status);".=0A=
> =0A=
Indeed, the error path is incorrect and should be fixed as you mentioned.=
=0A=
I will send a patch replacing this one.=0A=
Note that this fixes only the error path, meaning caam_probe() won't go int=
o an=0A=
endless loop and instead will return -ENODEV, due to being unable to acquir=
e=0A=
control of DECO0.=0A=
=0A=
There are still a few hurdles to cross for CAAM to work in a TZ environment=
.=0A=
=0A=
For e.g. could you please check / confirm whether DECO0MIDR (DECO0 MID regi=
sters=0A=
@0xA0, @0xA4) are set such that Linux kernel is allowed to r/w DECO0-relate=
d=0A=
registers?=0A=
=0A=
Thanks,=0A=
Horia=0A=
