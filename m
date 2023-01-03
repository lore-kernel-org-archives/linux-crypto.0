Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 467CFC3DA7D
	for <linux-crypto@archiver.kernel.org>; Tue,  3 Jan 2023 20:02:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231158AbjACUC5 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 3 Jan 2023 15:02:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230488AbjACUCz (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 3 Jan 2023 15:02:55 -0500
Received: from mail-oi1-x22d.google.com (mail-oi1-x22d.google.com [IPv6:2607:f8b0:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97D7D6244
        for <linux-crypto@vger.kernel.org>; Tue,  3 Jan 2023 12:02:54 -0800 (PST)
Received: by mail-oi1-x22d.google.com with SMTP id n8so21197841oih.0
        for <linux-crypto@vger.kernel.org>; Tue, 03 Jan 2023 12:02:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=2Xug8HsBhB4vw61CYQrO6p56II484h234IA/MNnX9p8=;
        b=EbYiDfIyp249xUh5FwvkVnPr7aBXtVFVGZSFtl9pIKq68SODoEw8kZPQnYL8sXX69z
         F8E5UHAWixIJOtaSy7hFVhbt6eKa4sXCG4zalB7Ox/hGl++YbRVBW/YzL9Wjbkm4SzAX
         YQKeVGr58BgkVk4yWdEMW4R74YCb6drskvcyg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2Xug8HsBhB4vw61CYQrO6p56II484h234IA/MNnX9p8=;
        b=EOg5c7T5JYa9EH5npLGYfba5g0V5d7TBAVxaF3LuyQWHcr19M60JlmAybd/L/YzG5k
         0WeitchtYkDI+gVL1t+z/El7guMvudrU+W2d/FqnZ9CKzGbLmvNWimwiJqvRAaDOxI9h
         nJak+MkiuPkIh0d/xiE2viL6aMilSw+UR9NapQ26xJ5SP6svaIAJDfT41QazJF/rnmyL
         UnIH6xBB8yo6WbKLhSVy9odAQz2ngfJcVsBpADEJ0KGSgrBUjY8CuiA7dGh/x8B4xeY3
         kzJPyZ2UuqyR4cTnxDWjuhOmHKDUqdSzVHhvNMxt3nOm3j2uoDnDdyc/R9RIqQliwr8s
         T5MQ==
X-Gm-Message-State: AFqh2krgQA1M58af/c2Fgy52CdyE9bHdmCeDdwbTxek0fa1lE8NiSorK
        fDqAGtCNUcgtckHtYVvW4RslXGkvyHMob3e7
X-Google-Smtp-Source: AMrXdXtAtpmdbrDXw/QIunZap5ldkfvAqL2GM//Bp5/iCDx53UXlDfSefDxJOQVAX4TdiitdfPKBzQ==
X-Received: by 2002:a05:6808:10c3:b0:359:a360:fc4a with SMTP id s3-20020a05680810c300b00359a360fc4amr27684794ois.0.1672776173677;
        Tue, 03 Jan 2023 12:02:53 -0800 (PST)
Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com. [209.85.160.182])
        by smtp.gmail.com with ESMTPSA id bk15-20020a05620a1a0f00b006ce580c2663sm22527712qkb.35.2023.01.03.12.02.53
        for <linux-crypto@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Jan 2023 12:02:53 -0800 (PST)
Received: by mail-qt1-f182.google.com with SMTP id h21so25397884qta.12
        for <linux-crypto@vger.kernel.org>; Tue, 03 Jan 2023 12:02:53 -0800 (PST)
X-Received: by 2002:ac8:4913:0:b0:3ab:88cb:97cb with SMTP id
 e19-20020ac84913000000b003ab88cb97cbmr986538qtq.436.1672775691842; Tue, 03
 Jan 2023 11:54:51 -0800 (PST)
MIME-Version: 1.0
References: <20230101162910.710293-1-Jason@zx2c4.com> <20230101162910.710293-3-Jason@zx2c4.com>
 <Y7QIg/hAIk7eZE42@gmail.com> <CALCETrWdw5kxrtr4M7AkKYDOJEE1cU1wENWgmgOxn0rEJz4y3w@mail.gmail.com>
 <CAHk-=wg_6Uhkjy12Vq_hN6rQqGRP2nE15rkgiAo6Qay5aOeigg@mail.gmail.com> <Y7SDgtXayQCy6xT6@zx2c4.com>
In-Reply-To: <Y7SDgtXayQCy6xT6@zx2c4.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue, 3 Jan 2023 11:54:35 -0800
X-Gmail-Original-Message-ID: <CAHk-=whQdWFw+0eGttxsWBHZg1+uh=0MhxXYtvJGX4t9P1MgNw@mail.gmail.com>
Message-ID: <CAHk-=whQdWFw+0eGttxsWBHZg1+uh=0MhxXYtvJGX4t9P1MgNw@mail.gmail.com>
Subject: Re: [PATCH v14 2/7] mm: add VM_DROPPABLE for designating always
 lazily freeable mappings
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     Andy Lutomirski <luto@kernel.org>, Ingo Molnar <mingo@kernel.org>,
        linux-kernel@vger.kernel.org, patches@lists.linux.dev,
        tglx@linutronix.de, linux-crypto@vger.kernel.org,
        linux-api@vger.kernel.org, x86@kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Adhemerval Zanella Netto <adhemerval.zanella@linaro.org>,
        "Carlos O'Donell" <carlos@redhat.com>,
        Florian Weimer <fweimer@redhat.com>,
        Arnd Bergmann <arnd@arndb.de>, Jann Horn <jannh@google.com>,
        Christian Brauner <brauner@kernel.org>, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Jan 3, 2023 at 11:35 AM Jason A. Donenfeld <Jason@zx2c4.com> wrote:
>
> I don't think this is about micro-optimization. Rather, userspace RNGs
> aren't really possible in a safe way at the moment.

"Bah, humbug", to quote a modern-time philosopher.

It's humbug simply because it makes two assumptions that aren't even valid:

 (a) that you have to do it in user space in the first place

 (b) that you care about the particular semantics that you are looking for

The thing is, you can just do getrandom(). It's what people already
do. Problem solved.

The system call interface just isn't that expensive. Sure, the various
spectre mitigations have screwed us over in a big way on various
hardware, but even with that in mind system calls aren't some kind of
insurmountable hazard. There are absolutely tons of system calls that
are way more performance-critical than getrandom() has ever been.

So 99% of the time, the solution really is just "getrandom()",
generally with the usual buffering ("read more than you need, so that
you don't do it all the time").\

Which is not at all different from all the other system calls like
"read()" and friends.

And that's entirely ignoring the fact that something like "read()"
basically *has* to be a system call, because there are no alternatives
(ok, mmap, but that's actually much slower, unless you're in it for
the reuse-and/or-sparse-use situation).

With random numbers, you have tons of other alternatives, including
just hardware giving you the random numbers almost for free and you
just using your own rng in user space entirely.

And yes, some users might want to do things like periodic re-seeding,
but we actually do have fast ways to check for periodic events in user
space, ranging from entirely non-kernel things like rdtsc to actual
vdso's for gettimeofday().

So when you say that this isn't about micro-optimizations, I really
say "humbug". It's *clearly* about micro-optimization of an area that
very few people care about, since the alternative is just our existing
"getrandom()" that is not at all horribly slow.

Let me guess: the people you talked to who were excited about this are
mainly just library people?

And they are excited about this not because they actually need the
random numbers themselves, but because they just don't want to do the
work. They want to get nice benchmark numbers, and push the onus of
complexity onto somebody else?

Because the people who actually *use* the random numbers and are *so*
performance-critical about them already have their own per-thread
buffers or what-not, and need to have them anyway because they write
real applications that possibly work on other systems than Linux, but
that *definitely* work on enterprise systems that won't even have this
kind of new support for another several years even if we implemented
it today.

In fact, they probably are people inside of cloud vendors that are
still running 4.x kernels on a large portion of their machines.

          Linus
