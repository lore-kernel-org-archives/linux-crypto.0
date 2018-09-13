From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: [PATCH net-next v3 02/17] zinc: introduce minimal cryptography library
Date: Thu, 13 Sep 2018 08:26:05 -0700
Message-ID: <A8D740A3-99F2-4AE7-8EF1-177F6534130B@amacapital.net>
References: <20180911010838.8818-1-Jason@zx2c4.com> <20180911010838.8818-3-Jason@zx2c4.com> <CAKv+Gu9nSeo4PFVrtjtqGQ32eqyxUp3xVCczZfu+dhFz5yLM0A@mail.gmail.com> <CAHmME9rTEFLaYmzFrc719LW2DWS2Ua_vL6by1UXZ9uDvMpbhYw@mail.gmail.com> <CAKv+Gu9RGo9rtGsmwMLZ_=-WSQ_h7har4agXP-2XOKupq-KYtA@mail.gmail.com> <CALCETrU2qkLVaxC=cpU5iAeT5B7xGsR+m2ZWtLVK37jMMWtcAA@mail.gmail.com> <c5855aa4-1561-8387-aebb-0a7587ac6d4f@gmail.com>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain;
        charset=utf-8
Content-Transfer-Encoding: quoted-printable
Cc: Andy Lutomirski <luto@kernel.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Samuel Neves <sneves@dei.uc.pt>,
        Jean-Philippe Aumasson <jeanphilippe.aumasson@gmail.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Milan Broz <gmazyland@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <c5855aa4-1561-8387-aebb-0a7587ac6d4f@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org


> On Sep 12, 2018, at 11:39 PM, Milan Broz <gmazyland@gmail.com> wrote:
>=20
>> On 13/09/18 01:45, Andy Lutomirski wrote:
>> On Wed, Sep 12, 2018 at 3:56 PM, Ard Biesheuvel
> ...=20
>> b) Crypto that is used dynamically.  This includes dm-crypt
>> (aes-xts-plain64, aes-cbc-essiv, etc), all the ALG_IF interfaces, a
>> lot of IPSEC stuff, possibly KCM, and probably many more.  These will
>> get comparatively little benefit from being converted to a zinc-like
>> interface.  For some of these cases, it wouldn't make any sense at all
>> to convert them.  Certainly the ones that do async hardware crypto
>> using DMA engines will never look at all like zinc, even under the
>> hood.
>=20
> Please note, that dm-crypt now uses not only block ciphers and modes,
> but also authenticated encryption and hashes (for ESSIV and HMAC
> in authenticated composed modes) and RNG (for random IV).
> We use crypto API, including async variants (I hope correctly :)

Right. And all this is why I don=E2=80=99t think dm-crypt should use zinc, a=
t least not any time soon.
