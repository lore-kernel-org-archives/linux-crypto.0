From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: Re: [PATCH] poly1305: generic C can be faster on chips with slow
 unaligned access
Date: Thu, 3 Nov 2016 08:24:57 +0100
Message-ID: <CAHmME9oL-pOWWXXFhJz1vSm5ftnSfmYrquGbH0acapgEL=c4Ew@mail.gmail.com>
References: <20161102175810.18647-1-Jason@zx2c4.com> <20161102200959.GA23297@gondor.apana.org.au>
 <CAHmME9ps=tLXvgP7DDzxLC58HxC7UjF35uPu6aVg6+zouPxEhQ@mail.gmail.com>
 <20161102210802.GA26741@gondor.apana.org.au> <CAHmME9rOM-tE=o_4yFd=N1Bw1ur-QKQ-Wp6pnaJ8d62_Eug9og@mail.gmail.com>
 <20161102212657.GA26887@gondor.apana.org.au> <CAHmME9ogYTGFaNDt1CD0FxEHxDzVhNX=AN3_PH3t=0zREGgYPA@mail.gmail.com>
 <20161103004934.GA30775@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Martin Willi <martin@strongswan.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20161103004934.GA30775@gondor.apana.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi Herbert,

On Thu, Nov 3, 2016 at 1:49 AM, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> FWIW I'd rather live with a 6% slowdown than having two different
> code paths in the generic code.  Anyone who cares about 6% would
> be much better off writing an assembly version of the code.

Please think twice before deciding that the generic C "is allowed to
be slow". It turns out to be used far more often than might be
obvious. For example, crypto is commonly done on the netdev layer --
like the case with mac80211-based drivers. At this layer, the FPU on
x86 isn't always available, depending on the path used. Some
combinations of drivers, packet family, and workload can result in the
generic C being used instead of the vectorized assembly for a massive
percentage of time. So, I think we do have a good motivation for
wanting the generic C to be as fast as possible.

In the particular case of poly1305, these are the only spots where
unaligned accesses take place, and they're rather small, and I think
it's pretty obvious what's happening in the two different cases of
code from a quick glance. This isn't the "two different paths case" in
which there's a significant future-facing maintenance burden.

Jason
