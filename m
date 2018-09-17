From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: [PATCH net-next v3 02/17] zinc: introduce minimal cryptography library
Date: Mon, 17 Sep 2018 09:18:32 -0700
Message-ID: <63AAE78E-25D7-46E7-84AB-5D0DFD0F1BF2@amacapital.net>
References: <20180911214737.GA81235@gmail.com> <CAHmME9rFUruF-VN1pmU-k5nFsb9ppAPhPpW-5Ho9dKL2HCg4kA@mail.gmail.com> <20180911233015.GD11474@lunn.ch> <20180911.165739.2032677219588723041.davem@davemloft.net> <CALCETrXrJPcs3h9CtF50N4k2AGx3qzspJd_UW3t+KGYOj7+p=Q@mail.gmail.com> <CAKv+Gu8QgRo-Oex2Sk5unET3FMq+1Cp2btAWXCB8xsALxjatHg@mail.gmail.com> <35BC21D7-01F4-4F91-A7E9-8D15DE5B95D6@amacapital.net> <CAHmME9o2sB-rQo0DRh56AFe7ZLJJh+CU6Z1m5XZ4tA8vATCy1g@mail.gmail.com> <CALCETrWHWZibRev=hZeE1_YFjktnpV9VBN_QmvHJfakb-saRuA@mail.gmail.com> <CAHmME9o+Q25t8c2Yk5_5ob2yJsu=7OA7WeAM71S5krP8KMY5GQ@mail.gmail.com>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain;
        charset=utf-8
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
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAHmME9o+Q25t8c2Yk5_5ob2yJsu=7OA7WeAM71S5krP8KMY5GQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org



> On Sep 17, 2018, at 9:16 AM, Jason A. Donenfeld <Jason@zx2c4.com> wrote:
>=20
>> On Mon, Sep 17, 2018 at 6:14 PM Andy Lutomirski <luto@amacapital.net> wro=
te:
>> Indeed.  What I'm saying is that you shouldn't refactor it this way
>> because it will be slow.  I agree it would be conceptually nice to be
>> able to blacklist a chacha20_x86_64 module to disable the asm, but I
>> think it would be very hard to get good performance.
>=20
> I hadn't understood your nosimd=3D1 command line suggestion the first
> time through, but now I see what you were after. This would be really
> easy to add. And I can do it for v5 if you want. But I'm kind of loath
> to add too much stuff to the initial patchset. Do you think this is an
> important feature to have for it? Or should I leave it for later?

I think it=E2=80=99s fine for later. It=E2=80=99s potentially useful for ben=
chmarking and debugging.=
