From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: Re: [PATCH net-next v6 00/23] WireGuard: Secure Network Tunnel
Date: Fri, 5 Oct 2018 15:13:54 +0200
Message-ID: <CAHmME9ogY=v2Le85+_=-m++RwAzwiUmKyNzx6N2y9Ht-J7xBcQ@mail.gmail.com>
References: <CAKv+Gu-ZMR7zEAKv6_2tyD3OqnjVugOzKHzBEXW3pQs5W-SvLw@mail.gmail.com>
 <20181002033908.324yhwqaohfsq65d@gondor.apana.org.au> <CAHmME9piX1kbUhOBcUKVdecr45EjxuruxYuMTepfXVvRrkVmyg@mail.gmail.com>
 <CAKv+Gu8fr_qADiTJH05nVWF7Yi3U722nfKJsMaRE9CP3YjNBbg@mail.gmail.com>
 <CAHmME9r6-DHLwePQGBGcnPUZuZgZ2GtSUX9arsWzLqhKxd=uDA@mail.gmail.com> <20181003064951.GC745@sol.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        LKML <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Eric Biggers <ebiggers@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181003064951.GC745@sol.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi Eric,

On Wed, Oct 3, 2018 at 8:49 AM Eric Biggers <ebiggers@kernel.org> wrote:
> It's not really about the name, though.  It's actually about the whole way of
> thinking about the submission.  Is it a new special library with its own things
> going on, or is it just some crypto helper functions?  It's really just the
> latter, but you've been presenting it as the former

No, it really is its own thing with important differences from the
present crypto api. Zinc's focus is on simplicity and clarity. To the
extent that we're at all tangled with the current crypto api, the goal
is to untangle as much as possible. It intends to be a small and
lightweight set of routines, whose relationships are obvious, and with
this direct and to the point organization, as well as work with the larger
cryptography community and with academia to invite collaboration. With
this comes a different way of maintaining it, with higher standards
and a preference for different implementations than the current
situation. With Zinc, you have an obvious series of C function calls
composing the whole thing, without complicated indirection. It's
something that could be trivially lifted out into a userspace library,
and used broadly, for example -- something I'll probably do at some
point. That's a bit of a design change to the current crypto api, and
sprinkling some direct function calls within the current crypto api's
complicated enterprise situation would only kick the can further down
the road, as much complexity would still remain. The goal is to move
away from behemoth enterprise APIs, and large and complex codebases to
a simple and direct way of doing things. This desire to untangle, to
start from a simpler base, and to generally do things differently
means it will go into lib/zinc/ and include/zinc/ and have different
maintainers.

Jason
