From: Laurentiu Tudor <laurentiu.tudor@nxp.com>
Subject: RE: [7/7] crypto: caam/qi - add ablkcipher and authenc algorithms
Date: Fri, 7 Apr 2017 14:00:58 +0000
Message-ID: <VI1PR0401MB1856407F4A75878EA66AF51EEC0C0@VI1PR0401MB1856.eurprd04.prod.outlook.com>
References: <20170317100602.2837-8-horia.geanta@nxp.com>
 <87vaqkvk6c.fsf@concordia.ellerman.id.au> <58E39F90.6050408@nxp.com>
 <87lgrftbgl.fsf@concordia.ellerman.id.au> <58E4D9C3.4070406@nxp.com>
 <87inmggxp7.fsf@concordia.ellerman.id.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
Cc: Claudiu Manoil <claudiu.manoil@nxp.com>,
        Cristian Stoica <cristian.stoica@nxp.com>,
        Dan Douglass <dan.douglass@nxp.com>,
        "linux-arm-kernel@lists.infradead.org"
        <linux-arm-kernel@lists.infradead.org>,
        Vakul Garg <vakul.garg@nxp.com>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexandru Porosanu <alexandru.porosanu@nxp.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: Michael Ellerman <mpe@ellerman.id.au>,
        =?iso-8859-2?Q?Horia_Geant=E3?= <horia.geanta@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Scott Wood <oss@buserror.net>, Roy Pledge <roy.pledge@nxp.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ve1eur01on0080.outbound.protection.outlook.com ([104.47.1.80]:9008
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751759AbdDGOBr (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 7 Apr 2017 10:01:47 -0400
In-Reply-To: <87inmggxp7.fsf@concordia.ellerman.id.au>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>



-----Original Message-----
From: Michael Ellerman [mailto:mpe@ellerman.id.au]=20
Sent: Friday, April 07, 2017 4:22 PM
To: Laurentiu Tudor <laurentiu.tudor@nxp.com>; Horia Geant=E3 <horia.geanta=
@nxp.com>; Herbert Xu <herbert@gondor.apana.org.au>; Scott Wood <oss@buserr=
or.net>; Roy Pledge <roy.pledge@nxp.com>
Cc: Claudiu Manoil <claudiu.manoil@nxp.com>; Cristian Stoica <cristian.stoi=
ca@nxp.com>; Dan Douglass <dan.douglass@nxp.com>; linux-arm-kernel@lists.in=
fradead.org; Vakul Garg <vakul.garg@nxp.com>; linuxppc-dev@lists.ozlabs.org=
; David S. Miller <davem@davemloft.net>; Alexandru Porosanu <alexandru.poro=
sanu@nxp.com>; linux-crypto@vger.kernel.org
Subject: Re: [7/7] crypto: caam/qi - add ablkcipher and authenc algorithms
Importance: High

Laurentiu Tudor <laurentiu.tudor@nxp.com> writes:

> On 04/05/2017 01:06 PM, Michael Ellerman wrote:
>> Laurentiu Tudor <laurentiu.tudor@nxp.com> writes:
>>
>>> Hi Michael,
>>>
>>> Just a couple of basic things to check:
>>>    - was the dtb updated to the newest?
>>
>> Possibly not, it's an automated build/boot, I'll have to check what=20
>> it does with the dtb.
>>
>>>    - is the qman node present? This should be easily visible in=20
>>> /proc/device-tree/soc@ffe000000/qman@318000.
>>
>> No it's not there.
>>
>> That's running linux-next with:
>>
>> CONFIG_CRYPTO_DEV_FSL_CAAM_CRYPTO_API_QI=3Dn
>>
>>
>> Does that mean I didn't update the device tree?
>
> I think so. Also, I just checked that the node is actually there by=20
> compiling p5020ds.dts and then decompiling the dtb.

> OK, I'll make sure I update the DTB.
>=20
> It will still be good if the code was a bit more robust about the qman be=
ing missing.

Totally agree. We should handle this error condition.

---
Thanks & Best Regards, Laurentiu
