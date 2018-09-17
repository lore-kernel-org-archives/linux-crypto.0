From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH net-next v3 02/17] zinc: introduce minimal cryptography library
Date: Sun, 16 Sep 2018 22:26:21 -0700
Message-ID: <CAKv+Gu8QgRo-Oex2Sk5unET3FMq+1Cp2btAWXCB8xsALxjatHg@mail.gmail.com>
References: <20180911214737.GA81235@gmail.com> <CAHmME9rFUruF-VN1pmU-k5nFsb9ppAPhPpW-5Ho9dKL2HCg4kA@mail.gmail.com>
 <20180911233015.GD11474@lunn.ch> <20180911.165739.2032677219588723041.davem@davemloft.net>
 <CALCETrXrJPcs3h9CtF50N4k2AGx3qzspJd_UW3t+KGYOj7+p=Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Eric Biggers <ebiggers@kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Samuel Neves <sneves@dei.uc.pt>,
        Jean-Philippe Aumasson <jeanphilippe.aumasson@gmail.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Andy Lutomirski <luto@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CALCETrXrJPcs3h9CtF50N4k2AGx3qzspJd_UW3t+KGYOj7+p=Q@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 17 September 2018 at 06:09, Andy Lutomirski <luto@kernel.org> wrote:
> On Tue, Sep 11, 2018 at 4:57 PM David Miller <davem@davemloft.net> wrote:
>>
>> From: Andrew Lunn <andrew@lunn.ch>
>> Date: Wed, 12 Sep 2018 01:30:15 +0200
>>
>> > Just as an FYI:
>> >
>> > 1) I don't think anybody in netdev has taken a serious look at the
>> > network code yet. There is little point until the controversial part
>> > of the code, Zinc, has been sorted out.
>> >
>> > 2) I personally would be surprised if DaveM took this code without
>> > having an Acked-by from the crypto subsystem people. In the same way,
>> > i doubt the crypto people would take an Ethernet driver without having
>> > DaveM's Acked-by.
>>
>> Both of Andrew's statements are completely true.
>>
>> I'm not looking at any of the networking bits until the crypto stuff
>> is fully sorted and fully supported and Ack'd by crypto folks.
>
> So, as a process question, whom exactly are we waiting for:
>
> CRYPTO API
> M:      Herbert Xu <herbert@gondor.apana.org.au>
> M:      "David S. Miller" <davem@davemloft.net>
> L:      linux-crypto@vger.kernel.org
>
> Herbert hasn't replied to any of these submissions.  You're the other
> maintainer :)
>
> To the extent that you (DaveM) want my ack, here's what I think of the
> series so far:
>
> The new APIs to the crypto primitives are good.  For code that wants
> to do a specific known crypto operation, they are much, much more
> pleasant to use than the existing crypto API.  The code cleanups in
> the big keys patch speak for themselves IMO.  I have no problem with
> the addition of a brand-new API to the kernel, especially when it's a
> nice one like Zinc's, even if that API starts out with only a couple
> of users.
>
> Zinc's arrangement of arch code is just fine.  Sure, there are
> arguments that putting arch-specific code in arch/ is better, but this
> is mostly bikeshedding IMO.
>
> There has been some discussion of the exact best way to handle
> simd_relax() and some other minor nitpicks of API details.  This kind
> of stuff doesn't need to block the series -- it can always be reworked
> down the road if needed.
>
> There are two things I don't like right now, though:
>
> 1. Zinc conflates the addition of a new API with the replacement of
> some algorithm implementations.  This is problematic.  Look at the
> recent benchmarks of ipsec before and after this series.  Apparently
> big packets get faster and small packets get slower.  It would be
> really nice to bisect the series to narrow down *where* the regression
> came from, but, as currently structured, you can't.
>
> The right way to do this is to rearrange the series.  First, the new
> Zinc APIs should be added, and they should be backed with the
> *existing* crypto code.  (If the code needs to be moved or copied to a
> new location, so be it.  The patch will be messy because somehow the
> Zinc API is going to have to dispatch to the arch-specific code, and
> the way that the crypto API handles it is not exactly friendly to this
> type of use.  So be it.)  Then another patch should switch the crypto
> API to use the Zinc interface.  That patch, *by itself*, can be
> benchmarked.  If it causes a regression for small ipsec packets, then
> it can be tracked down relatively easily.  Once this is all done, the
> actual crypto implementation can be changed, and that changed can be
> reviewed on its own merits.
>
> As a simplistic example, I wrote this code a while back:
>
> https://git.kernel.org/pub/scm/linux/kernel/git/luto/linux.git/commit/?h=crypto/sha256_bpf&id=e9e12f056f2abed50a30b762db9185799f5864e6
>
> and its two parents.  This series added a more Zinc-like API to
> SHA256.  And it did it without replacing the SHA256 implementation.
> Doing this for Zinc would be a bit more complication, since the arch
> code would need to be invoked too, but it should be doable.
>
> FWIW, Wireguard should not actually depend on the replacement of the
> crypto implementation.
>
> 2. The new Zinc crypto implementations look like they're brand new.  I
> realize that they have some history, some of them are derived from
> OpenSSL, etc, but none of this is really apparent in the patches
> themselves.  It would be great if the kernel could literally share the
> same code as something like OpenSSL, since OpenSSL gets much more
> attention than the kernel's crypto.  Failing that, it would be nice if
> the patches made it more clear how the code differs from its origin.
> At the very least, though, if the replacement of the crypto code were,
> as above, a patch that just replaced the crypto code, it would be much
> easier to review and benchmark intelligently.
>

OK, so let me summarize my remaining concerns as well. I may be a bit
more finicky than Andy, though.

First of all, the rate at which new revisions of this series are
appearing increases the review effort unnecessarily, especially given
that the latest version seemed to have some issues that would have
been spotted by a simple build test. I would like to urge Jason to
bear with us and bring this discussion to a close before resubmitting.

As far as I can tell (i.e., as a user not a network dev), WireGuard is
an excellent piece of code, and I would like to see it merged. I also
think there is little disagreement about the quality of the proposed
algorithm implementations and the usefulness of having a set of easy
to use solid crypto primitives in addition to or complementing the
current crypto API.

I do have some concerns over how the code is organized though:

* simd_relax() is currently not called by the crypto routines
themselves. This means that the worst case scheduling latency is
unbounded, which is unacceptable for the -rt kernel. The worst case
scheduling latency should never be proportional to the input size.
(Apologies for not spotting that earlier)

* Using a cute name for the crypto library [that will end up being the
preferred choice for casual use only] may confuse people, given that
we have lots of code in crypto/ already. I'd much prefer using, e.g.,
crypto/lib and crypto/api (regardless of where the arch specific
pieces live)

* I'd prefer the arch specific pieces to live under arch, but I can
live with keeping them in a single place, as long as the arch
maintainers have some kind of jurisdiction over them. I also think
there should be some overlap between the maintainership
responsibilities of the two generic pieces (api and lib).

* (Nit) The GCC command line -include'd .h files contain variable and
function definitions so they are actually .c files.

* (Nit) Referencing CONFIG_xxx macros from -include'd files adds the
implicit assumption that the -include appears after the -include of
kconfig.h.

* Adding /conditional/ -include's (or #include's) increases the size
of the validation space, which is why we generally prefer
unconditional includes (and static inline stubs), and 'if
(IS_ENABLED(CONFIG_xxx))' over #ifdef CONFIG_xxx

* The current organization of the code puts all available (for the
arch) versions of all routines into a single module, which can only be
built in once we update random.c to use Zinc's chacha20 routines. This
bloats the core kernel (which is a huge deal for embedded systems that
have very strict boot requirements). It also makes it impossible to
simply blacklist a module if you, for instance, prefer to use the
[potentially more power efficient] scalar code over the SIMD code when
using a distro kernel.

[To summarize the 4 points above, I'd much rather see a more
conventional organization where different parts are provided by
different modules. I don't think the argument that inlining is needed
for performance is actually valid, given that we have branch
predictors and static keys, and the arch SIMD code is built as
separate object files anyway]

* If we reuse source files from OpenSSL, we should use that actual
source which is the perlasm not the emitted assembler. Also, we should
work with Andy Polyakov (as I have done several times over the past 5+
years) to upstream the changes we apply to the kernel version of the
code. The same applies to code from other sources, btw, but I am not
personally familiar with them.

* If upstreaming the changes is not an option, they should be applied
as a separate patch and not hidden in a 5000 line patch without any
justification or documentation (but Jason is already working on that)
