From: =?iso-8859-2?Q?Horia_Geant=E3?= <horia.geanta@nxp.com>
Subject: Re: crypto API - async semantics
Date: Thu, 12 Oct 2017 10:12:06 +0000
Message-ID: <VI1PR0402MB33427ED73E8D45B72E07EDA3984B0@VI1PR0402MB3342.eurprd04.prod.outlook.com>
References: <VI1PR0402MB3342DCCE076721CFD172C5FC984A0@VI1PR0402MB3342.eurprd04.prod.outlook.com>
 <20171012064334.GA26737@gondor.apana.org.au>
 <VI1PR0402MB33421AE04D3D1115400CDD83984B0@VI1PR0402MB3342.eurprd04.prod.outlook.com>
 <20171012094836.GA29179@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-db5eur01on0080.outbound.protection.outlook.com ([104.47.2.80]:26464
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751140AbdJLKML (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 12 Oct 2017 06:12:11 -0400
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 10/12/2017 12:49 PM, Herbert Xu wrote:=0A=
> On Thu, Oct 12, 2017 at 09:39:34AM +0000, Horia Geant=E3 wrote:=0A=
>>=0A=
>> Taking ascii art from crypto API docs:=0A=
>>=0A=
>> DATA -----------.=0A=
>>                 v=0A=
>>  .init() -> .update() -> .final()      ! .update() might not be called=
=0A=
>>              ^    |         |            at all in this scenario.=0A=
>>              '----'         '---> HASH=0A=
>>=0A=
>> My question was referring to the case where multiple update() operations=
=0A=
>> are issued in parallel for the same request object.=0A=
>> For e.g. let's say a crypto API client wants to hash a 4GB file, and=0A=
>> does this by issuing update() repeatedly and performing=0A=
>> wait_for_completion() at the very end.=0A=
> =0A=
> That is most certainly not legal.  Is dm-crypt doing that?=0A=
> =0A=
dm-crypt is issuing requests (aead / skcipher) in parallel, however a=0A=
new request object is allocated each time, which seems legit.=0A=
=0A=
My confusion was due to mixing parallelism at different levels:=0A=
-at request object level - issuing multiple requests for the same=0A=
request object (ahash update() case)=0A=
-at tfm object level - issuing multiple requests for different request=0A=
objects (dm-crypt case)=0A=
=0A=
As you pointed out, the first is not legal, while the latter is=0A=
perfectly fine.=0A=
=0A=
Thanks,=0A=
Horia=0A=
