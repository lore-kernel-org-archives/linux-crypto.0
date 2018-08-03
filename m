From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: Re: [PATCH v1 2/3] zinc: Introduce minimal cryptography library
Date: Fri, 3 Aug 2018 04:33:50 +0200
Message-ID: <CAHmME9pbwj0RaX4YM9epGOSgDRNUt=GA4UzO_iKcW=Md7kG6JQ@mail.gmail.com>
References: <20180801072246.GA15677@sol.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Andrew Lutomirski <luto@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Samuel Neves <sneves@dei.uc.pt>,
        "Daniel J . Bernstein" <djb@cr.yp.to>,
        Tanja Lange <tanja@hyperelliptic.org>,
        Jean-Philippe Aumasson <jeanphilippe.aumasson@gmail.com>,
        Karthikeyan Bhargavan <karthik.bhargavan@gmail.com>
To: Eric Biggers <ebiggers3@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180801072246.GA15677@sol.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi Eric,

Thanks for your feedback. Responses below.

On Wed, Aug 1, 2018 at 9:22 AM Eric Biggers <ebiggers3@gmail.com> wrote:
> it's intended that the "Zinc" algorithms will be exposed through the
> crypto API -- just like how most of the existing crypto code in lib/ is
> also exposed through the crypto API.  So, I think that what you're doing
> isn't actually *that* different from what already exists in some cases;
> and pretending that it is very different is just going to cause
> problems.

I think as an eventual thing, it'd be great to see the whole of the
software part of the Crypto API rebased ontop of Zinc's software
implementations. But the Cryto API is huge, and it's not really
realistic to do this all at once. I'd also like to have a bit more
scrutiny of each individual Zinc submission, rather than just dumping
it all in there wholesale. Additionally, it seems reasonable to do
this in accordance with actual need for using the algorithms from
Zinc, i.e., not rushing toward DES.

> Rather, the actual truly new thing seems to be that the [...]
> [...] are part of some holy crusade against the crypto API.
> So much for WireGuard being only

I sense a bit of snark in your comments, and I am sorry if I ruffled
some feathers. I can understand a number of things might have rubbed
you the wrong way. But I am pretty committed to getting this done
right, taking into account your and Andy's opinions, as well as
working hard to keep Zinc close to its design goals. I think you'll
find we're closer to being on the same page than not, and that I only
want to make things better rather than be on some kind of "crusade"
against anything.

> They could even still go in subdirectory lib/crypto/ -- but just for
> logical code organization purposes,

Indeed a subdirectory is important for organization. We can bikeshed
about names, I suppose. I'm partial zinc, and I think that it might
actually help foster contributors and interested academics. Anyway,
let's dive into the code issues first, though, as I think that'll be a
productive way to get going.

> CONFIG_ZINC also needs to go.  Algorithms will need to be independently
> configurable as soon as anything other than WireGuard needs to use any
> of them, so you might as well do it right from the start with
> CONFIG_BLAKE2, CONFIG_CHACHA20, CONFIG_POLY1305, etc.

Okay, I can add this all as individual nobs. I'll do that for v2.

I'm tempted to still have this built as one module, though. For
example, should WireGuard depend on 5 mini-modules (blake2s, chacha20,
poly1305, chacha20poly1305, curve25519)? Rather, it seems a bit
sleeker to just have a single zinc.ko, and allow what's built into it
be configurable with the various algorithm configuration options. What
would you think of this? Or do you think you'd still prefer
one-algo-per-ko approach like with the current crypto API? I can see
good arguments both ways.

> I think the above changes would also naturally lead to a much saner
> patch series where each algorithm is added by its own patch, rather than
> one monster patch that adds many algorithms and 24000 lines of code.

Yes, absolutely! And sorry for that monster patch; it even got
rejected from LKML as you pointed out. I had started to split things
up, but I wanted to send the patchset foremost to netdev, to start
getting some feedback on WireGuard, and wanted to keep the
organization simple. I'll have this split up for v2.

>
> Note that adding all the algorithms in one patch also makes the
> description of them conflated, e.g. you wrote that "formally verified"
> implementations were used whenever possible, but AFAICS that actually
> only applies to the C implementations of Curve25519,

Yes, the commit message mentioned which implementations have been
verified. It's quite likely that in the near future we'll be adding
more formally verified implementations, and even formally verified
assembly implementations. While BLAKE2s and ChaCha20 are somewhat
straight forward, bigint stuff, such as Curve25519 and Poly1305,
always make me a bit nervous, and so we'll probably be additionally
incorporating a formally verified Poly1305 first of the bunch.

Either way, _all_ of those implementations have been reviewed in some
depth, fuzzed absurd amounts, and fed some pretty nasty test vectors.
I've spent a lot of time with all of them, and most have received a
good amount of external scrutiny, due to their origin.

> So, I'd strongly prefer that you don't oversell the crypto
> code you're adding, e.g. by implying that most of it is formally
> verified, as it likely still has bugs, like any other code...

This sounds like snark that's going to devolve into endless
bikeshedding, but I do note that I mentioned formally verified
implementations in these 3 contexts, which I think were appropriate
each time:

1) "Wherever possible and performant, formally verified
implementations are used, such as those from HACL* and Fiat-Crypto."

So, trying to state that we use it when we can, but we can't always. I
think it's important to mention it here, as already, I've been
contacted by formal verification people who are already eager to help.
This is exactly the kind of positive outcome I was hoping for.

2) "Curve25519: formally verified 64-bit C, formally verified 32-bit C, [...]"

Pointing out that these 2 implementations, in contradistinction to the
subsequent ones listed, are from formally verified C.

3) "potentially replacing them with either formally-verified
implementations [...]"

Again here, I indicate that I'd like to replace non formally-verified
implementations with formally-verified implementations wherever
there's such a potentiality. And like the previous comment, I believe
this has been interpreted as a welcome call to action by the people
who are actually working on this stuff.

So I don't think I'm "over selling" it. Formal verification is a good
thing. We have a little bit of it in Zinc. I'd like to have a lot more
of it. And all the while we're doing the best with what we've got.

Generally speaking, I believe the choices I've made on the individual
implementations in this submission have been made with a lot of care,
and I'm happy to work with you on any concerns you have about them and
do what's needed to get them in the proper shape.

> I also want to compare the performance of some of the assembly
> implementations you're adding to the existing implementations in the
> kernel they duplicate.  I'm especially interested in the NEON
> implementation of ChaCha20.  But adding 11 implementations in one single
> patch means there isn't really a chance to comment on them individually.

As noted, I'll certainly split this up for v2. With ChaCha20, my
benchmarks have indicated Zinc is faster than the Crypto API's
implementations. But there's also another benefit: the ChaCha20 and
Poly1305 implementations are based on Andy Polyakov's ones, which
means they benefit from the *huge* amount of scrutiny those have
already received and continue to receive. In fact, there are people
working on doing formally verified reproductions of some of his
implementations, and that alone is hugely valuable. The
implementations generally found in Linux haven't received nearly as
much scrutiny and attention, putting them at a bit of a disadvantage,
I think. In other words, there's a strong benefit from working
together and sharing in the enterprise with other projects.

There's another plus, too, which is that they all have a very common
interface, making the glue code simpler and more uniform. This is
probably mostly just a benefit for me, as a lazy coder who would
prefer an easier job, but usually less complexity and fewer
differences results in fewer bugs, too.

> Also, earlier when I tested OpenSSL's ChaCha NEON implementation on ARM
> Cortex-A7 it was actually quite a bit slower than the one in the Linux
> kernel written by Ard Biesheuvel... I trust that when claiming the
> performance of all implementations you're adding is "state-of-the-art
> and unrivaled", you actually compared them to the ones already in the
> Linux kernel which you're advocating replacing, right? :-)

Yes, I have, and my results don't corroborate your findings. It will
be interesting to get out a wider variety of hardware for comparisons.
I suspect, also, that if the snarky emoticons subside, AndyP would be
very interested in whatever we find and could have interest in
improving implementations, should we actually find performance
differences.

> Your patch description is also missing any mention of crypto accelerator
> hardware.  Quite a bit of the complexity in the crypto API, such as
> scatterlist support and asynchronous execution, exists because it
> supports crypto accelerators.

I can augment that description, if you like, for v2. But with regards
to crypto accelerators -- I think the asynchronous API causes all
sorts of problems for some of the most common use cases, and so Zinc
is a software-based ordinary synchronous API. I think this is an
advantage. Of course you can continue to support wild async IPSec
accelerator hardware and such in the crypto API, but that's
intentionally not the focus of Zinc.


> I assume your justification is that "djb algorithms" like
> But you never explicitly stated this and discussed the
> tradeoffs.

It was already a pretty huge wall of text in the monster patch, but
even so there's probably tons of discussion about different details,
both large and small, that I must have left out. Sorry about that.
Hopefully these discussions here can help fill them in.

> The main problem, though, is that your code is a mess due to all
> the #ifdefs, and it will only get worse as people add more
> architectures.

I really thought the ifdefs were cleaner than the three other ways I
have implemented for doing it. When I showed this all to Greg KH
several months ago, he also thought the ifdefs were disgusting. It
seems you agree with him, and I'll certainly change this for v2. I
already have most of that code written, and based on your comments and
suggestions below, I'm sure you'll find it much better.

> Note that this
> would make the code much more consistent with the usual Linux kernel
> coding style, which strongly prefers calling functions unconditionally
> rather than having core logic littered with unmaintainable #ifdefs.

Noted. Will be changed.

> I'd also strongly prefer the patchset to include converting the crypto
> API versions of ChaCha20 and Poly1305 over to use your new lib/ code, to
> show that it's really possible.  You mentioned that it's planned, but if
> it's not done right away there will be things that were missed and will
> require changes when someone finally does it.  IMO it's not acceptable
> to add your own completely separate ChaCha20 and Poly1305 just because
> you don't like that the existing ones are part of the crypto API.

Alright. I didn't really want to do this right off the bat, but you
make a good argument that doing so is important in working out the
required details of just knowing how it's done. So I'll take a stab at
it for v2. I'll let you know if I run into any snags; we might be able
to collaborate nicely here.

> You
> need to refactor things properly.  I think you'd need to expose the new
> code under a cra_driver_name like "chacha20-software" and
> "poly1305-software" to reflect that they use the fastest available
> implementation of the algorithm on the CPU, e.g. "chacha20-generic",
> "chacha20-neon", and "chacha20-simd" would all be replaced by a single
> "chacha20-software".  Is that what you had in mind?

Calling it "chacha20-software" sounds like a reasonable way to name it.

>
> I'm also wondering about the origin and licensing of some of the
> assembly language files.  Many have an OpenSSL copyright statement.
> But, the OpenSSL license is often thought to be incompatible with GPL,
> so using OpenSSL assembly code in the kernel has in the past required
> getting special permission from Andy Polyakov (the person who's written
> most of OpenSSL's assembly code so holds the copyright on it).  As one
> example, see arch/arm/crypto/sha256-armv4.pl: the file explicitly states
> that Andy has relicensed it under GPLv2.  For your new OpenSSL-derived
> files, have you gone through and explicitly gotten GPLv2 permission from
> Andy / the copyright holders?

Andy and I spoke in January about this and he was okay with the usual
CRYPTOGAMS GPLv2 origin dance for that code.

> For example lib/zinc/curve25519/curve25519-arm.S has your
> copyright statement and says it's "Based on algorithms from Daniel J.
> Bernstein and Peter Schwabe.", but it's not clarified whether the *code*
> was written by those other people, as opposed to those people designing
> the *algorithms* and then you writing the code; and if you didn't write
> it, where you retrieved the file from and when, what license it had
> (even if it was "public domain" like some of djb's code, this should be
> mentioned for informational purposes), and what changes you made if any.

It's indeed based on their public domain code. I'll change that
wording to make it very clear that it's from public domain code.

> Oh, and please use 80-character lines like the rest of the kernel, so
> that people's eyes don't bleed when reading your code :-)

Ack. Will be so in v2.

>
> Thanks for all your hard work on WireGuard!

Thanks for your excellent review. I really appreciate it you taking
the time. Hopefully v2 will start looking a lot more interesting to
you!

Regards,
Jason
