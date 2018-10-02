From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: Re: [PATCH net-next v6 21/23] crypto: port ChaCha20 to Zinc
Date: Tue, 2 Oct 2018 05:31:36 +0200
Message-ID: <CAHmME9rfd9wFOFNxaC23nAtGtjOUZGOYUwJKHS35iFwT8DYuwg@mail.gmail.com>
References: <20180925145622.29959-22-Jason@zx2c4.com> <20181002032609.o5i2hmphuqtkqgc4@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: LKML <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Samuel Neves <sneves@dei.uc.pt>,
        Andrew Lutomirski <luto@kernel.org>,
        Jean-Philippe Aumasson <jeanphilippe.aumasson@gmail.com>,
        Eric Biggers <ebiggers@google.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181002032609.o5i2hmphuqtkqgc4@gondor.apana.org.au>
Sender: netdev-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi Herbert,

On Tue, Oct 2, 2018 at 5:26 AM Herbert Xu <herbert@gondor.apana.org.au> wrote:
> Oh nice, so you did the conversion of the existing crypto code.
>
> I presume someone has done the numbers and verified that there
> is no performance regression?
>
> If so it would be good to include those numbers somewhere in this
> submission (within a patch description so that it goes into git).

Indeed I've done a pretty ridiculous amount of benchmarking, and the
x86_64 numbers are included in those commits because they're pretty
straightforward to show. The performance is also better on
arm1176,cortex-a7,8,9,15,53,73. On mips, as well, performance is
better, since there wasn't any optimized code there at all. Early
versions of this patchset included a regression on cortex-a7, which
was particularly problematic because Eric Biggers recent fscrypt work
requires fast chacha on that hardware, but this v6 (and the future v7)
contain code that is faster on all platforms across the board.

Regards,
Jason
