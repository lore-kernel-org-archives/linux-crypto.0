From: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH v2 09/11] arm64/crypto: add voluntary preemption to Crypto Extensions SHA1
Date: Thu, 15 May 2014 22:47:04 +0100
Message-ID: <E28B9BA9-468D-45BD-A479-5D9289616798@arm.com>
References: <1400091451-9117-1-git-send-email-ard.biesheuvel@linaro.org> <1400091451-9117-10-git-send-email-ard.biesheuvel@linaro.org> <20140515172458.GE1499@arm.com> <CAKv+Gu-9P+vDPnvr2Cz4Bcw5=5SuEMw-xFxLM4=SoF65ESvhcQ@mail.gmail.com>
Mime-Version: 1.0 (Mac OS X Mail 7.2 \(1874\))
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "jussi.kivilinna@iki.fi" <jussi.kivilinna@iki.fi>,
	"herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-we0-f179.google.com ([74.125.82.179]:48549 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752719AbaEOVrH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 15 May 2014 17:47:07 -0400
Received: by mail-we0-f179.google.com with SMTP id q59so1699719wes.38
        for <linux-crypto@vger.kernel.org>; Thu, 15 May 2014 14:47:06 -0700 (PDT)
In-Reply-To: <CAKv+Gu-9P+vDPnvr2Cz4Bcw5=5SuEMw-xFxLM4=SoF65ESvhcQ@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 15 May 2014, at 22:35, Ard Biesheuvel <ard.biesheuvel@linaro.org> wr=
ote:
> On 15 May 2014 10:24, Catalin Marinas <catalin.marinas@arm.com> wrote=
:
>> On Wed, May 14, 2014 at 07:17:29PM +0100, Ard Biesheuvel wrote:
>>> +static u8 const *sha1_do_update(struct shash_desc *desc, const u8 =
*data,
>>> +                             int blocks, u8 *head, unsigned int le=
n)
>>> +{
>>> +     struct sha1_state *sctx =3D shash_desc_ctx(desc);
>>> +     struct thread_info *ti =3D NULL;
>>> +
>>> +     /*
>>> +      * Pass current's thread info pointer to sha1_ce_transform()
>>> +      * below if we want it to play nice under preemption.
>>> +      */
>>> +     if ((IS_ENABLED(CONFIG_PREEMPT_VOLUNTARY) || IS_ENABLED(CONFI=
G_PREEMPT))
>>> +         && (desc->flags & CRYPTO_TFM_REQ_MAY_SLEEP))
>>> +             ti =3D current_thread_info();
>>> +
>>> +     do {
>>> +             int rem;
>>> +
>>> +             kernel_neon_begin_partial(16);
>>> +             rem =3D sha1_ce_transform(blocks, data, sctx->state, =
head, 0, ti);
>>> +             kernel_neon_end();
>>> +
>>> +             data +=3D (blocks - rem) * SHA1_BLOCK_SIZE;
>>> +             blocks =3D rem;
>>> +             head =3D NULL;
>>> +     } while (unlikely(ti && blocks > 0));
>>> +     return data;
>>> +}
>>=20
>> What latencies are we talking about? Would it make sense to always
>> call cond_resched() even if preemption is disabled?
>=20
> Calculating the SHA256 (which is the most striking example) hash of a
> 4k buffer takes ~10 microseconds, so perhaps this is all a bit moot a=
s
> I don't think there will generally be many in-kernel users hashing
> substantially larger quantities of data at a time.

And what=92s the maximum size? Could we do it in blocks of 4K?

>> But I think we should have this loop always rescheduling if
>> CRYPTO_TFM_REQ_MAY_SLEEP. I can see there is a crypto_yield() functi=
on
>> that conditionally reschedules. What's the overhead of calling
>> sha1_ce_transform() in a loop vs a single call for the entire data?
>=20
> For SHA256 we lose at least 10% if we call into the core function for
> each 64 byte block rather than letting it chew away at all the data
> itself.

I was thinking more like calling it for bigger buffers (e.g. page) at
once and a crypto_yield() in between.

> (This is due to the fact that it needs to load 64 32-bit round
> keys) But perhaps (considering the above) it is better to just shelve
> the last 4 patches in this series until it becomes a problem for
> anyone.

=46or the time being I would drop the last 4 patches. We can revisit th=
em
for the next kernel version.

Catalin--
To unsubscribe from this list: send the line "unsubscribe linux-crypto"=
 in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
