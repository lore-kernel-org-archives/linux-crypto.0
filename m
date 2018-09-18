From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: Re: [PATCH net-next v3 02/17] zinc: introduce minimal cryptography library
Date: Tue, 18 Sep 2018 02:56:18 +0200
Message-ID: <CAHmME9pdesobgG=AeZ74Rb+aJ-gGDEYj624MnYDz-A=w9fkiYA@mail.gmail.com>
References: <20180911214737.GA81235@gmail.com> <CAHmME9rFUruF-VN1pmU-k5nFsb9ppAPhPpW-5Ho9dKL2HCg4kA@mail.gmail.com>
 <20180911233015.GD11474@lunn.ch> <20180911.165739.2032677219588723041.davem@davemloft.net>
 <CALCETrXrJPcs3h9CtF50N4k2AGx3qzspJd_UW3t+KGYOj7+p=Q@mail.gmail.com>
 <CAKv+Gu8QgRo-Oex2Sk5unET3FMq+1Cp2btAWXCB8xsALxjatHg@mail.gmail.com>
 <35BC21D7-01F4-4F91-A7E9-8D15DE5B95D6@amacapital.net> <CAHmME9o2sB-rQo0DRh56AFe7ZLJJh+CU6Z1m5XZ4tA8vATCy1g@mail.gmail.com>
 <CALCETrWHWZibRev=hZeE1_YFjktnpV9VBN_QmvHJfakb-saRuA@mail.gmail.com>
 <CAHmME9o+Q25t8c2Yk5_5ob2yJsu=7OA7WeAM71S5krP8KMY5GQ@mail.gmail.com> <63AAE78E-25D7-46E7-84AB-5D0DFD0F1BF2@amacapital.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Andrew Lutomirski <luto@kernel.org>,
        David Miller <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Eric Biggers <ebiggers@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>, Samuel Neves <sneves@dei.uc.pt>,
        Jean-Philippe Aumasson <jeanphilippe.aumasson@gmail.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Andy Lutomirski <luto@amacapital.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <63AAE78E-25D7-46E7-84AB-5D0DFD0F1BF2@amacapital.net>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hey Andy,

On Mon, Sep 17, 2018 at 6:18 PM Andy Lutomirski <luto@amacapital.net> wrote=
:
> I think it=E2=80=99s fine for later. It=E2=80=99s potentially useful for =
benchmarking and debugging.

I went ahead and added it anyway in the end. It was really quite easy
to do, and it sets a good template for future primitives that are
added to Zinc.

Meanwhile, I've fully triaged the regression Martin found, and in the
same test he performed, the Zinc code now runs faster than the old
code (which should be no surprise).

I've also finished getting rid of -include, per your suggestion, and
modularizing each algorithm to be loadable independently, per your
suggestion.

All and all, v5 is turning out really well, and I'll probably submit
it sometime soon. My tree was just added to the kbuild test bot, so
I'll hopefully get an email about any breakage *before* I submit this
time.

Regards,
Jason
