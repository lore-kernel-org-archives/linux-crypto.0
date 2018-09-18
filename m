From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH net-next v3 02/17] zinc: introduce minimal cryptography library
Date: Tue, 18 Sep 2018 11:53:11 -0700
Message-ID: <CAKv+Gu8OKyVvvgLy48GDV2KJt-UmmHbf5x0qNxQC_SDiddb9-g@mail.gmail.com>
References: <20180911214737.GA81235@gmail.com> <CAHmME9rFUruF-VN1pmU-k5nFsb9ppAPhPpW-5Ho9dKL2HCg4kA@mail.gmail.com>
 <20180911233015.GD11474@lunn.ch> <20180911.165739.2032677219588723041.davem@davemloft.net>
 <CALCETrXrJPcs3h9CtF50N4k2AGx3qzspJd_UW3t+KGYOj7+p=Q@mail.gmail.com>
 <CAKv+Gu8QgRo-Oex2Sk5unET3FMq+1Cp2btAWXCB8xsALxjatHg@mail.gmail.com> <CAHmME9qwRzuoo-3Hxahwu=Li2LCz06Uowaq1GFmkts6tsffM7w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Andrew Lutomirski <luto@kernel.org>,
        David Miller <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Eric Biggers <ebiggers@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>, Samuel Neves <sneves@dei.uc.pt>,
        Jean-Philippe Aumasson <jeanphilippe.aumasson@gmail.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAHmME9qwRzuoo-3Hxahwu=Li2LCz06Uowaq1GFmkts6tsffM7w@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 17 September 2018 at 08:52, Jason A. Donenfeld <Jason@zx2c4.com> wrote:
> Hi Ard,
>
> On Mon, Sep 17, 2018 at 7:26 AM Ard Biesheuvel
> <ard.biesheuvel@linaro.org> wrote:
>> OK, so let me summarize my remaining concerns as well. I may be a bit
>> more finicky than Andy, though.
>
> Yes, and generally hostile to this whole initiative since the
> beginning. But I am very grateful for your reviews nonetheless, and
> I'll do my best to incorporate as much as is reasonable.
>
>> I would like to urge Jason to
>> bear with us and bring this discussion to a close before resubmitting.
>
> What I fear is that either:
> - You don't like the Zinc initiative in one way or another, and the
> desire to "keep discussing" and adding more things is less out of
> their necessity and more out of a desire to stall it indefinitely.
> - You're going to bikeshed and bikeshed and waste tons of time until
> Zinc copies lots of the same design decisions from the present crypto
> API.
>

Given that you show no interest whatsoever in gaining an understanding
of the underlying requirements that we have to deal with in the crypto
API, the only way to get my point across is by repeatedly stating it
in response to your patches. Also, sending out a new series each time
with only half of the review comments addressed doesn't make me a
bikeshedder.

> I do sincerely hope these are only fears and not what actually is
> going on. I'll do my best to take into serious consideration what you
> say -- many are indeed extremely helpful --  but I certainly won't be
> wholesale accepting all the things you've mentioned.
>

I have pointed out to you numerous times (as has Eric) that the
ChaCha20 ARM code you are importing from the OpenSSL project has been
found to be slower on Cortex-A7, which represents the vast majority of
devices expected to be in the field in 1~2 years. Yet, we are at the
fifth revision now where you are replacing the existing code. Also, I
have asked you more than once to split out your changes to the
upstream OpenSSL code into separate patches so we can more easily
track them, but v5 now puts them in the commit log (again) [but in a
corrupted way - the preprocessor directives are filtered out by
git-commit], which means we cannot use git diff/blame etc to look at
them.

Upstreaming code is about taking an interest in other people's use
cases, and about choosing your battles. It is unfortunate that we have
spent all this time talking about a couple of crypto routines, while
the actual meat of your submission is in WireGuard itself, which I'm
sure you much rather talk about.



>> * simd_relax() is currently not called by the crypto routines
>> themselves. This means that the worst case scheduling latency is
>> unbounded, which is unacceptable for the -rt kernel. The worst case
>> scheduling latency should never be proportional to the input size.
>> (Apologies for not spotting that earlier)
>
> Good catch. I actually did this correct when porting the crypto API to
> use Zinc (in those later top commits in v4), but I hadn't in the Zinc
> code itself. I'll address this for v5.
>
>> maintainership
>> responsibilities
>
> Samuel and I intend to maintain Zinc in lib/zinc/ and send future
> updates to it through Greg's tree, as mentioned in the 00/ cover
> letter. The maintainership of the existing crypto API won't change.
>
>> * The current organization of the code puts all available (for the
>> arch) versions of all routines into a single module, which can only be
>> built in once we update random.c to use Zinc's chacha20 routines. This
>> bloats the core kernel (which is a huge deal for embedded systems that
>> have very strict boot requirements).
>
> I'll split each Zinc primitive into a separate module for v5, per your
> and Andy's desire. And the SIMD code is already toggle-able via a
> Kconfig menu option.
>
>> we should
>> work with Andy Polyakov (as I have done several times over the past 5+
>> years) to upstream the changes we apply to the kernel version of the
>> code.
>
> Indeed this is the intent.
>
>> The same applies to code from other sources, btw, but I am not
>> personally familiar with them.
>
> Good news on this front:
> - Rene wrote the MIPS code specifically for WireGuard, so that _is_ upstream.
> - Samuel wrote the BLAKE2 assembly, and he's the co-maintainer of Zinc with me.
> - I talk to Dan and Peter a decent amount about qhasm.
> - I'm in very close contact with the team behind HACL*, and they're
> treating Zinc as a target -- stylistically and with regards to kernel
> requirements -- which means they're looking at what's happening in
> this patchset and adjusting accordingly.
>
>
>> * If upstreaming the changes is not an option, they should be applied
>> as a separate patch and not hidden in a 5000 line patch without any
>> justification or documentation (but Jason is already working on that)
>
> Indeed this is already underway.
>
> Thanks again for your review.
>
> Jason
