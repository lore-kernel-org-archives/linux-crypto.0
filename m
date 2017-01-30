From: Eric Biggers <ebiggers3@gmail.com>
Subject: Re: [PATCH] dm: switch dm-verity to async hash crypto API
Date: Sun, 29 Jan 2017 16:28:44 -0800
Message-ID: <20170130002844.GB5253@zzz>
References: <1485268704-31033-1-git-send-email-gilad@benyossef.com>
 <CAAUqJDsC8BVnudsirn96O2qTHh4jMmYYe4YBiO83UW-PGfy+Qg@mail.gmail.com>
 <CAOtvUMfx4xYQk7_NQTQsc0xxGnsKkQdGk97XY5vv2tE0aHLpfw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: Ondrej =?utf-8?B?TW9zbsOhxI1law==?=
        <omosnacek+linux-crypto@gmail.com>, dm-devel@redhat.com,
        Alasdair Kergon <agk@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>,
        linux-crypto@vger.kernel.org, gilad.benyossef@arm.com,
        Ofir <ofir.drang@arm.com>
To: Gilad Ben-Yossef <gilad@benyossef.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pg0-f66.google.com ([74.125.83.66]:33649 "EHLO
        mail-pg0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750835AbdA3A2s (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 29 Jan 2017 19:28:48 -0500
Received: by mail-pg0-f66.google.com with SMTP id 194so30068841pgd.0
        for <linux-crypto@vger.kernel.org>; Sun, 29 Jan 2017 16:28:47 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <CAOtvUMfx4xYQk7_NQTQsc0xxGnsKkQdGk97XY5vv2tE0aHLpfw@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sun, Jan 29, 2017 at 09:39:20AM +0200, Gilad Ben-Yossef wrote:
> Hi Odrej,
> 
> On Thu, Jan 26, 2017 at 1:34 PM, Ondrej Mosnáček
> <omosnacek+linux-crypto@gmail.com> wrote:
> > Hi Gilad,
> >
> > 2017-01-24 15:38 GMT+01:00 Gilad Ben-Yossef <gilad@benyossef.com>:
> >> -       v->tfm = crypto_alloc_shash(v->alg_name, 0, 0);
> >> +       v->tfm = crypto_alloc_ahash(v->alg_name, 0, CRYPTO_ALG_ASYNC);
> >
> > I believe you should pass zero as the mask here. When flags == 0 and
> > mask == CRYPTO_ALG_ASYNC, you are basically saying "I want only algs
> > that have flags & CRYPTO_ALG_ASYNC == 0", which means you should only
> > get ahash tfms that are always synchronous (see [1]). However, since
> > you set a non-NULL callback in verity_hash_init, I don't think this
> > was your intention. By setting the mask to zero, you should be able to
> > get also an actual async tfm.
> >
> > Thanks,
> > Ondrej
> >
> > [1] https://lkml.org/lkml/2016/12/13/904
> 
> Thank you very much for the review.
> 
> I am the first to admit that I find the Crypto API very cryptic (pun
> intended)... :-)
> 
> I actually followed the example in Documentation/crypto/api-intro.txt.
> I see now the example is
> not doing what I though it was doing. Thank you for clarifying this. I
> will send out a 2nd version.
> 
> The thing I find puzzling in this is that I saw a difference in
> latency when a async algorythm
> provider driver with high priority (3000) was loaded vs. not. Based on
> your description I would
> expect the performance not to change. I will retest with the change
> and will publish the results.
> 
> Thanks!
> Gilad

Hi Gilad,

One thing to keep in mind is that the crypto API somewhat conflates the concept
of "is the algorithm asynchronous?" with "does this algorithm operate on virtual
memory or physical memory?".  The shash API is both synchronous and operates on
virtual memory, and when using it you only have access to shash algorithms.  The
ahash API on the other hand operates on physical memory and can be used either
synchronously or asynchronously.  In addition, both shash and ahash algorithms
may be accessed through the ahash API, and for shash algorithms the API will
handle translating physical addresses to virtual addresses.

So simply by using the ahash API instead of the shash API, even still requiring
a "synchronous" algorithm, you may gain access to a different implementation of
the algorithm, thereby changing the performance.  So whenever doing any
benchmarks I suggest including the actual driver name (cra_driver_name) of the
algorithms used; otherwise it may be unclear why the performance changed.

As for the patch, I haven't looked at it in detail, but I agree that if
dm-verity is indeed operating on sufficiently large buffers in physically
contiguous memory, then the ahash API would be better than the shash API.  Note,
that it also could be useful look into supporting having multiple async requests
issued and pending at the same time, similar to what dm-crypt does.

Eric
