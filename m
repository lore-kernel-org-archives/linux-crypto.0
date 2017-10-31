From: =?iso-8859-2?Q?Horia_Geant=E3?= <horia.geanta@nxp.com>
Subject: Re: [PATCH] crypto: testmgr: don't allocate IV on stack
Date: Tue, 31 Oct 2017 09:05:57 +0000
Message-ID: <VI1PR0402MB3342C4C9E798F9973FFDB6A6985E0@VI1PR0402MB3342.eurprd04.prod.outlook.com>
References: <1509436586-17500-1-git-send-email-gilad@benyossef.com>
 <20171031075925.GA26147@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
Cc: "David S. Miller" <davem@davemloft.net>,
        Ofir Drang <ofir.drang@arm.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        Gilad Ben-Yossef <gilad@benyossef.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-eopbgr40066.outbound.protection.outlook.com ([40.107.4.66]:36727
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750848AbdJaJGB (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 31 Oct 2017 05:06:01 -0400
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 10/31/2017 10:00 AM, Herbert Xu wrote:=0A=
> On Tue, Oct 31, 2017 at 07:56:26AM +0000, Gilad Ben-Yossef wrote:=0A=
>> The IV was allocated on the stack in testmgr skcipher tests.=0A=
>> Since HW based tfm providers need to DMA the IV to the HW,=0A=
>> this leads to problems and is detected by the DMA-API debug=0A=
>> code.=0A=
>>=0A=
>> Fix it by allocating the IV using kmalloc instead.=0A=
>>=0A=
>> Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>=0A=
Gilad, you're not the only one who bumped into this issue:=0A=
https://www.mail-archive.com/linux-crypto@vger.kernel.org/msg23074.html=0A=
not to mention previous patches that have been accepted:=0A=
96692a7305c4 crypto: tcrypt - do not allocate iv on stack for aead speed=0A=
tests=0A=
9bac019dad80 crypto: testmgr - Fix DMA-API warning=0A=
and so on.=0A=
=0A=
> =0A=
> The driver that is mapping the IV directly should be fixed instead.=0A=
> Only input that is given in the form of SG lists can be mapped.=0A=
> Everything else should be copied if they need to go over DMA.=0A=
> =0A=
Herbert, wouldn't it make more sense to follow your previous suggestion:=0A=
"Perhaps we should change the API so that it gets passed in as an=0A=
SG list."=0A=
https://www.mail-archive.com/linux-crypto@vger.kernel.org/msg23082.html=0A=
=0A=
Thanks,=0A=
Horia=0A=
