Return-Path: <SRS0=sLqA=CY=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5493AC433E2
	for <linux-crypto@archiver.kernel.org>; Tue, 15 Sep 2020 06:04:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 166B620829
	for <linux-crypto@archiver.kernel.org>; Tue, 15 Sep 2020 06:04:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1600149843;
	bh=yIKc6+lk+0xwbnj6zXSMk3kuutAka6YWOJZS6bQ1R04=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=j5pFzVQirDmgI7jrgjPAZ+/x4vcVPxHm7P4eu0SIcegYEnqKvxoSpKarFLpKR6EGy
	 iPzLZD2/3yr4v4I8qRaZ7I/UOmKLnwLelxBV/gwfThcS2rzExvC7LZ+OHWcHJLrnIF
	 Sm78OunG6genM5xc5NtXs7cAnomxn8k/7f9h0Jd8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726087AbgIOGEA (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 15 Sep 2020 02:04:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:38452 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726073AbgIOGD7 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 15 Sep 2020 02:03:59 -0400
Received: from mail-ot1-f51.google.com (mail-ot1-f51.google.com [209.85.210.51])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 48F5220829;
        Tue, 15 Sep 2020 06:03:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600149838;
        bh=yIKc6+lk+0xwbnj6zXSMk3kuutAka6YWOJZS6bQ1R04=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=gsrheCJlHdoVOxgKbUzPnEMQ+xPctgZHo1XT99mmpPay54YMVwO8YEMcZZAQINghA
         mfdxIhHVEbAX8v16BT6PF0fll3Ss8GJewsd/cNTZ3zerlcz/T36lQjjzs6psPxn+p+
         Bz1vSwY6eKY6OjZ1MXwiaisKgCXGmvKitYDrP8WM=
Received: by mail-ot1-f51.google.com with SMTP id 60so2156457otw.3;
        Mon, 14 Sep 2020 23:03:58 -0700 (PDT)
X-Gm-Message-State: AOAM533/06dox62Y/QOo0REEYneCyK9xBXXp3hsr/Sc7ETa+ImqSNy9/
        /obZDXf+4932Gnp7oboPvru42D3Im3YPpnUr9Ec=
X-Google-Smtp-Source: ABdhPJxwGgUPEtFHKxE+2wv+WN2wtG/IRcQVZzc3wtmDPDCsD6aTynxC4/KVtBOTY5oyj60Ck1UfoB0i/UOjzAOLPDo=
X-Received: by 2002:a9d:6250:: with SMTP id i16mr12468647otk.77.1600149837597;
 Mon, 14 Sep 2020 23:03:57 -0700 (PDT)
MIME-Version: 1.0
References: <20200914204209.256266093@linutronix.de> <CAHk-=win80rdof8Pb=5k6gT9j_v+hz-TQzKPVastZDvBe9RimQ@mail.gmail.com>
 <871rj4owfn.fsf@nanos.tec.linutronix.de> <CAHk-=wj0eUuVQ=hRFZv_nY7g5ZLt7Fy3K7SMJL0ZCzniPtsbbg@mail.gmail.com>
 <CAHk-=wjOV6f_ddg+QVCF6RUe+pXPhSR2WevnNyOs9oT+q2ihEA@mail.gmail.com> <20200915033024.GB25789@gondor.apana.org.au>
In-Reply-To: <20200915033024.GB25789@gondor.apana.org.au>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Tue, 15 Sep 2020 09:03:46 +0300
X-Gmail-Original-Message-ID: <CAMj1kXEhQL-=tDRB8dW6L=EYn1OGjEKW3VKgFRV5O791NdJfzQ@mail.gmail.com>
Message-ID: <CAMj1kXEhQL-=tDRB8dW6L=EYn1OGjEKW3VKgFRV5O791NdJfzQ@mail.gmail.com>
Subject: Re: [PATCH] crypto: lib/chacha20poly1305 - Set SG_MITER_ATOMIC unconditionally
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

(+ Jason)

On Tue, 15 Sep 2020 at 06:30, Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> I trimmed the cc as the mailing lists appear to be blocking this
> email because of it.
>
> On Mon, Sep 14, 2020 at 03:37:49PM -0700, Linus Torvalds wrote:
> >
> > So it _looks_ like this code started using kmap() - probably back when
> > kmap_atomic() was so cumbersome to use - and was then converted
> > (conditionally) to kmap_atomic() rather than just changed whole-sale.
> > Is there actually something that wants to use those sg_miter functions
> > and sleep?
>
> I dug up the old zinc patch submissions and this wasn't present at
> all in the original.  The original zinc code used blkcipher_walk
> which unconditinoally does kmap_atomic.
>

Remember that the Zinc patchset was very vocal about not relying on
the Linux crypto API, yet it [ab]used the crypto blkcipher_walk API
(which was already deprecated at that point) in a rather horrid way,
by going around the blkcipher API itself, and creating some mock
objects that the blkcipher scatterlist walker would expect to exist.

So instead, I opted to rewrite this code using the SG miter API so that:
- src == dst, and so we only need to traverse (and kmap) a single
scatterlist instead of two in parallel (as Wireguard has no need for
the latter)
- no elaborate handling of the scatterlist elements when they are not
a multiple of the cipher chunk size (which is not needed for a stream
cipher liker ChaCha)
- no need to use scatterwalk_map_and_copy() (and do another kmap()) to
access the tag if it was covered by the last scatterlist element.

> So it's only the SG miter conversion that introduced this change,
> which appears to be a simple oversight (I think Ard was working on
> latency issues at that time, perhaps he was worried about keeping
> preemption off unnecessarily).
>

No, the problem with using kmap_atomic() is that it disables
preemption even on !HIGHMEM architectures. So using it unconditionally
here means that all chacha/poly processing will execute with
preemption disabled on 64-bit architectures as well.

This means that, even if you avoid the SIMD accelerated ciphers for
latency reasons (as they disable preemption as well), you are still
running the bulk of the WireGuard processing with preemption disabled.

> ---8<---
> There is no reason for the chacha20poly1305 SG miter code to use
> kmap instead of kmap_atomic as the critical section doesn't sleep
> anyway.  So we can simply get rid of the preemptible check and
> set SG_MITER_ATOMIC unconditionally.
>
> Even if we need to reenable preemption to lower latency we should
> be doing that by interrupting the SG miter walk rather than using
> kmap.
>

AIUI, the common case is that the entire packet is covered by a single
scatterlist element, so there is no room for latency reduction here.

The problem is really that kmap_atomic() is not simply a no-op on
!HIGHMEM architectures. If we can fix that, I have no objections to
this patch.

> Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
>
> diff --git a/lib/crypto/chacha20poly1305.c b/lib/crypto/chacha20poly1305.c
> index 431e04280332..5850f3b87359 100644
> --- a/lib/crypto/chacha20poly1305.c
> +++ b/lib/crypto/chacha20poly1305.c
> @@ -251,9 +251,7 @@ bool chacha20poly1305_crypt_sg_inplace(struct scatterlist *src,
>                         poly1305_update(&poly1305_state, pad0, 0x10 - (ad_len & 0xf));
>         }
>
> -       flags = SG_MITER_TO_SG;
> -       if (!preemptible())
> -               flags |= SG_MITER_ATOMIC;
> +       flags = SG_MITER_TO_SG | SG_MITER_ATOMIC;
>
>         sg_miter_start(&miter, src, sg_nents(src), flags);
>
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
