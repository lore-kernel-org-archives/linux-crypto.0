From: =?iso-8859-2?Q?Horia_Geant=E3?= <horia.geanta@nxp.com>
Subject: Re: [PATCH 1/2] crypto: tcrypt - fix S/G table for test_aead_speed()
Date: Tue, 14 Nov 2017 10:02:54 +0000
Message-ID: <VI1PR0402MB334266444B0B9A93141F894798280@VI1PR0402MB3342.eurprd04.prod.outlook.com>
References: <1507630920-9014-1-git-send-email-robert.baronescu@nxp.com>
 <c0079a24-d338-76f0-2957-1d3727e966fc@microchip.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>
To: Tudor Ambarus <tudor.ambarus@microchip.com>,
        Robert Baronescu <robert.baronescu@nxp.com>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-db5eur01on0053.outbound.protection.outlook.com ([104.47.2.53]:19898
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752092AbdKNKC6 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 14 Nov 2017 05:02:58 -0500
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 11/13/2017 8:24 PM, Tudor Ambarus wrote:=0A=
> Hi,=0A=
> =0A=
> On 10/10/2017 01:21 PM, Robert Baronescu wrote:=0A=
>> In case buffer length is a multiple of PAGE_SIZE,=0A=
>> the S/G table is incorrectly generated.=0A=
>> Fix this by handling buflen =3D k * PAGE_SIZE separately.=0A=
>>=0A=
>> Signed-off-by: Robert Baronescu <robert.baronescu@nxp.com>=0A=
>> ---=0A=
>>   crypto/tcrypt.c | 6 ++++--=0A=
>>   1 file changed, 4 insertions(+), 2 deletions(-)=0A=
> =0A=
> This patch fixes the segmentation fault listed below. The NULL=0A=
> dereference can be seen starting with:=0A=
> 7aacbfc crypto: tcrypt - fix buffer lengths in test_aead_speed()=0A=
> =0A=
Right, the order of the two fixes is unfortunate in the sense that first=0A=
fix (commit 7aacbfc) uncovers the issue you mention.=0A=
=0A=
Thanks,=0A=
Horia=0A=
=0A=
