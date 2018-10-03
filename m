From: Eric Biggers <ebiggers@kernel.org>
Subject: Re: [PATCH net-next v6 00/23] WireGuard: Secure Network Tunnel
Date: Tue, 2 Oct 2018 23:49:52 -0700
Message-ID: <20181003064951.GC745@sol.localdomain>
References: <CAKv+Gu-ZMR7zEAKv6_2tyD3OqnjVugOzKHzBEXW3pQs5W-SvLw@mail.gmail.com>
 <20181002033908.324yhwqaohfsq65d@gondor.apana.org.au>
 <CAHmME9piX1kbUhOBcUKVdecr45EjxuruxYuMTepfXVvRrkVmyg@mail.gmail.com>
 <CAKv+Gu8fr_qADiTJH05nVWF7Yi3U722nfKJsMaRE9CP3YjNBbg@mail.gmail.com>
 <CAHmME9r6-DHLwePQGBGcnPUZuZgZ2GtSUX9arsWzLqhKxd=uDA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        LKML <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAHmME9r6-DHLwePQGBGcnPUZuZgZ2GtSUX9arsWzLqhKxd=uDA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, Oct 02, 2018 at 02:22:47PM +0200, Jason A. Donenfeld wrote:
> On Tue, Oct 2, 2018 at 8:04 AM Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:
> > Also, I still think the name Zinc (zinc is not crypto/) is needlessly
> > divisive and condescending, and unsaying it (in v2 and up) doesn't
> > really work on the Internet (especially since you are still repeating
> > it in your conference talk.)
> > Jason, you seem to hate the existing crypto framework with passion,
> > and the name reflects that.
> 
> It's not divisive or condescending. I don't hate the existing
> framework with a passion -- this is patently false. The name even with
> its original acronym doesn't imply anything essentially negative. I
> see that you've repeatedly misinterpreted it this way -- which is why
> I removed that from v2 for the avoidance of doubt --  but that doesn't
> change the fact that its proper interpretation is not a condescending
> or divisive one.
> 
> Look, people love to bikeshed about names. I'm sure you'll be able to
> CC-in a large crew of people who have opinions in one way or another,
> and this thread could begin to have many voices on that front or on
> multiple fronts. There are real benefits of sticking with the name
> I've given to the library I've spent enormous amounts of time writing.
> And so I'm going to stick with Zinc, since that's why our library is
> called. Sorry. We can talk about this at Plumbers in Vancouver if you
> want, but I think you're not going to get very far with a mailing list
> naming bikeshed.
> 

It's not really about the name, though.  It's actually about the whole way of
thinking about the submission.  Is it a new special library with its own things
going on, or is it just some crypto helper functions?  It's really just the
latter, but you've been presenting it as the former, which is causing a lot of
unnecessary confusion and controversy.  And I think that largely because you've
started from that perspective, you've ended up with some oddities like your own
directories in lib/ and include/ separate from the other existing crypto helper
functions, and proposals to maintain it completely separately from the existing
crypto code including having a separate git tree and separate upstreaming path.

For example, we already have include/crypto/.  What's the difference between
include/crypto/ and include/zinc/?  How do users know whether to include e.g.
<crypto/chacha20.h> rather than <zinc/chacha20.h>?  And are users going to
remember and understand that "zinc" actually means "crypto" but not really?  It
would be much more straightforward and intuitive if we just had
<crypto/chacha20.h>, and your new helper functions were declared in there.

Dismissing these concerns as bikeshedding about the name is missing the point.

- Eric
