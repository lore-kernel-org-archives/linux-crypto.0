From: =?iso-8859-2?Q?Horia_Geant=E3?= <horia.geanta@nxp.com>
Subject: Re: [PATCH 1/2] crypto: tcrypt - fix S/G table for test_aead_speed()
Date: Tue, 14 Nov 2017 10:41:00 +0000
Message-ID: <VI1PR0402MB3342AAD7C8F275F8EF91B77198280@VI1PR0402MB3342.eurprd04.prod.outlook.com>
References: <1507630920-9014-1-git-send-email-robert.baronescu@nxp.com>
 <20171103124157.GA8330@gondor.apana.org.au>
 <VI1PR0402MB33425E266579E4F3B375617498570@VI1PR0402MB3342.eurprd04.prod.outlook.com>
 <20171109222129.GB20824@gondor.apana.org.au>
 <VI1PR0402MB3342FFECA75AFC5556AD085498540@VI1PR0402MB3342.eurprd04.prod.outlook.com>
 <20171110074332.GB24384@gondor.apana.org.au>
 <VI1PR0402MB334241EA4B848E77AF8DFC2298540@VI1PR0402MB3342.eurprd04.prod.outlook.com>
 <20171110104145.GA25739@gondor.apana.org.au>
 <VI1PR0402MB33426CA117EDA1686C916D7B982A0@VI1PR0402MB3342.eurprd04.prod.outlook.com>
 <75766914-fdc1-5fb9-a571-82f86bcbe928@microchip.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
Cc: Robert Baronescu <robert.baronescu@nxp.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>
To: Tudor Ambarus <tudor.ambarus@microchip.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-eopbgr20089.outbound.protection.outlook.com ([40.107.2.89]:19680
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750828AbdKNKlF (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 14 Nov 2017 05:41:05 -0500
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 11/13/2017 8:28 PM, Tudor Ambarus wrote:=0A=
> Hi,=0A=
> =0A=
> On 11/12/2017 06:26 PM, Horia Geant=E3 wrote:=0A=
> =0A=
>> -sg[0] - (1 entry) reserved for associated data, filled outside=0A=
>> sg_init_aead()=0A=
> =0A=
> Let's fill the sg[0] with aad inside sg_init_aead()!=0A=
> =0A=
This could be done, however I would not mix fixes with improvements.=0A=
=0A=
Thanks,=0A=
Horia=0A=
