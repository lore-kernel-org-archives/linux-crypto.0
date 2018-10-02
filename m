From: Richard Weinberger <richard.weinberger@gmail.com>
Subject: Re: [PATCH net-next v6 00/23] WireGuard: Secure Network Tunnel
Date: Tue, 2 Oct 2018 08:43:25 +0200
Message-ID: <CAFLxGvz3tR4Fy95Zu+-gRfk19HDd_N54QLftisdJJewPWbL3xA@mail.gmail.com>
References: <CAKv+Gu-ZMR7zEAKv6_2tyD3OqnjVugOzKHzBEXW3pQs5W-SvLw@mail.gmail.com>
 <20181002033908.324yhwqaohfsq65d@gondor.apana.org.au> <CAHmME9piX1kbUhOBcUKVdecr45EjxuruxYuMTepfXVvRrkVmyg@mail.gmail.com>
 <CAKv+Gu8fr_qADiTJH05nVWF7Yi3U722nfKJsMaRE9CP3YjNBbg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Herbert Xu <herbert@gondor.apana.org.au>, ebiggers@kernel.org,
        LKML <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org,
        linux-crypto@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Greg KH <gregkh@linuxfoundation.org>
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAKv+Gu8fr_qADiTJH05nVWF7Yi3U722nfKJsMaRE9CP3YjNBbg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, Oct 2, 2018 at 8:04 AM Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:
>
> On 2 October 2018 at 05:45, Jason A. Donenfeld <Jason@zx2c4.com> wrote:
> > Hi Herbert,
> >
> > On Tue, Oct 2, 2018 at 5:39 AM Herbert Xu <herbert@gondor.apana.org.au> wrote:
> >> > I would also strongly prefer that all crypto work is taken through
> >> > Herbert's tree, so we have a coherent view of it before it goes
> >> > upstream.
> >>
> >> I agree.  I don't have any problems with the zinc code living in
> >> its own git tree.  But any upstream merges should definitely go
> >> through the crypto tree because the inherent ties between the two
> >> code-base.
> >
> > I can send you pull requests then if there are development cycles when
> > there are in fact relations between the two trees. I'll update the
> > commit message describing Zinc to include this.
> >
>
> Can you explain why you it is so important to you that your changes
> remain outside the crypto tree?
>
> Also, I still think the name Zinc (zinc is not crypto/) is needlessly
> divisive and condescending, and unsaying it (in v2 and up) doesn't
> really work on the Internet (especially since you are still repeating
> it in your conference talk.)

I've been following the drama^Wdiscussion on the zinc for a long time now
and I also think that "zinc" is a misleading name.
Jason, you seem to hate the existing crypto framework with passion,
and the name reflects that.
Since we all agree that the framework can do better and your patches actually
make it better, please just rename it to something that reflects what
it is, a base
framework. I think Ard already suggested "crypto/base/" or "crypto/core/".

-- 
Thanks,
//richard
