From: =?iso-8859-2?Q?Horia_Geant=E3?= <horia.geanta@nxp.com>
Subject: Re: crypto API - async semantics
Date: Thu, 12 Oct 2017 09:39:34 +0000
Message-ID: <VI1PR0402MB33421AE04D3D1115400CDD83984B0@VI1PR0402MB3342.eurprd04.prod.outlook.com>
References: <VI1PR0402MB3342DCCE076721CFD172C5FC984A0@VI1PR0402MB3342.eurprd04.prod.outlook.com>
 <20171012064334.GA26737@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-db5eur01on0050.outbound.protection.outlook.com ([104.47.2.50]:3680
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1756048AbdJLJjg (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 12 Oct 2017 05:39:36 -0400
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 10/12/2017 9:44 AM, Herbert Xu wrote:=0A=
> On Wed, Oct 11, 2017 at 12:36:11PM +0000, Horia Geant=E3 wrote:=0A=
>> Hi Herbert,=0A=
>>=0A=
>> I am evaluating whether ahash implementation in caam crypto driver=0A=
>> behaves correctly.=0A=
>> One thing I've noticed is that for each ahash tfm there is support for=
=0A=
>> at most two in-flight requests, and I would like to know whether this is=
=0A=
>> an issue or not.=0A=
> =0A=
> What do you mean by in-flight requests? If you're talking about=0A=
> requests that have not been completed (i.e., in progress) then=0A=
> that's fine.  Any new requests coming in can just be queued.=0A=
> =0A=
> If you're talking about requests that have not been finalised=0A=
> then that would be broken.  The API allows an arbitrary number=0A=
> of requests to ben present in an non-finalised state.  For example,=0A=
> given an IPsec SA, we may be processing any number of packets for=0A=
> it at once, with each coming from a different CPU.=0A=
> =0A=
Taking ascii art from crypto API docs:=0A=
=0A=
DATA -----------.=0A=
                v=0A=
 .init() -> .update() -> .final()      ! .update() might not be called=0A=
             ^    |         |            at all in this scenario.=0A=
             '----'         '---> HASH=0A=
=0A=
My question was referring to the case where multiple update() operations=0A=
are issued in parallel for the same request object.=0A=
For e.g. let's say a crypto API client wants to hash a 4GB file, and=0A=
does this by issuing update() repeatedly and performing=0A=
wait_for_completion() at the very end.=0A=
=0A=
>> In this context, could you please clarify whether your previous answer:=
=0A=
>> https://www.mail-archive.com/linux-crypto@vger.kernel.org/msg04029.html=
=0A=
>>> If any async operation returns EINPROGRESS, the client must not=0A=
>>> proceed until that operation has completed.=0A=
>> refers only to ahash operations OR to any crypto API async operation?=0A=
>> IIUC this would be equivalent to saying that crypto API allows only for=
=0A=
>> one in-flight request per tfm, correct?=0A=
> =0A=
> No that comment is referring to the request object.  The whole point=0A=
> of having a request object is to allow arbitrary number of hash=0A=
> operations in parallel given a single tfm.  The tfm is simply a=0A=
> representation of the key.  All hash state must be stored in the=0A=
> request.=0A=
> =0A=
Got it, thanks.=0A=
=0A=
Horia=0A=
