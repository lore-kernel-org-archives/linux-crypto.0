From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [patch] crypto: sha256-mb - cleanup a || vs | typo
Date: Fri, 8 Jul 2016 10:19:26 -0700
Message-ID: <CA+55aFyQYJerovMsSoSKS7PessZBr4vNp-3QUUwhqk4A4_jcbg@mail.gmail.com>
References: <20160629144242.GE22818@mwanda> <8538242a-eab7-127e-e47e-26027fee4f6d@zytor.com>
 <1467319339.22178.256.camel@linux.intel.com> <20160701075559.GA11902@gmail.com>
 <20160701092806.GA13424@gondor.apana.org.au> <20160701101329.GA3833@gmail.com>
 <20160708162803.GA29111@linux.intel.com> <20160708164502.GA3064@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Tim Chen <tim.c.chen@linux.intel.com>,
	Ingo Molnar <mingo@kernel.org>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Dan Carpenter <dan.carpenter@oracle.com>,
	"David S. Miller" <davem@davemloft.net>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	"the arch/x86 maintainers" <x86@kernel.org>,
	Megha Dey <megha.dey@intel.com>,
	"Wang, Rui Y" <rui.y.wang@intel.com>,
	Denys Vlasenko <dvlasenk@redhat.com>,
	Xiaodong Liu <xiaodong.liu@intel.com>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	kernel-janitors <kernel-janitors@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-oi0-f47.google.com ([209.85.218.47]:32772 "EHLO
	mail-oi0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932118AbcGHRT2 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 8 Jul 2016 13:19:28 -0400
In-Reply-To: <20160708164502.GA3064@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

[ rare comment rant. I think I'll do this once, and then ignore the discussion ]

On Fri, Jul 8, 2016 at 9:45 AM, Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> Nack.  As I said the commenting style in the crypto API is the
> same as the network stack.  So unless we decide to change both
> please stick to the current style.

Can we please get rid of the brain-damaged stupid networking comment
syntax style, PLEASE?

If the networking people cannot handle the pure awesomeness that is a
balanced and symmetric traditional multi-line C style comments, then
instead of the disgusting unbalanced crap that you guys use now,
please just go all the way to the C++ mode.

In other words, these three models are good:

 (a)
      /* This is a comment *./

 (b)
      /*
       * This is also a comment, but it can now be cleanly
       * split over multiple lines
       */

 (c)
      // This can be a single line. Or many. Your choice.

and they are all obviously visually balanced. Sometimes you want (b)
even for a single line, if you want the white-space to make it stand
out more, but you can obviously do that with (c) too, by just
surrounding it with two empty (comment) lines.

The (c) form is particularly good for things like enum or structure
member comments at the end of code, where you might want to align
things up, but the ending comment marker ends up being visually pretty
distracting (and lining _that_ up is too much make-believe work).

There's also another acceptablr traditional multi-line style that
you'll find in some places, but it's not the common kernel style:

 (d)
      /* This is an alternate multi-line format
         that isn't horrible, but not kernel style */

Note how all the above comment styles have a certain visual symmatry
and balance.

But no, the networking code picked *none* of the above sane formats.
Instead, it picked these two models that are just half-arsed
shit-for-brains:

 (no)
     /* This is disgusting drug-induced
       * crap, and should die
       */

  (no-no-no)
      /* This is also very nasty
       * and visually unbalanced */

Please. The networking code actually has the *worst* possible comment
style. You can literally find that (no-no-no) style, which is just
really horribly disgusting and worse than the otherwise fairly similar
(d) in pretty much every way.

I'm not even going to start talking about the people who prefer to
"box in" their comments, and line up both ends and have fancy boxes of
stars around the whole thing. I'm sure that looks really nice if you
are out of your mind on LSD, and have nothing better to do than to
worry about the right alignment of the asterisks.

I'd be happy to start moving the whole kernel over to the C++ style,
it's been many many years since we had compatibility issues and we are
all used to it by now, even if we weren't all fans originally.

I really don't understand why the networking people think that their
particularly ugly styles are fine. They are the most visually
unbalanced version of _all_ the common comment styles, and have no
actual advantages.

So just get rid of the (no-no) and (no-no-no) forms. Not in one big
go, but as people touch the code, just fix that mess up.

                 Linus
