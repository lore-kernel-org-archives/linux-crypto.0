From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH v2 09/11] arm64/crypto: add voluntary preemption to Crypto
 Extensions SHA1
Date: Thu, 15 May 2014 15:10:20 -0700
Message-ID: <CAKv+Gu_Tupu8jJX+6hRx_LOM0y05A5+MPXndzSKRNYQcG-yAvw@mail.gmail.com>
References: <1400091451-9117-1-git-send-email-ard.biesheuvel@linaro.org>
	<1400091451-9117-10-git-send-email-ard.biesheuvel@linaro.org>
	<20140515172458.GE1499@arm.com>
	<CAKv+Gu-9P+vDPnvr2Cz4Bcw5=5SuEMw-xFxLM4=SoF65ESvhcQ@mail.gmail.com>
	<E28B9BA9-468D-45BD-A479-5D9289616798@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "jussi.kivilinna@iki.fi" <jussi.kivilinna@iki.fi>,
	"herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-lb0-f173.google.com ([209.85.217.173]:49052 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753167AbaEOWKW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 15 May 2014 18:10:22 -0400
Received: by mail-lb0-f173.google.com with SMTP id 10so1295330lbg.4
        for <linux-crypto@vger.kernel.org>; Thu, 15 May 2014 15:10:20 -0700 (PDT)
In-Reply-To: <E28B9BA9-468D-45BD-A479-5D9289616798@arm.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 15 May 2014 14:47, Catalin Marinas <catalin.marinas@arm.com> wrote:
> On 15 May 2014, at 22:35, Ard Biesheuvel <ard.biesheuvel@linaro.org> =
wrote:
>> On 15 May 2014 10:24, Catalin Marinas <catalin.marinas@arm.com> wrot=
e:
>>> On Wed, May 14, 2014 at 07:17:29PM +0100, Ard Biesheuvel wrote:
>>>> +static u8 const *sha1_do_update(struct shash_desc *desc, const u8=
 *data,
>>>> +                             int blocks, u8 *head, unsigned int l=
en)
>>>> +{
>>>> +     struct sha1_state *sctx =3D shash_desc_ctx(desc);
>>>> +     struct thread_info *ti =3D NULL;
>>>> +
>>>> +     /*
>>>> +      * Pass current's thread info pointer to sha1_ce_transform()
>>>> +      * below if we want it to play nice under preemption.
>>>> +      */
>>>> +     if ((IS_ENABLED(CONFIG_PREEMPT_VOLUNTARY) || IS_ENABLED(CONF=
IG_PREEMPT))
>>>> +         && (desc->flags & CRYPTO_TFM_REQ_MAY_SLEEP))
>>>> +             ti =3D current_thread_info();
>>>> +
>>>> +     do {
>>>> +             int rem;
>>>> +
>>>> +             kernel_neon_begin_partial(16);
>>>> +             rem =3D sha1_ce_transform(blocks, data, sctx->state,=
 head, 0, ti);
>>>> +             kernel_neon_end();
>>>> +
>>>> +             data +=3D (blocks - rem) * SHA1_BLOCK_SIZE;
>>>> +             blocks =3D rem;
>>>> +             head =3D NULL;
>>>> +     } while (unlikely(ti && blocks > 0));
>>>> +     return data;
>>>> +}
>>>
>>> What latencies are we talking about? Would it make sense to always
>>> call cond_resched() even if preemption is disabled?
>>
>> Calculating the SHA256 (which is the most striking example) hash of =
a
>> 4k buffer takes ~10 microseconds, so perhaps this is all a bit moot =
as
>> I don't think there will generally be many in-kernel users hashing
>> substantially larger quantities of data at a time.
>
> And what=E2=80=99s the maximum size? Could we do it in blocks of 4K?
>

Yes, that should be doable as well. Once we feel we actually need this
feature, that is probably a better approach.

>>> But I think we should have this loop always rescheduling if
>>> CRYPTO_TFM_REQ_MAY_SLEEP. I can see there is a crypto_yield() funct=
ion
>>> that conditionally reschedules. What's the overhead of calling
>>> sha1_ce_transform() in a loop vs a single call for the entire data?
>>
>> For SHA256 we lose at least 10% if we call into the core function fo=
r
>> each 64 byte block rather than letting it chew away at all the data
>> itself.
>
> I was thinking more like calling it for bigger buffers (e.g. page) at
> once and a crypto_yield() in between.
>
>> (This is due to the fact that it needs to load 64 32-bit round
>> keys) But perhaps (considering the above) it is better to just shelv=
e
>> the last 4 patches in this series until it becomes a problem for
>> anyone.
>
> For the time being I would drop the last 4 patches. We can revisit th=
em
> for the next kernel version.
>

Agreed.

Should I send an updated pull request?

--=20
Ard.
