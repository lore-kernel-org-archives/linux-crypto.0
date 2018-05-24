From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: Re: [PATCH 3/3] arm64: dts: renesas: r8a7795: add ccree binding
Date: Thu, 24 May 2018 16:20:33 +0300
Message-ID: <CAOtvUMdCSoxYjpyb+fD36EE5+4sV4CjrxwK94RQ7bNKE5rajmQ@mail.gmail.com>
References: <1526387370-17142-1-git-send-email-gilad@benyossef.com>
 <1526387370-17142-4-git-send-email-gilad@benyossef.com> <CAMuHMdWzeNqsho1V6ezZb81T3_HcRzrtuQpmGXsjtFgt9BtZDQ@mail.gmail.com>
 <20180516074333.i2672u435ymwffk3@verge.net.au> <CAOtvUMfFjokOLCg6aHNQESJ_q4Jiok3izrPtae5wR+cND=XL6g@mail.gmail.com>
 <CAMuHMdVM55S7+PdnKusX-qkTxioc=0kQ6EGSbwv+kbLk5RCUYw@mail.gmail.com>
 <CAOtvUMcf-fHduThORv3cbcN16wEm_Si27OjSjAmSc9g5eK4PJw@mail.gmail.com> <CAMuHMdX-t8WfjRKpZ7UxXBbBNojsn-8z7_BM9grmLJcf=9Ks2Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Simon Horman <horms@verge.net.au>,
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
        Ofir Drang <ofir.drang@arm.com>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS"
        <devicetree@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-clk <linux-clk@vger.kernel.org>,
        L
To: Geert Uytterhoeven <geert@linux-m68k.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAMuHMdX-t8WfjRKpZ7UxXBbBNojsn-8z7_BM9grmLJcf=9Ks2Q@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, May 22, 2018 at 10:48 AM, Geert Uytterhoeven
<geert@linux-m68k.org> wrote:
> Hi Gilad,
>
> On Mon, May 21, 2018 at 3:43 PM, Gilad Ben-Yossef <gilad@benyossef.com> wrote:
>> On Thu, May 17, 2018 at 1:16 PM, Geert Uytterhoeven
>> <geert@linux-m68k.org> wrote:
>>> Indeed. From a quick glance, it looks like drivers/crypto/ccree/cc_driver.c
>>> does not distinguish between the absence of the clock property, and an
>>> actual error in getting the clock, and never considers any error a failure
>>> (incl. -PROBE_DEFER).
>>>
>>> As of_clk_get() returns -ENOENT for both a missing clock property and a
>>> missing clock, you should use (devm_)clk_get() instead, and distinguish
>>> between NULL (no clock property) and IS_ERR() (actual failure -> abort).
>>
>> I was trying to do as you suggested but I didn't quite get what is the
>> dev_id (2nd) parameter to devm_clk_get parameter is supposed to be.
>
> It's the (optional) name of the clock, helpful in case there is more than one.
> In your case, NULL is fine.
>

I have assumed as much and tried it, it did not work and so I assumed
I am missing something and asked you.
It turns out I was missing the fact I was using the wrong device tree
file... :-(

So thanks, it works now :-)

Having said that, while using devm)clk_get() is a better approach, it
does not seems to distinguish
between no "clocks" and a failure to clock information - it returns
ENOENT in both cases as well.

Thanks,
Gilad


-- 
Gilad Ben-Yossef
Chief Coffee Drinker

"If you take a class in large-scale robotics, can you end up in a
situation where the homework eats your dog?"
 -- Jean-Baptiste Queru
