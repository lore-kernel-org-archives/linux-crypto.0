From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: [PATCH net-next v3 02/17] zinc: introduce minimal cryptography library
Date: Mon, 17 Sep 2018 07:53:56 -0700
Message-ID: <8937D6B1-D21C-4C47-8A89-A466CDB6FB04@amacapital.net>
References: <20180911214737.GA81235@gmail.com> <CAHmME9rFUruF-VN1pmU-k5nFsb9ppAPhPpW-5Ho9dKL2HCg4kA@mail.gmail.com> <20180911233015.GD11474@lunn.ch> <20180911.165739.2032677219588723041.davem@davemloft.net> <CALCETrXrJPcs3h9CtF50N4k2AGx3qzspJd_UW3t+KGYOj7+p=Q@mail.gmail.com> <CAHmME9ohGPTX-fkhP6zaWdx3SbkiqO5kWkWE-bDk=pm-nUqYvw@mail.gmail.com>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain;
        charset=utf-8
Content-Transfer-Encoding: quoted-printable
Cc: Andrew Lutomirski <luto@kernel.org>,
        David Miller <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Eric Biggers <ebiggers@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>, Samuel Neves <sneves@dei.uc.pt>,
        Jean-Philippe Aumasson <jeanphilippe.aumasson@gmail.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAHmME9ohGPTX-fkhP6zaWdx3SbkiqO5kWkWE-bDk=pm-nUqYvw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org




> On Sep 16, 2018, at 10:07 PM, Jason A. Donenfeld <Jason@zx2c4.com> wrote:
>=20
> Hey Andy,
>=20
> Thanks a lot for your feedback.
>=20
>> On Mon, Sep 17, 2018 at 6:09 AM Andy Lutomirski <luto@kernel.org> wrote:
>> 1. Zinc conflates the addition of a new API with the replacement of
>> some algorithm implementations.  This is problematic.  Look at the
>> recent benchmarks of ipsec before and after this series.  Apparently
>> big packets get faster and small packets get slower.  It would be
>> really nice to bisect the series to narrow down *where* the regression
>> came from, but, as currently structured, you can't.
>>=20
>> The right way to do this is to rearrange the series.  First, the new
>> Zinc APIs should be added, and they should be backed with the
>> *existing* crypto code.  (If the code needs to be moved or copied to a
>> new location, so be it.  The patch will be messy because somehow the
>> Zinc API is going to have to dispatch to the arch-specific code, and
>> the way that the crypto API handles it is not exactly friendly to this
>> type of use.  So be it.)  Then another patch should switch the crypto
>> API to use the Zinc interface.  That patch, *by itself*, can be
>> benchmarked.  If it causes a regression for small ipsec packets, then
>> it can be tracked down relatively easily.  Once this is all done, the
>> actual crypto implementation can be changed, and that changed can be
>> reviewed on its own merits.
>=20
> That ipsec regression was less related to the implementation and more
> related to calling kernel_fpu_begin() unnecessarily, something I've
> now fixed. So I'm not sure that's such a good example. However, I can
> try to implement Zinc over the existing assembly (Martin's and Ard's),
> first, as you've described. This will be a pretty large amount of
> work, but if you think it's worth it for the commit history, then I'll
> do it.

Ard, what do you think?  I think it would
be nice, but if the authors of that assembly are convinced it should be repl=
aced, then this step is optional IMO.

>=20
>> 2. The new Zinc crypto implementations look like they're brand new.  I
>> realize that they have some history, some of them are derived from
>> OpenSSL, etc, but none of this is really apparent in the patches
>> themselves.
>=20
> The whole point of going with these is that they _aren't_ brand new,
> yet they are very fast. Eyeballs and fuzzer hours are important, and
> AndyP's seems to get the most eyeballs and fuzzer hours, generally.
>=20
>> it would be nice if
>> the patches made it more clear how the code differs from its origin.
>> At the very least, though, if the replacement of the crypto code were,
>> as above, a patch that just replaced the crypto code, it would be much
>> easier to review and benchmark intelligently.
>=20
> You seem to have replied to the v3 thread, not the v4 thread. I've
> already started to include lots of detail about the origins of the
> code and [any] important differences in v4, and I'll continue to add
> more detail for v5.

This is indeed better.  Ard=E2=80=99s reply covers this better.
