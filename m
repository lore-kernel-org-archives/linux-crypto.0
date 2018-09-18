From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: Re: [PATCH net-next v3 02/17] zinc: introduce minimal cryptography
 library
Date: Tue, 18 Sep 2018 22:36:59 +0200
Message-ID: <20180918203658.GA28723@zx2c4.com>
References: <20180911214737.GA81235@gmail.com>
 <CAHmME9rFUruF-VN1pmU-k5nFsb9ppAPhPpW-5Ho9dKL2HCg4kA@mail.gmail.com>
 <20180911233015.GD11474@lunn.ch>
 <20180911.165739.2032677219588723041.davem@davemloft.net>
 <CALCETrXrJPcs3h9CtF50N4k2AGx3qzspJd_UW3t+KGYOj7+p=Q@mail.gmail.com>
 <CAKv+Gu8QgRo-Oex2Sk5unET3FMq+1Cp2btAWXCB8xsALxjatHg@mail.gmail.com>
 <CAHmME9qwRzuoo-3Hxahwu=Li2LCz06Uowaq1GFmkts6tsffM7w@mail.gmail.com>
 <CAKv+Gu8OKyVvvgLy48GDV2KJt-UmmHbf5x0qNxQC_SDiddb9-g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Cc: Andrew Lutomirski <luto@kernel.org>,
        David Miller <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Eric Biggers <ebiggers@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>, Samuel Neves <sneves@dei.uc.pt>,
        Jean-Philippe Aumasson <jeanphilippe.aumasson@gmail.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAKv+Gu8OKyVvvgLy48GDV2KJt-UmmHbf5x0qNxQC_SDiddb9-g@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi Ard,

On Tue, Sep 18, 2018 at 11:53:11AM -0700, Ard Biesheuvel wrote:
> On 17 September 2018 at 08:52, Jason A. Donenfeld <Jason@zx2c4.com> wrote:
> > Hi Ard,
> >
> 
> Given that you show no interest whatsoever in gaining an understanding
> of the underlying requirements that we have to deal with in the crypto
> API, the only way to get my point across is by repeatedly stating it

Sorry if I've come across that way, but I am certainly interested in
gaining such an understanding of said requirements.

> I have pointed out to you numerous times (as has Eric) that the
> ChaCha20 ARM code you are importing from the OpenSSL project has been
> found to be slower on Cortex-A7, which represents the vast majority of
> devices expected to be in the field in 1~2 years.

I mentioned in the other thread that I intend immanently to begin
benching on a variety of ARM boards, and I should have numbers and
results and conclusions somewhat soon for the list.

My initial notion here was that it'd be better to go with AndyP's code
no matter what, and then later work with him on contributing said
improvements, and then port these back to the kernel. However, you and
Andy made a compelling point about code replacement -- that it's okay to
replace all in one go only if there are positive benchmark results. So I
think what I'll do to appease this is -- if the benchmarks are indeed
how Eric suggested -- stick with your faster code, and then follow up
with replacement plans after the merge. (I feel a bit more comfortable
with varying ChaCha code, because implementations tend to be pretty
straight forward and harder to screw up in subtle ways than, say,
poly1305 or curve25519.)

> have asked you more than once to split out your changes to the
> upstream OpenSSL code into separate patches so we can more easily
> track them, but v5 now puts them in the commit log (again) [but in a
> corrupted way - the preprocessor directives are filtered out by
> git-commit], which means we cannot use git diff/blame etc to look at
> them.

Didnt't realize this was so important to you. It's trivial to do, so
I'll do that for AndyP's implementations for the next revision.


> Upstreaming code is about taking an interest in other people's use
> cases, and about choosing your battles. It is unfortunate that we have
> spent all this time talking about a couple of crypto routines, while
> the actual meat of your submission is in WireGuard itself, which I'm
> sure you much rather talk about.

I don't find it unfortunate; getting the crypto right is of the utmost
importance.

Regards,
Jason
