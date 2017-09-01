From: Michael Ellerman <mpe@ellerman.id.au>
Subject: Re: [PATCH V3 6/6] crypto/nx: Add P9 NX support for 842 compression engine
Date: Fri, 01 Sep 2017 21:29:44 +1000
Message-ID: <87bmmu64if.fsf@concordia.ellerman.id.au>
References: <1500699702.23205.8.camel@hbabu-laptop> <CALZtONBGVQy2iwkb8WpVd-_QG7bLFTvUbnuub6CCXP55YpQiSQ@mail.gmail.com> <1504041817.2358.32.camel@kernel.crashing.org> <59A5E2AE.5060400@linux.vnet.ibm.com> <CALZtONBBvrfWkiFQipMrM9+VxsbBkHMFOAbgL0OBm5gb8yZ=LQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        "linuxppc-dev\@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        Michael Neuling <mikey@neuling.org>, suka@us.ibm.com,
        Ram Pai <linuxram@us.ibm.com>, npiggin@gmail.com,
        Haren Myneni <hbabu@us.ibm.com>
To: Dan Streetman <ddstreet@ieee.org>,
        Haren Myneni <haren@linux.vnet.ibm.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ozlabs.org ([103.22.144.67]:37771 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751862AbdIAL3q (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 1 Sep 2017 07:29:46 -0400
In-Reply-To: <CALZtONBBvrfWkiFQipMrM9+VxsbBkHMFOAbgL0OBm5gb8yZ=LQ@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Dan,

Thanks for reviewing this series.

Dan Streetman <ddstreet@ieee.org> writes:
> On Tue, Aug 29, 2017 at 5:54 PM, Haren Myneni <haren@linux.vnet.ibm.com> wrote:
>> On 08/29/2017 02:23 PM, Benjamin Herrenschmidt wrote:
>>> On Tue, 2017-08-29 at 09:58 -0400, Dan Streetman wrote:
>>>>> +
>>>>> +       ret = -EINVAL;
>>>>> +       if (coproc && coproc->vas.rxwin) {
>>>>> +               wmem->txwin = nx842_alloc_txwin(coproc);
>>>>
>>>> this is wrong.  the workmem is scratch memory that's valid only for
>>>> the duration of a single operation.
>>
>> Correct, workmem is used until crypto_free is called.
>
> that's not a 'single operation'.  a single operation is compress() or
> decompress().
>
>>>>
>>>> do you actually need a txwin per crypto transform?  or do you need a
>>>> txwin per coprocessor?  or txwin per processor?  either per-coproc or
>>>> per-cpu should be created at driver init and held separately
>>>> (globally) instead of a per-transform txwin.  I really don't see why
>>>> you would need a txwin per transform, because the coproc should not
>>>> care how many different transforms there are.
>>>
>>> We should only need a single window for the whole kernel really, plus
>>> one per user process who wants direct access but that's not relevant
>>> here.
>>
>> Opening send window for each crypto transform (crypto_alloc,
>> compression/decompression, ..., crypto_free) so that does not
>> have to wait for the previous copy/paste complete.
>> VAS will map send and receive windows, and can cache in send
>> windows (up to 128). So I thought using the same send window
>> (per chip) for more requests (say 1000) may be adding overhead.
>>
>> I will make changes if you prefer using 1 send window per chip.
>
> i don't have the spec, so i shouldn't be making the decision on it,
> but i do know putting a persistent field into the workmem is the wrong
> location.  If it's valid for the life of the transform, put it into
> the transform context.  The workmem buffer is intended to be used only
> during a single operation - it's "working memory" to perform each
> individual crypto transformation.

I agree workmem isn't the right place for the txwin. But I don't believe
it actually breaks anything to put txwin there.

So for now I'm going to merge this series as-is and I've asked Haren to
send fixes as soon as he can to clean it up.

cheers
