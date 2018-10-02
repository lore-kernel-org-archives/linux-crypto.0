From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: Re: [PATCH net-next v6 00/23] WireGuard: Secure Network Tunnel
Date: Tue, 2 Oct 2018 14:22:47 +0200
Message-ID: <CAHmME9r6-DHLwePQGBGcnPUZuZgZ2GtSUX9arsWzLqhKxd=uDA@mail.gmail.com>
References: <CAKv+Gu-ZMR7zEAKv6_2tyD3OqnjVugOzKHzBEXW3pQs5W-SvLw@mail.gmail.com>
 <20181002033908.324yhwqaohfsq65d@gondor.apana.org.au> <CAHmME9piX1kbUhOBcUKVdecr45EjxuruxYuMTepfXVvRrkVmyg@mail.gmail.com>
 <CAKv+Gu8fr_qADiTJH05nVWF7Yi3U722nfKJsMaRE9CP3YjNBbg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        Eric Biggers <ebiggers@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAKv+Gu8fr_qADiTJH05nVWF7Yi3U722nfKJsMaRE9CP3YjNBbg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, Oct 2, 2018 at 8:04 AM Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:
> Also, I still think the name Zinc (zinc is not crypto/) is needlessly
> divisive and condescending, and unsaying it (in v2 and up) doesn't
> really work on the Internet (especially since you are still repeating
> it in your conference talk.)
> Jason, you seem to hate the existing crypto framework with passion,
> and the name reflects that.

It's not divisive or condescending. I don't hate the existing
framework with a passion -- this is patently false. The name even with
its original acronym doesn't imply anything essentially negative. I
see that you've repeatedly misinterpreted it this way -- which is why
I removed that from v2 for the avoidance of doubt --  but that doesn't
change the fact that its proper interpretation is not a condescending
or divisive one.

Look, people love to bikeshed about names. I'm sure you'll be able to
CC-in a large crew of people who have opinions in one way or another,
and this thread could begin to have many voices on that front or on
multiple fronts. There are real benefits of sticking with the name
I've given to the library I've spent enormous amounts of time writing.
And so I'm going to stick with Zinc, since that's why our library is
called. Sorry. We can talk about this at Plumbers in Vancouver if you
want, but I think you're not going to get very far with a mailing list
naming bikeshed.

Meanwhile, I'm working around the clock to integrate your very useful
technical suggestions, so please keep them coming if you still have
technical nits you'd like to be in v7 of this patchset.

Jason
