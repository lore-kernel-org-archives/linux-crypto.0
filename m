From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: Re: [PATCH v2 0/5] crypto: ccree: cleanup, fixes and R-Car enabling
Date: Thu, 21 Jun 2018 08:00:57 +0300
Message-ID: <CAOtvUMfgUFT3+8kwVpACU6tXBX1TrzB-1uiHg7X=KXN-Utv0mg@mail.gmail.com>
References: <1527171551-21979-1-git-send-email-gilad@benyossef.com>
 <CAMuHMdVXrppnFEBmR3xhwNu3i0N3mVE1+FJRjEcWBYpHHbsAsw@mail.gmail.com>
 <CAOtvUMc8D9DQFC6vZ+GnaVBg5uFVrQmOrnSQKz7ZPHGh4BCsZg@mail.gmail.com> <20180620085145.7bxfbu7bi45sftnk@verge.net.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
        Magnus Damm <magnus.damm@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Michael Turquette <mturquette@baylibre.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS"
        <devicetree@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        linux-clk <linux-clk@vger.kernel.org>,
        Linux ARM <linux-arm-kerne
To: Simon Horman <horms@verge.net.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180620085145.7bxfbu7bi45sftnk@verge.net.au>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wed, Jun 20, 2018 at 11:51 AM, Simon Horman <horms@verge.net.au> wrote:
> On Tue, Jun 19, 2018 at 04:57:15PM +0300, Gilad Ben-Yossef wrote:
>> On Tue, Jun 19, 2018 at 3:58 PM, Geert Uytterhoeven
>> <geert@linux-m68k.org> wrote:
>> > Hi Gilad,
>> >
>> > On Thu, May 24, 2018 at 4:19 PM Gilad Ben-Yossef <gilad@benyossef.com>=
 wrote:
>> >> The patch set enables the use of CryptoCell found in some Renesas R-C=
ar
>> >> Salvator-X boards and fixes some driver issues uncovered that prevent=
ed
>> >> to work properly.
>> >
>> > With DEBUG enabled on R-Car H3, I see lots of
>> >
>> >     ccree e6601000.crypto: IRR includes unknown cause bits (0x00000098=
)
>> >     ccree e6601000.crypto: IRR includes unknown cause bits (0x000000C0=
)
>> >     ccree e6601000.crypto: IRR includes unknown cause bits (0x000000D0=
)
>> >     ccree e6601000.crypto: IRR includes unknown cause bits (0x000000D8=
)
>> >     ccree e6601000.crypto: IRR includes unknown cause bits (0x000000E0=
)
>> >     ccree e6601000.crypto: IRR includes unknown cause bits (0x000000F0=
)
>> >     ccree e6601000.crypto: IRR includes unknown cause bits (0x000000F8=
)
>> >
>> > during boot. Is that expected?
>>
>> Yes. The condition itself it is reporting is not necessarily bad. It
>> means that driver
>> did not act on certain HW notification during interrupts and that's
>> OK, we don't act on all of them
>> depending on configuration - e.g. if you have CONFIG_FIPS enabled and
>> an active TEE module or not.
>>
>> I can rate_limit the message if it bothers you but other than that it
>> is a harmless debug print.
>
> Rate limiting sounds like an excellent idea to me.

Will do.

Thanks!
Gilad



--=20
Gilad Ben-Yossef
Chief Coffee Drinker

values of =CE=B2 will give rise to dom!
