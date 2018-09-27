From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: Re: [PATCH net-next v6 00/23] WireGuard: Secure Network Tunnel
Date: Thu, 27 Sep 2018 23:35:39 +0200
Message-ID: <20180927213537.GA27576@zx2c4.com>
References: <20180925145622.29959-1-Jason@zx2c4.com>
 <20180927182944.GA22921@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-crypto@vger.kernel.org, davem@davemloft.net,
        gregkh@linuxfoundation.org
To: Eric Biggers <ebiggers@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180927182944.GA22921@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi Eric,

On Thu, Sep 27, 2018 at 8:29 PM Eric Biggers <ebiggers@kernel.org> wrote:
> Why is Herbert Xu's existing crypto tree being circumvented, especially for
> future patches (the initial merge isn't quite as important as that's a one-time
> event)?  I like being able to check out cryptodev to test upcoming crypto
> patches.  And currently, changes to APIs, algorithms, tests, and implementations
> all go through cryptodev, which is convenient for crypto developers.
>
> Apparently, you're proposing that someone adding a new algorithm will now have
> to submit the API portion to one maintainer (Herbert Xu) and the implementation
> portion to another maintainer (you), and they'll go through separate git trees.
> That's inconvenient for developers, and it seems that in practice you and
> Herbert will be stepping on each other's toes a lot.
>
> Can you please reach some kind of sane agreement with Herbert so that the
> development process isn't fractured into two?  Perhaps you could review patches,
> but Herbert could still apply them?

I think you're overthinking it a bit. Zinc will have a few software
implementations of primitives that are useful in cases where it's nice to call
the primitive directly. Think: various usages of sha2, siphash, the wireguard
suite (what this patchset includes), other things in lib/, etc. In so much as
this winds up duplicating things within the crypto API, I'll work with Herbert
to build one on top of the other -- as I've done in the two commits in this
series. But beyond that, think of the two initiatives as orthogonal. I'm
working on curating a few primitives that are maximally useful throughout
the kernel for various uses, and doing so in a way that I think brings
about a certain quality. Meanwhile the crypto API is amassing a huge
collection of primitives for some things, and that will continue to exist,
and Herbert will continue to maintain that. I expect for the crossover
to be fairly isolated and manageable, without too much foreseeable tree-
conflicts and such. Therefore, Samuel Neves and I plan to maintain the
codebase we've spent quite some time writing, and maintain our own tree for
it, which we'll be submitting through Greg. In other words, this is not
a matter of "circumvention" or "stepping on toes", but rather separate
efforts. I'm quite certain to the extent they overlap we'll be able to work
out fairly easily.

Either way, I'll take your suggestion and reach out to Herbert, since at
least a discussion between the two of us sounds like it could be productive.

> I'm also wondering about the criteria for making additions and changes to
> "Zinc".  You mentioned before that one of the "advantages" of Zinc is that it
> doesn't include "cipher modes from 90s cryptographers" -- what does that mean
> exactly?  You've also indicated before that you don't want people modifying the
> Poly1305 implementations as they are too error-prone.  Useful contributions
> could be blocked or discouraged in the future. Can you please elaborate on
> your criteria for contributions to Zinc?
>
> Also, will you allow algorithms that aren't up to modern security standards but
> are needed for compatibility reasons, e.g. MD5, SHA-1, and DES?  There are
> existing standards, APIs, and data formats that use these "legacy" algorithms;
> so implementations of them are often still needed, whether we like it or not.
>
> And does it matter who designed the algorithms, e.g. do algorithms from Daniel
> Bernstein get effectively a free pass, while algorithms from certain countries,
> governments, or organizations are not allowed?  E.g. wireless driver developers
> may need the SM4 block cipher (which is now supported by the crypto API) as it's
> specified in a Chinese wireless standard.  Will you allow SM4 in Zinc?  Or will
> people have to submit some algorithms to Herbert and some to you due to
> disagreements about what algorithms should be included?

Similarly here, I think you're over-politicizing everything. Stable address
generation for IPv6 uses SHA1 -- see net/ipv6/addrconf.c:3203 -- do you think
that this should use, say, the SM3 chinese hash function instead? No, of
course not, for a variety of interesting reasons. Rather, it should use some
simple hash function that's fast in software that we have available in Zinc.
On the other hand, it seems like parts of the kernel that have pretty high-
levels of cipher agility -- such as dmcrypt, ipsec, wifi apparently, and
so on -- will continue to use dynamic-dispatch system like the crypto API,
since that's what it was made to do and is effective at doing. And so, your
example of SM4 seems to fit perfectly into what the crypto API is well-suited
for, and it would fit naturally in there.

In other words, the "political criteria" for what we add to lib/zinc/ will
mostly be the same as for the rest of lib/: are there things using it that
benefit from it being there in a direct and obvious way, and does the
implementation meet certain quality standards.

> to change them yourself, e.g. when you added the part that converts the
> accumulator from base 26 to base 32.  I worry there may be double standards
> here

We do actually appreciate your concern here. However, there's a lot more that
went into that short patch than meets the eye:

  - It matches exactly what Andy Polyakov's code is doing for the exact
    same reason, so this isn't something that's actually "new". (There
    are paths inside his implementation that branch from the vector code
    to the scalar code.)
  - It has been discussed at length with Andy, including what kinds of
    proofs we'll need if we want to chop it down further (to remove that
    final reduction), and why we both don't want to do that yet, and so
    we go with the full carrying for the avoidance of risk.
  - We've proved its correctness with Z3, actually using an even looser
    constraint on digit size than what Andy mentioned to us, thus resulting
    in a stronger proof result. So we're certain this isn't rubbish.
  - There's been some considerable computing power sunk into fuzzing it.

There's no doubt about it, we've done our due-diligence here. This is in
fact the kind of efforts we require of submissions. You could fault us for
not detailing this in "the commit message" -- except as this is still a
patch series, we're putting improvements into the 00/XX change log, instead
of adding fixes and additions on top of the series. Of course in the ordinary
course of kernel development, this would exist instead as a standalone commit.
If you have a better idea of how this kind of thing can be communicated, and
where precisely, in the pre-merge process, I'd be interested in hearing
suggestions.

Thanks,
Jason
