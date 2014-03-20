From: =?UTF-8?B?SG9yaWEgR2VhbnTEgw==?= <horia.geanta@freescale.com>
Subject: Re: [PATCH cryptodev 1/4] crypto: caam - remove error propagation
 handling
Date: Thu, 20 Mar 2014 11:44:02 +0200
Message-ID: <532AB862.3070703@freescale.com>
References: <1394812012-13714-1-git-send-email-horia.geanta@freescale.com> <201403171923.11855.marex@denx.de> <5329D31C.6030807@freescale.com> <201403192001.56356.marex@denx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	<linux-crypto@vger.kernel.org>
To: Marek Vasut <marex@denx.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ch1ehsobe005.messaging.microsoft.com ([216.32.181.185]:40230
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757087AbaCTJoT convert rfc822-to-8bit
	(ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 20 Mar 2014 05:44:19 -0400
In-Reply-To: <201403192001.56356.marex@denx.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 3/19/2014 9:01 PM, Marek Vasut wrote:
> On Wednesday, March 19, 2014 at 06:25:48 PM, Horia Geant=C4=83 wrote:
>> On 3/17/2014 8:23 PM, Marek Vasut wrote:
>>> On Friday, March 14, 2014 at 04:46:49 PM, Horia Geanta wrote:
>>>> Commit 61bb86bba169507a5f223b94b9176c32c84b4721
>>>> ("crypto: caam - set descriptor sharing type to SERIAL")
>>>> changed the descriptor sharing mode from SHARE_WAIT to SHARE_SERIA=
L.
>>>>
>>>> All descriptor commands that handle the "ok to share" and
>>>> "error propagation" settings should also go away, since they have =
no
>>>> meaning for SHARE_SERIAL.
>>>
>>> [...]
>>>
>>>> @@ -253,7 +236,7 @@ static int aead_set_sh_desc(struct crypto_aead
>>>> *aead)
>>>>
>>>>    	/* assoclen + cryptlen =3D seqinlen - ivsize */
>>>>    	append_math_sub_imm_u32(desc, REG2, SEQINLEN, IMM, tfm->ivsize=
);
>>>>
>>>> -	/* assoclen + cryptlen =3D (assoclen + cryptlen) - cryptlen */
>>>> +	/* assoclen =3D (assoclen + cryptlen) - cryptlen */
>>>
>>> This comment basically says 'x =3D x' , but it doesn't explain anyt=
hing to
>>> uninformed observer. Can you fix such comments please ?
>>
>> The line under the comment is:
>> append_math_sub(desc, VARSEQINLEN, REG2, REG3, CAAM_CMD_SZ);
>>
>> which translates to:
>> VARSEQINLEN =3D REG2 - REG3
>>
>> The comment basically says that VARSEQINLEN gets assoclen by
>> substracting REG3 =3D cryptlen from REG2 =3D assoclen + cryptlen.
>>
>> If you still think this is "cryptic", that's perfectly fine - I'll
>> respin the patch.
>
> OK, I don't get it anyway. But that's OK, I am sure the next Marek th=
at comes
> across this code won't get it either. So I'd suggest you produce a pa=
tch
> afterwards, which cleans up the documentation ugliness in this driver=
=2E Would
> that work for you?

VARSEQINLEN, REG2, REG3 are registers of the crypto engine.
aead_set_sh_desc() is meant to generate microprograms / descriptors to=20
be executed by the engine.

Due to inherent complexity of the engine, it's difficult to explain=20
these microprograms in a few lines of comments.
Having a basic understanding of the HW block is mandatory.

I'll consider your suggestion of improving documentation in a subsequen=
t=20
patch.

>
> Best regards,
> Marek Vasut
>
>
>
>
