From: Vinod <vkoul@kernel.org>
Subject: Re: [PATCH 3/3] hwrng: msm - Add support for prng v2
Date: Wed, 20 Jun 2018 11:02:04 +0530
Message-ID: <20180620053204.GG13316@vkoul-mobl>
References: <20180618141259.23141-1-vkoul@kernel.org>
 <20180618141259.23141-4-vkoul@kernel.org>
 <20180619142853.wgi5easw4zv6ttrb@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Matt Mackall <mpm@selenic.com>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-arm-msm@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180619142853.wgi5easw4zv6ttrb@gondor.apana.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 19-06-18, 22:28, Herbert Xu wrote:
> On Mon, Jun 18, 2018 at 07:42:59PM +0530, Vinod Koul wrote:
> > Qcom 8996 and later chips support prng v2 where we need to only
> > implement .read callback for hwrng.
> > 
> > Add a new table for v2 which supports this and get version required for
> > driver data.
> > 
> > Signed-off-by: Vinod Koul <vkoul@kernel.org>
> 
> Is this really a pseudo-RNG? If so it needs to be moved over to
> the algif_rng interface.
> 
> hwrng is for true hardware RNGs only, because it may be directly
> fed into /dev/random.

I am trying to find how how much random output this hardware generates.

Meanwhile, can you please point out examples/Documentation for algif_rng
and if any test tools for this?

Thanks
-- 
~Vinod
