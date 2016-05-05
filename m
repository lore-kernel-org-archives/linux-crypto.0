From: John Denker <jsd@av8n.com>
Subject: Re: UB in general ... and linux/bitops.h in particular
Date: Thu, 5 May 2016 09:15:35 -0700
Message-ID: <572B71A7.1020100@av8n.com>
References: <CAH8yC8=sYbrY9gpz0mKMKrcj=kSh38SPyxfk4HGeB5mOU6=etA@mail.gmail.com>
 <BB2EB46A-8AFE-4A8C-A486-3717AC178A7B@zytor.com>
 <20160504190723.GD3901@thunk.org> <572A6CDD.10503@av8n.com>
 <572A6F1C.2080708@av8n.com>
 <CAH8yC8kZDfw+6Ctog-C7Jb57rLnagAFMNwNfGH_dwa9fs=5h1Q@mail.gmail.com>
 <28624BFC-7C63-4F38-9F67-7CBFB0C6499B@zytor.com>
 <CAH8yC8ndyLipAdu5=vmyJ3eHYBS-mxQsRF2q2G2EuOfQxTpM7g@mail.gmail.com>
 <0015E1DE-DFF9-4CCE-805E-7AC286021BED@zytor.com>
 <CAH8yC8mbW5yTwbKN7_RMNVnTiKmtP0u3_2+tKV=-L4BZ6miGVw@mail.gmail.com>
 <20160505035028.GD10776@thunk.org>
 <CAH8yC8n974Z=mvXPsLiZqYPkVjBqtR=nqYQ-jJo194ECmWkofA@mail.gmail.com>
 <572AE9A2.20609@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
To: "H. Peter Anvin" <hpa@zytor.com>, noloader@gmail.com,
	Theodore Ts'o <tytso@mit.edu>, linux-kernel@vger.kernel.org,
	Stephan Mueller <smueller@chronox.de>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Andi Kleen <andi@firstfloor.org>,
	Sandy Harris <sandyinchina@gmail.com>,
	cryptography@lakedaemon.net, linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from cloud.av8n.com ([174.136.99.130]:58037 "EHLO cloud.av8n.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752937AbcEEQPi (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 5 May 2016 12:15:38 -0400
In-Reply-To: <572AE9A2.20609@zytor.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 05/04/2016 11:35 PM, H. Peter Anvin wrote:

> The disagreement here is the priority between these points. 

Yes.

As usual, all the extremes are wrong.
Tradeoffs must be made.
Perspective and judgment are required.

> In my very strong opinion, "no undefined behavior" per the C standard
> is way less important than the others; what matters is what gcc and
> the other compilers we care about do.

But we don't control what the compilers do.  The gcc guys have
a track record of assuming that UB gives them a license to do
whatever they want.  At any moment they can change their mind
and do something new.

> The kernel relies on various versions of C-standard-undefined
> behavior *all over the place*;>

One should be careful with that argument.  Not all types of UB 
are created equal.  There is a world of difference between
  -- UB_type_1 used "all over the place" by necessity, and
  -- UB_type_2 used here-and-there for convenience.

UB_type_1 defines a de_facto dialect of the language.

Ideally there would be a formal specification of the dialect,
but that's not super-urgent, because the compiler guys are
probably not crazy enough to break something if it really is 
used "all over the place".

Formalized or not, UB_type_1 does not make it OK for programmers
to invoke *other* types of UB.  I'll say it again: the gcc guys
have a track record of assuming UB gives them a license to do 
whatever they want.  The results can be very counterintuitive.

UB is a nightmare from the point of view of reliability,
security, and maintainability.  The fact that your favorite
compiler does what you want as of today is *not* a guarantee
that it will do so in the future.

===========

As for the suggestion that the UB code is somehow more
efficient or in any way better, I'm not buying it.

Using gcc 5.2.1 I observe that [1] and [2] (given below)
generate the exact same code at any optimization level
from -O1 on up. My kernel is compiled with -O2.

(They generate different code with -O0 but that doesn't
seem like an important consideration.)

The relevant code is
   (word >> shift) | (word >> ((-shift) & 31));  /* [1] */
   (word >> shift) | (word << (32 - shift));     /* [2] */

> for one thing sizeof(void *) == sizeof(size_t) == sizeof(unsigned long)!!

I assume that comes up in the context of type punning.  I
am not a language lawyer, but it is my understanding that
type punning *is* permitted by the C language specification.
(C++ is another story entirely, but not relevant here.)

There is a world of difference between
 -- loosely specified options (LSO), and
 -- undefined behavior (UB)

The sizeof() example is LSO not UB.  One could easily check
the sizes at compile time, so that no looseness remains.
The result is perfectly reasonable, efficient, reliable code.

Similarly, the kernel assumes two's complement arithmetic
"all over the place" but this is LSO not UB.

This is relevant to linux/bitops.h because [2] is UB when
shift==0.  In contrast [1] is a very mild example of LSO
because it assumes two's complement.

I consider it a step in the right direction to get rid of UB
when it can be done at zero cost.  UB is dangerous.

==========================

Suggestions:

 a) Going forward, I suggest that UB should not be invoked
  unless there is a good solid reason.

 b) In cases where a this-or-that UB really is needed, it
  should be carefully documented.

   -- Perhaps there could be a file linux_kernel_dialect.c 
    that gives examples of all the constructs that the kernel
    needs but are not in the basic C specification.  One would
    hope this would be very, very short.

   -- Perhaps the compiler guys could be persuaded to support
    the needed features explicitly, perhaps via a command-line
    option: -std=vanilla
    This should be a no-cost option as things stand today, but
    it helps to prevent nasty surprises in the future.
