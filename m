From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: Re: [PATCH] random: silence compiler warnings and fix race
Date: Sat, 17 Jun 2017 02:39:40 +0200
Message-ID: <CAHmME9pLs2rKnuZ_La+PqYivEJDKEUdxUWS7eZthaw0jd8APVQ@mail.gmail.com>
References: <20170614192838.3jz4sxpcuhxygx4z@breakpoint.cc>
 <20170614224526.29076-1-Jason@zx2c4.com> <20170616143515.yn6oo6tvmcsrxidw@linutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: "Theodore Ts'o" <tytso@mit.edu>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        kernel-hardening@lists.openwall.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Eric Biggers <ebiggers3@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        David Miller <davem@davemloft.net>,
        Thomas Gleixner <tglx@linutronix.de>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from frisell.zx2c4.com ([192.95.5.64]:51951 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752042AbdFQAjn (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 16 Jun 2017 20:39:43 -0400
In-Reply-To: <20170616143515.yn6oo6tvmcsrxidw@linutronix.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Jun 16, 2017 at 4:35 PM, Sebastian Andrzej Siewior
<bigeasy@linutronix.de> wrote:
> I wouldn't just push the lock one up as is but move that write part to
> crng_init to remain within the locked section. Like that:

We can't quite do that, because invalidate_batched_entropy() needs to
be called _before_ crng_init. Otherwise a concurrent call to
get_random_u32/u64() will have crng_init being the wrong value when
the batched entropy is still old.

> Are use about that? I am not sure that the gcc will inline "crng_init"
> read twice. It is not a local variable. READ_ONCE() is usually used
> where gcc could cache a memory access but you do not want this. But hey!
> If someone knows better I am here to learn.

The whole purpose is that I _want_ it to cache the memory access so
that it is _not_ inlined. So, based on your understanding, it does
exactly what I intended it to do. The reason is that I'd like to avoid
a lock imbalance, which could happen if the read is inlined.

Jason
