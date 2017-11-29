From: =?iso-8859-2?Q?Horia_Geant=E3?= <horia.geanta@nxp.com>
Subject: Re: [1/2] crypto: tcrypt - fix S/G table for test_aead_speed()
Date: Wed, 29 Nov 2017 08:57:33 +0000
Message-ID: <VI1PR0402MB3342C5A4ECEB14C785823073983B0@VI1PR0402MB3342.eurprd04.prod.outlook.com>
References: <1507630920-9014-1-git-send-email-robert.baronescu@nxp.com>
 <20171129062821.GA21594@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Tudor Ambarus <tudor.ambarus@microchip.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        Robert Baronescu <robert.baronescu@nxp.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-eopbgr30070.outbound.protection.outlook.com ([40.107.3.70]:12375
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751770AbdK2I5h (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 29 Nov 2017 03:57:37 -0500
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 11/29/2017 8:28 AM, Herbert Xu wrote:=0A=
> On Tue, Oct 10, 2017 at 01:21:59PM +0300, Robert Baronescu wrote:=0A=
>> In case buffer length is a multiple of PAGE_SIZE,=0A=
>> the S/G table is incorrectly generated.=0A=
>> Fix this by handling buflen =3D k * PAGE_SIZE separately.=0A=
>>=0A=
>> Signed-off-by: Robert Baronescu <robert.baronescu@nxp.com>=0A=
> =0A=
> Patch applied.  Thanks.=0A=
> =0A=
Thanks Herbert.=0A=
=0A=
Considering this fixes the crash reported by Tudor:=0A=
https://www.mail-archive.com/linux-crypto@vger.kernel.org/msg29172.html=0A=
I think it should be merged in this release cycle (v4.15).=0A=
=0A=
Horia=0A=
