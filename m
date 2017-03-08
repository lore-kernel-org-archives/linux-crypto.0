From: =?iso-8859-2?Q?Horia_Geant=E3?= <horia.geanta@nxp.com>
Subject: Re: [PATCH] crypto: testmgr - don't DMA map IV from stack in
 test_skcipher()
Date: Wed, 8 Mar 2017 13:04:14 +0000
Message-ID: <DB4PR04MB08477C25A41104FA6D879D07982E0@DB4PR04MB0847.eurprd04.prod.outlook.com>
References: <1484290756-20868-1-git-send-email-horia.geanta@nxp.com>
 <20170113084620.GF22022@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
Cc: "David S. Miller" <davem@davemloft.net>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-db5eur01on0076.outbound.protection.outlook.com ([104.47.2.76]:40800
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753141AbdCHNEW (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 8 Mar 2017 08:04:22 -0500
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 1/13/2017 10:46 AM, Herbert Xu wrote:=0A=
> On Fri, Jan 13, 2017 at 08:59:16AM +0200, Horia Geant=E3 wrote:=0A=
>> Fix the "DMA-API: device driver maps memory from stack" warning=0A=
>> generated when crypto accelerators map the IV.=0A=
>>=0A=
>> Signed-off-by: Horia Geant=E3 <horia.geanta@nxp.com>=0A=
> =0A=
> Hmm, the IV comes in as a pointer.  So you should not assume that=0A=
> it can be DMAed at all.=0A=
> =0A=
That's correct, thanks for pointing it out.=0A=
=0A=
> Perhaps we should change the API so that it gets passed in as an=0A=
> SG list.=0A=
> =0A=
Since changing the API and converting the users looks pretty lengthy,=0A=
would it be acceptable to fix tcrypt for now?=0A=
Indeed, I've missed updating test_skcipher_speed, I can add this in v2.=0A=
=0A=
Thanks,=0A=
Horia=0A=
=0A=
