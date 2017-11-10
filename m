From: =?iso-8859-2?Q?Horia_Geant=E3?= <horia.geanta@nxp.com>
Subject: Re: [PATCH 1/2] crypto: tcrypt - fix S/G table for test_aead_speed()
Date: Fri, 10 Nov 2017 06:37:22 +0000
Message-ID: <VI1PR0402MB3342FFECA75AFC5556AD085498540@VI1PR0402MB3342.eurprd04.prod.outlook.com>
References: <1507630920-9014-1-git-send-email-robert.baronescu@nxp.com>
 <20171103124157.GA8330@gondor.apana.org.au>
 <VI1PR0402MB33425E266579E4F3B375617498570@VI1PR0402MB3342.eurprd04.prod.outlook.com>
 <20171109222129.GB20824@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
Cc: Robert Baronescu <robert.baronescu@nxp.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ve1eur01on0043.outbound.protection.outlook.com ([104.47.1.43]:56262
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750793AbdKJGh0 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 10 Nov 2017 01:37:26 -0500
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 11/10/2017 12:21 AM, Herbert Xu wrote:=0A=
> On Thu, Nov 09, 2017 at 02:37:29PM +0000, Horia Geant=E3 wrote:=0A=
>>=0A=
>>>>  	sg_init_table(sg, np + 1);=0A=
>> sg_mark_end() marks sg[np].=0A=
>>=0A=
>>>> -	np--;=0A=
>>>> +	if (rem)=0A=
>>>> +		np--;=0A=
>>>>  	for (k =3D 0; k < np; k++)=0A=
>>>>  		sg_set_buf(&sg[k + 1], xbuf[k], PAGE_SIZE);=0A=
>> In case rem =3D=3D 0, last k value is np-1, thus sg[np-1+1] will be fill=
ed=0A=
>> here with xbuf[np-1].=0A=
> =0A=
> No, if rem =3D=3D 0, then the last k value is np-2.=0A=
> =0A=
Notice that np-- above the for loop is done conditionally, so in the for=0A=
loop k takes values in [0, np-1].=0A=
This means the for loop fills sg[1]...sg[np].=0A=
=0A=
Thanks,=0A=
Horia=0A=
