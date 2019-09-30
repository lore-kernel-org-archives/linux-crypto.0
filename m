Return-Path: <SRS0=wYoS=XZ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CBA28C4360C
	for <linux-crypto@archiver.kernel.org>; Mon, 30 Sep 2019 07:36:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9649220679
	for <linux-crypto@archiver.kernel.org>; Mon, 30 Sep 2019 07:36:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729254AbfI3HgG (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 30 Sep 2019 03:36:06 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:51098 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726314AbfI3HgG (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 30 Sep 2019 03:36:06 -0400
Received: from bigeasy by Galois.linutronix.de with local (Exim 4.80)
        (envelope-from <bigeasy@linutronix.de>)
        id 1iEqDp-0001nY-P4; Mon, 30 Sep 2019 09:35:53 +0200
Date:   Mon, 30 Sep 2019 09:35:53 +0200
From:   Sebastian Siewior <bigeasy@linutronix.de>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Miller <davem@davemloft.net>,
        Greg KH <gregkh@linuxfoundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Samuel Neves <sneves@dei.uc.pt>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Eric Biggers <ebiggers@google.com>,
        Andy Lutomirski <luto@kernel.org>,
        Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Martin Willi <martin@strongswan.org>
Subject: Re: [RFC PATCH 11/20] crypto: BLAKE2s - x86_64 implementation
Message-ID: <20190930073553.xy57e75nteiakjyp@linutronix.de>
References: <20190929173850.26055-1-ard.biesheuvel@linaro.org>
 <20190929173850.26055-12-ard.biesheuvel@linaro.org>
 <CAHmME9q=72-iKnHh0nB2+mO3uNoUerOVoHDY=eBKSoPB32XSsA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAHmME9q=72-iKnHh0nB2+mO3uNoUerOVoHDY=eBKSoPB32XSsA@mail.gmail.com>
User-Agent: NeoMutt/20180716
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 2019-09-30 04:42:06 [+0200], Jason A. Donenfeld wrote:
> Hi Sebastian, Thomas,
Hi Jason,

> On Sun, Sep 29, 2019 at 7:39 PM Ard Biesheuvel
> <ard.biesheuvel@linaro.org> wrote:
> > +       for (;;) {
> > +               const size_t blocks = min_t(size_t, nblocks,
> > +                                           PAGE_SIZE / BLAKE2S_BLOCK_SIZE);
> > +
> > +               kernel_fpu_begin();
> > +               if (IS_ENABLED(CONFIG_AS_AVX512) && blake2s_use_avx512)
> > +                       blake2s_compress_avx512(state, block, blocks, inc);
> > +               else
> > +                       blake2s_compress_avx(state, block, blocks, inc);
> > +               kernel_fpu_end();
> > +
> > +               nblocks -= blocks;
> > +               if (!nblocks)
> > +                       break;
> > +               block += blocks * BLAKE2S_BLOCK_SIZE;
> > +       }
> > +       return true;
> > +}
> 
> I'm wondering if on modern kernels this is actually fine and whether
> my simd_get/put/relax thing no longer has a good use case.
> Specifically, I recall last year there were a lot of patches and
> discussions about doing FPU register restoration lazily -- on context
> switch or the like. Did those land? Did the theory of action work out
> in the end?

That optimisation landed in v5.2. With that change (on x86)
kernel_fpu_end() does almost nothing (and so the following
kernel_fpu_begin()) and the FPU context will be restored once the task
returns to user land. (Note that this counts only for user-tasks because
we don't save the FPU state of a kernel thread.)
I haven't look at crypto code since that change was merged but looking
at the snippet from Ard is actually what I was aiming for.

> Regards,
> Jason

Sebastian
