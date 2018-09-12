From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: Re: [PATCH net-next v3 02/17] zinc: introduce minimal cryptography library
Date: Tue, 11 Sep 2018 18:01:49 -0600
Message-ID: <CAHmME9om2rJONj6mMvSPHjiZDQKe05BCe=GonHN=c2Rg4n=pkg@mail.gmail.com>
References: <20180911010838.8818-1-Jason@zx2c4.com> <20180911010838.8818-3-Jason@zx2c4.com>
 <CAKv+Gu9nSeo4PFVrtjtqGQ32eqyxUp3xVCczZfu+dhFz5yLM0A@mail.gmail.com>
 <20180911145624.GA21635@kroah.com> <20180911214737.GA81235@gmail.com>
 <49BAF465-B3DC-4155-BFF9-DB6C386C1878@amacapital.net> <CAHmME9q+mqT+vtM1FdBvf8=nAFu=u+wN48sOxqLcFthxYVn7NQ@mail.gmail.com>
 <2E01FBB6-030A-40AB-8BEE-F8F271A57568@amacapital.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
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
To: Andy Lutomirski <luto@amacapital.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <2E01FBB6-030A-40AB-8BEE-F8F271A57568@amacapital.net>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi Andy,

On Tue, Sep 11, 2018 at 5:01 PM Andy Lutomirski <luto@amacapital.net> wrote=
:
> I think Ard=E2=80=99s point is valid: in the long run we don=E2=80=99t wa=
nt two competing software implementations of each primitive. It clearly *sh=
ould* be possible to make crypto API call into zinc for synchronous softwar=
e operations, but a demonstration of how this actually works and that there=
 isn=E2=80=99t some change to zinc to make it would well would be in order,=
 I think.
>
> IMO the right approach is do one conversion right away and save the rest =
for later.

Alright, I'll go ahead and do this for v4. Thanks for the guidance.

Jason
