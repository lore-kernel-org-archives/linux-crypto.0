From: Vinod <vkoul@kernel.org>
Subject: Re: [PATCH 3/3] hwrng: msm - Add support for prng v2
Date: Thu, 21 Jun 2018 09:47:51 +0530
Message-ID: <20180621041751.GC27187@vkoul-mobl>
References: <20180618141259.23141-1-vkoul@kernel.org>
 <20180618141259.23141-4-vkoul@kernel.org>
 <20180619142853.wgi5easw4zv6ttrb@gondor.apana.org.au>
 <20180620053204.GG13316@vkoul-mobl>
 <CANc+2y5-7S_1bvMYs54X3MqCkcsha3iNe1BGa-pG=_xH5xYn1Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE"
        <linux-crypto@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Matt Mackall <mpm@selenic.com>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-arm-msm@vger.kernel.org
To: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CANc+2y5-7S_1bvMYs54X3MqCkcsha3iNe1BGa-pG=_xH5xYn1Q@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi PrasannaKumar,

On 20-06-18, 23:15, PrasannaKumar Muralidharan wrote:
> Hi Vinod,
> 
> On 20 June 2018 at 11:02, Vinod <vkoul@kernel.org> wrote:
> > On 19-06-18, 22:28, Herbert Xu wrote:
> >> On Mon, Jun 18, 2018 at 07:42:59PM +0530, Vinod Koul wrote:
> >> > Qcom 8996 and later chips support prng v2 where we need to only
> >> > implement .read callback for hwrng.
> >> >
> >> > Add a new table for v2 which supports this and get version required for
> >> > driver data.
> >> >
> >> > Signed-off-by: Vinod Koul <vkoul@kernel.org>
> >>
> >> Is this really a pseudo-RNG? If so it needs to be moved over to
> >> the algif_rng interface.
> >>
> >> hwrng is for true hardware RNGs only, because it may be directly
> >> fed into /dev/random.
> >
> > I am trying to find how how much random output this hardware generates.
> >
> > Meanwhile, can you please point out examples/Documentation for algif_rng
> > and if any test tools for this?
> 
> As Herbert suggested exynos rng is a good example. It was wrongly
> using hwrng framework then switched to using crypto framework.
> 
> I have a patch for msm rng using crypto framework, only compile tested
> though. You can find the patch at
> https://pastebin.ubuntu.com/p/44r6BJgBkN/. I am having a hard time
> sending patches via git send-email form a gmail account so I have put
> it in pastebin. Feel free to use it if that is useful.

Ah, I already started based on msm downstream implementation (they had
one using crypto APIs too). Ideally you should have posted it and tested
it.

Thanks
-- 
~Vinod
