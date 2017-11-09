From: =?iso-8859-2?Q?Horia_Geant=E3?= <horia.geanta@nxp.com>
Subject: Re: [PATCH 1/2] crypto: tcrypt - fix S/G table for test_aead_speed()
Date: Thu, 9 Nov 2017 14:37:29 +0000
Message-ID: <VI1PR0402MB33425E266579E4F3B375617498570@VI1PR0402MB3342.eurprd04.prod.outlook.com>
References: <1507630920-9014-1-git-send-email-robert.baronescu@nxp.com>
 <20171103124157.GA8330@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        Robert Baronescu <robert.baronescu@nxp.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ve1eur01on0040.outbound.protection.outlook.com ([104.47.1.40]:25344
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753846AbdKIOhc (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 9 Nov 2017 09:37:32 -0500
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 11/3/2017 2:42 PM, Herbert Xu wrote:=0A=
> On Tue, Oct 10, 2017 at 01:21:59PM +0300, Robert Baronescu wrote:=0A=
>> In case buffer length is a multiple of PAGE_SIZE,=0A=
>> the S/G table is incorrectly generated.=0A=
>> Fix this by handling buflen =3D k * PAGE_SIZE separately.=0A=
>>=0A=
>> Signed-off-by: Robert Baronescu <robert.baronescu@nxp.com>=0A=
>> ---=0A=
>>  crypto/tcrypt.c | 6 ++++--=0A=
>>  1 file changed, 4 insertions(+), 2 deletions(-)=0A=
>>=0A=
>> diff --git a/crypto/tcrypt.c b/crypto/tcrypt.c=0A=
>> index 0022a18..bd9b66c 100644=0A=
>> --- a/crypto/tcrypt.c=0A=
>> +++ b/crypto/tcrypt.c=0A=
>> @@ -221,11 +221,13 @@ static void sg_init_aead(struct scatterlist *sg, c=
har *xbuf[XBUFSIZE],=0A=
>>  	}=0A=
>>  =0A=
>>  	sg_init_table(sg, np + 1);=0A=
sg_mark_end() marks sg[np].=0A=
=0A=
>> -	np--;=0A=
>> +	if (rem)=0A=
>> +		np--;=0A=
>>  	for (k =3D 0; k < np; k++)=0A=
>>  		sg_set_buf(&sg[k + 1], xbuf[k], PAGE_SIZE);=0A=
In case rem =3D=3D 0, last k value is np-1, thus sg[np-1+1] will be filled=
=0A=
here with xbuf[np-1].=0A=
=0A=
>>  =0A=
>> -	sg_set_buf(&sg[k + 1], xbuf[k], rem);=0A=
>> +	if (rem)=0A=
>> +		sg_set_buf(&sg[k + 1], xbuf[k], rem);=0A=
In case rem !=3D0, sg[np] will be filled here with xbuf[np-1].=0A=
=0A=
> =0A=
> Sorry but I think this is still buggy because you have not moved the=0A=
> end-of-table marking in the rem =3D=3D 0 case.=0A=
IIUC this is correct, see above comments.=0A=
Could you please take a look again?=0A=
=0A=
Thanks,=0A=
Horia=0A=
