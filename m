From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: [PATCH net-next v3 02/17] zinc: introduce minimal cryptography library
Date: Tue, 11 Sep 2018 16:01:19 -0700
Message-ID: <2E01FBB6-030A-40AB-8BEE-F8F271A57568@amacapital.net>
References: <20180911010838.8818-1-Jason@zx2c4.com> <20180911010838.8818-3-Jason@zx2c4.com> <CAKv+Gu9nSeo4PFVrtjtqGQ32eqyxUp3xVCczZfu+dhFz5yLM0A@mail.gmail.com> <20180911145624.GA21635@kroah.com> <20180911214737.GA81235@gmail.com> <49BAF465-B3DC-4155-BFF9-DB6C386C1878@amacapital.net> <CAHmME9q+mqT+vtM1FdBvf8=nAFu=u+wN48sOxqLcFthxYVn7NQ@mail.gmail.com>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain;
        charset=utf-8
Content-Transfer-Encoding: quoted-printable
Cc: Eric Biggers <ebiggers@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Andrew Lutomirski <luto@kernel.org>,
        Samuel Neves <sneves@dei.uc.pt>,
        Jean-Philippe Aumasson <jeanphilippe.aumasson@gmail.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAHmME9q+mqT+vtM1FdBvf8=nAFu=u+wN48sOxqLcFthxYVn7NQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org



> On Sep 11, 2018, at 3:18 PM, Jason A. Donenfeld <Jason@zx2c4.com> wrote:
>=20
>> On Tue, Sep 11, 2018 at 4:16 PM Andy Lutomirski <luto@amacapital.net> wro=
te:
>> Jason, can you do one of these conversions as an example?
>=20
> My preference is really to leave that to a different patch series. But
> if you think I *must*, then I shall.
>=20
>=20

I think Ard=E2=80=99s point is valid: in the long run we don=E2=80=99t want t=
wo competing software implementations of each primitive. It clearly *should*=
 be possible to make crypto API call into zinc for synchronous software oper=
ations, but a demonstration of how this actually works and that there isn=E2=
=80=99t some change to zinc to make it would well would be in order, I think=
.

IMO the right approach is do one conversion right away and save the rest for=
 later.=
