Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0F7AC4708E
	for <linux-crypto@archiver.kernel.org>; Fri,  6 Jan 2023 01:08:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236522AbjAFBH7 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 5 Jan 2023 20:07:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236747AbjAFBHv (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 5 Jan 2023 20:07:51 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7185F6E43A
        for <linux-crypto@vger.kernel.org>; Thu,  5 Jan 2023 17:07:45 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id z9-20020a17090a468900b00226b6e7aeeaso245629pjf.1
        for <linux-crypto@vger.kernel.org>; Thu, 05 Jan 2023 17:07:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=E2zTyAKcMSHj1NuBZpldWBfP/uR4r0Oo4FG0pR0Pc4o=;
        b=groJ1iJJAbzkeoFY5z0vFFmU8BFSk2iIyzy4jspxCVqwwWmPsIsjEfRdLdBElbBGOT
         EmrM5lijkGvSvr3nKF/I3GI8riFE7PasAhLLNA/4T+m976ixjVmwz3IcMaPuxSRT3Kgg
         txcqpXsJ9kof2smhhnslMFaxYEJR/ApjGac1A=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=E2zTyAKcMSHj1NuBZpldWBfP/uR4r0Oo4FG0pR0Pc4o=;
        b=2EcaLQBONJu0Su6EWafof2zq+YwtoCppAF4hMEpHOk3WK3rCH2/92k5nyYWTQAo4Yo
         sCM1IwH7rE4l0AB2XPwjUfPxkC03ys9W5Gspar2OFOCrlp3k0+iN9iSho506TBbtMsSa
         PTB5f5HQiyn6kU3LnUzbL6ae4mgogTIRN78/db/SwOMZz2jrXACzahCErkqgiOX9BBCg
         d5z0vSEzLfe5X3oY5TofjMIQ98iBHGam65JX+nsPq7iV3U1jyXYsj774DwPRZL3EYbjL
         80/9YskQ2jFn+J/dJwbBBqAh2UVvQQoskMQeRx0o8ld77UIHiyLbMNPj1dlNBnOkrubU
         ofww==
X-Gm-Message-State: AFqh2kqJKJ6wlbuG+e6YVhXzirugHxFX3sC2ymJpRITqtjzFZcG1LlwK
        eDme8j6zQrtCesSnxoMXPeMO1T3HH/Nu8yL4
X-Google-Smtp-Source: AMrXdXt47Kgsjb4bwLX+QrUO8qs4p6r61aRz3AJjT0iE92xauV9LhuZYx++nJ9ez7QMzKb+mdEmnRQ==
X-Received: by 2002:a05:6a20:cb58:b0:a4:255b:f3bd with SMTP id hd24-20020a056a20cb5800b000a4255bf3bdmr54022111pzb.45.1672967264704;
        Thu, 05 Jan 2023 17:07:44 -0800 (PST)
Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com. [209.85.216.45])
        by smtp.gmail.com with ESMTPSA id q9-20020a170902bd8900b00186ad73e2d5sm26555778pls.208.2023.01.05.17.07.44
        for <linux-crypto@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Jan 2023 17:07:44 -0800 (PST)
Received: by mail-pj1-f45.google.com with SMTP id fz16-20020a17090b025000b002269d6c2d83so4759794pjb.0
        for <linux-crypto@vger.kernel.org>; Thu, 05 Jan 2023 17:07:44 -0800 (PST)
X-Received: by 2002:a05:6214:1185:b0:4c6:608c:6b2c with SMTP id
 t5-20020a056214118500b004c6608c6b2cmr2487246qvv.130.1672966941474; Thu, 05
 Jan 2023 17:02:21 -0800 (PST)
MIME-Version: 1.0
References: <20230101162910.710293-3-Jason@zx2c4.com> <Y7QIg/hAIk7eZE42@gmail.com>
 <CALCETrWdw5kxrtr4M7AkKYDOJEE1cU1wENWgmgOxn0rEJz4y3w@mail.gmail.com>
 <CAHk-=wg_6Uhkjy12Vq_hN6rQqGRP2nE15rkgiAo6Qay5aOeigg@mail.gmail.com>
 <Y7SDgtXayQCy6xT6@zx2c4.com> <CAHk-=whQdWFw+0eGttxsWBHZg1+uh=0MhxXYtvJGX4t9P1MgNw@mail.gmail.com>
 <Y7SJ+/axonTK0Fir@zx2c4.com> <CAHk-=wi4gshfKjbhEO_xZdVb9ztXf0iuv5kKhxtvAHf2HzTmng@mail.gmail.com>
 <Y7STv9+p248zr+0a@zx2c4.com> <10302240-51ec-0854-2c86-16752d67a9be@opteya.com>
 <Y7dV1lVUYjqs8fh0@zx2c4.com>
In-Reply-To: <Y7dV1lVUYjqs8fh0@zx2c4.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Thu, 5 Jan 2023 17:02:05 -0800
X-Gmail-Original-Message-ID: <CAHk-=wijEC_oDzfUajhmp=ZVnzMTXgjxHEcxAfaHiNQm4iAcqA@mail.gmail.com>
Message-ID: <CAHk-=wijEC_oDzfUajhmp=ZVnzMTXgjxHEcxAfaHiNQm4iAcqA@mail.gmail.com>
Subject: Re: [PATCH v14 2/7] mm: add VM_DROPPABLE for designating always
 lazily freeable mappings
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     Yann Droneaud <ydroneaud@opteya.com>,
        Andy Lutomirski <luto@kernel.org>,
        Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        patches@lists.linux.dev, tglx@linutronix.de,
        linux-crypto@vger.kernel.org, linux-api@vger.kernel.org,
        x86@kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Adhemerval Zanella Netto <adhemerval.zanella@linaro.org>,
        "Carlos O'Donell" <carlos@redhat.com>,
        Florian Weimer <fweimer@redhat.com>,
        Arnd Bergmann <arnd@arndb.de>, Jann Horn <jannh@google.com>,
        Christian Brauner <brauner@kernel.org>, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Jan 5, 2023 at 2:57 PM Jason A. Donenfeld <Jason@zx2c4.com> wrote:
>
> On Thu, Jan 05, 2023 at 10:57:48PM +0100, Yann Droneaud wrote:
> >
> > To hold secret material, we need MADV_WIPEONFORK | MADV_DONTDUMP and the side effect of mlock() (pages' content never written to swap), inherited across fork().
> > And I want mlock() without paying the price.
> >
> > Jason's proposed semantics, which I call MADV_WIPEONSWAP, provide a mean to hold /unlimited/ amount secrets in userspace memory (not limited by RLIMIT_MEMLOCK).
> > The only constraint for userspace is to handle the case pages are wiped, which is already the case of userspace arc4random()'s implementation.
>
> If you're actually serious about wanting a generic mechanism for
> userspace, I think the moral of yesterday's poo-poo'ing all over this
> cool new idea is that the Linux innercircle doesn't really care for
> "security things" as a motivator

No.

We don't take stupid statements as a motivator.

Stop with the histrionics and silly security theater BS.

There is *nop* security in "MADV_WIPEONFORK". You claiming that that
is "security" is just making you less believable and me ignoring your
arguments more.

It's a complete make-believe fairy tale.

Why would it be "security" to dump random state data? In most
situations it's a complete non-issue, and nobody cares.

And those situations that want to be extra careful, and are actually
generating keys, those situations can do all of this very carefully on
their own using existing machinery.

If you don't want a core-dump because you have sensitive information,
you do "ulimit -c 0". Or you use MADV_DONTDUMP that we've had forever.

And you don't want to have wipe-on-fork, because

 (a) if you want things to be wiped on fork, you just wipe it before
the fork (duh!)

 (b) but more likely, and more relevantly, you want to make *DAMN
SURE* you wiped things much earlier than that if you are really
security-conscious and just generated a secret key, because you don't
want to leak things accidentally other ways.

 (c) and you can use MADV_DONTFORK to not copy it at all, which again
we've had for a long time.

And if you don't want to have it written to swap, you're just making
sh*t up at that point.

First off, it's a purely theoretical thing in the first place. See (b)
above. Don't keep those random things around long enough (and
untouched enough) to hit the disk.

Secondly, anybody who can read swap space can already ptrace you and
read things much more easily that way.

Thirdly, you can just use mlock, and make sure you never have so much
super-sikret stuff pending for long times and in big buffers.

Fourth, if your keys are *that* sensitive, and *that* secret, just use
/dev/random or getrandom(), because you're not generating that kind of
volume of long-term keys, so the whole "I have a huge random buffer
that is super-secret" is a complete non-issue.

So stop making stupid arguments. The kernel is not supposed to
baby-sit programs that do things wrong on purpose, and that are
literally trying to do things wrong, and leaving secret stuff around
while they do a lot of other things.

You guys have literally MADE UP bad examples of so-called "security",
and then you use those as arguments for bad coding, and for
bad-mouthing kernel developers who just don't happen to believe in
that bad model.

None of what you ask for is for any kind of real security, it's all
just crazy "but I want to feel the warm and fuzzies and take shortcuts
elsewhere, and push my pain onto other people".

          Linus
