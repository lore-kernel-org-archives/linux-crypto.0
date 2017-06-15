From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Crypto Fixes for 4.12
Date: Thu, 15 Jun 2017 18:04:44 +0900
Message-ID: <CA+55aFwU1ZvJZK8x9QQtROjOVHG_ks-H3XpU+hjuf8BTxndN3g@mail.gmail.com>
References: <20161119102748.GA4277@gondor.apana.org.au> <20161215160732.GA16580@gondor.apana.org.au>
 <20170111115646.GA8943@gondor.apana.org.au> <20170304074119.GA3041@gondor.apana.org.au>
 <20170523034211.GA12748@gondor.apana.org.au> <20170608092320.GA6478@gondor.apana.org.au>
 <20170615005443.GA30435@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-it0-f44.google.com ([209.85.214.44]:35081 "EHLO
        mail-it0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750777AbdFOJEq (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 15 Jun 2017 05:04:46 -0400
In-Reply-To: <20170615005443.GA30435@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Jun 15, 2017 at 9:54 AM, Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> This push fixes a bug on sparc where we may dereference freed stack
> memory.

Ugh, that's a particularly ugly fix for a random gcc bug on a random
architecture that almost nobody tests.

In other words, it's nasty. It's nasty because nobody sane will ever
realize this pattern, and the code will either bit-rot or just happen
again somewhere else.

I'd have been *much* happier if this had been some nicer abstraction
that is built up around the use of SHASH_DESC_ON_STACK(), and just
have some rule that "SHASH_DESC_ON_STACK()" needs to be paired with
retrieving the final value and then a SHASH_DESC_DEALLOC() or
whatever.

Then you *could* implement SHASH_DESC_ON_STACK() as a kmalloc, and
SHASH_DESC_DEALLOC() would be a kfree - but with an alloca()-like
allocation the SHASH_DESC_DEALLOC() would be that "barrier_data()".

At that point the interface would make _sense_ at some conceptual
level, rather than being a random hack for a small collection of
random users of this thing.

There's a fair number of SHASH_DESC_ON_STACK users, are all the others
safe for some random reason that just happens to be about code
generation? Did people actually verify that?

                Linus
