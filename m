From: Kees Cook <keescook@chromium.org>
Subject: Re: [GIT PULL] gcc-plugin updates for v4.19-rc1
Date: Wed, 15 Aug 2018 13:56:33 -0700
Message-ID: <CAGXu5j+Yv9Bu4mJPOfkpxrom91kSKaUESHR-Tn1CAJCTTZy_8w@mail.gmail.com>
References: <20180813214328.GA15137@beast> <CA+55aFw5Tkn6DgkAZS-UGOjJpYp2R4rFAm9ixu_=FONeqRyofg@mail.gmail.com>
 <CAGXu5jK_w7JRywdQ78FfQxeLSMmXbvyDDnaYzj27=y8wnAzKxQ@mail.gmail.com>
 <CA+55aFyFCWH3YJnRUKtSzs9Mvny0eU+=QANxoPTE+9B9CkUWDw@mail.gmail.com>
 <CAGXu5jJ1JNSxJABUTAO85z_hXjSkjD=nWEho7KrYJTqqVGivig@mail.gmail.com> <CA+55aFy6jNLsywVYdGp83AMrXBo_P-pkjkphPGrO=82SPKCpLQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Alexander Popov <alex.popov@linux.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Ingo Molnar <mingo@kernel.org>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tycho Andersen <tycho@tycho.ws>,
        Mark Rutland <mark.rutland@arm.com>,
        Laura Abbott <labbott@redhat.com>,
        Will Deacon <will.deacon@arm.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        linux-crypto <linux-crypto@vger.kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CA+55aFy6jNLsywVYdGp83AMrXBo_P-pkjkphPGrO=82SPKCpLQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wed, Aug 15, 2018 at 1:18 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> I absolutely refuse to take any hardening patches at all that have
> BUG() or panic() or similar machine-killing in it.

Okay, mental model adjusted. :) It was only "strong discouraged" until now.

> I thought VLA's were mostly gone.

Yes. Out of the ~115 instances we counted when we started with v4.16,
we've chipped away at them pretty steadily. Right now there are two
"one-off"s that haven't been picked up by maintainers:

https://git.kernel.org/pub/scm/linux/kernel/git/kees/linux.git/log/?h=vla/leftovers

and the remaining series against crypto, for which I am waiting on
further review for Herbert. All the really odd-ball crypto cases have
been handled (and are up for the merge window for v4.19), but there's
still some minor changes that Herbert is examining:

https://git.kernel.org/pub/scm/linux/kernel/git/kees/linux.git/log/?h=vla/crypto

And after that, there's a single patch to move -Wvla up into the
top-level Makefile:

https://patchwork.kernel.org/patch/10489873/

So, we're basically done, but the timing with the merge window wasn't
great since crypto continues to get tweaked and has taken much longer
than I had expected.

-Kees

-- 
Kees Cook
Pixel Security
