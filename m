From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: Re: [kernel-hardening] [PATCH] random: warn when kernel uses unseeded randomness
Date: Thu, 22 Jun 2017 02:04:57 +0200
Message-ID: <CAHmME9rObcSGQ9AQOe=4OMK1eszGMgchBznzAZwAO3aaGbo0gQ@mail.gmail.com>
References: <CAHmME9qvPL+vdY16SgV2VzuDDyM4r+hkYy8yGG3LJaa-3igxfA@mail.gmail.com>
 <20170621000300.11646-1-Jason@zx2c4.com> <87k245ub5y.fsf@concordia.ellerman.id.au>
 <20170621203824.khyt6uqxghhdromi@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: "Theodore Ts'o" <tytso@mit.edu>,
        Michael Ellerman <mpe@ellerman.id.au>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Jeffrey Walton <noloader@gmail.com>, tglx@breakpoint.cc,
        David Miller <davem@davemloft.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Eric Biggers <ebiggers3@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        kernel-hardening@lists.openwall.com,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from frisell.zx2c4.com ([192.95.5.64]:33997 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751689AbdFVAFC (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 21 Jun 2017 20:05:02 -0400
In-Reply-To: <20170621203824.khyt6uqxghhdromi@thunk.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Ted,

On Wed, Jun 21, 2017 at 10:38 PM, Theodore Ts'o <tytso@mit.edu> wrote:
> I agree completely with all of this.  The following patch replaces the
> current topmost patch on the random.git tree:
> For developers who want to work on improving this situation,
> CONFIG_WARN_UNSEEDED_RANDOM has been renamed to
> CONFIG_WARN_ALL_UNSEEDED_RANDOM.  By default the kernel will always
> print the first use of unseeded randomness.  This way, hopefully the
> security obsessed will be happy that there is _some_ indication when
> the kernel boots there may be a potential issue with that architecture
> or subarchitecture.  To see all uses of unseeded randomness,
> developers can enable CONFIG_WARN_ALL_UNSEEDED_RANDOM.

Seems fine to me.

Acked-by: Jason A. Donenfeld <Jason@zx2c4.com>

Jason
