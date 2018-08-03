From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: Re: [PATCH v1 2/3] zinc: Introduce minimal cryptography library
Date: Sat, 4 Aug 2018 00:10:01 +0200
Message-ID: <CAHmME9pt3PxKQmc8E-arA-W0p2tp9z_oJ-uXQwis3qD=Zvpnsg@mail.gmail.com>
References: <20180801072246.GA15677@sol.localdomain> <CALCETrXD_VyoyW5C1U34o-ySJ4nFcO6PQ+ZNBVYxCpJ-f65CHw@mail.gmail.com>
 <CAHmME9oThR-dE3gTW0UyqAGZO80qu19ktG4YTb4iL6CNpzNNaw@mail.gmail.com> <CALCETrVziUpAU4nTaZ=t5ct=1jsWswWOy7KDNxXGPD1L=tMTGQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Eric Biggers <ebiggers3@gmail.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Andrew Lutomirski <luto@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Samuel Neves <sneves@dei.uc.pt>,
        "Daniel J . Bernstein" <djb@cr.yp.to>,
        Tanja Lange <tanja@hyperelliptic.org>,
        Jean-Philippe Aumasson <jeanphilippe.aumasson@gmail.com>,
        Karthikeyan Bhargavan <karthik.bhargavan@gmail.com>
To: Andy Lutomirski <luto@amacapital.net>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <CALCETrVziUpAU4nTaZ=t5ct=1jsWswWOy7KDNxXGPD1L=tMTGQ@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Fri, Aug 3, 2018 at 11:29 PM Andy Lutomirski <luto@amacapital.net> wrote:
> Gotcha.  That was very hidden in the 24k lines.  Please make this (and
> any similar goodies) be their own patches.

I know, sorry, and I certainly will have this split out. The above
code snippet was from the much much shorter WireGuard patch (3/3), but
indeed the simd_get/put/relax code is in the monster patch here, so
that'll certainly be split for v2.

>
> Also, please consider spelling it differently:
>
> simd_context_t simd_context = simd_get();
>
> Because we'll feel very silly the first time some architecture has
> more than one possible state.  (It wouldn't be entirely insane for x86
> to distinguish between "no SIMD", "XMM only", and "go to town!", for
> example.)

That's a great idea. It'll also make it clearer that users shouldn't
just dump a raw "true" in there; raw bools are more tempting to abuse
like that.
