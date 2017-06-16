From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: Re: [PATCH v5 01/13] random: invalidate batched entropy after crng init
Date: Fri, 16 Jun 2017 14:12:42 +0200
Message-ID: <CAHmME9q_9-zQan0um9j2deHHPejYreCCbfss0BeNuEr4_tuaKg@mail.gmail.com>
References: <20170607232607.26870-1-Jason@zx2c4.com> <20170607232607.26870-2-Jason@zx2c4.com>
 <20170614192838.3jz4sxpcuhxygx4z@breakpoint.cc> <CAHmME9oRG4Oe4zNN4D8Nc9+A51uXPC0y3m3+ws_QK2aq=K=zwA@mail.gmail.com>
 <20170616083111.5cwwkzyauocxafou@breakpoint.cc>
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
To: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170616083111.5cwwkzyauocxafou@breakpoint.cc>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Fri, Jun 16, 2017 at 10:31 AM, Sebastian Andrzej Siewior
<sebastian@breakpoint.cc> wrote:
> am talking about. Again:

I actually figured that out myself after sending the initial email, so
then I wrote a follow-up patch which I attached to this thread. You
should have received it. Can you take a look?

https://lkml.org/lkml/2017/6/14/942
