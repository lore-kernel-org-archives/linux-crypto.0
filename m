From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH v2 09/11] arm64/crypto: add voluntary preemption to Crypto
 Extensions SHA1
Date: Thu, 15 May 2014 14:35:50 -0700
Message-ID: <CAKv+Gu-9P+vDPnvr2Cz4Bcw5=5SuEMw-xFxLM4=SoF65ESvhcQ@mail.gmail.com>
References: <1400091451-9117-1-git-send-email-ard.biesheuvel@linaro.org>
	<1400091451-9117-10-git-send-email-ard.biesheuvel@linaro.org>
	<20140515172458.GE1499@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "jussi.kivilinna@iki.fi" <jussi.kivilinna@iki.fi>,
	"herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-lb0-f171.google.com ([209.85.217.171]:45458 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752719AbaEOVfw (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 15 May 2014 17:35:52 -0400
Received: by mail-lb0-f171.google.com with SMTP id 10so1277145lbg.30
        for <linux-crypto@vger.kernel.org>; Thu, 15 May 2014 14:35:50 -0700 (PDT)
In-Reply-To: <20140515172458.GE1499@arm.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 15 May 2014 10:24, Catalin Marinas <catalin.marinas@arm.com> wrote:
> On Wed, May 14, 2014 at 07:17:29PM +0100, Ard Biesheuvel wrote:
>> The Crypto Extensions based SHA1 implementation uses the NEON register file,
>> and hence runs with preemption disabled. This patch adds a TIF_NEED_RESCHED
>> check to its inner loop so we at least give up the CPU voluntarily when we
>> are running in process context and have been tagged for preemption by the
>> scheduler.
>
> Sorry, I haven't got to the bottom of your series earlier and I now
> realised that the last patches are not just new crypto algorithms.
>
>> +static u8 const *sha1_do_update(struct shash_desc *desc, const u8 *data,
>> +                             int blocks, u8 *head, unsigned int len)
>> +{
>> +     struct sha1_state *sctx = shash_desc_ctx(desc);
>> +     struct thread_info *ti = NULL;
>> +
>> +     /*
>> +      * Pass current's thread info pointer to sha1_ce_transform()
>> +      * below if we want it to play nice under preemption.
>> +      */
>> +     if ((IS_ENABLED(CONFIG_PREEMPT_VOLUNTARY) || IS_ENABLED(CONFIG_PREEMPT))
>> +         && (desc->flags & CRYPTO_TFM_REQ_MAY_SLEEP))
>> +             ti = current_thread_info();
>> +
>> +     do {
>> +             int rem;
>> +
>> +             kernel_neon_begin_partial(16);
>> +             rem = sha1_ce_transform(blocks, data, sctx->state, head, 0, ti);
>> +             kernel_neon_end();
>> +
>> +             data += (blocks - rem) * SHA1_BLOCK_SIZE;
>> +             blocks = rem;
>> +             head = NULL;
>> +     } while (unlikely(ti && blocks > 0));
>> +     return data;
>> +}
>
> What latencies are we talking about? Would it make sense to always
> call cond_resched() even if preemption is disabled?
>

Calculating the SHA256 (which is the most striking example) hash of a
4k buffer takes ~10 microseconds, so perhaps this is all a bit moot as
I don't think there will generally be many in-kernel users hashing
substantially larger quantities of data at a time.

> With PREEMPT_VOLUNTARY I don't think the above code does any voluntary
> preemption. The preempt_enable() in kernel_neon_end() only reschedules
> if PREEMPT.
>

Right, my mistake.

> But I think we should have this loop always rescheduling if
> CRYPTO_TFM_REQ_MAY_SLEEP. I can see there is a crypto_yield() function
> that conditionally reschedules. What's the overhead of calling
> sha1_ce_transform() in a loop vs a single call for the entire data?
>

For SHA256 we lose at least 10% if we call into the core function for
each 64 byte block rather than letting it chew away at all the data
itself. (This is due to the fact that it needs to load 64 32-bit round
keys) But perhaps (considering the above) it is better to just shelve
the last 4 patches in this series until it becomes a problem for
anyone.

-- 
Ard.
