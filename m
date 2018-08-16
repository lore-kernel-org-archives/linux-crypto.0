From: Alexander Popov <alex.popov@linux.com>
Subject: Re: [GIT PULL] gcc-plugin updates for v4.19-rc1
Date: Fri, 17 Aug 2018 01:18:10 +0300
Message-ID: <43da98d0-409b-88b9-0178-a79b581fc044@linux.com>
References: <20180813214328.GA15137@beast>
 <CA+55aFw5Tkn6DgkAZS-UGOjJpYp2R4rFAm9ixu_=FONeqRyofg@mail.gmail.com>
 <CAGXu5jK_w7JRywdQ78FfQxeLSMmXbvyDDnaYzj27=y8wnAzKxQ@mail.gmail.com>
 <CA+55aFyFCWH3YJnRUKtSzs9Mvny0eU+=QANxoPTE+9B9CkUWDw@mail.gmail.com>
 <CAGXu5jJ1JNSxJABUTAO85z_hXjSkjD=nWEho7KrYJTqqVGivig@mail.gmail.com>
 <CA+55aFy6jNLsywVYdGp83AMrXBo_P-pkjkphPGrO=82SPKCpLQ@mail.gmail.com>
 <CAGXu5j+Yv9Bu4mJPOfkpxrom91kSKaUESHR-Tn1CAJCTTZy_8w@mail.gmail.com>
Reply-To: alex.popov@linux.com
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
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
To: Kees Cook <keescook@chromium.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAGXu5j+Yv9Bu4mJPOfkpxrom91kSKaUESHR-Tn1CAJCTTZy_8w@mail.gmail.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hello,

On 15.08.2018 23:56, Kees Cook wrote:
> On Wed, Aug 15, 2018 at 1:18 PM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
>> I absolutely refuse to take any hardening patches at all that have
>> BUG() or panic() or similar machine-killing in it.
> 
> Okay, mental model adjusted. :) It was only "strong discouraged" until now.
> 
>> I thought VLA's were mostly gone.
...
> And after that, there's a single patch to move -Wvla up into the
> top-level Makefile:
> 
> https://patchwork.kernel.org/patch/10489873/
> 
> So, we're basically done

I've just sent the 15th version of the series with changes according to the
feedback from Linus:

1. BUG_ON() in stackleak_erase() is safely eliminated;

2. Stack Clash detection (alloca() check) is completely dropped, since global
'-Wvla' should arrive soon. stackleak_check_alloca() for arm64 is dropped as
well in a separate commit.

This version is rebased onto Linus' tree.

Best regards,
Alexander
