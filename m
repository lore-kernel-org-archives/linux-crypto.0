From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: x86-64: Maintain 16-byte stack alignment
Date: Thu, 12 Jan 2017 13:40:54 -0800
Message-ID: <CA+55aFwkodRf3QM+GLzq5G4F7fp+=ds-cHJRtCgJczMZgVx6Ug@mail.gmail.com>
References: <20170111031124.GA4515@gondor.apana.org.au> <CA+55aFxJOzMim_d-O2E2yip8JWo0NdYs_72sNwFKSkTjy8q0Sw@mail.gmail.com>
 <CA+55aFzypqpMog8aTczWYok0MqOcMi4gGzCor6k-NdJzBoLWyQ@mail.gmail.com>
 <20170111043541.GA4944@gondor.apana.org.au> <CALCETrX_vWTWu=kh4Zawn2OuhPnLip8xTqBGjYU-BvpJ9=ruTg@mail.gmail.com>
 <CALCETrVb-NyKJajGEsLOrQqQrQ7cRm4sqLRxNr_yVE2-mjiDrg@mail.gmail.com>
 <20170112140215.rh247gwk55fjzmg7@treble> <CA+55aFxP+V6Wbq5Xw_NOksiWouEMg4gjBJgeGa-qFyxDMnTmcA@mail.gmail.com>
 <CALCETrVz-wEFVUwrpS8-Ln9SWnsF5KxkqJC-Br6wJ+e0LGM9UA@mail.gmail.com>
 <20170112201511.yj5ekqmj76r2yv6t@treble> <20170112205504.gb6z2w52mektyc73@treble>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Andy Lutomirski <luto@amacapital.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andy Lutomirski <luto@kernel.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: Josh Poimboeuf <jpoimboe@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:33106 "EHLO
        mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751111AbdALVk4 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 12 Jan 2017 16:40:56 -0500
In-Reply-To: <20170112205504.gb6z2w52mektyc73@treble>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Jan 12, 2017 at 12:55 PM, Josh Poimboeuf <jpoimboe@redhat.com> wrote:
>
> - Who's going to run sparse all the time to catch unauthorized users of
>   __aligned__(16)?

Well, considering that we apparently only have a small handful of
existing users without anybody having ever run any tool at all, I
don't think this is necessarily a huge problem.

One of the build servers could easily add the "make C=2" case to a
build test, and just grep the error reports for the 'excessive
alignment' string. The zero-day build bot already does much fancier
things.

So I don't think it would necessarily be all that hard to get a clean
build, and just say "if you need aligned stack space, you have to do
it yourself by hand".

That saId, if we now always enable frame pointers on x86 (and it has
gotten more and more difficult to avoid it), then the 16-byte
alignment would fairly natural.

The 8-byte alignment mainly makes sense when the basic call sequence
just adds 8 bytes, and you have functions without frames (that still
call other functions).

                       Linus
