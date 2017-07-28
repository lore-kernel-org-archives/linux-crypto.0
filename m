From: =?iso-8859-2?Q?Horia_Geant=E3?= <horia.geanta@nxp.com>
Subject: Re: [RFC PATCH] crypto: caam - convert from ablkcipher -> skcipher
Date: Fri, 28 Jul 2017 06:46:03 +0000
Message-ID: <VI1PR0401MB2591F6D4CAD871490564A2EE98BF0@VI1PR0401MB2591.eurprd04.prod.outlook.com>
References: <1472479884-1887-1-git-send-email-horia.geanta@nxp.com>
 <20160901101257.GA3362@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-eopbgr50089.outbound.protection.outlook.com ([40.107.5.89]:13716
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751138AbdG1GqG (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 28 Jul 2017 02:46:06 -0400
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 9/1/2016 1:13 PM, Herbert Xu wrote:=0A=
> On Mon, Aug 29, 2016 at 05:11:24PM +0300, Horia Geant=E3 wrote:=0A=
>> (a)blkcipher is being deprecated in favcur of skcipher.=0A=
>> The main difference is that IV generation is moved out=0A=
>> of crypto algorithms.=0A=
>>=0A=
>> Signed-off-by: Horia Geant=E3 <horia.geanta@nxp.com>=0A=
> =0A=
> Thanks! Please hold on though because I'm not quite done with=0A=
> the driver-side skcipher interface yet.=0A=
> =0A=
I see a mixture of ablkcipher and skcipher usage in crypto drivers.=0A=
=0A=
If I am to add a new driver, would it be possible and/or advisable to=0A=
use skcipher?=0A=
=0A=
Thanks,=0A=
Horia=0A=
