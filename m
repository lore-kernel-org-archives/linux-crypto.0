From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: [PATCH net-next v5 07/20] zinc: Poly1305 generic C implementations and selftest
Date: Tue, 18 Sep 2018 21:13:04 -0700
Message-ID: <BF781C43-52C2-410A-A6D0-AAD0AC998C2D@amacapital.net>
References: <20180918161646.19105-1-Jason@zx2c4.com> <20180918161646.19105-8-Jason@zx2c4.com> <20180919005054.GC74746@gmail.com> <CAHmME9oL98adRp6xXqaXxA0E4Oa4ecPW+JHChCS3hTgH7RLPjA@mail.gmail.com>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain;
        charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Cc: Eric Biggers <ebiggers@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Samuel Neves <sneves@dei.uc.pt>,
        Andrew Lutomirski <luto@kernel.org>,
        Jean-Philippe Aumasson <jeanphilippe.aumasson@gmail.com>
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAHmME9oL98adRp6xXqaXxA0E4Oa4ecPW+JHChCS3hTgH7RLPjA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org


> On Sep 18, 2018, at 6:35 PM, Jason A. Donenfeld <Jason@zx2c4.com> wrote:
>=20
>> On Wed, Sep 19, 2018 at 2:50 AM Eric Biggers <ebiggers@kernel.org> wrote:=

>> Hardcoding the 'input' array to 600 bytes forces the full amount of space=
 to be
>> reserved in the kernel image for every test vector.  Also, if anyone adds=
 a
>> longer test vector they will need to remember to increase the value.
>>=20
>> It should be a const pointer instead, like the test vectors in crypto/tes=
tmgr.h.
>=20
> I know. The agony. This has been really annoying me. I originally did
> it the right way, but removed it last week, when I noticed that gcc
> failed to put it in the initconst section:
>=20
> https://git.zx2c4.com/WireGuard/commit/?id=3Df4698d20f13946afc6ce99e98685b=
a3f9adc4474
>=20
> Even changing the (u8[]){ ... } into a (const u8[]){ ... } or even
> into a const string literal does not do the trick. It makes it into
> the constant data section with const, but it does not make it into the
> initconst section. What a bummer.
>=20
> I went asking about this on the gcc mailing list, to see if there was
> just some aspect of C that I had overlooked:
> https://gcc.gnu.org/ml/gcc/2018-09/msg00043.html

Can you not uglify the code a bit by using normal (non-compound) liberals as=
 described in the response to that email?
