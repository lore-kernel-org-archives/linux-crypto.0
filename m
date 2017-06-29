From: =?iso-8859-2?Q?Horia_Geant=E3?= <horia.geanta@nxp.com>
Subject: Re: [PATCH] crypto: caam - properly set IV after {en,de}crypt
Date: Thu, 29 Jun 2017 10:19:01 +0000
Message-ID: <VI1PR0401MB2591C51C446CFA129B50022298D20@VI1PR0401MB2591.eurprd04.prod.outlook.com>
References: <20170602122446.2427-1-david@sigma-star.at>
 <20170628132710.97278-1-david@sigma-star.at>
 <VI1PR0401MB2591AE2CA996495656C797B398DD0@VI1PR0401MB2591.eurprd04.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
Cc: "richard@sigma-star.at" <richard@sigma-star.at>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
To: David Gstir <david@sigma-star.at>,
        Dan Douglass <dan.douglass@nxp.com>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ve1eur01on0070.outbound.protection.outlook.com ([104.47.1.70]:3456
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751595AbdF2KTH (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 29 Jun 2017 06:19:07 -0400
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 6/28/2017 4:42 PM, Horia Geant=E3 wrote:=0A=
> On 6/28/2017 4:27 PM, David Gstir wrote:=0A=
>> Certain cipher modes like CTS expect the IV (req->info) of=0A=
>> ablkcipher_request (or equivalently req->iv of skcipher_request) to=0A=
>> contain the last ciphertext block when the {en,de}crypt operation is don=
e.=0A=
>> This is currently not the case for the CAAM driver which in turn breaks=
=0A=
>> e.g. cts(cbc(aes)) when the CAAM driver is enabled.=0A=
>>=0A=
>> This patch fixes the CAAM driver to properly set the IV after the=0A=
>> {en,de}crypt operation of ablkcipher finishes.=0A=
>>=0A=
>> This issue was revealed by the changes in the SW CTS mode in commit=0A=
>> 0605c41cc53ca ("crypto: cts - Convert to skcipher")=0A=
>>=0A=
>> Cc: <stable@vger.kernel.org> # 4.8+=0A=
>> Signed-off-by: David Gstir <david@sigma-star.at>=0A=
> Reviewed-by: Horia Geant=E3 <horia.geanta@nxp.com>=0A=
> =0A=
Btw, instead of updating the IV in SW, CAAM engine could be programmed=0A=
to do it - by saving the Context Register of the AES accelerator.=0A=
=0A=
Unfortunately this would require changes in quite a few places: shared=0A=
descriptor, HW S/G generation logic, IV dma (un)mapping and maybe others.=
=0A=
=0A=
So it's better to have this fix now (which, considering size, is=0A=
appropriate for -stable) and later, if needed, offload IV updating in HW.=
=0A=
=0A=
Regards,=0A=
Horia=0A=
