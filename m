From: Jeffrey Walton <noloader@gmail.com>
Subject: Re: [PATCH] random: silence compiler warnings and fix race
Date: Tue, 20 Jun 2017 04:33:37 -0400
Message-ID: <CAH8yC8kLHL80_i2WRssgE3chL3iU-6dwvdkM-MoaPx4mtjx-kg@mail.gmail.com>
References: <20170614192838.3jz4sxpcuhxygx4z@breakpoint.cc>
 <20170614224526.29076-1-Jason@zx2c4.com> <CAHmME9rv3EjOVF4LhYZ0VS2LYKjDr_-TxzNHvyE_mKZ_UX0+eA@mail.gmail.com>
 <20170620060344.ngbnzg2mz5hvq4kw@thunk.org> <CAHmME9oHZz44uQ1tq=M=Vrxc5NY-2r4xFjbwge-Hp=U-cCEYfQ@mail.gmail.com>
Reply-To: noloader@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: "Theodore Ts'o" <tytso@mit.edu>, tglx@breakpoint.cc,
        David Miller <davem@davemloft.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Eric Biggers <ebiggers3@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        kernel-hardening@lists.openwall.com,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ot0-f195.google.com ([74.125.82.195]:34145 "EHLO
        mail-ot0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750863AbdFTIdj (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 20 Jun 2017 04:33:39 -0400
In-Reply-To: <CAHmME9oHZz44uQ1tq=M=Vrxc5NY-2r4xFjbwge-Hp=U-cCEYfQ@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Jun 20, 2017 at 4:14 AM, Jason A. Donenfeld <Jason@zx2c4.com> wrote:
>...
> Specifically, I added `depends on DEBUG_KERNEL`. This means that these
> useful warnings will only poke other kernel developers. This is probably
> exactly what we want. If the various associated developers see a warning
> coming from their particular subsystem, they'll be more motivated to
> fix it. Ordinary users on distribution kernels shouldn't see the
> warnings or the spam at all, since typically users aren't using
> DEBUG_KERNEL.

I think it is a bad idea to suppress all messages from a security
engineering point of view.

Many folks don't run debug kernels. Most of the users who want or need
to know of the issues won't realize its happening. Consider, the
reason we learned of systemd's problems was due to dmesg's.

Suppressing all messages for all configurations cast a wider net than
necessary. Configurations that could potentially be detected and fixed
likely will go unnoticed. If the problem is not brought to light, then
it won't be fixed.

I feel like the kernel is making policy decisions for some
organizations. For those who have hardware that is effectively
unfixable, then organization has to decide what to do based on their
risk adversity. They may decide to live with the risk, or they may
decide to refresh the hardware. However, without information on the
issue, they may not even realize they have an actionable item.

Jeff
