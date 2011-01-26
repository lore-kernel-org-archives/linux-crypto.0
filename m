From: Hamid Nassiby <h.nassiby@gmail.com>
Subject: Re: Fwd: crypto accelerator driver problems
Date: Wed, 26 Jan 2011 11:20:22 +0330
Message-ID: <AANLkTi=m0jVWSqR1FNX9r9HH32LbA0aWJxSQtLd_VszW@mail.gmail.com>
References: <AANLkTinGGsjgBKD1LqhL2u4DOU_XrACK4D67nHfPnL5e@mail.gmail.com>
 <20101230211900.GA22742@gondor.apana.org.au> <AANLkTinm8uy34ni_4XFLZTcdkndy0B_jeFXag0onxA66@mail.gmail.com>
 <AANLkTin8au=98mmfsaJjOSyJNibk3foZWihj6EGTGWK-@mail.gmail.com> <20110126070939.GA18150@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:61295 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751802Ab1AZHux convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 26 Jan 2011 02:50:53 -0500
Received: by gxk9 with SMTP id 9so30740gxk.19
        for <linux-crypto@vger.kernel.org>; Tue, 25 Jan 2011 23:50:53 -0800 (PST)
In-Reply-To: <20110126070939.GA18150@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Jan 26, 2011 at 10:39 AM, Herbert Xu
<herbert@gondor.apana.org.au> wrote:
> On Wed, Jan 26, 2011 at 10:26:33AM +0330, Hamid Nassiby wrote:
>>
>> As you know, I posted my problem again to crypto list and no one ans=
wered.
>> Now I
>> emphasize one aspect of the problem as a concept related to IPSec pr=
otocol,
>> free
>> of my problem's nature, and I hope to get some guidelines at this ti=
me. The
>> question is as following:
>> If IPSec delivers IP packets to hardware crypto accelerator in seque=
ntial
>> manner
>> (e.g, packets in order: 1, 2, 3, ..., 36, 37, 38,...) and crypto acc=
elerator
>> possibly returns back packets out of entering order to IPSec (e.g, p=
acket
>> 37 is returned back before the packet 36 to IPSec, so the order of p=
ackets
>> is
>> not the same before entering crypto accelerator and after exiting it=
); Is it
>> possible to rise any problem here?
>
> We do not allow such reordering. =C2=A0All crypto drivers must ensure
> ordering within a single tfm. =C2=A0Between different tfms there is n=
o
> ordering requirement.
>
> Cheers,
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
>


Do you mean that different IP packets fit into one single Block Cipher =
tfm?
Would you please explain expansively?

Thanks a lot,
