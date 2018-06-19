From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 3/3] hwrng: msm - Add support for prng v2
Date: Tue, 19 Jun 2018 22:28:53 +0800
Message-ID: <20180619142853.wgi5easw4zv6ttrb@gondor.apana.org.au>
References: <20180618141259.23141-1-vkoul@kernel.org>
 <20180618141259.23141-4-vkoul@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Matt Mackall <mpm@selenic.com>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-arm-msm@vger.kernel.org, Vinod Koul <vkoul@kernel.org>
To: Vinod Koul <vinod.koul@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180618141259.23141-4-vkoul@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Mon, Jun 18, 2018 at 07:42:59PM +0530, Vinod Koul wrote:
> Qcom 8996 and later chips support prng v2 where we need to only
> implement .read callback for hwrng.
> 
> Add a new table for v2 which supports this and get version required for
> driver data.
> 
> Signed-off-by: Vinod Koul <vkoul@kernel.org>

Is this really a pseudo-RNG? If so it needs to be moved over to
the algif_rng interface.

hwrng is for true hardware RNGs only, because it may be directly
fed into /dev/random.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
