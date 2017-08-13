From: Sandy Harris <sandyinchina@gmail.com>
Subject: Re: [Freedombox-discuss] Hardware Crypto
Date: Sun, 13 Aug 2017 13:21:02 -0400
Message-ID: <CACXcFm=Kea6fOgeqYrgg5z3F=aVOS3YHYuU0S7FespD+C02AZg@mail.gmail.com>
References: <87pqldrq15.fsf@freedomboxfoundation.org> <CAMhXSQpkScTzZB4fZ0KGbTPKmtiwv_o7cz7MrWXc_rqrCfO3Pg@mail.gmail.com>
 <4E1FF66C.6010908@mray.de> <87wrfe1acu.fsf@freedomboxfoundation.org>
 <CA+FSnD1NO97U1zQQZV=VD+dbCGR0oQTgEYBmH6VupGUKo8uRFA@mail.gmail.com>
 <87r55m175w.fsf@freedomboxfoundation.org> <CAJVWO9aUCLb6k87do-ckOdkV-1U7d2SiG3gtBOVVXouog04Tpw@mail.gmail.com>
 <CAJVWO9YDKD72Sbb9_wWvxFVEppDg=4+XfBAY3uxvxcZ0b2t3yg@mail.gmail.com>
 <20110720063824.GA15748@havelock.liw.fi> <CAJVWO9bXs7_bx8-37O++n8kSJTuASC_benwmyeLgfiik8nGrmA@mail.gmail.com>
 <8762mx14co.fsf@freedomboxfoundation.org> <6556610b-9ddf-4bc2-b235-a2c91598a040@email.android.com>
 <201107220153.p6M1rVDn004794@new.toad.com> <CACXcFm=CBZmSaiwt7RaGUtS1u-q5HUrACKrvj=7Y201R6Fzmtw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f51.google.com ([74.125.82.51]:36053 "EHLO
        mail-wm0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751047AbdHMRVE (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 13 Aug 2017 13:21:04 -0400
Received: by mail-wm0-f51.google.com with SMTP id t201so23363204wmt.1
        for <linux-crypto@vger.kernel.org>; Sun, 13 Aug 2017 10:21:04 -0700 (PDT)
In-Reply-To: <CACXcFm=CBZmSaiwt7RaGUtS1u-q5HUrACKrvj=7Y201R6Fzmtw@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Showing only the key parts of the message:

> From: John Gilmore <gnu@toad.com>

An exceedingly knowledgeable guy, one we should probably take seriously.
https://en.wikipedia.org/wiki/John_Gilmore_(activist)

> Most hardware crypto accelerators are useless, ...
> ... you might as well have
> just computed the answer in userspace using ordinary instructions.

A strong claim, but one I'm inclined to believe. In the cases where it
applies, it may be a problem for much of the Linux crypto work.

Some CPUs have special instructions to speed up some crypto
operations, and not just AES. For example, Intel has them for several
hashes and for elliptic curve calculations:
https://software.intel.com/en-us/articles/intel-sha-extensions
https://en.wikipedia.org/wiki/CLMUL_instruction_set
https://www.intel.com/content/dam/www/public/us/en/documents/white-papers/polynomial-multiplication-instructions-paper.pdf

These move the goalposts; if doing it "using ordinary instructions" is
sometimes faster than hardware, then doing it with
application-specific instructions is even more likely to be faster.

> Even if a /dev/crypto interface existed and was faster for some kinds
> of operations than just doing the crypto manually, the standard crypto
> libraries would have to be portably tuned to detect when to use
> hardware and when to use software.  The libraries generally use
> hardware if it's available, since they were written with the
> assumption that nobody would bother with hardware crypto if it was
> slower than software.
>
> "Just make it fast for all cases" is hard when the hardware is poorly
> designed.  When the hardware is well designed, it *is* faster for all
> cases.  But that's uncommon.
>
> Making this determination in realtime would be a substantial
> enhancement to each crypto library.  Since it'd have to be written
> portably (or the maintainers of the portable crypto libraries won't
> take it back), it couldn't assume any particular timings of any
> particular driver, either in hardware or software.  So it would have
> to run some fraction of the calls (perhaps 1%) in more than one
> driver, and time each one, and then make decisions on which driver to
> use by default for the other 99% of the calls.  The resulting times
> differ dramatically, based on many factors, ...
>
> One advantage of running some of the calls using both hardware and
> software is that the library can check that the results match exactly,
> and abort with a clear message.  That would likely have caught some bugs
> that snuck through in earlier crypto libraries.

I'm not at all sure I'd want run-time testing of this since, at least
as a general rule, introducing complications to crypto code is rarely
a good idea. Such tests at development time seem like a fine idea,
though; do we have those already?

What about testing when it is time to decide on kernel configuration;
include a particular module or not? Another issue is whether the
module choice is all-or-nothing; if there is a hardware RNG can one
use that without loading the rest of the code for the crypto
accelerator?
